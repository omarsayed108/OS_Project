
obj/user/ef_tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 d5 03 00 00       	call   80040b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the shared variables, initialize them and run slaves
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec ac 00 00 00    	sub    $0xac,%esp
//#else
//	panic("make sure to enable the kernel heap: USE_KHEAP=1");
//#endif
//	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800044:	c7 45 e4 00 10 00 82 	movl   $0x82001000,-0x1c(%ebp)
	uint32 *x, *y, *z ;
	int diff, expected;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  80004b:	e8 65 25 00 00       	call   8025b5 <sys_calculate_free_frames>
  800050:	89 45 e0             	mov    %eax,-0x20(%ebp)
	x = smalloc("x", 4, 0);
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	6a 00                	push   $0x0
  800058:	6a 04                	push   $0x4
  80005a:	68 a0 3a 80 00       	push   $0x803aa0
  80005f:	e8 30 21 00 00       	call   802194 <smalloc>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)pagealloc_start) {panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  80006a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80006d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  800070:	74 14                	je     800086 <_main+0x4e>
  800072:	83 ec 04             	sub    $0x4,%esp
  800075:	68 a4 3a 80 00       	push   $0x803aa4
  80007a:	6a 1a                	push   $0x1a
  80007c:	68 07 3b 80 00       	push   $0x803b07
  800081:	e8 35 05 00 00       	call   8005bb <_panic>
	expected = 1+1 ; /*1page +1table*/
  800086:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  80008d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800090:	e8 20 25 00 00       	call   8025b5 <sys_calculate_free_frames>
  800095:	29 c3                	sub    %eax,%ebx
  800097:	89 d8                	mov    %ebx,%eax
  800099:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  80009c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80009f:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8000a2:	7c 0b                	jl     8000af <_main+0x77>
  8000a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000a7:	83 c0 02             	add    $0x2,%eax
  8000aa:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8000ad:	7d 24                	jge    8000d3 <_main+0x9b>
  8000af:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8000b2:	e8 fe 24 00 00       	call   8025b5 <sys_calculate_free_frames>
  8000b7:	29 c3                	sub    %eax,%ebx
  8000b9:	89 d8                	mov    %ebx,%eax
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	ff 75 d8             	pushl  -0x28(%ebp)
  8000c1:	50                   	push   %eax
  8000c2:	68 28 3b 80 00       	push   $0x803b28
  8000c7:	6a 1d                	push   $0x1d
  8000c9:	68 07 3b 80 00       	push   $0x803b07
  8000ce:	e8 e8 04 00 00       	call   8005bb <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  8000d3:	e8 dd 24 00 00       	call   8025b5 <sys_calculate_free_frames>
  8000d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	y = smalloc("y", 4, 0);
  8000db:	83 ec 04             	sub    $0x4,%esp
  8000de:	6a 00                	push   $0x0
  8000e0:	6a 04                	push   $0x4
  8000e2:	68 c0 3b 80 00       	push   $0x803bc0
  8000e7:	e8 a8 20 00 00       	call   802194 <smalloc>
  8000ec:	83 c4 10             	add    $0x10,%esp
  8000ef:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (y != (uint32*)(pagealloc_start + 1 * PAGE_SIZE)) {panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  8000f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f5:	05 00 10 00 00       	add    $0x1000,%eax
  8000fa:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8000fd:	74 14                	je     800113 <_main+0xdb>
  8000ff:	83 ec 04             	sub    $0x4,%esp
  800102:	68 a4 3a 80 00       	push   $0x803aa4
  800107:	6a 22                	push   $0x22
  800109:	68 07 3b 80 00       	push   $0x803b07
  80010e:	e8 a8 04 00 00       	call   8005bb <_panic>
	expected = 1 ; /*1page*/
  800113:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  80011a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80011d:	e8 93 24 00 00       	call   8025b5 <sys_calculate_free_frames>
  800122:	29 c3                	sub    %eax,%ebx
  800124:	89 d8                	mov    %ebx,%eax
  800126:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800129:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80012c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80012f:	7c 0b                	jl     80013c <_main+0x104>
  800131:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800134:	83 c0 02             	add    $0x2,%eax
  800137:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80013a:	7d 24                	jge    800160 <_main+0x128>
  80013c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80013f:	e8 71 24 00 00       	call   8025b5 <sys_calculate_free_frames>
  800144:	29 c3                	sub    %eax,%ebx
  800146:	89 d8                	mov    %ebx,%eax
  800148:	83 ec 0c             	sub    $0xc,%esp
  80014b:	ff 75 d8             	pushl  -0x28(%ebp)
  80014e:	50                   	push   %eax
  80014f:	68 28 3b 80 00       	push   $0x803b28
  800154:	6a 25                	push   $0x25
  800156:	68 07 3b 80 00       	push   $0x803b07
  80015b:	e8 5b 04 00 00       	call   8005bb <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  800160:	e8 50 24 00 00       	call   8025b5 <sys_calculate_free_frames>
  800165:	89 45 e0             	mov    %eax,-0x20(%ebp)
	z = smalloc("z", 4, 1);
  800168:	83 ec 04             	sub    $0x4,%esp
  80016b:	6a 01                	push   $0x1
  80016d:	6a 04                	push   $0x4
  80016f:	68 c2 3b 80 00       	push   $0x803bc2
  800174:	e8 1b 20 00 00       	call   802194 <smalloc>
  800179:	83 c4 10             	add    $0x10,%esp
  80017c:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (z != (uint32*)(pagealloc_start + 2 * PAGE_SIZE)) {panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  80017f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800182:	05 00 20 00 00       	add    $0x2000,%eax
  800187:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80018a:	74 14                	je     8001a0 <_main+0x168>
  80018c:	83 ec 04             	sub    $0x4,%esp
  80018f:	68 a4 3a 80 00       	push   $0x803aa4
  800194:	6a 2a                	push   $0x2a
  800196:	68 07 3b 80 00       	push   $0x803b07
  80019b:	e8 1b 04 00 00       	call   8005bb <_panic>
	expected = 1 ; /*1page*/
  8001a0:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8001a7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8001aa:	e8 06 24 00 00       	call   8025b5 <sys_calculate_free_frames>
  8001af:	29 c3                	sub    %eax,%ebx
  8001b1:	89 d8                	mov    %ebx,%eax
  8001b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8001b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001b9:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8001bc:	7c 0b                	jl     8001c9 <_main+0x191>
  8001be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001c1:	83 c0 02             	add    $0x2,%eax
  8001c4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8001c7:	7d 24                	jge    8001ed <_main+0x1b5>
  8001c9:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8001cc:	e8 e4 23 00 00       	call   8025b5 <sys_calculate_free_frames>
  8001d1:	29 c3                	sub    %eax,%ebx
  8001d3:	89 d8                	mov    %ebx,%eax
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	ff 75 d8             	pushl  -0x28(%ebp)
  8001db:	50                   	push   %eax
  8001dc:	68 28 3b 80 00       	push   $0x803b28
  8001e1:	6a 2d                	push   $0x2d
  8001e3:	68 07 3b 80 00       	push   $0x803b07
  8001e8:	e8 ce 03 00 00       	call   8005bb <_panic>

	*x = 10 ;
  8001ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001f0:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  8001f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001f9:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8001ff:	a1 20 50 80 00       	mov    0x805020,%eax
  800204:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  80020a:	89 c2                	mov    %eax,%edx
  80020c:	a1 20 50 80 00       	mov    0x805020,%eax
  800211:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800217:	6a 32                	push   $0x32
  800219:	52                   	push   %edx
  80021a:	50                   	push   %eax
  80021b:	68 c4 3b 80 00       	push   $0x803bc4
  800220:	e8 eb 24 00 00       	call   802710 <sys_create_env>
  800225:	83 c4 10             	add    $0x10,%esp
  800228:	89 45 c8             	mov    %eax,-0x38(%ebp)
	id2 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80022b:	a1 20 50 80 00       	mov    0x805020,%eax
  800230:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  800236:	89 c2                	mov    %eax,%edx
  800238:	a1 20 50 80 00       	mov    0x805020,%eax
  80023d:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800243:	6a 32                	push   $0x32
  800245:	52                   	push   %edx
  800246:	50                   	push   %eax
  800247:	68 c4 3b 80 00       	push   $0x803bc4
  80024c:	e8 bf 24 00 00       	call   802710 <sys_create_env>
  800251:	83 c4 10             	add    $0x10,%esp
  800254:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	id3 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800257:	a1 20 50 80 00       	mov    0x805020,%eax
  80025c:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  800262:	89 c2                	mov    %eax,%edx
  800264:	a1 20 50 80 00       	mov    0x805020,%eax
  800269:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80026f:	6a 32                	push   $0x32
  800271:	52                   	push   %edx
  800272:	50                   	push   %eax
  800273:	68 c4 3b 80 00       	push   $0x803bc4
  800278:	e8 93 24 00 00       	call   802710 <sys_create_env>
  80027d:	83 c4 10             	add    $0x10,%esp
  800280:	89 45 c0             	mov    %eax,-0x40(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800283:	e8 d4 25 00 00       	call   80285c <rsttst>

	int* finish_children = smalloc("finish_children", sizeof(int), 1);
  800288:	83 ec 04             	sub    $0x4,%esp
  80028b:	6a 01                	push   $0x1
  80028d:	6a 04                	push   $0x4
  80028f:	68 d2 3b 80 00       	push   $0x803bd2
  800294:	e8 fb 1e 00 00       	call   802194 <smalloc>
  800299:	83 c4 10             	add    $0x10,%esp
  80029c:	89 45 bc             	mov    %eax,-0x44(%ebp)

	sys_run_env(id1);
  80029f:	83 ec 0c             	sub    $0xc,%esp
  8002a2:	ff 75 c8             	pushl  -0x38(%ebp)
  8002a5:	e8 84 24 00 00       	call   80272e <sys_run_env>
  8002aa:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	ff 75 c4             	pushl  -0x3c(%ebp)
  8002b3:	e8 76 24 00 00       	call   80272e <sys_run_env>
  8002b8:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	ff 75 c0             	pushl  -0x40(%ebp)
  8002c1:	e8 68 24 00 00       	call   80272e <sys_run_env>
  8002c6:	83 c4 10             	add    $0x10,%esp

	env_sleep(15000) ;
  8002c9:	83 ec 0c             	sub    $0xc,%esp
  8002cc:	68 98 3a 00 00       	push   $0x3a98
  8002d1:	e8 8c 34 00 00       	call   803762 <env_sleep>
  8002d6:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	while (gettst()!=3) ; //panic("test failed");
  8002d9:	90                   	nop
  8002da:	e8 f7 25 00 00       	call   8028d6 <gettst>
  8002df:	83 f8 03             	cmp    $0x3,%eax
  8002e2:	75 f6                	jne    8002da <_main+0x2a2>


	if (*z != 30)
  8002e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002e7:	8b 00                	mov    (%eax),%eax
  8002e9:	83 f8 1e             	cmp    $0x1e,%eax
  8002ec:	74 14                	je     800302 <_main+0x2ca>
		panic("Error!! Please check the creation (or the getting) of shared 2variables!!\n\n\n");
  8002ee:	83 ec 04             	sub    $0x4,%esp
  8002f1:	68 e4 3b 80 00       	push   $0x803be4
  8002f6:	6a 47                	push   $0x47
  8002f8:	68 07 3b 80 00       	push   $0x803b07
  8002fd:	e8 b9 02 00 00       	call   8005bb <_panic>
	else
		cprintf("test sharing 2 [Create & Get] is finished. Now, it'll destroy its children...\n\n");
  800302:	83 ec 0c             	sub    $0xc,%esp
  800305:	68 34 3c 80 00       	push   $0x803c34
  80030a:	e8 9a 05 00 00       	call   8008a9 <cprintf>
  80030f:	83 c4 10             	add    $0x10,%esp


	if (sys_getparentenvid() > 0) {
  800312:	e8 80 24 00 00       	call   802797 <sys_getparentenvid>
  800317:	85 c0                	test   %eax,%eax
  800319:	0f 8e e3 00 00 00    	jle    800402 <_main+0x3ca>
		//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
		//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
		//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
		//	2. changing the # free frames

		char changeIntCmd[100] = "__changeInterruptStatus__";
  80031f:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800325:	bb 3a 3d 80 00       	mov    $0x803d3a,%ebx
  80032a:	ba 1a 00 00 00       	mov    $0x1a,%edx
  80032f:	89 c7                	mov    %eax,%edi
  800331:	89 de                	mov    %ebx,%esi
  800333:	89 d1                	mov    %edx,%ecx
  800335:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800337:	8d 95 6e ff ff ff    	lea    -0x92(%ebp),%edx
  80033d:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  800342:	b0 00                	mov    $0x0,%al
  800344:	89 d7                	mov    %edx,%edi
  800346:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(changeIntCmd, 0);
  800348:	83 ec 08             	sub    $0x8,%esp
  80034b:	6a 00                	push   $0x0
  80034d:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800353:	50                   	push   %eax
  800354:	e8 5b 26 00 00       	call   8029b4 <sys_utilities>
  800359:	83 c4 10             	add    $0x10,%esp
		{
			sys_destroy_env(id1);
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	ff 75 c8             	pushl  -0x38(%ebp)
  800362:	e8 e3 23 00 00       	call   80274a <sys_destroy_env>
  800367:	83 c4 10             	add    $0x10,%esp
			cprintf("[1] *****************************>>>>>>>>>>>>>>>>>>>>>\n");
  80036a:	83 ec 0c             	sub    $0xc,%esp
  80036d:	68 84 3c 80 00       	push   $0x803c84
  800372:	e8 32 05 00 00       	call   8008a9 <cprintf>
  800377:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(id2);
  80037a:	83 ec 0c             	sub    $0xc,%esp
  80037d:	ff 75 c4             	pushl  -0x3c(%ebp)
  800380:	e8 c5 23 00 00       	call   80274a <sys_destroy_env>
  800385:	83 c4 10             	add    $0x10,%esp
			cprintf("[2] *****************************>>>>>>>>>>>>>>>>>>>>>\n");
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	68 bc 3c 80 00       	push   $0x803cbc
  800390:	e8 14 05 00 00       	call   8008a9 <cprintf>
  800395:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(id3);
  800398:	83 ec 0c             	sub    $0xc,%esp
  80039b:	ff 75 c0             	pushl  -0x40(%ebp)
  80039e:	e8 a7 23 00 00       	call   80274a <sys_destroy_env>
  8003a3:	83 c4 10             	add    $0x10,%esp
			cprintf("[3] *****************************>>>>>>>>>>>>>>>>>>>>>\n");
  8003a6:	83 ec 0c             	sub    $0xc,%esp
  8003a9:	68 f4 3c 80 00       	push   $0x803cf4
  8003ae:	e8 f6 04 00 00       	call   8008a9 <cprintf>
  8003b3:	83 c4 10             	add    $0x10,%esp
		}
		sys_utilities(changeIntCmd, 1);
  8003b6:	83 ec 08             	sub    $0x8,%esp
  8003b9:	6a 01                	push   $0x1
  8003bb:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  8003c1:	50                   	push   %eax
  8003c2:	e8 ed 25 00 00       	call   8029b4 <sys_utilities>
  8003c7:	83 c4 10             	add    $0x10,%esp

		int *finishedCount = NULL;
  8003ca:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  8003d1:	e8 c1 23 00 00       	call   802797 <sys_getparentenvid>
  8003d6:	83 ec 08             	sub    $0x8,%esp
  8003d9:	68 2c 3d 80 00       	push   $0x803d2c
  8003de:	50                   	push   %eax
  8003df:	e8 10 1f 00 00       	call   8022f4 <sget>
  8003e4:	83 c4 10             	add    $0x10,%esp
  8003e7:	89 45 b8             	mov    %eax,-0x48(%ebp)
		sys_lock_cons();
  8003ea:	e8 16 21 00 00       	call   802505 <sys_lock_cons>
		{
			(*finishedCount)++ ;
  8003ef:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8003f2:	8b 00                	mov    (%eax),%eax
  8003f4:	8d 50 01             	lea    0x1(%eax),%edx
  8003f7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8003fa:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  8003fc:	e8 1e 21 00 00       	call   80251f <sys_unlock_cons>
	}
	return;
  800401:	90                   	nop
  800402:	90                   	nop
}
  800403:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800406:	5b                   	pop    %ebx
  800407:	5e                   	pop    %esi
  800408:	5f                   	pop    %edi
  800409:	5d                   	pop    %ebp
  80040a:	c3                   	ret    

0080040b <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80040b:	55                   	push   %ebp
  80040c:	89 e5                	mov    %esp,%ebp
  80040e:	57                   	push   %edi
  80040f:	56                   	push   %esi
  800410:	53                   	push   %ebx
  800411:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800414:	e8 65 23 00 00       	call   80277e <sys_getenvindex>
  800419:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80041c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80041f:	89 d0                	mov    %edx,%eax
  800421:	01 c0                	add    %eax,%eax
  800423:	01 d0                	add    %edx,%eax
  800425:	c1 e0 02             	shl    $0x2,%eax
  800428:	01 d0                	add    %edx,%eax
  80042a:	c1 e0 02             	shl    $0x2,%eax
  80042d:	01 d0                	add    %edx,%eax
  80042f:	c1 e0 03             	shl    $0x3,%eax
  800432:	01 d0                	add    %edx,%eax
  800434:	c1 e0 02             	shl    $0x2,%eax
  800437:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80043c:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800441:	a1 20 50 80 00       	mov    0x805020,%eax
  800446:	8a 40 20             	mov    0x20(%eax),%al
  800449:	84 c0                	test   %al,%al
  80044b:	74 0d                	je     80045a <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80044d:	a1 20 50 80 00       	mov    0x805020,%eax
  800452:	83 c0 20             	add    $0x20,%eax
  800455:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80045a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80045e:	7e 0a                	jle    80046a <libmain+0x5f>
		binaryname = argv[0];
  800460:	8b 45 0c             	mov    0xc(%ebp),%eax
  800463:	8b 00                	mov    (%eax),%eax
  800465:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  80046a:	83 ec 08             	sub    $0x8,%esp
  80046d:	ff 75 0c             	pushl  0xc(%ebp)
  800470:	ff 75 08             	pushl  0x8(%ebp)
  800473:	e8 c0 fb ff ff       	call   800038 <_main>
  800478:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80047b:	a1 00 50 80 00       	mov    0x805000,%eax
  800480:	85 c0                	test   %eax,%eax
  800482:	0f 84 01 01 00 00    	je     800589 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800488:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80048e:	bb 98 3e 80 00       	mov    $0x803e98,%ebx
  800493:	ba 0e 00 00 00       	mov    $0xe,%edx
  800498:	89 c7                	mov    %eax,%edi
  80049a:	89 de                	mov    %ebx,%esi
  80049c:	89 d1                	mov    %edx,%ecx
  80049e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8004a0:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8004a3:	b9 56 00 00 00       	mov    $0x56,%ecx
  8004a8:	b0 00                	mov    $0x0,%al
  8004aa:	89 d7                	mov    %edx,%edi
  8004ac:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8004ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8004b5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004b8:	83 ec 08             	sub    $0x8,%esp
  8004bb:	50                   	push   %eax
  8004bc:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8004c2:	50                   	push   %eax
  8004c3:	e8 ec 24 00 00       	call   8029b4 <sys_utilities>
  8004c8:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8004cb:	e8 35 20 00 00       	call   802505 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8004d0:	83 ec 0c             	sub    $0xc,%esp
  8004d3:	68 b8 3d 80 00       	push   $0x803db8
  8004d8:	e8 cc 03 00 00       	call   8008a9 <cprintf>
  8004dd:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8004e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e3:	85 c0                	test   %eax,%eax
  8004e5:	74 18                	je     8004ff <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8004e7:	e8 e6 24 00 00       	call   8029d2 <sys_get_optimal_num_faults>
  8004ec:	83 ec 08             	sub    $0x8,%esp
  8004ef:	50                   	push   %eax
  8004f0:	68 e0 3d 80 00       	push   $0x803de0
  8004f5:	e8 af 03 00 00       	call   8008a9 <cprintf>
  8004fa:	83 c4 10             	add    $0x10,%esp
  8004fd:	eb 59                	jmp    800558 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004ff:	a1 20 50 80 00       	mov    0x805020,%eax
  800504:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  80050a:	a1 20 50 80 00       	mov    0x805020,%eax
  80050f:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800515:	83 ec 04             	sub    $0x4,%esp
  800518:	52                   	push   %edx
  800519:	50                   	push   %eax
  80051a:	68 04 3e 80 00       	push   $0x803e04
  80051f:	e8 85 03 00 00       	call   8008a9 <cprintf>
  800524:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800527:	a1 20 50 80 00       	mov    0x805020,%eax
  80052c:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800532:	a1 20 50 80 00       	mov    0x805020,%eax
  800537:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  80053d:	a1 20 50 80 00       	mov    0x805020,%eax
  800542:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800548:	51                   	push   %ecx
  800549:	52                   	push   %edx
  80054a:	50                   	push   %eax
  80054b:	68 2c 3e 80 00       	push   $0x803e2c
  800550:	e8 54 03 00 00       	call   8008a9 <cprintf>
  800555:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800558:	a1 20 50 80 00       	mov    0x805020,%eax
  80055d:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800563:	83 ec 08             	sub    $0x8,%esp
  800566:	50                   	push   %eax
  800567:	68 84 3e 80 00       	push   $0x803e84
  80056c:	e8 38 03 00 00       	call   8008a9 <cprintf>
  800571:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800574:	83 ec 0c             	sub    $0xc,%esp
  800577:	68 b8 3d 80 00       	push   $0x803db8
  80057c:	e8 28 03 00 00       	call   8008a9 <cprintf>
  800581:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800584:	e8 96 1f 00 00       	call   80251f <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800589:	e8 1f 00 00 00       	call   8005ad <exit>
}
  80058e:	90                   	nop
  80058f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800592:	5b                   	pop    %ebx
  800593:	5e                   	pop    %esi
  800594:	5f                   	pop    %edi
  800595:	5d                   	pop    %ebp
  800596:	c3                   	ret    

00800597 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800597:	55                   	push   %ebp
  800598:	89 e5                	mov    %esp,%ebp
  80059a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80059d:	83 ec 0c             	sub    $0xc,%esp
  8005a0:	6a 00                	push   $0x0
  8005a2:	e8 a3 21 00 00       	call   80274a <sys_destroy_env>
  8005a7:	83 c4 10             	add    $0x10,%esp
}
  8005aa:	90                   	nop
  8005ab:	c9                   	leave  
  8005ac:	c3                   	ret    

008005ad <exit>:

void
exit(void)
{
  8005ad:	55                   	push   %ebp
  8005ae:	89 e5                	mov    %esp,%ebp
  8005b0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005b3:	e8 f8 21 00 00       	call   8027b0 <sys_exit_env>
}
  8005b8:	90                   	nop
  8005b9:	c9                   	leave  
  8005ba:	c3                   	ret    

008005bb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8005bb:	55                   	push   %ebp
  8005bc:	89 e5                	mov    %esp,%ebp
  8005be:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8005c1:	8d 45 10             	lea    0x10(%ebp),%eax
  8005c4:	83 c0 04             	add    $0x4,%eax
  8005c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8005ca:	a1 18 d1 81 00       	mov    0x81d118,%eax
  8005cf:	85 c0                	test   %eax,%eax
  8005d1:	74 16                	je     8005e9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8005d3:	a1 18 d1 81 00       	mov    0x81d118,%eax
  8005d8:	83 ec 08             	sub    $0x8,%esp
  8005db:	50                   	push   %eax
  8005dc:	68 fc 3e 80 00       	push   $0x803efc
  8005e1:	e8 c3 02 00 00       	call   8008a9 <cprintf>
  8005e6:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8005e9:	a1 04 50 80 00       	mov    0x805004,%eax
  8005ee:	83 ec 0c             	sub    $0xc,%esp
  8005f1:	ff 75 0c             	pushl  0xc(%ebp)
  8005f4:	ff 75 08             	pushl  0x8(%ebp)
  8005f7:	50                   	push   %eax
  8005f8:	68 04 3f 80 00       	push   $0x803f04
  8005fd:	6a 74                	push   $0x74
  8005ff:	e8 d2 02 00 00       	call   8008d6 <cprintf_colored>
  800604:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800607:	8b 45 10             	mov    0x10(%ebp),%eax
  80060a:	83 ec 08             	sub    $0x8,%esp
  80060d:	ff 75 f4             	pushl  -0xc(%ebp)
  800610:	50                   	push   %eax
  800611:	e8 24 02 00 00       	call   80083a <vcprintf>
  800616:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800619:	83 ec 08             	sub    $0x8,%esp
  80061c:	6a 00                	push   $0x0
  80061e:	68 2c 3f 80 00       	push   $0x803f2c
  800623:	e8 12 02 00 00       	call   80083a <vcprintf>
  800628:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80062b:	e8 7d ff ff ff       	call   8005ad <exit>

	// should not return here
	while (1) ;
  800630:	eb fe                	jmp    800630 <_panic+0x75>

00800632 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800632:	55                   	push   %ebp
  800633:	89 e5                	mov    %esp,%ebp
  800635:	53                   	push   %ebx
  800636:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800639:	a1 20 50 80 00       	mov    0x805020,%eax
  80063e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800644:	8b 45 0c             	mov    0xc(%ebp),%eax
  800647:	39 c2                	cmp    %eax,%edx
  800649:	74 14                	je     80065f <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80064b:	83 ec 04             	sub    $0x4,%esp
  80064e:	68 30 3f 80 00       	push   $0x803f30
  800653:	6a 26                	push   $0x26
  800655:	68 7c 3f 80 00       	push   $0x803f7c
  80065a:	e8 5c ff ff ff       	call   8005bb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80065f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800666:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80066d:	e9 d9 00 00 00       	jmp    80074b <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800672:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800675:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80067c:	8b 45 08             	mov    0x8(%ebp),%eax
  80067f:	01 d0                	add    %edx,%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	85 c0                	test   %eax,%eax
  800685:	75 08                	jne    80068f <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  800687:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80068a:	e9 b9 00 00 00       	jmp    800748 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  80068f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800696:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80069d:	eb 79                	jmp    800718 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80069f:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a4:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8006aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006ad:	89 d0                	mov    %edx,%eax
  8006af:	01 c0                	add    %eax,%eax
  8006b1:	01 d0                	add    %edx,%eax
  8006b3:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8006ba:	01 d8                	add    %ebx,%eax
  8006bc:	01 d0                	add    %edx,%eax
  8006be:	01 c8                	add    %ecx,%eax
  8006c0:	8a 40 04             	mov    0x4(%eax),%al
  8006c3:	84 c0                	test   %al,%al
  8006c5:	75 4e                	jne    800715 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006c7:	a1 20 50 80 00       	mov    0x805020,%eax
  8006cc:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8006d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006d5:	89 d0                	mov    %edx,%eax
  8006d7:	01 c0                	add    %eax,%eax
  8006d9:	01 d0                	add    %edx,%eax
  8006db:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8006e2:	01 d8                	add    %ebx,%eax
  8006e4:	01 d0                	add    %edx,%eax
  8006e6:	01 c8                	add    %ecx,%eax
  8006e8:	8b 00                	mov    (%eax),%eax
  8006ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006f5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8006f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006fa:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	01 c8                	add    %ecx,%eax
  800706:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800708:	39 c2                	cmp    %eax,%edx
  80070a:	75 09                	jne    800715 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  80070c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800713:	eb 19                	jmp    80072e <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800715:	ff 45 e8             	incl   -0x18(%ebp)
  800718:	a1 20 50 80 00       	mov    0x805020,%eax
  80071d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800723:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800726:	39 c2                	cmp    %eax,%edx
  800728:	0f 87 71 ff ff ff    	ja     80069f <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80072e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800732:	75 14                	jne    800748 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800734:	83 ec 04             	sub    $0x4,%esp
  800737:	68 88 3f 80 00       	push   $0x803f88
  80073c:	6a 3a                	push   $0x3a
  80073e:	68 7c 3f 80 00       	push   $0x803f7c
  800743:	e8 73 fe ff ff       	call   8005bb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800748:	ff 45 f0             	incl   -0x10(%ebp)
  80074b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80074e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800751:	0f 8c 1b ff ff ff    	jl     800672 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800757:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80075e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800765:	eb 2e                	jmp    800795 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800767:	a1 20 50 80 00       	mov    0x805020,%eax
  80076c:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800772:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800775:	89 d0                	mov    %edx,%eax
  800777:	01 c0                	add    %eax,%eax
  800779:	01 d0                	add    %edx,%eax
  80077b:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800782:	01 d8                	add    %ebx,%eax
  800784:	01 d0                	add    %edx,%eax
  800786:	01 c8                	add    %ecx,%eax
  800788:	8a 40 04             	mov    0x4(%eax),%al
  80078b:	3c 01                	cmp    $0x1,%al
  80078d:	75 03                	jne    800792 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  80078f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800792:	ff 45 e0             	incl   -0x20(%ebp)
  800795:	a1 20 50 80 00       	mov    0x805020,%eax
  80079a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8007a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007a3:	39 c2                	cmp    %eax,%edx
  8007a5:	77 c0                	ja     800767 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8007a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007aa:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8007ad:	74 14                	je     8007c3 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  8007af:	83 ec 04             	sub    $0x4,%esp
  8007b2:	68 dc 3f 80 00       	push   $0x803fdc
  8007b7:	6a 44                	push   $0x44
  8007b9:	68 7c 3f 80 00       	push   $0x803f7c
  8007be:	e8 f8 fd ff ff       	call   8005bb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8007c3:	90                   	nop
  8007c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007c7:	c9                   	leave  
  8007c8:	c3                   	ret    

008007c9 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8007c9:	55                   	push   %ebp
  8007ca:	89 e5                	mov    %esp,%ebp
  8007cc:	53                   	push   %ebx
  8007cd:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8007d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d3:	8b 00                	mov    (%eax),%eax
  8007d5:	8d 48 01             	lea    0x1(%eax),%ecx
  8007d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007db:	89 0a                	mov    %ecx,(%edx)
  8007dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8007e0:	88 d1                	mov    %dl,%cl
  8007e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007e5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8007e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ec:	8b 00                	mov    (%eax),%eax
  8007ee:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007f3:	75 30                	jne    800825 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8007f5:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  8007fb:	a0 44 50 80 00       	mov    0x805044,%al
  800800:	0f b6 c0             	movzbl %al,%eax
  800803:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800806:	8b 09                	mov    (%ecx),%ecx
  800808:	89 cb                	mov    %ecx,%ebx
  80080a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80080d:	83 c1 08             	add    $0x8,%ecx
  800810:	52                   	push   %edx
  800811:	50                   	push   %eax
  800812:	53                   	push   %ebx
  800813:	51                   	push   %ecx
  800814:	e8 a8 1c 00 00       	call   8024c1 <sys_cputs>
  800819:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80081c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800825:	8b 45 0c             	mov    0xc(%ebp),%eax
  800828:	8b 40 04             	mov    0x4(%eax),%eax
  80082b:	8d 50 01             	lea    0x1(%eax),%edx
  80082e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800831:	89 50 04             	mov    %edx,0x4(%eax)
}
  800834:	90                   	nop
  800835:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800838:	c9                   	leave  
  800839:	c3                   	ret    

0080083a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80083a:	55                   	push   %ebp
  80083b:	89 e5                	mov    %esp,%ebp
  80083d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800843:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80084a:	00 00 00 
	b.cnt = 0;
  80084d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800854:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800857:	ff 75 0c             	pushl  0xc(%ebp)
  80085a:	ff 75 08             	pushl  0x8(%ebp)
  80085d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800863:	50                   	push   %eax
  800864:	68 c9 07 80 00       	push   $0x8007c9
  800869:	e8 5a 02 00 00       	call   800ac8 <vprintfmt>
  80086e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800871:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800877:	a0 44 50 80 00       	mov    0x805044,%al
  80087c:	0f b6 c0             	movzbl %al,%eax
  80087f:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800885:	52                   	push   %edx
  800886:	50                   	push   %eax
  800887:	51                   	push   %ecx
  800888:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80088e:	83 c0 08             	add    $0x8,%eax
  800891:	50                   	push   %eax
  800892:	e8 2a 1c 00 00       	call   8024c1 <sys_cputs>
  800897:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80089a:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  8008a1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8008a7:	c9                   	leave  
  8008a8:	c3                   	ret    

008008a9 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8008a9:	55                   	push   %ebp
  8008aa:	89 e5                	mov    %esp,%ebp
  8008ac:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8008af:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  8008b6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	83 ec 08             	sub    $0x8,%esp
  8008c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8008c5:	50                   	push   %eax
  8008c6:	e8 6f ff ff ff       	call   80083a <vcprintf>
  8008cb:	83 c4 10             	add    $0x10,%esp
  8008ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8008d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008d4:	c9                   	leave  
  8008d5:	c3                   	ret    

008008d6 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
  8008d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8008dc:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	c1 e0 08             	shl    $0x8,%eax
  8008e9:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  8008ee:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008f1:	83 c0 04             	add    $0x4,%eax
  8008f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fa:	83 ec 08             	sub    $0x8,%esp
  8008fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800900:	50                   	push   %eax
  800901:	e8 34 ff ff ff       	call   80083a <vcprintf>
  800906:	83 c4 10             	add    $0x10,%esp
  800909:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80090c:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  800913:	07 00 00 

	return cnt;
  800916:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800919:	c9                   	leave  
  80091a:	c3                   	ret    

0080091b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800921:	e8 df 1b 00 00       	call   802505 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800926:	8d 45 0c             	lea    0xc(%ebp),%eax
  800929:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	83 ec 08             	sub    $0x8,%esp
  800932:	ff 75 f4             	pushl  -0xc(%ebp)
  800935:	50                   	push   %eax
  800936:	e8 ff fe ff ff       	call   80083a <vcprintf>
  80093b:	83 c4 10             	add    $0x10,%esp
  80093e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800941:	e8 d9 1b 00 00       	call   80251f <sys_unlock_cons>
	return cnt;
  800946:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800949:	c9                   	leave  
  80094a:	c3                   	ret    

0080094b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80094b:	55                   	push   %ebp
  80094c:	89 e5                	mov    %esp,%ebp
  80094e:	53                   	push   %ebx
  80094f:	83 ec 14             	sub    $0x14,%esp
  800952:	8b 45 10             	mov    0x10(%ebp),%eax
  800955:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800958:	8b 45 14             	mov    0x14(%ebp),%eax
  80095b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80095e:	8b 45 18             	mov    0x18(%ebp),%eax
  800961:	ba 00 00 00 00       	mov    $0x0,%edx
  800966:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800969:	77 55                	ja     8009c0 <printnum+0x75>
  80096b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80096e:	72 05                	jb     800975 <printnum+0x2a>
  800970:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800973:	77 4b                	ja     8009c0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800975:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800978:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80097b:	8b 45 18             	mov    0x18(%ebp),%eax
  80097e:	ba 00 00 00 00       	mov    $0x0,%edx
  800983:	52                   	push   %edx
  800984:	50                   	push   %eax
  800985:	ff 75 f4             	pushl  -0xc(%ebp)
  800988:	ff 75 f0             	pushl  -0x10(%ebp)
  80098b:	e8 90 2e 00 00       	call   803820 <__udivdi3>
  800990:	83 c4 10             	add    $0x10,%esp
  800993:	83 ec 04             	sub    $0x4,%esp
  800996:	ff 75 20             	pushl  0x20(%ebp)
  800999:	53                   	push   %ebx
  80099a:	ff 75 18             	pushl  0x18(%ebp)
  80099d:	52                   	push   %edx
  80099e:	50                   	push   %eax
  80099f:	ff 75 0c             	pushl  0xc(%ebp)
  8009a2:	ff 75 08             	pushl  0x8(%ebp)
  8009a5:	e8 a1 ff ff ff       	call   80094b <printnum>
  8009aa:	83 c4 20             	add    $0x20,%esp
  8009ad:	eb 1a                	jmp    8009c9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8009af:	83 ec 08             	sub    $0x8,%esp
  8009b2:	ff 75 0c             	pushl  0xc(%ebp)
  8009b5:	ff 75 20             	pushl  0x20(%ebp)
  8009b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bb:	ff d0                	call   *%eax
  8009bd:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8009c0:	ff 4d 1c             	decl   0x1c(%ebp)
  8009c3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8009c7:	7f e6                	jg     8009af <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8009c9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8009cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d7:	53                   	push   %ebx
  8009d8:	51                   	push   %ecx
  8009d9:	52                   	push   %edx
  8009da:	50                   	push   %eax
  8009db:	e8 50 2f 00 00       	call   803930 <__umoddi3>
  8009e0:	83 c4 10             	add    $0x10,%esp
  8009e3:	05 54 42 80 00       	add    $0x804254,%eax
  8009e8:	8a 00                	mov    (%eax),%al
  8009ea:	0f be c0             	movsbl %al,%eax
  8009ed:	83 ec 08             	sub    $0x8,%esp
  8009f0:	ff 75 0c             	pushl  0xc(%ebp)
  8009f3:	50                   	push   %eax
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	ff d0                	call   *%eax
  8009f9:	83 c4 10             	add    $0x10,%esp
}
  8009fc:	90                   	nop
  8009fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a00:	c9                   	leave  
  800a01:	c3                   	ret    

