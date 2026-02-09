
obj/user/ef_tst_sharing_5_master:     file format elf32-i386


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
  800031:	e8 d6 04 00 00       	call   80050c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec bc 00 00 00    	sub    $0xbc,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800044:	a1 20 50 80 00       	mov    0x805020,%eax
  800049:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80004f:	a1 20 50 80 00       	mov    0x805020,%eax
  800054:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80005a:	39 c2                	cmp    %eax,%edx
  80005c:	72 14                	jb     800072 <_main+0x3a>
			panic("Please increase the WS size");
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	68 a0 3b 80 00       	push   $0x803ba0
  800066:	6a 0b                	push   $0xb
  800068:	68 bc 3b 80 00       	push   $0x803bbc
  80006d:	e8 4a 06 00 00       	call   8006bc <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800072:	c7 45 e4 00 10 00 82 	movl   $0x82001000,-0x1c(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	cprintf("************************************************\n");
  800079:	83 ec 0c             	sub    $0xc,%esp
  80007c:	68 dc 3b 80 00       	push   $0x803bdc
  800081:	e8 24 09 00 00       	call   8009aa <cprintf>
  800086:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800089:	83 ec 0c             	sub    $0xc,%esp
  80008c:	68 10 3c 80 00       	push   $0x803c10
  800091:	e8 14 09 00 00       	call   8009aa <cprintf>
  800096:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  800099:	83 ec 0c             	sub    $0xc,%esp
  80009c:	68 6c 3c 80 00       	push   $0x803c6c
  8000a1:	e8 04 09 00 00       	call   8009aa <cprintf>
  8000a6:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000a9:	e8 b8 27 00 00       	call   802866 <sys_getenvid>
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int32 envIdSlave1, envIdSlave2, envIdSlaveB1, envIdSlaveB2;

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 a0 3c 80 00       	push   $0x803ca0
  8000b9:	e8 ec 08 00 00       	call   8009aa <cprintf>
  8000be:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		envIdSlave1 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8000c6:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  8000cc:	89 c2                	mov    %eax,%edx
  8000ce:	a1 20 50 80 00       	mov    0x805020,%eax
  8000d3:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000d9:	6a 32                	push   $0x32
  8000db:	52                   	push   %edx
  8000dc:	50                   	push   %eax
  8000dd:	68 e1 3c 80 00       	push   $0x803ce1
  8000e2:	e8 2a 27 00 00       	call   802811 <sys_create_env>
  8000e7:	83 c4 10             	add    $0x10,%esp
  8000ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
		envIdSlave2 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8000f2:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  8000f8:	89 c2                	mov    %eax,%edx
  8000fa:	a1 20 50 80 00       	mov    0x805020,%eax
  8000ff:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800105:	6a 32                	push   $0x32
  800107:	52                   	push   %edx
  800108:	50                   	push   %eax
  800109:	68 e1 3c 80 00       	push   $0x803ce1
  80010e:	e8 fe 26 00 00       	call   802811 <sys_create_env>
  800113:	83 c4 10             	add    $0x10,%esp
  800116:	89 45 d8             	mov    %eax,-0x28(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800119:	e8 98 25 00 00       	call   8026b6 <sys_calculate_free_frames>
  80011e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800121:	83 ec 04             	sub    $0x4,%esp
  800124:	6a 01                	push   $0x1
  800126:	68 00 10 00 00       	push   $0x1000
  80012b:	68 ef 3c 80 00       	push   $0x803cef
  800130:	e8 60 21 00 00       	call   802295 <smalloc>
  800135:	83 c4 10             	add    $0x10,%esp
  800138:	89 45 d0             	mov    %eax,-0x30(%ebp)
		cprintf("Master env created x (1 page) \n");
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	68 f4 3c 80 00       	push   $0x803cf4
  800143:	e8 62 08 00 00       	call   8009aa <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)pagealloc_start) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80014b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014e:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  800151:	74 14                	je     800167 <_main+0x12f>
  800153:	83 ec 04             	sub    $0x4,%esp
  800156:	68 14 3d 80 00       	push   $0x803d14
  80015b:	6a 27                	push   $0x27
  80015d:	68 bc 3b 80 00       	push   $0x803bbc
  800162:	e8 55 05 00 00       	call   8006bc <_panic>
		expected = 1+1 ; /*1page +1table*/
  800167:	c7 45 cc 02 00 00 00 	movl   $0x2,-0x34(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80016e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800171:	e8 40 25 00 00       	call   8026b6 <sys_calculate_free_frames>
  800176:	29 c3                	sub    %eax,%ebx
  800178:	89 d8                	mov    %ebx,%eax
  80017a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/)
  80017d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800180:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800183:	7c 0b                	jl     800190 <_main+0x158>
  800185:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800188:	83 c0 02             	add    $0x2,%eax
  80018b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80018e:	7d 24                	jge    8001b4 <_main+0x17c>
			panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800190:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800193:	e8 1e 25 00 00       	call   8026b6 <sys_calculate_free_frames>
  800198:	29 c3                	sub    %eax,%ebx
  80019a:	89 d8                	mov    %ebx,%eax
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	ff 75 cc             	pushl  -0x34(%ebp)
  8001a2:	50                   	push   %eax
  8001a3:	68 80 3d 80 00       	push   $0x803d80
  8001a8:	6a 2b                	push   $0x2b
  8001aa:	68 bc 3b 80 00       	push   $0x803bbc
  8001af:	e8 08 05 00 00       	call   8006bc <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001b4:	e8 a4 27 00 00       	call   80295d <rsttst>

		sys_run_env(envIdSlave1);
  8001b9:	83 ec 0c             	sub    $0xc,%esp
  8001bc:	ff 75 dc             	pushl  -0x24(%ebp)
  8001bf:	e8 6b 26 00 00       	call   80282f <sys_run_env>
  8001c4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001c7:	83 ec 0c             	sub    $0xc,%esp
  8001ca:	ff 75 d8             	pushl  -0x28(%ebp)
  8001cd:	e8 5d 26 00 00       	call   80282f <sys_run_env>
  8001d2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 18 3e 80 00       	push   $0x803e18
  8001dd:	e8 c8 07 00 00       	call   8009aa <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	68 b8 0b 00 00       	push   $0xbb8
  8001ed:	e8 71 36 00 00       	call   803863 <env_sleep>
  8001f2:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		while (gettst()!=2) ;// panic("test failed");
  8001f5:	90                   	nop
  8001f6:	e8 dc 27 00 00       	call   8029d7 <gettst>
  8001fb:	83 f8 02             	cmp    $0x2,%eax
  8001fe:	75 f6                	jne    8001f6 <_main+0x1be>

		freeFrames = sys_calculate_free_frames() ;
  800200:	e8 b1 24 00 00       	call   8026b6 <sys_calculate_free_frames>
  800205:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		sfree(x);
  800208:	83 ec 0c             	sub    $0xc,%esp
  80020b:	ff 75 d0             	pushl  -0x30(%ebp)
  80020e:	e8 67 23 00 00       	call   80257a <sfree>
  800213:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800216:	83 ec 0c             	sub    $0xc,%esp
  800219:	68 30 3e 80 00       	push   $0x803e30
  80021e:	e8 87 07 00 00       	call   8009aa <cprintf>
  800223:	83 c4 10             	add    $0x10,%esp
		int diff2 = (sys_calculate_free_frames() - freeFrames);
  800226:	e8 8b 24 00 00       	call   8026b6 <sys_calculate_free_frames>
  80022b:	89 c2                	mov    %eax,%edx
  80022d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800230:	29 c2                	sub    %eax,%edx
  800232:	89 d0                	mov    %edx,%eax
  800234:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		expected = 1+1; /*1page+1table*/
  800237:	c7 45 cc 02 00 00 00 	movl   $0x2,-0x34(%ebp)
		if (diff2 != expected) panic("Wrong free (diff=%d, expected=%d): revise your freeSharedObject logic\n", diff2, expected);
  80023e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800241:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800244:	74 1a                	je     800260 <_main+0x228>
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	ff 75 cc             	pushl  -0x34(%ebp)
  80024c:	ff 75 c4             	pushl  -0x3c(%ebp)
  80024f:	68 50 3e 80 00       	push   $0x803e50
  800254:	6a 3e                	push   $0x3e
  800256:	68 bc 3b 80 00       	push   $0x803bbc
  80025b:	e8 5c 04 00 00       	call   8006bc <_panic>
	}
	cprintf("Step A is finished!!\n\n\n");
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	68 97 3e 80 00       	push   $0x803e97
  800268:	e8 3d 07 00 00       	call   8009aa <cprintf>
  80026d:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	68 b0 3e 80 00       	push   $0x803eb0
  800278:	e8 2d 07 00 00       	call   8009aa <cprintf>
  80027d:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		envIdSlaveB1 = sys_create_env("ef_tshr5slaveB1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800280:	a1 20 50 80 00       	mov    0x805020,%eax
  800285:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  80028b:	89 c2                	mov    %eax,%edx
  80028d:	a1 20 50 80 00       	mov    0x805020,%eax
  800292:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800298:	6a 32                	push   $0x32
  80029a:	52                   	push   %edx
  80029b:	50                   	push   %eax
  80029c:	68 e0 3e 80 00       	push   $0x803ee0
  8002a1:	e8 6b 25 00 00       	call   802811 <sys_create_env>
  8002a6:	83 c4 10             	add    $0x10,%esp
  8002a9:	89 45 c0             	mov    %eax,-0x40(%ebp)
		envIdSlaveB2 = sys_create_env("ef_tshr5slaveB2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),50);
  8002ac:	a1 20 50 80 00       	mov    0x805020,%eax
  8002b1:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  8002b7:	89 c2                	mov    %eax,%edx
  8002b9:	a1 20 50 80 00       	mov    0x805020,%eax
  8002be:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8002c4:	6a 32                	push   $0x32
  8002c6:	52                   	push   %edx
  8002c7:	50                   	push   %eax
  8002c8:	68 f0 3e 80 00       	push   $0x803ef0
  8002cd:	e8 3f 25 00 00       	call   802811 <sys_create_env>
  8002d2:	83 c4 10             	add    $0x10,%esp
  8002d5:	89 45 bc             	mov    %eax,-0x44(%ebp)

		z = smalloc("z", PAGE_SIZE+1, 1);
  8002d8:	83 ec 04             	sub    $0x4,%esp
  8002db:	6a 01                	push   $0x1
  8002dd:	68 01 10 00 00       	push   $0x1001
  8002e2:	68 00 3f 80 00       	push   $0x803f00
  8002e7:	e8 a9 1f 00 00       	call   802295 <smalloc>
  8002ec:	83 c4 10             	add    $0x10,%esp
  8002ef:	89 45 b8             	mov    %eax,-0x48(%ebp)
		cprintf("Master env created z (2 pages) \n");
  8002f2:	83 ec 0c             	sub    $0xc,%esp
  8002f5:	68 04 3f 80 00       	push   $0x803f04
  8002fa:	e8 ab 06 00 00       	call   8009aa <cprintf>
  8002ff:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE+1024, 1);
  800302:	83 ec 04             	sub    $0x4,%esp
  800305:	6a 01                	push   $0x1
  800307:	68 00 14 00 00       	push   $0x1400
  80030c:	68 ef 3c 80 00       	push   $0x803cef
  800311:	e8 7f 1f 00 00       	call   802295 <smalloc>
  800316:	83 c4 10             	add    $0x10,%esp
  800319:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		cprintf("Master env created x (2 pages) \n");
  80031c:	83 ec 0c             	sub    $0xc,%esp
  80031f:	68 28 3f 80 00       	push   $0x803f28
  800324:	e8 81 06 00 00       	call   8009aa <cprintf>
  800329:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80032c:	e8 2c 26 00 00       	call   80295d <rsttst>

		sys_run_env(envIdSlaveB1);
  800331:	83 ec 0c             	sub    $0xc,%esp
  800334:	ff 75 c0             	pushl  -0x40(%ebp)
  800337:	e8 f3 24 00 00       	call   80282f <sys_run_env>
  80033c:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	ff 75 bc             	pushl  -0x44(%ebp)
  800345:	e8 e5 24 00 00       	call   80282f <sys_run_env>
  80034a:	83 c4 10             	add    $0x10,%esp

		//give slaves time to catch the shared object before removal
		{
			//			env_sleep(4000);
			while (gettst()!=2) ;
  80034d:	90                   	nop
  80034e:	e8 84 26 00 00       	call   8029d7 <gettst>
  800353:	83 f8 02             	cmp    $0x2,%eax
  800356:	75 f6                	jne    80034e <_main+0x316>
		}

		int freeFrames = sys_calculate_free_frames() ;
  800358:	e8 59 23 00 00       	call   8026b6 <sys_calculate_free_frames>
  80035d:	89 45 b0             	mov    %eax,-0x50(%ebp)

		sfree(z);
  800360:	83 ec 0c             	sub    $0xc,%esp
  800363:	ff 75 b8             	pushl  -0x48(%ebp)
  800366:	e8 0f 22 00 00       	call   80257a <sfree>
  80036b:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  80036e:	83 ec 0c             	sub    $0xc,%esp
  800371:	68 49 3f 80 00       	push   $0x803f49
  800376:	e8 2f 06 00 00       	call   8009aa <cprintf>
  80037b:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  80037e:	83 ec 0c             	sub    $0xc,%esp
  800381:	ff 75 b4             	pushl  -0x4c(%ebp)
  800384:	e8 f1 21 00 00       	call   80257a <sfree>
  800389:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  80038c:	83 ec 0c             	sub    $0xc,%esp
  80038f:	68 5f 3f 80 00       	push   $0x803f5f
  800394:	e8 11 06 00 00       	call   8009aa <cprintf>
  800399:	83 c4 10             	add    $0x10,%esp

		inctst(); //finish the free's
  80039c:	e8 1c 26 00 00       	call   8029bd <inctst>

		int diff = (sys_calculate_free_frames() - freeFrames);
  8003a1:	e8 10 23 00 00       	call   8026b6 <sys_calculate_free_frames>
  8003a6:	89 c2                	mov    %eax,%edx
  8003a8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8003ab:	29 c2                	sub    %eax,%edx
  8003ad:	89 d0                	mov    %edx,%eax
  8003af:	89 45 ac             	mov    %eax,-0x54(%ebp)
		expected = 1 /*table*/;
  8003b2:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
		if (diff !=  expected) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003b9:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8003bc:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8003bf:	74 14                	je     8003d5 <_main+0x39d>
  8003c1:	83 ec 04             	sub    $0x4,%esp
  8003c4:	68 78 3f 80 00       	push   $0x803f78
  8003c9:	6a 65                	push   $0x65
  8003cb:	68 bc 3b 80 00       	push   $0x803bbc
  8003d0:	e8 e7 02 00 00       	call   8006bc <_panic>

		inctst();	// finish checking
  8003d5:	e8 e3 25 00 00       	call   8029bd <inctst>

		//to ensure that the other environments completed successfully
		while (gettst()!=6) ;// panic("test failed");
  8003da:	90                   	nop
  8003db:	e8 f7 25 00 00       	call   8029d7 <gettst>
  8003e0:	83 f8 06             	cmp    $0x6,%eax
  8003e3:	75 f6                	jne    8003db <_main+0x3a3>

		int* finish_children = smalloc("finish_children", sizeof(int), 1);
  8003e5:	83 ec 04             	sub    $0x4,%esp
  8003e8:	6a 01                	push   $0x1
  8003ea:	6a 04                	push   $0x4
  8003ec:	68 1d 40 80 00       	push   $0x80401d
  8003f1:	e8 9f 1e 00 00       	call   802295 <smalloc>
  8003f6:	83 c4 10             	add    $0x10,%esp
  8003f9:	89 45 a8             	mov    %eax,-0x58(%ebp)
		*finish_children = 0;
  8003fc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

		//To indicate that it create the finish_children & completed successfully
		cprintf("Master is completed.\n");
  800405:	83 ec 0c             	sub    $0xc,%esp
  800408:	68 2d 40 80 00       	push   $0x80402d
  80040d:	e8 98 05 00 00       	call   8009aa <cprintf>
  800412:	83 c4 10             	add    $0x10,%esp
		inctst();
  800415:	e8 a3 25 00 00       	call   8029bd <inctst>

		if (sys_getparentenvid() > 0) {
  80041a:	e8 79 24 00 00       	call   802898 <sys_getparentenvid>
  80041f:	85 c0                	test   %eax,%eax
  800421:	0f 8e dc 00 00 00    	jle    800503 <_main+0x4cb>
			while(*finish_children != 1);
  800427:	90                   	nop
  800428:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80042b:	8b 00                	mov    (%eax),%eax
  80042d:	83 f8 01             	cmp    $0x1,%eax
  800430:	75 f6                	jne    800428 <_main+0x3f0>
			cprintf("done\n");
  800432:	83 ec 0c             	sub    $0xc,%esp
  800435:	68 43 40 80 00       	push   $0x804043
  80043a:	e8 6b 05 00 00       	call   8009aa <cprintf>
  80043f:	83 c4 10             	add    $0x10,%esp

			//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
			//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
			//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
			//	2. changing the # free frames
			char changeIntCmd[100] = "__changeInterruptStatus__";
  800442:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  800448:	bb 57 40 80 00       	mov    $0x804057,%ebx
  80044d:	ba 1a 00 00 00       	mov    $0x1a,%edx
  800452:	89 c7                	mov    %eax,%edi
  800454:	89 de                	mov    %ebx,%esi
  800456:	89 d1                	mov    %edx,%ecx
  800458:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80045a:	8d 95 5a ff ff ff    	lea    -0xa6(%ebp),%edx
  800460:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  800465:	b0 00                	mov    $0x0,%al
  800467:	89 d7                	mov    %edx,%edi
  800469:	f3 aa                	rep stos %al,%es:(%edi)
			sys_utilities(changeIntCmd, 0);
  80046b:	83 ec 08             	sub    $0x8,%esp
  80046e:	6a 00                	push   $0x0
  800470:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  800476:	50                   	push   %eax
  800477:	e8 39 26 00 00       	call   802ab5 <sys_utilities>
  80047c:	83 c4 10             	add    $0x10,%esp
			{
				sys_destroy_env(envIdSlave1);
  80047f:	83 ec 0c             	sub    $0xc,%esp
  800482:	ff 75 dc             	pushl  -0x24(%ebp)
  800485:	e8 c1 23 00 00       	call   80284b <sys_destroy_env>
  80048a:	83 c4 10             	add    $0x10,%esp
				sys_destroy_env(envIdSlave2);
  80048d:	83 ec 0c             	sub    $0xc,%esp
  800490:	ff 75 d8             	pushl  -0x28(%ebp)
  800493:	e8 b3 23 00 00       	call   80284b <sys_destroy_env>
  800498:	83 c4 10             	add    $0x10,%esp
				sys_destroy_env(envIdSlaveB1);
  80049b:	83 ec 0c             	sub    $0xc,%esp
  80049e:	ff 75 c0             	pushl  -0x40(%ebp)
  8004a1:	e8 a5 23 00 00       	call   80284b <sys_destroy_env>
  8004a6:	83 c4 10             	add    $0x10,%esp
				sys_destroy_env(envIdSlaveB2);
  8004a9:	83 ec 0c             	sub    $0xc,%esp
  8004ac:	ff 75 bc             	pushl  -0x44(%ebp)
  8004af:	e8 97 23 00 00       	call   80284b <sys_destroy_env>
  8004b4:	83 c4 10             	add    $0x10,%esp
			}
			sys_utilities(changeIntCmd, 1);
  8004b7:	83 ec 08             	sub    $0x8,%esp
  8004ba:	6a 01                	push   $0x1
  8004bc:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  8004c2:	50                   	push   %eax
  8004c3:	e8 ed 25 00 00       	call   802ab5 <sys_utilities>
  8004c8:	83 c4 10             	add    $0x10,%esp

			int *finishedCount = NULL;
  8004cb:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
			finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  8004d2:	e8 c1 23 00 00       	call   802898 <sys_getparentenvid>
  8004d7:	83 ec 08             	sub    $0x8,%esp
  8004da:	68 49 40 80 00       	push   $0x804049
  8004df:	50                   	push   %eax
  8004e0:	e8 10 1f 00 00       	call   8023f5 <sget>
  8004e5:	83 c4 10             	add    $0x10,%esp
  8004e8:	89 45 a4             	mov    %eax,-0x5c(%ebp)

			//Critical section to protect the shared variable
			sys_lock_cons();
  8004eb:	e8 16 21 00 00       	call   802606 <sys_lock_cons>
			{
				(*finishedCount)++ ;
  8004f0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004f3:	8b 00                	mov    (%eax),%eax
  8004f5:	8d 50 01             	lea    0x1(%eax),%edx
  8004f8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004fb:	89 10                	mov    %edx,(%eax)
			}
			sys_unlock_cons();
  8004fd:	e8 1e 21 00 00       	call   802620 <sys_unlock_cons>
		}
	}


	return;
  800502:	90                   	nop
  800503:	90                   	nop
}
  800504:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800507:	5b                   	pop    %ebx
  800508:	5e                   	pop    %esi
  800509:	5f                   	pop    %edi
  80050a:	5d                   	pop    %ebp
  80050b:	c3                   	ret    

0080050c <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80050c:	55                   	push   %ebp
  80050d:	89 e5                	mov    %esp,%ebp
  80050f:	57                   	push   %edi
  800510:	56                   	push   %esi
  800511:	53                   	push   %ebx
  800512:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800515:	e8 65 23 00 00       	call   80287f <sys_getenvindex>
  80051a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80051d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800520:	89 d0                	mov    %edx,%eax
  800522:	01 c0                	add    %eax,%eax
  800524:	01 d0                	add    %edx,%eax
  800526:	c1 e0 02             	shl    $0x2,%eax
  800529:	01 d0                	add    %edx,%eax
  80052b:	c1 e0 02             	shl    $0x2,%eax
  80052e:	01 d0                	add    %edx,%eax
  800530:	c1 e0 03             	shl    $0x3,%eax
  800533:	01 d0                	add    %edx,%eax
  800535:	c1 e0 02             	shl    $0x2,%eax
  800538:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80053d:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800542:	a1 20 50 80 00       	mov    0x805020,%eax
  800547:	8a 40 20             	mov    0x20(%eax),%al
  80054a:	84 c0                	test   %al,%al
  80054c:	74 0d                	je     80055b <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80054e:	a1 20 50 80 00       	mov    0x805020,%eax
  800553:	83 c0 20             	add    $0x20,%eax
  800556:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80055b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80055f:	7e 0a                	jle    80056b <libmain+0x5f>
		binaryname = argv[0];
  800561:	8b 45 0c             	mov    0xc(%ebp),%eax
  800564:	8b 00                	mov    (%eax),%eax
  800566:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  80056b:	83 ec 08             	sub    $0x8,%esp
  80056e:	ff 75 0c             	pushl  0xc(%ebp)
  800571:	ff 75 08             	pushl  0x8(%ebp)
  800574:	e8 bf fa ff ff       	call   800038 <_main>
  800579:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80057c:	a1 00 50 80 00       	mov    0x805000,%eax
  800581:	85 c0                	test   %eax,%eax
  800583:	0f 84 01 01 00 00    	je     80068a <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800589:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80058f:	bb b4 41 80 00       	mov    $0x8041b4,%ebx
  800594:	ba 0e 00 00 00       	mov    $0xe,%edx
  800599:	89 c7                	mov    %eax,%edi
  80059b:	89 de                	mov    %ebx,%esi
  80059d:	89 d1                	mov    %edx,%ecx
  80059f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8005a1:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8005a4:	b9 56 00 00 00       	mov    $0x56,%ecx
  8005a9:	b0 00                	mov    $0x0,%al
  8005ab:	89 d7                	mov    %edx,%edi
  8005ad:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8005af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8005b6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	50                   	push   %eax
  8005bd:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8005c3:	50                   	push   %eax
  8005c4:	e8 ec 24 00 00       	call   802ab5 <sys_utilities>
  8005c9:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8005cc:	e8 35 20 00 00       	call   802606 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8005d1:	83 ec 0c             	sub    $0xc,%esp
  8005d4:	68 d4 40 80 00       	push   $0x8040d4
  8005d9:	e8 cc 03 00 00       	call   8009aa <cprintf>
  8005de:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8005e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e4:	85 c0                	test   %eax,%eax
  8005e6:	74 18                	je     800600 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8005e8:	e8 e6 24 00 00       	call   802ad3 <sys_get_optimal_num_faults>
  8005ed:	83 ec 08             	sub    $0x8,%esp
  8005f0:	50                   	push   %eax
  8005f1:	68 fc 40 80 00       	push   $0x8040fc
  8005f6:	e8 af 03 00 00       	call   8009aa <cprintf>
  8005fb:	83 c4 10             	add    $0x10,%esp
  8005fe:	eb 59                	jmp    800659 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800600:	a1 20 50 80 00       	mov    0x805020,%eax
  800605:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  80060b:	a1 20 50 80 00       	mov    0x805020,%eax
  800610:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800616:	83 ec 04             	sub    $0x4,%esp
  800619:	52                   	push   %edx
  80061a:	50                   	push   %eax
  80061b:	68 20 41 80 00       	push   $0x804120
  800620:	e8 85 03 00 00       	call   8009aa <cprintf>
  800625:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800628:	a1 20 50 80 00       	mov    0x805020,%eax
  80062d:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800633:	a1 20 50 80 00       	mov    0x805020,%eax
  800638:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  80063e:	a1 20 50 80 00       	mov    0x805020,%eax
  800643:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800649:	51                   	push   %ecx
  80064a:	52                   	push   %edx
  80064b:	50                   	push   %eax
  80064c:	68 48 41 80 00       	push   $0x804148
  800651:	e8 54 03 00 00       	call   8009aa <cprintf>
  800656:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800659:	a1 20 50 80 00       	mov    0x805020,%eax
  80065e:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800664:	83 ec 08             	sub    $0x8,%esp
  800667:	50                   	push   %eax
  800668:	68 a0 41 80 00       	push   $0x8041a0
  80066d:	e8 38 03 00 00       	call   8009aa <cprintf>
  800672:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800675:	83 ec 0c             	sub    $0xc,%esp
  800678:	68 d4 40 80 00       	push   $0x8040d4
  80067d:	e8 28 03 00 00       	call   8009aa <cprintf>
  800682:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800685:	e8 96 1f 00 00       	call   802620 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80068a:	e8 1f 00 00 00       	call   8006ae <exit>
}
  80068f:	90                   	nop
  800690:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800693:	5b                   	pop    %ebx
  800694:	5e                   	pop    %esi
  800695:	5f                   	pop    %edi
  800696:	5d                   	pop    %ebp
  800697:	c3                   	ret    

00800698 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800698:	55                   	push   %ebp
  800699:	89 e5                	mov    %esp,%ebp
  80069b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80069e:	83 ec 0c             	sub    $0xc,%esp
  8006a1:	6a 00                	push   $0x0
  8006a3:	e8 a3 21 00 00       	call   80284b <sys_destroy_env>
  8006a8:	83 c4 10             	add    $0x10,%esp
}
  8006ab:	90                   	nop
  8006ac:	c9                   	leave  
  8006ad:	c3                   	ret    

008006ae <exit>:

void
exit(void)
{
  8006ae:	55                   	push   %ebp
  8006af:	89 e5                	mov    %esp,%ebp
  8006b1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006b4:	e8 f8 21 00 00       	call   8028b1 <sys_exit_env>
}
  8006b9:	90                   	nop
  8006ba:	c9                   	leave  
  8006bb:	c3                   	ret    