00800a02 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a05:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a09:	7e 1c                	jle    800a27 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	8b 00                	mov    (%eax),%eax
  800a10:	8d 50 08             	lea    0x8(%eax),%edx
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	89 10                	mov    %edx,(%eax)
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	8b 00                	mov    (%eax),%eax
  800a1d:	83 e8 08             	sub    $0x8,%eax
  800a20:	8b 50 04             	mov    0x4(%eax),%edx
  800a23:	8b 00                	mov    (%eax),%eax
  800a25:	eb 40                	jmp    800a67 <getuint+0x65>
	else if (lflag)
  800a27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a2b:	74 1e                	je     800a4b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	8b 00                	mov    (%eax),%eax
  800a32:	8d 50 04             	lea    0x4(%eax),%edx
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	89 10                	mov    %edx,(%eax)
  800a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3d:	8b 00                	mov    (%eax),%eax
  800a3f:	83 e8 04             	sub    $0x4,%eax
  800a42:	8b 00                	mov    (%eax),%eax
  800a44:	ba 00 00 00 00       	mov    $0x0,%edx
  800a49:	eb 1c                	jmp    800a67 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	8b 00                	mov    (%eax),%eax
  800a50:	8d 50 04             	lea    0x4(%eax),%edx
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	89 10                	mov    %edx,(%eax)
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	8b 00                	mov    (%eax),%eax
  800a5d:	83 e8 04             	sub    $0x4,%eax
  800a60:	8b 00                	mov    (%eax),%eax
  800a62:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800a67:	5d                   	pop    %ebp
  800a68:	c3                   	ret    

00800a69 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a69:	55                   	push   %ebp
  800a6a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a6c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a70:	7e 1c                	jle    800a8e <getint+0x25>
		return va_arg(*ap, long long);
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	8b 00                	mov    (%eax),%eax
  800a77:	8d 50 08             	lea    0x8(%eax),%edx
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	89 10                	mov    %edx,(%eax)
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	8b 00                	mov    (%eax),%eax
  800a84:	83 e8 08             	sub    $0x8,%eax
  800a87:	8b 50 04             	mov    0x4(%eax),%edx
  800a8a:	8b 00                	mov    (%eax),%eax
  800a8c:	eb 38                	jmp    800ac6 <getint+0x5d>
	else if (lflag)
  800a8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a92:	74 1a                	je     800aae <getint+0x45>
		return va_arg(*ap, long);
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	8b 00                	mov    (%eax),%eax
  800a99:	8d 50 04             	lea    0x4(%eax),%edx
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	89 10                	mov    %edx,(%eax)
  800aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa4:	8b 00                	mov    (%eax),%eax
  800aa6:	83 e8 04             	sub    $0x4,%eax
  800aa9:	8b 00                	mov    (%eax),%eax
  800aab:	99                   	cltd   
  800aac:	eb 18                	jmp    800ac6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	8b 00                	mov    (%eax),%eax
  800ab3:	8d 50 04             	lea    0x4(%eax),%edx
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	89 10                	mov    %edx,(%eax)
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	8b 00                	mov    (%eax),%eax
  800ac0:	83 e8 04             	sub    $0x4,%eax
  800ac3:	8b 00                	mov    (%eax),%eax
  800ac5:	99                   	cltd   
}
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    

00800ac8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	56                   	push   %esi
  800acc:	53                   	push   %ebx
  800acd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ad0:	eb 17                	jmp    800ae9 <vprintfmt+0x21>
			if (ch == '\0')
  800ad2:	85 db                	test   %ebx,%ebx
  800ad4:	0f 84 c1 03 00 00    	je     800e9b <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800ada:	83 ec 08             	sub    $0x8,%esp
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	53                   	push   %ebx
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	ff d0                	call   *%eax
  800ae6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ae9:	8b 45 10             	mov    0x10(%ebp),%eax
  800aec:	8d 50 01             	lea    0x1(%eax),%edx
  800aef:	89 55 10             	mov    %edx,0x10(%ebp)
  800af2:	8a 00                	mov    (%eax),%al
  800af4:	0f b6 d8             	movzbl %al,%ebx
  800af7:	83 fb 25             	cmp    $0x25,%ebx
  800afa:	75 d6                	jne    800ad2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800afc:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b00:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b07:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b0e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b15:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1f:	8d 50 01             	lea    0x1(%eax),%edx
  800b22:	89 55 10             	mov    %edx,0x10(%ebp)
  800b25:	8a 00                	mov    (%eax),%al
  800b27:	0f b6 d8             	movzbl %al,%ebx
  800b2a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b2d:	83 f8 5b             	cmp    $0x5b,%eax
  800b30:	0f 87 3d 03 00 00    	ja     800e73 <vprintfmt+0x3ab>
  800b36:	8b 04 85 78 42 80 00 	mov    0x804278(,%eax,4),%eax
  800b3d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800b3f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800b43:	eb d7                	jmp    800b1c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b45:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800b49:	eb d1                	jmp    800b1c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b4b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800b52:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b55:	89 d0                	mov    %edx,%eax
  800b57:	c1 e0 02             	shl    $0x2,%eax
  800b5a:	01 d0                	add    %edx,%eax
  800b5c:	01 c0                	add    %eax,%eax
  800b5e:	01 d8                	add    %ebx,%eax
  800b60:	83 e8 30             	sub    $0x30,%eax
  800b63:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800b66:	8b 45 10             	mov    0x10(%ebp),%eax
  800b69:	8a 00                	mov    (%eax),%al
  800b6b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b6e:	83 fb 2f             	cmp    $0x2f,%ebx
  800b71:	7e 3e                	jle    800bb1 <vprintfmt+0xe9>
  800b73:	83 fb 39             	cmp    $0x39,%ebx
  800b76:	7f 39                	jg     800bb1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b78:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b7b:	eb d5                	jmp    800b52 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800b7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b80:	83 c0 04             	add    $0x4,%eax
  800b83:	89 45 14             	mov    %eax,0x14(%ebp)
  800b86:	8b 45 14             	mov    0x14(%ebp),%eax
  800b89:	83 e8 04             	sub    $0x4,%eax
  800b8c:	8b 00                	mov    (%eax),%eax
  800b8e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b91:	eb 1f                	jmp    800bb2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b93:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b97:	79 83                	jns    800b1c <vprintfmt+0x54>
				width = 0;
  800b99:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ba0:	e9 77 ff ff ff       	jmp    800b1c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ba5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800bac:	e9 6b ff ff ff       	jmp    800b1c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800bb1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800bb2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb6:	0f 89 60 ff ff ff    	jns    800b1c <vprintfmt+0x54>
				width = precision, precision = -1;
  800bbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bbf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800bc2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800bc9:	e9 4e ff ff ff       	jmp    800b1c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800bce:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800bd1:	e9 46 ff ff ff       	jmp    800b1c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800bd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd9:	83 c0 04             	add    $0x4,%eax
  800bdc:	89 45 14             	mov    %eax,0x14(%ebp)
  800bdf:	8b 45 14             	mov    0x14(%ebp),%eax
  800be2:	83 e8 04             	sub    $0x4,%eax
  800be5:	8b 00                	mov    (%eax),%eax
  800be7:	83 ec 08             	sub    $0x8,%esp
  800bea:	ff 75 0c             	pushl  0xc(%ebp)
  800bed:	50                   	push   %eax
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	ff d0                	call   *%eax
  800bf3:	83 c4 10             	add    $0x10,%esp
			break;
  800bf6:	e9 9b 02 00 00       	jmp    800e96 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800bfb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bfe:	83 c0 04             	add    $0x4,%eax
  800c01:	89 45 14             	mov    %eax,0x14(%ebp)
  800c04:	8b 45 14             	mov    0x14(%ebp),%eax
  800c07:	83 e8 04             	sub    $0x4,%eax
  800c0a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c0c:	85 db                	test   %ebx,%ebx
  800c0e:	79 02                	jns    800c12 <vprintfmt+0x14a>
				err = -err;
  800c10:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c12:	83 fb 64             	cmp    $0x64,%ebx
  800c15:	7f 0b                	jg     800c22 <vprintfmt+0x15a>
  800c17:	8b 34 9d c0 40 80 00 	mov    0x8040c0(,%ebx,4),%esi
  800c1e:	85 f6                	test   %esi,%esi
  800c20:	75 19                	jne    800c3b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c22:	53                   	push   %ebx
  800c23:	68 65 42 80 00       	push   $0x804265
  800c28:	ff 75 0c             	pushl  0xc(%ebp)
  800c2b:	ff 75 08             	pushl  0x8(%ebp)
  800c2e:	e8 70 02 00 00       	call   800ea3 <printfmt>
  800c33:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c36:	e9 5b 02 00 00       	jmp    800e96 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c3b:	56                   	push   %esi
  800c3c:	68 6e 42 80 00       	push   $0x80426e
  800c41:	ff 75 0c             	pushl  0xc(%ebp)
  800c44:	ff 75 08             	pushl  0x8(%ebp)
  800c47:	e8 57 02 00 00       	call   800ea3 <printfmt>
  800c4c:	83 c4 10             	add    $0x10,%esp
			break;
  800c4f:	e9 42 02 00 00       	jmp    800e96 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800c54:	8b 45 14             	mov    0x14(%ebp),%eax
  800c57:	83 c0 04             	add    $0x4,%eax
  800c5a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c60:	83 e8 04             	sub    $0x4,%eax
  800c63:	8b 30                	mov    (%eax),%esi
  800c65:	85 f6                	test   %esi,%esi
  800c67:	75 05                	jne    800c6e <vprintfmt+0x1a6>
				p = "(null)";
  800c69:	be 71 42 80 00       	mov    $0x804271,%esi
			if (width > 0 && padc != '-')
  800c6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c72:	7e 6d                	jle    800ce1 <vprintfmt+0x219>
  800c74:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800c78:	74 67                	je     800ce1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c7d:	83 ec 08             	sub    $0x8,%esp
  800c80:	50                   	push   %eax
  800c81:	56                   	push   %esi
  800c82:	e8 1e 03 00 00       	call   800fa5 <strnlen>
  800c87:	83 c4 10             	add    $0x10,%esp
  800c8a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c8d:	eb 16                	jmp    800ca5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c8f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c93:	83 ec 08             	sub    $0x8,%esp
  800c96:	ff 75 0c             	pushl  0xc(%ebp)
  800c99:	50                   	push   %eax
  800c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9d:	ff d0                	call   *%eax
  800c9f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ca2:	ff 4d e4             	decl   -0x1c(%ebp)
  800ca5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ca9:	7f e4                	jg     800c8f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cab:	eb 34                	jmp    800ce1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800cad:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800cb1:	74 1c                	je     800ccf <vprintfmt+0x207>
  800cb3:	83 fb 1f             	cmp    $0x1f,%ebx
  800cb6:	7e 05                	jle    800cbd <vprintfmt+0x1f5>
  800cb8:	83 fb 7e             	cmp    $0x7e,%ebx
  800cbb:	7e 12                	jle    800ccf <vprintfmt+0x207>
					putch('?', putdat);
  800cbd:	83 ec 08             	sub    $0x8,%esp
  800cc0:	ff 75 0c             	pushl  0xc(%ebp)
  800cc3:	6a 3f                	push   $0x3f
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	ff d0                	call   *%eax
  800cca:	83 c4 10             	add    $0x10,%esp
  800ccd:	eb 0f                	jmp    800cde <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ccf:	83 ec 08             	sub    $0x8,%esp
  800cd2:	ff 75 0c             	pushl  0xc(%ebp)
  800cd5:	53                   	push   %ebx
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	ff d0                	call   *%eax
  800cdb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cde:	ff 4d e4             	decl   -0x1c(%ebp)
  800ce1:	89 f0                	mov    %esi,%eax
  800ce3:	8d 70 01             	lea    0x1(%eax),%esi
  800ce6:	8a 00                	mov    (%eax),%al
  800ce8:	0f be d8             	movsbl %al,%ebx
  800ceb:	85 db                	test   %ebx,%ebx
  800ced:	74 24                	je     800d13 <vprintfmt+0x24b>
  800cef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800cf3:	78 b8                	js     800cad <vprintfmt+0x1e5>
  800cf5:	ff 4d e0             	decl   -0x20(%ebp)
  800cf8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800cfc:	79 af                	jns    800cad <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cfe:	eb 13                	jmp    800d13 <vprintfmt+0x24b>
				putch(' ', putdat);
  800d00:	83 ec 08             	sub    $0x8,%esp
  800d03:	ff 75 0c             	pushl  0xc(%ebp)
  800d06:	6a 20                	push   $0x20
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	ff d0                	call   *%eax
  800d0d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d10:	ff 4d e4             	decl   -0x1c(%ebp)
  800d13:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d17:	7f e7                	jg     800d00 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d19:	e9 78 01 00 00       	jmp    800e96 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d1e:	83 ec 08             	sub    $0x8,%esp
  800d21:	ff 75 e8             	pushl  -0x18(%ebp)
  800d24:	8d 45 14             	lea    0x14(%ebp),%eax
  800d27:	50                   	push   %eax
  800d28:	e8 3c fd ff ff       	call   800a69 <getint>
  800d2d:	83 c4 10             	add    $0x10,%esp
  800d30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d33:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d3c:	85 d2                	test   %edx,%edx
  800d3e:	79 23                	jns    800d63 <vprintfmt+0x29b>
				putch('-', putdat);
  800d40:	83 ec 08             	sub    $0x8,%esp
  800d43:	ff 75 0c             	pushl  0xc(%ebp)
  800d46:	6a 2d                	push   $0x2d
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	ff d0                	call   *%eax
  800d4d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800d50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d56:	f7 d8                	neg    %eax
  800d58:	83 d2 00             	adc    $0x0,%edx
  800d5b:	f7 da                	neg    %edx
  800d5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d60:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800d63:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d6a:	e9 bc 00 00 00       	jmp    800e2b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800d6f:	83 ec 08             	sub    $0x8,%esp
  800d72:	ff 75 e8             	pushl  -0x18(%ebp)
  800d75:	8d 45 14             	lea    0x14(%ebp),%eax
  800d78:	50                   	push   %eax
  800d79:	e8 84 fc ff ff       	call   800a02 <getuint>
  800d7e:	83 c4 10             	add    $0x10,%esp
  800d81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d84:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800d87:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d8e:	e9 98 00 00 00       	jmp    800e2b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d93:	83 ec 08             	sub    $0x8,%esp
  800d96:	ff 75 0c             	pushl  0xc(%ebp)
  800d99:	6a 58                	push   $0x58
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	ff d0                	call   *%eax
  800da0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800da3:	83 ec 08             	sub    $0x8,%esp
  800da6:	ff 75 0c             	pushl  0xc(%ebp)
  800da9:	6a 58                	push   $0x58
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	ff d0                	call   *%eax
  800db0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800db3:	83 ec 08             	sub    $0x8,%esp
  800db6:	ff 75 0c             	pushl  0xc(%ebp)
  800db9:	6a 58                	push   $0x58
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	ff d0                	call   *%eax
  800dc0:	83 c4 10             	add    $0x10,%esp
			break;
  800dc3:	e9 ce 00 00 00       	jmp    800e96 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800dc8:	83 ec 08             	sub    $0x8,%esp
  800dcb:	ff 75 0c             	pushl  0xc(%ebp)
  800dce:	6a 30                	push   $0x30
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	ff d0                	call   *%eax
  800dd5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800dd8:	83 ec 08             	sub    $0x8,%esp
  800ddb:	ff 75 0c             	pushl  0xc(%ebp)
  800dde:	6a 78                	push   $0x78
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	ff d0                	call   *%eax
  800de5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800de8:	8b 45 14             	mov    0x14(%ebp),%eax
  800deb:	83 c0 04             	add    $0x4,%eax
  800dee:	89 45 14             	mov    %eax,0x14(%ebp)
  800df1:	8b 45 14             	mov    0x14(%ebp),%eax
  800df4:	83 e8 04             	sub    $0x4,%eax
  800df7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800df9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dfc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e03:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e0a:	eb 1f                	jmp    800e2b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e0c:	83 ec 08             	sub    $0x8,%esp
  800e0f:	ff 75 e8             	pushl  -0x18(%ebp)
  800e12:	8d 45 14             	lea    0x14(%ebp),%eax
  800e15:	50                   	push   %eax
  800e16:	e8 e7 fb ff ff       	call   800a02 <getuint>
  800e1b:	83 c4 10             	add    $0x10,%esp
  800e1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e21:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e24:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e2b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e32:	83 ec 04             	sub    $0x4,%esp
  800e35:	52                   	push   %edx
  800e36:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e39:	50                   	push   %eax
  800e3a:	ff 75 f4             	pushl  -0xc(%ebp)
  800e3d:	ff 75 f0             	pushl  -0x10(%ebp)
  800e40:	ff 75 0c             	pushl  0xc(%ebp)
  800e43:	ff 75 08             	pushl  0x8(%ebp)
  800e46:	e8 00 fb ff ff       	call   80094b <printnum>
  800e4b:	83 c4 20             	add    $0x20,%esp
			break;
  800e4e:	eb 46                	jmp    800e96 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e50:	83 ec 08             	sub    $0x8,%esp
  800e53:	ff 75 0c             	pushl  0xc(%ebp)
  800e56:	53                   	push   %ebx
  800e57:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5a:	ff d0                	call   *%eax
  800e5c:	83 c4 10             	add    $0x10,%esp
			break;
  800e5f:	eb 35                	jmp    800e96 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800e61:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800e68:	eb 2c                	jmp    800e96 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800e6a:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800e71:	eb 23                	jmp    800e96 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e73:	83 ec 08             	sub    $0x8,%esp
  800e76:	ff 75 0c             	pushl  0xc(%ebp)
  800e79:	6a 25                	push   $0x25
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	ff d0                	call   *%eax
  800e80:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e83:	ff 4d 10             	decl   0x10(%ebp)
  800e86:	eb 03                	jmp    800e8b <vprintfmt+0x3c3>
  800e88:	ff 4d 10             	decl   0x10(%ebp)
  800e8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8e:	48                   	dec    %eax
  800e8f:	8a 00                	mov    (%eax),%al
  800e91:	3c 25                	cmp    $0x25,%al
  800e93:	75 f3                	jne    800e88 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800e95:	90                   	nop
		}
	}
  800e96:	e9 35 fc ff ff       	jmp    800ad0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800e9b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800e9c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e9f:	5b                   	pop    %ebx
  800ea0:	5e                   	pop    %esi
  800ea1:	5d                   	pop    %ebp
  800ea2:	c3                   	ret    

00800ea3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ea9:	8d 45 10             	lea    0x10(%ebp),%eax
  800eac:	83 c0 04             	add    $0x4,%eax
  800eaf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800eb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb5:	ff 75 f4             	pushl  -0xc(%ebp)
  800eb8:	50                   	push   %eax
  800eb9:	ff 75 0c             	pushl  0xc(%ebp)
  800ebc:	ff 75 08             	pushl  0x8(%ebp)
  800ebf:	e8 04 fc ff ff       	call   800ac8 <vprintfmt>
  800ec4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ec7:	90                   	nop
  800ec8:	c9                   	leave  
  800ec9:	c3                   	ret    

00800eca <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed0:	8b 40 08             	mov    0x8(%eax),%eax
  800ed3:	8d 50 01             	lea    0x1(%eax),%edx
  800ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800edc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edf:	8b 10                	mov    (%eax),%edx
  800ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee4:	8b 40 04             	mov    0x4(%eax),%eax
  800ee7:	39 c2                	cmp    %eax,%edx
  800ee9:	73 12                	jae    800efd <sprintputch+0x33>
		*b->buf++ = ch;
  800eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eee:	8b 00                	mov    (%eax),%eax
  800ef0:	8d 48 01             	lea    0x1(%eax),%ecx
  800ef3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef6:	89 0a                	mov    %ecx,(%edx)
  800ef8:	8b 55 08             	mov    0x8(%ebp),%edx
  800efb:	88 10                	mov    %dl,(%eax)
}
  800efd:	90                   	nop
  800efe:	5d                   	pop    %ebp
  800eff:	c3                   	ret    

00800f00 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	01 d0                	add    %edx,%eax
  800f17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f25:	74 06                	je     800f2d <vsnprintf+0x2d>
  800f27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f2b:	7f 07                	jg     800f34 <vsnprintf+0x34>
		return -E_INVAL;
  800f2d:	b8 03 00 00 00       	mov    $0x3,%eax
  800f32:	eb 20                	jmp    800f54 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f34:	ff 75 14             	pushl  0x14(%ebp)
  800f37:	ff 75 10             	pushl  0x10(%ebp)
  800f3a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f3d:	50                   	push   %eax
  800f3e:	68 ca 0e 80 00       	push   $0x800eca
  800f43:	e8 80 fb ff ff       	call   800ac8 <vprintfmt>
  800f48:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800f4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f4e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800f54:	c9                   	leave  
  800f55:	c3                   	ret    

00800f56 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f56:	55                   	push   %ebp
  800f57:	89 e5                	mov    %esp,%ebp
  800f59:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800f5c:	8d 45 10             	lea    0x10(%ebp),%eax
  800f5f:	83 c0 04             	add    $0x4,%eax
  800f62:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800f65:	8b 45 10             	mov    0x10(%ebp),%eax
  800f68:	ff 75 f4             	pushl  -0xc(%ebp)
  800f6b:	50                   	push   %eax
  800f6c:	ff 75 0c             	pushl  0xc(%ebp)
  800f6f:	ff 75 08             	pushl  0x8(%ebp)
  800f72:	e8 89 ff ff ff       	call   800f00 <vsnprintf>
  800f77:	83 c4 10             	add    $0x10,%esp
  800f7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f80:	c9                   	leave  
  800f81:	c3                   	ret    

00800f82 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800f88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f8f:	eb 06                	jmp    800f97 <strlen+0x15>
		n++;
  800f91:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f94:	ff 45 08             	incl   0x8(%ebp)
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	84 c0                	test   %al,%al
  800f9e:	75 f1                	jne    800f91 <strlen+0xf>
		n++;
	return n;
  800fa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800fa3:	c9                   	leave  
  800fa4:	c3                   	ret    

00800fa5 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fb2:	eb 09                	jmp    800fbd <strnlen+0x18>
		n++;
  800fb4:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fb7:	ff 45 08             	incl   0x8(%ebp)
  800fba:	ff 4d 0c             	decl   0xc(%ebp)
  800fbd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fc1:	74 09                	je     800fcc <strnlen+0x27>
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	8a 00                	mov    (%eax),%al
  800fc8:	84 c0                	test   %al,%al
  800fca:	75 e8                	jne    800fb4 <strnlen+0xf>
		n++;
	return n;
  800fcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800fcf:	c9                   	leave  
  800fd0:	c3                   	ret    

00800fd1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
  800fd4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800fdd:	90                   	nop
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8d 50 01             	lea    0x1(%eax),%edx
  800fe4:	89 55 08             	mov    %edx,0x8(%ebp)
  800fe7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fea:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fed:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ff0:	8a 12                	mov    (%edx),%dl
  800ff2:	88 10                	mov    %dl,(%eax)
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	84 c0                	test   %al,%al
  800ff8:	75 e4                	jne    800fde <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ffa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ffd:	c9                   	leave  
  800ffe:	c3                   	ret    

00800fff <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
  801002:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80100b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801012:	eb 1f                	jmp    801033 <strncpy+0x34>
		*dst++ = *src;
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	8d 50 01             	lea    0x1(%eax),%edx
  80101a:	89 55 08             	mov    %edx,0x8(%ebp)
  80101d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801020:	8a 12                	mov    (%edx),%dl
  801022:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801024:	8b 45 0c             	mov    0xc(%ebp),%eax
  801027:	8a 00                	mov    (%eax),%al
  801029:	84 c0                	test   %al,%al
  80102b:	74 03                	je     801030 <strncpy+0x31>
			src++;
  80102d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801030:	ff 45 fc             	incl   -0x4(%ebp)
  801033:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801036:	3b 45 10             	cmp    0x10(%ebp),%eax
  801039:	72 d9                	jb     801014 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80103b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80103e:	c9                   	leave  
  80103f:	c3                   	ret    

00801040 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
  801043:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80104c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801050:	74 30                	je     801082 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801052:	eb 16                	jmp    80106a <strlcpy+0x2a>
			*dst++ = *src++;
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8d 50 01             	lea    0x1(%eax),%edx
  80105a:	89 55 08             	mov    %edx,0x8(%ebp)
  80105d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801060:	8d 4a 01             	lea    0x1(%edx),%ecx
  801063:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801066:	8a 12                	mov    (%edx),%dl
  801068:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80106a:	ff 4d 10             	decl   0x10(%ebp)
  80106d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801071:	74 09                	je     80107c <strlcpy+0x3c>
  801073:	8b 45 0c             	mov    0xc(%ebp),%eax
  801076:	8a 00                	mov    (%eax),%al
  801078:	84 c0                	test   %al,%al
  80107a:	75 d8                	jne    801054 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801082:	8b 55 08             	mov    0x8(%ebp),%edx
  801085:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801088:	29 c2                	sub    %eax,%edx
  80108a:	89 d0                	mov    %edx,%eax
}
  80108c:	c9                   	leave  
  80108d:	c3                   	ret    

0080108e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801091:	eb 06                	jmp    801099 <strcmp+0xb>
		p++, q++;
  801093:	ff 45 08             	incl   0x8(%ebp)
  801096:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	8a 00                	mov    (%eax),%al
  80109e:	84 c0                	test   %al,%al
  8010a0:	74 0e                	je     8010b0 <strcmp+0x22>
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	8a 10                	mov    (%eax),%dl
  8010a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010aa:	8a 00                	mov    (%eax),%al
  8010ac:	38 c2                	cmp    %al,%dl
  8010ae:	74 e3                	je     801093 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	8a 00                	mov    (%eax),%al
  8010b5:	0f b6 d0             	movzbl %al,%edx
  8010b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bb:	8a 00                	mov    (%eax),%al
  8010bd:	0f b6 c0             	movzbl %al,%eax
  8010c0:	29 c2                	sub    %eax,%edx
  8010c2:	89 d0                	mov    %edx,%eax
}
  8010c4:	5d                   	pop    %ebp
  8010c5:	c3                   	ret    

008010c6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8010c9:	eb 09                	jmp    8010d4 <strncmp+0xe>
		n--, p++, q++;
  8010cb:	ff 4d 10             	decl   0x10(%ebp)
  8010ce:	ff 45 08             	incl   0x8(%ebp)
  8010d1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8010d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d8:	74 17                	je     8010f1 <strncmp+0x2b>
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dd:	8a 00                	mov    (%eax),%al
  8010df:	84 c0                	test   %al,%al
  8010e1:	74 0e                	je     8010f1 <strncmp+0x2b>
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	8a 10                	mov    (%eax),%dl
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	38 c2                	cmp    %al,%dl
  8010ef:	74 da                	je     8010cb <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8010f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f5:	75 07                	jne    8010fe <strncmp+0x38>
		return 0;
  8010f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fc:	eb 14                	jmp    801112 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	8a 00                	mov    (%eax),%al
  801103:	0f b6 d0             	movzbl %al,%edx
  801106:	8b 45 0c             	mov    0xc(%ebp),%eax
  801109:	8a 00                	mov    (%eax),%al
  80110b:	0f b6 c0             	movzbl %al,%eax
  80110e:	29 c2                	sub    %eax,%edx
  801110:	89 d0                	mov    %edx,%eax
}
  801112:	5d                   	pop    %ebp
  801113:	c3                   	ret    

00801114 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	83 ec 04             	sub    $0x4,%esp
  80111a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801120:	eb 12                	jmp    801134 <strchr+0x20>
		if (*s == c)
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	8a 00                	mov    (%eax),%al
  801127:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80112a:	75 05                	jne    801131 <strchr+0x1d>
			return (char *) s;
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	eb 11                	jmp    801142 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801131:	ff 45 08             	incl   0x8(%ebp)
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	84 c0                	test   %al,%al
  80113b:	75 e5                	jne    801122 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80113d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801142:	c9                   	leave  
  801143:	c3                   	ret    

00801144 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801144:	55                   	push   %ebp
  801145:	89 e5                	mov    %esp,%ebp
  801147:	83 ec 04             	sub    $0x4,%esp
  80114a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801150:	eb 0d                	jmp    80115f <strfind+0x1b>
		if (*s == c)
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
  801155:	8a 00                	mov    (%eax),%al
  801157:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80115a:	74 0e                	je     80116a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80115c:	ff 45 08             	incl   0x8(%ebp)
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	84 c0                	test   %al,%al
  801166:	75 ea                	jne    801152 <strfind+0xe>
  801168:	eb 01                	jmp    80116b <strfind+0x27>
		if (*s == c)
			break;
  80116a:	90                   	nop
	return (char *) s;
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80116e:	c9                   	leave  
  80116f:	c3                   	ret    

00801170 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
  801173:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80117c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801180:	76 63                	jbe    8011e5 <memset+0x75>
		uint64 data_block = c;
  801182:	8b 45 0c             	mov    0xc(%ebp),%eax
  801185:	99                   	cltd   
  801186:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801189:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80118c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80118f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801192:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801196:	c1 e0 08             	shl    $0x8,%eax
  801199:	09 45 f0             	or     %eax,-0x10(%ebp)
  80119c:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80119f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a5:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8011a9:	c1 e0 10             	shl    $0x10,%eax
  8011ac:	09 45 f0             	or     %eax,-0x10(%ebp)
  8011af:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8011b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b8:	89 c2                	mov    %eax,%edx
  8011ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8011bf:	09 45 f0             	or     %eax,-0x10(%ebp)
  8011c2:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8011c5:	eb 18                	jmp    8011df <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8011c7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011ca:	8d 41 08             	lea    0x8(%ecx),%eax
  8011cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8011d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011d6:	89 01                	mov    %eax,(%ecx)
  8011d8:	89 51 04             	mov    %edx,0x4(%ecx)
  8011db:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8011df:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011e3:	77 e2                	ja     8011c7 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8011e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e9:	74 23                	je     80120e <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8011f1:	eb 0e                	jmp    801201 <memset+0x91>
			*p8++ = (uint8)c;
  8011f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f6:	8d 50 01             	lea    0x1(%eax),%edx
  8011f9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ff:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801201:	8b 45 10             	mov    0x10(%ebp),%eax
  801204:	8d 50 ff             	lea    -0x1(%eax),%edx
  801207:	89 55 10             	mov    %edx,0x10(%ebp)
  80120a:	85 c0                	test   %eax,%eax
  80120c:	75 e5                	jne    8011f3 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801211:	c9                   	leave  
  801212:	c3                   	ret    