008006bc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006bc:	55                   	push   %ebp
  8006bd:	89 e5                	mov    %esp,%ebp
  8006bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006c2:	8d 45 10             	lea    0x10(%ebp),%eax
  8006c5:	83 c0 04             	add    $0x4,%eax
  8006c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006cb:	a1 18 d1 81 00       	mov    0x81d118,%eax
  8006d0:	85 c0                	test   %eax,%eax
  8006d2:	74 16                	je     8006ea <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006d4:	a1 18 d1 81 00       	mov    0x81d118,%eax
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	50                   	push   %eax
  8006dd:	68 18 42 80 00       	push   $0x804218
  8006e2:	e8 c3 02 00 00       	call   8009aa <cprintf>
  8006e7:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8006ea:	a1 04 50 80 00       	mov    0x805004,%eax
  8006ef:	83 ec 0c             	sub    $0xc,%esp
  8006f2:	ff 75 0c             	pushl  0xc(%ebp)
  8006f5:	ff 75 08             	pushl  0x8(%ebp)
  8006f8:	50                   	push   %eax
  8006f9:	68 20 42 80 00       	push   $0x804220
  8006fe:	6a 74                	push   $0x74
  800700:	e8 d2 02 00 00       	call   8009d7 <cprintf_colored>
  800705:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800708:	8b 45 10             	mov    0x10(%ebp),%eax
  80070b:	83 ec 08             	sub    $0x8,%esp
  80070e:	ff 75 f4             	pushl  -0xc(%ebp)
  800711:	50                   	push   %eax
  800712:	e8 24 02 00 00       	call   80093b <vcprintf>
  800717:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80071a:	83 ec 08             	sub    $0x8,%esp
  80071d:	6a 00                	push   $0x0
  80071f:	68 48 42 80 00       	push   $0x804248
  800724:	e8 12 02 00 00       	call   80093b <vcprintf>
  800729:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80072c:	e8 7d ff ff ff       	call   8006ae <exit>

	// should not return here
	while (1) ;
  800731:	eb fe                	jmp    800731 <_panic+0x75>

00800733 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800733:	55                   	push   %ebp
  800734:	89 e5                	mov    %esp,%ebp
  800736:	53                   	push   %ebx
  800737:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80073a:	a1 20 50 80 00       	mov    0x805020,%eax
  80073f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800745:	8b 45 0c             	mov    0xc(%ebp),%eax
  800748:	39 c2                	cmp    %eax,%edx
  80074a:	74 14                	je     800760 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80074c:	83 ec 04             	sub    $0x4,%esp
  80074f:	68 4c 42 80 00       	push   $0x80424c
  800754:	6a 26                	push   $0x26
  800756:	68 98 42 80 00       	push   $0x804298
  80075b:	e8 5c ff ff ff       	call   8006bc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800760:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800767:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80076e:	e9 d9 00 00 00       	jmp    80084c <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800773:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800776:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	01 d0                	add    %edx,%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	85 c0                	test   %eax,%eax
  800786:	75 08                	jne    800790 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  800788:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80078b:	e9 b9 00 00 00       	jmp    800849 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800790:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800797:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80079e:	eb 79                	jmp    800819 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8007a5:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8007ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007ae:	89 d0                	mov    %edx,%eax
  8007b0:	01 c0                	add    %eax,%eax
  8007b2:	01 d0                	add    %edx,%eax
  8007b4:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8007bb:	01 d8                	add    %ebx,%eax
  8007bd:	01 d0                	add    %edx,%eax
  8007bf:	01 c8                	add    %ecx,%eax
  8007c1:	8a 40 04             	mov    0x4(%eax),%al
  8007c4:	84 c0                	test   %al,%al
  8007c6:	75 4e                	jne    800816 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007c8:	a1 20 50 80 00       	mov    0x805020,%eax
  8007cd:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8007d3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007d6:	89 d0                	mov    %edx,%eax
  8007d8:	01 c0                	add    %eax,%eax
  8007da:	01 d0                	add    %edx,%eax
  8007dc:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8007e3:	01 d8                	add    %ebx,%eax
  8007e5:	01 d0                	add    %edx,%eax
  8007e7:	01 c8                	add    %ecx,%eax
  8007e9:	8b 00                	mov    (%eax),%eax
  8007eb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007f6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007fb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800802:	8b 45 08             	mov    0x8(%ebp),%eax
  800805:	01 c8                	add    %ecx,%eax
  800807:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800809:	39 c2                	cmp    %eax,%edx
  80080b:	75 09                	jne    800816 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  80080d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800814:	eb 19                	jmp    80082f <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800816:	ff 45 e8             	incl   -0x18(%ebp)
  800819:	a1 20 50 80 00       	mov    0x805020,%eax
  80081e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800824:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800827:	39 c2                	cmp    %eax,%edx
  800829:	0f 87 71 ff ff ff    	ja     8007a0 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80082f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800833:	75 14                	jne    800849 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800835:	83 ec 04             	sub    $0x4,%esp
  800838:	68 a4 42 80 00       	push   $0x8042a4
  80083d:	6a 3a                	push   $0x3a
  80083f:	68 98 42 80 00       	push   $0x804298
  800844:	e8 73 fe ff ff       	call   8006bc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800849:	ff 45 f0             	incl   -0x10(%ebp)
  80084c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800852:	0f 8c 1b ff ff ff    	jl     800773 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800858:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80085f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800866:	eb 2e                	jmp    800896 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800868:	a1 20 50 80 00       	mov    0x805020,%eax
  80086d:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800873:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800876:	89 d0                	mov    %edx,%eax
  800878:	01 c0                	add    %eax,%eax
  80087a:	01 d0                	add    %edx,%eax
  80087c:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800883:	01 d8                	add    %ebx,%eax
  800885:	01 d0                	add    %edx,%eax
  800887:	01 c8                	add    %ecx,%eax
  800889:	8a 40 04             	mov    0x4(%eax),%al
  80088c:	3c 01                	cmp    $0x1,%al
  80088e:	75 03                	jne    800893 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800890:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800893:	ff 45 e0             	incl   -0x20(%ebp)
  800896:	a1 20 50 80 00       	mov    0x805020,%eax
  80089b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8008a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008a4:	39 c2                	cmp    %eax,%edx
  8008a6:	77 c0                	ja     800868 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ab:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008ae:	74 14                	je     8008c4 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  8008b0:	83 ec 04             	sub    $0x4,%esp
  8008b3:	68 f8 42 80 00       	push   $0x8042f8
  8008b8:	6a 44                	push   $0x44
  8008ba:	68 98 42 80 00       	push   $0x804298
  8008bf:	e8 f8 fd ff ff       	call   8006bc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008c4:	90                   	nop
  8008c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c8:	c9                   	leave  
  8008c9:	c3                   	ret    

008008ca <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8008ca:	55                   	push   %ebp
  8008cb:	89 e5                	mov    %esp,%ebp
  8008cd:	53                   	push   %ebx
  8008ce:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8008d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d4:	8b 00                	mov    (%eax),%eax
  8008d6:	8d 48 01             	lea    0x1(%eax),%ecx
  8008d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008dc:	89 0a                	mov    %ecx,(%edx)
  8008de:	8b 55 08             	mov    0x8(%ebp),%edx
  8008e1:	88 d1                	mov    %dl,%cl
  8008e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ed:	8b 00                	mov    (%eax),%eax
  8008ef:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008f4:	75 30                	jne    800926 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8008f6:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  8008fc:	a0 44 50 80 00       	mov    0x805044,%al
  800901:	0f b6 c0             	movzbl %al,%eax
  800904:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800907:	8b 09                	mov    (%ecx),%ecx
  800909:	89 cb                	mov    %ecx,%ebx
  80090b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80090e:	83 c1 08             	add    $0x8,%ecx
  800911:	52                   	push   %edx
  800912:	50                   	push   %eax
  800913:	53                   	push   %ebx
  800914:	51                   	push   %ecx
  800915:	e8 a8 1c 00 00       	call   8025c2 <sys_cputs>
  80091a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800926:	8b 45 0c             	mov    0xc(%ebp),%eax
  800929:	8b 40 04             	mov    0x4(%eax),%eax
  80092c:	8d 50 01             	lea    0x1(%eax),%edx
  80092f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800932:	89 50 04             	mov    %edx,0x4(%eax)
}
  800935:	90                   	nop
  800936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800939:	c9                   	leave  
  80093a:	c3                   	ret    

0080093b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800944:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80094b:	00 00 00 
	b.cnt = 0;
  80094e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800955:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800958:	ff 75 0c             	pushl  0xc(%ebp)
  80095b:	ff 75 08             	pushl  0x8(%ebp)
  80095e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800964:	50                   	push   %eax
  800965:	68 ca 08 80 00       	push   $0x8008ca
  80096a:	e8 5a 02 00 00       	call   800bc9 <vprintfmt>
  80096f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800972:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800978:	a0 44 50 80 00       	mov    0x805044,%al
  80097d:	0f b6 c0             	movzbl %al,%eax
  800980:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800986:	52                   	push   %edx
  800987:	50                   	push   %eax
  800988:	51                   	push   %ecx
  800989:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80098f:	83 c0 08             	add    $0x8,%eax
  800992:	50                   	push   %eax
  800993:	e8 2a 1c 00 00       	call   8025c2 <sys_cputs>
  800998:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80099b:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  8009a2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009a8:	c9                   	leave  
  8009a9:	c3                   	ret    

008009aa <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009b0:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  8009b7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	83 ec 08             	sub    $0x8,%esp
  8009c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009c6:	50                   	push   %eax
  8009c7:	e8 6f ff ff ff       	call   80093b <vcprintf>
  8009cc:	83 c4 10             	add    $0x10,%esp
  8009cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009d5:	c9                   	leave  
  8009d6:	c3                   	ret    

008009d7 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8009d7:	55                   	push   %ebp
  8009d8:	89 e5                	mov    %esp,%ebp
  8009da:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009dd:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8009e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e7:	c1 e0 08             	shl    $0x8,%eax
  8009ea:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  8009ef:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009f2:	83 c0 04             	add    $0x4,%eax
  8009f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	ff 75 f4             	pushl  -0xc(%ebp)
  800a01:	50                   	push   %eax
  800a02:	e8 34 ff ff ff       	call   80093b <vcprintf>
  800a07:	83 c4 10             	add    $0x10,%esp
  800a0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800a0d:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  800a14:	07 00 00 

	return cnt;
  800a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a1a:	c9                   	leave  
  800a1b:	c3                   	ret    

00800a1c <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800a22:	e8 df 1b 00 00       	call   802606 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800a27:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	83 ec 08             	sub    $0x8,%esp
  800a33:	ff 75 f4             	pushl  -0xc(%ebp)
  800a36:	50                   	push   %eax
  800a37:	e8 ff fe ff ff       	call   80093b <vcprintf>
  800a3c:	83 c4 10             	add    $0x10,%esp
  800a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800a42:	e8 d9 1b 00 00       	call   802620 <sys_unlock_cons>
	return cnt;
  800a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a4a:	c9                   	leave  
  800a4b:	c3                   	ret    

00800a4c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	53                   	push   %ebx
  800a50:	83 ec 14             	sub    $0x14,%esp
  800a53:	8b 45 10             	mov    0x10(%ebp),%eax
  800a56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a59:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a5f:	8b 45 18             	mov    0x18(%ebp),%eax
  800a62:	ba 00 00 00 00       	mov    $0x0,%edx
  800a67:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a6a:	77 55                	ja     800ac1 <printnum+0x75>
  800a6c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a6f:	72 05                	jb     800a76 <printnum+0x2a>
  800a71:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a74:	77 4b                	ja     800ac1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a76:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a79:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a7c:	8b 45 18             	mov    0x18(%ebp),%eax
  800a7f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a84:	52                   	push   %edx
  800a85:	50                   	push   %eax
  800a86:	ff 75 f4             	pushl  -0xc(%ebp)
  800a89:	ff 75 f0             	pushl  -0x10(%ebp)
  800a8c:	e8 93 2e 00 00       	call   803924 <__udivdi3>
  800a91:	83 c4 10             	add    $0x10,%esp
  800a94:	83 ec 04             	sub    $0x4,%esp
  800a97:	ff 75 20             	pushl  0x20(%ebp)
  800a9a:	53                   	push   %ebx
  800a9b:	ff 75 18             	pushl  0x18(%ebp)
  800a9e:	52                   	push   %edx
  800a9f:	50                   	push   %eax
  800aa0:	ff 75 0c             	pushl  0xc(%ebp)
  800aa3:	ff 75 08             	pushl  0x8(%ebp)
  800aa6:	e8 a1 ff ff ff       	call   800a4c <printnum>
  800aab:	83 c4 20             	add    $0x20,%esp
  800aae:	eb 1a                	jmp    800aca <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ab0:	83 ec 08             	sub    $0x8,%esp
  800ab3:	ff 75 0c             	pushl  0xc(%ebp)
  800ab6:	ff 75 20             	pushl  0x20(%ebp)
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	ff d0                	call   *%eax
  800abe:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ac1:	ff 4d 1c             	decl   0x1c(%ebp)
  800ac4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ac8:	7f e6                	jg     800ab0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800aca:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800acd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ad2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ad5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ad8:	53                   	push   %ebx
  800ad9:	51                   	push   %ecx
  800ada:	52                   	push   %edx
  800adb:	50                   	push   %eax
  800adc:	e8 53 2f 00 00       	call   803a34 <__umoddi3>
  800ae1:	83 c4 10             	add    $0x10,%esp
  800ae4:	05 74 45 80 00       	add    $0x804574,%eax
  800ae9:	8a 00                	mov    (%eax),%al
  800aeb:	0f be c0             	movsbl %al,%eax
  800aee:	83 ec 08             	sub    $0x8,%esp
  800af1:	ff 75 0c             	pushl  0xc(%ebp)
  800af4:	50                   	push   %eax
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	ff d0                	call   *%eax
  800afa:	83 c4 10             	add    $0x10,%esp
}
  800afd:	90                   	nop
  800afe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b01:	c9                   	leave  
  800b02:	c3                   	ret    

00800b03 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b03:	55                   	push   %ebp
  800b04:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b06:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b0a:	7e 1c                	jle    800b28 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	8b 00                	mov    (%eax),%eax
  800b11:	8d 50 08             	lea    0x8(%eax),%edx
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	89 10                	mov    %edx,(%eax)
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 00                	mov    (%eax),%eax
  800b1e:	83 e8 08             	sub    $0x8,%eax
  800b21:	8b 50 04             	mov    0x4(%eax),%edx
  800b24:	8b 00                	mov    (%eax),%eax
  800b26:	eb 40                	jmp    800b68 <getuint+0x65>
	else if (lflag)
  800b28:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b2c:	74 1e                	je     800b4c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b31:	8b 00                	mov    (%eax),%eax
  800b33:	8d 50 04             	lea    0x4(%eax),%edx
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	89 10                	mov    %edx,(%eax)
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	8b 00                	mov    (%eax),%eax
  800b40:	83 e8 04             	sub    $0x4,%eax
  800b43:	8b 00                	mov    (%eax),%eax
  800b45:	ba 00 00 00 00       	mov    $0x0,%edx
  800b4a:	eb 1c                	jmp    800b68 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	8b 00                	mov    (%eax),%eax
  800b51:	8d 50 04             	lea    0x4(%eax),%edx
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	89 10                	mov    %edx,(%eax)
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	8b 00                	mov    (%eax),%eax
  800b5e:	83 e8 04             	sub    $0x4,%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b68:	5d                   	pop    %ebp
  800b69:	c3                   	ret    

00800b6a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b6d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b71:	7e 1c                	jle    800b8f <getint+0x25>
		return va_arg(*ap, long long);
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	8b 00                	mov    (%eax),%eax
  800b78:	8d 50 08             	lea    0x8(%eax),%edx
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	89 10                	mov    %edx,(%eax)
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	8b 00                	mov    (%eax),%eax
  800b85:	83 e8 08             	sub    $0x8,%eax
  800b88:	8b 50 04             	mov    0x4(%eax),%edx
  800b8b:	8b 00                	mov    (%eax),%eax
  800b8d:	eb 38                	jmp    800bc7 <getint+0x5d>
	else if (lflag)
  800b8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b93:	74 1a                	je     800baf <getint+0x45>
		return va_arg(*ap, long);
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	8b 00                	mov    (%eax),%eax
  800b9a:	8d 50 04             	lea    0x4(%eax),%edx
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	89 10                	mov    %edx,(%eax)
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	8b 00                	mov    (%eax),%eax
  800ba7:	83 e8 04             	sub    $0x4,%eax
  800baa:	8b 00                	mov    (%eax),%eax
  800bac:	99                   	cltd   
  800bad:	eb 18                	jmp    800bc7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8b 00                	mov    (%eax),%eax
  800bb4:	8d 50 04             	lea    0x4(%eax),%edx
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	89 10                	mov    %edx,(%eax)
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8b 00                	mov    (%eax),%eax
  800bc1:	83 e8 04             	sub    $0x4,%eax
  800bc4:	8b 00                	mov    (%eax),%eax
  800bc6:	99                   	cltd   
}
  800bc7:	5d                   	pop    %ebp
  800bc8:	c3                   	ret    

00800bc9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	56                   	push   %esi
  800bcd:	53                   	push   %ebx
  800bce:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bd1:	eb 17                	jmp    800bea <vprintfmt+0x21>
			if (ch == '\0')
  800bd3:	85 db                	test   %ebx,%ebx
  800bd5:	0f 84 c1 03 00 00    	je     800f9c <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800bdb:	83 ec 08             	sub    $0x8,%esp
  800bde:	ff 75 0c             	pushl  0xc(%ebp)
  800be1:	53                   	push   %ebx
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	ff d0                	call   *%eax
  800be7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bea:	8b 45 10             	mov    0x10(%ebp),%eax
  800bed:	8d 50 01             	lea    0x1(%eax),%edx
  800bf0:	89 55 10             	mov    %edx,0x10(%ebp)
  800bf3:	8a 00                	mov    (%eax),%al
  800bf5:	0f b6 d8             	movzbl %al,%ebx
  800bf8:	83 fb 25             	cmp    $0x25,%ebx
  800bfb:	75 d6                	jne    800bd3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800bfd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c01:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c08:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c0f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c16:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c20:	8d 50 01             	lea    0x1(%eax),%edx
  800c23:	89 55 10             	mov    %edx,0x10(%ebp)
  800c26:	8a 00                	mov    (%eax),%al
  800c28:	0f b6 d8             	movzbl %al,%ebx
  800c2b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c2e:	83 f8 5b             	cmp    $0x5b,%eax
  800c31:	0f 87 3d 03 00 00    	ja     800f74 <vprintfmt+0x3ab>
  800c37:	8b 04 85 98 45 80 00 	mov    0x804598(,%eax,4),%eax
  800c3e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c40:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c44:	eb d7                	jmp    800c1d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c46:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c4a:	eb d1                	jmp    800c1d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c4c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c53:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c56:	89 d0                	mov    %edx,%eax
  800c58:	c1 e0 02             	shl    $0x2,%eax
  800c5b:	01 d0                	add    %edx,%eax
  800c5d:	01 c0                	add    %eax,%eax
  800c5f:	01 d8                	add    %ebx,%eax
  800c61:	83 e8 30             	sub    $0x30,%eax
  800c64:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c67:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6a:	8a 00                	mov    (%eax),%al
  800c6c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c6f:	83 fb 2f             	cmp    $0x2f,%ebx
  800c72:	7e 3e                	jle    800cb2 <vprintfmt+0xe9>
  800c74:	83 fb 39             	cmp    $0x39,%ebx
  800c77:	7f 39                	jg     800cb2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c79:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c7c:	eb d5                	jmp    800c53 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c81:	83 c0 04             	add    $0x4,%eax
  800c84:	89 45 14             	mov    %eax,0x14(%ebp)
  800c87:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8a:	83 e8 04             	sub    $0x4,%eax
  800c8d:	8b 00                	mov    (%eax),%eax
  800c8f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c92:	eb 1f                	jmp    800cb3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c98:	79 83                	jns    800c1d <vprintfmt+0x54>
				width = 0;
  800c9a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ca1:	e9 77 ff ff ff       	jmp    800c1d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ca6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800cad:	e9 6b ff ff ff       	jmp    800c1d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cb2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cb3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cb7:	0f 89 60 ff ff ff    	jns    800c1d <vprintfmt+0x54>
				width = precision, precision = -1;
  800cbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cc3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cca:	e9 4e ff ff ff       	jmp    800c1d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ccf:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cd2:	e9 46 ff ff ff       	jmp    800c1d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cd7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cda:	83 c0 04             	add    $0x4,%eax
  800cdd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce3:	83 e8 04             	sub    $0x4,%eax
  800ce6:	8b 00                	mov    (%eax),%eax
  800ce8:	83 ec 08             	sub    $0x8,%esp
  800ceb:	ff 75 0c             	pushl  0xc(%ebp)
  800cee:	50                   	push   %eax
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	ff d0                	call   *%eax
  800cf4:	83 c4 10             	add    $0x10,%esp
			break;
  800cf7:	e9 9b 02 00 00       	jmp    800f97 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cfc:	8b 45 14             	mov    0x14(%ebp),%eax
  800cff:	83 c0 04             	add    $0x4,%eax
  800d02:	89 45 14             	mov    %eax,0x14(%ebp)
  800d05:	8b 45 14             	mov    0x14(%ebp),%eax
  800d08:	83 e8 04             	sub    $0x4,%eax
  800d0b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d0d:	85 db                	test   %ebx,%ebx
  800d0f:	79 02                	jns    800d13 <vprintfmt+0x14a>
				err = -err;
  800d11:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d13:	83 fb 64             	cmp    $0x64,%ebx
  800d16:	7f 0b                	jg     800d23 <vprintfmt+0x15a>
  800d18:	8b 34 9d e0 43 80 00 	mov    0x8043e0(,%ebx,4),%esi
  800d1f:	85 f6                	test   %esi,%esi
  800d21:	75 19                	jne    800d3c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d23:	53                   	push   %ebx
  800d24:	68 85 45 80 00       	push   $0x804585
  800d29:	ff 75 0c             	pushl  0xc(%ebp)
  800d2c:	ff 75 08             	pushl  0x8(%ebp)
  800d2f:	e8 70 02 00 00       	call   800fa4 <printfmt>
  800d34:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d37:	e9 5b 02 00 00       	jmp    800f97 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d3c:	56                   	push   %esi
  800d3d:	68 8e 45 80 00       	push   $0x80458e
  800d42:	ff 75 0c             	pushl  0xc(%ebp)
  800d45:	ff 75 08             	pushl  0x8(%ebp)
  800d48:	e8 57 02 00 00       	call   800fa4 <printfmt>
  800d4d:	83 c4 10             	add    $0x10,%esp
			break;
  800d50:	e9 42 02 00 00       	jmp    800f97 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d55:	8b 45 14             	mov    0x14(%ebp),%eax
  800d58:	83 c0 04             	add    $0x4,%eax
  800d5b:	89 45 14             	mov    %eax,0x14(%ebp)
  800d5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d61:	83 e8 04             	sub    $0x4,%eax
  800d64:	8b 30                	mov    (%eax),%esi
  800d66:	85 f6                	test   %esi,%esi
  800d68:	75 05                	jne    800d6f <vprintfmt+0x1a6>
				p = "(null)";
  800d6a:	be 91 45 80 00       	mov    $0x804591,%esi
			if (width > 0 && padc != '-')
  800d6f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d73:	7e 6d                	jle    800de2 <vprintfmt+0x219>
  800d75:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d79:	74 67                	je     800de2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d7e:	83 ec 08             	sub    $0x8,%esp
  800d81:	50                   	push   %eax
  800d82:	56                   	push   %esi
  800d83:	e8 1e 03 00 00       	call   8010a6 <strnlen>
  800d88:	83 c4 10             	add    $0x10,%esp
  800d8b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d8e:	eb 16                	jmp    800da6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d90:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d94:	83 ec 08             	sub    $0x8,%esp
  800d97:	ff 75 0c             	pushl  0xc(%ebp)
  800d9a:	50                   	push   %eax
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	ff d0                	call   *%eax
  800da0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800da3:	ff 4d e4             	decl   -0x1c(%ebp)
  800da6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800daa:	7f e4                	jg     800d90 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dac:	eb 34                	jmp    800de2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800dae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800db2:	74 1c                	je     800dd0 <vprintfmt+0x207>
  800db4:	83 fb 1f             	cmp    $0x1f,%ebx
  800db7:	7e 05                	jle    800dbe <vprintfmt+0x1f5>
  800db9:	83 fb 7e             	cmp    $0x7e,%ebx
  800dbc:	7e 12                	jle    800dd0 <vprintfmt+0x207>
					putch('?', putdat);
  800dbe:	83 ec 08             	sub    $0x8,%esp
  800dc1:	ff 75 0c             	pushl  0xc(%ebp)
  800dc4:	6a 3f                	push   $0x3f
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	ff d0                	call   *%eax
  800dcb:	83 c4 10             	add    $0x10,%esp
  800dce:	eb 0f                	jmp    800ddf <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800dd0:	83 ec 08             	sub    $0x8,%esp
  800dd3:	ff 75 0c             	pushl  0xc(%ebp)
  800dd6:	53                   	push   %ebx
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	ff d0                	call   *%eax
  800ddc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ddf:	ff 4d e4             	decl   -0x1c(%ebp)
  800de2:	89 f0                	mov    %esi,%eax
  800de4:	8d 70 01             	lea    0x1(%eax),%esi
  800de7:	8a 00                	mov    (%eax),%al
  800de9:	0f be d8             	movsbl %al,%ebx
  800dec:	85 db                	test   %ebx,%ebx
  800dee:	74 24                	je     800e14 <vprintfmt+0x24b>
  800df0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800df4:	78 b8                	js     800dae <vprintfmt+0x1e5>
  800df6:	ff 4d e0             	decl   -0x20(%ebp)
  800df9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dfd:	79 af                	jns    800dae <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dff:	eb 13                	jmp    800e14 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e01:	83 ec 08             	sub    $0x8,%esp
  800e04:	ff 75 0c             	pushl  0xc(%ebp)
  800e07:	6a 20                	push   $0x20
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	ff d0                	call   *%eax
  800e0e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e11:	ff 4d e4             	decl   -0x1c(%ebp)
  800e14:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e18:	7f e7                	jg     800e01 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e1a:	e9 78 01 00 00       	jmp    800f97 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e1f:	83 ec 08             	sub    $0x8,%esp
  800e22:	ff 75 e8             	pushl  -0x18(%ebp)
  800e25:	8d 45 14             	lea    0x14(%ebp),%eax
  800e28:	50                   	push   %eax
  800e29:	e8 3c fd ff ff       	call   800b6a <getint>
  800e2e:	83 c4 10             	add    $0x10,%esp
  800e31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e34:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3d:	85 d2                	test   %edx,%edx
  800e3f:	79 23                	jns    800e64 <vprintfmt+0x29b>
				putch('-', putdat);
  800e41:	83 ec 08             	sub    $0x8,%esp
  800e44:	ff 75 0c             	pushl  0xc(%ebp)
  800e47:	6a 2d                	push   $0x2d
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	ff d0                	call   *%eax
  800e4e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e57:	f7 d8                	neg    %eax
  800e59:	83 d2 00             	adc    $0x0,%edx
  800e5c:	f7 da                	neg    %edx
  800e5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e61:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e64:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e6b:	e9 bc 00 00 00       	jmp    800f2c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e70:	83 ec 08             	sub    $0x8,%esp
  800e73:	ff 75 e8             	pushl  -0x18(%ebp)
  800e76:	8d 45 14             	lea    0x14(%ebp),%eax
  800e79:	50                   	push   %eax
  800e7a:	e8 84 fc ff ff       	call   800b03 <getuint>
  800e7f:	83 c4 10             	add    $0x10,%esp
  800e82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e85:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e88:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e8f:	e9 98 00 00 00       	jmp    800f2c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e94:	83 ec 08             	sub    $0x8,%esp
  800e97:	ff 75 0c             	pushl  0xc(%ebp)
  800e9a:	6a 58                	push   $0x58
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	ff d0                	call   *%eax
  800ea1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ea4:	83 ec 08             	sub    $0x8,%esp
  800ea7:	ff 75 0c             	pushl  0xc(%ebp)
  800eaa:	6a 58                	push   $0x58
  800eac:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaf:	ff d0                	call   *%eax
  800eb1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800eb4:	83 ec 08             	sub    $0x8,%esp
  800eb7:	ff 75 0c             	pushl  0xc(%ebp)
  800eba:	6a 58                	push   $0x58
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	ff d0                	call   *%eax
  800ec1:	83 c4 10             	add    $0x10,%esp
			break;
  800ec4:	e9 ce 00 00 00       	jmp    800f97 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ec9:	83 ec 08             	sub    $0x8,%esp
  800ecc:	ff 75 0c             	pushl  0xc(%ebp)
  800ecf:	6a 30                	push   $0x30
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	ff d0                	call   *%eax
  800ed6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ed9:	83 ec 08             	sub    $0x8,%esp
  800edc:	ff 75 0c             	pushl  0xc(%ebp)
  800edf:	6a 78                	push   $0x78
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	ff d0                	call   *%eax
  800ee6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ee9:	8b 45 14             	mov    0x14(%ebp),%eax
  800eec:	83 c0 04             	add    $0x4,%eax
  800eef:	89 45 14             	mov    %eax,0x14(%ebp)
  800ef2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef5:	83 e8 04             	sub    $0x4,%eax
  800ef8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800efa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800efd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f04:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f0b:	eb 1f                	jmp    800f2c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f0d:	83 ec 08             	sub    $0x8,%esp
  800f10:	ff 75 e8             	pushl  -0x18(%ebp)
  800f13:	8d 45 14             	lea    0x14(%ebp),%eax
  800f16:	50                   	push   %eax
  800f17:	e8 e7 fb ff ff       	call   800b03 <getuint>
  800f1c:	83 c4 10             	add    $0x10,%esp
  800f1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f25:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f2c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f33:	83 ec 04             	sub    $0x4,%esp
  800f36:	52                   	push   %edx
  800f37:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f3a:	50                   	push   %eax
  800f3b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f3e:	ff 75 f0             	pushl  -0x10(%ebp)
  800f41:	ff 75 0c             	pushl  0xc(%ebp)
  800f44:	ff 75 08             	pushl  0x8(%ebp)
  800f47:	e8 00 fb ff ff       	call   800a4c <printnum>
  800f4c:	83 c4 20             	add    $0x20,%esp
			break;
  800f4f:	eb 46                	jmp    800f97 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f51:	83 ec 08             	sub    $0x8,%esp
  800f54:	ff 75 0c             	pushl  0xc(%ebp)
  800f57:	53                   	push   %ebx
  800f58:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5b:	ff d0                	call   *%eax
  800f5d:	83 c4 10             	add    $0x10,%esp
			break;
  800f60:	eb 35                	jmp    800f97 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800f62:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800f69:	eb 2c                	jmp    800f97 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800f6b:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800f72:	eb 23                	jmp    800f97 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f74:	83 ec 08             	sub    $0x8,%esp
  800f77:	ff 75 0c             	pushl  0xc(%ebp)
  800f7a:	6a 25                	push   $0x25
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	ff d0                	call   *%eax
  800f81:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f84:	ff 4d 10             	decl   0x10(%ebp)
  800f87:	eb 03                	jmp    800f8c <vprintfmt+0x3c3>
  800f89:	ff 4d 10             	decl   0x10(%ebp)
  800f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8f:	48                   	dec    %eax
  800f90:	8a 00                	mov    (%eax),%al
  800f92:	3c 25                	cmp    $0x25,%al
  800f94:	75 f3                	jne    800f89 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800f96:	90                   	nop
		}
	}
  800f97:	e9 35 fc ff ff       	jmp    800bd1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f9c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f9d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fa0:	5b                   	pop    %ebx
  800fa1:	5e                   	pop    %esi
  800fa2:	5d                   	pop    %ebp
  800fa3:	c3                   	ret    