00801213 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801213:	55                   	push   %ebp
  801214:	89 e5                	mov    %esp,%ebp
  801216:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801219:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801225:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801229:	76 24                	jbe    80124f <memcpy+0x3c>
		while(n >= 8){
  80122b:	eb 1c                	jmp    801249 <memcpy+0x36>
			*d64 = *s64;
  80122d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801230:	8b 50 04             	mov    0x4(%eax),%edx
  801233:	8b 00                	mov    (%eax),%eax
  801235:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801238:	89 01                	mov    %eax,(%ecx)
  80123a:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80123d:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801241:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801245:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801249:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80124d:	77 de                	ja     80122d <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80124f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801253:	74 31                	je     801286 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801255:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801258:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80125b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801261:	eb 16                	jmp    801279 <memcpy+0x66>
			*d8++ = *s8++;
  801263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801266:	8d 50 01             	lea    0x1(%eax),%edx
  801269:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80126c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80126f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801272:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801275:	8a 12                	mov    (%edx),%dl
  801277:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801279:	8b 45 10             	mov    0x10(%ebp),%eax
  80127c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80127f:	89 55 10             	mov    %edx,0x10(%ebp)
  801282:	85 c0                	test   %eax,%eax
  801284:	75 dd                	jne    801263 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801286:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801289:	c9                   	leave  
  80128a:	c3                   	ret    

0080128b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
  80128e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801291:	8b 45 0c             	mov    0xc(%ebp),%eax
  801294:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80129d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012a3:	73 50                	jae    8012f5 <memmove+0x6a>
  8012a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ab:	01 d0                	add    %edx,%eax
  8012ad:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012b0:	76 43                	jbe    8012f5 <memmove+0x6a>
		s += n;
  8012b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b5:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bb:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012be:	eb 10                	jmp    8012d0 <memmove+0x45>
			*--d = *--s;
  8012c0:	ff 4d f8             	decl   -0x8(%ebp)
  8012c3:	ff 4d fc             	decl   -0x4(%ebp)
  8012c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c9:	8a 10                	mov    (%eax),%dl
  8012cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ce:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	75 e3                	jne    8012c0 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012dd:	eb 23                	jmp    801302 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e2:	8d 50 01             	lea    0x1(%eax),%edx
  8012e5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012eb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012ee:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012f1:	8a 12                	mov    (%edx),%dl
  8012f3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012fb:	89 55 10             	mov    %edx,0x10(%ebp)
  8012fe:	85 c0                	test   %eax,%eax
  801300:	75 dd                	jne    8012df <memmove+0x54>
			*d++ = *s++;

	return dst;
  801302:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801305:	c9                   	leave  
  801306:	c3                   	ret    

00801307 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
  80130a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801313:	8b 45 0c             	mov    0xc(%ebp),%eax
  801316:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801319:	eb 2a                	jmp    801345 <memcmp+0x3e>
		if (*s1 != *s2)
  80131b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80131e:	8a 10                	mov    (%eax),%dl
  801320:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801323:	8a 00                	mov    (%eax),%al
  801325:	38 c2                	cmp    %al,%dl
  801327:	74 16                	je     80133f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801329:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132c:	8a 00                	mov    (%eax),%al
  80132e:	0f b6 d0             	movzbl %al,%edx
  801331:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801334:	8a 00                	mov    (%eax),%al
  801336:	0f b6 c0             	movzbl %al,%eax
  801339:	29 c2                	sub    %eax,%edx
  80133b:	89 d0                	mov    %edx,%eax
  80133d:	eb 18                	jmp    801357 <memcmp+0x50>
		s1++, s2++;
  80133f:	ff 45 fc             	incl   -0x4(%ebp)
  801342:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801345:	8b 45 10             	mov    0x10(%ebp),%eax
  801348:	8d 50 ff             	lea    -0x1(%eax),%edx
  80134b:	89 55 10             	mov    %edx,0x10(%ebp)
  80134e:	85 c0                	test   %eax,%eax
  801350:	75 c9                	jne    80131b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801352:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801357:	c9                   	leave  
  801358:	c3                   	ret    

00801359 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
  80135c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80135f:	8b 55 08             	mov    0x8(%ebp),%edx
  801362:	8b 45 10             	mov    0x10(%ebp),%eax
  801365:	01 d0                	add    %edx,%eax
  801367:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80136a:	eb 15                	jmp    801381 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	8a 00                	mov    (%eax),%al
  801371:	0f b6 d0             	movzbl %al,%edx
  801374:	8b 45 0c             	mov    0xc(%ebp),%eax
  801377:	0f b6 c0             	movzbl %al,%eax
  80137a:	39 c2                	cmp    %eax,%edx
  80137c:	74 0d                	je     80138b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80137e:	ff 45 08             	incl   0x8(%ebp)
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801387:	72 e3                	jb     80136c <memfind+0x13>
  801389:	eb 01                	jmp    80138c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80138b:	90                   	nop
	return (void *) s;
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80138f:	c9                   	leave  
  801390:	c3                   	ret    

00801391 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
  801394:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801397:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80139e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013a5:	eb 03                	jmp    8013aa <strtol+0x19>
		s++;
  8013a7:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	8a 00                	mov    (%eax),%al
  8013af:	3c 20                	cmp    $0x20,%al
  8013b1:	74 f4                	je     8013a7 <strtol+0x16>
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	8a 00                	mov    (%eax),%al
  8013b8:	3c 09                	cmp    $0x9,%al
  8013ba:	74 eb                	je     8013a7 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bf:	8a 00                	mov    (%eax),%al
  8013c1:	3c 2b                	cmp    $0x2b,%al
  8013c3:	75 05                	jne    8013ca <strtol+0x39>
		s++;
  8013c5:	ff 45 08             	incl   0x8(%ebp)
  8013c8:	eb 13                	jmp    8013dd <strtol+0x4c>
	else if (*s == '-')
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	8a 00                	mov    (%eax),%al
  8013cf:	3c 2d                	cmp    $0x2d,%al
  8013d1:	75 0a                	jne    8013dd <strtol+0x4c>
		s++, neg = 1;
  8013d3:	ff 45 08             	incl   0x8(%ebp)
  8013d6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e1:	74 06                	je     8013e9 <strtol+0x58>
  8013e3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013e7:	75 20                	jne    801409 <strtol+0x78>
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	8a 00                	mov    (%eax),%al
  8013ee:	3c 30                	cmp    $0x30,%al
  8013f0:	75 17                	jne    801409 <strtol+0x78>
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	40                   	inc    %eax
  8013f6:	8a 00                	mov    (%eax),%al
  8013f8:	3c 78                	cmp    $0x78,%al
  8013fa:	75 0d                	jne    801409 <strtol+0x78>
		s += 2, base = 16;
  8013fc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801400:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801407:	eb 28                	jmp    801431 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801409:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80140d:	75 15                	jne    801424 <strtol+0x93>
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	8a 00                	mov    (%eax),%al
  801414:	3c 30                	cmp    $0x30,%al
  801416:	75 0c                	jne    801424 <strtol+0x93>
		s++, base = 8;
  801418:	ff 45 08             	incl   0x8(%ebp)
  80141b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801422:	eb 0d                	jmp    801431 <strtol+0xa0>
	else if (base == 0)
  801424:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801428:	75 07                	jne    801431 <strtol+0xa0>
		base = 10;
  80142a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	8a 00                	mov    (%eax),%al
  801436:	3c 2f                	cmp    $0x2f,%al
  801438:	7e 19                	jle    801453 <strtol+0xc2>
  80143a:	8b 45 08             	mov    0x8(%ebp),%eax
  80143d:	8a 00                	mov    (%eax),%al
  80143f:	3c 39                	cmp    $0x39,%al
  801441:	7f 10                	jg     801453 <strtol+0xc2>
			dig = *s - '0';
  801443:	8b 45 08             	mov    0x8(%ebp),%eax
  801446:	8a 00                	mov    (%eax),%al
  801448:	0f be c0             	movsbl %al,%eax
  80144b:	83 e8 30             	sub    $0x30,%eax
  80144e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801451:	eb 42                	jmp    801495 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	8a 00                	mov    (%eax),%al
  801458:	3c 60                	cmp    $0x60,%al
  80145a:	7e 19                	jle    801475 <strtol+0xe4>
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	3c 7a                	cmp    $0x7a,%al
  801463:	7f 10                	jg     801475 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	8a 00                	mov    (%eax),%al
  80146a:	0f be c0             	movsbl %al,%eax
  80146d:	83 e8 57             	sub    $0x57,%eax
  801470:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801473:	eb 20                	jmp    801495 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801475:	8b 45 08             	mov    0x8(%ebp),%eax
  801478:	8a 00                	mov    (%eax),%al
  80147a:	3c 40                	cmp    $0x40,%al
  80147c:	7e 39                	jle    8014b7 <strtol+0x126>
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	8a 00                	mov    (%eax),%al
  801483:	3c 5a                	cmp    $0x5a,%al
  801485:	7f 30                	jg     8014b7 <strtol+0x126>
			dig = *s - 'A' + 10;
  801487:	8b 45 08             	mov    0x8(%ebp),%eax
  80148a:	8a 00                	mov    (%eax),%al
  80148c:	0f be c0             	movsbl %al,%eax
  80148f:	83 e8 37             	sub    $0x37,%eax
  801492:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801498:	3b 45 10             	cmp    0x10(%ebp),%eax
  80149b:	7d 19                	jge    8014b6 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80149d:	ff 45 08             	incl   0x8(%ebp)
  8014a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a3:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014a7:	89 c2                	mov    %eax,%edx
  8014a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ac:	01 d0                	add    %edx,%eax
  8014ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014b1:	e9 7b ff ff ff       	jmp    801431 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014b6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014b7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014bb:	74 08                	je     8014c5 <strtol+0x134>
		*endptr = (char *) s;
  8014bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014c3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014c9:	74 07                	je     8014d2 <strtol+0x141>
  8014cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ce:	f7 d8                	neg    %eax
  8014d0:	eb 03                	jmp    8014d5 <strtol+0x144>
  8014d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014d5:	c9                   	leave  
  8014d6:	c3                   	ret    

008014d7 <ltostr>:

void
ltostr(long value, char *str)
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
  8014da:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014e4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014ef:	79 13                	jns    801504 <ltostr+0x2d>
	{
		neg = 1;
  8014f1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fb:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014fe:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801501:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80150c:	99                   	cltd   
  80150d:	f7 f9                	idiv   %ecx
  80150f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801512:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801515:	8d 50 01             	lea    0x1(%eax),%edx
  801518:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80151b:	89 c2                	mov    %eax,%edx
  80151d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801520:	01 d0                	add    %edx,%eax
  801522:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801525:	83 c2 30             	add    $0x30,%edx
  801528:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80152a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80152d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801532:	f7 e9                	imul   %ecx
  801534:	c1 fa 02             	sar    $0x2,%edx
  801537:	89 c8                	mov    %ecx,%eax
  801539:	c1 f8 1f             	sar    $0x1f,%eax
  80153c:	29 c2                	sub    %eax,%edx
  80153e:	89 d0                	mov    %edx,%eax
  801540:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801543:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801547:	75 bb                	jne    801504 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801549:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801550:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801553:	48                   	dec    %eax
  801554:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801557:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80155b:	74 3d                	je     80159a <ltostr+0xc3>
		start = 1 ;
  80155d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801564:	eb 34                	jmp    80159a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801566:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156c:	01 d0                	add    %edx,%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801573:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801576:	8b 45 0c             	mov    0xc(%ebp),%eax
  801579:	01 c2                	add    %eax,%edx
  80157b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80157e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801581:	01 c8                	add    %ecx,%eax
  801583:	8a 00                	mov    (%eax),%al
  801585:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801587:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80158a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158d:	01 c2                	add    %eax,%edx
  80158f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801592:	88 02                	mov    %al,(%edx)
		start++ ;
  801594:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801597:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80159a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015a0:	7c c4                	jl     801566 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015a2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a8:	01 d0                	add    %edx,%eax
  8015aa:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015ad:	90                   	nop
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015b6:	ff 75 08             	pushl  0x8(%ebp)
  8015b9:	e8 c4 f9 ff ff       	call   800f82 <strlen>
  8015be:	83 c4 04             	add    $0x4,%esp
  8015c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015c4:	ff 75 0c             	pushl  0xc(%ebp)
  8015c7:	e8 b6 f9 ff ff       	call   800f82 <strlen>
  8015cc:	83 c4 04             	add    $0x4,%esp
  8015cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015e0:	eb 17                	jmp    8015f9 <strcconcat+0x49>
		final[s] = str1[s] ;
  8015e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e8:	01 c2                	add    %eax,%edx
  8015ea:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f0:	01 c8                	add    %ecx,%eax
  8015f2:	8a 00                	mov    (%eax),%al
  8015f4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015f6:	ff 45 fc             	incl   -0x4(%ebp)
  8015f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015ff:	7c e1                	jl     8015e2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801601:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801608:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80160f:	eb 1f                	jmp    801630 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801611:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801614:	8d 50 01             	lea    0x1(%eax),%edx
  801617:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80161a:	89 c2                	mov    %eax,%edx
  80161c:	8b 45 10             	mov    0x10(%ebp),%eax
  80161f:	01 c2                	add    %eax,%edx
  801621:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801624:	8b 45 0c             	mov    0xc(%ebp),%eax
  801627:	01 c8                	add    %ecx,%eax
  801629:	8a 00                	mov    (%eax),%al
  80162b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80162d:	ff 45 f8             	incl   -0x8(%ebp)
  801630:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801633:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801636:	7c d9                	jl     801611 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801638:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80163b:	8b 45 10             	mov    0x10(%ebp),%eax
  80163e:	01 d0                	add    %edx,%eax
  801640:	c6 00 00             	movb   $0x0,(%eax)
}
  801643:	90                   	nop
  801644:	c9                   	leave  
  801645:	c3                   	ret    

00801646 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801649:	8b 45 14             	mov    0x14(%ebp),%eax
  80164c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801652:	8b 45 14             	mov    0x14(%ebp),%eax
  801655:	8b 00                	mov    (%eax),%eax
  801657:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80165e:	8b 45 10             	mov    0x10(%ebp),%eax
  801661:	01 d0                	add    %edx,%eax
  801663:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801669:	eb 0c                	jmp    801677 <strsplit+0x31>
			*string++ = 0;
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	8d 50 01             	lea    0x1(%eax),%edx
  801671:	89 55 08             	mov    %edx,0x8(%ebp)
  801674:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801677:	8b 45 08             	mov    0x8(%ebp),%eax
  80167a:	8a 00                	mov    (%eax),%al
  80167c:	84 c0                	test   %al,%al
  80167e:	74 18                	je     801698 <strsplit+0x52>
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	8a 00                	mov    (%eax),%al
  801685:	0f be c0             	movsbl %al,%eax
  801688:	50                   	push   %eax
  801689:	ff 75 0c             	pushl  0xc(%ebp)
  80168c:	e8 83 fa ff ff       	call   801114 <strchr>
  801691:	83 c4 08             	add    $0x8,%esp
  801694:	85 c0                	test   %eax,%eax
  801696:	75 d3                	jne    80166b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	8a 00                	mov    (%eax),%al
  80169d:	84 c0                	test   %al,%al
  80169f:	74 5a                	je     8016fb <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a4:	8b 00                	mov    (%eax),%eax
  8016a6:	83 f8 0f             	cmp    $0xf,%eax
  8016a9:	75 07                	jne    8016b2 <strsplit+0x6c>
		{
			return 0;
  8016ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b0:	eb 66                	jmp    801718 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8016b5:	8b 00                	mov    (%eax),%eax
  8016b7:	8d 48 01             	lea    0x1(%eax),%ecx
  8016ba:	8b 55 14             	mov    0x14(%ebp),%edx
  8016bd:	89 0a                	mov    %ecx,(%edx)
  8016bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c9:	01 c2                	add    %eax,%edx
  8016cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ce:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016d0:	eb 03                	jmp    8016d5 <strsplit+0x8f>
			string++;
  8016d2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d8:	8a 00                	mov    (%eax),%al
  8016da:	84 c0                	test   %al,%al
  8016dc:	74 8b                	je     801669 <strsplit+0x23>
  8016de:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e1:	8a 00                	mov    (%eax),%al
  8016e3:	0f be c0             	movsbl %al,%eax
  8016e6:	50                   	push   %eax
  8016e7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ea:	e8 25 fa ff ff       	call   801114 <strchr>
  8016ef:	83 c4 08             	add    $0x8,%esp
  8016f2:	85 c0                	test   %eax,%eax
  8016f4:	74 dc                	je     8016d2 <strsplit+0x8c>
			string++;
	}
  8016f6:	e9 6e ff ff ff       	jmp    801669 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016fb:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ff:	8b 00                	mov    (%eax),%eax
  801701:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801708:	8b 45 10             	mov    0x10(%ebp),%eax
  80170b:	01 d0                	add    %edx,%eax
  80170d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801713:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801718:	c9                   	leave  
  801719:	c3                   	ret    

0080171a <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80171a:	55                   	push   %ebp
  80171b:	89 e5                	mov    %esp,%ebp
  80171d:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801720:	8b 45 08             	mov    0x8(%ebp),%eax
  801723:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801726:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80172d:	eb 4a                	jmp    801779 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80172f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801732:	8b 45 08             	mov    0x8(%ebp),%eax
  801735:	01 c2                	add    %eax,%edx
  801737:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80173a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80173d:	01 c8                	add    %ecx,%eax
  80173f:	8a 00                	mov    (%eax),%al
  801741:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801743:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801746:	8b 45 0c             	mov    0xc(%ebp),%eax
  801749:	01 d0                	add    %edx,%eax
  80174b:	8a 00                	mov    (%eax),%al
  80174d:	3c 40                	cmp    $0x40,%al
  80174f:	7e 25                	jle    801776 <str2lower+0x5c>
  801751:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801754:	8b 45 0c             	mov    0xc(%ebp),%eax
  801757:	01 d0                	add    %edx,%eax
  801759:	8a 00                	mov    (%eax),%al
  80175b:	3c 5a                	cmp    $0x5a,%al
  80175d:	7f 17                	jg     801776 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80175f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
  801765:	01 d0                	add    %edx,%eax
  801767:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80176a:	8b 55 08             	mov    0x8(%ebp),%edx
  80176d:	01 ca                	add    %ecx,%edx
  80176f:	8a 12                	mov    (%edx),%dl
  801771:	83 c2 20             	add    $0x20,%edx
  801774:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801776:	ff 45 fc             	incl   -0x4(%ebp)
  801779:	ff 75 0c             	pushl  0xc(%ebp)
  80177c:	e8 01 f8 ff ff       	call   800f82 <strlen>
  801781:	83 c4 04             	add    $0x4,%esp
  801784:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801787:	7f a6                	jg     80172f <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801789:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80178c:	c9                   	leave  
  80178d:	c3                   	ret    

0080178e <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  801794:	83 ec 0c             	sub    $0xc,%esp
  801797:	6a 10                	push   $0x10
  801799:	e8 b2 15 00 00       	call   802d50 <alloc_block>
  80179e:	83 c4 10             	add    $0x10,%esp
  8017a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  8017a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017a8:	75 14                	jne    8017be <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  8017aa:	83 ec 04             	sub    $0x4,%esp
  8017ad:	68 e8 43 80 00       	push   $0x8043e8
  8017b2:	6a 14                	push   $0x14
  8017b4:	68 11 44 80 00       	push   $0x804411
  8017b9:	e8 fd ed ff ff       	call   8005bb <_panic>

	node->start = start;
  8017be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c4:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  8017c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cc:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  8017cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  8017d6:	a1 24 50 80 00       	mov    0x805024,%eax
  8017db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017de:	eb 18                	jmp    8017f8 <insert_page_alloc+0x6a>
		if (start < it->start)
  8017e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e3:	8b 00                	mov    (%eax),%eax
  8017e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8017e8:	77 37                	ja     801821 <insert_page_alloc+0x93>
			break;
		prev = it;
  8017ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ed:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  8017f0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8017f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017fc:	74 08                	je     801806 <insert_page_alloc+0x78>
  8017fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801801:	8b 40 08             	mov    0x8(%eax),%eax
  801804:	eb 05                	jmp    80180b <insert_page_alloc+0x7d>
  801806:	b8 00 00 00 00       	mov    $0x0,%eax
  80180b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801810:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801815:	85 c0                	test   %eax,%eax
  801817:	75 c7                	jne    8017e0 <insert_page_alloc+0x52>
  801819:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80181d:	75 c1                	jne    8017e0 <insert_page_alloc+0x52>
  80181f:	eb 01                	jmp    801822 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  801821:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  801822:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801826:	75 64                	jne    80188c <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  801828:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80182c:	75 14                	jne    801842 <insert_page_alloc+0xb4>
  80182e:	83 ec 04             	sub    $0x4,%esp
  801831:	68 20 44 80 00       	push   $0x804420
  801836:	6a 21                	push   $0x21
  801838:	68 11 44 80 00       	push   $0x804411
  80183d:	e8 79 ed ff ff       	call   8005bb <_panic>
  801842:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801848:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80184b:	89 50 08             	mov    %edx,0x8(%eax)
  80184e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801851:	8b 40 08             	mov    0x8(%eax),%eax
  801854:	85 c0                	test   %eax,%eax
  801856:	74 0d                	je     801865 <insert_page_alloc+0xd7>
  801858:	a1 24 50 80 00       	mov    0x805024,%eax
  80185d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801860:	89 50 0c             	mov    %edx,0xc(%eax)
  801863:	eb 08                	jmp    80186d <insert_page_alloc+0xdf>
  801865:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801868:	a3 28 50 80 00       	mov    %eax,0x805028
  80186d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801870:	a3 24 50 80 00       	mov    %eax,0x805024
  801875:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801878:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80187f:	a1 30 50 80 00       	mov    0x805030,%eax
  801884:	40                   	inc    %eax
  801885:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  80188a:	eb 71                	jmp    8018fd <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  80188c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801890:	74 06                	je     801898 <insert_page_alloc+0x10a>
  801892:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801896:	75 14                	jne    8018ac <insert_page_alloc+0x11e>
  801898:	83 ec 04             	sub    $0x4,%esp
  80189b:	68 44 44 80 00       	push   $0x804444
  8018a0:	6a 23                	push   $0x23
  8018a2:	68 11 44 80 00       	push   $0x804411
  8018a7:	e8 0f ed ff ff       	call   8005bb <_panic>
  8018ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018af:	8b 50 08             	mov    0x8(%eax),%edx
  8018b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b5:	89 50 08             	mov    %edx,0x8(%eax)
  8018b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018bb:	8b 40 08             	mov    0x8(%eax),%eax
  8018be:	85 c0                	test   %eax,%eax
  8018c0:	74 0c                	je     8018ce <insert_page_alloc+0x140>
  8018c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c5:	8b 40 08             	mov    0x8(%eax),%eax
  8018c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018cb:	89 50 0c             	mov    %edx,0xc(%eax)
  8018ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018d4:	89 50 08             	mov    %edx,0x8(%eax)
  8018d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018dd:	89 50 0c             	mov    %edx,0xc(%eax)
  8018e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018e3:	8b 40 08             	mov    0x8(%eax),%eax
  8018e6:	85 c0                	test   %eax,%eax
  8018e8:	75 08                	jne    8018f2 <insert_page_alloc+0x164>
  8018ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ed:	a3 28 50 80 00       	mov    %eax,0x805028
  8018f2:	a1 30 50 80 00       	mov    0x805030,%eax
  8018f7:	40                   	inc    %eax
  8018f8:	a3 30 50 80 00       	mov    %eax,0x805030
}
  8018fd:	90                   	nop
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  801906:	a1 24 50 80 00       	mov    0x805024,%eax
  80190b:	85 c0                	test   %eax,%eax
  80190d:	75 0c                	jne    80191b <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  80190f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801914:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  801919:	eb 67                	jmp    801982 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  80191b:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801920:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801923:	a1 24 50 80 00       	mov    0x805024,%eax
  801928:	89 45 f8             	mov    %eax,-0x8(%ebp)
  80192b:	eb 26                	jmp    801953 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  80192d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801930:	8b 10                	mov    (%eax),%edx
  801932:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801935:	8b 40 04             	mov    0x4(%eax),%eax
  801938:	01 d0                	add    %edx,%eax
  80193a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  80193d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801940:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801943:	76 06                	jbe    80194b <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  801945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801948:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80194b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801950:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801953:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801957:	74 08                	je     801961 <recompute_page_alloc_break+0x61>
  801959:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80195c:	8b 40 08             	mov    0x8(%eax),%eax
  80195f:	eb 05                	jmp    801966 <recompute_page_alloc_break+0x66>
  801961:	b8 00 00 00 00       	mov    $0x0,%eax
  801966:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80196b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801970:	85 c0                	test   %eax,%eax
  801972:	75 b9                	jne    80192d <recompute_page_alloc_break+0x2d>
  801974:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801978:	75 b3                	jne    80192d <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  80197a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80197d:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  80198a:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801991:	8b 55 08             	mov    0x8(%ebp),%edx
  801994:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801997:	01 d0                	add    %edx,%eax
  801999:	48                   	dec    %eax
  80199a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80199d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a5:	f7 75 d8             	divl   -0x28(%ebp)
  8019a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019ab:	29 d0                	sub    %edx,%eax
  8019ad:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  8019b0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8019b4:	75 0a                	jne    8019c0 <alloc_pages_custom_fit+0x3c>
		return NULL;
  8019b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019bb:	e9 7e 01 00 00       	jmp    801b3e <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  8019c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  8019c7:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  8019cb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  8019d2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  8019d9:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8019de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  8019e1:	a1 24 50 80 00       	mov    0x805024,%eax
  8019e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8019e9:	eb 69                	jmp    801a54 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  8019eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019ee:	8b 00                	mov    (%eax),%eax
  8019f0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8019f3:	76 47                	jbe    801a3c <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  8019f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019f8:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  8019fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019fe:	8b 00                	mov    (%eax),%eax
  801a00:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801a03:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  801a06:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a09:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801a0c:	72 2e                	jb     801a3c <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801a0e:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801a12:	75 14                	jne    801a28 <alloc_pages_custom_fit+0xa4>
  801a14:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a17:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801a1a:	75 0c                	jne    801a28 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  801a1c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801a1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  801a22:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801a26:	eb 14                	jmp    801a3c <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  801a28:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a2b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a2e:	76 0c                	jbe    801a3c <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  801a30:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801a33:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  801a36:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a39:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  801a3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a3f:	8b 10                	mov    (%eax),%edx
  801a41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a44:	8b 40 04             	mov    0x4(%eax),%eax
  801a47:	01 d0                	add    %edx,%eax
  801a49:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801a4c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801a51:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801a54:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a58:	74 08                	je     801a62 <alloc_pages_custom_fit+0xde>
  801a5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a5d:	8b 40 08             	mov    0x8(%eax),%eax
  801a60:	eb 05                	jmp    801a67 <alloc_pages_custom_fit+0xe3>
  801a62:	b8 00 00 00 00       	mov    $0x0,%eax
  801a67:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801a6c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801a71:	85 c0                	test   %eax,%eax
  801a73:	0f 85 72 ff ff ff    	jne    8019eb <alloc_pages_custom_fit+0x67>
  801a79:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a7d:	0f 85 68 ff ff ff    	jne    8019eb <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  801a83:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801a88:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801a8b:	76 47                	jbe    801ad4 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801a8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a90:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  801a93:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801a98:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801a9b:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801a9e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801aa1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801aa4:	72 2e                	jb     801ad4 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  801aa6:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801aaa:	75 14                	jne    801ac0 <alloc_pages_custom_fit+0x13c>
  801aac:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801aaf:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801ab2:	75 0c                	jne    801ac0 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  801ab4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801ab7:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  801aba:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801abe:	eb 14                	jmp    801ad4 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  801ac0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801ac3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801ac6:	76 0c                	jbe    801ad4 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  801ac8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801acb:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801ace:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801ad1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  801ad4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  801adb:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801adf:	74 08                	je     801ae9 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  801ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801ae7:	eb 40                	jmp    801b29 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  801ae9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801aed:	74 08                	je     801af7 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  801aef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801af2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801af5:	eb 32                	jmp    801b29 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  801af7:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801afc:	2b 45 d0             	sub    -0x30(%ebp),%eax
  801aff:	89 c2                	mov    %eax,%edx
  801b01:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801b06:	39 c2                	cmp    %eax,%edx
  801b08:	73 07                	jae    801b11 <alloc_pages_custom_fit+0x18d>
			return NULL;
  801b0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b0f:	eb 2d                	jmp    801b3e <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  801b11:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801b16:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  801b19:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801b1f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b22:	01 d0                	add    %edx,%eax
  801b24:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  801b29:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b2c:	83 ec 08             	sub    $0x8,%esp
  801b2f:	ff 75 d0             	pushl  -0x30(%ebp)
  801b32:	50                   	push   %eax
  801b33:	e8 56 fc ff ff       	call   80178e <insert_page_alloc>
  801b38:	83 c4 10             	add    $0x10,%esp

	return result;
  801b3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801b4c:	a1 24 50 80 00       	mov    0x805024,%eax
  801b51:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801b54:	eb 1a                	jmp    801b70 <find_allocated_size+0x30>
		if (it->start == va)
  801b56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b59:	8b 00                	mov    (%eax),%eax
  801b5b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b5e:	75 08                	jne    801b68 <find_allocated_size+0x28>
			return it->size;
  801b60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b63:	8b 40 04             	mov    0x4(%eax),%eax
  801b66:	eb 34                	jmp    801b9c <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801b68:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801b6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801b70:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b74:	74 08                	je     801b7e <find_allocated_size+0x3e>
  801b76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b79:	8b 40 08             	mov    0x8(%eax),%eax
  801b7c:	eb 05                	jmp    801b83 <find_allocated_size+0x43>
  801b7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b83:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801b88:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801b8d:	85 c0                	test   %eax,%eax
  801b8f:	75 c5                	jne    801b56 <find_allocated_size+0x16>
  801b91:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b95:	75 bf                	jne    801b56 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  801b97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
  801ba1:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  801ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801baa:	a1 24 50 80 00       	mov    0x805024,%eax
  801baf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bb2:	e9 e1 01 00 00       	jmp    801d98 <free_pages+0x1fa>
		if (it->start == va) {
  801bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bba:	8b 00                	mov    (%eax),%eax
  801bbc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801bbf:	0f 85 cb 01 00 00    	jne    801d90 <free_pages+0x1f2>

			uint32 start = it->start;
  801bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc8:	8b 00                	mov    (%eax),%eax
  801bca:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd0:	8b 40 04             	mov    0x4(%eax),%eax
  801bd3:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801bd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bd9:	f7 d0                	not    %eax
  801bdb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801bde:	73 1d                	jae    801bfd <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801be0:	83 ec 0c             	sub    $0xc,%esp
  801be3:	ff 75 e4             	pushl  -0x1c(%ebp)
  801be6:	ff 75 e8             	pushl  -0x18(%ebp)
  801be9:	68 78 44 80 00       	push   $0x804478
  801bee:	68 a5 00 00 00       	push   $0xa5
  801bf3:	68 11 44 80 00       	push   $0x804411
  801bf8:	e8 be e9 ff ff       	call   8005bb <_panic>
			}

			uint32 start_end = start + size;
  801bfd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c03:	01 d0                	add    %edx,%eax
  801c05:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801c08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c0b:	85 c0                	test   %eax,%eax
  801c0d:	79 19                	jns    801c28 <free_pages+0x8a>
  801c0f:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801c16:	77 10                	ja     801c28 <free_pages+0x8a>
  801c18:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801c1f:	77 07                	ja     801c28 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  801c21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c24:	85 c0                	test   %eax,%eax
  801c26:	78 2c                	js     801c54 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  801c28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c2b:	83 ec 0c             	sub    $0xc,%esp
  801c2e:	68 00 00 00 a0       	push   $0xa0000000
  801c33:	ff 75 e0             	pushl  -0x20(%ebp)
  801c36:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c39:	ff 75 e8             	pushl  -0x18(%ebp)
  801c3c:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c3f:	50                   	push   %eax
  801c40:	68 bc 44 80 00       	push   $0x8044bc
  801c45:	68 ad 00 00 00       	push   $0xad
  801c4a:	68 11 44 80 00       	push   $0x804411
  801c4f:	e8 67 e9 ff ff       	call   8005bb <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801c54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c57:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c5a:	e9 88 00 00 00       	jmp    801ce7 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  801c5f:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  801c66:	76 17                	jbe    801c7f <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  801c68:	ff 75 f0             	pushl  -0x10(%ebp)
  801c6b:	68 20 45 80 00       	push   $0x804520
  801c70:	68 b4 00 00 00       	push   $0xb4
  801c75:	68 11 44 80 00       	push   $0x804411
  801c7a:	e8 3c e9 ff ff       	call   8005bb <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  801c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c82:	05 00 10 00 00       	add    $0x1000,%eax
  801c87:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  801c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c8d:	85 c0                	test   %eax,%eax
  801c8f:	79 2e                	jns    801cbf <free_pages+0x121>
  801c91:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801c98:	77 25                	ja     801cbf <free_pages+0x121>
  801c9a:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801ca1:	77 1c                	ja     801cbf <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  801ca3:	83 ec 08             	sub    $0x8,%esp
  801ca6:	68 00 10 00 00       	push   $0x1000
  801cab:	ff 75 f0             	pushl  -0x10(%ebp)
  801cae:	e8 38 0d 00 00       	call   8029eb <sys_free_user_mem>
  801cb3:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801cb6:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801cbd:	eb 28                	jmp    801ce7 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  801cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc2:	68 00 00 00 a0       	push   $0xa0000000
  801cc7:	ff 75 dc             	pushl  -0x24(%ebp)
  801cca:	68 00 10 00 00       	push   $0x1000
  801ccf:	ff 75 f0             	pushl  -0x10(%ebp)
  801cd2:	50                   	push   %eax
  801cd3:	68 60 45 80 00       	push   $0x804560
  801cd8:	68 bd 00 00 00       	push   $0xbd
  801cdd:	68 11 44 80 00       	push   $0x804411
  801ce2:	e8 d4 e8 ff ff       	call   8005bb <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801ce7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cea:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801ced:	0f 82 6c ff ff ff    	jb     801c5f <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  801cf3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cf7:	75 17                	jne    801d10 <free_pages+0x172>
  801cf9:	83 ec 04             	sub    $0x4,%esp
  801cfc:	68 c2 45 80 00       	push   $0x8045c2
  801d01:	68 c1 00 00 00       	push   $0xc1
  801d06:	68 11 44 80 00       	push   $0x804411
  801d0b:	e8 ab e8 ff ff       	call   8005bb <_panic>
  801d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d13:	8b 40 08             	mov    0x8(%eax),%eax
  801d16:	85 c0                	test   %eax,%eax
  801d18:	74 11                	je     801d2b <free_pages+0x18d>
  801d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1d:	8b 40 08             	mov    0x8(%eax),%eax
  801d20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d23:	8b 52 0c             	mov    0xc(%edx),%edx
  801d26:	89 50 0c             	mov    %edx,0xc(%eax)
  801d29:	eb 0b                	jmp    801d36 <free_pages+0x198>
  801d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2e:	8b 40 0c             	mov    0xc(%eax),%eax
  801d31:	a3 28 50 80 00       	mov    %eax,0x805028
  801d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d39:	8b 40 0c             	mov    0xc(%eax),%eax
  801d3c:	85 c0                	test   %eax,%eax
  801d3e:	74 11                	je     801d51 <free_pages+0x1b3>
  801d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d43:	8b 40 0c             	mov    0xc(%eax),%eax
  801d46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d49:	8b 52 08             	mov    0x8(%edx),%edx
  801d4c:	89 50 08             	mov    %edx,0x8(%eax)
  801d4f:	eb 0b                	jmp    801d5c <free_pages+0x1be>
  801d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d54:	8b 40 08             	mov    0x8(%eax),%eax
  801d57:	a3 24 50 80 00       	mov    %eax,0x805024
  801d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d69:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801d70:	a1 30 50 80 00       	mov    0x805030,%eax
  801d75:	48                   	dec    %eax
  801d76:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  801d7b:	83 ec 0c             	sub    $0xc,%esp
  801d7e:	ff 75 f4             	pushl  -0xc(%ebp)
  801d81:	e8 24 15 00 00       	call   8032aa <free_block>
  801d86:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  801d89:	e8 72 fb ff ff       	call   801900 <recompute_page_alloc_break>

			return;
  801d8e:	eb 37                	jmp    801dc7 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801d90:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801d95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d9c:	74 08                	je     801da6 <free_pages+0x208>
  801d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da1:	8b 40 08             	mov    0x8(%eax),%eax
  801da4:	eb 05                	jmp    801dab <free_pages+0x20d>
  801da6:	b8 00 00 00 00       	mov    $0x0,%eax
  801dab:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801db0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801db5:	85 c0                	test   %eax,%eax
  801db7:	0f 85 fa fd ff ff    	jne    801bb7 <free_pages+0x19>
  801dbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dc1:	0f 85 f0 fd ff ff    	jne    801bb7 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  801dcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd1:	5d                   	pop    %ebp
  801dd2:	c3                   	ret    

00801dd3 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801dd9:	a1 08 50 80 00       	mov    0x805008,%eax
  801dde:	85 c0                	test   %eax,%eax
  801de0:	74 60                	je     801e42 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801de2:	83 ec 08             	sub    $0x8,%esp
  801de5:	68 00 00 00 82       	push   $0x82000000
  801dea:	68 00 00 00 80       	push   $0x80000000
  801def:	e8 0d 0d 00 00       	call   802b01 <initialize_dynamic_allocator>
  801df4:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801df7:	e8 f3 0a 00 00       	call   8028ef <sys_get_uheap_strategy>
  801dfc:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801e01:	a1 40 50 80 00       	mov    0x805040,%eax
  801e06:	05 00 10 00 00       	add    $0x1000,%eax
  801e0b:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  801e10:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e15:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  801e1a:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  801e21:	00 00 00 
  801e24:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  801e2b:	00 00 00 
  801e2e:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  801e35:	00 00 00 

		__firstTimeFlag = 0;
  801e38:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801e3f:	00 00 00 
	}
}
  801e42:	90                   	nop
  801e43:	c9                   	leave  
  801e44:	c3                   	ret    

00801e45 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
  801e48:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e54:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e59:	83 ec 08             	sub    $0x8,%esp
  801e5c:	68 06 04 00 00       	push   $0x406
  801e61:	50                   	push   %eax
  801e62:	e8 d2 06 00 00       	call   802539 <__sys_allocate_page>
  801e67:	83 c4 10             	add    $0x10,%esp
  801e6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801e6d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e71:	79 17                	jns    801e8a <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  801e73:	83 ec 04             	sub    $0x4,%esp
  801e76:	68 e0 45 80 00       	push   $0x8045e0
  801e7b:	68 ea 00 00 00       	push   $0xea
  801e80:	68 11 44 80 00       	push   $0x804411
  801e85:	e8 31 e7 ff ff       	call   8005bb <_panic>
	return 0;
  801e8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    

00801e91 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
  801e94:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801e97:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ea5:	83 ec 0c             	sub    $0xc,%esp
  801ea8:	50                   	push   %eax
  801ea9:	e8 d2 06 00 00       	call   802580 <__sys_unmap_frame>
  801eae:	83 c4 10             	add    $0x10,%esp
  801eb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801eb4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eb8:	79 17                	jns    801ed1 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  801eba:	83 ec 04             	sub    $0x4,%esp
  801ebd:	68 1c 46 80 00       	push   $0x80461c
  801ec2:	68 f5 00 00 00       	push   $0xf5
  801ec7:	68 11 44 80 00       	push   $0x804411
  801ecc:	e8 ea e6 ff ff       	call   8005bb <_panic>
}
  801ed1:	90                   	nop
  801ed2:	c9                   	leave  
  801ed3:	c3                   	ret    

00801ed4 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
  801ed7:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801eda:	e8 f4 fe ff ff       	call   801dd3 <uheap_init>
	if (size == 0) return NULL ;
  801edf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ee3:	75 0a                	jne    801eef <malloc+0x1b>
  801ee5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eea:	e9 67 01 00 00       	jmp    802056 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  801eef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801ef6:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801efd:	77 16                	ja     801f15 <malloc+0x41>
		result = alloc_block(size);
  801eff:	83 ec 0c             	sub    $0xc,%esp
  801f02:	ff 75 08             	pushl  0x8(%ebp)
  801f05:	e8 46 0e 00 00       	call   802d50 <alloc_block>
  801f0a:	83 c4 10             	add    $0x10,%esp
  801f0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f10:	e9 3e 01 00 00       	jmp    802053 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  801f15:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f1c:	8b 55 08             	mov    0x8(%ebp),%edx
  801f1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f22:	01 d0                	add    %edx,%eax
  801f24:	48                   	dec    %eax
  801f25:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f2b:	ba 00 00 00 00       	mov    $0x0,%edx
  801f30:	f7 75 f0             	divl   -0x10(%ebp)
  801f33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f36:	29 d0                	sub    %edx,%eax
  801f38:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  801f3b:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f40:	85 c0                	test   %eax,%eax
  801f42:	75 0a                	jne    801f4e <malloc+0x7a>
			return NULL;
  801f44:	b8 00 00 00 00       	mov    $0x0,%eax
  801f49:	e9 08 01 00 00       	jmp    802056 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  801f4e:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801f53:	85 c0                	test   %eax,%eax
  801f55:	74 0f                	je     801f66 <malloc+0x92>
  801f57:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801f5d:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f62:	39 c2                	cmp    %eax,%edx
  801f64:	73 0a                	jae    801f70 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  801f66:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f6b:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801f70:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801f75:	83 f8 05             	cmp    $0x5,%eax
  801f78:	75 11                	jne    801f8b <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  801f7a:	83 ec 0c             	sub    $0xc,%esp
  801f7d:	ff 75 e8             	pushl  -0x18(%ebp)
  801f80:	e8 ff f9 ff ff       	call   801984 <alloc_pages_custom_fit>
  801f85:	83 c4 10             	add    $0x10,%esp
  801f88:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  801f8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f8f:	0f 84 be 00 00 00    	je     802053 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  801f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f98:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  801f9b:	83 ec 0c             	sub    $0xc,%esp
  801f9e:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa1:	e8 9a fb ff ff       	call   801b40 <find_allocated_size>
  801fa6:	83 c4 10             	add    $0x10,%esp
  801fa9:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  801fac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fb0:	75 17                	jne    801fc9 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  801fb2:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb5:	68 5c 46 80 00       	push   $0x80465c
  801fba:	68 24 01 00 00       	push   $0x124
  801fbf:	68 11 44 80 00       	push   $0x804411
  801fc4:	e8 f2 e5 ff ff       	call   8005bb <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  801fc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fcc:	f7 d0                	not    %eax
  801fce:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801fd1:	73 1d                	jae    801ff0 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  801fd3:	83 ec 0c             	sub    $0xc,%esp
  801fd6:	ff 75 e0             	pushl  -0x20(%ebp)
  801fd9:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fdc:	68 a4 46 80 00       	push   $0x8046a4
  801fe1:	68 29 01 00 00       	push   $0x129
  801fe6:	68 11 44 80 00       	push   $0x804411
  801feb:	e8 cb e5 ff ff       	call   8005bb <_panic>
			}

			uint32 result_end = result_va + actual_size;
  801ff0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ff3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ff6:	01 d0                	add    %edx,%eax
  801ff8:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  801ffb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ffe:	85 c0                	test   %eax,%eax
  802000:	79 2c                	jns    80202e <malloc+0x15a>
  802002:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  802009:	77 23                	ja     80202e <malloc+0x15a>
  80200b:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802012:	77 1a                	ja     80202e <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  802014:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802017:	85 c0                	test   %eax,%eax
  802019:	79 13                	jns    80202e <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  80201b:	83 ec 08             	sub    $0x8,%esp
  80201e:	ff 75 e0             	pushl  -0x20(%ebp)
  802021:	ff 75 e4             	pushl  -0x1c(%ebp)
  802024:	e8 de 09 00 00       	call   802a07 <sys_allocate_user_mem>
  802029:	83 c4 10             	add    $0x10,%esp
  80202c:	eb 25                	jmp    802053 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  80202e:	68 00 00 00 a0       	push   $0xa0000000
  802033:	ff 75 dc             	pushl  -0x24(%ebp)
  802036:	ff 75 e0             	pushl  -0x20(%ebp)
  802039:	ff 75 e4             	pushl  -0x1c(%ebp)
  80203c:	ff 75 f4             	pushl  -0xc(%ebp)
  80203f:	68 e0 46 80 00       	push   $0x8046e0
  802044:	68 33 01 00 00       	push   $0x133
  802049:	68 11 44 80 00       	push   $0x804411
  80204e:	e8 68 e5 ff ff       	call   8005bb <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  802053:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  802056:	c9                   	leave  
  802057:	c3                   	ret    

00802058 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
  80205b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  80205e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802062:	0f 84 26 01 00 00    	je     80218e <free+0x136>

	uint32 addr = (uint32)virtual_address;
  802068:	8b 45 08             	mov    0x8(%ebp),%eax
  80206b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  80206e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802071:	85 c0                	test   %eax,%eax
  802073:	79 1c                	jns    802091 <free+0x39>
  802075:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  80207c:	77 13                	ja     802091 <free+0x39>
		free_block(virtual_address);
  80207e:	83 ec 0c             	sub    $0xc,%esp
  802081:	ff 75 08             	pushl  0x8(%ebp)
  802084:	e8 21 12 00 00       	call   8032aa <free_block>
  802089:	83 c4 10             	add    $0x10,%esp
		return;
  80208c:	e9 01 01 00 00       	jmp    802192 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  802091:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802096:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  802099:	0f 82 d8 00 00 00    	jb     802177 <free+0x11f>
  80209f:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  8020a6:	0f 87 cb 00 00 00    	ja     802177 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  8020ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020af:	25 ff 0f 00 00       	and    $0xfff,%eax
  8020b4:	85 c0                	test   %eax,%eax
  8020b6:	74 17                	je     8020cf <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  8020b8:	ff 75 08             	pushl  0x8(%ebp)
  8020bb:	68 50 47 80 00       	push   $0x804750
  8020c0:	68 57 01 00 00       	push   $0x157
  8020c5:	68 11 44 80 00       	push   $0x804411
  8020ca:	e8 ec e4 ff ff       	call   8005bb <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  8020cf:	83 ec 0c             	sub    $0xc,%esp
  8020d2:	ff 75 08             	pushl  0x8(%ebp)
  8020d5:	e8 66 fa ff ff       	call   801b40 <find_allocated_size>
  8020da:	83 c4 10             	add    $0x10,%esp
  8020dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  8020e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020e4:	0f 84 a7 00 00 00    	je     802191 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  8020ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ed:	f7 d0                	not    %eax
  8020ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8020f2:	73 1d                	jae    802111 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  8020f4:	83 ec 0c             	sub    $0xc,%esp
  8020f7:	ff 75 f0             	pushl  -0x10(%ebp)
  8020fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8020fd:	68 78 47 80 00       	push   $0x804778
  802102:	68 61 01 00 00       	push   $0x161
  802107:	68 11 44 80 00       	push   $0x804411
  80210c:	e8 aa e4 ff ff       	call   8005bb <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  802111:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802114:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802117:	01 d0                	add    %edx,%eax
  802119:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  80211c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211f:	85 c0                	test   %eax,%eax
  802121:	79 19                	jns    80213c <free+0xe4>
  802123:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  80212a:	77 10                	ja     80213c <free+0xe4>
  80212c:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  802133:	77 07                	ja     80213c <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  802135:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802138:	85 c0                	test   %eax,%eax
  80213a:	78 2b                	js     802167 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  80213c:	83 ec 0c             	sub    $0xc,%esp
  80213f:	68 00 00 00 a0       	push   $0xa0000000
  802144:	ff 75 ec             	pushl  -0x14(%ebp)
  802147:	ff 75 f0             	pushl  -0x10(%ebp)
  80214a:	ff 75 f4             	pushl  -0xc(%ebp)
  80214d:	ff 75 f0             	pushl  -0x10(%ebp)
  802150:	ff 75 08             	pushl  0x8(%ebp)
  802153:	68 b4 47 80 00       	push   $0x8047b4
  802158:	68 69 01 00 00       	push   $0x169
  80215d:	68 11 44 80 00       	push   $0x804411
  802162:	e8 54 e4 ff ff       	call   8005bb <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  802167:	83 ec 0c             	sub    $0xc,%esp
  80216a:	ff 75 08             	pushl  0x8(%ebp)
  80216d:	e8 2c fa ff ff       	call   801b9e <free_pages>
  802172:	83 c4 10             	add    $0x10,%esp
		return;
  802175:	eb 1b                	jmp    802192 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  802177:	ff 75 08             	pushl  0x8(%ebp)
  80217a:	68 10 48 80 00       	push   $0x804810
  80217f:	68 70 01 00 00       	push   $0x170
  802184:	68 11 44 80 00       	push   $0x804411
  802189:	e8 2d e4 ff ff       	call   8005bb <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  80218e:	90                   	nop
  80218f:	eb 01                	jmp    802192 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  802191:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  802192:	c9                   	leave  
  802193:	c3                   	ret    

00802194 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
  802197:	83 ec 38             	sub    $0x38,%esp
  80219a:	8b 45 10             	mov    0x10(%ebp),%eax
  80219d:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8021a0:	e8 2e fc ff ff       	call   801dd3 <uheap_init>
	if (size == 0) return NULL ;
  8021a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021a9:	75 0a                	jne    8021b5 <smalloc+0x21>
  8021ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b0:	e9 3d 01 00 00       	jmp    8022f2 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  8021b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  8021bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021be:	25 ff 0f 00 00       	and    $0xfff,%eax
  8021c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  8021c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021ca:	74 0e                	je     8021da <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  8021cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cf:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8021d2:	05 00 10 00 00       	add    $0x1000,%eax
  8021d7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  8021da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dd:	c1 e8 0c             	shr    $0xc,%eax
  8021e0:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  8021e3:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8021e8:	85 c0                	test   %eax,%eax
  8021ea:	75 0a                	jne    8021f6 <smalloc+0x62>
		return NULL;
  8021ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f1:	e9 fc 00 00 00       	jmp    8022f2 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8021f6:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8021fb:	85 c0                	test   %eax,%eax
  8021fd:	74 0f                	je     80220e <smalloc+0x7a>
  8021ff:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802205:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80220a:	39 c2                	cmp    %eax,%edx
  80220c:	73 0a                	jae    802218 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  80220e:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802213:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802218:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80221d:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802222:	29 c2                	sub    %eax,%edx
  802224:	89 d0                	mov    %edx,%eax
  802226:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802229:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80222f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802234:	29 c2                	sub    %eax,%edx
  802236:	89 d0                	mov    %edx,%eax
  802238:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  80223b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802241:	77 13                	ja     802256 <smalloc+0xc2>
  802243:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802246:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802249:	77 0b                	ja     802256 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  80224b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80224e:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  802251:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802254:	73 0a                	jae    802260 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  802256:	b8 00 00 00 00       	mov    $0x0,%eax
  80225b:	e9 92 00 00 00       	jmp    8022f2 <smalloc+0x15e>
	}

	void *va = NULL;
  802260:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  802267:	a1 60 d0 81 00       	mov    0x81d060,%eax
  80226c:	83 f8 05             	cmp    $0x5,%eax
  80226f:	75 11                	jne    802282 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  802271:	83 ec 0c             	sub    $0xc,%esp
  802274:	ff 75 f4             	pushl  -0xc(%ebp)
  802277:	e8 08 f7 ff ff       	call   801984 <alloc_pages_custom_fit>
  80227c:	83 c4 10             	add    $0x10,%esp
  80227f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  802282:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802286:	75 27                	jne    8022af <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802288:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  80228f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802292:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802295:	89 c2                	mov    %eax,%edx
  802297:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80229c:	39 c2                	cmp    %eax,%edx
  80229e:	73 07                	jae    8022a7 <smalloc+0x113>
			return NULL;}
  8022a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a5:	eb 4b                	jmp    8022f2 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  8022a7:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8022ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  8022af:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8022b3:	ff 75 f0             	pushl  -0x10(%ebp)
  8022b6:	50                   	push   %eax
  8022b7:	ff 75 0c             	pushl  0xc(%ebp)
  8022ba:	ff 75 08             	pushl  0x8(%ebp)
  8022bd:	e8 cb 03 00 00       	call   80268d <sys_create_shared_object>
  8022c2:	83 c4 10             	add    $0x10,%esp
  8022c5:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  8022c8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8022cc:	79 07                	jns    8022d5 <smalloc+0x141>
		return NULL;
  8022ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d3:	eb 1d                	jmp    8022f2 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  8022d5:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8022da:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8022dd:	75 10                	jne    8022ef <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  8022df:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8022e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e8:	01 d0                	add    %edx,%eax
  8022ea:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  8022ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  8022f2:	c9                   	leave  
  8022f3:	c3                   	ret    

008022f4 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8022f4:	55                   	push   %ebp
  8022f5:	89 e5                	mov    %esp,%ebp
  8022f7:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8022fa:	e8 d4 fa ff ff       	call   801dd3 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8022ff:	83 ec 08             	sub    $0x8,%esp
  802302:	ff 75 0c             	pushl  0xc(%ebp)
  802305:	ff 75 08             	pushl  0x8(%ebp)
  802308:	e8 aa 03 00 00       	call   8026b7 <sys_size_of_shared_object>
  80230d:	83 c4 10             	add    $0x10,%esp
  802310:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  802313:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802317:	7f 0a                	jg     802323 <sget+0x2f>
		return NULL;
  802319:	b8 00 00 00 00       	mov    $0x0,%eax
  80231e:	e9 32 01 00 00       	jmp    802455 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  802323:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802326:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  802329:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80232c:	25 ff 0f 00 00       	and    $0xfff,%eax
  802331:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  802334:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802338:	74 0e                	je     802348 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  80233a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802340:	05 00 10 00 00       	add    $0x1000,%eax
  802345:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  802348:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80234d:	85 c0                	test   %eax,%eax
  80234f:	75 0a                	jne    80235b <sget+0x67>
		return NULL;
  802351:	b8 00 00 00 00       	mov    $0x0,%eax
  802356:	e9 fa 00 00 00       	jmp    802455 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  80235b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802360:	85 c0                	test   %eax,%eax
  802362:	74 0f                	je     802373 <sget+0x7f>
  802364:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80236a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80236f:	39 c2                	cmp    %eax,%edx
  802371:	73 0a                	jae    80237d <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  802373:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802378:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  80237d:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802382:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802387:	29 c2                	sub    %eax,%edx
  802389:	89 d0                	mov    %edx,%eax
  80238b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  80238e:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802394:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802399:	29 c2                	sub    %eax,%edx
  80239b:	89 d0                	mov    %edx,%eax
  80239d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8023a6:	77 13                	ja     8023bb <sget+0xc7>
  8023a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023ab:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8023ae:	77 0b                	ja     8023bb <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  8023b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023b3:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8023b6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8023b9:	73 0a                	jae    8023c5 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  8023bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c0:	e9 90 00 00 00       	jmp    802455 <sget+0x161>

	void *va = NULL;
  8023c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  8023cc:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8023d1:	83 f8 05             	cmp    $0x5,%eax
  8023d4:	75 11                	jne    8023e7 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  8023d6:	83 ec 0c             	sub    $0xc,%esp
  8023d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8023dc:	e8 a3 f5 ff ff       	call   801984 <alloc_pages_custom_fit>
  8023e1:	83 c4 10             	add    $0x10,%esp
  8023e4:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  8023e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023eb:	75 27                	jne    802414 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8023ed:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  8023f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023f7:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8023fa:	89 c2                	mov    %eax,%edx
  8023fc:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802401:	39 c2                	cmp    %eax,%edx
  802403:	73 07                	jae    80240c <sget+0x118>
			return NULL;
  802405:	b8 00 00 00 00       	mov    $0x0,%eax
  80240a:	eb 49                	jmp    802455 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  80240c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802411:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  802414:	83 ec 04             	sub    $0x4,%esp
  802417:	ff 75 f0             	pushl  -0x10(%ebp)
  80241a:	ff 75 0c             	pushl  0xc(%ebp)
  80241d:	ff 75 08             	pushl  0x8(%ebp)
  802420:	e8 af 02 00 00       	call   8026d4 <sys_get_shared_object>
  802425:	83 c4 10             	add    $0x10,%esp
  802428:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  80242b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80242f:	79 07                	jns    802438 <sget+0x144>
		return NULL;
  802431:	b8 00 00 00 00       	mov    $0x0,%eax
  802436:	eb 1d                	jmp    802455 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  802438:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80243d:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802440:	75 10                	jne    802452 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  802442:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244b:	01 d0                	add    %edx,%eax
  80244d:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  802452:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  802455:	c9                   	leave  
  802456:	c3                   	ret    

00802457 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802457:	55                   	push   %ebp
  802458:	89 e5                	mov    %esp,%ebp
  80245a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80245d:	e8 71 f9 ff ff       	call   801dd3 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802462:	83 ec 04             	sub    $0x4,%esp
  802465:	68 34 48 80 00       	push   $0x804834
  80246a:	68 19 02 00 00       	push   $0x219
  80246f:	68 11 44 80 00       	push   $0x804411
  802474:	e8 42 e1 ff ff       	call   8005bb <_panic>

00802479 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802479:	55                   	push   %ebp
  80247a:	89 e5                	mov    %esp,%ebp
  80247c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80247f:	83 ec 04             	sub    $0x4,%esp
  802482:	68 5c 48 80 00       	push   $0x80485c
  802487:	68 2b 02 00 00       	push   $0x22b
  80248c:	68 11 44 80 00       	push   $0x804411
  802491:	e8 25 e1 ff ff       	call   8005bb <_panic>

00802496 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
  802499:	57                   	push   %edi
  80249a:	56                   	push   %esi
  80249b:	53                   	push   %ebx
  80249c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80249f:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024a8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024ab:	8b 7d 18             	mov    0x18(%ebp),%edi
  8024ae:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8024b1:	cd 30                	int    $0x30
  8024b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8024b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8024b9:	83 c4 10             	add    $0x10,%esp
  8024bc:	5b                   	pop    %ebx
  8024bd:	5e                   	pop    %esi
  8024be:	5f                   	pop    %edi
  8024bf:	5d                   	pop    %ebp
  8024c0:	c3                   	ret    

008024c1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8024c1:	55                   	push   %ebp
  8024c2:	89 e5                	mov    %esp,%ebp
  8024c4:	83 ec 04             	sub    $0x4,%esp
  8024c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8024cd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024d0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8024d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d7:	6a 00                	push   $0x0
  8024d9:	51                   	push   %ecx
  8024da:	52                   	push   %edx
  8024db:	ff 75 0c             	pushl  0xc(%ebp)
  8024de:	50                   	push   %eax
  8024df:	6a 00                	push   $0x0
  8024e1:	e8 b0 ff ff ff       	call   802496 <syscall>
  8024e6:	83 c4 18             	add    $0x18,%esp
}
  8024e9:	90                   	nop
  8024ea:	c9                   	leave  
  8024eb:	c3                   	ret    

008024ec <sys_cgetc>:

int
sys_cgetc(void)
{
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8024ef:	6a 00                	push   $0x0
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 02                	push   $0x2
  8024fb:	e8 96 ff ff ff       	call   802496 <syscall>
  802500:	83 c4 18             	add    $0x18,%esp
}
  802503:	c9                   	leave  
  802504:	c3                   	ret    

00802505 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802505:	55                   	push   %ebp
  802506:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 03                	push   $0x3
  802514:	e8 7d ff ff ff       	call   802496 <syscall>
  802519:	83 c4 18             	add    $0x18,%esp
}
  80251c:	90                   	nop
  80251d:	c9                   	leave  
  80251e:	c3                   	ret    

0080251f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80251f:	55                   	push   %ebp
  802520:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802522:	6a 00                	push   $0x0
  802524:	6a 00                	push   $0x0
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	6a 04                	push   $0x4
  80252e:	e8 63 ff ff ff       	call   802496 <syscall>
  802533:	83 c4 18             	add    $0x18,%esp
}
  802536:	90                   	nop
  802537:	c9                   	leave  
  802538:	c3                   	ret    

00802539 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802539:	55                   	push   %ebp
  80253a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80253c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80253f:	8b 45 08             	mov    0x8(%ebp),%eax
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	6a 00                	push   $0x0
  802548:	52                   	push   %edx
  802549:	50                   	push   %eax
  80254a:	6a 08                	push   $0x8
  80254c:	e8 45 ff ff ff       	call   802496 <syscall>
  802551:	83 c4 18             	add    $0x18,%esp
}
  802554:	c9                   	leave  
  802555:	c3                   	ret    

00802556 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802556:	55                   	push   %ebp
  802557:	89 e5                	mov    %esp,%ebp
  802559:	56                   	push   %esi
  80255a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80255b:	8b 75 18             	mov    0x18(%ebp),%esi
  80255e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802561:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802564:	8b 55 0c             	mov    0xc(%ebp),%edx
  802567:	8b 45 08             	mov    0x8(%ebp),%eax
  80256a:	56                   	push   %esi
  80256b:	53                   	push   %ebx
  80256c:	51                   	push   %ecx
  80256d:	52                   	push   %edx
  80256e:	50                   	push   %eax
  80256f:	6a 09                	push   $0x9
  802571:	e8 20 ff ff ff       	call   802496 <syscall>
  802576:	83 c4 18             	add    $0x18,%esp
}
  802579:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80257c:	5b                   	pop    %ebx
  80257d:	5e                   	pop    %esi
  80257e:	5d                   	pop    %ebp
  80257f:	c3                   	ret    

00802580 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802580:	55                   	push   %ebp
  802581:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802583:	6a 00                	push   $0x0
  802585:	6a 00                	push   $0x0
  802587:	6a 00                	push   $0x0
  802589:	6a 00                	push   $0x0
  80258b:	ff 75 08             	pushl  0x8(%ebp)
  80258e:	6a 0a                	push   $0xa
  802590:	e8 01 ff ff ff       	call   802496 <syscall>
  802595:	83 c4 18             	add    $0x18,%esp
}
  802598:	c9                   	leave  
  802599:	c3                   	ret    

0080259a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80259a:	55                   	push   %ebp
  80259b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80259d:	6a 00                	push   $0x0
  80259f:	6a 00                	push   $0x0
  8025a1:	6a 00                	push   $0x0
  8025a3:	ff 75 0c             	pushl  0xc(%ebp)
  8025a6:	ff 75 08             	pushl  0x8(%ebp)
  8025a9:	6a 0b                	push   $0xb
  8025ab:	e8 e6 fe ff ff       	call   802496 <syscall>
  8025b0:	83 c4 18             	add    $0x18,%esp
}
  8025b3:	c9                   	leave  
  8025b4:	c3                   	ret    

008025b5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8025b5:	55                   	push   %ebp
  8025b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8025b8:	6a 00                	push   $0x0
  8025ba:	6a 00                	push   $0x0
  8025bc:	6a 00                	push   $0x0
  8025be:	6a 00                	push   $0x0
  8025c0:	6a 00                	push   $0x0
  8025c2:	6a 0c                	push   $0xc
  8025c4:	e8 cd fe ff ff       	call   802496 <syscall>
  8025c9:	83 c4 18             	add    $0x18,%esp
}
  8025cc:	c9                   	leave  
  8025cd:	c3                   	ret    

008025ce <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8025ce:	55                   	push   %ebp
  8025cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8025d1:	6a 00                	push   $0x0
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 0d                	push   $0xd
  8025dd:	e8 b4 fe ff ff       	call   802496 <syscall>
  8025e2:	83 c4 18             	add    $0x18,%esp
}
  8025e5:	c9                   	leave  
  8025e6:	c3                   	ret    

008025e7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8025e7:	55                   	push   %ebp
  8025e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 0e                	push   $0xe
  8025f6:	e8 9b fe ff ff       	call   802496 <syscall>
  8025fb:	83 c4 18             	add    $0x18,%esp
}
  8025fe:	c9                   	leave  
  8025ff:	c3                   	ret    

00802600 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802600:	55                   	push   %ebp
  802601:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802603:	6a 00                	push   $0x0
  802605:	6a 00                	push   $0x0
  802607:	6a 00                	push   $0x0
  802609:	6a 00                	push   $0x0
  80260b:	6a 00                	push   $0x0
  80260d:	6a 0f                	push   $0xf
  80260f:	e8 82 fe ff ff       	call   802496 <syscall>
  802614:	83 c4 18             	add    $0x18,%esp
}
  802617:	c9                   	leave  
  802618:	c3                   	ret    

00802619 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802619:	55                   	push   %ebp
  80261a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80261c:	6a 00                	push   $0x0
  80261e:	6a 00                	push   $0x0
  802620:	6a 00                	push   $0x0
  802622:	6a 00                	push   $0x0
  802624:	ff 75 08             	pushl  0x8(%ebp)
  802627:	6a 10                	push   $0x10
  802629:	e8 68 fe ff ff       	call   802496 <syscall>
  80262e:	83 c4 18             	add    $0x18,%esp
}
  802631:	c9                   	leave  
  802632:	c3                   	ret    

00802633 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802633:	55                   	push   %ebp
  802634:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802636:	6a 00                	push   $0x0
  802638:	6a 00                	push   $0x0
  80263a:	6a 00                	push   $0x0
  80263c:	6a 00                	push   $0x0
  80263e:	6a 00                	push   $0x0
  802640:	6a 11                	push   $0x11
  802642:	e8 4f fe ff ff       	call   802496 <syscall>
  802647:	83 c4 18             	add    $0x18,%esp
}
  80264a:	90                   	nop
  80264b:	c9                   	leave  
  80264c:	c3                   	ret    

0080264d <sys_cputc>:

void
sys_cputc(const char c)
{
  80264d:	55                   	push   %ebp
  80264e:	89 e5                	mov    %esp,%ebp
  802650:	83 ec 04             	sub    $0x4,%esp
  802653:	8b 45 08             	mov    0x8(%ebp),%eax
  802656:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802659:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80265d:	6a 00                	push   $0x0
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	50                   	push   %eax
  802666:	6a 01                	push   $0x1
  802668:	e8 29 fe ff ff       	call   802496 <syscall>
  80266d:	83 c4 18             	add    $0x18,%esp
}
  802670:	90                   	nop
  802671:	c9                   	leave  
  802672:	c3                   	ret    

00802673 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802673:	55                   	push   %ebp
  802674:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802676:	6a 00                	push   $0x0
  802678:	6a 00                	push   $0x0
  80267a:	6a 00                	push   $0x0
  80267c:	6a 00                	push   $0x0
  80267e:	6a 00                	push   $0x0
  802680:	6a 14                	push   $0x14
  802682:	e8 0f fe ff ff       	call   802496 <syscall>
  802687:	83 c4 18             	add    $0x18,%esp
}
  80268a:	90                   	nop
  80268b:	c9                   	leave  
  80268c:	c3                   	ret    