00800fa4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800faa:	8d 45 10             	lea    0x10(%ebp),%eax
  800fad:	83 c0 04             	add    $0x4,%eax
  800fb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb6:	ff 75 f4             	pushl  -0xc(%ebp)
  800fb9:	50                   	push   %eax
  800fba:	ff 75 0c             	pushl  0xc(%ebp)
  800fbd:	ff 75 08             	pushl  0x8(%ebp)
  800fc0:	e8 04 fc ff ff       	call   800bc9 <vprintfmt>
  800fc5:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fc8:	90                   	nop
  800fc9:	c9                   	leave  
  800fca:	c3                   	ret    

00800fcb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd1:	8b 40 08             	mov    0x8(%eax),%eax
  800fd4:	8d 50 01             	lea    0x1(%eax),%edx
  800fd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fda:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe0:	8b 10                	mov    (%eax),%edx
  800fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe5:	8b 40 04             	mov    0x4(%eax),%eax
  800fe8:	39 c2                	cmp    %eax,%edx
  800fea:	73 12                	jae    800ffe <sprintputch+0x33>
		*b->buf++ = ch;
  800fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fef:	8b 00                	mov    (%eax),%eax
  800ff1:	8d 48 01             	lea    0x1(%eax),%ecx
  800ff4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ff7:	89 0a                	mov    %ecx,(%edx)
  800ff9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffc:	88 10                	mov    %dl,(%eax)
}
  800ffe:	90                   	nop
  800fff:	5d                   	pop    %ebp
  801000:	c3                   	ret    

00801001 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80100d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801010:	8d 50 ff             	lea    -0x1(%eax),%edx
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	01 d0                	add    %edx,%eax
  801018:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80101b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801022:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801026:	74 06                	je     80102e <vsnprintf+0x2d>
  801028:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80102c:	7f 07                	jg     801035 <vsnprintf+0x34>
		return -E_INVAL;
  80102e:	b8 03 00 00 00       	mov    $0x3,%eax
  801033:	eb 20                	jmp    801055 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801035:	ff 75 14             	pushl  0x14(%ebp)
  801038:	ff 75 10             	pushl  0x10(%ebp)
  80103b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80103e:	50                   	push   %eax
  80103f:	68 cb 0f 80 00       	push   $0x800fcb
  801044:	e8 80 fb ff ff       	call   800bc9 <vprintfmt>
  801049:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80104c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80104f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801052:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801055:	c9                   	leave  
  801056:	c3                   	ret    

00801057 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80105d:	8d 45 10             	lea    0x10(%ebp),%eax
  801060:	83 c0 04             	add    $0x4,%eax
  801063:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801066:	8b 45 10             	mov    0x10(%ebp),%eax
  801069:	ff 75 f4             	pushl  -0xc(%ebp)
  80106c:	50                   	push   %eax
  80106d:	ff 75 0c             	pushl  0xc(%ebp)
  801070:	ff 75 08             	pushl  0x8(%ebp)
  801073:	e8 89 ff ff ff       	call   801001 <vsnprintf>
  801078:	83 c4 10             	add    $0x10,%esp
  80107b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80107e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801081:	c9                   	leave  
  801082:	c3                   	ret    

00801083 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
  801086:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801089:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801090:	eb 06                	jmp    801098 <strlen+0x15>
		n++;
  801092:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801095:	ff 45 08             	incl   0x8(%ebp)
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	84 c0                	test   %al,%al
  80109f:	75 f1                	jne    801092 <strlen+0xf>
		n++;
	return n;
  8010a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010a4:	c9                   	leave  
  8010a5:	c3                   	ret    

008010a6 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
  8010a9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010b3:	eb 09                	jmp    8010be <strnlen+0x18>
		n++;
  8010b5:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010b8:	ff 45 08             	incl   0x8(%ebp)
  8010bb:	ff 4d 0c             	decl   0xc(%ebp)
  8010be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010c2:	74 09                	je     8010cd <strnlen+0x27>
  8010c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c7:	8a 00                	mov    (%eax),%al
  8010c9:	84 c0                	test   %al,%al
  8010cb:	75 e8                	jne    8010b5 <strnlen+0xf>
		n++;
	return n;
  8010cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010d0:	c9                   	leave  
  8010d1:	c3                   	ret    

008010d2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010de:	90                   	nop
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	8d 50 01             	lea    0x1(%eax),%edx
  8010e5:	89 55 08             	mov    %edx,0x8(%ebp)
  8010e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010eb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ee:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010f1:	8a 12                	mov    (%edx),%dl
  8010f3:	88 10                	mov    %dl,(%eax)
  8010f5:	8a 00                	mov    (%eax),%al
  8010f7:	84 c0                	test   %al,%al
  8010f9:	75 e4                	jne    8010df <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010fe:	c9                   	leave  
  8010ff:	c3                   	ret    

00801100 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801100:	55                   	push   %ebp
  801101:	89 e5                	mov    %esp,%ebp
  801103:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80110c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801113:	eb 1f                	jmp    801134 <strncpy+0x34>
		*dst++ = *src;
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	8d 50 01             	lea    0x1(%eax),%edx
  80111b:	89 55 08             	mov    %edx,0x8(%ebp)
  80111e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801121:	8a 12                	mov    (%edx),%dl
  801123:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801125:	8b 45 0c             	mov    0xc(%ebp),%eax
  801128:	8a 00                	mov    (%eax),%al
  80112a:	84 c0                	test   %al,%al
  80112c:	74 03                	je     801131 <strncpy+0x31>
			src++;
  80112e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801131:	ff 45 fc             	incl   -0x4(%ebp)
  801134:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801137:	3b 45 10             	cmp    0x10(%ebp),%eax
  80113a:	72 d9                	jb     801115 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80113c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80113f:	c9                   	leave  
  801140:	c3                   	ret    

00801141 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80114d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801151:	74 30                	je     801183 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801153:	eb 16                	jmp    80116b <strlcpy+0x2a>
			*dst++ = *src++;
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	8d 50 01             	lea    0x1(%eax),%edx
  80115b:	89 55 08             	mov    %edx,0x8(%ebp)
  80115e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801161:	8d 4a 01             	lea    0x1(%edx),%ecx
  801164:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801167:	8a 12                	mov    (%edx),%dl
  801169:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80116b:	ff 4d 10             	decl   0x10(%ebp)
  80116e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801172:	74 09                	je     80117d <strlcpy+0x3c>
  801174:	8b 45 0c             	mov    0xc(%ebp),%eax
  801177:	8a 00                	mov    (%eax),%al
  801179:	84 c0                	test   %al,%al
  80117b:	75 d8                	jne    801155 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80117d:	8b 45 08             	mov    0x8(%ebp),%eax
  801180:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801183:	8b 55 08             	mov    0x8(%ebp),%edx
  801186:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801189:	29 c2                	sub    %eax,%edx
  80118b:	89 d0                	mov    %edx,%eax
}
  80118d:	c9                   	leave  
  80118e:	c3                   	ret    

0080118f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801192:	eb 06                	jmp    80119a <strcmp+0xb>
		p++, q++;
  801194:	ff 45 08             	incl   0x8(%ebp)
  801197:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
  80119d:	8a 00                	mov    (%eax),%al
  80119f:	84 c0                	test   %al,%al
  8011a1:	74 0e                	je     8011b1 <strcmp+0x22>
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	8a 10                	mov    (%eax),%dl
  8011a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ab:	8a 00                	mov    (%eax),%al
  8011ad:	38 c2                	cmp    %al,%dl
  8011af:	74 e3                	je     801194 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b4:	8a 00                	mov    (%eax),%al
  8011b6:	0f b6 d0             	movzbl %al,%edx
  8011b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	0f b6 c0             	movzbl %al,%eax
  8011c1:	29 c2                	sub    %eax,%edx
  8011c3:	89 d0                	mov    %edx,%eax
}
  8011c5:	5d                   	pop    %ebp
  8011c6:	c3                   	ret    

008011c7 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8011ca:	eb 09                	jmp    8011d5 <strncmp+0xe>
		n--, p++, q++;
  8011cc:	ff 4d 10             	decl   0x10(%ebp)
  8011cf:	ff 45 08             	incl   0x8(%ebp)
  8011d2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d9:	74 17                	je     8011f2 <strncmp+0x2b>
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	8a 00                	mov    (%eax),%al
  8011e0:	84 c0                	test   %al,%al
  8011e2:	74 0e                	je     8011f2 <strncmp+0x2b>
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	8a 10                	mov    (%eax),%dl
  8011e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	38 c2                	cmp    %al,%dl
  8011f0:	74 da                	je     8011cc <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011f6:	75 07                	jne    8011ff <strncmp+0x38>
		return 0;
  8011f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8011fd:	eb 14                	jmp    801213 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	0f b6 d0             	movzbl %al,%edx
  801207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	0f b6 c0             	movzbl %al,%eax
  80120f:	29 c2                	sub    %eax,%edx
  801211:	89 d0                	mov    %edx,%eax
}
  801213:	5d                   	pop    %ebp
  801214:	c3                   	ret    

00801215 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	83 ec 04             	sub    $0x4,%esp
  80121b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801221:	eb 12                	jmp    801235 <strchr+0x20>
		if (*s == c)
  801223:	8b 45 08             	mov    0x8(%ebp),%eax
  801226:	8a 00                	mov    (%eax),%al
  801228:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80122b:	75 05                	jne    801232 <strchr+0x1d>
			return (char *) s;
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	eb 11                	jmp    801243 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801232:	ff 45 08             	incl   0x8(%ebp)
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	8a 00                	mov    (%eax),%al
  80123a:	84 c0                	test   %al,%al
  80123c:	75 e5                	jne    801223 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80123e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801243:	c9                   	leave  
  801244:	c3                   	ret    

00801245 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
  801248:	83 ec 04             	sub    $0x4,%esp
  80124b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801251:	eb 0d                	jmp    801260 <strfind+0x1b>
		if (*s == c)
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	8a 00                	mov    (%eax),%al
  801258:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80125b:	74 0e                	je     80126b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80125d:	ff 45 08             	incl   0x8(%ebp)
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	8a 00                	mov    (%eax),%al
  801265:	84 c0                	test   %al,%al
  801267:	75 ea                	jne    801253 <strfind+0xe>
  801269:	eb 01                	jmp    80126c <strfind+0x27>
		if (*s == c)
			break;
  80126b:	90                   	nop
	return (char *) s;
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80126f:	c9                   	leave  
  801270:	c3                   	ret    

00801271 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80127d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801281:	76 63                	jbe    8012e6 <memset+0x75>
		uint64 data_block = c;
  801283:	8b 45 0c             	mov    0xc(%ebp),%eax
  801286:	99                   	cltd   
  801287:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80128a:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80128d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801290:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801293:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801297:	c1 e0 08             	shl    $0x8,%eax
  80129a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80129d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8012a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a6:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8012aa:	c1 e0 10             	shl    $0x10,%eax
  8012ad:	09 45 f0             	or     %eax,-0x10(%ebp)
  8012b0:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8012b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b9:	89 c2                	mov    %eax,%edx
  8012bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c0:	09 45 f0             	or     %eax,-0x10(%ebp)
  8012c3:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8012c6:	eb 18                	jmp    8012e0 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8012c8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012cb:	8d 41 08             	lea    0x8(%ecx),%eax
  8012ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8012d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012d7:	89 01                	mov    %eax,(%ecx)
  8012d9:	89 51 04             	mov    %edx,0x4(%ecx)
  8012dc:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8012e0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012e4:	77 e2                	ja     8012c8 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8012e6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ea:	74 23                	je     80130f <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8012ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012f2:	eb 0e                	jmp    801302 <memset+0x91>
			*p8++ = (uint8)c;
  8012f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f7:	8d 50 01             	lea    0x1(%eax),%edx
  8012fa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801300:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801302:	8b 45 10             	mov    0x10(%ebp),%eax
  801305:	8d 50 ff             	lea    -0x1(%eax),%edx
  801308:	89 55 10             	mov    %edx,0x10(%ebp)
  80130b:	85 c0                	test   %eax,%eax
  80130d:	75 e5                	jne    8012f4 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80130f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801312:	c9                   	leave  
  801313:	c3                   	ret    