0080268d <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80268d:	55                   	push   %ebp
  80268e:	89 e5                	mov    %esp,%ebp
  802690:	83 ec 04             	sub    $0x4,%esp
  802693:	8b 45 10             	mov    0x10(%ebp),%eax
  802696:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802699:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80269c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8026a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a3:	6a 00                	push   $0x0
  8026a5:	51                   	push   %ecx
  8026a6:	52                   	push   %edx
  8026a7:	ff 75 0c             	pushl  0xc(%ebp)
  8026aa:	50                   	push   %eax
  8026ab:	6a 15                	push   $0x15
  8026ad:	e8 e4 fd ff ff       	call   802496 <syscall>
  8026b2:	83 c4 18             	add    $0x18,%esp
}
  8026b5:	c9                   	leave  
  8026b6:	c3                   	ret    

008026b7 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8026b7:	55                   	push   %ebp
  8026b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8026ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 00                	push   $0x0
  8026c4:	6a 00                	push   $0x0
  8026c6:	52                   	push   %edx
  8026c7:	50                   	push   %eax
  8026c8:	6a 16                	push   $0x16
  8026ca:	e8 c7 fd ff ff       	call   802496 <syscall>
  8026cf:	83 c4 18             	add    $0x18,%esp
}
  8026d2:	c9                   	leave  
  8026d3:	c3                   	ret    

008026d4 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8026d4:	55                   	push   %ebp
  8026d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8026d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e0:	6a 00                	push   $0x0
  8026e2:	6a 00                	push   $0x0
  8026e4:	51                   	push   %ecx
  8026e5:	52                   	push   %edx
  8026e6:	50                   	push   %eax
  8026e7:	6a 17                	push   $0x17
  8026e9:	e8 a8 fd ff ff       	call   802496 <syscall>
  8026ee:	83 c4 18             	add    $0x18,%esp
}
  8026f1:	c9                   	leave  
  8026f2:	c3                   	ret    

008026f3 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8026f3:	55                   	push   %ebp
  8026f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8026f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fc:	6a 00                	push   $0x0
  8026fe:	6a 00                	push   $0x0
  802700:	6a 00                	push   $0x0
  802702:	52                   	push   %edx
  802703:	50                   	push   %eax
  802704:	6a 18                	push   $0x18
  802706:	e8 8b fd ff ff       	call   802496 <syscall>
  80270b:	83 c4 18             	add    $0x18,%esp
}
  80270e:	c9                   	leave  
  80270f:	c3                   	ret    

00802710 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802710:	55                   	push   %ebp
  802711:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802713:	8b 45 08             	mov    0x8(%ebp),%eax
  802716:	6a 00                	push   $0x0
  802718:	ff 75 14             	pushl  0x14(%ebp)
  80271b:	ff 75 10             	pushl  0x10(%ebp)
  80271e:	ff 75 0c             	pushl  0xc(%ebp)
  802721:	50                   	push   %eax
  802722:	6a 19                	push   $0x19
  802724:	e8 6d fd ff ff       	call   802496 <syscall>
  802729:	83 c4 18             	add    $0x18,%esp
}
  80272c:	c9                   	leave  
  80272d:	c3                   	ret    

0080272e <sys_run_env>:

void sys_run_env(int32 envId)
{
  80272e:	55                   	push   %ebp
  80272f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802731:	8b 45 08             	mov    0x8(%ebp),%eax
  802734:	6a 00                	push   $0x0
  802736:	6a 00                	push   $0x0
  802738:	6a 00                	push   $0x0
  80273a:	6a 00                	push   $0x0
  80273c:	50                   	push   %eax
  80273d:	6a 1a                	push   $0x1a
  80273f:	e8 52 fd ff ff       	call   802496 <syscall>
  802744:	83 c4 18             	add    $0x18,%esp
}
  802747:	90                   	nop
  802748:	c9                   	leave  
  802749:	c3                   	ret    

0080274a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80274a:	55                   	push   %ebp
  80274b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80274d:	8b 45 08             	mov    0x8(%ebp),%eax
  802750:	6a 00                	push   $0x0
  802752:	6a 00                	push   $0x0
  802754:	6a 00                	push   $0x0
  802756:	6a 00                	push   $0x0
  802758:	50                   	push   %eax
  802759:	6a 1b                	push   $0x1b
  80275b:	e8 36 fd ff ff       	call   802496 <syscall>
  802760:	83 c4 18             	add    $0x18,%esp
}
  802763:	c9                   	leave  
  802764:	c3                   	ret    

00802765 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802765:	55                   	push   %ebp
  802766:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802768:	6a 00                	push   $0x0
  80276a:	6a 00                	push   $0x0
  80276c:	6a 00                	push   $0x0
  80276e:	6a 00                	push   $0x0
  802770:	6a 00                	push   $0x0
  802772:	6a 05                	push   $0x5
  802774:	e8 1d fd ff ff       	call   802496 <syscall>
  802779:	83 c4 18             	add    $0x18,%esp
}
  80277c:	c9                   	leave  
  80277d:	c3                   	ret    

0080277e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80277e:	55                   	push   %ebp
  80277f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802781:	6a 00                	push   $0x0
  802783:	6a 00                	push   $0x0
  802785:	6a 00                	push   $0x0
  802787:	6a 00                	push   $0x0
  802789:	6a 00                	push   $0x0
  80278b:	6a 06                	push   $0x6
  80278d:	e8 04 fd ff ff       	call   802496 <syscall>
  802792:	83 c4 18             	add    $0x18,%esp
}
  802795:	c9                   	leave  
  802796:	c3                   	ret    

00802797 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802797:	55                   	push   %ebp
  802798:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80279a:	6a 00                	push   $0x0
  80279c:	6a 00                	push   $0x0
  80279e:	6a 00                	push   $0x0
  8027a0:	6a 00                	push   $0x0
  8027a2:	6a 00                	push   $0x0
  8027a4:	6a 07                	push   $0x7
  8027a6:	e8 eb fc ff ff       	call   802496 <syscall>
  8027ab:	83 c4 18             	add    $0x18,%esp
}
  8027ae:	c9                   	leave  
  8027af:	c3                   	ret    

008027b0 <sys_exit_env>:


void sys_exit_env(void)
{
  8027b0:	55                   	push   %ebp
  8027b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8027b3:	6a 00                	push   $0x0
  8027b5:	6a 00                	push   $0x0
  8027b7:	6a 00                	push   $0x0
  8027b9:	6a 00                	push   $0x0
  8027bb:	6a 00                	push   $0x0
  8027bd:	6a 1c                	push   $0x1c
  8027bf:	e8 d2 fc ff ff       	call   802496 <syscall>
  8027c4:	83 c4 18             	add    $0x18,%esp
}
  8027c7:	90                   	nop
  8027c8:	c9                   	leave  
  8027c9:	c3                   	ret    

008027ca <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8027ca:	55                   	push   %ebp
  8027cb:	89 e5                	mov    %esp,%ebp
  8027cd:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8027d0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8027d3:	8d 50 04             	lea    0x4(%eax),%edx
  8027d6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8027d9:	6a 00                	push   $0x0
  8027db:	6a 00                	push   $0x0
  8027dd:	6a 00                	push   $0x0
  8027df:	52                   	push   %edx
  8027e0:	50                   	push   %eax
  8027e1:	6a 1d                	push   $0x1d
  8027e3:	e8 ae fc ff ff       	call   802496 <syscall>
  8027e8:	83 c4 18             	add    $0x18,%esp
	return result;
  8027eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8027f4:	89 01                	mov    %eax,(%ecx)
  8027f6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8027f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fc:	c9                   	leave  
  8027fd:	c2 04 00             	ret    $0x4

00802800 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802800:	55                   	push   %ebp
  802801:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802803:	6a 00                	push   $0x0
  802805:	6a 00                	push   $0x0
  802807:	ff 75 10             	pushl  0x10(%ebp)
  80280a:	ff 75 0c             	pushl  0xc(%ebp)
  80280d:	ff 75 08             	pushl  0x8(%ebp)
  802810:	6a 13                	push   $0x13
  802812:	e8 7f fc ff ff       	call   802496 <syscall>
  802817:	83 c4 18             	add    $0x18,%esp
	return ;
  80281a:	90                   	nop
}
  80281b:	c9                   	leave  
  80281c:	c3                   	ret    

0080281d <sys_rcr2>:
uint32 sys_rcr2()
{
  80281d:	55                   	push   %ebp
  80281e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802820:	6a 00                	push   $0x0
  802822:	6a 00                	push   $0x0
  802824:	6a 00                	push   $0x0
  802826:	6a 00                	push   $0x0
  802828:	6a 00                	push   $0x0
  80282a:	6a 1e                	push   $0x1e
  80282c:	e8 65 fc ff ff       	call   802496 <syscall>
  802831:	83 c4 18             	add    $0x18,%esp
}
  802834:	c9                   	leave  
  802835:	c3                   	ret    

00802836 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802836:	55                   	push   %ebp
  802837:	89 e5                	mov    %esp,%ebp
  802839:	83 ec 04             	sub    $0x4,%esp
  80283c:	8b 45 08             	mov    0x8(%ebp),%eax
  80283f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802842:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802846:	6a 00                	push   $0x0
  802848:	6a 00                	push   $0x0
  80284a:	6a 00                	push   $0x0
  80284c:	6a 00                	push   $0x0
  80284e:	50                   	push   %eax
  80284f:	6a 1f                	push   $0x1f
  802851:	e8 40 fc ff ff       	call   802496 <syscall>
  802856:	83 c4 18             	add    $0x18,%esp
	return ;
  802859:	90                   	nop
}
  80285a:	c9                   	leave  
  80285b:	c3                   	ret    

0080285c <rsttst>:
void rsttst()
{
  80285c:	55                   	push   %ebp
  80285d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80285f:	6a 00                	push   $0x0
  802861:	6a 00                	push   $0x0
  802863:	6a 00                	push   $0x0
  802865:	6a 00                	push   $0x0
  802867:	6a 00                	push   $0x0
  802869:	6a 21                	push   $0x21
  80286b:	e8 26 fc ff ff       	call   802496 <syscall>
  802870:	83 c4 18             	add    $0x18,%esp
	return ;
  802873:	90                   	nop
}
  802874:	c9                   	leave  
  802875:	c3                   	ret    

00802876 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802876:	55                   	push   %ebp
  802877:	89 e5                	mov    %esp,%ebp
  802879:	83 ec 04             	sub    $0x4,%esp
  80287c:	8b 45 14             	mov    0x14(%ebp),%eax
  80287f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802882:	8b 55 18             	mov    0x18(%ebp),%edx
  802885:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802889:	52                   	push   %edx
  80288a:	50                   	push   %eax
  80288b:	ff 75 10             	pushl  0x10(%ebp)
  80288e:	ff 75 0c             	pushl  0xc(%ebp)
  802891:	ff 75 08             	pushl  0x8(%ebp)
  802894:	6a 20                	push   $0x20
  802896:	e8 fb fb ff ff       	call   802496 <syscall>
  80289b:	83 c4 18             	add    $0x18,%esp
	return ;
  80289e:	90                   	nop
}
  80289f:	c9                   	leave  
  8028a0:	c3                   	ret    

008028a1 <chktst>:
void chktst(uint32 n)
{
  8028a1:	55                   	push   %ebp
  8028a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8028a4:	6a 00                	push   $0x0
  8028a6:	6a 00                	push   $0x0
  8028a8:	6a 00                	push   $0x0
  8028aa:	6a 00                	push   $0x0
  8028ac:	ff 75 08             	pushl  0x8(%ebp)
  8028af:	6a 22                	push   $0x22
  8028b1:	e8 e0 fb ff ff       	call   802496 <syscall>
  8028b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8028b9:	90                   	nop
}
  8028ba:	c9                   	leave  
  8028bb:	c3                   	ret    

008028bc <inctst>:

void inctst()
{
  8028bc:	55                   	push   %ebp
  8028bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8028bf:	6a 00                	push   $0x0
  8028c1:	6a 00                	push   $0x0
  8028c3:	6a 00                	push   $0x0
  8028c5:	6a 00                	push   $0x0
  8028c7:	6a 00                	push   $0x0
  8028c9:	6a 23                	push   $0x23
  8028cb:	e8 c6 fb ff ff       	call   802496 <syscall>
  8028d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8028d3:	90                   	nop
}
  8028d4:	c9                   	leave  
  8028d5:	c3                   	ret    

008028d6 <gettst>:
uint32 gettst()
{
  8028d6:	55                   	push   %ebp
  8028d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8028d9:	6a 00                	push   $0x0
  8028db:	6a 00                	push   $0x0
  8028dd:	6a 00                	push   $0x0
  8028df:	6a 00                	push   $0x0
  8028e1:	6a 00                	push   $0x0
  8028e3:	6a 24                	push   $0x24
  8028e5:	e8 ac fb ff ff       	call   802496 <syscall>
  8028ea:	83 c4 18             	add    $0x18,%esp
}
  8028ed:	c9                   	leave  
  8028ee:	c3                   	ret    

008028ef <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8028ef:	55                   	push   %ebp
  8028f0:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028f2:	6a 00                	push   $0x0
  8028f4:	6a 00                	push   $0x0
  8028f6:	6a 00                	push   $0x0
  8028f8:	6a 00                	push   $0x0
  8028fa:	6a 00                	push   $0x0
  8028fc:	6a 25                	push   $0x25
  8028fe:	e8 93 fb ff ff       	call   802496 <syscall>
  802903:	83 c4 18             	add    $0x18,%esp
  802906:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  80290b:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  802910:	c9                   	leave  
  802911:	c3                   	ret    

00802912 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802912:	55                   	push   %ebp
  802913:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802915:	8b 45 08             	mov    0x8(%ebp),%eax
  802918:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80291d:	6a 00                	push   $0x0
  80291f:	6a 00                	push   $0x0
  802921:	6a 00                	push   $0x0
  802923:	6a 00                	push   $0x0
  802925:	ff 75 08             	pushl  0x8(%ebp)
  802928:	6a 26                	push   $0x26
  80292a:	e8 67 fb ff ff       	call   802496 <syscall>
  80292f:	83 c4 18             	add    $0x18,%esp
	return ;
  802932:	90                   	nop
}
  802933:	c9                   	leave  
  802934:	c3                   	ret    

00802935 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802935:	55                   	push   %ebp
  802936:	89 e5                	mov    %esp,%ebp
  802938:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802939:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80293c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80293f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802942:	8b 45 08             	mov    0x8(%ebp),%eax
  802945:	6a 00                	push   $0x0
  802947:	53                   	push   %ebx
  802948:	51                   	push   %ecx
  802949:	52                   	push   %edx
  80294a:	50                   	push   %eax
  80294b:	6a 27                	push   $0x27
  80294d:	e8 44 fb ff ff       	call   802496 <syscall>
  802952:	83 c4 18             	add    $0x18,%esp
}
  802955:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802958:	c9                   	leave  
  802959:	c3                   	ret    

0080295a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80295a:	55                   	push   %ebp
  80295b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80295d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802960:	8b 45 08             	mov    0x8(%ebp),%eax
  802963:	6a 00                	push   $0x0
  802965:	6a 00                	push   $0x0
  802967:	6a 00                	push   $0x0
  802969:	52                   	push   %edx
  80296a:	50                   	push   %eax
  80296b:	6a 28                	push   $0x28
  80296d:	e8 24 fb ff ff       	call   802496 <syscall>
  802972:	83 c4 18             	add    $0x18,%esp
}
  802975:	c9                   	leave  
  802976:	c3                   	ret    

00802977 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802977:	55                   	push   %ebp
  802978:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80297a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80297d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802980:	8b 45 08             	mov    0x8(%ebp),%eax
  802983:	6a 00                	push   $0x0
  802985:	51                   	push   %ecx
  802986:	ff 75 10             	pushl  0x10(%ebp)
  802989:	52                   	push   %edx
  80298a:	50                   	push   %eax
  80298b:	6a 29                	push   $0x29
  80298d:	e8 04 fb ff ff       	call   802496 <syscall>
  802992:	83 c4 18             	add    $0x18,%esp
}
  802995:	c9                   	leave  
  802996:	c3                   	ret    

00802997 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802997:	55                   	push   %ebp
  802998:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80299a:	6a 00                	push   $0x0
  80299c:	6a 00                	push   $0x0
  80299e:	ff 75 10             	pushl  0x10(%ebp)
  8029a1:	ff 75 0c             	pushl  0xc(%ebp)
  8029a4:	ff 75 08             	pushl  0x8(%ebp)
  8029a7:	6a 12                	push   $0x12
  8029a9:	e8 e8 fa ff ff       	call   802496 <syscall>
  8029ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8029b1:	90                   	nop
}
  8029b2:	c9                   	leave  
  8029b3:	c3                   	ret    

008029b4 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8029b4:	55                   	push   %ebp
  8029b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8029b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bd:	6a 00                	push   $0x0
  8029bf:	6a 00                	push   $0x0
  8029c1:	6a 00                	push   $0x0
  8029c3:	52                   	push   %edx
  8029c4:	50                   	push   %eax
  8029c5:	6a 2a                	push   $0x2a
  8029c7:	e8 ca fa ff ff       	call   802496 <syscall>
  8029cc:	83 c4 18             	add    $0x18,%esp
	return;
  8029cf:	90                   	nop
}
  8029d0:	c9                   	leave  
  8029d1:	c3                   	ret    

008029d2 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8029d2:	55                   	push   %ebp
  8029d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8029d5:	6a 00                	push   $0x0
  8029d7:	6a 00                	push   $0x0
  8029d9:	6a 00                	push   $0x0
  8029db:	6a 00                	push   $0x0
  8029dd:	6a 00                	push   $0x0
  8029df:	6a 2b                	push   $0x2b
  8029e1:	e8 b0 fa ff ff       	call   802496 <syscall>
  8029e6:	83 c4 18             	add    $0x18,%esp
}
  8029e9:	c9                   	leave  
  8029ea:	c3                   	ret    

008029eb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8029eb:	55                   	push   %ebp
  8029ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8029ee:	6a 00                	push   $0x0
  8029f0:	6a 00                	push   $0x0
  8029f2:	6a 00                	push   $0x0
  8029f4:	ff 75 0c             	pushl  0xc(%ebp)
  8029f7:	ff 75 08             	pushl  0x8(%ebp)
  8029fa:	6a 2d                	push   $0x2d
  8029fc:	e8 95 fa ff ff       	call   802496 <syscall>
  802a01:	83 c4 18             	add    $0x18,%esp
	return;
  802a04:	90                   	nop
}
  802a05:	c9                   	leave  
  802a06:	c3                   	ret    

00802a07 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802a07:	55                   	push   %ebp
  802a08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802a0a:	6a 00                	push   $0x0
  802a0c:	6a 00                	push   $0x0
  802a0e:	6a 00                	push   $0x0
  802a10:	ff 75 0c             	pushl  0xc(%ebp)
  802a13:	ff 75 08             	pushl  0x8(%ebp)
  802a16:	6a 2c                	push   $0x2c
  802a18:	e8 79 fa ff ff       	call   802496 <syscall>
  802a1d:	83 c4 18             	add    $0x18,%esp
	return ;
  802a20:	90                   	nop
}
  802a21:	c9                   	leave  
  802a22:	c3                   	ret    

00802a23 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802a23:	55                   	push   %ebp
  802a24:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802a26:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a29:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2c:	6a 00                	push   $0x0
  802a2e:	6a 00                	push   $0x0
  802a30:	6a 00                	push   $0x0
  802a32:	52                   	push   %edx
  802a33:	50                   	push   %eax
  802a34:	6a 2e                	push   $0x2e
  802a36:	e8 5b fa ff ff       	call   802496 <syscall>
  802a3b:	83 c4 18             	add    $0x18,%esp
	return ;
  802a3e:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  802a3f:	c9                   	leave  
  802a40:	c3                   	ret    

00802a41 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802a41:	55                   	push   %ebp
  802a42:	89 e5                	mov    %esp,%ebp
  802a44:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802a47:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  802a4e:	72 09                	jb     802a59 <to_page_va+0x18>
  802a50:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  802a57:	72 14                	jb     802a6d <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802a59:	83 ec 04             	sub    $0x4,%esp
  802a5c:	68 80 48 80 00       	push   $0x804880
  802a61:	6a 15                	push   $0x15
  802a63:	68 ab 48 80 00       	push   $0x8048ab
  802a68:	e8 4e db ff ff       	call   8005bb <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a70:	ba 60 50 80 00       	mov    $0x805060,%edx
  802a75:	29 d0                	sub    %edx,%eax
  802a77:	c1 f8 02             	sar    $0x2,%eax
  802a7a:	89 c2                	mov    %eax,%edx
  802a7c:	89 d0                	mov    %edx,%eax
  802a7e:	c1 e0 02             	shl    $0x2,%eax
  802a81:	01 d0                	add    %edx,%eax
  802a83:	c1 e0 02             	shl    $0x2,%eax
  802a86:	01 d0                	add    %edx,%eax
  802a88:	c1 e0 02             	shl    $0x2,%eax
  802a8b:	01 d0                	add    %edx,%eax
  802a8d:	89 c1                	mov    %eax,%ecx
  802a8f:	c1 e1 08             	shl    $0x8,%ecx
  802a92:	01 c8                	add    %ecx,%eax
  802a94:	89 c1                	mov    %eax,%ecx
  802a96:	c1 e1 10             	shl    $0x10,%ecx
  802a99:	01 c8                	add    %ecx,%eax
  802a9b:	01 c0                	add    %eax,%eax
  802a9d:	01 d0                	add    %edx,%eax
  802a9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa5:	c1 e0 0c             	shl    $0xc,%eax
  802aa8:	89 c2                	mov    %eax,%edx
  802aaa:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802aaf:	01 d0                	add    %edx,%eax
}
  802ab1:	c9                   	leave  
  802ab2:	c3                   	ret    

00802ab3 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802ab3:	55                   	push   %ebp
  802ab4:	89 e5                	mov    %esp,%ebp
  802ab6:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802ab9:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802abe:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac1:	29 c2                	sub    %eax,%edx
  802ac3:	89 d0                	mov    %edx,%eax
  802ac5:	c1 e8 0c             	shr    $0xc,%eax
  802ac8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802acb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802acf:	78 09                	js     802ada <to_page_info+0x27>
  802ad1:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802ad8:	7e 14                	jle    802aee <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802ada:	83 ec 04             	sub    $0x4,%esp
  802add:	68 c4 48 80 00       	push   $0x8048c4
  802ae2:	6a 22                	push   $0x22
  802ae4:	68 ab 48 80 00       	push   $0x8048ab
  802ae9:	e8 cd da ff ff       	call   8005bb <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802aee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af1:	89 d0                	mov    %edx,%eax
  802af3:	01 c0                	add    %eax,%eax
  802af5:	01 d0                	add    %edx,%eax
  802af7:	c1 e0 02             	shl    $0x2,%eax
  802afa:	05 60 50 80 00       	add    $0x805060,%eax
}
  802aff:	c9                   	leave  
  802b00:	c3                   	ret    

00802b01 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802b01:	55                   	push   %ebp
  802b02:	89 e5                	mov    %esp,%ebp
  802b04:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802b07:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0a:	05 00 00 00 02       	add    $0x2000000,%eax
  802b0f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802b12:	73 16                	jae    802b2a <initialize_dynamic_allocator+0x29>
  802b14:	68 e8 48 80 00       	push   $0x8048e8
  802b19:	68 0e 49 80 00       	push   $0x80490e
  802b1e:	6a 34                	push   $0x34
  802b20:	68 ab 48 80 00       	push   $0x8048ab
  802b25:	e8 91 da ff ff       	call   8005bb <_panic>
		is_initialized = 1;
  802b2a:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  802b31:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  802b34:	8b 45 08             	mov    0x8(%ebp),%eax
  802b37:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  802b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b3f:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  802b44:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  802b4b:	00 00 00 
  802b4e:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802b55:	00 00 00 
  802b58:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  802b5f:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  802b62:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  802b69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b70:	eb 36                	jmp    802ba8 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  802b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b75:	c1 e0 04             	shl    $0x4,%eax
  802b78:	05 80 d0 81 00       	add    $0x81d080,%eax
  802b7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b86:	c1 e0 04             	shl    $0x4,%eax
  802b89:	05 84 d0 81 00       	add    $0x81d084,%eax
  802b8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b97:	c1 e0 04             	shl    $0x4,%eax
  802b9a:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802b9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  802ba5:	ff 45 f4             	incl   -0xc(%ebp)
  802ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bab:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802bae:	72 c2                	jb     802b72 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  802bb0:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802bb6:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802bbb:	29 c2                	sub    %eax,%edx
  802bbd:	89 d0                	mov    %edx,%eax
  802bbf:	c1 e8 0c             	shr    $0xc,%eax
  802bc2:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802bc5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802bcc:	e9 c8 00 00 00       	jmp    802c99 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802bd1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bd4:	89 d0                	mov    %edx,%eax
  802bd6:	01 c0                	add    %eax,%eax
  802bd8:	01 d0                	add    %edx,%eax
  802bda:	c1 e0 02             	shl    $0x2,%eax
  802bdd:	05 68 50 80 00       	add    $0x805068,%eax
  802be2:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802be7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bea:	89 d0                	mov    %edx,%eax
  802bec:	01 c0                	add    %eax,%eax
  802bee:	01 d0                	add    %edx,%eax
  802bf0:	c1 e0 02             	shl    $0x2,%eax
  802bf3:	05 6a 50 80 00       	add    $0x80506a,%eax
  802bf8:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802bfd:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802c03:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802c06:	89 c8                	mov    %ecx,%eax
  802c08:	01 c0                	add    %eax,%eax
  802c0a:	01 c8                	add    %ecx,%eax
  802c0c:	c1 e0 02             	shl    $0x2,%eax
  802c0f:	05 64 50 80 00       	add    $0x805064,%eax
  802c14:	89 10                	mov    %edx,(%eax)
  802c16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c19:	89 d0                	mov    %edx,%eax
  802c1b:	01 c0                	add    %eax,%eax
  802c1d:	01 d0                	add    %edx,%eax
  802c1f:	c1 e0 02             	shl    $0x2,%eax
  802c22:	05 64 50 80 00       	add    $0x805064,%eax
  802c27:	8b 00                	mov    (%eax),%eax
  802c29:	85 c0                	test   %eax,%eax
  802c2b:	74 1b                	je     802c48 <initialize_dynamic_allocator+0x147>
  802c2d:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802c33:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802c36:	89 c8                	mov    %ecx,%eax
  802c38:	01 c0                	add    %eax,%eax
  802c3a:	01 c8                	add    %ecx,%eax
  802c3c:	c1 e0 02             	shl    $0x2,%eax
  802c3f:	05 60 50 80 00       	add    $0x805060,%eax
  802c44:	89 02                	mov    %eax,(%edx)
  802c46:	eb 16                	jmp    802c5e <initialize_dynamic_allocator+0x15d>
  802c48:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c4b:	89 d0                	mov    %edx,%eax
  802c4d:	01 c0                	add    %eax,%eax
  802c4f:	01 d0                	add    %edx,%eax
  802c51:	c1 e0 02             	shl    $0x2,%eax
  802c54:	05 60 50 80 00       	add    $0x805060,%eax
  802c59:	a3 48 50 80 00       	mov    %eax,0x805048
  802c5e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c61:	89 d0                	mov    %edx,%eax
  802c63:	01 c0                	add    %eax,%eax
  802c65:	01 d0                	add    %edx,%eax
  802c67:	c1 e0 02             	shl    $0x2,%eax
  802c6a:	05 60 50 80 00       	add    $0x805060,%eax
  802c6f:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802c74:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c77:	89 d0                	mov    %edx,%eax
  802c79:	01 c0                	add    %eax,%eax
  802c7b:	01 d0                	add    %edx,%eax
  802c7d:	c1 e0 02             	shl    $0x2,%eax
  802c80:	05 60 50 80 00       	add    $0x805060,%eax
  802c85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c8b:	a1 54 50 80 00       	mov    0x805054,%eax
  802c90:	40                   	inc    %eax
  802c91:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  802c96:	ff 45 f0             	incl   -0x10(%ebp)
  802c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802c9f:	0f 82 2c ff ff ff    	jb     802bd1 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802ca5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ca8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802cab:	eb 2f                	jmp    802cdc <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  802cad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cb0:	89 d0                	mov    %edx,%eax
  802cb2:	01 c0                	add    %eax,%eax
  802cb4:	01 d0                	add    %edx,%eax
  802cb6:	c1 e0 02             	shl    $0x2,%eax
  802cb9:	05 68 50 80 00       	add    $0x805068,%eax
  802cbe:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  802cc3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cc6:	89 d0                	mov    %edx,%eax
  802cc8:	01 c0                	add    %eax,%eax
  802cca:	01 d0                	add    %edx,%eax
  802ccc:	c1 e0 02             	shl    $0x2,%eax
  802ccf:	05 6a 50 80 00       	add    $0x80506a,%eax
  802cd4:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802cd9:	ff 45 ec             	incl   -0x14(%ebp)
  802cdc:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  802ce3:	76 c8                	jbe    802cad <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802ce5:	90                   	nop
  802ce6:	c9                   	leave  
  802ce7:	c3                   	ret    