00801314 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801314:	55                   	push   %ebp
  801315:	89 e5                	mov    %esp,%ebp
  801317:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80131a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801326:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80132a:	76 24                	jbe    801350 <memcpy+0x3c>
		while(n >= 8){
  80132c:	eb 1c                	jmp    80134a <memcpy+0x36>
			*d64 = *s64;
  80132e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801331:	8b 50 04             	mov    0x4(%eax),%edx
  801334:	8b 00                	mov    (%eax),%eax
  801336:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801339:	89 01                	mov    %eax,(%ecx)
  80133b:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80133e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801342:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801346:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80134a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80134e:	77 de                	ja     80132e <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801350:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801354:	74 31                	je     801387 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801356:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801359:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80135c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801362:	eb 16                	jmp    80137a <memcpy+0x66>
			*d8++ = *s8++;
  801364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801367:	8d 50 01             	lea    0x1(%eax),%edx
  80136a:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80136d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801370:	8d 4a 01             	lea    0x1(%edx),%ecx
  801373:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801376:	8a 12                	mov    (%edx),%dl
  801378:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80137a:	8b 45 10             	mov    0x10(%ebp),%eax
  80137d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801380:	89 55 10             	mov    %edx,0x10(%ebp)
  801383:	85 c0                	test   %eax,%eax
  801385:	75 dd                	jne    801364 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80138a:	c9                   	leave  
  80138b:	c3                   	ret    

0080138c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
  80138f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801392:	8b 45 0c             	mov    0xc(%ebp),%eax
  801395:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801398:	8b 45 08             	mov    0x8(%ebp),%eax
  80139b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80139e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013a4:	73 50                	jae    8013f6 <memmove+0x6a>
  8013a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ac:	01 d0                	add    %edx,%eax
  8013ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013b1:	76 43                	jbe    8013f6 <memmove+0x6a>
		s += n;
  8013b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8013b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8013bf:	eb 10                	jmp    8013d1 <memmove+0x45>
			*--d = *--s;
  8013c1:	ff 4d f8             	decl   -0x8(%ebp)
  8013c4:	ff 4d fc             	decl   -0x4(%ebp)
  8013c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ca:	8a 10                	mov    (%eax),%dl
  8013cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013cf:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8013d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013d7:	89 55 10             	mov    %edx,0x10(%ebp)
  8013da:	85 c0                	test   %eax,%eax
  8013dc:	75 e3                	jne    8013c1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8013de:	eb 23                	jmp    801403 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8013e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e3:	8d 50 01             	lea    0x1(%eax),%edx
  8013e6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ec:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013ef:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013f2:	8a 12                	mov    (%edx),%dl
  8013f4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013fc:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ff:	85 c0                	test   %eax,%eax
  801401:	75 dd                	jne    8013e0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801406:	c9                   	leave  
  801407:	c3                   	ret    

00801408 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801414:	8b 45 0c             	mov    0xc(%ebp),%eax
  801417:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80141a:	eb 2a                	jmp    801446 <memcmp+0x3e>
		if (*s1 != *s2)
  80141c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80141f:	8a 10                	mov    (%eax),%dl
  801421:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801424:	8a 00                	mov    (%eax),%al
  801426:	38 c2                	cmp    %al,%dl
  801428:	74 16                	je     801440 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80142a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142d:	8a 00                	mov    (%eax),%al
  80142f:	0f b6 d0             	movzbl %al,%edx
  801432:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	0f b6 c0             	movzbl %al,%eax
  80143a:	29 c2                	sub    %eax,%edx
  80143c:	89 d0                	mov    %edx,%eax
  80143e:	eb 18                	jmp    801458 <memcmp+0x50>
		s1++, s2++;
  801440:	ff 45 fc             	incl   -0x4(%ebp)
  801443:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801446:	8b 45 10             	mov    0x10(%ebp),%eax
  801449:	8d 50 ff             	lea    -0x1(%eax),%edx
  80144c:	89 55 10             	mov    %edx,0x10(%ebp)
  80144f:	85 c0                	test   %eax,%eax
  801451:	75 c9                	jne    80141c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801453:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801458:	c9                   	leave  
  801459:	c3                   	ret    

0080145a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
  80145d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801460:	8b 55 08             	mov    0x8(%ebp),%edx
  801463:	8b 45 10             	mov    0x10(%ebp),%eax
  801466:	01 d0                	add    %edx,%eax
  801468:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80146b:	eb 15                	jmp    801482 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	0f b6 d0             	movzbl %al,%edx
  801475:	8b 45 0c             	mov    0xc(%ebp),%eax
  801478:	0f b6 c0             	movzbl %al,%eax
  80147b:	39 c2                	cmp    %eax,%edx
  80147d:	74 0d                	je     80148c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80147f:	ff 45 08             	incl   0x8(%ebp)
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801488:	72 e3                	jb     80146d <memfind+0x13>
  80148a:	eb 01                	jmp    80148d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80148c:	90                   	nop
	return (void *) s;
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801490:	c9                   	leave  
  801491:	c3                   	ret    

00801492 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
  801495:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801498:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80149f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014a6:	eb 03                	jmp    8014ab <strtol+0x19>
		s++;
  8014a8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	8a 00                	mov    (%eax),%al
  8014b0:	3c 20                	cmp    $0x20,%al
  8014b2:	74 f4                	je     8014a8 <strtol+0x16>
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	8a 00                	mov    (%eax),%al
  8014b9:	3c 09                	cmp    $0x9,%al
  8014bb:	74 eb                	je     8014a8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	8a 00                	mov    (%eax),%al
  8014c2:	3c 2b                	cmp    $0x2b,%al
  8014c4:	75 05                	jne    8014cb <strtol+0x39>
		s++;
  8014c6:	ff 45 08             	incl   0x8(%ebp)
  8014c9:	eb 13                	jmp    8014de <strtol+0x4c>
	else if (*s == '-')
  8014cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ce:	8a 00                	mov    (%eax),%al
  8014d0:	3c 2d                	cmp    $0x2d,%al
  8014d2:	75 0a                	jne    8014de <strtol+0x4c>
		s++, neg = 1;
  8014d4:	ff 45 08             	incl   0x8(%ebp)
  8014d7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e2:	74 06                	je     8014ea <strtol+0x58>
  8014e4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014e8:	75 20                	jne    80150a <strtol+0x78>
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	8a 00                	mov    (%eax),%al
  8014ef:	3c 30                	cmp    $0x30,%al
  8014f1:	75 17                	jne    80150a <strtol+0x78>
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	40                   	inc    %eax
  8014f7:	8a 00                	mov    (%eax),%al
  8014f9:	3c 78                	cmp    $0x78,%al
  8014fb:	75 0d                	jne    80150a <strtol+0x78>
		s += 2, base = 16;
  8014fd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801501:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801508:	eb 28                	jmp    801532 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80150a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80150e:	75 15                	jne    801525 <strtol+0x93>
  801510:	8b 45 08             	mov    0x8(%ebp),%eax
  801513:	8a 00                	mov    (%eax),%al
  801515:	3c 30                	cmp    $0x30,%al
  801517:	75 0c                	jne    801525 <strtol+0x93>
		s++, base = 8;
  801519:	ff 45 08             	incl   0x8(%ebp)
  80151c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801523:	eb 0d                	jmp    801532 <strtol+0xa0>
	else if (base == 0)
  801525:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801529:	75 07                	jne    801532 <strtol+0xa0>
		base = 10;
  80152b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	8a 00                	mov    (%eax),%al
  801537:	3c 2f                	cmp    $0x2f,%al
  801539:	7e 19                	jle    801554 <strtol+0xc2>
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	8a 00                	mov    (%eax),%al
  801540:	3c 39                	cmp    $0x39,%al
  801542:	7f 10                	jg     801554 <strtol+0xc2>
			dig = *s - '0';
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	8a 00                	mov    (%eax),%al
  801549:	0f be c0             	movsbl %al,%eax
  80154c:	83 e8 30             	sub    $0x30,%eax
  80154f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801552:	eb 42                	jmp    801596 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	8a 00                	mov    (%eax),%al
  801559:	3c 60                	cmp    $0x60,%al
  80155b:	7e 19                	jle    801576 <strtol+0xe4>
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	8a 00                	mov    (%eax),%al
  801562:	3c 7a                	cmp    $0x7a,%al
  801564:	7f 10                	jg     801576 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	8a 00                	mov    (%eax),%al
  80156b:	0f be c0             	movsbl %al,%eax
  80156e:	83 e8 57             	sub    $0x57,%eax
  801571:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801574:	eb 20                	jmp    801596 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801576:	8b 45 08             	mov    0x8(%ebp),%eax
  801579:	8a 00                	mov    (%eax),%al
  80157b:	3c 40                	cmp    $0x40,%al
  80157d:	7e 39                	jle    8015b8 <strtol+0x126>
  80157f:	8b 45 08             	mov    0x8(%ebp),%eax
  801582:	8a 00                	mov    (%eax),%al
  801584:	3c 5a                	cmp    $0x5a,%al
  801586:	7f 30                	jg     8015b8 <strtol+0x126>
			dig = *s - 'A' + 10;
  801588:	8b 45 08             	mov    0x8(%ebp),%eax
  80158b:	8a 00                	mov    (%eax),%al
  80158d:	0f be c0             	movsbl %al,%eax
  801590:	83 e8 37             	sub    $0x37,%eax
  801593:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801599:	3b 45 10             	cmp    0x10(%ebp),%eax
  80159c:	7d 19                	jge    8015b7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80159e:	ff 45 08             	incl   0x8(%ebp)
  8015a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015a4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8015a8:	89 c2                	mov    %eax,%edx
  8015aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ad:	01 d0                	add    %edx,%eax
  8015af:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8015b2:	e9 7b ff ff ff       	jmp    801532 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8015b7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8015b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015bc:	74 08                	je     8015c6 <strtol+0x134>
		*endptr = (char *) s;
  8015be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8015c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015ca:	74 07                	je     8015d3 <strtol+0x141>
  8015cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015cf:	f7 d8                	neg    %eax
  8015d1:	eb 03                	jmp    8015d6 <strtol+0x144>
  8015d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <ltostr>:

void
ltostr(long value, char *str)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8015de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8015e5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015f0:	79 13                	jns    801605 <ltostr+0x2d>
	{
		neg = 1;
  8015f2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015ff:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801602:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801605:	8b 45 08             	mov    0x8(%ebp),%eax
  801608:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80160d:	99                   	cltd   
  80160e:	f7 f9                	idiv   %ecx
  801610:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801613:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801616:	8d 50 01             	lea    0x1(%eax),%edx
  801619:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80161c:	89 c2                	mov    %eax,%edx
  80161e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801621:	01 d0                	add    %edx,%eax
  801623:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801626:	83 c2 30             	add    $0x30,%edx
  801629:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80162b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80162e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801633:	f7 e9                	imul   %ecx
  801635:	c1 fa 02             	sar    $0x2,%edx
  801638:	89 c8                	mov    %ecx,%eax
  80163a:	c1 f8 1f             	sar    $0x1f,%eax
  80163d:	29 c2                	sub    %eax,%edx
  80163f:	89 d0                	mov    %edx,%eax
  801641:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801644:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801648:	75 bb                	jne    801605 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80164a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801651:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801654:	48                   	dec    %eax
  801655:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801658:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80165c:	74 3d                	je     80169b <ltostr+0xc3>
		start = 1 ;
  80165e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801665:	eb 34                	jmp    80169b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801667:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80166a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166d:	01 d0                	add    %edx,%eax
  80166f:	8a 00                	mov    (%eax),%al
  801671:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801674:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801677:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167a:	01 c2                	add    %eax,%edx
  80167c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80167f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801682:	01 c8                	add    %ecx,%eax
  801684:	8a 00                	mov    (%eax),%al
  801686:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801688:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80168b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168e:	01 c2                	add    %eax,%edx
  801690:	8a 45 eb             	mov    -0x15(%ebp),%al
  801693:	88 02                	mov    %al,(%edx)
		start++ ;
  801695:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801698:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80169b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016a1:	7c c4                	jl     801667 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8016a3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8016a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a9:	01 d0                	add    %edx,%eax
  8016ab:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8016ae:	90                   	nop
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
  8016b4:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8016b7:	ff 75 08             	pushl  0x8(%ebp)
  8016ba:	e8 c4 f9 ff ff       	call   801083 <strlen>
  8016bf:	83 c4 04             	add    $0x4,%esp
  8016c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8016c5:	ff 75 0c             	pushl  0xc(%ebp)
  8016c8:	e8 b6 f9 ff ff       	call   801083 <strlen>
  8016cd:	83 c4 04             	add    $0x4,%esp
  8016d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8016da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016e1:	eb 17                	jmp    8016fa <strcconcat+0x49>
		final[s] = str1[s] ;
  8016e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e9:	01 c2                	add    %eax,%edx
  8016eb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f1:	01 c8                	add    %ecx,%eax
  8016f3:	8a 00                	mov    (%eax),%al
  8016f5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016f7:	ff 45 fc             	incl   -0x4(%ebp)
  8016fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016fd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801700:	7c e1                	jl     8016e3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801702:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801709:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801710:	eb 1f                	jmp    801731 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801712:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801715:	8d 50 01             	lea    0x1(%eax),%edx
  801718:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80171b:	89 c2                	mov    %eax,%edx
  80171d:	8b 45 10             	mov    0x10(%ebp),%eax
  801720:	01 c2                	add    %eax,%edx
  801722:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801725:	8b 45 0c             	mov    0xc(%ebp),%eax
  801728:	01 c8                	add    %ecx,%eax
  80172a:	8a 00                	mov    (%eax),%al
  80172c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80172e:	ff 45 f8             	incl   -0x8(%ebp)
  801731:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801734:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801737:	7c d9                	jl     801712 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801739:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80173c:	8b 45 10             	mov    0x10(%ebp),%eax
  80173f:	01 d0                	add    %edx,%eax
  801741:	c6 00 00             	movb   $0x0,(%eax)
}
  801744:	90                   	nop
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80174a:	8b 45 14             	mov    0x14(%ebp),%eax
  80174d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801753:	8b 45 14             	mov    0x14(%ebp),%eax
  801756:	8b 00                	mov    (%eax),%eax
  801758:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80175f:	8b 45 10             	mov    0x10(%ebp),%eax
  801762:	01 d0                	add    %edx,%eax
  801764:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80176a:	eb 0c                	jmp    801778 <strsplit+0x31>
			*string++ = 0;
  80176c:	8b 45 08             	mov    0x8(%ebp),%eax
  80176f:	8d 50 01             	lea    0x1(%eax),%edx
  801772:	89 55 08             	mov    %edx,0x8(%ebp)
  801775:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	8a 00                	mov    (%eax),%al
  80177d:	84 c0                	test   %al,%al
  80177f:	74 18                	je     801799 <strsplit+0x52>
  801781:	8b 45 08             	mov    0x8(%ebp),%eax
  801784:	8a 00                	mov    (%eax),%al
  801786:	0f be c0             	movsbl %al,%eax
  801789:	50                   	push   %eax
  80178a:	ff 75 0c             	pushl  0xc(%ebp)
  80178d:	e8 83 fa ff ff       	call   801215 <strchr>
  801792:	83 c4 08             	add    $0x8,%esp
  801795:	85 c0                	test   %eax,%eax
  801797:	75 d3                	jne    80176c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801799:	8b 45 08             	mov    0x8(%ebp),%eax
  80179c:	8a 00                	mov    (%eax),%al
  80179e:	84 c0                	test   %al,%al
  8017a0:	74 5a                	je     8017fc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8017a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a5:	8b 00                	mov    (%eax),%eax
  8017a7:	83 f8 0f             	cmp    $0xf,%eax
  8017aa:	75 07                	jne    8017b3 <strsplit+0x6c>
		{
			return 0;
  8017ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b1:	eb 66                	jmp    801819 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8017b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b6:	8b 00                	mov    (%eax),%eax
  8017b8:	8d 48 01             	lea    0x1(%eax),%ecx
  8017bb:	8b 55 14             	mov    0x14(%ebp),%edx
  8017be:	89 0a                	mov    %ecx,(%edx)
  8017c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ca:	01 c2                	add    %eax,%edx
  8017cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cf:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017d1:	eb 03                	jmp    8017d6 <strsplit+0x8f>
			string++;
  8017d3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	84 c0                	test   %al,%al
  8017dd:	74 8b                	je     80176a <strsplit+0x23>
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	8a 00                	mov    (%eax),%al
  8017e4:	0f be c0             	movsbl %al,%eax
  8017e7:	50                   	push   %eax
  8017e8:	ff 75 0c             	pushl  0xc(%ebp)
  8017eb:	e8 25 fa ff ff       	call   801215 <strchr>
  8017f0:	83 c4 08             	add    $0x8,%esp
  8017f3:	85 c0                	test   %eax,%eax
  8017f5:	74 dc                	je     8017d3 <strsplit+0x8c>
			string++;
	}
  8017f7:	e9 6e ff ff ff       	jmp    80176a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017fc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801800:	8b 00                	mov    (%eax),%eax
  801802:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801809:	8b 45 10             	mov    0x10(%ebp),%eax
  80180c:	01 d0                	add    %edx,%eax
  80180e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801814:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801827:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80182e:	eb 4a                	jmp    80187a <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801830:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801833:	8b 45 08             	mov    0x8(%ebp),%eax
  801836:	01 c2                	add    %eax,%edx
  801838:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80183b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183e:	01 c8                	add    %ecx,%eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801844:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801847:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184a:	01 d0                	add    %edx,%eax
  80184c:	8a 00                	mov    (%eax),%al
  80184e:	3c 40                	cmp    $0x40,%al
  801850:	7e 25                	jle    801877 <str2lower+0x5c>
  801852:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801855:	8b 45 0c             	mov    0xc(%ebp),%eax
  801858:	01 d0                	add    %edx,%eax
  80185a:	8a 00                	mov    (%eax),%al
  80185c:	3c 5a                	cmp    $0x5a,%al
  80185e:	7f 17                	jg     801877 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801860:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801863:	8b 45 08             	mov    0x8(%ebp),%eax
  801866:	01 d0                	add    %edx,%eax
  801868:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80186b:	8b 55 08             	mov    0x8(%ebp),%edx
  80186e:	01 ca                	add    %ecx,%edx
  801870:	8a 12                	mov    (%edx),%dl
  801872:	83 c2 20             	add    $0x20,%edx
  801875:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801877:	ff 45 fc             	incl   -0x4(%ebp)
  80187a:	ff 75 0c             	pushl  0xc(%ebp)
  80187d:	e8 01 f8 ff ff       	call   801083 <strlen>
  801882:	83 c4 04             	add    $0x4,%esp
  801885:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801888:	7f a6                	jg     801830 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80188a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
  801892:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  801895:	83 ec 0c             	sub    $0xc,%esp
  801898:	6a 10                	push   $0x10
  80189a:	e8 b2 15 00 00       	call   802e51 <alloc_block>
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  8018a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018a9:	75 14                	jne    8018bf <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  8018ab:	83 ec 04             	sub    $0x4,%esp
  8018ae:	68 08 47 80 00       	push   $0x804708
  8018b3:	6a 14                	push   $0x14
  8018b5:	68 31 47 80 00       	push   $0x804731
  8018ba:	e8 fd ed ff ff       	call   8006bc <_panic>

	node->start = start;
  8018bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8018c5:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  8018c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018cd:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  8018d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  8018d7:	a1 24 50 80 00       	mov    0x805024,%eax
  8018dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018df:	eb 18                	jmp    8018f9 <insert_page_alloc+0x6a>
		if (start < it->start)
  8018e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e4:	8b 00                	mov    (%eax),%eax
  8018e6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8018e9:	77 37                	ja     801922 <insert_page_alloc+0x93>
			break;
		prev = it;
  8018eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ee:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  8018f1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8018f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018fd:	74 08                	je     801907 <insert_page_alloc+0x78>
  8018ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801902:	8b 40 08             	mov    0x8(%eax),%eax
  801905:	eb 05                	jmp    80190c <insert_page_alloc+0x7d>
  801907:	b8 00 00 00 00       	mov    $0x0,%eax
  80190c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801911:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801916:	85 c0                	test   %eax,%eax
  801918:	75 c7                	jne    8018e1 <insert_page_alloc+0x52>
  80191a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80191e:	75 c1                	jne    8018e1 <insert_page_alloc+0x52>
  801920:	eb 01                	jmp    801923 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  801922:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  801923:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801927:	75 64                	jne    80198d <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  801929:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80192d:	75 14                	jne    801943 <insert_page_alloc+0xb4>
  80192f:	83 ec 04             	sub    $0x4,%esp
  801932:	68 40 47 80 00       	push   $0x804740
  801937:	6a 21                	push   $0x21
  801939:	68 31 47 80 00       	push   $0x804731
  80193e:	e8 79 ed ff ff       	call   8006bc <_panic>
  801943:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801949:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80194c:	89 50 08             	mov    %edx,0x8(%eax)
  80194f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801952:	8b 40 08             	mov    0x8(%eax),%eax
  801955:	85 c0                	test   %eax,%eax
  801957:	74 0d                	je     801966 <insert_page_alloc+0xd7>
  801959:	a1 24 50 80 00       	mov    0x805024,%eax
  80195e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801961:	89 50 0c             	mov    %edx,0xc(%eax)
  801964:	eb 08                	jmp    80196e <insert_page_alloc+0xdf>
  801966:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801969:	a3 28 50 80 00       	mov    %eax,0x805028
  80196e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801971:	a3 24 50 80 00       	mov    %eax,0x805024
  801976:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801979:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801980:	a1 30 50 80 00       	mov    0x805030,%eax
  801985:	40                   	inc    %eax
  801986:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  80198b:	eb 71                	jmp    8019fe <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  80198d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801991:	74 06                	je     801999 <insert_page_alloc+0x10a>
  801993:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801997:	75 14                	jne    8019ad <insert_page_alloc+0x11e>
  801999:	83 ec 04             	sub    $0x4,%esp
  80199c:	68 64 47 80 00       	push   $0x804764
  8019a1:	6a 23                	push   $0x23
  8019a3:	68 31 47 80 00       	push   $0x804731
  8019a8:	e8 0f ed ff ff       	call   8006bc <_panic>
  8019ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b0:	8b 50 08             	mov    0x8(%eax),%edx
  8019b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019b6:	89 50 08             	mov    %edx,0x8(%eax)
  8019b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019bc:	8b 40 08             	mov    0x8(%eax),%eax
  8019bf:	85 c0                	test   %eax,%eax
  8019c1:	74 0c                	je     8019cf <insert_page_alloc+0x140>
  8019c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c6:	8b 40 08             	mov    0x8(%eax),%eax
  8019c9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019cc:	89 50 0c             	mov    %edx,0xc(%eax)
  8019cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019d5:	89 50 08             	mov    %edx,0x8(%eax)
  8019d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019de:	89 50 0c             	mov    %edx,0xc(%eax)
  8019e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019e4:	8b 40 08             	mov    0x8(%eax),%eax
  8019e7:	85 c0                	test   %eax,%eax
  8019e9:	75 08                	jne    8019f3 <insert_page_alloc+0x164>
  8019eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ee:	a3 28 50 80 00       	mov    %eax,0x805028
  8019f3:	a1 30 50 80 00       	mov    0x805030,%eax
  8019f8:	40                   	inc    %eax
  8019f9:	a3 30 50 80 00       	mov    %eax,0x805030
}
  8019fe:	90                   	nop
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  801a07:	a1 24 50 80 00       	mov    0x805024,%eax
  801a0c:	85 c0                	test   %eax,%eax
  801a0e:	75 0c                	jne    801a1c <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  801a10:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801a15:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  801a1a:	eb 67                	jmp    801a83 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  801a1c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801a21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801a24:	a1 24 50 80 00       	mov    0x805024,%eax
  801a29:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801a2c:	eb 26                	jmp    801a54 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  801a2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a31:	8b 10                	mov    (%eax),%edx
  801a33:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a36:	8b 40 04             	mov    0x4(%eax),%eax
  801a39:	01 d0                	add    %edx,%eax
  801a3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  801a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a41:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801a44:	76 06                	jbe    801a4c <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  801a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a49:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801a4c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801a51:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801a54:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801a58:	74 08                	je     801a62 <recompute_page_alloc_break+0x61>
  801a5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a5d:	8b 40 08             	mov    0x8(%eax),%eax
  801a60:	eb 05                	jmp    801a67 <recompute_page_alloc_break+0x66>
  801a62:	b8 00 00 00 00       	mov    $0x0,%eax
  801a67:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801a6c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801a71:	85 c0                	test   %eax,%eax
  801a73:	75 b9                	jne    801a2e <recompute_page_alloc_break+0x2d>
  801a75:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801a79:	75 b3                	jne    801a2e <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  801a7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a7e:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
  801a88:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801a8b:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801a92:	8b 55 08             	mov    0x8(%ebp),%edx
  801a95:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a98:	01 d0                	add    %edx,%eax
  801a9a:	48                   	dec    %eax
  801a9b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801a9e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801aa1:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa6:	f7 75 d8             	divl   -0x28(%ebp)
  801aa9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801aac:	29 d0                	sub    %edx,%eax
  801aae:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  801ab1:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801ab5:	75 0a                	jne    801ac1 <alloc_pages_custom_fit+0x3c>
		return NULL;
  801ab7:	b8 00 00 00 00       	mov    $0x0,%eax
  801abc:	e9 7e 01 00 00       	jmp    801c3f <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  801ac1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  801ac8:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801acc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801ad3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  801ada:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801adf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801ae2:	a1 24 50 80 00       	mov    0x805024,%eax
  801ae7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801aea:	eb 69                	jmp    801b55 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  801aec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aef:	8b 00                	mov    (%eax),%eax
  801af1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801af4:	76 47                	jbe    801b3d <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  801af6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801af9:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  801afc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aff:	8b 00                	mov    (%eax),%eax
  801b01:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801b04:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  801b07:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801b0a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801b0d:	72 2e                	jb     801b3d <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801b0f:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801b13:	75 14                	jne    801b29 <alloc_pages_custom_fit+0xa4>
  801b15:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801b18:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801b1b:	75 0c                	jne    801b29 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  801b1d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801b20:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  801b23:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801b27:	eb 14                	jmp    801b3d <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  801b29:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801b2c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801b2f:	76 0c                	jbe    801b3d <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  801b31:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801b34:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  801b37:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801b3a:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  801b3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b40:	8b 10                	mov    (%eax),%edx
  801b42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b45:	8b 40 04             	mov    0x4(%eax),%eax
  801b48:	01 d0                	add    %edx,%eax
  801b4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801b4d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801b52:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801b55:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b59:	74 08                	je     801b63 <alloc_pages_custom_fit+0xde>
  801b5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b5e:	8b 40 08             	mov    0x8(%eax),%eax
  801b61:	eb 05                	jmp    801b68 <alloc_pages_custom_fit+0xe3>
  801b63:	b8 00 00 00 00       	mov    $0x0,%eax
  801b68:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801b6d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801b72:	85 c0                	test   %eax,%eax
  801b74:	0f 85 72 ff ff ff    	jne    801aec <alloc_pages_custom_fit+0x67>
  801b7a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b7e:	0f 85 68 ff ff ff    	jne    801aec <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  801b84:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801b89:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801b8c:	76 47                	jbe    801bd5 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801b8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b91:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  801b94:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801b99:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801b9c:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801b9f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801ba2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801ba5:	72 2e                	jb     801bd5 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  801ba7:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801bab:	75 14                	jne    801bc1 <alloc_pages_custom_fit+0x13c>
  801bad:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801bb0:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801bb3:	75 0c                	jne    801bc1 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  801bb5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801bb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  801bbb:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801bbf:	eb 14                	jmp    801bd5 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  801bc1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801bc4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801bc7:	76 0c                	jbe    801bd5 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  801bc9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801bcc:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801bcf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801bd2:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  801bd5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  801bdc:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801be0:	74 08                	je     801bea <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  801be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801be8:	eb 40                	jmp    801c2a <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  801bea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bee:	74 08                	je     801bf8 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  801bf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bf3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801bf6:	eb 32                	jmp    801c2a <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  801bf8:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801bfd:	2b 45 d0             	sub    -0x30(%ebp),%eax
  801c00:	89 c2                	mov    %eax,%edx
  801c02:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801c07:	39 c2                	cmp    %eax,%edx
  801c09:	73 07                	jae    801c12 <alloc_pages_custom_fit+0x18d>
			return NULL;
  801c0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c10:	eb 2d                	jmp    801c3f <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  801c12:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801c17:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  801c1a:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801c20:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801c23:	01 d0                	add    %edx,%eax
  801c25:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  801c2a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c2d:	83 ec 08             	sub    $0x8,%esp
  801c30:	ff 75 d0             	pushl  -0x30(%ebp)
  801c33:	50                   	push   %eax
  801c34:	e8 56 fc ff ff       	call   80188f <insert_page_alloc>
  801c39:	83 c4 10             	add    $0x10,%esp

	return result;
  801c3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
  801c44:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  801c47:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801c4d:	a1 24 50 80 00       	mov    0x805024,%eax
  801c52:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801c55:	eb 1a                	jmp    801c71 <find_allocated_size+0x30>
		if (it->start == va)
  801c57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c5a:	8b 00                	mov    (%eax),%eax
  801c5c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801c5f:	75 08                	jne    801c69 <find_allocated_size+0x28>
			return it->size;
  801c61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c64:	8b 40 04             	mov    0x4(%eax),%eax
  801c67:	eb 34                	jmp    801c9d <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801c69:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801c6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801c71:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801c75:	74 08                	je     801c7f <find_allocated_size+0x3e>
  801c77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c7a:	8b 40 08             	mov    0x8(%eax),%eax
  801c7d:	eb 05                	jmp    801c84 <find_allocated_size+0x43>
  801c7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c84:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801c89:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801c8e:	85 c0                	test   %eax,%eax
  801c90:	75 c5                	jne    801c57 <find_allocated_size+0x16>
  801c92:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801c96:	75 bf                	jne    801c57 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  801c98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  801ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801cab:	a1 24 50 80 00       	mov    0x805024,%eax
  801cb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cb3:	e9 e1 01 00 00       	jmp    801e99 <free_pages+0x1fa>
		if (it->start == va) {
  801cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbb:	8b 00                	mov    (%eax),%eax
  801cbd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801cc0:	0f 85 cb 01 00 00    	jne    801e91 <free_pages+0x1f2>

			uint32 start = it->start;
  801cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc9:	8b 00                	mov    (%eax),%eax
  801ccb:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd1:	8b 40 04             	mov    0x4(%eax),%eax
  801cd4:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801cd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cda:	f7 d0                	not    %eax
  801cdc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801cdf:	73 1d                	jae    801cfe <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801ce1:	83 ec 0c             	sub    $0xc,%esp
  801ce4:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ce7:	ff 75 e8             	pushl  -0x18(%ebp)
  801cea:	68 98 47 80 00       	push   $0x804798
  801cef:	68 a5 00 00 00       	push   $0xa5
  801cf4:	68 31 47 80 00       	push   $0x804731
  801cf9:	e8 be e9 ff ff       	call   8006bc <_panic>
			}

			uint32 start_end = start + size;
  801cfe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d04:	01 d0                	add    %edx,%eax
  801d06:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801d09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d0c:	85 c0                	test   %eax,%eax
  801d0e:	79 19                	jns    801d29 <free_pages+0x8a>
  801d10:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801d17:	77 10                	ja     801d29 <free_pages+0x8a>
  801d19:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801d20:	77 07                	ja     801d29 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  801d22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d25:	85 c0                	test   %eax,%eax
  801d27:	78 2c                	js     801d55 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  801d29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d2c:	83 ec 0c             	sub    $0xc,%esp
  801d2f:	68 00 00 00 a0       	push   $0xa0000000
  801d34:	ff 75 e0             	pushl  -0x20(%ebp)
  801d37:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d3a:	ff 75 e8             	pushl  -0x18(%ebp)
  801d3d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d40:	50                   	push   %eax
  801d41:	68 dc 47 80 00       	push   $0x8047dc
  801d46:	68 ad 00 00 00       	push   $0xad
  801d4b:	68 31 47 80 00       	push   $0x804731
  801d50:	e8 67 e9 ff ff       	call   8006bc <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801d55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d5b:	e9 88 00 00 00       	jmp    801de8 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  801d60:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  801d67:	76 17                	jbe    801d80 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  801d69:	ff 75 f0             	pushl  -0x10(%ebp)
  801d6c:	68 40 48 80 00       	push   $0x804840
  801d71:	68 b4 00 00 00       	push   $0xb4
  801d76:	68 31 47 80 00       	push   $0x804731
  801d7b:	e8 3c e9 ff ff       	call   8006bc <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  801d80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d83:	05 00 10 00 00       	add    $0x1000,%eax
  801d88:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  801d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8e:	85 c0                	test   %eax,%eax
  801d90:	79 2e                	jns    801dc0 <free_pages+0x121>
  801d92:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801d99:	77 25                	ja     801dc0 <free_pages+0x121>
  801d9b:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801da2:	77 1c                	ja     801dc0 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  801da4:	83 ec 08             	sub    $0x8,%esp
  801da7:	68 00 10 00 00       	push   $0x1000
  801dac:	ff 75 f0             	pushl  -0x10(%ebp)
  801daf:	e8 38 0d 00 00       	call   802aec <sys_free_user_mem>
  801db4:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801db7:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801dbe:	eb 28                	jmp    801de8 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  801dc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dc3:	68 00 00 00 a0       	push   $0xa0000000
  801dc8:	ff 75 dc             	pushl  -0x24(%ebp)
  801dcb:	68 00 10 00 00       	push   $0x1000
  801dd0:	ff 75 f0             	pushl  -0x10(%ebp)
  801dd3:	50                   	push   %eax
  801dd4:	68 80 48 80 00       	push   $0x804880
  801dd9:	68 bd 00 00 00       	push   $0xbd
  801dde:	68 31 47 80 00       	push   $0x804731
  801de3:	e8 d4 e8 ff ff       	call   8006bc <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801deb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801dee:	0f 82 6c ff ff ff    	jb     801d60 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  801df4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801df8:	75 17                	jne    801e11 <free_pages+0x172>
  801dfa:	83 ec 04             	sub    $0x4,%esp
  801dfd:	68 e2 48 80 00       	push   $0x8048e2
  801e02:	68 c1 00 00 00       	push   $0xc1
  801e07:	68 31 47 80 00       	push   $0x804731
  801e0c:	e8 ab e8 ff ff       	call   8006bc <_panic>
  801e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e14:	8b 40 08             	mov    0x8(%eax),%eax
  801e17:	85 c0                	test   %eax,%eax
  801e19:	74 11                	je     801e2c <free_pages+0x18d>
  801e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1e:	8b 40 08             	mov    0x8(%eax),%eax
  801e21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e24:	8b 52 0c             	mov    0xc(%edx),%edx
  801e27:	89 50 0c             	mov    %edx,0xc(%eax)
  801e2a:	eb 0b                	jmp    801e37 <free_pages+0x198>
  801e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e32:	a3 28 50 80 00       	mov    %eax,0x805028
  801e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3a:	8b 40 0c             	mov    0xc(%eax),%eax
  801e3d:	85 c0                	test   %eax,%eax
  801e3f:	74 11                	je     801e52 <free_pages+0x1b3>
  801e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e44:	8b 40 0c             	mov    0xc(%eax),%eax
  801e47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e4a:	8b 52 08             	mov    0x8(%edx),%edx
  801e4d:	89 50 08             	mov    %edx,0x8(%eax)
  801e50:	eb 0b                	jmp    801e5d <free_pages+0x1be>
  801e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e55:	8b 40 08             	mov    0x8(%eax),%eax
  801e58:	a3 24 50 80 00       	mov    %eax,0x805024
  801e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e60:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801e71:	a1 30 50 80 00       	mov    0x805030,%eax
  801e76:	48                   	dec    %eax
  801e77:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  801e7c:	83 ec 0c             	sub    $0xc,%esp
  801e7f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e82:	e8 24 15 00 00       	call   8033ab <free_block>
  801e87:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  801e8a:	e8 72 fb ff ff       	call   801a01 <recompute_page_alloc_break>

			return;
  801e8f:	eb 37                	jmp    801ec8 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801e91:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801e96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e9d:	74 08                	je     801ea7 <free_pages+0x208>
  801e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea2:	8b 40 08             	mov    0x8(%eax),%eax
  801ea5:	eb 05                	jmp    801eac <free_pages+0x20d>
  801ea7:	b8 00 00 00 00       	mov    $0x0,%eax
  801eac:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801eb1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801eb6:	85 c0                	test   %eax,%eax
  801eb8:	0f 85 fa fd ff ff    	jne    801cb8 <free_pages+0x19>
  801ebe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ec2:	0f 85 f0 fd ff ff    	jne    801cb8 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  801ecd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed2:	5d                   	pop    %ebp
  801ed3:	c3                   	ret    

00801ed4 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
  801ed7:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801eda:	a1 08 50 80 00       	mov    0x805008,%eax
  801edf:	85 c0                	test   %eax,%eax
  801ee1:	74 60                	je     801f43 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801ee3:	83 ec 08             	sub    $0x8,%esp
  801ee6:	68 00 00 00 82       	push   $0x82000000
  801eeb:	68 00 00 00 80       	push   $0x80000000
  801ef0:	e8 0d 0d 00 00       	call   802c02 <initialize_dynamic_allocator>
  801ef5:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801ef8:	e8 f3 0a 00 00       	call   8029f0 <sys_get_uheap_strategy>
  801efd:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801f02:	a1 40 50 80 00       	mov    0x805040,%eax
  801f07:	05 00 10 00 00       	add    $0x1000,%eax
  801f0c:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  801f11:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f16:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  801f1b:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  801f22:	00 00 00 
  801f25:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  801f2c:	00 00 00 
  801f2f:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  801f36:	00 00 00 

		__firstTimeFlag = 0;
  801f39:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801f40:	00 00 00 
	}
}
  801f43:	90                   	nop
  801f44:	c9                   	leave  
  801f45:	c3                   	ret    