00802ce8 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802ce8:	55                   	push   %ebp
  802ce9:	89 e5                	mov    %esp,%ebp
  802ceb:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  802cee:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf1:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802cf6:	29 c2                	sub    %eax,%edx
  802cf8:	89 d0                	mov    %edx,%eax
  802cfa:	c1 e8 0c             	shr    $0xc,%eax
  802cfd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  802d00:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802d03:	89 d0                	mov    %edx,%eax
  802d05:	01 c0                	add    %eax,%eax
  802d07:	01 d0                	add    %edx,%eax
  802d09:	c1 e0 02             	shl    $0x2,%eax
  802d0c:	05 68 50 80 00       	add    $0x805068,%eax
  802d11:	8b 00                	mov    (%eax),%eax
  802d13:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802d16:	c9                   	leave  
  802d17:	c3                   	ret    

00802d18 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802d18:	55                   	push   %ebp
  802d19:	89 e5                	mov    %esp,%ebp
  802d1b:	83 ec 14             	sub    $0x14,%esp
  802d1e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  802d21:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  802d25:	77 07                	ja     802d2e <nearest_pow2_ceil.1513+0x16>
  802d27:	b8 01 00 00 00       	mov    $0x1,%eax
  802d2c:	eb 20                	jmp    802d4e <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  802d2e:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  802d35:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  802d38:	eb 08                	jmp    802d42 <nearest_pow2_ceil.1513+0x2a>
  802d3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d3d:	01 c0                	add    %eax,%eax
  802d3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802d42:	d1 6d 08             	shrl   0x8(%ebp)
  802d45:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d49:	75 ef                	jne    802d3a <nearest_pow2_ceil.1513+0x22>
        return power;
  802d4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802d4e:	c9                   	leave  
  802d4f:	c3                   	ret    

00802d50 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802d50:	55                   	push   %ebp
  802d51:	89 e5                	mov    %esp,%ebp
  802d53:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802d56:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802d5d:	76 16                	jbe    802d75 <alloc_block+0x25>
  802d5f:	68 24 49 80 00       	push   $0x804924
  802d64:	68 0e 49 80 00       	push   $0x80490e
  802d69:	6a 72                	push   $0x72
  802d6b:	68 ab 48 80 00       	push   $0x8048ab
  802d70:	e8 46 d8 ff ff       	call   8005bb <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  802d75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d79:	75 0a                	jne    802d85 <alloc_block+0x35>
  802d7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d80:	e9 bd 04 00 00       	jmp    803242 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  802d85:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  802d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802d92:	73 06                	jae    802d9a <alloc_block+0x4a>
        size = min_block_size;
  802d94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d97:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  802d9a:	83 ec 0c             	sub    $0xc,%esp
  802d9d:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802da0:	ff 75 08             	pushl  0x8(%ebp)
  802da3:	89 c1                	mov    %eax,%ecx
  802da5:	e8 6e ff ff ff       	call   802d18 <nearest_pow2_ceil.1513>
  802daa:	83 c4 10             	add    $0x10,%esp
  802dad:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  802db0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802db3:	83 ec 0c             	sub    $0xc,%esp
  802db6:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802db9:	52                   	push   %edx
  802dba:	89 c1                	mov    %eax,%ecx
  802dbc:	e8 83 04 00 00       	call   803244 <log2_ceil.1520>
  802dc1:	83 c4 10             	add    $0x10,%esp
  802dc4:	83 e8 03             	sub    $0x3,%eax
  802dc7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  802dca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dcd:	c1 e0 04             	shl    $0x4,%eax
  802dd0:	05 80 d0 81 00       	add    $0x81d080,%eax
  802dd5:	8b 00                	mov    (%eax),%eax
  802dd7:	85 c0                	test   %eax,%eax
  802dd9:	0f 84 d8 00 00 00    	je     802eb7 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802ddf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802de2:	c1 e0 04             	shl    $0x4,%eax
  802de5:	05 80 d0 81 00       	add    $0x81d080,%eax
  802dea:	8b 00                	mov    (%eax),%eax
  802dec:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802def:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802df3:	75 17                	jne    802e0c <alloc_block+0xbc>
  802df5:	83 ec 04             	sub    $0x4,%esp
  802df8:	68 45 49 80 00       	push   $0x804945
  802dfd:	68 98 00 00 00       	push   $0x98
  802e02:	68 ab 48 80 00       	push   $0x8048ab
  802e07:	e8 af d7 ff ff       	call   8005bb <_panic>
  802e0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e0f:	8b 00                	mov    (%eax),%eax
  802e11:	85 c0                	test   %eax,%eax
  802e13:	74 10                	je     802e25 <alloc_block+0xd5>
  802e15:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e18:	8b 00                	mov    (%eax),%eax
  802e1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e1d:	8b 52 04             	mov    0x4(%edx),%edx
  802e20:	89 50 04             	mov    %edx,0x4(%eax)
  802e23:	eb 14                	jmp    802e39 <alloc_block+0xe9>
  802e25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e28:	8b 40 04             	mov    0x4(%eax),%eax
  802e2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e2e:	c1 e2 04             	shl    $0x4,%edx
  802e31:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802e37:	89 02                	mov    %eax,(%edx)
  802e39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e3c:	8b 40 04             	mov    0x4(%eax),%eax
  802e3f:	85 c0                	test   %eax,%eax
  802e41:	74 0f                	je     802e52 <alloc_block+0x102>
  802e43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e46:	8b 40 04             	mov    0x4(%eax),%eax
  802e49:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e4c:	8b 12                	mov    (%edx),%edx
  802e4e:	89 10                	mov    %edx,(%eax)
  802e50:	eb 13                	jmp    802e65 <alloc_block+0x115>
  802e52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e55:	8b 00                	mov    (%eax),%eax
  802e57:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e5a:	c1 e2 04             	shl    $0x4,%edx
  802e5d:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802e63:	89 02                	mov    %eax,(%edx)
  802e65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e7b:	c1 e0 04             	shl    $0x4,%eax
  802e7e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802e83:	8b 00                	mov    (%eax),%eax
  802e85:	8d 50 ff             	lea    -0x1(%eax),%edx
  802e88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e8b:	c1 e0 04             	shl    $0x4,%eax
  802e8e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802e93:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802e95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e98:	83 ec 0c             	sub    $0xc,%esp
  802e9b:	50                   	push   %eax
  802e9c:	e8 12 fc ff ff       	call   802ab3 <to_page_info>
  802ea1:	83 c4 10             	add    $0x10,%esp
  802ea4:	89 c2                	mov    %eax,%edx
  802ea6:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802eaa:	48                   	dec    %eax
  802eab:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  802eaf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eb2:	e9 8b 03 00 00       	jmp    803242 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  802eb7:	a1 48 50 80 00       	mov    0x805048,%eax
  802ebc:	85 c0                	test   %eax,%eax
  802ebe:	0f 84 64 02 00 00    	je     803128 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  802ec4:	a1 48 50 80 00       	mov    0x805048,%eax
  802ec9:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  802ecc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ed0:	75 17                	jne    802ee9 <alloc_block+0x199>
  802ed2:	83 ec 04             	sub    $0x4,%esp
  802ed5:	68 45 49 80 00       	push   $0x804945
  802eda:	68 a0 00 00 00       	push   $0xa0
  802edf:	68 ab 48 80 00       	push   $0x8048ab
  802ee4:	e8 d2 d6 ff ff       	call   8005bb <_panic>
  802ee9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eec:	8b 00                	mov    (%eax),%eax
  802eee:	85 c0                	test   %eax,%eax
  802ef0:	74 10                	je     802f02 <alloc_block+0x1b2>
  802ef2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ef5:	8b 00                	mov    (%eax),%eax
  802ef7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802efa:	8b 52 04             	mov    0x4(%edx),%edx
  802efd:	89 50 04             	mov    %edx,0x4(%eax)
  802f00:	eb 0b                	jmp    802f0d <alloc_block+0x1bd>
  802f02:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f05:	8b 40 04             	mov    0x4(%eax),%eax
  802f08:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802f0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f10:	8b 40 04             	mov    0x4(%eax),%eax
  802f13:	85 c0                	test   %eax,%eax
  802f15:	74 0f                	je     802f26 <alloc_block+0x1d6>
  802f17:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f1a:	8b 40 04             	mov    0x4(%eax),%eax
  802f1d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f20:	8b 12                	mov    (%edx),%edx
  802f22:	89 10                	mov    %edx,(%eax)
  802f24:	eb 0a                	jmp    802f30 <alloc_block+0x1e0>
  802f26:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f29:	8b 00                	mov    (%eax),%eax
  802f2b:	a3 48 50 80 00       	mov    %eax,0x805048
  802f30:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f39:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f43:	a1 54 50 80 00       	mov    0x805054,%eax
  802f48:	48                   	dec    %eax
  802f49:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  802f4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f51:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f54:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  802f58:	b8 00 10 00 00       	mov    $0x1000,%eax
  802f5d:	99                   	cltd   
  802f5e:	f7 7d e8             	idivl  -0x18(%ebp)
  802f61:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f64:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  802f68:	83 ec 0c             	sub    $0xc,%esp
  802f6b:	ff 75 dc             	pushl  -0x24(%ebp)
  802f6e:	e8 ce fa ff ff       	call   802a41 <to_page_va>
  802f73:	83 c4 10             	add    $0x10,%esp
  802f76:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  802f79:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f7c:	83 ec 0c             	sub    $0xc,%esp
  802f7f:	50                   	push   %eax
  802f80:	e8 c0 ee ff ff       	call   801e45 <get_page>
  802f85:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802f88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802f8f:	e9 aa 00 00 00       	jmp    80303e <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  802f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f97:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  802f9b:	89 c2                	mov    %eax,%edx
  802f9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802fa0:	01 d0                	add    %edx,%eax
  802fa2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  802fa5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802fa9:	75 17                	jne    802fc2 <alloc_block+0x272>
  802fab:	83 ec 04             	sub    $0x4,%esp
  802fae:	68 64 49 80 00       	push   $0x804964
  802fb3:	68 aa 00 00 00       	push   $0xaa
  802fb8:	68 ab 48 80 00       	push   $0x8048ab
  802fbd:	e8 f9 d5 ff ff       	call   8005bb <_panic>
  802fc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fc5:	c1 e0 04             	shl    $0x4,%eax
  802fc8:	05 84 d0 81 00       	add    $0x81d084,%eax
  802fcd:	8b 10                	mov    (%eax),%edx
  802fcf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fd2:	89 50 04             	mov    %edx,0x4(%eax)
  802fd5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fd8:	8b 40 04             	mov    0x4(%eax),%eax
  802fdb:	85 c0                	test   %eax,%eax
  802fdd:	74 14                	je     802ff3 <alloc_block+0x2a3>
  802fdf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fe2:	c1 e0 04             	shl    $0x4,%eax
  802fe5:	05 84 d0 81 00       	add    $0x81d084,%eax
  802fea:	8b 00                	mov    (%eax),%eax
  802fec:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802fef:	89 10                	mov    %edx,(%eax)
  802ff1:	eb 11                	jmp    803004 <alloc_block+0x2b4>
  802ff3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ff6:	c1 e0 04             	shl    $0x4,%eax
  802ff9:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  802fff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803002:	89 02                	mov    %eax,(%edx)
  803004:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803007:	c1 e0 04             	shl    $0x4,%eax
  80300a:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803010:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803013:	89 02                	mov    %eax,(%edx)
  803015:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803018:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80301e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803021:	c1 e0 04             	shl    $0x4,%eax
  803024:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803029:	8b 00                	mov    (%eax),%eax
  80302b:	8d 50 01             	lea    0x1(%eax),%edx
  80302e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803031:	c1 e0 04             	shl    $0x4,%eax
  803034:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803039:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  80303b:	ff 45 f4             	incl   -0xc(%ebp)
  80303e:	b8 00 10 00 00       	mov    $0x1000,%eax
  803043:	99                   	cltd   
  803044:	f7 7d e8             	idivl  -0x18(%ebp)
  803047:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80304a:	0f 8f 44 ff ff ff    	jg     802f94 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803050:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803053:	c1 e0 04             	shl    $0x4,%eax
  803056:	05 80 d0 81 00       	add    $0x81d080,%eax
  80305b:	8b 00                	mov    (%eax),%eax
  80305d:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803060:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803064:	75 17                	jne    80307d <alloc_block+0x32d>
  803066:	83 ec 04             	sub    $0x4,%esp
  803069:	68 45 49 80 00       	push   $0x804945
  80306e:	68 ae 00 00 00       	push   $0xae
  803073:	68 ab 48 80 00       	push   $0x8048ab
  803078:	e8 3e d5 ff ff       	call   8005bb <_panic>
  80307d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803080:	8b 00                	mov    (%eax),%eax
  803082:	85 c0                	test   %eax,%eax
  803084:	74 10                	je     803096 <alloc_block+0x346>
  803086:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803089:	8b 00                	mov    (%eax),%eax
  80308b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80308e:	8b 52 04             	mov    0x4(%edx),%edx
  803091:	89 50 04             	mov    %edx,0x4(%eax)
  803094:	eb 14                	jmp    8030aa <alloc_block+0x35a>
  803096:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803099:	8b 40 04             	mov    0x4(%eax),%eax
  80309c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80309f:	c1 e2 04             	shl    $0x4,%edx
  8030a2:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8030a8:	89 02                	mov    %eax,(%edx)
  8030aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8030ad:	8b 40 04             	mov    0x4(%eax),%eax
  8030b0:	85 c0                	test   %eax,%eax
  8030b2:	74 0f                	je     8030c3 <alloc_block+0x373>
  8030b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8030b7:	8b 40 04             	mov    0x4(%eax),%eax
  8030ba:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8030bd:	8b 12                	mov    (%edx),%edx
  8030bf:	89 10                	mov    %edx,(%eax)
  8030c1:	eb 13                	jmp    8030d6 <alloc_block+0x386>
  8030c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8030c6:	8b 00                	mov    (%eax),%eax
  8030c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030cb:	c1 e2 04             	shl    $0x4,%edx
  8030ce:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8030d4:	89 02                	mov    %eax,(%edx)
  8030d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8030d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030df:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8030e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ec:	c1 e0 04             	shl    $0x4,%eax
  8030ef:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8030f4:	8b 00                	mov    (%eax),%eax
  8030f6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8030f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030fc:	c1 e0 04             	shl    $0x4,%eax
  8030ff:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803104:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803106:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803109:	83 ec 0c             	sub    $0xc,%esp
  80310c:	50                   	push   %eax
  80310d:	e8 a1 f9 ff ff       	call   802ab3 <to_page_info>
  803112:	83 c4 10             	add    $0x10,%esp
  803115:	89 c2                	mov    %eax,%edx
  803117:	66 8b 42 0a          	mov    0xa(%edx),%ax
  80311b:	48                   	dec    %eax
  80311c:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  803120:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803123:	e9 1a 01 00 00       	jmp    803242 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  803128:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80312b:	40                   	inc    %eax
  80312c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80312f:	e9 ed 00 00 00       	jmp    803221 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  803134:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803137:	c1 e0 04             	shl    $0x4,%eax
  80313a:	05 80 d0 81 00       	add    $0x81d080,%eax
  80313f:	8b 00                	mov    (%eax),%eax
  803141:	85 c0                	test   %eax,%eax
  803143:	0f 84 d5 00 00 00    	je     80321e <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  803149:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314c:	c1 e0 04             	shl    $0x4,%eax
  80314f:	05 80 d0 81 00       	add    $0x81d080,%eax
  803154:	8b 00                	mov    (%eax),%eax
  803156:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  803159:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80315d:	75 17                	jne    803176 <alloc_block+0x426>
  80315f:	83 ec 04             	sub    $0x4,%esp
  803162:	68 45 49 80 00       	push   $0x804945
  803167:	68 b8 00 00 00       	push   $0xb8
  80316c:	68 ab 48 80 00       	push   $0x8048ab
  803171:	e8 45 d4 ff ff       	call   8005bb <_panic>
  803176:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803179:	8b 00                	mov    (%eax),%eax
  80317b:	85 c0                	test   %eax,%eax
  80317d:	74 10                	je     80318f <alloc_block+0x43f>
  80317f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803182:	8b 00                	mov    (%eax),%eax
  803184:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803187:	8b 52 04             	mov    0x4(%edx),%edx
  80318a:	89 50 04             	mov    %edx,0x4(%eax)
  80318d:	eb 14                	jmp    8031a3 <alloc_block+0x453>
  80318f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803192:	8b 40 04             	mov    0x4(%eax),%eax
  803195:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803198:	c1 e2 04             	shl    $0x4,%edx
  80319b:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8031a1:	89 02                	mov    %eax,(%edx)
  8031a3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031a6:	8b 40 04             	mov    0x4(%eax),%eax
  8031a9:	85 c0                	test   %eax,%eax
  8031ab:	74 0f                	je     8031bc <alloc_block+0x46c>
  8031ad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031b0:	8b 40 04             	mov    0x4(%eax),%eax
  8031b3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8031b6:	8b 12                	mov    (%edx),%edx
  8031b8:	89 10                	mov    %edx,(%eax)
  8031ba:	eb 13                	jmp    8031cf <alloc_block+0x47f>
  8031bc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031bf:	8b 00                	mov    (%eax),%eax
  8031c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031c4:	c1 e2 04             	shl    $0x4,%edx
  8031c7:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8031cd:	89 02                	mov    %eax,(%edx)
  8031cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031d8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e5:	c1 e0 04             	shl    $0x4,%eax
  8031e8:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8031ed:	8b 00                	mov    (%eax),%eax
  8031ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8031f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f5:	c1 e0 04             	shl    $0x4,%eax
  8031f8:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8031fd:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  8031ff:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803202:	83 ec 0c             	sub    $0xc,%esp
  803205:	50                   	push   %eax
  803206:	e8 a8 f8 ff ff       	call   802ab3 <to_page_info>
  80320b:	83 c4 10             	add    $0x10,%esp
  80320e:	89 c2                	mov    %eax,%edx
  803210:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803214:	48                   	dec    %eax
  803215:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  803219:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80321c:	eb 24                	jmp    803242 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  80321e:	ff 45 f0             	incl   -0x10(%ebp)
  803221:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  803225:	0f 8e 09 ff ff ff    	jle    803134 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  80322b:	83 ec 04             	sub    $0x4,%esp
  80322e:	68 87 49 80 00       	push   $0x804987
  803233:	68 bf 00 00 00       	push   $0xbf
  803238:	68 ab 48 80 00       	push   $0x8048ab
  80323d:	e8 79 d3 ff ff       	call   8005bb <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803242:	c9                   	leave  
  803243:	c3                   	ret    

00803244 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  803244:	55                   	push   %ebp
  803245:	89 e5                	mov    %esp,%ebp
  803247:	83 ec 14             	sub    $0x14,%esp
  80324a:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  80324d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803251:	75 07                	jne    80325a <log2_ceil.1520+0x16>
  803253:	b8 00 00 00 00       	mov    $0x0,%eax
  803258:	eb 1b                	jmp    803275 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  80325a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  803261:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  803264:	eb 06                	jmp    80326c <log2_ceil.1520+0x28>
            x >>= 1;
  803266:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  803269:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  80326c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803270:	75 f4                	jne    803266 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  803272:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803275:	c9                   	leave  
  803276:	c3                   	ret    

00803277 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  803277:	55                   	push   %ebp
  803278:	89 e5                	mov    %esp,%ebp
  80327a:	83 ec 14             	sub    $0x14,%esp
  80327d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  803280:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803284:	75 07                	jne    80328d <log2_ceil.1547+0x16>
  803286:	b8 00 00 00 00       	mov    $0x0,%eax
  80328b:	eb 1b                	jmp    8032a8 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  80328d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  803294:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  803297:	eb 06                	jmp    80329f <log2_ceil.1547+0x28>
			x >>= 1;
  803299:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  80329c:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  80329f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032a3:	75 f4                	jne    803299 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  8032a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  8032a8:	c9                   	leave  
  8032a9:	c3                   	ret    