00801f46 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
  801f49:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f55:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f5a:	83 ec 08             	sub    $0x8,%esp
  801f5d:	68 06 04 00 00       	push   $0x406
  801f62:	50                   	push   %eax
  801f63:	e8 d2 06 00 00       	call   80263a <__sys_allocate_page>
  801f68:	83 c4 10             	add    $0x10,%esp
  801f6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801f6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f72:	79 17                	jns    801f8b <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  801f74:	83 ec 04             	sub    $0x4,%esp
  801f77:	68 00 49 80 00       	push   $0x804900
  801f7c:	68 ea 00 00 00       	push   $0xea
  801f81:	68 31 47 80 00       	push   $0x804731
  801f86:	e8 31 e7 ff ff       	call   8006bc <_panic>
	return 0;
  801f8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
  801f95:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801fa6:	83 ec 0c             	sub    $0xc,%esp
  801fa9:	50                   	push   %eax
  801faa:	e8 d2 06 00 00       	call   802681 <__sys_unmap_frame>
  801faf:	83 c4 10             	add    $0x10,%esp
  801fb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801fb5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fb9:	79 17                	jns    801fd2 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  801fbb:	83 ec 04             	sub    $0x4,%esp
  801fbe:	68 3c 49 80 00       	push   $0x80493c
  801fc3:	68 f5 00 00 00       	push   $0xf5
  801fc8:	68 31 47 80 00       	push   $0x804731
  801fcd:	e8 ea e6 ff ff       	call   8006bc <_panic>
}
  801fd2:	90                   	nop
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
  801fd8:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801fdb:	e8 f4 fe ff ff       	call   801ed4 <uheap_init>
	if (size == 0) return NULL ;
  801fe0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fe4:	75 0a                	jne    801ff0 <malloc+0x1b>
  801fe6:	b8 00 00 00 00       	mov    $0x0,%eax
  801feb:	e9 67 01 00 00       	jmp    802157 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  801ff0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801ff7:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801ffe:	77 16                	ja     802016 <malloc+0x41>
		result = alloc_block(size);
  802000:	83 ec 0c             	sub    $0xc,%esp
  802003:	ff 75 08             	pushl  0x8(%ebp)
  802006:	e8 46 0e 00 00       	call   802e51 <alloc_block>
  80200b:	83 c4 10             	add    $0x10,%esp
  80200e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802011:	e9 3e 01 00 00       	jmp    802154 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  802016:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80201d:	8b 55 08             	mov    0x8(%ebp),%edx
  802020:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802023:	01 d0                	add    %edx,%eax
  802025:	48                   	dec    %eax
  802026:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802029:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80202c:	ba 00 00 00 00       	mov    $0x0,%edx
  802031:	f7 75 f0             	divl   -0x10(%ebp)
  802034:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802037:	29 d0                	sub    %edx,%eax
  802039:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  80203c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802041:	85 c0                	test   %eax,%eax
  802043:	75 0a                	jne    80204f <malloc+0x7a>
			return NULL;
  802045:	b8 00 00 00 00       	mov    $0x0,%eax
  80204a:	e9 08 01 00 00       	jmp    802157 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  80204f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802054:	85 c0                	test   %eax,%eax
  802056:	74 0f                	je     802067 <malloc+0x92>
  802058:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80205e:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802063:	39 c2                	cmp    %eax,%edx
  802065:	73 0a                	jae    802071 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  802067:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80206c:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  802071:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802076:	83 f8 05             	cmp    $0x5,%eax
  802079:	75 11                	jne    80208c <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  80207b:	83 ec 0c             	sub    $0xc,%esp
  80207e:	ff 75 e8             	pushl  -0x18(%ebp)
  802081:	e8 ff f9 ff ff       	call   801a85 <alloc_pages_custom_fit>
  802086:	83 c4 10             	add    $0x10,%esp
  802089:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  80208c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802090:	0f 84 be 00 00 00    	je     802154 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  802096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802099:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  80209c:	83 ec 0c             	sub    $0xc,%esp
  80209f:	ff 75 f4             	pushl  -0xc(%ebp)
  8020a2:	e8 9a fb ff ff       	call   801c41 <find_allocated_size>
  8020a7:	83 c4 10             	add    $0x10,%esp
  8020aa:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  8020ad:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8020b1:	75 17                	jne    8020ca <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  8020b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8020b6:	68 7c 49 80 00       	push   $0x80497c
  8020bb:	68 24 01 00 00       	push   $0x124
  8020c0:	68 31 47 80 00       	push   $0x804731
  8020c5:	e8 f2 e5 ff ff       	call   8006bc <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  8020ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020cd:	f7 d0                	not    %eax
  8020cf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8020d2:	73 1d                	jae    8020f1 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  8020d4:	83 ec 0c             	sub    $0xc,%esp
  8020d7:	ff 75 e0             	pushl  -0x20(%ebp)
  8020da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8020dd:	68 c4 49 80 00       	push   $0x8049c4
  8020e2:	68 29 01 00 00       	push   $0x129
  8020e7:	68 31 47 80 00       	push   $0x804731
  8020ec:	e8 cb e5 ff ff       	call   8006bc <_panic>
			}

			uint32 result_end = result_va + actual_size;
  8020f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020f7:	01 d0                	add    %edx,%eax
  8020f9:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  8020fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020ff:	85 c0                	test   %eax,%eax
  802101:	79 2c                	jns    80212f <malloc+0x15a>
  802103:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  80210a:	77 23                	ja     80212f <malloc+0x15a>
  80210c:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802113:	77 1a                	ja     80212f <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  802115:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802118:	85 c0                	test   %eax,%eax
  80211a:	79 13                	jns    80212f <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  80211c:	83 ec 08             	sub    $0x8,%esp
  80211f:	ff 75 e0             	pushl  -0x20(%ebp)
  802122:	ff 75 e4             	pushl  -0x1c(%ebp)
  802125:	e8 de 09 00 00       	call   802b08 <sys_allocate_user_mem>
  80212a:	83 c4 10             	add    $0x10,%esp
  80212d:	eb 25                	jmp    802154 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  80212f:	68 00 00 00 a0       	push   $0xa0000000
  802134:	ff 75 dc             	pushl  -0x24(%ebp)
  802137:	ff 75 e0             	pushl  -0x20(%ebp)
  80213a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80213d:	ff 75 f4             	pushl  -0xc(%ebp)
  802140:	68 00 4a 80 00       	push   $0x804a00
  802145:	68 33 01 00 00       	push   $0x133
  80214a:	68 31 47 80 00       	push   $0x804731
  80214f:	e8 68 e5 ff ff       	call   8006bc <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  802154:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  802157:	c9                   	leave  
  802158:	c3                   	ret    

00802159 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
  80215c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  80215f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802163:	0f 84 26 01 00 00    	je     80228f <free+0x136>

	uint32 addr = (uint32)virtual_address;
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  80216f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802172:	85 c0                	test   %eax,%eax
  802174:	79 1c                	jns    802192 <free+0x39>
  802176:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  80217d:	77 13                	ja     802192 <free+0x39>
		free_block(virtual_address);
  80217f:	83 ec 0c             	sub    $0xc,%esp
  802182:	ff 75 08             	pushl  0x8(%ebp)
  802185:	e8 21 12 00 00       	call   8033ab <free_block>
  80218a:	83 c4 10             	add    $0x10,%esp
		return;
  80218d:	e9 01 01 00 00       	jmp    802293 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  802192:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802197:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  80219a:	0f 82 d8 00 00 00    	jb     802278 <free+0x11f>
  8021a0:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  8021a7:	0f 87 cb 00 00 00    	ja     802278 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  8021ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b0:	25 ff 0f 00 00       	and    $0xfff,%eax
  8021b5:	85 c0                	test   %eax,%eax
  8021b7:	74 17                	je     8021d0 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  8021b9:	ff 75 08             	pushl  0x8(%ebp)
  8021bc:	68 70 4a 80 00       	push   $0x804a70
  8021c1:	68 57 01 00 00       	push   $0x157
  8021c6:	68 31 47 80 00       	push   $0x804731
  8021cb:	e8 ec e4 ff ff       	call   8006bc <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  8021d0:	83 ec 0c             	sub    $0xc,%esp
  8021d3:	ff 75 08             	pushl  0x8(%ebp)
  8021d6:	e8 66 fa ff ff       	call   801c41 <find_allocated_size>
  8021db:	83 c4 10             	add    $0x10,%esp
  8021de:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  8021e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021e5:	0f 84 a7 00 00 00    	je     802292 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  8021eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ee:	f7 d0                	not    %eax
  8021f0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8021f3:	73 1d                	jae    802212 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  8021f5:	83 ec 0c             	sub    $0xc,%esp
  8021f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8021fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8021fe:	68 98 4a 80 00       	push   $0x804a98
  802203:	68 61 01 00 00       	push   $0x161
  802208:	68 31 47 80 00       	push   $0x804731
  80220d:	e8 aa e4 ff ff       	call   8006bc <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  802212:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802215:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802218:	01 d0                	add    %edx,%eax
  80221a:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  80221d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802220:	85 c0                	test   %eax,%eax
  802222:	79 19                	jns    80223d <free+0xe4>
  802224:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  80222b:	77 10                	ja     80223d <free+0xe4>
  80222d:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  802234:	77 07                	ja     80223d <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  802236:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802239:	85 c0                	test   %eax,%eax
  80223b:	78 2b                	js     802268 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  80223d:	83 ec 0c             	sub    $0xc,%esp
  802240:	68 00 00 00 a0       	push   $0xa0000000
  802245:	ff 75 ec             	pushl  -0x14(%ebp)
  802248:	ff 75 f0             	pushl  -0x10(%ebp)
  80224b:	ff 75 f4             	pushl  -0xc(%ebp)
  80224e:	ff 75 f0             	pushl  -0x10(%ebp)
  802251:	ff 75 08             	pushl  0x8(%ebp)
  802254:	68 d4 4a 80 00       	push   $0x804ad4
  802259:	68 69 01 00 00       	push   $0x169
  80225e:	68 31 47 80 00       	push   $0x804731
  802263:	e8 54 e4 ff ff       	call   8006bc <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  802268:	83 ec 0c             	sub    $0xc,%esp
  80226b:	ff 75 08             	pushl  0x8(%ebp)
  80226e:	e8 2c fa ff ff       	call   801c9f <free_pages>
  802273:	83 c4 10             	add    $0x10,%esp
		return;
  802276:	eb 1b                	jmp    802293 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  802278:	ff 75 08             	pushl  0x8(%ebp)
  80227b:	68 30 4b 80 00       	push   $0x804b30
  802280:	68 70 01 00 00       	push   $0x170
  802285:	68 31 47 80 00       	push   $0x804731
  80228a:	e8 2d e4 ff ff       	call   8006bc <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  80228f:	90                   	nop
  802290:	eb 01                	jmp    802293 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  802292:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  802293:	c9                   	leave  
  802294:	c3                   	ret    

00802295 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802295:	55                   	push   %ebp
  802296:	89 e5                	mov    %esp,%ebp
  802298:	83 ec 38             	sub    $0x38,%esp
  80229b:	8b 45 10             	mov    0x10(%ebp),%eax
  80229e:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8022a1:	e8 2e fc ff ff       	call   801ed4 <uheap_init>
	if (size == 0) return NULL ;
  8022a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8022aa:	75 0a                	jne    8022b6 <smalloc+0x21>
  8022ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b1:	e9 3d 01 00 00       	jmp    8023f3 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  8022b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  8022bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022bf:	25 ff 0f 00 00       	and    $0xfff,%eax
  8022c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  8022c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022cb:	74 0e                	je     8022db <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  8022cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d0:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8022d3:	05 00 10 00 00       	add    $0x1000,%eax
  8022d8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  8022db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022de:	c1 e8 0c             	shr    $0xc,%eax
  8022e1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  8022e4:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8022e9:	85 c0                	test   %eax,%eax
  8022eb:	75 0a                	jne    8022f7 <smalloc+0x62>
		return NULL;
  8022ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f2:	e9 fc 00 00 00       	jmp    8023f3 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8022f7:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8022fc:	85 c0                	test   %eax,%eax
  8022fe:	74 0f                	je     80230f <smalloc+0x7a>
  802300:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802306:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80230b:	39 c2                	cmp    %eax,%edx
  80230d:	73 0a                	jae    802319 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  80230f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802314:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802319:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80231e:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802323:	29 c2                	sub    %eax,%edx
  802325:	89 d0                	mov    %edx,%eax
  802327:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  80232a:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802330:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802335:	29 c2                	sub    %eax,%edx
  802337:	89 d0                	mov    %edx,%eax
  802339:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  80233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802342:	77 13                	ja     802357 <smalloc+0xc2>
  802344:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802347:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80234a:	77 0b                	ja     802357 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  80234c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80234f:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  802352:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802355:	73 0a                	jae    802361 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  802357:	b8 00 00 00 00       	mov    $0x0,%eax
  80235c:	e9 92 00 00 00       	jmp    8023f3 <smalloc+0x15e>
	}

	void *va = NULL;
  802361:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  802368:	a1 60 d0 81 00       	mov    0x81d060,%eax
  80236d:	83 f8 05             	cmp    $0x5,%eax
  802370:	75 11                	jne    802383 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  802372:	83 ec 0c             	sub    $0xc,%esp
  802375:	ff 75 f4             	pushl  -0xc(%ebp)
  802378:	e8 08 f7 ff ff       	call   801a85 <alloc_pages_custom_fit>
  80237d:	83 c4 10             	add    $0x10,%esp
  802380:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  802383:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802387:	75 27                	jne    8023b0 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802389:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  802390:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802393:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802396:	89 c2                	mov    %eax,%edx
  802398:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80239d:	39 c2                	cmp    %eax,%edx
  80239f:	73 07                	jae    8023a8 <smalloc+0x113>
			return NULL;}
  8023a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a6:	eb 4b                	jmp    8023f3 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  8023a8:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8023ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  8023b0:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8023b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8023b7:	50                   	push   %eax
  8023b8:	ff 75 0c             	pushl  0xc(%ebp)
  8023bb:	ff 75 08             	pushl  0x8(%ebp)
  8023be:	e8 cb 03 00 00       	call   80278e <sys_create_shared_object>
  8023c3:	83 c4 10             	add    $0x10,%esp
  8023c6:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  8023c9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8023cd:	79 07                	jns    8023d6 <smalloc+0x141>
		return NULL;
  8023cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d4:	eb 1d                	jmp    8023f3 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  8023d6:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8023db:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8023de:	75 10                	jne    8023f0 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  8023e0:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8023e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e9:	01 d0                	add    %edx,%eax
  8023eb:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  8023f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  8023f3:	c9                   	leave  
  8023f4:	c3                   	ret    

008023f5 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8023f5:	55                   	push   %ebp
  8023f6:	89 e5                	mov    %esp,%ebp
  8023f8:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8023fb:	e8 d4 fa ff ff       	call   801ed4 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802400:	83 ec 08             	sub    $0x8,%esp
  802403:	ff 75 0c             	pushl  0xc(%ebp)
  802406:	ff 75 08             	pushl  0x8(%ebp)
  802409:	e8 aa 03 00 00       	call   8027b8 <sys_size_of_shared_object>
  80240e:	83 c4 10             	add    $0x10,%esp
  802411:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  802414:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802418:	7f 0a                	jg     802424 <sget+0x2f>
		return NULL;
  80241a:	b8 00 00 00 00       	mov    $0x0,%eax
  80241f:	e9 32 01 00 00       	jmp    802556 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  802424:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802427:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  80242a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80242d:	25 ff 0f 00 00       	and    $0xfff,%eax
  802432:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  802435:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802439:	74 0e                	je     802449 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802441:	05 00 10 00 00       	add    $0x1000,%eax
  802446:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  802449:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80244e:	85 c0                	test   %eax,%eax
  802450:	75 0a                	jne    80245c <sget+0x67>
		return NULL;
  802452:	b8 00 00 00 00       	mov    $0x0,%eax
  802457:	e9 fa 00 00 00       	jmp    802556 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  80245c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802461:	85 c0                	test   %eax,%eax
  802463:	74 0f                	je     802474 <sget+0x7f>
  802465:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80246b:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802470:	39 c2                	cmp    %eax,%edx
  802472:	73 0a                	jae    80247e <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  802474:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802479:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  80247e:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802483:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802488:	29 c2                	sub    %eax,%edx
  80248a:	89 d0                	mov    %edx,%eax
  80248c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  80248f:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802495:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80249a:	29 c2                	sub    %eax,%edx
  80249c:	89 d0                	mov    %edx,%eax
  80249e:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8024a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8024a7:	77 13                	ja     8024bc <sget+0xc7>
  8024a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024ac:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8024af:	77 0b                	ja     8024bc <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  8024b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024b4:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8024b7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8024ba:	73 0a                	jae    8024c6 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  8024bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c1:	e9 90 00 00 00       	jmp    802556 <sget+0x161>

	void *va = NULL;
  8024c6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  8024cd:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8024d2:	83 f8 05             	cmp    $0x5,%eax
  8024d5:	75 11                	jne    8024e8 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  8024d7:	83 ec 0c             	sub    $0xc,%esp
  8024da:	ff 75 f4             	pushl  -0xc(%ebp)
  8024dd:	e8 a3 f5 ff ff       	call   801a85 <alloc_pages_custom_fit>
  8024e2:	83 c4 10             	add    $0x10,%esp
  8024e5:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  8024e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024ec:	75 27                	jne    802515 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8024ee:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  8024f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024f8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8024fb:	89 c2                	mov    %eax,%edx
  8024fd:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802502:	39 c2                	cmp    %eax,%edx
  802504:	73 07                	jae    80250d <sget+0x118>
			return NULL;
  802506:	b8 00 00 00 00       	mov    $0x0,%eax
  80250b:	eb 49                	jmp    802556 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  80250d:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802512:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  802515:	83 ec 04             	sub    $0x4,%esp
  802518:	ff 75 f0             	pushl  -0x10(%ebp)
  80251b:	ff 75 0c             	pushl  0xc(%ebp)
  80251e:	ff 75 08             	pushl  0x8(%ebp)
  802521:	e8 af 02 00 00       	call   8027d5 <sys_get_shared_object>
  802526:	83 c4 10             	add    $0x10,%esp
  802529:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  80252c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802530:	79 07                	jns    802539 <sget+0x144>
		return NULL;
  802532:	b8 00 00 00 00       	mov    $0x0,%eax
  802537:	eb 1d                	jmp    802556 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  802539:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80253e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802541:	75 10                	jne    802553 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  802543:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	01 d0                	add    %edx,%eax
  80254e:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  802553:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  802556:	c9                   	leave  
  802557:	c3                   	ret    

00802558 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
  80255b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80255e:	e8 71 f9 ff ff       	call   801ed4 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802563:	83 ec 04             	sub    $0x4,%esp
  802566:	68 54 4b 80 00       	push   $0x804b54
  80256b:	68 19 02 00 00       	push   $0x219
  802570:	68 31 47 80 00       	push   $0x804731
  802575:	e8 42 e1 ff ff       	call   8006bc <_panic>

0080257a <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80257a:	55                   	push   %ebp
  80257b:	89 e5                	mov    %esp,%ebp
  80257d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802580:	83 ec 04             	sub    $0x4,%esp
  802583:	68 7c 4b 80 00       	push   $0x804b7c
  802588:	68 2b 02 00 00       	push   $0x22b
  80258d:	68 31 47 80 00       	push   $0x804731
  802592:	e8 25 e1 ff ff       	call   8006bc <_panic>

00802597 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802597:	55                   	push   %ebp
  802598:	89 e5                	mov    %esp,%ebp
  80259a:	57                   	push   %edi
  80259b:	56                   	push   %esi
  80259c:	53                   	push   %ebx
  80259d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8025a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025a9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025ac:	8b 7d 18             	mov    0x18(%ebp),%edi
  8025af:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8025b2:	cd 30                	int    $0x30
  8025b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8025b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8025ba:	83 c4 10             	add    $0x10,%esp
  8025bd:	5b                   	pop    %ebx
  8025be:	5e                   	pop    %esi
  8025bf:	5f                   	pop    %edi
  8025c0:	5d                   	pop    %ebp
  8025c1:	c3                   	ret    

008025c2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8025c2:	55                   	push   %ebp
  8025c3:	89 e5                	mov    %esp,%ebp
  8025c5:	83 ec 04             	sub    $0x4,%esp
  8025c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8025cb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8025ce:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8025d1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8025d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d8:	6a 00                	push   $0x0
  8025da:	51                   	push   %ecx
  8025db:	52                   	push   %edx
  8025dc:	ff 75 0c             	pushl  0xc(%ebp)
  8025df:	50                   	push   %eax
  8025e0:	6a 00                	push   $0x0
  8025e2:	e8 b0 ff ff ff       	call   802597 <syscall>
  8025e7:	83 c4 18             	add    $0x18,%esp
}
  8025ea:	90                   	nop
  8025eb:	c9                   	leave  
  8025ec:	c3                   	ret    

008025ed <sys_cgetc>:

int
sys_cgetc(void)
{
  8025ed:	55                   	push   %ebp
  8025ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 00                	push   $0x0
  8025fa:	6a 02                	push   $0x2
  8025fc:	e8 96 ff ff ff       	call   802597 <syscall>
  802601:	83 c4 18             	add    $0x18,%esp
}
  802604:	c9                   	leave  
  802605:	c3                   	ret    

00802606 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802606:	55                   	push   %ebp
  802607:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802609:	6a 00                	push   $0x0
  80260b:	6a 00                	push   $0x0
  80260d:	6a 00                	push   $0x0
  80260f:	6a 00                	push   $0x0
  802611:	6a 00                	push   $0x0
  802613:	6a 03                	push   $0x3
  802615:	e8 7d ff ff ff       	call   802597 <syscall>
  80261a:	83 c4 18             	add    $0x18,%esp
}
  80261d:	90                   	nop
  80261e:	c9                   	leave  
  80261f:	c3                   	ret    

00802620 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802623:	6a 00                	push   $0x0
  802625:	6a 00                	push   $0x0
  802627:	6a 00                	push   $0x0
  802629:	6a 00                	push   $0x0
  80262b:	6a 00                	push   $0x0
  80262d:	6a 04                	push   $0x4
  80262f:	e8 63 ff ff ff       	call   802597 <syscall>
  802634:	83 c4 18             	add    $0x18,%esp
}
  802637:	90                   	nop
  802638:	c9                   	leave  
  802639:	c3                   	ret    

0080263a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80263a:	55                   	push   %ebp
  80263b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80263d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802640:	8b 45 08             	mov    0x8(%ebp),%eax
  802643:	6a 00                	push   $0x0
  802645:	6a 00                	push   $0x0
  802647:	6a 00                	push   $0x0
  802649:	52                   	push   %edx
  80264a:	50                   	push   %eax
  80264b:	6a 08                	push   $0x8
  80264d:	e8 45 ff ff ff       	call   802597 <syscall>
  802652:	83 c4 18             	add    $0x18,%esp
}
  802655:	c9                   	leave  
  802656:	c3                   	ret    

00802657 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802657:	55                   	push   %ebp
  802658:	89 e5                	mov    %esp,%ebp
  80265a:	56                   	push   %esi
  80265b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80265c:	8b 75 18             	mov    0x18(%ebp),%esi
  80265f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802662:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802665:	8b 55 0c             	mov    0xc(%ebp),%edx
  802668:	8b 45 08             	mov    0x8(%ebp),%eax
  80266b:	56                   	push   %esi
  80266c:	53                   	push   %ebx
  80266d:	51                   	push   %ecx
  80266e:	52                   	push   %edx
  80266f:	50                   	push   %eax
  802670:	6a 09                	push   $0x9
  802672:	e8 20 ff ff ff       	call   802597 <syscall>
  802677:	83 c4 18             	add    $0x18,%esp
}
  80267a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80267d:	5b                   	pop    %ebx
  80267e:	5e                   	pop    %esi
  80267f:	5d                   	pop    %ebp
  802680:	c3                   	ret    

00802681 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802681:	55                   	push   %ebp
  802682:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802684:	6a 00                	push   $0x0
  802686:	6a 00                	push   $0x0
  802688:	6a 00                	push   $0x0
  80268a:	6a 00                	push   $0x0
  80268c:	ff 75 08             	pushl  0x8(%ebp)
  80268f:	6a 0a                	push   $0xa
  802691:	e8 01 ff ff ff       	call   802597 <syscall>
  802696:	83 c4 18             	add    $0x18,%esp
}
  802699:	c9                   	leave  
  80269a:	c3                   	ret    

0080269b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80269b:	55                   	push   %ebp
  80269c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80269e:	6a 00                	push   $0x0
  8026a0:	6a 00                	push   $0x0
  8026a2:	6a 00                	push   $0x0
  8026a4:	ff 75 0c             	pushl  0xc(%ebp)
  8026a7:	ff 75 08             	pushl  0x8(%ebp)
  8026aa:	6a 0b                	push   $0xb
  8026ac:	e8 e6 fe ff ff       	call   802597 <syscall>
  8026b1:	83 c4 18             	add    $0x18,%esp
}
  8026b4:	c9                   	leave  
  8026b5:	c3                   	ret    

008026b6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8026b6:	55                   	push   %ebp
  8026b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8026b9:	6a 00                	push   $0x0
  8026bb:	6a 00                	push   $0x0
  8026bd:	6a 00                	push   $0x0
  8026bf:	6a 00                	push   $0x0
  8026c1:	6a 00                	push   $0x0
  8026c3:	6a 0c                	push   $0xc
  8026c5:	e8 cd fe ff ff       	call   802597 <syscall>
  8026ca:	83 c4 18             	add    $0x18,%esp
}
  8026cd:	c9                   	leave  
  8026ce:	c3                   	ret    

008026cf <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8026cf:	55                   	push   %ebp
  8026d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8026d2:	6a 00                	push   $0x0
  8026d4:	6a 00                	push   $0x0
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 00                	push   $0x0
  8026da:	6a 00                	push   $0x0
  8026dc:	6a 0d                	push   $0xd
  8026de:	e8 b4 fe ff ff       	call   802597 <syscall>
  8026e3:	83 c4 18             	add    $0x18,%esp
}
  8026e6:	c9                   	leave  
  8026e7:	c3                   	ret    

008026e8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8026e8:	55                   	push   %ebp
  8026e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8026eb:	6a 00                	push   $0x0
  8026ed:	6a 00                	push   $0x0
  8026ef:	6a 00                	push   $0x0
  8026f1:	6a 00                	push   $0x0
  8026f3:	6a 00                	push   $0x0
  8026f5:	6a 0e                	push   $0xe
  8026f7:	e8 9b fe ff ff       	call   802597 <syscall>
  8026fc:	83 c4 18             	add    $0x18,%esp
}
  8026ff:	c9                   	leave  
  802700:	c3                   	ret    

00802701 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802701:	55                   	push   %ebp
  802702:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802704:	6a 00                	push   $0x0
  802706:	6a 00                	push   $0x0
  802708:	6a 00                	push   $0x0
  80270a:	6a 00                	push   $0x0
  80270c:	6a 00                	push   $0x0
  80270e:	6a 0f                	push   $0xf
  802710:	e8 82 fe ff ff       	call   802597 <syscall>
  802715:	83 c4 18             	add    $0x18,%esp
}
  802718:	c9                   	leave  
  802719:	c3                   	ret    

0080271a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80271a:	55                   	push   %ebp
  80271b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80271d:	6a 00                	push   $0x0
  80271f:	6a 00                	push   $0x0
  802721:	6a 00                	push   $0x0
  802723:	6a 00                	push   $0x0
  802725:	ff 75 08             	pushl  0x8(%ebp)
  802728:	6a 10                	push   $0x10
  80272a:	e8 68 fe ff ff       	call   802597 <syscall>
  80272f:	83 c4 18             	add    $0x18,%esp
}
  802732:	c9                   	leave  
  802733:	c3                   	ret    

00802734 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802734:	55                   	push   %ebp
  802735:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802737:	6a 00                	push   $0x0
  802739:	6a 00                	push   $0x0
  80273b:	6a 00                	push   $0x0
  80273d:	6a 00                	push   $0x0
  80273f:	6a 00                	push   $0x0
  802741:	6a 11                	push   $0x11
  802743:	e8 4f fe ff ff       	call   802597 <syscall>
  802748:	83 c4 18             	add    $0x18,%esp
}
  80274b:	90                   	nop
  80274c:	c9                   	leave  
  80274d:	c3                   	ret    

0080274e <sys_cputc>:

void
sys_cputc(const char c)
{
  80274e:	55                   	push   %ebp
  80274f:	89 e5                	mov    %esp,%ebp
  802751:	83 ec 04             	sub    $0x4,%esp
  802754:	8b 45 08             	mov    0x8(%ebp),%eax
  802757:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80275a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80275e:	6a 00                	push   $0x0
  802760:	6a 00                	push   $0x0
  802762:	6a 00                	push   $0x0
  802764:	6a 00                	push   $0x0
  802766:	50                   	push   %eax
  802767:	6a 01                	push   $0x1
  802769:	e8 29 fe ff ff       	call   802597 <syscall>
  80276e:	83 c4 18             	add    $0x18,%esp
}
  802771:	90                   	nop
  802772:	c9                   	leave  
  802773:	c3                   	ret    

00802774 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802774:	55                   	push   %ebp
  802775:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802777:	6a 00                	push   $0x0
  802779:	6a 00                	push   $0x0
  80277b:	6a 00                	push   $0x0
  80277d:	6a 00                	push   $0x0
  80277f:	6a 00                	push   $0x0
  802781:	6a 14                	push   $0x14
  802783:	e8 0f fe ff ff       	call   802597 <syscall>
  802788:	83 c4 18             	add    $0x18,%esp
}
  80278b:	90                   	nop
  80278c:	c9                   	leave  
  80278d:	c3                   	ret    

0080278e <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80278e:	55                   	push   %ebp
  80278f:	89 e5                	mov    %esp,%ebp
  802791:	83 ec 04             	sub    $0x4,%esp
  802794:	8b 45 10             	mov    0x10(%ebp),%eax
  802797:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80279a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80279d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8027a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a4:	6a 00                	push   $0x0
  8027a6:	51                   	push   %ecx
  8027a7:	52                   	push   %edx
  8027a8:	ff 75 0c             	pushl  0xc(%ebp)
  8027ab:	50                   	push   %eax
  8027ac:	6a 15                	push   $0x15
  8027ae:	e8 e4 fd ff ff       	call   802597 <syscall>
  8027b3:	83 c4 18             	add    $0x18,%esp
}
  8027b6:	c9                   	leave  
  8027b7:	c3                   	ret    

008027b8 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8027b8:	55                   	push   %ebp
  8027b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8027bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027be:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c1:	6a 00                	push   $0x0
  8027c3:	6a 00                	push   $0x0
  8027c5:	6a 00                	push   $0x0
  8027c7:	52                   	push   %edx
  8027c8:	50                   	push   %eax
  8027c9:	6a 16                	push   $0x16
  8027cb:	e8 c7 fd ff ff       	call   802597 <syscall>
  8027d0:	83 c4 18             	add    $0x18,%esp
}
  8027d3:	c9                   	leave  
  8027d4:	c3                   	ret    

008027d5 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8027d5:	55                   	push   %ebp
  8027d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8027d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027de:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e1:	6a 00                	push   $0x0
  8027e3:	6a 00                	push   $0x0
  8027e5:	51                   	push   %ecx
  8027e6:	52                   	push   %edx
  8027e7:	50                   	push   %eax
  8027e8:	6a 17                	push   $0x17
  8027ea:	e8 a8 fd ff ff       	call   802597 <syscall>
  8027ef:	83 c4 18             	add    $0x18,%esp
}
  8027f2:	c9                   	leave  
  8027f3:	c3                   	ret    

008027f4 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8027f4:	55                   	push   %ebp
  8027f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8027f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fd:	6a 00                	push   $0x0
  8027ff:	6a 00                	push   $0x0
  802801:	6a 00                	push   $0x0
  802803:	52                   	push   %edx
  802804:	50                   	push   %eax
  802805:	6a 18                	push   $0x18
  802807:	e8 8b fd ff ff       	call   802597 <syscall>
  80280c:	83 c4 18             	add    $0x18,%esp
}
  80280f:	c9                   	leave  
  802810:	c3                   	ret    

00802811 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802811:	55                   	push   %ebp
  802812:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802814:	8b 45 08             	mov    0x8(%ebp),%eax
  802817:	6a 00                	push   $0x0
  802819:	ff 75 14             	pushl  0x14(%ebp)
  80281c:	ff 75 10             	pushl  0x10(%ebp)
  80281f:	ff 75 0c             	pushl  0xc(%ebp)
  802822:	50                   	push   %eax
  802823:	6a 19                	push   $0x19
  802825:	e8 6d fd ff ff       	call   802597 <syscall>
  80282a:	83 c4 18             	add    $0x18,%esp
}
  80282d:	c9                   	leave  
  80282e:	c3                   	ret    

0080282f <sys_run_env>:

void sys_run_env(int32 envId)
{
  80282f:	55                   	push   %ebp
  802830:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802832:	8b 45 08             	mov    0x8(%ebp),%eax
  802835:	6a 00                	push   $0x0
  802837:	6a 00                	push   $0x0
  802839:	6a 00                	push   $0x0
  80283b:	6a 00                	push   $0x0
  80283d:	50                   	push   %eax
  80283e:	6a 1a                	push   $0x1a
  802840:	e8 52 fd ff ff       	call   802597 <syscall>
  802845:	83 c4 18             	add    $0x18,%esp
}
  802848:	90                   	nop
  802849:	c9                   	leave  
  80284a:	c3                   	ret    

0080284b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80284b:	55                   	push   %ebp
  80284c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80284e:	8b 45 08             	mov    0x8(%ebp),%eax
  802851:	6a 00                	push   $0x0
  802853:	6a 00                	push   $0x0
  802855:	6a 00                	push   $0x0
  802857:	6a 00                	push   $0x0
  802859:	50                   	push   %eax
  80285a:	6a 1b                	push   $0x1b
  80285c:	e8 36 fd ff ff       	call   802597 <syscall>
  802861:	83 c4 18             	add    $0x18,%esp
}
  802864:	c9                   	leave  
  802865:	c3                   	ret    

00802866 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802866:	55                   	push   %ebp
  802867:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802869:	6a 00                	push   $0x0
  80286b:	6a 00                	push   $0x0
  80286d:	6a 00                	push   $0x0
  80286f:	6a 00                	push   $0x0
  802871:	6a 00                	push   $0x0
  802873:	6a 05                	push   $0x5
  802875:	e8 1d fd ff ff       	call   802597 <syscall>
  80287a:	83 c4 18             	add    $0x18,%esp
}
  80287d:	c9                   	leave  
  80287e:	c3                   	ret    

0080287f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80287f:	55                   	push   %ebp
  802880:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802882:	6a 00                	push   $0x0
  802884:	6a 00                	push   $0x0
  802886:	6a 00                	push   $0x0
  802888:	6a 00                	push   $0x0
  80288a:	6a 00                	push   $0x0
  80288c:	6a 06                	push   $0x6
  80288e:	e8 04 fd ff ff       	call   802597 <syscall>
  802893:	83 c4 18             	add    $0x18,%esp
}
  802896:	c9                   	leave  
  802897:	c3                   	ret    

00802898 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802898:	55                   	push   %ebp
  802899:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80289b:	6a 00                	push   $0x0
  80289d:	6a 00                	push   $0x0
  80289f:	6a 00                	push   $0x0
  8028a1:	6a 00                	push   $0x0
  8028a3:	6a 00                	push   $0x0
  8028a5:	6a 07                	push   $0x7
  8028a7:	e8 eb fc ff ff       	call   802597 <syscall>
  8028ac:	83 c4 18             	add    $0x18,%esp
}
  8028af:	c9                   	leave  
  8028b0:	c3                   	ret    

008028b1 <sys_exit_env>:


void sys_exit_env(void)
{
  8028b1:	55                   	push   %ebp
  8028b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8028b4:	6a 00                	push   $0x0
  8028b6:	6a 00                	push   $0x0
  8028b8:	6a 00                	push   $0x0
  8028ba:	6a 00                	push   $0x0
  8028bc:	6a 00                	push   $0x0
  8028be:	6a 1c                	push   $0x1c
  8028c0:	e8 d2 fc ff ff       	call   802597 <syscall>
  8028c5:	83 c4 18             	add    $0x18,%esp
}
  8028c8:	90                   	nop
  8028c9:	c9                   	leave  
  8028ca:	c3                   	ret    

008028cb <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8028cb:	55                   	push   %ebp
  8028cc:	89 e5                	mov    %esp,%ebp
  8028ce:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8028d1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8028d4:	8d 50 04             	lea    0x4(%eax),%edx
  8028d7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8028da:	6a 00                	push   $0x0
  8028dc:	6a 00                	push   $0x0
  8028de:	6a 00                	push   $0x0
  8028e0:	52                   	push   %edx
  8028e1:	50                   	push   %eax
  8028e2:	6a 1d                	push   $0x1d
  8028e4:	e8 ae fc ff ff       	call   802597 <syscall>
  8028e9:	83 c4 18             	add    $0x18,%esp
	return result;
  8028ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8028f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8028f5:	89 01                	mov    %eax,(%ecx)
  8028f7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8028fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fd:	c9                   	leave  
  8028fe:	c2 04 00             	ret    $0x4

00802901 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802901:	55                   	push   %ebp
  802902:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802904:	6a 00                	push   $0x0
  802906:	6a 00                	push   $0x0
  802908:	ff 75 10             	pushl  0x10(%ebp)
  80290b:	ff 75 0c             	pushl  0xc(%ebp)
  80290e:	ff 75 08             	pushl  0x8(%ebp)
  802911:	6a 13                	push   $0x13
  802913:	e8 7f fc ff ff       	call   802597 <syscall>
  802918:	83 c4 18             	add    $0x18,%esp
	return ;
  80291b:	90                   	nop
}
  80291c:	c9                   	leave  
  80291d:	c3                   	ret    

0080291e <sys_rcr2>:
uint32 sys_rcr2()
{
  80291e:	55                   	push   %ebp
  80291f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802921:	6a 00                	push   $0x0
  802923:	6a 00                	push   $0x0
  802925:	6a 00                	push   $0x0
  802927:	6a 00                	push   $0x0
  802929:	6a 00                	push   $0x0
  80292b:	6a 1e                	push   $0x1e
  80292d:	e8 65 fc ff ff       	call   802597 <syscall>
  802932:	83 c4 18             	add    $0x18,%esp
}
  802935:	c9                   	leave  
  802936:	c3                   	ret    

00802937 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802937:	55                   	push   %ebp
  802938:	89 e5                	mov    %esp,%ebp
  80293a:	83 ec 04             	sub    $0x4,%esp
  80293d:	8b 45 08             	mov    0x8(%ebp),%eax
  802940:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802943:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802947:	6a 00                	push   $0x0
  802949:	6a 00                	push   $0x0
  80294b:	6a 00                	push   $0x0
  80294d:	6a 00                	push   $0x0
  80294f:	50                   	push   %eax
  802950:	6a 1f                	push   $0x1f
  802952:	e8 40 fc ff ff       	call   802597 <syscall>
  802957:	83 c4 18             	add    $0x18,%esp
	return ;
  80295a:	90                   	nop
}
  80295b:	c9                   	leave  
  80295c:	c3                   	ret    

0080295d <rsttst>:
void rsttst()
{
  80295d:	55                   	push   %ebp
  80295e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802960:	6a 00                	push   $0x0
  802962:	6a 00                	push   $0x0
  802964:	6a 00                	push   $0x0
  802966:	6a 00                	push   $0x0
  802968:	6a 00                	push   $0x0
  80296a:	6a 21                	push   $0x21
  80296c:	e8 26 fc ff ff       	call   802597 <syscall>
  802971:	83 c4 18             	add    $0x18,%esp
	return ;
  802974:	90                   	nop
}
  802975:	c9                   	leave  
  802976:	c3                   	ret    

00802977 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802977:	55                   	push   %ebp
  802978:	89 e5                	mov    %esp,%ebp
  80297a:	83 ec 04             	sub    $0x4,%esp
  80297d:	8b 45 14             	mov    0x14(%ebp),%eax
  802980:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802983:	8b 55 18             	mov    0x18(%ebp),%edx
  802986:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80298a:	52                   	push   %edx
  80298b:	50                   	push   %eax
  80298c:	ff 75 10             	pushl  0x10(%ebp)
  80298f:	ff 75 0c             	pushl  0xc(%ebp)
  802992:	ff 75 08             	pushl  0x8(%ebp)
  802995:	6a 20                	push   $0x20
  802997:	e8 fb fb ff ff       	call   802597 <syscall>
  80299c:	83 c4 18             	add    $0x18,%esp
	return ;
  80299f:	90                   	nop
}
  8029a0:	c9                   	leave  
  8029a1:	c3                   	ret    

008029a2 <chktst>:
void chktst(uint32 n)
{
  8029a2:	55                   	push   %ebp
  8029a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8029a5:	6a 00                	push   $0x0
  8029a7:	6a 00                	push   $0x0
  8029a9:	6a 00                	push   $0x0
  8029ab:	6a 00                	push   $0x0
  8029ad:	ff 75 08             	pushl  0x8(%ebp)
  8029b0:	6a 22                	push   $0x22
  8029b2:	e8 e0 fb ff ff       	call   802597 <syscall>
  8029b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8029ba:	90                   	nop
}
  8029bb:	c9                   	leave  
  8029bc:	c3                   	ret    

008029bd <inctst>:

void inctst()
{
  8029bd:	55                   	push   %ebp
  8029be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8029c0:	6a 00                	push   $0x0
  8029c2:	6a 00                	push   $0x0
  8029c4:	6a 00                	push   $0x0
  8029c6:	6a 00                	push   $0x0
  8029c8:	6a 00                	push   $0x0
  8029ca:	6a 23                	push   $0x23
  8029cc:	e8 c6 fb ff ff       	call   802597 <syscall>
  8029d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8029d4:	90                   	nop
}
  8029d5:	c9                   	leave  
  8029d6:	c3                   	ret    

008029d7 <gettst>:
uint32 gettst()
{
  8029d7:	55                   	push   %ebp
  8029d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8029da:	6a 00                	push   $0x0
  8029dc:	6a 00                	push   $0x0
  8029de:	6a 00                	push   $0x0
  8029e0:	6a 00                	push   $0x0
  8029e2:	6a 00                	push   $0x0
  8029e4:	6a 24                	push   $0x24
  8029e6:	e8 ac fb ff ff       	call   802597 <syscall>
  8029eb:	83 c4 18             	add    $0x18,%esp
}
  8029ee:	c9                   	leave  
  8029ef:	c3                   	ret    

008029f0 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8029f0:	55                   	push   %ebp
  8029f1:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029f3:	6a 00                	push   $0x0
  8029f5:	6a 00                	push   $0x0
  8029f7:	6a 00                	push   $0x0
  8029f9:	6a 00                	push   $0x0
  8029fb:	6a 00                	push   $0x0
  8029fd:	6a 25                	push   $0x25
  8029ff:	e8 93 fb ff ff       	call   802597 <syscall>
  802a04:	83 c4 18             	add    $0x18,%esp
  802a07:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802a0c:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  802a11:	c9                   	leave  
  802a12:	c3                   	ret    

00802a13 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802a13:	55                   	push   %ebp
  802a14:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802a16:	8b 45 08             	mov    0x8(%ebp),%eax
  802a19:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802a1e:	6a 00                	push   $0x0
  802a20:	6a 00                	push   $0x0
  802a22:	6a 00                	push   $0x0
  802a24:	6a 00                	push   $0x0
  802a26:	ff 75 08             	pushl  0x8(%ebp)
  802a29:	6a 26                	push   $0x26
  802a2b:	e8 67 fb ff ff       	call   802597 <syscall>
  802a30:	83 c4 18             	add    $0x18,%esp
	return ;
  802a33:	90                   	nop
}
  802a34:	c9                   	leave  
  802a35:	c3                   	ret    

00802a36 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802a36:	55                   	push   %ebp
  802a37:	89 e5                	mov    %esp,%ebp
  802a39:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802a3a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a40:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a43:	8b 45 08             	mov    0x8(%ebp),%eax
  802a46:	6a 00                	push   $0x0
  802a48:	53                   	push   %ebx
  802a49:	51                   	push   %ecx
  802a4a:	52                   	push   %edx
  802a4b:	50                   	push   %eax
  802a4c:	6a 27                	push   $0x27
  802a4e:	e8 44 fb ff ff       	call   802597 <syscall>
  802a53:	83 c4 18             	add    $0x18,%esp
}
  802a56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a59:	c9                   	leave  
  802a5a:	c3                   	ret    

00802a5b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802a5b:	55                   	push   %ebp
  802a5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802a5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a61:	8b 45 08             	mov    0x8(%ebp),%eax
  802a64:	6a 00                	push   $0x0
  802a66:	6a 00                	push   $0x0
  802a68:	6a 00                	push   $0x0
  802a6a:	52                   	push   %edx
  802a6b:	50                   	push   %eax
  802a6c:	6a 28                	push   $0x28
  802a6e:	e8 24 fb ff ff       	call   802597 <syscall>
  802a73:	83 c4 18             	add    $0x18,%esp
}
  802a76:	c9                   	leave  
  802a77:	c3                   	ret    

00802a78 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802a78:	55                   	push   %ebp
  802a79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802a7b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802a7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a81:	8b 45 08             	mov    0x8(%ebp),%eax
  802a84:	6a 00                	push   $0x0
  802a86:	51                   	push   %ecx
  802a87:	ff 75 10             	pushl  0x10(%ebp)
  802a8a:	52                   	push   %edx
  802a8b:	50                   	push   %eax
  802a8c:	6a 29                	push   $0x29
  802a8e:	e8 04 fb ff ff       	call   802597 <syscall>
  802a93:	83 c4 18             	add    $0x18,%esp
}
  802a96:	c9                   	leave  
  802a97:	c3                   	ret    

00802a98 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802a98:	55                   	push   %ebp
  802a99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802a9b:	6a 00                	push   $0x0
  802a9d:	6a 00                	push   $0x0
  802a9f:	ff 75 10             	pushl  0x10(%ebp)
  802aa2:	ff 75 0c             	pushl  0xc(%ebp)
  802aa5:	ff 75 08             	pushl  0x8(%ebp)
  802aa8:	6a 12                	push   $0x12
  802aaa:	e8 e8 fa ff ff       	call   802597 <syscall>
  802aaf:	83 c4 18             	add    $0x18,%esp
	return ;
  802ab2:	90                   	nop
}
  802ab3:	c9                   	leave  
  802ab4:	c3                   	ret    

00802ab5 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802ab5:	55                   	push   %ebp
  802ab6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802ab8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802abb:	8b 45 08             	mov    0x8(%ebp),%eax
  802abe:	6a 00                	push   $0x0
  802ac0:	6a 00                	push   $0x0
  802ac2:	6a 00                	push   $0x0
  802ac4:	52                   	push   %edx
  802ac5:	50                   	push   %eax
  802ac6:	6a 2a                	push   $0x2a
  802ac8:	e8 ca fa ff ff       	call   802597 <syscall>
  802acd:	83 c4 18             	add    $0x18,%esp
	return;
  802ad0:	90                   	nop
}
  802ad1:	c9                   	leave  
  802ad2:	c3                   	ret    

00802ad3 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802ad3:	55                   	push   %ebp
  802ad4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802ad6:	6a 00                	push   $0x0
  802ad8:	6a 00                	push   $0x0
  802ada:	6a 00                	push   $0x0
  802adc:	6a 00                	push   $0x0
  802ade:	6a 00                	push   $0x0
  802ae0:	6a 2b                	push   $0x2b
  802ae2:	e8 b0 fa ff ff       	call   802597 <syscall>
  802ae7:	83 c4 18             	add    $0x18,%esp
}
  802aea:	c9                   	leave  
  802aeb:	c3                   	ret    

00802aec <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802aec:	55                   	push   %ebp
  802aed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802aef:	6a 00                	push   $0x0
  802af1:	6a 00                	push   $0x0
  802af3:	6a 00                	push   $0x0
  802af5:	ff 75 0c             	pushl  0xc(%ebp)
  802af8:	ff 75 08             	pushl  0x8(%ebp)
  802afb:	6a 2d                	push   $0x2d
  802afd:	e8 95 fa ff ff       	call   802597 <syscall>
  802b02:	83 c4 18             	add    $0x18,%esp
	return;
  802b05:	90                   	nop
}
  802b06:	c9                   	leave  
  802b07:	c3                   	ret    

00802b08 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802b08:	55                   	push   %ebp
  802b09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802b0b:	6a 00                	push   $0x0
  802b0d:	6a 00                	push   $0x0
  802b0f:	6a 00                	push   $0x0
  802b11:	ff 75 0c             	pushl  0xc(%ebp)
  802b14:	ff 75 08             	pushl  0x8(%ebp)
  802b17:	6a 2c                	push   $0x2c
  802b19:	e8 79 fa ff ff       	call   802597 <syscall>
  802b1e:	83 c4 18             	add    $0x18,%esp
	return ;
  802b21:	90                   	nop
}
  802b22:	c9                   	leave  
  802b23:	c3                   	ret    

00802b24 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802b24:	55                   	push   %ebp
  802b25:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802b27:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2d:	6a 00                	push   $0x0
  802b2f:	6a 00                	push   $0x0
  802b31:	6a 00                	push   $0x0
  802b33:	52                   	push   %edx
  802b34:	50                   	push   %eax
  802b35:	6a 2e                	push   $0x2e
  802b37:	e8 5b fa ff ff       	call   802597 <syscall>
  802b3c:	83 c4 18             	add    $0x18,%esp
	return ;
  802b3f:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  802b40:	c9                   	leave  
  802b41:	c3                   	ret    

00802b42 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802b42:	55                   	push   %ebp
  802b43:	89 e5                	mov    %esp,%ebp
  802b45:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802b48:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  802b4f:	72 09                	jb     802b5a <to_page_va+0x18>
  802b51:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  802b58:	72 14                	jb     802b6e <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802b5a:	83 ec 04             	sub    $0x4,%esp
  802b5d:	68 a0 4b 80 00       	push   $0x804ba0
  802b62:	6a 15                	push   $0x15
  802b64:	68 cb 4b 80 00       	push   $0x804bcb
  802b69:	e8 4e db ff ff       	call   8006bc <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b71:	ba 60 50 80 00       	mov    $0x805060,%edx
  802b76:	29 d0                	sub    %edx,%eax
  802b78:	c1 f8 02             	sar    $0x2,%eax
  802b7b:	89 c2                	mov    %eax,%edx
  802b7d:	89 d0                	mov    %edx,%eax
  802b7f:	c1 e0 02             	shl    $0x2,%eax
  802b82:	01 d0                	add    %edx,%eax
  802b84:	c1 e0 02             	shl    $0x2,%eax
  802b87:	01 d0                	add    %edx,%eax
  802b89:	c1 e0 02             	shl    $0x2,%eax
  802b8c:	01 d0                	add    %edx,%eax
  802b8e:	89 c1                	mov    %eax,%ecx
  802b90:	c1 e1 08             	shl    $0x8,%ecx
  802b93:	01 c8                	add    %ecx,%eax
  802b95:	89 c1                	mov    %eax,%ecx
  802b97:	c1 e1 10             	shl    $0x10,%ecx
  802b9a:	01 c8                	add    %ecx,%eax
  802b9c:	01 c0                	add    %eax,%eax
  802b9e:	01 d0                	add    %edx,%eax
  802ba0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba6:	c1 e0 0c             	shl    $0xc,%eax
  802ba9:	89 c2                	mov    %eax,%edx
  802bab:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802bb0:	01 d0                	add    %edx,%eax
}
  802bb2:	c9                   	leave  
  802bb3:	c3                   	ret    

00802bb4 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802bb4:	55                   	push   %ebp
  802bb5:	89 e5                	mov    %esp,%ebp
  802bb7:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802bba:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802bbf:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc2:	29 c2                	sub    %eax,%edx
  802bc4:	89 d0                	mov    %edx,%eax
  802bc6:	c1 e8 0c             	shr    $0xc,%eax
  802bc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802bcc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd0:	78 09                	js     802bdb <to_page_info+0x27>
  802bd2:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802bd9:	7e 14                	jle    802bef <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802bdb:	83 ec 04             	sub    $0x4,%esp
  802bde:	68 e4 4b 80 00       	push   $0x804be4
  802be3:	6a 22                	push   $0x22
  802be5:	68 cb 4b 80 00       	push   $0x804bcb
  802bea:	e8 cd da ff ff       	call   8006bc <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802bef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf2:	89 d0                	mov    %edx,%eax
  802bf4:	01 c0                	add    %eax,%eax
  802bf6:	01 d0                	add    %edx,%eax
  802bf8:	c1 e0 02             	shl    $0x2,%eax
  802bfb:	05 60 50 80 00       	add    $0x805060,%eax
}
  802c00:	c9                   	leave  
  802c01:	c3                   	ret    

00802c02 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802c02:	55                   	push   %ebp
  802c03:	89 e5                	mov    %esp,%ebp
  802c05:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802c08:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0b:	05 00 00 00 02       	add    $0x2000000,%eax
  802c10:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c13:	73 16                	jae    802c2b <initialize_dynamic_allocator+0x29>
  802c15:	68 08 4c 80 00       	push   $0x804c08
  802c1a:	68 2e 4c 80 00       	push   $0x804c2e
  802c1f:	6a 34                	push   $0x34
  802c21:	68 cb 4b 80 00       	push   $0x804bcb
  802c26:	e8 91 da ff ff       	call   8006bc <_panic>
		is_initialized = 1;
  802c2b:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  802c32:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  802c35:	8b 45 08             	mov    0x8(%ebp),%eax
  802c38:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  802c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c40:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  802c45:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  802c4c:	00 00 00 
  802c4f:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802c56:	00 00 00 
  802c59:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  802c60:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  802c63:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  802c6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c71:	eb 36                	jmp    802ca9 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  802c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c76:	c1 e0 04             	shl    $0x4,%eax
  802c79:	05 80 d0 81 00       	add    $0x81d080,%eax
  802c7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	c1 e0 04             	shl    $0x4,%eax
  802c8a:	05 84 d0 81 00       	add    $0x81d084,%eax
  802c8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c98:	c1 e0 04             	shl    $0x4,%eax
  802c9b:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802ca0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  802ca6:	ff 45 f4             	incl   -0xc(%ebp)
  802ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cac:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802caf:	72 c2                	jb     802c73 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  802cb1:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802cb7:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802cbc:	29 c2                	sub    %eax,%edx
  802cbe:	89 d0                	mov    %edx,%eax
  802cc0:	c1 e8 0c             	shr    $0xc,%eax
  802cc3:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802cc6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802ccd:	e9 c8 00 00 00       	jmp    802d9a <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802cd2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cd5:	89 d0                	mov    %edx,%eax
  802cd7:	01 c0                	add    %eax,%eax
  802cd9:	01 d0                	add    %edx,%eax
  802cdb:	c1 e0 02             	shl    $0x2,%eax
  802cde:	05 68 50 80 00       	add    $0x805068,%eax
  802ce3:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802ce8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ceb:	89 d0                	mov    %edx,%eax
  802ced:	01 c0                	add    %eax,%eax
  802cef:	01 d0                	add    %edx,%eax
  802cf1:	c1 e0 02             	shl    $0x2,%eax
  802cf4:	05 6a 50 80 00       	add    $0x80506a,%eax
  802cf9:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802cfe:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802d04:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802d07:	89 c8                	mov    %ecx,%eax
  802d09:	01 c0                	add    %eax,%eax
  802d0b:	01 c8                	add    %ecx,%eax
  802d0d:	c1 e0 02             	shl    $0x2,%eax
  802d10:	05 64 50 80 00       	add    $0x805064,%eax
  802d15:	89 10                	mov    %edx,(%eax)
  802d17:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d1a:	89 d0                	mov    %edx,%eax
  802d1c:	01 c0                	add    %eax,%eax
  802d1e:	01 d0                	add    %edx,%eax
  802d20:	c1 e0 02             	shl    $0x2,%eax
  802d23:	05 64 50 80 00       	add    $0x805064,%eax
  802d28:	8b 00                	mov    (%eax),%eax
  802d2a:	85 c0                	test   %eax,%eax
  802d2c:	74 1b                	je     802d49 <initialize_dynamic_allocator+0x147>
  802d2e:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802d34:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802d37:	89 c8                	mov    %ecx,%eax
  802d39:	01 c0                	add    %eax,%eax
  802d3b:	01 c8                	add    %ecx,%eax
  802d3d:	c1 e0 02             	shl    $0x2,%eax
  802d40:	05 60 50 80 00       	add    $0x805060,%eax
  802d45:	89 02                	mov    %eax,(%edx)
  802d47:	eb 16                	jmp    802d5f <initialize_dynamic_allocator+0x15d>
  802d49:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d4c:	89 d0                	mov    %edx,%eax
  802d4e:	01 c0                	add    %eax,%eax
  802d50:	01 d0                	add    %edx,%eax
  802d52:	c1 e0 02             	shl    $0x2,%eax
  802d55:	05 60 50 80 00       	add    $0x805060,%eax
  802d5a:	a3 48 50 80 00       	mov    %eax,0x805048
  802d5f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d62:	89 d0                	mov    %edx,%eax
  802d64:	01 c0                	add    %eax,%eax
  802d66:	01 d0                	add    %edx,%eax
  802d68:	c1 e0 02             	shl    $0x2,%eax
  802d6b:	05 60 50 80 00       	add    $0x805060,%eax
  802d70:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802d75:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d78:	89 d0                	mov    %edx,%eax
  802d7a:	01 c0                	add    %eax,%eax
  802d7c:	01 d0                	add    %edx,%eax
  802d7e:	c1 e0 02             	shl    $0x2,%eax
  802d81:	05 60 50 80 00       	add    $0x805060,%eax
  802d86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d8c:	a1 54 50 80 00       	mov    0x805054,%eax
  802d91:	40                   	inc    %eax
  802d92:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  802d97:	ff 45 f0             	incl   -0x10(%ebp)
  802d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802da0:	0f 82 2c ff ff ff    	jb     802cd2 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802da6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802dac:	eb 2f                	jmp    802ddd <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  802dae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802db1:	89 d0                	mov    %edx,%eax
  802db3:	01 c0                	add    %eax,%eax
  802db5:	01 d0                	add    %edx,%eax
  802db7:	c1 e0 02             	shl    $0x2,%eax
  802dba:	05 68 50 80 00       	add    $0x805068,%eax
  802dbf:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  802dc4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dc7:	89 d0                	mov    %edx,%eax
  802dc9:	01 c0                	add    %eax,%eax
  802dcb:	01 d0                	add    %edx,%eax
  802dcd:	c1 e0 02             	shl    $0x2,%eax
  802dd0:	05 6a 50 80 00       	add    $0x80506a,%eax
  802dd5:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802dda:	ff 45 ec             	incl   -0x14(%ebp)
  802ddd:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  802de4:	76 c8                	jbe    802dae <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802de6:	90                   	nop
  802de7:	c9                   	leave  
  802de8:	c3                   	ret    