008032aa <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8032aa:	55                   	push   %ebp
  8032ab:	89 e5                	mov    %esp,%ebp
  8032ad:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8032b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8032b3:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8032b8:	39 c2                	cmp    %eax,%edx
  8032ba:	72 0c                	jb     8032c8 <free_block+0x1e>
  8032bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8032bf:	a1 40 50 80 00       	mov    0x805040,%eax
  8032c4:	39 c2                	cmp    %eax,%edx
  8032c6:	72 19                	jb     8032e1 <free_block+0x37>
  8032c8:	68 8c 49 80 00       	push   $0x80498c
  8032cd:	68 0e 49 80 00       	push   $0x80490e
  8032d2:	68 d0 00 00 00       	push   $0xd0
  8032d7:	68 ab 48 80 00       	push   $0x8048ab
  8032dc:	e8 da d2 ff ff       	call   8005bb <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8032e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032e5:	0f 84 42 03 00 00    	je     80362d <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  8032eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ee:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8032f3:	39 c2                	cmp    %eax,%edx
  8032f5:	72 0c                	jb     803303 <free_block+0x59>
  8032f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8032fa:	a1 40 50 80 00       	mov    0x805040,%eax
  8032ff:	39 c2                	cmp    %eax,%edx
  803301:	72 17                	jb     80331a <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  803303:	83 ec 04             	sub    $0x4,%esp
  803306:	68 c4 49 80 00       	push   $0x8049c4
  80330b:	68 e6 00 00 00       	push   $0xe6
  803310:	68 ab 48 80 00       	push   $0x8048ab
  803315:	e8 a1 d2 ff ff       	call   8005bb <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  80331a:	8b 55 08             	mov    0x8(%ebp),%edx
  80331d:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803322:	29 c2                	sub    %eax,%edx
  803324:	89 d0                	mov    %edx,%eax
  803326:	83 e0 07             	and    $0x7,%eax
  803329:	85 c0                	test   %eax,%eax
  80332b:	74 17                	je     803344 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  80332d:	83 ec 04             	sub    $0x4,%esp
  803330:	68 f8 49 80 00       	push   $0x8049f8
  803335:	68 ea 00 00 00       	push   $0xea
  80333a:	68 ab 48 80 00       	push   $0x8048ab
  80333f:	e8 77 d2 ff ff       	call   8005bb <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  803344:	8b 45 08             	mov    0x8(%ebp),%eax
  803347:	83 ec 0c             	sub    $0xc,%esp
  80334a:	50                   	push   %eax
  80334b:	e8 63 f7 ff ff       	call   802ab3 <to_page_info>
  803350:	83 c4 10             	add    $0x10,%esp
  803353:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  803356:	83 ec 0c             	sub    $0xc,%esp
  803359:	ff 75 08             	pushl  0x8(%ebp)
  80335c:	e8 87 f9 ff ff       	call   802ce8 <get_block_size>
  803361:	83 c4 10             	add    $0x10,%esp
  803364:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  803367:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80336b:	75 17                	jne    803384 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  80336d:	83 ec 04             	sub    $0x4,%esp
  803370:	68 24 4a 80 00       	push   $0x804a24
  803375:	68 f1 00 00 00       	push   $0xf1
  80337a:	68 ab 48 80 00       	push   $0x8048ab
  80337f:	e8 37 d2 ff ff       	call   8005bb <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  803384:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803387:	83 ec 0c             	sub    $0xc,%esp
  80338a:	8d 45 d0             	lea    -0x30(%ebp),%eax
  80338d:	52                   	push   %edx
  80338e:	89 c1                	mov    %eax,%ecx
  803390:	e8 e2 fe ff ff       	call   803277 <log2_ceil.1547>
  803395:	83 c4 10             	add    $0x10,%esp
  803398:	83 e8 03             	sub    $0x3,%eax
  80339b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  80339e:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  8033a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8033a8:	75 17                	jne    8033c1 <free_block+0x117>
  8033aa:	83 ec 04             	sub    $0x4,%esp
  8033ad:	68 70 4a 80 00       	push   $0x804a70
  8033b2:	68 f6 00 00 00       	push   $0xf6
  8033b7:	68 ab 48 80 00       	push   $0x8048ab
  8033bc:	e8 fa d1 ff ff       	call   8005bb <_panic>
  8033c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c4:	c1 e0 04             	shl    $0x4,%eax
  8033c7:	05 80 d0 81 00       	add    $0x81d080,%eax
  8033cc:	8b 10                	mov    (%eax),%edx
  8033ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033d1:	89 10                	mov    %edx,(%eax)
  8033d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033d6:	8b 00                	mov    (%eax),%eax
  8033d8:	85 c0                	test   %eax,%eax
  8033da:	74 15                	je     8033f1 <free_block+0x147>
  8033dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033df:	c1 e0 04             	shl    $0x4,%eax
  8033e2:	05 80 d0 81 00       	add    $0x81d080,%eax
  8033e7:	8b 00                	mov    (%eax),%eax
  8033e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033ec:	89 50 04             	mov    %edx,0x4(%eax)
  8033ef:	eb 11                	jmp    803402 <free_block+0x158>
  8033f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f4:	c1 e0 04             	shl    $0x4,%eax
  8033f7:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  8033fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803400:	89 02                	mov    %eax,(%edx)
  803402:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803405:	c1 e0 04             	shl    $0x4,%eax
  803408:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  80340e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803411:	89 02                	mov    %eax,(%edx)
  803413:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803416:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80341d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803420:	c1 e0 04             	shl    $0x4,%eax
  803423:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803428:	8b 00                	mov    (%eax),%eax
  80342a:	8d 50 01             	lea    0x1(%eax),%edx
  80342d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803430:	c1 e0 04             	shl    $0x4,%eax
  803433:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803438:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  80343a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80343d:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803441:	40                   	inc    %eax
  803442:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803445:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  803449:	8b 55 08             	mov    0x8(%ebp),%edx
  80344c:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803451:	29 c2                	sub    %eax,%edx
  803453:	89 d0                	mov    %edx,%eax
  803455:	c1 e8 0c             	shr    $0xc,%eax
  803458:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  80345b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80345e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803462:	0f b7 c8             	movzwl %ax,%ecx
  803465:	b8 00 10 00 00       	mov    $0x1000,%eax
  80346a:	99                   	cltd   
  80346b:	f7 7d e8             	idivl  -0x18(%ebp)
  80346e:	39 c1                	cmp    %eax,%ecx
  803470:	0f 85 b8 01 00 00    	jne    80362e <free_block+0x384>
    	uint32 blocks_removed = 0;
  803476:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  80347d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803480:	c1 e0 04             	shl    $0x4,%eax
  803483:	05 80 d0 81 00       	add    $0x81d080,%eax
  803488:	8b 00                	mov    (%eax),%eax
  80348a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  80348d:	e9 d5 00 00 00       	jmp    803567 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  803492:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803495:	8b 00                	mov    (%eax),%eax
  803497:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  80349a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80349d:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8034a2:	29 c2                	sub    %eax,%edx
  8034a4:	89 d0                	mov    %edx,%eax
  8034a6:	c1 e8 0c             	shr    $0xc,%eax
  8034a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  8034ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034af:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8034b2:	0f 85 a9 00 00 00    	jne    803561 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  8034b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034bc:	75 17                	jne    8034d5 <free_block+0x22b>
  8034be:	83 ec 04             	sub    $0x4,%esp
  8034c1:	68 45 49 80 00       	push   $0x804945
  8034c6:	68 04 01 00 00       	push   $0x104
  8034cb:	68 ab 48 80 00       	push   $0x8048ab
  8034d0:	e8 e6 d0 ff ff       	call   8005bb <_panic>
  8034d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034d8:	8b 00                	mov    (%eax),%eax
  8034da:	85 c0                	test   %eax,%eax
  8034dc:	74 10                	je     8034ee <free_block+0x244>
  8034de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e1:	8b 00                	mov    (%eax),%eax
  8034e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034e6:	8b 52 04             	mov    0x4(%edx),%edx
  8034e9:	89 50 04             	mov    %edx,0x4(%eax)
  8034ec:	eb 14                	jmp    803502 <free_block+0x258>
  8034ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f1:	8b 40 04             	mov    0x4(%eax),%eax
  8034f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034f7:	c1 e2 04             	shl    $0x4,%edx
  8034fa:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803500:	89 02                	mov    %eax,(%edx)
  803502:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803505:	8b 40 04             	mov    0x4(%eax),%eax
  803508:	85 c0                	test   %eax,%eax
  80350a:	74 0f                	je     80351b <free_block+0x271>
  80350c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80350f:	8b 40 04             	mov    0x4(%eax),%eax
  803512:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803515:	8b 12                	mov    (%edx),%edx
  803517:	89 10                	mov    %edx,(%eax)
  803519:	eb 13                	jmp    80352e <free_block+0x284>
  80351b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80351e:	8b 00                	mov    (%eax),%eax
  803520:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803523:	c1 e2 04             	shl    $0x4,%edx
  803526:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  80352c:	89 02                	mov    %eax,(%edx)
  80352e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803531:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803541:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803544:	c1 e0 04             	shl    $0x4,%eax
  803547:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80354c:	8b 00                	mov    (%eax),%eax
  80354e:	8d 50 ff             	lea    -0x1(%eax),%edx
  803551:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803554:	c1 e0 04             	shl    $0x4,%eax
  803557:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80355c:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  80355e:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  803561:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803564:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803567:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80356b:	0f 85 21 ff ff ff    	jne    803492 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  803571:	b8 00 10 00 00       	mov    $0x1000,%eax
  803576:	99                   	cltd   
  803577:	f7 7d e8             	idivl  -0x18(%ebp)
  80357a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80357d:	74 17                	je     803596 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  80357f:	83 ec 04             	sub    $0x4,%esp
  803582:	68 94 4a 80 00       	push   $0x804a94
  803587:	68 0c 01 00 00       	push   $0x10c
  80358c:	68 ab 48 80 00       	push   $0x8048ab
  803591:	e8 25 d0 ff ff       	call   8005bb <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  803596:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803599:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  80359f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035a2:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  8035a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8035ac:	75 17                	jne    8035c5 <free_block+0x31b>
  8035ae:	83 ec 04             	sub    $0x4,%esp
  8035b1:	68 64 49 80 00       	push   $0x804964
  8035b6:	68 11 01 00 00       	push   $0x111
  8035bb:	68 ab 48 80 00       	push   $0x8048ab
  8035c0:	e8 f6 cf ff ff       	call   8005bb <_panic>
  8035c5:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  8035cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ce:	89 50 04             	mov    %edx,0x4(%eax)
  8035d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035d4:	8b 40 04             	mov    0x4(%eax),%eax
  8035d7:	85 c0                	test   %eax,%eax
  8035d9:	74 0c                	je     8035e7 <free_block+0x33d>
  8035db:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8035e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035e3:	89 10                	mov    %edx,(%eax)
  8035e5:	eb 08                	jmp    8035ef <free_block+0x345>
  8035e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ea:	a3 48 50 80 00       	mov    %eax,0x805048
  8035ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035f2:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8035f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803600:	a1 54 50 80 00       	mov    0x805054,%eax
  803605:	40                   	inc    %eax
  803606:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  80360b:	83 ec 0c             	sub    $0xc,%esp
  80360e:	ff 75 ec             	pushl  -0x14(%ebp)
  803611:	e8 2b f4 ff ff       	call   802a41 <to_page_va>
  803616:	83 c4 10             	add    $0x10,%esp
  803619:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  80361c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80361f:	83 ec 0c             	sub    $0xc,%esp
  803622:	50                   	push   %eax
  803623:	e8 69 e8 ff ff       	call   801e91 <return_page>
  803628:	83 c4 10             	add    $0x10,%esp
  80362b:	eb 01                	jmp    80362e <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  80362d:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  80362e:	c9                   	leave  
  80362f:	c3                   	ret    

00803630 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803630:	55                   	push   %ebp
  803631:	89 e5                	mov    %esp,%ebp
  803633:	83 ec 14             	sub    $0x14,%esp
  803636:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  803639:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80363d:	77 07                	ja     803646 <nearest_pow2_ceil.1572+0x16>
      return 1;
  80363f:	b8 01 00 00 00       	mov    $0x1,%eax
  803644:	eb 20                	jmp    803666 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  803646:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  80364d:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  803650:	eb 08                	jmp    80365a <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  803652:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803655:	01 c0                	add    %eax,%eax
  803657:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  80365a:	d1 6d 08             	shrl   0x8(%ebp)
  80365d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803661:	75 ef                	jne    803652 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  803663:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  803666:	c9                   	leave  
  803667:	c3                   	ret    

00803668 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  803668:	55                   	push   %ebp
  803669:	89 e5                	mov    %esp,%ebp
  80366b:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  80366e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803672:	75 13                	jne    803687 <realloc_block+0x1f>
    return alloc_block(new_size);
  803674:	83 ec 0c             	sub    $0xc,%esp
  803677:	ff 75 0c             	pushl  0xc(%ebp)
  80367a:	e8 d1 f6 ff ff       	call   802d50 <alloc_block>
  80367f:	83 c4 10             	add    $0x10,%esp
  803682:	e9 d9 00 00 00       	jmp    803760 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  803687:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80368b:	75 18                	jne    8036a5 <realloc_block+0x3d>
    free_block(va);
  80368d:	83 ec 0c             	sub    $0xc,%esp
  803690:	ff 75 08             	pushl  0x8(%ebp)
  803693:	e8 12 fc ff ff       	call   8032aa <free_block>
  803698:	83 c4 10             	add    $0x10,%esp
    return NULL;
  80369b:	b8 00 00 00 00       	mov    $0x0,%eax
  8036a0:	e9 bb 00 00 00       	jmp    803760 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  8036a5:	83 ec 0c             	sub    $0xc,%esp
  8036a8:	ff 75 08             	pushl  0x8(%ebp)
  8036ab:	e8 38 f6 ff ff       	call   802ce8 <get_block_size>
  8036b0:	83 c4 10             	add    $0x10,%esp
  8036b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  8036b6:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  8036bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036c0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8036c3:	73 06                	jae    8036cb <realloc_block+0x63>
    new_size = min_block_size;
  8036c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036c8:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  8036cb:	83 ec 0c             	sub    $0xc,%esp
  8036ce:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8036d1:	ff 75 0c             	pushl  0xc(%ebp)
  8036d4:	89 c1                	mov    %eax,%ecx
  8036d6:	e8 55 ff ff ff       	call   803630 <nearest_pow2_ceil.1572>
  8036db:	83 c4 10             	add    $0x10,%esp
  8036de:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  8036e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8036e7:	75 05                	jne    8036ee <realloc_block+0x86>
    return va;
  8036e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ec:	eb 72                	jmp    803760 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  8036ee:	83 ec 0c             	sub    $0xc,%esp
  8036f1:	ff 75 0c             	pushl  0xc(%ebp)
  8036f4:	e8 57 f6 ff ff       	call   802d50 <alloc_block>
  8036f9:	83 c4 10             	add    $0x10,%esp
  8036fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  8036ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803703:	75 07                	jne    80370c <realloc_block+0xa4>
    return NULL;
  803705:	b8 00 00 00 00       	mov    $0x0,%eax
  80370a:	eb 54                	jmp    803760 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  80370c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80370f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803712:	39 d0                	cmp    %edx,%eax
  803714:	76 02                	jbe    803718 <realloc_block+0xb0>
  803716:	89 d0                	mov    %edx,%eax
  803718:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  80371b:	8b 45 08             	mov    0x8(%ebp),%eax
  80371e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  803721:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803724:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  803727:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80372e:	eb 17                	jmp    803747 <realloc_block+0xdf>
    dst[i] = src[i];
  803730:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803736:	01 c2                	add    %eax,%edx
  803738:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80373b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373e:	01 c8                	add    %ecx,%eax
  803740:	8a 00                	mov    (%eax),%al
  803742:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  803744:	ff 45 f4             	incl   -0xc(%ebp)
  803747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80374d:	72 e1                	jb     803730 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  80374f:	83 ec 0c             	sub    $0xc,%esp
  803752:	ff 75 08             	pushl  0x8(%ebp)
  803755:	e8 50 fb ff ff       	call   8032aa <free_block>
  80375a:	83 c4 10             	add    $0x10,%esp

  return new_va;
  80375d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  803760:	c9                   	leave  
  803761:	c3                   	ret    

00803762 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803762:	55                   	push   %ebp
  803763:	89 e5                	mov    %esp,%ebp
  803765:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803768:	8b 55 08             	mov    0x8(%ebp),%edx
  80376b:	89 d0                	mov    %edx,%eax
  80376d:	c1 e0 02             	shl    $0x2,%eax
  803770:	01 d0                	add    %edx,%eax
  803772:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803779:	01 d0                	add    %edx,%eax
  80377b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803782:	01 d0                	add    %edx,%eax
  803784:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80378b:	01 d0                	add    %edx,%eax
  80378d:	c1 e0 04             	shl    $0x4,%eax
  803790:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  803793:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  80379a:	0f 31                	rdtsc  
  80379c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80379f:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8037a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8037ab:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8037ae:	eb 46                	jmp    8037f6 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8037b0:	0f 31                	rdtsc  
  8037b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8037b5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8037b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8037bb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8037c1:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8037c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ca:	29 c2                	sub    %eax,%edx
  8037cc:	89 d0                	mov    %edx,%eax
  8037ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8037d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d7:	89 d1                	mov    %edx,%ecx
  8037d9:	29 c1                	sub    %eax,%ecx
  8037db:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8037de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037e1:	39 c2                	cmp    %eax,%edx
  8037e3:	0f 97 c0             	seta   %al
  8037e6:	0f b6 c0             	movzbl %al,%eax
  8037e9:	29 c1                	sub    %eax,%ecx
  8037eb:	89 c8                	mov    %ecx,%eax
  8037ed:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8037f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8037f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8037f9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8037fc:	72 b2                	jb     8037b0 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8037fe:	90                   	nop
  8037ff:	c9                   	leave  
  803800:	c3                   	ret    

00803801 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803801:	55                   	push   %ebp
  803802:	89 e5                	mov    %esp,%ebp
  803804:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803807:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80380e:	eb 03                	jmp    803813 <busy_wait+0x12>
  803810:	ff 45 fc             	incl   -0x4(%ebp)
  803813:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803816:	3b 45 08             	cmp    0x8(%ebp),%eax
  803819:	72 f5                	jb     803810 <busy_wait+0xf>
	return i;
  80381b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80381e:	c9                   	leave  
  80381f:	c3                   	ret    

00803820 <__udivdi3>:
  803820:	55                   	push   %ebp
  803821:	57                   	push   %edi
  803822:	56                   	push   %esi
  803823:	53                   	push   %ebx
  803824:	83 ec 1c             	sub    $0x1c,%esp
  803827:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80382b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80382f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803833:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803837:	89 ca                	mov    %ecx,%edx
  803839:	89 f8                	mov    %edi,%eax
  80383b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80383f:	85 f6                	test   %esi,%esi
  803841:	75 2d                	jne    803870 <__udivdi3+0x50>
  803843:	39 cf                	cmp    %ecx,%edi
  803845:	77 65                	ja     8038ac <__udivdi3+0x8c>
  803847:	89 fd                	mov    %edi,%ebp
  803849:	85 ff                	test   %edi,%edi
  80384b:	75 0b                	jne    803858 <__udivdi3+0x38>
  80384d:	b8 01 00 00 00       	mov    $0x1,%eax
  803852:	31 d2                	xor    %edx,%edx
  803854:	f7 f7                	div    %edi
  803856:	89 c5                	mov    %eax,%ebp
  803858:	31 d2                	xor    %edx,%edx
  80385a:	89 c8                	mov    %ecx,%eax
  80385c:	f7 f5                	div    %ebp
  80385e:	89 c1                	mov    %eax,%ecx
  803860:	89 d8                	mov    %ebx,%eax
  803862:	f7 f5                	div    %ebp
  803864:	89 cf                	mov    %ecx,%edi
  803866:	89 fa                	mov    %edi,%edx
  803868:	83 c4 1c             	add    $0x1c,%esp
  80386b:	5b                   	pop    %ebx
  80386c:	5e                   	pop    %esi
  80386d:	5f                   	pop    %edi
  80386e:	5d                   	pop    %ebp
  80386f:	c3                   	ret    
  803870:	39 ce                	cmp    %ecx,%esi
  803872:	77 28                	ja     80389c <__udivdi3+0x7c>
  803874:	0f bd fe             	bsr    %esi,%edi
  803877:	83 f7 1f             	xor    $0x1f,%edi
  80387a:	75 40                	jne    8038bc <__udivdi3+0x9c>
  80387c:	39 ce                	cmp    %ecx,%esi
  80387e:	72 0a                	jb     80388a <__udivdi3+0x6a>
  803880:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803884:	0f 87 9e 00 00 00    	ja     803928 <__udivdi3+0x108>
  80388a:	b8 01 00 00 00       	mov    $0x1,%eax
  80388f:	89 fa                	mov    %edi,%edx
  803891:	83 c4 1c             	add    $0x1c,%esp
  803894:	5b                   	pop    %ebx
  803895:	5e                   	pop    %esi
  803896:	5f                   	pop    %edi
  803897:	5d                   	pop    %ebp
  803898:	c3                   	ret    
  803899:	8d 76 00             	lea    0x0(%esi),%esi
  80389c:	31 ff                	xor    %edi,%edi
  80389e:	31 c0                	xor    %eax,%eax
  8038a0:	89 fa                	mov    %edi,%edx
  8038a2:	83 c4 1c             	add    $0x1c,%esp
  8038a5:	5b                   	pop    %ebx
  8038a6:	5e                   	pop    %esi
  8038a7:	5f                   	pop    %edi
  8038a8:	5d                   	pop    %ebp
  8038a9:	c3                   	ret    
  8038aa:	66 90                	xchg   %ax,%ax
  8038ac:	89 d8                	mov    %ebx,%eax
  8038ae:	f7 f7                	div    %edi
  8038b0:	31 ff                	xor    %edi,%edi
  8038b2:	89 fa                	mov    %edi,%edx
  8038b4:	83 c4 1c             	add    $0x1c,%esp
  8038b7:	5b                   	pop    %ebx
  8038b8:	5e                   	pop    %esi
  8038b9:	5f                   	pop    %edi
  8038ba:	5d                   	pop    %ebp
  8038bb:	c3                   	ret    
  8038bc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8038c1:	89 eb                	mov    %ebp,%ebx
  8038c3:	29 fb                	sub    %edi,%ebx
  8038c5:	89 f9                	mov    %edi,%ecx
  8038c7:	d3 e6                	shl    %cl,%esi
  8038c9:	89 c5                	mov    %eax,%ebp
  8038cb:	88 d9                	mov    %bl,%cl
  8038cd:	d3 ed                	shr    %cl,%ebp
  8038cf:	89 e9                	mov    %ebp,%ecx
  8038d1:	09 f1                	or     %esi,%ecx
  8038d3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8038d7:	89 f9                	mov    %edi,%ecx
  8038d9:	d3 e0                	shl    %cl,%eax
  8038db:	89 c5                	mov    %eax,%ebp
  8038dd:	89 d6                	mov    %edx,%esi
  8038df:	88 d9                	mov    %bl,%cl
  8038e1:	d3 ee                	shr    %cl,%esi
  8038e3:	89 f9                	mov    %edi,%ecx
  8038e5:	d3 e2                	shl    %cl,%edx
  8038e7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038eb:	88 d9                	mov    %bl,%cl
  8038ed:	d3 e8                	shr    %cl,%eax
  8038ef:	09 c2                	or     %eax,%edx
  8038f1:	89 d0                	mov    %edx,%eax
  8038f3:	89 f2                	mov    %esi,%edx
  8038f5:	f7 74 24 0c          	divl   0xc(%esp)
  8038f9:	89 d6                	mov    %edx,%esi
  8038fb:	89 c3                	mov    %eax,%ebx
  8038fd:	f7 e5                	mul    %ebp
  8038ff:	39 d6                	cmp    %edx,%esi
  803901:	72 19                	jb     80391c <__udivdi3+0xfc>
  803903:	74 0b                	je     803910 <__udivdi3+0xf0>
  803905:	89 d8                	mov    %ebx,%eax
  803907:	31 ff                	xor    %edi,%edi
  803909:	e9 58 ff ff ff       	jmp    803866 <__udivdi3+0x46>
  80390e:	66 90                	xchg   %ax,%ax
  803910:	8b 54 24 08          	mov    0x8(%esp),%edx
  803914:	89 f9                	mov    %edi,%ecx
  803916:	d3 e2                	shl    %cl,%edx
  803918:	39 c2                	cmp    %eax,%edx
  80391a:	73 e9                	jae    803905 <__udivdi3+0xe5>
  80391c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80391f:	31 ff                	xor    %edi,%edi
  803921:	e9 40 ff ff ff       	jmp    803866 <__udivdi3+0x46>
  803926:	66 90                	xchg   %ax,%ax
  803928:	31 c0                	xor    %eax,%eax
  80392a:	e9 37 ff ff ff       	jmp    803866 <__udivdi3+0x46>
  80392f:	90                   	nop

00803930 <__umoddi3>:
  803930:	55                   	push   %ebp
  803931:	57                   	push   %edi
  803932:	56                   	push   %esi
  803933:	53                   	push   %ebx
  803934:	83 ec 1c             	sub    $0x1c,%esp
  803937:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80393b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80393f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803943:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803947:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80394b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80394f:	89 f3                	mov    %esi,%ebx
  803951:	89 fa                	mov    %edi,%edx
  803953:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803957:	89 34 24             	mov    %esi,(%esp)
  80395a:	85 c0                	test   %eax,%eax
  80395c:	75 1a                	jne    803978 <__umoddi3+0x48>
  80395e:	39 f7                	cmp    %esi,%edi
  803960:	0f 86 a2 00 00 00    	jbe    803a08 <__umoddi3+0xd8>
  803966:	89 c8                	mov    %ecx,%eax
  803968:	89 f2                	mov    %esi,%edx
  80396a:	f7 f7                	div    %edi
  80396c:	89 d0                	mov    %edx,%eax
  80396e:	31 d2                	xor    %edx,%edx
  803970:	83 c4 1c             	add    $0x1c,%esp
  803973:	5b                   	pop    %ebx
  803974:	5e                   	pop    %esi
  803975:	5f                   	pop    %edi
  803976:	5d                   	pop    %ebp
  803977:	c3                   	ret    
  803978:	39 f0                	cmp    %esi,%eax
  80397a:	0f 87 ac 00 00 00    	ja     803a2c <__umoddi3+0xfc>
  803980:	0f bd e8             	bsr    %eax,%ebp
  803983:	83 f5 1f             	xor    $0x1f,%ebp
  803986:	0f 84 ac 00 00 00    	je     803a38 <__umoddi3+0x108>
  80398c:	bf 20 00 00 00       	mov    $0x20,%edi
  803991:	29 ef                	sub    %ebp,%edi
  803993:	89 fe                	mov    %edi,%esi
  803995:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803999:	89 e9                	mov    %ebp,%ecx
  80399b:	d3 e0                	shl    %cl,%eax
  80399d:	89 d7                	mov    %edx,%edi
  80399f:	89 f1                	mov    %esi,%ecx
  8039a1:	d3 ef                	shr    %cl,%edi
  8039a3:	09 c7                	or     %eax,%edi
  8039a5:	89 e9                	mov    %ebp,%ecx
  8039a7:	d3 e2                	shl    %cl,%edx
  8039a9:	89 14 24             	mov    %edx,(%esp)
  8039ac:	89 d8                	mov    %ebx,%eax
  8039ae:	d3 e0                	shl    %cl,%eax
  8039b0:	89 c2                	mov    %eax,%edx
  8039b2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039b6:	d3 e0                	shl    %cl,%eax
  8039b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039bc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039c0:	89 f1                	mov    %esi,%ecx
  8039c2:	d3 e8                	shr    %cl,%eax
  8039c4:	09 d0                	or     %edx,%eax
  8039c6:	d3 eb                	shr    %cl,%ebx
  8039c8:	89 da                	mov    %ebx,%edx
  8039ca:	f7 f7                	div    %edi
  8039cc:	89 d3                	mov    %edx,%ebx
  8039ce:	f7 24 24             	mull   (%esp)
  8039d1:	89 c6                	mov    %eax,%esi
  8039d3:	89 d1                	mov    %edx,%ecx
  8039d5:	39 d3                	cmp    %edx,%ebx
  8039d7:	0f 82 87 00 00 00    	jb     803a64 <__umoddi3+0x134>
  8039dd:	0f 84 91 00 00 00    	je     803a74 <__umoddi3+0x144>
  8039e3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039e7:	29 f2                	sub    %esi,%edx
  8039e9:	19 cb                	sbb    %ecx,%ebx
  8039eb:	89 d8                	mov    %ebx,%eax
  8039ed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8039f1:	d3 e0                	shl    %cl,%eax
  8039f3:	89 e9                	mov    %ebp,%ecx
  8039f5:	d3 ea                	shr    %cl,%edx
  8039f7:	09 d0                	or     %edx,%eax
  8039f9:	89 e9                	mov    %ebp,%ecx
  8039fb:	d3 eb                	shr    %cl,%ebx
  8039fd:	89 da                	mov    %ebx,%edx
  8039ff:	83 c4 1c             	add    $0x1c,%esp
  803a02:	5b                   	pop    %ebx
  803a03:	5e                   	pop    %esi
  803a04:	5f                   	pop    %edi
  803a05:	5d                   	pop    %ebp
  803a06:	c3                   	ret    
  803a07:	90                   	nop
  803a08:	89 fd                	mov    %edi,%ebp
  803a0a:	85 ff                	test   %edi,%edi
  803a0c:	75 0b                	jne    803a19 <__umoddi3+0xe9>
  803a0e:	b8 01 00 00 00       	mov    $0x1,%eax
  803a13:	31 d2                	xor    %edx,%edx
  803a15:	f7 f7                	div    %edi
  803a17:	89 c5                	mov    %eax,%ebp
  803a19:	89 f0                	mov    %esi,%eax
  803a1b:	31 d2                	xor    %edx,%edx
  803a1d:	f7 f5                	div    %ebp
  803a1f:	89 c8                	mov    %ecx,%eax
  803a21:	f7 f5                	div    %ebp
  803a23:	89 d0                	mov    %edx,%eax
  803a25:	e9 44 ff ff ff       	jmp    80396e <__umoddi3+0x3e>
  803a2a:	66 90                	xchg   %ax,%ax
  803a2c:	89 c8                	mov    %ecx,%eax
  803a2e:	89 f2                	mov    %esi,%edx
  803a30:	83 c4 1c             	add    $0x1c,%esp
  803a33:	5b                   	pop    %ebx
  803a34:	5e                   	pop    %esi
  803a35:	5f                   	pop    %edi
  803a36:	5d                   	pop    %ebp
  803a37:	c3                   	ret    
  803a38:	3b 04 24             	cmp    (%esp),%eax
  803a3b:	72 06                	jb     803a43 <__umoddi3+0x113>
  803a3d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a41:	77 0f                	ja     803a52 <__umoddi3+0x122>
  803a43:	89 f2                	mov    %esi,%edx
  803a45:	29 f9                	sub    %edi,%ecx
  803a47:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a4b:	89 14 24             	mov    %edx,(%esp)
  803a4e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a52:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a56:	8b 14 24             	mov    (%esp),%edx
  803a59:	83 c4 1c             	add    $0x1c,%esp
  803a5c:	5b                   	pop    %ebx
  803a5d:	5e                   	pop    %esi
  803a5e:	5f                   	pop    %edi
  803a5f:	5d                   	pop    %ebp
  803a60:	c3                   	ret    
  803a61:	8d 76 00             	lea    0x0(%esi),%esi
  803a64:	2b 04 24             	sub    (%esp),%eax
  803a67:	19 fa                	sbb    %edi,%edx
  803a69:	89 d1                	mov    %edx,%ecx
  803a6b:	89 c6                	mov    %eax,%esi
  803a6d:	e9 71 ff ff ff       	jmp    8039e3 <__umoddi3+0xb3>
  803a72:	66 90                	xchg   %ax,%ax
  803a74:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a78:	72 ea                	jb     803a64 <__umoddi3+0x134>
  803a7a:	89 d9                	mov    %ebx,%ecx
  803a7c:	e9 62 ff ff ff       	jmp    8039e3 <__umoddi3+0xb3>