00802de9 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802de9:	55                   	push   %ebp
  802dea:	89 e5                	mov    %esp,%ebp
  802dec:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  802def:	8b 55 08             	mov    0x8(%ebp),%edx
  802df2:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802df7:	29 c2                	sub    %eax,%edx
  802df9:	89 d0                	mov    %edx,%eax
  802dfb:	c1 e8 0c             	shr    $0xc,%eax
  802dfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  802e01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802e04:	89 d0                	mov    %edx,%eax
  802e06:	01 c0                	add    %eax,%eax
  802e08:	01 d0                	add    %edx,%eax
  802e0a:	c1 e0 02             	shl    $0x2,%eax
  802e0d:	05 68 50 80 00       	add    $0x805068,%eax
  802e12:	8b 00                	mov    (%eax),%eax
  802e14:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802e17:	c9                   	leave  
  802e18:	c3                   	ret    

00802e19 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802e19:	55                   	push   %ebp
  802e1a:	89 e5                	mov    %esp,%ebp
  802e1c:	83 ec 14             	sub    $0x14,%esp
  802e1f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  802e22:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  802e26:	77 07                	ja     802e2f <nearest_pow2_ceil.1513+0x16>
  802e28:	b8 01 00 00 00       	mov    $0x1,%eax
  802e2d:	eb 20                	jmp    802e4f <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  802e2f:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  802e36:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  802e39:	eb 08                	jmp    802e43 <nearest_pow2_ceil.1513+0x2a>
  802e3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802e3e:	01 c0                	add    %eax,%eax
  802e40:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802e43:	d1 6d 08             	shrl   0x8(%ebp)
  802e46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e4a:	75 ef                	jne    802e3b <nearest_pow2_ceil.1513+0x22>
        return power;
  802e4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802e4f:	c9                   	leave  
  802e50:	c3                   	ret    

00802e51 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802e51:	55                   	push   %ebp
  802e52:	89 e5                	mov    %esp,%ebp
  802e54:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802e57:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802e5e:	76 16                	jbe    802e76 <alloc_block+0x25>
  802e60:	68 44 4c 80 00       	push   $0x804c44
  802e65:	68 2e 4c 80 00       	push   $0x804c2e
  802e6a:	6a 72                	push   $0x72
  802e6c:	68 cb 4b 80 00       	push   $0x804bcb
  802e71:	e8 46 d8 ff ff       	call   8006bc <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  802e76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e7a:	75 0a                	jne    802e86 <alloc_block+0x35>
  802e7c:	b8 00 00 00 00       	mov    $0x0,%eax
  802e81:	e9 bd 04 00 00       	jmp    803343 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  802e86:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  802e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e90:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802e93:	73 06                	jae    802e9b <alloc_block+0x4a>
        size = min_block_size;
  802e95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e98:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  802e9b:	83 ec 0c             	sub    $0xc,%esp
  802e9e:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802ea1:	ff 75 08             	pushl  0x8(%ebp)
  802ea4:	89 c1                	mov    %eax,%ecx
  802ea6:	e8 6e ff ff ff       	call   802e19 <nearest_pow2_ceil.1513>
  802eab:	83 c4 10             	add    $0x10,%esp
  802eae:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  802eb1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802eb4:	83 ec 0c             	sub    $0xc,%esp
  802eb7:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802eba:	52                   	push   %edx
  802ebb:	89 c1                	mov    %eax,%ecx
  802ebd:	e8 83 04 00 00       	call   803345 <log2_ceil.1520>
  802ec2:	83 c4 10             	add    $0x10,%esp
  802ec5:	83 e8 03             	sub    $0x3,%eax
  802ec8:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  802ecb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ece:	c1 e0 04             	shl    $0x4,%eax
  802ed1:	05 80 d0 81 00       	add    $0x81d080,%eax
  802ed6:	8b 00                	mov    (%eax),%eax
  802ed8:	85 c0                	test   %eax,%eax
  802eda:	0f 84 d8 00 00 00    	je     802fb8 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802ee0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ee3:	c1 e0 04             	shl    $0x4,%eax
  802ee6:	05 80 d0 81 00       	add    $0x81d080,%eax
  802eeb:	8b 00                	mov    (%eax),%eax
  802eed:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802ef0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ef4:	75 17                	jne    802f0d <alloc_block+0xbc>
  802ef6:	83 ec 04             	sub    $0x4,%esp
  802ef9:	68 65 4c 80 00       	push   $0x804c65
  802efe:	68 98 00 00 00       	push   $0x98
  802f03:	68 cb 4b 80 00       	push   $0x804bcb
  802f08:	e8 af d7 ff ff       	call   8006bc <_panic>
  802f0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f10:	8b 00                	mov    (%eax),%eax
  802f12:	85 c0                	test   %eax,%eax
  802f14:	74 10                	je     802f26 <alloc_block+0xd5>
  802f16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f19:	8b 00                	mov    (%eax),%eax
  802f1b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f1e:	8b 52 04             	mov    0x4(%edx),%edx
  802f21:	89 50 04             	mov    %edx,0x4(%eax)
  802f24:	eb 14                	jmp    802f3a <alloc_block+0xe9>
  802f26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f29:	8b 40 04             	mov    0x4(%eax),%eax
  802f2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f2f:	c1 e2 04             	shl    $0x4,%edx
  802f32:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802f38:	89 02                	mov    %eax,(%edx)
  802f3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f3d:	8b 40 04             	mov    0x4(%eax),%eax
  802f40:	85 c0                	test   %eax,%eax
  802f42:	74 0f                	je     802f53 <alloc_block+0x102>
  802f44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f47:	8b 40 04             	mov    0x4(%eax),%eax
  802f4a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f4d:	8b 12                	mov    (%edx),%edx
  802f4f:	89 10                	mov    %edx,(%eax)
  802f51:	eb 13                	jmp    802f66 <alloc_block+0x115>
  802f53:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f56:	8b 00                	mov    (%eax),%eax
  802f58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f5b:	c1 e2 04             	shl    $0x4,%edx
  802f5e:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802f64:	89 02                	mov    %eax,(%edx)
  802f66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f7c:	c1 e0 04             	shl    $0x4,%eax
  802f7f:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f84:	8b 00                	mov    (%eax),%eax
  802f86:	8d 50 ff             	lea    -0x1(%eax),%edx
  802f89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f8c:	c1 e0 04             	shl    $0x4,%eax
  802f8f:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f94:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802f96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f99:	83 ec 0c             	sub    $0xc,%esp
  802f9c:	50                   	push   %eax
  802f9d:	e8 12 fc ff ff       	call   802bb4 <to_page_info>
  802fa2:	83 c4 10             	add    $0x10,%esp
  802fa5:	89 c2                	mov    %eax,%edx
  802fa7:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802fab:	48                   	dec    %eax
  802fac:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  802fb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fb3:	e9 8b 03 00 00       	jmp    803343 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  802fb8:	a1 48 50 80 00       	mov    0x805048,%eax
  802fbd:	85 c0                	test   %eax,%eax
  802fbf:	0f 84 64 02 00 00    	je     803229 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  802fc5:	a1 48 50 80 00       	mov    0x805048,%eax
  802fca:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  802fcd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fd1:	75 17                	jne    802fea <alloc_block+0x199>
  802fd3:	83 ec 04             	sub    $0x4,%esp
  802fd6:	68 65 4c 80 00       	push   $0x804c65
  802fdb:	68 a0 00 00 00       	push   $0xa0
  802fe0:	68 cb 4b 80 00       	push   $0x804bcb
  802fe5:	e8 d2 d6 ff ff       	call   8006bc <_panic>
  802fea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fed:	8b 00                	mov    (%eax),%eax
  802fef:	85 c0                	test   %eax,%eax
  802ff1:	74 10                	je     803003 <alloc_block+0x1b2>
  802ff3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ff6:	8b 00                	mov    (%eax),%eax
  802ff8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ffb:	8b 52 04             	mov    0x4(%edx),%edx
  802ffe:	89 50 04             	mov    %edx,0x4(%eax)
  803001:	eb 0b                	jmp    80300e <alloc_block+0x1bd>
  803003:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803006:	8b 40 04             	mov    0x4(%eax),%eax
  803009:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80300e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803011:	8b 40 04             	mov    0x4(%eax),%eax
  803014:	85 c0                	test   %eax,%eax
  803016:	74 0f                	je     803027 <alloc_block+0x1d6>
  803018:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80301b:	8b 40 04             	mov    0x4(%eax),%eax
  80301e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803021:	8b 12                	mov    (%edx),%edx
  803023:	89 10                	mov    %edx,(%eax)
  803025:	eb 0a                	jmp    803031 <alloc_block+0x1e0>
  803027:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80302a:	8b 00                	mov    (%eax),%eax
  80302c:	a3 48 50 80 00       	mov    %eax,0x805048
  803031:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803034:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80303a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80303d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803044:	a1 54 50 80 00       	mov    0x805054,%eax
  803049:	48                   	dec    %eax
  80304a:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  80304f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803052:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803055:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  803059:	b8 00 10 00 00       	mov    $0x1000,%eax
  80305e:	99                   	cltd   
  80305f:	f7 7d e8             	idivl  -0x18(%ebp)
  803062:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803065:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  803069:	83 ec 0c             	sub    $0xc,%esp
  80306c:	ff 75 dc             	pushl  -0x24(%ebp)
  80306f:	e8 ce fa ff ff       	call   802b42 <to_page_va>
  803074:	83 c4 10             	add    $0x10,%esp
  803077:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  80307a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80307d:	83 ec 0c             	sub    $0xc,%esp
  803080:	50                   	push   %eax
  803081:	e8 c0 ee ff ff       	call   801f46 <get_page>
  803086:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  803089:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803090:	e9 aa 00 00 00       	jmp    80313f <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  803095:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803098:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  80309c:	89 c2                	mov    %eax,%edx
  80309e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030a1:	01 d0                	add    %edx,%eax
  8030a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  8030a6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8030aa:	75 17                	jne    8030c3 <alloc_block+0x272>
  8030ac:	83 ec 04             	sub    $0x4,%esp
  8030af:	68 84 4c 80 00       	push   $0x804c84
  8030b4:	68 aa 00 00 00       	push   $0xaa
  8030b9:	68 cb 4b 80 00       	push   $0x804bcb
  8030be:	e8 f9 d5 ff ff       	call   8006bc <_panic>
  8030c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030c6:	c1 e0 04             	shl    $0x4,%eax
  8030c9:	05 84 d0 81 00       	add    $0x81d084,%eax
  8030ce:	8b 10                	mov    (%eax),%edx
  8030d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8030d3:	89 50 04             	mov    %edx,0x4(%eax)
  8030d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8030d9:	8b 40 04             	mov    0x4(%eax),%eax
  8030dc:	85 c0                	test   %eax,%eax
  8030de:	74 14                	je     8030f4 <alloc_block+0x2a3>
  8030e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030e3:	c1 e0 04             	shl    $0x4,%eax
  8030e6:	05 84 d0 81 00       	add    $0x81d084,%eax
  8030eb:	8b 00                	mov    (%eax),%eax
  8030ed:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8030f0:	89 10                	mov    %edx,(%eax)
  8030f2:	eb 11                	jmp    803105 <alloc_block+0x2b4>
  8030f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030f7:	c1 e0 04             	shl    $0x4,%eax
  8030fa:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803100:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803103:	89 02                	mov    %eax,(%edx)
  803105:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803108:	c1 e0 04             	shl    $0x4,%eax
  80310b:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803111:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803114:	89 02                	mov    %eax,(%edx)
  803116:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803119:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80311f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803122:	c1 e0 04             	shl    $0x4,%eax
  803125:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80312a:	8b 00                	mov    (%eax),%eax
  80312c:	8d 50 01             	lea    0x1(%eax),%edx
  80312f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803132:	c1 e0 04             	shl    $0x4,%eax
  803135:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80313a:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  80313c:	ff 45 f4             	incl   -0xc(%ebp)
  80313f:	b8 00 10 00 00       	mov    $0x1000,%eax
  803144:	99                   	cltd   
  803145:	f7 7d e8             	idivl  -0x18(%ebp)
  803148:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80314b:	0f 8f 44 ff ff ff    	jg     803095 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803151:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803154:	c1 e0 04             	shl    $0x4,%eax
  803157:	05 80 d0 81 00       	add    $0x81d080,%eax
  80315c:	8b 00                	mov    (%eax),%eax
  80315e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803161:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803165:	75 17                	jne    80317e <alloc_block+0x32d>
  803167:	83 ec 04             	sub    $0x4,%esp
  80316a:	68 65 4c 80 00       	push   $0x804c65
  80316f:	68 ae 00 00 00       	push   $0xae
  803174:	68 cb 4b 80 00       	push   $0x804bcb
  803179:	e8 3e d5 ff ff       	call   8006bc <_panic>
  80317e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803181:	8b 00                	mov    (%eax),%eax
  803183:	85 c0                	test   %eax,%eax
  803185:	74 10                	je     803197 <alloc_block+0x346>
  803187:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80318a:	8b 00                	mov    (%eax),%eax
  80318c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80318f:	8b 52 04             	mov    0x4(%edx),%edx
  803192:	89 50 04             	mov    %edx,0x4(%eax)
  803195:	eb 14                	jmp    8031ab <alloc_block+0x35a>
  803197:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80319a:	8b 40 04             	mov    0x4(%eax),%eax
  80319d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031a0:	c1 e2 04             	shl    $0x4,%edx
  8031a3:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8031a9:	89 02                	mov    %eax,(%edx)
  8031ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031ae:	8b 40 04             	mov    0x4(%eax),%eax
  8031b1:	85 c0                	test   %eax,%eax
  8031b3:	74 0f                	je     8031c4 <alloc_block+0x373>
  8031b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031b8:	8b 40 04             	mov    0x4(%eax),%eax
  8031bb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8031be:	8b 12                	mov    (%edx),%edx
  8031c0:	89 10                	mov    %edx,(%eax)
  8031c2:	eb 13                	jmp    8031d7 <alloc_block+0x386>
  8031c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031c7:	8b 00                	mov    (%eax),%eax
  8031c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031cc:	c1 e2 04             	shl    $0x4,%edx
  8031cf:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8031d5:	89 02                	mov    %eax,(%edx)
  8031d7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ed:	c1 e0 04             	shl    $0x4,%eax
  8031f0:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8031f5:	8b 00                	mov    (%eax),%eax
  8031f7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8031fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031fd:	c1 e0 04             	shl    $0x4,%eax
  803200:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803205:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803207:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80320a:	83 ec 0c             	sub    $0xc,%esp
  80320d:	50                   	push   %eax
  80320e:	e8 a1 f9 ff ff       	call   802bb4 <to_page_info>
  803213:	83 c4 10             	add    $0x10,%esp
  803216:	89 c2                	mov    %eax,%edx
  803218:	66 8b 42 0a          	mov    0xa(%edx),%ax
  80321c:	48                   	dec    %eax
  80321d:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  803221:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803224:	e9 1a 01 00 00       	jmp    803343 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  803229:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80322c:	40                   	inc    %eax
  80322d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803230:	e9 ed 00 00 00       	jmp    803322 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  803235:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803238:	c1 e0 04             	shl    $0x4,%eax
  80323b:	05 80 d0 81 00       	add    $0x81d080,%eax
  803240:	8b 00                	mov    (%eax),%eax
  803242:	85 c0                	test   %eax,%eax
  803244:	0f 84 d5 00 00 00    	je     80331f <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  80324a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324d:	c1 e0 04             	shl    $0x4,%eax
  803250:	05 80 d0 81 00       	add    $0x81d080,%eax
  803255:	8b 00                	mov    (%eax),%eax
  803257:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  80325a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80325e:	75 17                	jne    803277 <alloc_block+0x426>
  803260:	83 ec 04             	sub    $0x4,%esp
  803263:	68 65 4c 80 00       	push   $0x804c65
  803268:	68 b8 00 00 00       	push   $0xb8
  80326d:	68 cb 4b 80 00       	push   $0x804bcb
  803272:	e8 45 d4 ff ff       	call   8006bc <_panic>
  803277:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80327a:	8b 00                	mov    (%eax),%eax
  80327c:	85 c0                	test   %eax,%eax
  80327e:	74 10                	je     803290 <alloc_block+0x43f>
  803280:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803283:	8b 00                	mov    (%eax),%eax
  803285:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803288:	8b 52 04             	mov    0x4(%edx),%edx
  80328b:	89 50 04             	mov    %edx,0x4(%eax)
  80328e:	eb 14                	jmp    8032a4 <alloc_block+0x453>
  803290:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803293:	8b 40 04             	mov    0x4(%eax),%eax
  803296:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803299:	c1 e2 04             	shl    $0x4,%edx
  80329c:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8032a2:	89 02                	mov    %eax,(%edx)
  8032a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032a7:	8b 40 04             	mov    0x4(%eax),%eax
  8032aa:	85 c0                	test   %eax,%eax
  8032ac:	74 0f                	je     8032bd <alloc_block+0x46c>
  8032ae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032b1:	8b 40 04             	mov    0x4(%eax),%eax
  8032b4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8032b7:	8b 12                	mov    (%edx),%edx
  8032b9:	89 10                	mov    %edx,(%eax)
  8032bb:	eb 13                	jmp    8032d0 <alloc_block+0x47f>
  8032bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032c0:	8b 00                	mov    (%eax),%eax
  8032c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032c5:	c1 e2 04             	shl    $0x4,%edx
  8032c8:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8032ce:	89 02                	mov    %eax,(%edx)
  8032d0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032d9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e6:	c1 e0 04             	shl    $0x4,%eax
  8032e9:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8032ee:	8b 00                	mov    (%eax),%eax
  8032f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8032f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f6:	c1 e0 04             	shl    $0x4,%eax
  8032f9:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8032fe:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  803300:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803303:	83 ec 0c             	sub    $0xc,%esp
  803306:	50                   	push   %eax
  803307:	e8 a8 f8 ff ff       	call   802bb4 <to_page_info>
  80330c:	83 c4 10             	add    $0x10,%esp
  80330f:	89 c2                	mov    %eax,%edx
  803311:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803315:	48                   	dec    %eax
  803316:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  80331a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80331d:	eb 24                	jmp    803343 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  80331f:	ff 45 f0             	incl   -0x10(%ebp)
  803322:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  803326:	0f 8e 09 ff ff ff    	jle    803235 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  80332c:	83 ec 04             	sub    $0x4,%esp
  80332f:	68 a7 4c 80 00       	push   $0x804ca7
  803334:	68 bf 00 00 00       	push   $0xbf
  803339:	68 cb 4b 80 00       	push   $0x804bcb
  80333e:	e8 79 d3 ff ff       	call   8006bc <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803343:	c9                   	leave  
  803344:	c3                   	ret    

00803345 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  803345:	55                   	push   %ebp
  803346:	89 e5                	mov    %esp,%ebp
  803348:	83 ec 14             	sub    $0x14,%esp
  80334b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  80334e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803352:	75 07                	jne    80335b <log2_ceil.1520+0x16>
  803354:	b8 00 00 00 00       	mov    $0x0,%eax
  803359:	eb 1b                	jmp    803376 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  80335b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  803362:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  803365:	eb 06                	jmp    80336d <log2_ceil.1520+0x28>
            x >>= 1;
  803367:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  80336a:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  80336d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803371:	75 f4                	jne    803367 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  803373:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803376:	c9                   	leave  
  803377:	c3                   	ret    

00803378 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  803378:	55                   	push   %ebp
  803379:	89 e5                	mov    %esp,%ebp
  80337b:	83 ec 14             	sub    $0x14,%esp
  80337e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  803381:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803385:	75 07                	jne    80338e <log2_ceil.1547+0x16>
  803387:	b8 00 00 00 00       	mov    $0x0,%eax
  80338c:	eb 1b                	jmp    8033a9 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  80338e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  803395:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  803398:	eb 06                	jmp    8033a0 <log2_ceil.1547+0x28>
			x >>= 1;
  80339a:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  80339d:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  8033a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033a4:	75 f4                	jne    80339a <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  8033a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  8033a9:	c9                   	leave  
  8033aa:	c3                   	ret    

008033ab <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8033ab:	55                   	push   %ebp
  8033ac:	89 e5                	mov    %esp,%ebp
  8033ae:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8033b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8033b4:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8033b9:	39 c2                	cmp    %eax,%edx
  8033bb:	72 0c                	jb     8033c9 <free_block+0x1e>
  8033bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c0:	a1 40 50 80 00       	mov    0x805040,%eax
  8033c5:	39 c2                	cmp    %eax,%edx
  8033c7:	72 19                	jb     8033e2 <free_block+0x37>
  8033c9:	68 ac 4c 80 00       	push   $0x804cac
  8033ce:	68 2e 4c 80 00       	push   $0x804c2e
  8033d3:	68 d0 00 00 00       	push   $0xd0
  8033d8:	68 cb 4b 80 00       	push   $0x804bcb
  8033dd:	e8 da d2 ff ff       	call   8006bc <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8033e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033e6:	0f 84 42 03 00 00    	je     80372e <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  8033ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ef:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8033f4:	39 c2                	cmp    %eax,%edx
  8033f6:	72 0c                	jb     803404 <free_block+0x59>
  8033f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8033fb:	a1 40 50 80 00       	mov    0x805040,%eax
  803400:	39 c2                	cmp    %eax,%edx
  803402:	72 17                	jb     80341b <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  803404:	83 ec 04             	sub    $0x4,%esp
  803407:	68 e4 4c 80 00       	push   $0x804ce4
  80340c:	68 e6 00 00 00       	push   $0xe6
  803411:	68 cb 4b 80 00       	push   $0x804bcb
  803416:	e8 a1 d2 ff ff       	call   8006bc <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  80341b:	8b 55 08             	mov    0x8(%ebp),%edx
  80341e:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803423:	29 c2                	sub    %eax,%edx
  803425:	89 d0                	mov    %edx,%eax
  803427:	83 e0 07             	and    $0x7,%eax
  80342a:	85 c0                	test   %eax,%eax
  80342c:	74 17                	je     803445 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  80342e:	83 ec 04             	sub    $0x4,%esp
  803431:	68 18 4d 80 00       	push   $0x804d18
  803436:	68 ea 00 00 00       	push   $0xea
  80343b:	68 cb 4b 80 00       	push   $0x804bcb
  803440:	e8 77 d2 ff ff       	call   8006bc <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  803445:	8b 45 08             	mov    0x8(%ebp),%eax
  803448:	83 ec 0c             	sub    $0xc,%esp
  80344b:	50                   	push   %eax
  80344c:	e8 63 f7 ff ff       	call   802bb4 <to_page_info>
  803451:	83 c4 10             	add    $0x10,%esp
  803454:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  803457:	83 ec 0c             	sub    $0xc,%esp
  80345a:	ff 75 08             	pushl  0x8(%ebp)
  80345d:	e8 87 f9 ff ff       	call   802de9 <get_block_size>
  803462:	83 c4 10             	add    $0x10,%esp
  803465:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  803468:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80346c:	75 17                	jne    803485 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  80346e:	83 ec 04             	sub    $0x4,%esp
  803471:	68 44 4d 80 00       	push   $0x804d44
  803476:	68 f1 00 00 00       	push   $0xf1
  80347b:	68 cb 4b 80 00       	push   $0x804bcb
  803480:	e8 37 d2 ff ff       	call   8006bc <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  803485:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803488:	83 ec 0c             	sub    $0xc,%esp
  80348b:	8d 45 d0             	lea    -0x30(%ebp),%eax
  80348e:	52                   	push   %edx
  80348f:	89 c1                	mov    %eax,%ecx
  803491:	e8 e2 fe ff ff       	call   803378 <log2_ceil.1547>
  803496:	83 c4 10             	add    $0x10,%esp
  803499:	83 e8 03             	sub    $0x3,%eax
  80349c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  80349f:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  8034a5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8034a9:	75 17                	jne    8034c2 <free_block+0x117>
  8034ab:	83 ec 04             	sub    $0x4,%esp
  8034ae:	68 90 4d 80 00       	push   $0x804d90
  8034b3:	68 f6 00 00 00       	push   $0xf6
  8034b8:	68 cb 4b 80 00       	push   $0x804bcb
  8034bd:	e8 fa d1 ff ff       	call   8006bc <_panic>
  8034c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c5:	c1 e0 04             	shl    $0x4,%eax
  8034c8:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034cd:	8b 10                	mov    (%eax),%edx
  8034cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034d2:	89 10                	mov    %edx,(%eax)
  8034d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034d7:	8b 00                	mov    (%eax),%eax
  8034d9:	85 c0                	test   %eax,%eax
  8034db:	74 15                	je     8034f2 <free_block+0x147>
  8034dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e0:	c1 e0 04             	shl    $0x4,%eax
  8034e3:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034e8:	8b 00                	mov    (%eax),%eax
  8034ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034ed:	89 50 04             	mov    %edx,0x4(%eax)
  8034f0:	eb 11                	jmp    803503 <free_block+0x158>
  8034f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f5:	c1 e0 04             	shl    $0x4,%eax
  8034f8:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  8034fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803501:	89 02                	mov    %eax,(%edx)
  803503:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803506:	c1 e0 04             	shl    $0x4,%eax
  803509:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  80350f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803512:	89 02                	mov    %eax,(%edx)
  803514:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803517:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80351e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803521:	c1 e0 04             	shl    $0x4,%eax
  803524:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803529:	8b 00                	mov    (%eax),%eax
  80352b:	8d 50 01             	lea    0x1(%eax),%edx
  80352e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803531:	c1 e0 04             	shl    $0x4,%eax
  803534:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803539:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  80353b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80353e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803542:	40                   	inc    %eax
  803543:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803546:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  80354a:	8b 55 08             	mov    0x8(%ebp),%edx
  80354d:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803552:	29 c2                	sub    %eax,%edx
  803554:	89 d0                	mov    %edx,%eax
  803556:	c1 e8 0c             	shr    $0xc,%eax
  803559:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  80355c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80355f:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803563:	0f b7 c8             	movzwl %ax,%ecx
  803566:	b8 00 10 00 00       	mov    $0x1000,%eax
  80356b:	99                   	cltd   
  80356c:	f7 7d e8             	idivl  -0x18(%ebp)
  80356f:	39 c1                	cmp    %eax,%ecx
  803571:	0f 85 b8 01 00 00    	jne    80372f <free_block+0x384>
    	uint32 blocks_removed = 0;
  803577:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  80357e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803581:	c1 e0 04             	shl    $0x4,%eax
  803584:	05 80 d0 81 00       	add    $0x81d080,%eax
  803589:	8b 00                	mov    (%eax),%eax
  80358b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  80358e:	e9 d5 00 00 00       	jmp    803668 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  803593:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803596:	8b 00                	mov    (%eax),%eax
  803598:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  80359b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80359e:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8035a3:	29 c2                	sub    %eax,%edx
  8035a5:	89 d0                	mov    %edx,%eax
  8035a7:	c1 e8 0c             	shr    $0xc,%eax
  8035aa:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  8035ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8035b3:	0f 85 a9 00 00 00    	jne    803662 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  8035b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035bd:	75 17                	jne    8035d6 <free_block+0x22b>
  8035bf:	83 ec 04             	sub    $0x4,%esp
  8035c2:	68 65 4c 80 00       	push   $0x804c65
  8035c7:	68 04 01 00 00       	push   $0x104
  8035cc:	68 cb 4b 80 00       	push   $0x804bcb
  8035d1:	e8 e6 d0 ff ff       	call   8006bc <_panic>
  8035d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035d9:	8b 00                	mov    (%eax),%eax
  8035db:	85 c0                	test   %eax,%eax
  8035dd:	74 10                	je     8035ef <free_block+0x244>
  8035df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e2:	8b 00                	mov    (%eax),%eax
  8035e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035e7:	8b 52 04             	mov    0x4(%edx),%edx
  8035ea:	89 50 04             	mov    %edx,0x4(%eax)
  8035ed:	eb 14                	jmp    803603 <free_block+0x258>
  8035ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f2:	8b 40 04             	mov    0x4(%eax),%eax
  8035f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035f8:	c1 e2 04             	shl    $0x4,%edx
  8035fb:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803601:	89 02                	mov    %eax,(%edx)
  803603:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803606:	8b 40 04             	mov    0x4(%eax),%eax
  803609:	85 c0                	test   %eax,%eax
  80360b:	74 0f                	je     80361c <free_block+0x271>
  80360d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803610:	8b 40 04             	mov    0x4(%eax),%eax
  803613:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803616:	8b 12                	mov    (%edx),%edx
  803618:	89 10                	mov    %edx,(%eax)
  80361a:	eb 13                	jmp    80362f <free_block+0x284>
  80361c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80361f:	8b 00                	mov    (%eax),%eax
  803621:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803624:	c1 e2 04             	shl    $0x4,%edx
  803627:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  80362d:	89 02                	mov    %eax,(%edx)
  80362f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803632:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803638:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80363b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803642:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803645:	c1 e0 04             	shl    $0x4,%eax
  803648:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80364d:	8b 00                	mov    (%eax),%eax
  80364f:	8d 50 ff             	lea    -0x1(%eax),%edx
  803652:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803655:	c1 e0 04             	shl    $0x4,%eax
  803658:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80365d:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  80365f:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  803662:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803665:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803668:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80366c:	0f 85 21 ff ff ff    	jne    803593 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  803672:	b8 00 10 00 00       	mov    $0x1000,%eax
  803677:	99                   	cltd   
  803678:	f7 7d e8             	idivl  -0x18(%ebp)
  80367b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80367e:	74 17                	je     803697 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  803680:	83 ec 04             	sub    $0x4,%esp
  803683:	68 b4 4d 80 00       	push   $0x804db4
  803688:	68 0c 01 00 00       	push   $0x10c
  80368d:	68 cb 4b 80 00       	push   $0x804bcb
  803692:	e8 25 d0 ff ff       	call   8006bc <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  803697:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80369a:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  8036a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036a3:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  8036a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8036ad:	75 17                	jne    8036c6 <free_block+0x31b>
  8036af:	83 ec 04             	sub    $0x4,%esp
  8036b2:	68 84 4c 80 00       	push   $0x804c84
  8036b7:	68 11 01 00 00       	push   $0x111
  8036bc:	68 cb 4b 80 00       	push   $0x804bcb
  8036c1:	e8 f6 cf ff ff       	call   8006bc <_panic>
  8036c6:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  8036cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036cf:	89 50 04             	mov    %edx,0x4(%eax)
  8036d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036d5:	8b 40 04             	mov    0x4(%eax),%eax
  8036d8:	85 c0                	test   %eax,%eax
  8036da:	74 0c                	je     8036e8 <free_block+0x33d>
  8036dc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8036e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036e4:	89 10                	mov    %edx,(%eax)
  8036e6:	eb 08                	jmp    8036f0 <free_block+0x345>
  8036e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036eb:	a3 48 50 80 00       	mov    %eax,0x805048
  8036f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036f3:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8036f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803701:	a1 54 50 80 00       	mov    0x805054,%eax
  803706:	40                   	inc    %eax
  803707:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  80370c:	83 ec 0c             	sub    $0xc,%esp
  80370f:	ff 75 ec             	pushl  -0x14(%ebp)
  803712:	e8 2b f4 ff ff       	call   802b42 <to_page_va>
  803717:	83 c4 10             	add    $0x10,%esp
  80371a:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  80371d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803720:	83 ec 0c             	sub    $0xc,%esp
  803723:	50                   	push   %eax
  803724:	e8 69 e8 ff ff       	call   801f92 <return_page>
  803729:	83 c4 10             	add    $0x10,%esp
  80372c:	eb 01                	jmp    80372f <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  80372e:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  80372f:	c9                   	leave  
  803730:	c3                   	ret    

00803731 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803731:	55                   	push   %ebp
  803732:	89 e5                	mov    %esp,%ebp
  803734:	83 ec 14             	sub    $0x14,%esp
  803737:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  80373a:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80373e:	77 07                	ja     803747 <nearest_pow2_ceil.1572+0x16>
      return 1;
  803740:	b8 01 00 00 00       	mov    $0x1,%eax
  803745:	eb 20                	jmp    803767 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  803747:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  80374e:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  803751:	eb 08                	jmp    80375b <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  803753:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803756:	01 c0                	add    %eax,%eax
  803758:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  80375b:	d1 6d 08             	shrl   0x8(%ebp)
  80375e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803762:	75 ef                	jne    803753 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  803764:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  803767:	c9                   	leave  
  803768:	c3                   	ret    

00803769 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  803769:	55                   	push   %ebp
  80376a:	89 e5                	mov    %esp,%ebp
  80376c:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  80376f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803773:	75 13                	jne    803788 <realloc_block+0x1f>
    return alloc_block(new_size);
  803775:	83 ec 0c             	sub    $0xc,%esp
  803778:	ff 75 0c             	pushl  0xc(%ebp)
  80377b:	e8 d1 f6 ff ff       	call   802e51 <alloc_block>
  803780:	83 c4 10             	add    $0x10,%esp
  803783:	e9 d9 00 00 00       	jmp    803861 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  803788:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80378c:	75 18                	jne    8037a6 <realloc_block+0x3d>
    free_block(va);
  80378e:	83 ec 0c             	sub    $0xc,%esp
  803791:	ff 75 08             	pushl  0x8(%ebp)
  803794:	e8 12 fc ff ff       	call   8033ab <free_block>
  803799:	83 c4 10             	add    $0x10,%esp
    return NULL;
  80379c:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a1:	e9 bb 00 00 00       	jmp    803861 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  8037a6:	83 ec 0c             	sub    $0xc,%esp
  8037a9:	ff 75 08             	pushl  0x8(%ebp)
  8037ac:	e8 38 f6 ff ff       	call   802de9 <get_block_size>
  8037b1:	83 c4 10             	add    $0x10,%esp
  8037b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  8037b7:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  8037be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037c1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8037c4:	73 06                	jae    8037cc <realloc_block+0x63>
    new_size = min_block_size;
  8037c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037c9:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  8037cc:	83 ec 0c             	sub    $0xc,%esp
  8037cf:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8037d2:	ff 75 0c             	pushl  0xc(%ebp)
  8037d5:	89 c1                	mov    %eax,%ecx
  8037d7:	e8 55 ff ff ff       	call   803731 <nearest_pow2_ceil.1572>
  8037dc:	83 c4 10             	add    $0x10,%esp
  8037df:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  8037e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8037e8:	75 05                	jne    8037ef <realloc_block+0x86>
    return va;
  8037ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ed:	eb 72                	jmp    803861 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  8037ef:	83 ec 0c             	sub    $0xc,%esp
  8037f2:	ff 75 0c             	pushl  0xc(%ebp)
  8037f5:	e8 57 f6 ff ff       	call   802e51 <alloc_block>
  8037fa:	83 c4 10             	add    $0x10,%esp
  8037fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  803800:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803804:	75 07                	jne    80380d <realloc_block+0xa4>
    return NULL;
  803806:	b8 00 00 00 00       	mov    $0x0,%eax
  80380b:	eb 54                	jmp    803861 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  80380d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803810:	8b 45 0c             	mov    0xc(%ebp),%eax
  803813:	39 d0                	cmp    %edx,%eax
  803815:	76 02                	jbe    803819 <realloc_block+0xb0>
  803817:	89 d0                	mov    %edx,%eax
  803819:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  80381c:	8b 45 08             	mov    0x8(%ebp),%eax
  80381f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  803822:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803825:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  803828:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80382f:	eb 17                	jmp    803848 <realloc_block+0xdf>
    dst[i] = src[i];
  803831:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803837:	01 c2                	add    %eax,%edx
  803839:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80383c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383f:	01 c8                	add    %ecx,%eax
  803841:	8a 00                	mov    (%eax),%al
  803843:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  803845:	ff 45 f4             	incl   -0xc(%ebp)
  803848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80384e:	72 e1                	jb     803831 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  803850:	83 ec 0c             	sub    $0xc,%esp
  803853:	ff 75 08             	pushl  0x8(%ebp)
  803856:	e8 50 fb ff ff       	call   8033ab <free_block>
  80385b:	83 c4 10             	add    $0x10,%esp

  return new_va;
  80385e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  803861:	c9                   	leave  
  803862:	c3                   	ret    

00803863 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803863:	55                   	push   %ebp
  803864:	89 e5                	mov    %esp,%ebp
  803866:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803869:	8b 55 08             	mov    0x8(%ebp),%edx
  80386c:	89 d0                	mov    %edx,%eax
  80386e:	c1 e0 02             	shl    $0x2,%eax
  803871:	01 d0                	add    %edx,%eax
  803873:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80387a:	01 d0                	add    %edx,%eax
  80387c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803883:	01 d0                	add    %edx,%eax
  803885:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80388c:	01 d0                	add    %edx,%eax
  80388e:	c1 e0 04             	shl    $0x4,%eax
  803891:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  803894:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  80389b:	0f 31                	rdtsc  
  80389d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8038a0:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8038a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8038ac:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8038af:	eb 46                	jmp    8038f7 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8038b1:	0f 31                	rdtsc  
  8038b3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8038b6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8038b9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8038bc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8038bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8038c2:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8038c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038cb:	29 c2                	sub    %eax,%edx
  8038cd:	89 d0                	mov    %edx,%eax
  8038cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8038d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d8:	89 d1                	mov    %edx,%ecx
  8038da:	29 c1                	sub    %eax,%ecx
  8038dc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8038df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038e2:	39 c2                	cmp    %eax,%edx
  8038e4:	0f 97 c0             	seta   %al
  8038e7:	0f b6 c0             	movzbl %al,%eax
  8038ea:	29 c1                	sub    %eax,%ecx
  8038ec:	89 c8                	mov    %ecx,%eax
  8038ee:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8038f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8038f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8038f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8038fa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8038fd:	72 b2                	jb     8038b1 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8038ff:	90                   	nop
  803900:	c9                   	leave  
  803901:	c3                   	ret    

00803902 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803902:	55                   	push   %ebp
  803903:	89 e5                	mov    %esp,%ebp
  803905:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803908:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80390f:	eb 03                	jmp    803914 <busy_wait+0x12>
  803911:	ff 45 fc             	incl   -0x4(%ebp)
  803914:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803917:	3b 45 08             	cmp    0x8(%ebp),%eax
  80391a:	72 f5                	jb     803911 <busy_wait+0xf>
	return i;
  80391c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80391f:	c9                   	leave  
  803920:	c3                   	ret    
  803921:	66 90                	xchg   %ax,%ax
  803923:	90                   	nop

00803924 <__udivdi3>:
  803924:	55                   	push   %ebp
  803925:	57                   	push   %edi
  803926:	56                   	push   %esi
  803927:	53                   	push   %ebx
  803928:	83 ec 1c             	sub    $0x1c,%esp
  80392b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80392f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803933:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803937:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80393b:	89 ca                	mov    %ecx,%edx
  80393d:	89 f8                	mov    %edi,%eax
  80393f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803943:	85 f6                	test   %esi,%esi
  803945:	75 2d                	jne    803974 <__udivdi3+0x50>
  803947:	39 cf                	cmp    %ecx,%edi
  803949:	77 65                	ja     8039b0 <__udivdi3+0x8c>
  80394b:	89 fd                	mov    %edi,%ebp
  80394d:	85 ff                	test   %edi,%edi
  80394f:	75 0b                	jne    80395c <__udivdi3+0x38>
  803951:	b8 01 00 00 00       	mov    $0x1,%eax
  803956:	31 d2                	xor    %edx,%edx
  803958:	f7 f7                	div    %edi
  80395a:	89 c5                	mov    %eax,%ebp
  80395c:	31 d2                	xor    %edx,%edx
  80395e:	89 c8                	mov    %ecx,%eax
  803960:	f7 f5                	div    %ebp
  803962:	89 c1                	mov    %eax,%ecx
  803964:	89 d8                	mov    %ebx,%eax
  803966:	f7 f5                	div    %ebp
  803968:	89 cf                	mov    %ecx,%edi
  80396a:	89 fa                	mov    %edi,%edx
  80396c:	83 c4 1c             	add    $0x1c,%esp
  80396f:	5b                   	pop    %ebx
  803970:	5e                   	pop    %esi
  803971:	5f                   	pop    %edi
  803972:	5d                   	pop    %ebp
  803973:	c3                   	ret    
  803974:	39 ce                	cmp    %ecx,%esi
  803976:	77 28                	ja     8039a0 <__udivdi3+0x7c>
  803978:	0f bd fe             	bsr    %esi,%edi
  80397b:	83 f7 1f             	xor    $0x1f,%edi
  80397e:	75 40                	jne    8039c0 <__udivdi3+0x9c>
  803980:	39 ce                	cmp    %ecx,%esi
  803982:	72 0a                	jb     80398e <__udivdi3+0x6a>
  803984:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803988:	0f 87 9e 00 00 00    	ja     803a2c <__udivdi3+0x108>
  80398e:	b8 01 00 00 00       	mov    $0x1,%eax
  803993:	89 fa                	mov    %edi,%edx
  803995:	83 c4 1c             	add    $0x1c,%esp
  803998:	5b                   	pop    %ebx
  803999:	5e                   	pop    %esi
  80399a:	5f                   	pop    %edi
  80399b:	5d                   	pop    %ebp
  80399c:	c3                   	ret    
  80399d:	8d 76 00             	lea    0x0(%esi),%esi
  8039a0:	31 ff                	xor    %edi,%edi
  8039a2:	31 c0                	xor    %eax,%eax
  8039a4:	89 fa                	mov    %edi,%edx
  8039a6:	83 c4 1c             	add    $0x1c,%esp
  8039a9:	5b                   	pop    %ebx
  8039aa:	5e                   	pop    %esi
  8039ab:	5f                   	pop    %edi
  8039ac:	5d                   	pop    %ebp
  8039ad:	c3                   	ret    
  8039ae:	66 90                	xchg   %ax,%ax
  8039b0:	89 d8                	mov    %ebx,%eax
  8039b2:	f7 f7                	div    %edi
  8039b4:	31 ff                	xor    %edi,%edi
  8039b6:	89 fa                	mov    %edi,%edx
  8039b8:	83 c4 1c             	add    $0x1c,%esp
  8039bb:	5b                   	pop    %ebx
  8039bc:	5e                   	pop    %esi
  8039bd:	5f                   	pop    %edi
  8039be:	5d                   	pop    %ebp
  8039bf:	c3                   	ret    
  8039c0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8039c5:	89 eb                	mov    %ebp,%ebx
  8039c7:	29 fb                	sub    %edi,%ebx
  8039c9:	89 f9                	mov    %edi,%ecx
  8039cb:	d3 e6                	shl    %cl,%esi
  8039cd:	89 c5                	mov    %eax,%ebp
  8039cf:	88 d9                	mov    %bl,%cl
  8039d1:	d3 ed                	shr    %cl,%ebp
  8039d3:	89 e9                	mov    %ebp,%ecx
  8039d5:	09 f1                	or     %esi,%ecx
  8039d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8039db:	89 f9                	mov    %edi,%ecx
  8039dd:	d3 e0                	shl    %cl,%eax
  8039df:	89 c5                	mov    %eax,%ebp
  8039e1:	89 d6                	mov    %edx,%esi
  8039e3:	88 d9                	mov    %bl,%cl
  8039e5:	d3 ee                	shr    %cl,%esi
  8039e7:	89 f9                	mov    %edi,%ecx
  8039e9:	d3 e2                	shl    %cl,%edx
  8039eb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039ef:	88 d9                	mov    %bl,%cl
  8039f1:	d3 e8                	shr    %cl,%eax
  8039f3:	09 c2                	or     %eax,%edx
  8039f5:	89 d0                	mov    %edx,%eax
  8039f7:	89 f2                	mov    %esi,%edx
  8039f9:	f7 74 24 0c          	divl   0xc(%esp)
  8039fd:	89 d6                	mov    %edx,%esi
  8039ff:	89 c3                	mov    %eax,%ebx
  803a01:	f7 e5                	mul    %ebp
  803a03:	39 d6                	cmp    %edx,%esi
  803a05:	72 19                	jb     803a20 <__udivdi3+0xfc>
  803a07:	74 0b                	je     803a14 <__udivdi3+0xf0>
  803a09:	89 d8                	mov    %ebx,%eax
  803a0b:	31 ff                	xor    %edi,%edi
  803a0d:	e9 58 ff ff ff       	jmp    80396a <__udivdi3+0x46>
  803a12:	66 90                	xchg   %ax,%ax
  803a14:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a18:	89 f9                	mov    %edi,%ecx
  803a1a:	d3 e2                	shl    %cl,%edx
  803a1c:	39 c2                	cmp    %eax,%edx
  803a1e:	73 e9                	jae    803a09 <__udivdi3+0xe5>
  803a20:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a23:	31 ff                	xor    %edi,%edi
  803a25:	e9 40 ff ff ff       	jmp    80396a <__udivdi3+0x46>
  803a2a:	66 90                	xchg   %ax,%ax
  803a2c:	31 c0                	xor    %eax,%eax
  803a2e:	e9 37 ff ff ff       	jmp    80396a <__udivdi3+0x46>
  803a33:	90                   	nop

00803a34 <__umoddi3>:
  803a34:	55                   	push   %ebp
  803a35:	57                   	push   %edi
  803a36:	56                   	push   %esi
  803a37:	53                   	push   %ebx
  803a38:	83 ec 1c             	sub    $0x1c,%esp
  803a3b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a3f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a47:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a4b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a4f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a53:	89 f3                	mov    %esi,%ebx
  803a55:	89 fa                	mov    %edi,%edx
  803a57:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a5b:	89 34 24             	mov    %esi,(%esp)
  803a5e:	85 c0                	test   %eax,%eax
  803a60:	75 1a                	jne    803a7c <__umoddi3+0x48>
  803a62:	39 f7                	cmp    %esi,%edi
  803a64:	0f 86 a2 00 00 00    	jbe    803b0c <__umoddi3+0xd8>
  803a6a:	89 c8                	mov    %ecx,%eax
  803a6c:	89 f2                	mov    %esi,%edx
  803a6e:	f7 f7                	div    %edi
  803a70:	89 d0                	mov    %edx,%eax
  803a72:	31 d2                	xor    %edx,%edx
  803a74:	83 c4 1c             	add    $0x1c,%esp
  803a77:	5b                   	pop    %ebx
  803a78:	5e                   	pop    %esi
  803a79:	5f                   	pop    %edi
  803a7a:	5d                   	pop    %ebp
  803a7b:	c3                   	ret    
  803a7c:	39 f0                	cmp    %esi,%eax
  803a7e:	0f 87 ac 00 00 00    	ja     803b30 <__umoddi3+0xfc>
  803a84:	0f bd e8             	bsr    %eax,%ebp
  803a87:	83 f5 1f             	xor    $0x1f,%ebp
  803a8a:	0f 84 ac 00 00 00    	je     803b3c <__umoddi3+0x108>
  803a90:	bf 20 00 00 00       	mov    $0x20,%edi
  803a95:	29 ef                	sub    %ebp,%edi
  803a97:	89 fe                	mov    %edi,%esi
  803a99:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a9d:	89 e9                	mov    %ebp,%ecx
  803a9f:	d3 e0                	shl    %cl,%eax
  803aa1:	89 d7                	mov    %edx,%edi
  803aa3:	89 f1                	mov    %esi,%ecx
  803aa5:	d3 ef                	shr    %cl,%edi
  803aa7:	09 c7                	or     %eax,%edi
  803aa9:	89 e9                	mov    %ebp,%ecx
  803aab:	d3 e2                	shl    %cl,%edx
  803aad:	89 14 24             	mov    %edx,(%esp)
  803ab0:	89 d8                	mov    %ebx,%eax
  803ab2:	d3 e0                	shl    %cl,%eax
  803ab4:	89 c2                	mov    %eax,%edx
  803ab6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aba:	d3 e0                	shl    %cl,%eax
  803abc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ac0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ac4:	89 f1                	mov    %esi,%ecx
  803ac6:	d3 e8                	shr    %cl,%eax
  803ac8:	09 d0                	or     %edx,%eax
  803aca:	d3 eb                	shr    %cl,%ebx
  803acc:	89 da                	mov    %ebx,%edx
  803ace:	f7 f7                	div    %edi
  803ad0:	89 d3                	mov    %edx,%ebx
  803ad2:	f7 24 24             	mull   (%esp)
  803ad5:	89 c6                	mov    %eax,%esi
  803ad7:	89 d1                	mov    %edx,%ecx
  803ad9:	39 d3                	cmp    %edx,%ebx
  803adb:	0f 82 87 00 00 00    	jb     803b68 <__umoddi3+0x134>
  803ae1:	0f 84 91 00 00 00    	je     803b78 <__umoddi3+0x144>
  803ae7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803aeb:	29 f2                	sub    %esi,%edx
  803aed:	19 cb                	sbb    %ecx,%ebx
  803aef:	89 d8                	mov    %ebx,%eax
  803af1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803af5:	d3 e0                	shl    %cl,%eax
  803af7:	89 e9                	mov    %ebp,%ecx
  803af9:	d3 ea                	shr    %cl,%edx
  803afb:	09 d0                	or     %edx,%eax
  803afd:	89 e9                	mov    %ebp,%ecx
  803aff:	d3 eb                	shr    %cl,%ebx
  803b01:	89 da                	mov    %ebx,%edx
  803b03:	83 c4 1c             	add    $0x1c,%esp
  803b06:	5b                   	pop    %ebx
  803b07:	5e                   	pop    %esi
  803b08:	5f                   	pop    %edi
  803b09:	5d                   	pop    %ebp
  803b0a:	c3                   	ret    
  803b0b:	90                   	nop
  803b0c:	89 fd                	mov    %edi,%ebp
  803b0e:	85 ff                	test   %edi,%edi
  803b10:	75 0b                	jne    803b1d <__umoddi3+0xe9>
  803b12:	b8 01 00 00 00       	mov    $0x1,%eax
  803b17:	31 d2                	xor    %edx,%edx
  803b19:	f7 f7                	div    %edi
  803b1b:	89 c5                	mov    %eax,%ebp
  803b1d:	89 f0                	mov    %esi,%eax
  803b1f:	31 d2                	xor    %edx,%edx
  803b21:	f7 f5                	div    %ebp
  803b23:	89 c8                	mov    %ecx,%eax
  803b25:	f7 f5                	div    %ebp
  803b27:	89 d0                	mov    %edx,%eax
  803b29:	e9 44 ff ff ff       	jmp    803a72 <__umoddi3+0x3e>
  803b2e:	66 90                	xchg   %ax,%ax
  803b30:	89 c8                	mov    %ecx,%eax
  803b32:	89 f2                	mov    %esi,%edx
  803b34:	83 c4 1c             	add    $0x1c,%esp
  803b37:	5b                   	pop    %ebx
  803b38:	5e                   	pop    %esi
  803b39:	5f                   	pop    %edi
  803b3a:	5d                   	pop    %ebp
  803b3b:	c3                   	ret    
  803b3c:	3b 04 24             	cmp    (%esp),%eax
  803b3f:	72 06                	jb     803b47 <__umoddi3+0x113>
  803b41:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b45:	77 0f                	ja     803b56 <__umoddi3+0x122>
  803b47:	89 f2                	mov    %esi,%edx
  803b49:	29 f9                	sub    %edi,%ecx
  803b4b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b4f:	89 14 24             	mov    %edx,(%esp)
  803b52:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b56:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b5a:	8b 14 24             	mov    (%esp),%edx
  803b5d:	83 c4 1c             	add    $0x1c,%esp
  803b60:	5b                   	pop    %ebx
  803b61:	5e                   	pop    %esi
  803b62:	5f                   	pop    %edi
  803b63:	5d                   	pop    %ebp
  803b64:	c3                   	ret    
  803b65:	8d 76 00             	lea    0x0(%esi),%esi
  803b68:	2b 04 24             	sub    (%esp),%eax
  803b6b:	19 fa                	sbb    %edi,%edx
  803b6d:	89 d1                	mov    %edx,%ecx
  803b6f:	89 c6                	mov    %eax,%esi
  803b71:	e9 71 ff ff ff       	jmp    803ae7 <__umoddi3+0xb3>
  803b76:	66 90                	xchg   %ax,%ax
  803b78:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b7c:	72 ea                	jb     803b68 <__umoddi3+0x134>
  803b7e:	89 d9                	mov    %ebx,%ecx
  803b80:	e9 62 ff ff ff       	jmp    803ae7 <__umoddi3+0xb3>
