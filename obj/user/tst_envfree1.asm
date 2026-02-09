
obj/user/tst_envfree1:     file format elf32-i386


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
  800031:	e8 c1 02 00 00       	call   8002f7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests environment free run tef1 5 3
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	rsttst();
  800044:	e8 f7 19 00 00       	call   801a40 <rsttst>
	// Testing scenario 1: without using dynamic allocation/de-allocation, shared variables and semaphores
	// Testing removing the allocated pages in mem, WS, mapped page tables, env's directory and env's page file

	char getksbrkCmd[100] = "__getKernelSBreak__";
  800049:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80004f:	bb c1 20 80 00       	mov    $0x8020c1,%ebx
  800054:	ba 05 00 00 00       	mov    $0x5,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800061:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  800067:	b9 14 00 00 00       	mov    $0x14,%ecx
  80006c:	b8 00 00 00 00       	mov    $0x0,%eax
  800071:	89 d7                	mov    %edx,%edi
  800073:	f3 ab                	rep stos %eax,%es:(%edi)
	uint32 ksbrk_before ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_before);
  800075:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  80007b:	83 ec 08             	sub    $0x8,%esp
  80007e:	50                   	push   %eax
  80007f:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800085:	50                   	push   %eax
  800086:	e8 0d 1b 00 00       	call   801b98 <sys_utilities>
  80008b:	83 c4 10             	add    $0x10,%esp

	int freeFrames_before = sys_calculate_free_frames() ;
  80008e:	e8 06 17 00 00       	call   801799 <sys_calculate_free_frames>
  800093:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800096:	e8 49 17 00 00       	call   8017e4 <sys_pf_calculate_allocated_pages>
  80009b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80009e:	83 ec 08             	sub    $0x8,%esp
  8000a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000a4:	68 a0 1e 80 00       	push   $0x801ea0
  8000a9:	e8 e7 06 00 00       	call   800795 <cprintf>
  8000ae:	83 c4 10             	add    $0x10,%esp

	/*[4] CREATE AND RUN ProcessA & ProcessB*/
	//Create 3 processes

	int32 envIdProcessA = sys_create_env("sc_fib_recursive", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b6:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  8000bc:	89 c2                	mov    %eax,%edx
  8000be:	a1 20 30 80 00       	mov    0x803020,%eax
  8000c3:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000c9:	6a 32                	push   $0x32
  8000cb:	52                   	push   %edx
  8000cc:	50                   	push   %eax
  8000cd:	68 d3 1e 80 00       	push   $0x801ed3
  8000d2:	e8 1d 18 00 00       	call   8018f4 <sys_create_env>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdProcessB = sys_create_env("sc_fact_recursive", (myEnv->page_WS_max_size)*4,(myEnv->SecondListSize), 50);
  8000dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e2:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  8000e8:	89 c2                	mov    %eax,%edx
  8000ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ef:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000f5:	c1 e0 02             	shl    $0x2,%eax
  8000f8:	6a 32                	push   $0x32
  8000fa:	52                   	push   %edx
  8000fb:	50                   	push   %eax
  8000fc:	68 e4 1e 80 00       	push   $0x801ee4
  800101:	e8 ee 17 00 00       	call   8018f4 <sys_create_env>
  800106:	83 c4 10             	add    $0x10,%esp
  800109:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdProcessC = sys_create_env("sc_fos_add",(myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80010c:	a1 20 30 80 00       	mov    0x803020,%eax
  800111:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  800117:	89 c2                	mov    %eax,%edx
  800119:	a1 20 30 80 00       	mov    0x803020,%eax
  80011e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800124:	6a 32                	push   $0x32
  800126:	52                   	push   %edx
  800127:	50                   	push   %eax
  800128:	68 f6 1e 80 00       	push   $0x801ef6
  80012d:	e8 c2 17 00 00       	call   8018f4 <sys_create_env>
  800132:	83 c4 10             	add    $0x10,%esp
  800135:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//Run 3 processes
	sys_run_env(envIdProcessA);
  800138:	83 ec 0c             	sub    $0xc,%esp
  80013b:	ff 75 dc             	pushl  -0x24(%ebp)
  80013e:	e8 cf 17 00 00       	call   801912 <sys_run_env>
  800143:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800146:	83 ec 0c             	sub    $0xc,%esp
  800149:	ff 75 d8             	pushl  -0x28(%ebp)
  80014c:	e8 c1 17 00 00       	call   801912 <sys_run_env>
  800151:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessC);
  800154:	83 ec 0c             	sub    $0xc,%esp
  800157:	ff 75 d4             	pushl  -0x2c(%ebp)
  80015a:	e8 b3 17 00 00       	call   801912 <sys_run_env>
  80015f:	83 c4 10             	add    $0x10,%esp

	//env_sleep(6000);
	while (gettst() != 3) ;
  800162:	90                   	nop
  800163:	e8 52 19 00 00       	call   801aba <gettst>
  800168:	83 f8 03             	cmp    $0x3,%eax
  80016b:	75 f6                	jne    800163 <_main+0x12b>

	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  80016d:	e8 27 16 00 00       	call   801799 <sys_calculate_free_frames>
  800172:	83 ec 08             	sub    $0x8,%esp
  800175:	50                   	push   %eax
  800176:	68 04 1f 80 00       	push   $0x801f04
  80017b:	e8 15 06 00 00       	call   800795 <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp

	uint32 ksbrk_after ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_after);
  800183:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800189:	83 ec 08             	sub    $0x8,%esp
  80018c:	50                   	push   %eax
  80018d:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800193:	50                   	push   %eax
  800194:	e8 ff 19 00 00       	call   801b98 <sys_utilities>
  800199:	83 c4 10             	add    $0x10,%esp
	//Kill the 3 processes
	//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
	//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
	//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
	//	2. changing the # free frames
	char changeIntCmd[100] = "__changeInterruptStatus__";
  80019c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001a2:	bb 25 21 80 00       	mov    $0x802125,%ebx
  8001a7:	ba 1a 00 00 00       	mov    $0x1a,%edx
  8001ac:	89 c7                	mov    %eax,%edi
  8001ae:	89 de                	mov    %ebx,%esi
  8001b0:	89 d1                	mov    %edx,%ecx
  8001b2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001b4:	8d 95 02 ff ff ff    	lea    -0xfe(%ebp),%edx
  8001ba:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  8001bf:	b0 00                	mov    $0x0,%al
  8001c1:	89 d7                	mov    %edx,%edi
  8001c3:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(changeIntCmd, 0);
  8001c5:	83 ec 08             	sub    $0x8,%esp
  8001c8:	6a 00                	push   $0x0
  8001ca:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001d0:	50                   	push   %eax
  8001d1:	e8 c2 19 00 00       	call   801b98 <sys_utilities>
  8001d6:	83 c4 10             	add    $0x10,%esp
	{
		sys_destroy_env(envIdProcessA);
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	ff 75 dc             	pushl  -0x24(%ebp)
  8001df:	e8 4a 17 00 00       	call   80192e <sys_destroy_env>
  8001e4:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	ff 75 d8             	pushl  -0x28(%ebp)
  8001ed:	e8 3c 17 00 00       	call   80192e <sys_destroy_env>
  8001f2:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessC);
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001fb:	e8 2e 17 00 00       	call   80192e <sys_destroy_env>
  800200:	83 c4 10             	add    $0x10,%esp
	}
	sys_utilities(changeIntCmd, 1);
  800203:	83 ec 08             	sub    $0x8,%esp
  800206:	6a 01                	push   $0x1
  800208:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80020e:	50                   	push   %eax
  80020f:	e8 84 19 00 00       	call   801b98 <sys_utilities>
  800214:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  800217:	e8 7d 15 00 00       	call   801799 <sys_calculate_free_frames>
  80021c:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  80021f:	e8 c0 15 00 00       	call   8017e4 <sys_pf_calculate_allocated_pages>
  800224:	89 45 cc             	mov    %eax,-0x34(%ebp)

	cprintf("\n---# of free frames after KILLING programs = %d\n", sys_calculate_free_frames());
  800227:	e8 6d 15 00 00       	call   801799 <sys_calculate_free_frames>
  80022c:	83 ec 08             	sub    $0x8,%esp
  80022f:	50                   	push   %eax
  800230:	68 38 1f 80 00       	push   $0x801f38
  800235:	e8 5b 05 00 00       	call   800795 <cprintf>
  80023a:	83 c4 10             	add    $0x10,%esp

	int expected = (ROUNDUP((uint32)ksbrk_after, PAGE_SIZE) - ROUNDUP((uint32)ksbrk_before, PAGE_SIZE)) / PAGE_SIZE;
  80023d:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  800244:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  80024a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80024d:	01 d0                	add    %edx,%eax
  80024f:	48                   	dec    %eax
  800250:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800253:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800256:	ba 00 00 00 00       	mov    $0x0,%edx
  80025b:	f7 75 c8             	divl   -0x38(%ebp)
  80025e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800261:	29 d0                	sub    %edx,%eax
  800263:	89 c1                	mov    %eax,%ecx
  800265:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  80026c:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  800272:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800275:	01 d0                	add    %edx,%eax
  800277:	48                   	dec    %eax
  800278:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80027b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80027e:	ba 00 00 00 00       	mov    $0x0,%edx
  800283:	f7 75 c0             	divl   -0x40(%ebp)
  800286:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800289:	29 d0                	sub    %edx,%eax
  80028b:	29 c1                	sub    %eax,%ecx
  80028d:	89 c8                	mov    %ecx,%eax
  80028f:	c1 e8 0c             	shr    $0xc,%eax
  800292:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if ((freeFrames_before - freeFrames_after) != expected) {
  800295:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800298:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80029b:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80029e:	74 2e                	je     8002ce <_main+0x296>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d, expected = %d\n",
  8002a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002a3:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002a6:	ff 75 b8             	pushl  -0x48(%ebp)
  8002a9:	50                   	push   %eax
  8002aa:	ff 75 d0             	pushl  -0x30(%ebp)
  8002ad:	68 6c 1f 80 00       	push   $0x801f6c
  8002b2:	e8 de 04 00 00       	call   800795 <cprintf>
  8002b7:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before, expected);
		panic("env_free() does not work correctly... check it again.");
  8002ba:	83 ec 04             	sub    $0x4,%esp
  8002bd:	68 dc 1f 80 00       	push   $0x801fdc
  8002c2:	6a 3e                	push   $0x3e
  8002c4:	68 12 20 80 00       	push   $0x802012
  8002c9:	e8 d9 01 00 00       	call   8004a7 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back as expected\n");
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	68 28 20 80 00       	push   $0x802028
  8002d6:	e8 ba 04 00 00       	call   800795 <cprintf>
  8002db:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 1 for envfree completed successfully.\n");
  8002de:	83 ec 0c             	sub    $0xc,%esp
  8002e1:	68 78 20 80 00       	push   $0x802078
  8002e6:	e8 aa 04 00 00       	call   800795 <cprintf>
  8002eb:	83 c4 10             	add    $0x10,%esp
	return;
  8002ee:	90                   	nop
}
  8002ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002f2:	5b                   	pop    %ebx
  8002f3:	5e                   	pop    %esi
  8002f4:	5f                   	pop    %edi
  8002f5:	5d                   	pop    %ebp
  8002f6:	c3                   	ret    

008002f7 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	57                   	push   %edi
  8002fb:	56                   	push   %esi
  8002fc:	53                   	push   %ebx
  8002fd:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800300:	e8 5d 16 00 00       	call   801962 <sys_getenvindex>
  800305:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800308:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80030b:	89 d0                	mov    %edx,%eax
  80030d:	01 c0                	add    %eax,%eax
  80030f:	01 d0                	add    %edx,%eax
  800311:	c1 e0 02             	shl    $0x2,%eax
  800314:	01 d0                	add    %edx,%eax
  800316:	c1 e0 02             	shl    $0x2,%eax
  800319:	01 d0                	add    %edx,%eax
  80031b:	c1 e0 03             	shl    $0x3,%eax
  80031e:	01 d0                	add    %edx,%eax
  800320:	c1 e0 02             	shl    $0x2,%eax
  800323:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800328:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80032d:	a1 20 30 80 00       	mov    0x803020,%eax
  800332:	8a 40 20             	mov    0x20(%eax),%al
  800335:	84 c0                	test   %al,%al
  800337:	74 0d                	je     800346 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800339:	a1 20 30 80 00       	mov    0x803020,%eax
  80033e:	83 c0 20             	add    $0x20,%eax
  800341:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800346:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80034a:	7e 0a                	jle    800356 <libmain+0x5f>
		binaryname = argv[0];
  80034c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034f:	8b 00                	mov    (%eax),%eax
  800351:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800356:	83 ec 08             	sub    $0x8,%esp
  800359:	ff 75 0c             	pushl  0xc(%ebp)
  80035c:	ff 75 08             	pushl  0x8(%ebp)
  80035f:	e8 d4 fc ff ff       	call   800038 <_main>
  800364:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800367:	a1 00 30 80 00       	mov    0x803000,%eax
  80036c:	85 c0                	test   %eax,%eax
  80036e:	0f 84 01 01 00 00    	je     800475 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800374:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80037a:	bb 84 22 80 00       	mov    $0x802284,%ebx
  80037f:	ba 0e 00 00 00       	mov    $0xe,%edx
  800384:	89 c7                	mov    %eax,%edi
  800386:	89 de                	mov    %ebx,%esi
  800388:	89 d1                	mov    %edx,%ecx
  80038a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80038c:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80038f:	b9 56 00 00 00       	mov    $0x56,%ecx
  800394:	b0 00                	mov    $0x0,%al
  800396:	89 d7                	mov    %edx,%edi
  800398:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80039a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8003a1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8003a4:	83 ec 08             	sub    $0x8,%esp
  8003a7:	50                   	push   %eax
  8003a8:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003ae:	50                   	push   %eax
  8003af:	e8 e4 17 00 00       	call   801b98 <sys_utilities>
  8003b4:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003b7:	e8 2d 13 00 00       	call   8016e9 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003bc:	83 ec 0c             	sub    $0xc,%esp
  8003bf:	68 a4 21 80 00       	push   $0x8021a4
  8003c4:	e8 cc 03 00 00       	call   800795 <cprintf>
  8003c9:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003cf:	85 c0                	test   %eax,%eax
  8003d1:	74 18                	je     8003eb <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003d3:	e8 de 17 00 00       	call   801bb6 <sys_get_optimal_num_faults>
  8003d8:	83 ec 08             	sub    $0x8,%esp
  8003db:	50                   	push   %eax
  8003dc:	68 cc 21 80 00       	push   $0x8021cc
  8003e1:	e8 af 03 00 00       	call   800795 <cprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp
  8003e9:	eb 59                	jmp    800444 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f0:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8003f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003fb:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800401:	83 ec 04             	sub    $0x4,%esp
  800404:	52                   	push   %edx
  800405:	50                   	push   %eax
  800406:	68 f0 21 80 00       	push   $0x8021f0
  80040b:	e8 85 03 00 00       	call   800795 <cprintf>
  800410:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800413:	a1 20 30 80 00       	mov    0x803020,%eax
  800418:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  80041e:	a1 20 30 80 00       	mov    0x803020,%eax
  800423:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800429:	a1 20 30 80 00       	mov    0x803020,%eax
  80042e:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800434:	51                   	push   %ecx
  800435:	52                   	push   %edx
  800436:	50                   	push   %eax
  800437:	68 18 22 80 00       	push   $0x802218
  80043c:	e8 54 03 00 00       	call   800795 <cprintf>
  800441:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800444:	a1 20 30 80 00       	mov    0x803020,%eax
  800449:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  80044f:	83 ec 08             	sub    $0x8,%esp
  800452:	50                   	push   %eax
  800453:	68 70 22 80 00       	push   $0x802270
  800458:	e8 38 03 00 00       	call   800795 <cprintf>
  80045d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800460:	83 ec 0c             	sub    $0xc,%esp
  800463:	68 a4 21 80 00       	push   $0x8021a4
  800468:	e8 28 03 00 00       	call   800795 <cprintf>
  80046d:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800470:	e8 8e 12 00 00       	call   801703 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800475:	e8 1f 00 00 00       	call   800499 <exit>
}
  80047a:	90                   	nop
  80047b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80047e:	5b                   	pop    %ebx
  80047f:	5e                   	pop    %esi
  800480:	5f                   	pop    %edi
  800481:	5d                   	pop    %ebp
  800482:	c3                   	ret    

00800483 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800483:	55                   	push   %ebp
  800484:	89 e5                	mov    %esp,%ebp
  800486:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800489:	83 ec 0c             	sub    $0xc,%esp
  80048c:	6a 00                	push   $0x0
  80048e:	e8 9b 14 00 00       	call   80192e <sys_destroy_env>
  800493:	83 c4 10             	add    $0x10,%esp
}
  800496:	90                   	nop
  800497:	c9                   	leave  
  800498:	c3                   	ret    

00800499 <exit>:

void
exit(void)
{
  800499:	55                   	push   %ebp
  80049a:	89 e5                	mov    %esp,%ebp
  80049c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80049f:	e8 f0 14 00 00       	call   801994 <sys_exit_env>
}
  8004a4:	90                   	nop
  8004a5:	c9                   	leave  
  8004a6:	c3                   	ret    

008004a7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004a7:	55                   	push   %ebp
  8004a8:	89 e5                	mov    %esp,%ebp
  8004aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004ad:	8d 45 10             	lea    0x10(%ebp),%eax
  8004b0:	83 c0 04             	add    $0x4,%eax
  8004b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004b6:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8004bb:	85 c0                	test   %eax,%eax
  8004bd:	74 16                	je     8004d5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004bf:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8004c4:	83 ec 08             	sub    $0x8,%esp
  8004c7:	50                   	push   %eax
  8004c8:	68 e8 22 80 00       	push   $0x8022e8
  8004cd:	e8 c3 02 00 00       	call   800795 <cprintf>
  8004d2:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004d5:	a1 04 30 80 00       	mov    0x803004,%eax
  8004da:	83 ec 0c             	sub    $0xc,%esp
  8004dd:	ff 75 0c             	pushl  0xc(%ebp)
  8004e0:	ff 75 08             	pushl  0x8(%ebp)
  8004e3:	50                   	push   %eax
  8004e4:	68 f0 22 80 00       	push   $0x8022f0
  8004e9:	6a 74                	push   $0x74
  8004eb:	e8 d2 02 00 00       	call   8007c2 <cprintf_colored>
  8004f0:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f6:	83 ec 08             	sub    $0x8,%esp
  8004f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004fc:	50                   	push   %eax
  8004fd:	e8 24 02 00 00       	call   800726 <vcprintf>
  800502:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800505:	83 ec 08             	sub    $0x8,%esp
  800508:	6a 00                	push   $0x0
  80050a:	68 18 23 80 00       	push   $0x802318
  80050f:	e8 12 02 00 00       	call   800726 <vcprintf>
  800514:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800517:	e8 7d ff ff ff       	call   800499 <exit>

	// should not return here
	while (1) ;
  80051c:	eb fe                	jmp    80051c <_panic+0x75>

0080051e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80051e:	55                   	push   %ebp
  80051f:	89 e5                	mov    %esp,%ebp
  800521:	53                   	push   %ebx
  800522:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800525:	a1 20 30 80 00       	mov    0x803020,%eax
  80052a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800530:	8b 45 0c             	mov    0xc(%ebp),%eax
  800533:	39 c2                	cmp    %eax,%edx
  800535:	74 14                	je     80054b <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800537:	83 ec 04             	sub    $0x4,%esp
  80053a:	68 1c 23 80 00       	push   $0x80231c
  80053f:	6a 26                	push   $0x26
  800541:	68 68 23 80 00       	push   $0x802368
  800546:	e8 5c ff ff ff       	call   8004a7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80054b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800552:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800559:	e9 d9 00 00 00       	jmp    800637 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  80055e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800561:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800568:	8b 45 08             	mov    0x8(%ebp),%eax
  80056b:	01 d0                	add    %edx,%eax
  80056d:	8b 00                	mov    (%eax),%eax
  80056f:	85 c0                	test   %eax,%eax
  800571:	75 08                	jne    80057b <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  800573:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800576:	e9 b9 00 00 00       	jmp    800634 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  80057b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800582:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800589:	eb 79                	jmp    800604 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80058b:	a1 20 30 80 00       	mov    0x803020,%eax
  800590:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800596:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800599:	89 d0                	mov    %edx,%eax
  80059b:	01 c0                	add    %eax,%eax
  80059d:	01 d0                	add    %edx,%eax
  80059f:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8005a6:	01 d8                	add    %ebx,%eax
  8005a8:	01 d0                	add    %edx,%eax
  8005aa:	01 c8                	add    %ecx,%eax
  8005ac:	8a 40 04             	mov    0x4(%eax),%al
  8005af:	84 c0                	test   %al,%al
  8005b1:	75 4e                	jne    800601 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005b3:	a1 20 30 80 00       	mov    0x803020,%eax
  8005b8:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8005be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005c1:	89 d0                	mov    %edx,%eax
  8005c3:	01 c0                	add    %eax,%eax
  8005c5:	01 d0                	add    %edx,%eax
  8005c7:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8005ce:	01 d8                	add    %ebx,%eax
  8005d0:	01 d0                	add    %edx,%eax
  8005d2:	01 c8                	add    %ecx,%eax
  8005d4:	8b 00                	mov    (%eax),%eax
  8005d6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005e1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005e6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f0:	01 c8                	add    %ecx,%eax
  8005f2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005f4:	39 c2                	cmp    %eax,%edx
  8005f6:	75 09                	jne    800601 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8005f8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005ff:	eb 19                	jmp    80061a <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800601:	ff 45 e8             	incl   -0x18(%ebp)
  800604:	a1 20 30 80 00       	mov    0x803020,%eax
  800609:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80060f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800612:	39 c2                	cmp    %eax,%edx
  800614:	0f 87 71 ff ff ff    	ja     80058b <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80061a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80061e:	75 14                	jne    800634 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800620:	83 ec 04             	sub    $0x4,%esp
  800623:	68 74 23 80 00       	push   $0x802374
  800628:	6a 3a                	push   $0x3a
  80062a:	68 68 23 80 00       	push   $0x802368
  80062f:	e8 73 fe ff ff       	call   8004a7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800634:	ff 45 f0             	incl   -0x10(%ebp)
  800637:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80063a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80063d:	0f 8c 1b ff ff ff    	jl     80055e <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800643:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80064a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800651:	eb 2e                	jmp    800681 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800653:	a1 20 30 80 00       	mov    0x803020,%eax
  800658:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80065e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800661:	89 d0                	mov    %edx,%eax
  800663:	01 c0                	add    %eax,%eax
  800665:	01 d0                	add    %edx,%eax
  800667:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80066e:	01 d8                	add    %ebx,%eax
  800670:	01 d0                	add    %edx,%eax
  800672:	01 c8                	add    %ecx,%eax
  800674:	8a 40 04             	mov    0x4(%eax),%al
  800677:	3c 01                	cmp    $0x1,%al
  800679:	75 03                	jne    80067e <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  80067b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80067e:	ff 45 e0             	incl   -0x20(%ebp)
  800681:	a1 20 30 80 00       	mov    0x803020,%eax
  800686:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80068c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80068f:	39 c2                	cmp    %eax,%edx
  800691:	77 c0                	ja     800653 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800696:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800699:	74 14                	je     8006af <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  80069b:	83 ec 04             	sub    $0x4,%esp
  80069e:	68 c8 23 80 00       	push   $0x8023c8
  8006a3:	6a 44                	push   $0x44
  8006a5:	68 68 23 80 00       	push   $0x802368
  8006aa:	e8 f8 fd ff ff       	call   8004a7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006af:	90                   	nop
  8006b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006b3:	c9                   	leave  
  8006b4:	c3                   	ret    

008006b5 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8006b5:	55                   	push   %ebp
  8006b6:	89 e5                	mov    %esp,%ebp
  8006b8:	53                   	push   %ebx
  8006b9:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	8d 48 01             	lea    0x1(%eax),%ecx
  8006c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c7:	89 0a                	mov    %ecx,(%edx)
  8006c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8006cc:	88 d1                	mov    %dl,%cl
  8006ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006df:	75 30                	jne    800711 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006e1:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006e7:	a0 44 30 80 00       	mov    0x803044,%al
  8006ec:	0f b6 c0             	movzbl %al,%eax
  8006ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006f2:	8b 09                	mov    (%ecx),%ecx
  8006f4:	89 cb                	mov    %ecx,%ebx
  8006f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006f9:	83 c1 08             	add    $0x8,%ecx
  8006fc:	52                   	push   %edx
  8006fd:	50                   	push   %eax
  8006fe:	53                   	push   %ebx
  8006ff:	51                   	push   %ecx
  800700:	e8 a0 0f 00 00       	call   8016a5 <sys_cputs>
  800705:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800708:	8b 45 0c             	mov    0xc(%ebp),%eax
  80070b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800711:	8b 45 0c             	mov    0xc(%ebp),%eax
  800714:	8b 40 04             	mov    0x4(%eax),%eax
  800717:	8d 50 01             	lea    0x1(%eax),%edx
  80071a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80071d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800720:	90                   	nop
  800721:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800724:	c9                   	leave  
  800725:	c3                   	ret    

00800726 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800726:	55                   	push   %ebp
  800727:	89 e5                	mov    %esp,%ebp
  800729:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80072f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800736:	00 00 00 
	b.cnt = 0;
  800739:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800740:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800743:	ff 75 0c             	pushl  0xc(%ebp)
  800746:	ff 75 08             	pushl  0x8(%ebp)
  800749:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80074f:	50                   	push   %eax
  800750:	68 b5 06 80 00       	push   $0x8006b5
  800755:	e8 5a 02 00 00       	call   8009b4 <vprintfmt>
  80075a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80075d:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800763:	a0 44 30 80 00       	mov    0x803044,%al
  800768:	0f b6 c0             	movzbl %al,%eax
  80076b:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800771:	52                   	push   %edx
  800772:	50                   	push   %eax
  800773:	51                   	push   %ecx
  800774:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80077a:	83 c0 08             	add    $0x8,%eax
  80077d:	50                   	push   %eax
  80077e:	e8 22 0f 00 00       	call   8016a5 <sys_cputs>
  800783:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800786:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  80078d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800793:	c9                   	leave  
  800794:	c3                   	ret    

00800795 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800795:	55                   	push   %ebp
  800796:	89 e5                	mov    %esp,%ebp
  800798:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80079b:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8007a2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b1:	50                   	push   %eax
  8007b2:	e8 6f ff ff ff       	call   800726 <vcprintf>
  8007b7:	83 c4 10             	add    $0x10,%esp
  8007ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007c0:	c9                   	leave  
  8007c1:	c3                   	ret    

008007c2 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8007c2:	55                   	push   %ebp
  8007c3:	89 e5                	mov    %esp,%ebp
  8007c5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007c8:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	c1 e0 08             	shl    $0x8,%eax
  8007d5:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8007da:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007dd:	83 c0 04             	add    $0x4,%eax
  8007e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e6:	83 ec 08             	sub    $0x8,%esp
  8007e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ec:	50                   	push   %eax
  8007ed:	e8 34 ff ff ff       	call   800726 <vcprintf>
  8007f2:	83 c4 10             	add    $0x10,%esp
  8007f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007f8:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8007ff:	07 00 00 

	return cnt;
  800802:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800805:	c9                   	leave  
  800806:	c3                   	ret    

00800807 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800807:	55                   	push   %ebp
  800808:	89 e5                	mov    %esp,%ebp
  80080a:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80080d:	e8 d7 0e 00 00       	call   8016e9 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800812:	8d 45 0c             	lea    0xc(%ebp),%eax
  800815:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800818:	8b 45 08             	mov    0x8(%ebp),%eax
  80081b:	83 ec 08             	sub    $0x8,%esp
  80081e:	ff 75 f4             	pushl  -0xc(%ebp)
  800821:	50                   	push   %eax
  800822:	e8 ff fe ff ff       	call   800726 <vcprintf>
  800827:	83 c4 10             	add    $0x10,%esp
  80082a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80082d:	e8 d1 0e 00 00       	call   801703 <sys_unlock_cons>
	return cnt;
  800832:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800835:	c9                   	leave  
  800836:	c3                   	ret    

00800837 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800837:	55                   	push   %ebp
  800838:	89 e5                	mov    %esp,%ebp
  80083a:	53                   	push   %ebx
  80083b:	83 ec 14             	sub    $0x14,%esp
  80083e:	8b 45 10             	mov    0x10(%ebp),%eax
  800841:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800844:	8b 45 14             	mov    0x14(%ebp),%eax
  800847:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80084a:	8b 45 18             	mov    0x18(%ebp),%eax
  80084d:	ba 00 00 00 00       	mov    $0x0,%edx
  800852:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800855:	77 55                	ja     8008ac <printnum+0x75>
  800857:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80085a:	72 05                	jb     800861 <printnum+0x2a>
  80085c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80085f:	77 4b                	ja     8008ac <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800861:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800864:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800867:	8b 45 18             	mov    0x18(%ebp),%eax
  80086a:	ba 00 00 00 00       	mov    $0x0,%edx
  80086f:	52                   	push   %edx
  800870:	50                   	push   %eax
  800871:	ff 75 f4             	pushl  -0xc(%ebp)
  800874:	ff 75 f0             	pushl  -0x10(%ebp)
  800877:	e8 ac 13 00 00       	call   801c28 <__udivdi3>
  80087c:	83 c4 10             	add    $0x10,%esp
  80087f:	83 ec 04             	sub    $0x4,%esp
  800882:	ff 75 20             	pushl  0x20(%ebp)
  800885:	53                   	push   %ebx
  800886:	ff 75 18             	pushl  0x18(%ebp)
  800889:	52                   	push   %edx
  80088a:	50                   	push   %eax
  80088b:	ff 75 0c             	pushl  0xc(%ebp)
  80088e:	ff 75 08             	pushl  0x8(%ebp)
  800891:	e8 a1 ff ff ff       	call   800837 <printnum>
  800896:	83 c4 20             	add    $0x20,%esp
  800899:	eb 1a                	jmp    8008b5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80089b:	83 ec 08             	sub    $0x8,%esp
  80089e:	ff 75 0c             	pushl  0xc(%ebp)
  8008a1:	ff 75 20             	pushl  0x20(%ebp)
  8008a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a7:	ff d0                	call   *%eax
  8008a9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008ac:	ff 4d 1c             	decl   0x1c(%ebp)
  8008af:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008b3:	7f e6                	jg     80089b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008b5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008c3:	53                   	push   %ebx
  8008c4:	51                   	push   %ecx
  8008c5:	52                   	push   %edx
  8008c6:	50                   	push   %eax
  8008c7:	e8 6c 14 00 00       	call   801d38 <__umoddi3>
  8008cc:	83 c4 10             	add    $0x10,%esp
  8008cf:	05 34 26 80 00       	add    $0x802634,%eax
  8008d4:	8a 00                	mov    (%eax),%al
  8008d6:	0f be c0             	movsbl %al,%eax
  8008d9:	83 ec 08             	sub    $0x8,%esp
  8008dc:	ff 75 0c             	pushl  0xc(%ebp)
  8008df:	50                   	push   %eax
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	ff d0                	call   *%eax
  8008e5:	83 c4 10             	add    $0x10,%esp
}
  8008e8:	90                   	nop
  8008e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008ec:	c9                   	leave  
  8008ed:	c3                   	ret    

008008ee <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008f1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008f5:	7e 1c                	jle    800913 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	8d 50 08             	lea    0x8(%eax),%edx
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	89 10                	mov    %edx,(%eax)
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	8b 00                	mov    (%eax),%eax
  800909:	83 e8 08             	sub    $0x8,%eax
  80090c:	8b 50 04             	mov    0x4(%eax),%edx
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	eb 40                	jmp    800953 <getuint+0x65>
	else if (lflag)
  800913:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800917:	74 1e                	je     800937 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	8b 00                	mov    (%eax),%eax
  80091e:	8d 50 04             	lea    0x4(%eax),%edx
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	89 10                	mov    %edx,(%eax)
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	8b 00                	mov    (%eax),%eax
  80092b:	83 e8 04             	sub    $0x4,%eax
  80092e:	8b 00                	mov    (%eax),%eax
  800930:	ba 00 00 00 00       	mov    $0x0,%edx
  800935:	eb 1c                	jmp    800953 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	8d 50 04             	lea    0x4(%eax),%edx
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	89 10                	mov    %edx,(%eax)
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	8b 00                	mov    (%eax),%eax
  800949:	83 e8 04             	sub    $0x4,%eax
  80094c:	8b 00                	mov    (%eax),%eax
  80094e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800953:	5d                   	pop    %ebp
  800954:	c3                   	ret    

00800955 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800958:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80095c:	7e 1c                	jle    80097a <getint+0x25>
		return va_arg(*ap, long long);
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	8b 00                	mov    (%eax),%eax
  800963:	8d 50 08             	lea    0x8(%eax),%edx
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	89 10                	mov    %edx,(%eax)
  80096b:	8b 45 08             	mov    0x8(%ebp),%eax
  80096e:	8b 00                	mov    (%eax),%eax
  800970:	83 e8 08             	sub    $0x8,%eax
  800973:	8b 50 04             	mov    0x4(%eax),%edx
  800976:	8b 00                	mov    (%eax),%eax
  800978:	eb 38                	jmp    8009b2 <getint+0x5d>
	else if (lflag)
  80097a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80097e:	74 1a                	je     80099a <getint+0x45>
		return va_arg(*ap, long);
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	8b 00                	mov    (%eax),%eax
  800985:	8d 50 04             	lea    0x4(%eax),%edx
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	89 10                	mov    %edx,(%eax)
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	8b 00                	mov    (%eax),%eax
  800992:	83 e8 04             	sub    $0x4,%eax
  800995:	8b 00                	mov    (%eax),%eax
  800997:	99                   	cltd   
  800998:	eb 18                	jmp    8009b2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80099a:	8b 45 08             	mov    0x8(%ebp),%eax
  80099d:	8b 00                	mov    (%eax),%eax
  80099f:	8d 50 04             	lea    0x4(%eax),%edx
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	89 10                	mov    %edx,(%eax)
  8009a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009aa:	8b 00                	mov    (%eax),%eax
  8009ac:	83 e8 04             	sub    $0x4,%eax
  8009af:	8b 00                	mov    (%eax),%eax
  8009b1:	99                   	cltd   
}
  8009b2:	5d                   	pop    %ebp
  8009b3:	c3                   	ret    

008009b4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	56                   	push   %esi
  8009b8:	53                   	push   %ebx
  8009b9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009bc:	eb 17                	jmp    8009d5 <vprintfmt+0x21>
			if (ch == '\0')
  8009be:	85 db                	test   %ebx,%ebx
  8009c0:	0f 84 c1 03 00 00    	je     800d87 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009c6:	83 ec 08             	sub    $0x8,%esp
  8009c9:	ff 75 0c             	pushl  0xc(%ebp)
  8009cc:	53                   	push   %ebx
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	ff d0                	call   *%eax
  8009d2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d8:	8d 50 01             	lea    0x1(%eax),%edx
  8009db:	89 55 10             	mov    %edx,0x10(%ebp)
  8009de:	8a 00                	mov    (%eax),%al
  8009e0:	0f b6 d8             	movzbl %al,%ebx
  8009e3:	83 fb 25             	cmp    $0x25,%ebx
  8009e6:	75 d6                	jne    8009be <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009e8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009ec:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009f3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009fa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a01:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a08:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0b:	8d 50 01             	lea    0x1(%eax),%edx
  800a0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800a11:	8a 00                	mov    (%eax),%al
  800a13:	0f b6 d8             	movzbl %al,%ebx
  800a16:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a19:	83 f8 5b             	cmp    $0x5b,%eax
  800a1c:	0f 87 3d 03 00 00    	ja     800d5f <vprintfmt+0x3ab>
  800a22:	8b 04 85 58 26 80 00 	mov    0x802658(,%eax,4),%eax
  800a29:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a2b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a2f:	eb d7                	jmp    800a08 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a31:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a35:	eb d1                	jmp    800a08 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a37:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a3e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a41:	89 d0                	mov    %edx,%eax
  800a43:	c1 e0 02             	shl    $0x2,%eax
  800a46:	01 d0                	add    %edx,%eax
  800a48:	01 c0                	add    %eax,%eax
  800a4a:	01 d8                	add    %ebx,%eax
  800a4c:	83 e8 30             	sub    $0x30,%eax
  800a4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a52:	8b 45 10             	mov    0x10(%ebp),%eax
  800a55:	8a 00                	mov    (%eax),%al
  800a57:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a5a:	83 fb 2f             	cmp    $0x2f,%ebx
  800a5d:	7e 3e                	jle    800a9d <vprintfmt+0xe9>
  800a5f:	83 fb 39             	cmp    $0x39,%ebx
  800a62:	7f 39                	jg     800a9d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a64:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a67:	eb d5                	jmp    800a3e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a69:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6c:	83 c0 04             	add    $0x4,%eax
  800a6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a72:	8b 45 14             	mov    0x14(%ebp),%eax
  800a75:	83 e8 04             	sub    $0x4,%eax
  800a78:	8b 00                	mov    (%eax),%eax
  800a7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a7d:	eb 1f                	jmp    800a9e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a83:	79 83                	jns    800a08 <vprintfmt+0x54>
				width = 0;
  800a85:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a8c:	e9 77 ff ff ff       	jmp    800a08 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a91:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a98:	e9 6b ff ff ff       	jmp    800a08 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a9d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aa2:	0f 89 60 ff ff ff    	jns    800a08 <vprintfmt+0x54>
				width = precision, precision = -1;
  800aa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800aae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ab5:	e9 4e ff ff ff       	jmp    800a08 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800aba:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800abd:	e9 46 ff ff ff       	jmp    800a08 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ac2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac5:	83 c0 04             	add    $0x4,%eax
  800ac8:	89 45 14             	mov    %eax,0x14(%ebp)
  800acb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ace:	83 e8 04             	sub    $0x4,%eax
  800ad1:	8b 00                	mov    (%eax),%eax
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	50                   	push   %eax
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	ff d0                	call   *%eax
  800adf:	83 c4 10             	add    $0x10,%esp
			break;
  800ae2:	e9 9b 02 00 00       	jmp    800d82 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ae7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aea:	83 c0 04             	add    $0x4,%eax
  800aed:	89 45 14             	mov    %eax,0x14(%ebp)
  800af0:	8b 45 14             	mov    0x14(%ebp),%eax
  800af3:	83 e8 04             	sub    $0x4,%eax
  800af6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800af8:	85 db                	test   %ebx,%ebx
  800afa:	79 02                	jns    800afe <vprintfmt+0x14a>
				err = -err;
  800afc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800afe:	83 fb 64             	cmp    $0x64,%ebx
  800b01:	7f 0b                	jg     800b0e <vprintfmt+0x15a>
  800b03:	8b 34 9d a0 24 80 00 	mov    0x8024a0(,%ebx,4),%esi
  800b0a:	85 f6                	test   %esi,%esi
  800b0c:	75 19                	jne    800b27 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b0e:	53                   	push   %ebx
  800b0f:	68 45 26 80 00       	push   $0x802645
  800b14:	ff 75 0c             	pushl  0xc(%ebp)
  800b17:	ff 75 08             	pushl  0x8(%ebp)
  800b1a:	e8 70 02 00 00       	call   800d8f <printfmt>
  800b1f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b22:	e9 5b 02 00 00       	jmp    800d82 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b27:	56                   	push   %esi
  800b28:	68 4e 26 80 00       	push   $0x80264e
  800b2d:	ff 75 0c             	pushl  0xc(%ebp)
  800b30:	ff 75 08             	pushl  0x8(%ebp)
  800b33:	e8 57 02 00 00       	call   800d8f <printfmt>
  800b38:	83 c4 10             	add    $0x10,%esp
			break;
  800b3b:	e9 42 02 00 00       	jmp    800d82 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b40:	8b 45 14             	mov    0x14(%ebp),%eax
  800b43:	83 c0 04             	add    $0x4,%eax
  800b46:	89 45 14             	mov    %eax,0x14(%ebp)
  800b49:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4c:	83 e8 04             	sub    $0x4,%eax
  800b4f:	8b 30                	mov    (%eax),%esi
  800b51:	85 f6                	test   %esi,%esi
  800b53:	75 05                	jne    800b5a <vprintfmt+0x1a6>
				p = "(null)";
  800b55:	be 51 26 80 00       	mov    $0x802651,%esi
			if (width > 0 && padc != '-')
  800b5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b5e:	7e 6d                	jle    800bcd <vprintfmt+0x219>
  800b60:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b64:	74 67                	je     800bcd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b69:	83 ec 08             	sub    $0x8,%esp
  800b6c:	50                   	push   %eax
  800b6d:	56                   	push   %esi
  800b6e:	e8 1e 03 00 00       	call   800e91 <strnlen>
  800b73:	83 c4 10             	add    $0x10,%esp
  800b76:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b79:	eb 16                	jmp    800b91 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b7b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b7f:	83 ec 08             	sub    $0x8,%esp
  800b82:	ff 75 0c             	pushl  0xc(%ebp)
  800b85:	50                   	push   %eax
  800b86:	8b 45 08             	mov    0x8(%ebp),%eax
  800b89:	ff d0                	call   *%eax
  800b8b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b8e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b95:	7f e4                	jg     800b7b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b97:	eb 34                	jmp    800bcd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b99:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b9d:	74 1c                	je     800bbb <vprintfmt+0x207>
  800b9f:	83 fb 1f             	cmp    $0x1f,%ebx
  800ba2:	7e 05                	jle    800ba9 <vprintfmt+0x1f5>
  800ba4:	83 fb 7e             	cmp    $0x7e,%ebx
  800ba7:	7e 12                	jle    800bbb <vprintfmt+0x207>
					putch('?', putdat);
  800ba9:	83 ec 08             	sub    $0x8,%esp
  800bac:	ff 75 0c             	pushl  0xc(%ebp)
  800baf:	6a 3f                	push   $0x3f
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	ff d0                	call   *%eax
  800bb6:	83 c4 10             	add    $0x10,%esp
  800bb9:	eb 0f                	jmp    800bca <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bbb:	83 ec 08             	sub    $0x8,%esp
  800bbe:	ff 75 0c             	pushl  0xc(%ebp)
  800bc1:	53                   	push   %ebx
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	ff d0                	call   *%eax
  800bc7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bca:	ff 4d e4             	decl   -0x1c(%ebp)
  800bcd:	89 f0                	mov    %esi,%eax
  800bcf:	8d 70 01             	lea    0x1(%eax),%esi
  800bd2:	8a 00                	mov    (%eax),%al
  800bd4:	0f be d8             	movsbl %al,%ebx
  800bd7:	85 db                	test   %ebx,%ebx
  800bd9:	74 24                	je     800bff <vprintfmt+0x24b>
  800bdb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bdf:	78 b8                	js     800b99 <vprintfmt+0x1e5>
  800be1:	ff 4d e0             	decl   -0x20(%ebp)
  800be4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800be8:	79 af                	jns    800b99 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bea:	eb 13                	jmp    800bff <vprintfmt+0x24b>
				putch(' ', putdat);
  800bec:	83 ec 08             	sub    $0x8,%esp
  800bef:	ff 75 0c             	pushl  0xc(%ebp)
  800bf2:	6a 20                	push   $0x20
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	ff d0                	call   *%eax
  800bf9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bfc:	ff 4d e4             	decl   -0x1c(%ebp)
  800bff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c03:	7f e7                	jg     800bec <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c05:	e9 78 01 00 00       	jmp    800d82 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c0a:	83 ec 08             	sub    $0x8,%esp
  800c0d:	ff 75 e8             	pushl  -0x18(%ebp)
  800c10:	8d 45 14             	lea    0x14(%ebp),%eax
  800c13:	50                   	push   %eax
  800c14:	e8 3c fd ff ff       	call   800955 <getint>
  800c19:	83 c4 10             	add    $0x10,%esp
  800c1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c28:	85 d2                	test   %edx,%edx
  800c2a:	79 23                	jns    800c4f <vprintfmt+0x29b>
				putch('-', putdat);
  800c2c:	83 ec 08             	sub    $0x8,%esp
  800c2f:	ff 75 0c             	pushl  0xc(%ebp)
  800c32:	6a 2d                	push   $0x2d
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	ff d0                	call   *%eax
  800c39:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c42:	f7 d8                	neg    %eax
  800c44:	83 d2 00             	adc    $0x0,%edx
  800c47:	f7 da                	neg    %edx
  800c49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c4f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c56:	e9 bc 00 00 00       	jmp    800d17 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c61:	8d 45 14             	lea    0x14(%ebp),%eax
  800c64:	50                   	push   %eax
  800c65:	e8 84 fc ff ff       	call   8008ee <getuint>
  800c6a:	83 c4 10             	add    $0x10,%esp
  800c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c73:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c7a:	e9 98 00 00 00       	jmp    800d17 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c7f:	83 ec 08             	sub    $0x8,%esp
  800c82:	ff 75 0c             	pushl  0xc(%ebp)
  800c85:	6a 58                	push   $0x58
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	ff d0                	call   *%eax
  800c8c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c8f:	83 ec 08             	sub    $0x8,%esp
  800c92:	ff 75 0c             	pushl  0xc(%ebp)
  800c95:	6a 58                	push   $0x58
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	ff d0                	call   *%eax
  800c9c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c9f:	83 ec 08             	sub    $0x8,%esp
  800ca2:	ff 75 0c             	pushl  0xc(%ebp)
  800ca5:	6a 58                	push   $0x58
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	ff d0                	call   *%eax
  800cac:	83 c4 10             	add    $0x10,%esp
			break;
  800caf:	e9 ce 00 00 00       	jmp    800d82 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800cb4:	83 ec 08             	sub    $0x8,%esp
  800cb7:	ff 75 0c             	pushl  0xc(%ebp)
  800cba:	6a 30                	push   $0x30
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	ff d0                	call   *%eax
  800cc1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cc4:	83 ec 08             	sub    $0x8,%esp
  800cc7:	ff 75 0c             	pushl  0xc(%ebp)
  800cca:	6a 78                	push   $0x78
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	ff d0                	call   *%eax
  800cd1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd7:	83 c0 04             	add    $0x4,%eax
  800cda:	89 45 14             	mov    %eax,0x14(%ebp)
  800cdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce0:	83 e8 04             	sub    $0x4,%eax
  800ce3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ce5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cf6:	eb 1f                	jmp    800d17 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cf8:	83 ec 08             	sub    $0x8,%esp
  800cfb:	ff 75 e8             	pushl  -0x18(%ebp)
  800cfe:	8d 45 14             	lea    0x14(%ebp),%eax
  800d01:	50                   	push   %eax
  800d02:	e8 e7 fb ff ff       	call   8008ee <getuint>
  800d07:	83 c4 10             	add    $0x10,%esp
  800d0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d10:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d17:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d1e:	83 ec 04             	sub    $0x4,%esp
  800d21:	52                   	push   %edx
  800d22:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d25:	50                   	push   %eax
  800d26:	ff 75 f4             	pushl  -0xc(%ebp)
  800d29:	ff 75 f0             	pushl  -0x10(%ebp)
  800d2c:	ff 75 0c             	pushl  0xc(%ebp)
  800d2f:	ff 75 08             	pushl  0x8(%ebp)
  800d32:	e8 00 fb ff ff       	call   800837 <printnum>
  800d37:	83 c4 20             	add    $0x20,%esp
			break;
  800d3a:	eb 46                	jmp    800d82 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d3c:	83 ec 08             	sub    $0x8,%esp
  800d3f:	ff 75 0c             	pushl  0xc(%ebp)
  800d42:	53                   	push   %ebx
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	ff d0                	call   *%eax
  800d48:	83 c4 10             	add    $0x10,%esp
			break;
  800d4b:	eb 35                	jmp    800d82 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d4d:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800d54:	eb 2c                	jmp    800d82 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d56:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800d5d:	eb 23                	jmp    800d82 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d5f:	83 ec 08             	sub    $0x8,%esp
  800d62:	ff 75 0c             	pushl  0xc(%ebp)
  800d65:	6a 25                	push   $0x25
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	ff d0                	call   *%eax
  800d6c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d6f:	ff 4d 10             	decl   0x10(%ebp)
  800d72:	eb 03                	jmp    800d77 <vprintfmt+0x3c3>
  800d74:	ff 4d 10             	decl   0x10(%ebp)
  800d77:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7a:	48                   	dec    %eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	3c 25                	cmp    $0x25,%al
  800d7f:	75 f3                	jne    800d74 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d81:	90                   	nop
		}
	}
  800d82:	e9 35 fc ff ff       	jmp    8009bc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d87:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d88:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d8b:	5b                   	pop    %ebx
  800d8c:	5e                   	pop    %esi
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d95:	8d 45 10             	lea    0x10(%ebp),%eax
  800d98:	83 c0 04             	add    $0x4,%eax
  800d9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800da1:	ff 75 f4             	pushl  -0xc(%ebp)
  800da4:	50                   	push   %eax
  800da5:	ff 75 0c             	pushl  0xc(%ebp)
  800da8:	ff 75 08             	pushl  0x8(%ebp)
  800dab:	e8 04 fc ff ff       	call   8009b4 <vprintfmt>
  800db0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800db3:	90                   	nop
  800db4:	c9                   	leave  
  800db5:	c3                   	ret    

00800db6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800db9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbc:	8b 40 08             	mov    0x8(%eax),%eax
  800dbf:	8d 50 01             	lea    0x1(%eax),%edx
  800dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcb:	8b 10                	mov    (%eax),%edx
  800dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd0:	8b 40 04             	mov    0x4(%eax),%eax
  800dd3:	39 c2                	cmp    %eax,%edx
  800dd5:	73 12                	jae    800de9 <sprintputch+0x33>
		*b->buf++ = ch;
  800dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dda:	8b 00                	mov    (%eax),%eax
  800ddc:	8d 48 01             	lea    0x1(%eax),%ecx
  800ddf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de2:	89 0a                	mov    %ecx,(%edx)
  800de4:	8b 55 08             	mov    0x8(%ebp),%edx
  800de7:	88 10                	mov    %dl,(%eax)
}
  800de9:	90                   	nop
  800dea:	5d                   	pop    %ebp
  800deb:	c3                   	ret    

00800dec <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	01 d0                	add    %edx,%eax
  800e03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e11:	74 06                	je     800e19 <vsnprintf+0x2d>
  800e13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e17:	7f 07                	jg     800e20 <vsnprintf+0x34>
		return -E_INVAL;
  800e19:	b8 03 00 00 00       	mov    $0x3,%eax
  800e1e:	eb 20                	jmp    800e40 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e20:	ff 75 14             	pushl  0x14(%ebp)
  800e23:	ff 75 10             	pushl  0x10(%ebp)
  800e26:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e29:	50                   	push   %eax
  800e2a:	68 b6 0d 80 00       	push   $0x800db6
  800e2f:	e8 80 fb ff ff       	call   8009b4 <vprintfmt>
  800e34:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e3a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e40:	c9                   	leave  
  800e41:	c3                   	ret    

00800e42 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e48:	8d 45 10             	lea    0x10(%ebp),%eax
  800e4b:	83 c0 04             	add    $0x4,%eax
  800e4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e51:	8b 45 10             	mov    0x10(%ebp),%eax
  800e54:	ff 75 f4             	pushl  -0xc(%ebp)
  800e57:	50                   	push   %eax
  800e58:	ff 75 0c             	pushl  0xc(%ebp)
  800e5b:	ff 75 08             	pushl  0x8(%ebp)
  800e5e:	e8 89 ff ff ff       	call   800dec <vsnprintf>
  800e63:	83 c4 10             	add    $0x10,%esp
  800e66:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e6c:	c9                   	leave  
  800e6d:	c3                   	ret    

00800e6e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
  800e71:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e7b:	eb 06                	jmp    800e83 <strlen+0x15>
		n++;
  800e7d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e80:	ff 45 08             	incl   0x8(%ebp)
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	8a 00                	mov    (%eax),%al
  800e88:	84 c0                	test   %al,%al
  800e8a:	75 f1                	jne    800e7d <strlen+0xf>
		n++;
	return n;
  800e8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e8f:	c9                   	leave  
  800e90:	c3                   	ret    

00800e91 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e91:	55                   	push   %ebp
  800e92:	89 e5                	mov    %esp,%ebp
  800e94:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e9e:	eb 09                	jmp    800ea9 <strnlen+0x18>
		n++;
  800ea0:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ea3:	ff 45 08             	incl   0x8(%ebp)
  800ea6:	ff 4d 0c             	decl   0xc(%ebp)
  800ea9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ead:	74 09                	je     800eb8 <strnlen+0x27>
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	8a 00                	mov    (%eax),%al
  800eb4:	84 c0                	test   %al,%al
  800eb6:	75 e8                	jne    800ea0 <strnlen+0xf>
		n++;
	return n;
  800eb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ebb:	c9                   	leave  
  800ebc:	c3                   	ret    

00800ebd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ebd:	55                   	push   %ebp
  800ebe:	89 e5                	mov    %esp,%ebp
  800ec0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ec9:	90                   	nop
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	8d 50 01             	lea    0x1(%eax),%edx
  800ed0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ed3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ed9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800edc:	8a 12                	mov    (%edx),%dl
  800ede:	88 10                	mov    %dl,(%eax)
  800ee0:	8a 00                	mov    (%eax),%al
  800ee2:	84 c0                	test   %al,%al
  800ee4:	75 e4                	jne    800eca <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ee6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ee9:	c9                   	leave  
  800eea:	c3                   	ret    

00800eeb <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800eeb:	55                   	push   %ebp
  800eec:	89 e5                	mov    %esp,%ebp
  800eee:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ef7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800efe:	eb 1f                	jmp    800f1f <strncpy+0x34>
		*dst++ = *src;
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	8d 50 01             	lea    0x1(%eax),%edx
  800f06:	89 55 08             	mov    %edx,0x8(%ebp)
  800f09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f0c:	8a 12                	mov    (%edx),%dl
  800f0e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f13:	8a 00                	mov    (%eax),%al
  800f15:	84 c0                	test   %al,%al
  800f17:	74 03                	je     800f1c <strncpy+0x31>
			src++;
  800f19:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f1c:	ff 45 fc             	incl   -0x4(%ebp)
  800f1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f22:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f25:	72 d9                	jb     800f00 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f27:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f2a:	c9                   	leave  
  800f2b:	c3                   	ret    

00800f2c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f38:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3c:	74 30                	je     800f6e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f3e:	eb 16                	jmp    800f56 <strlcpy+0x2a>
			*dst++ = *src++;
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8d 50 01             	lea    0x1(%eax),%edx
  800f46:	89 55 08             	mov    %edx,0x8(%ebp)
  800f49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f4c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f4f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f52:	8a 12                	mov    (%edx),%dl
  800f54:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f56:	ff 4d 10             	decl   0x10(%ebp)
  800f59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5d:	74 09                	je     800f68 <strlcpy+0x3c>
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	84 c0                	test   %al,%al
  800f66:	75 d8                	jne    800f40 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f74:	29 c2                	sub    %eax,%edx
  800f76:	89 d0                	mov    %edx,%eax
}
  800f78:	c9                   	leave  
  800f79:	c3                   	ret    

00800f7a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f7d:	eb 06                	jmp    800f85 <strcmp+0xb>
		p++, q++;
  800f7f:	ff 45 08             	incl   0x8(%ebp)
  800f82:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	84 c0                	test   %al,%al
  800f8c:	74 0e                	je     800f9c <strcmp+0x22>
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	8a 10                	mov    (%eax),%dl
  800f93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	38 c2                	cmp    %al,%dl
  800f9a:	74 e3                	je     800f7f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	0f b6 d0             	movzbl %al,%edx
  800fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	0f b6 c0             	movzbl %al,%eax
  800fac:	29 c2                	sub    %eax,%edx
  800fae:	89 d0                	mov    %edx,%eax
}
  800fb0:	5d                   	pop    %ebp
  800fb1:	c3                   	ret    

00800fb2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fb2:	55                   	push   %ebp
  800fb3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fb5:	eb 09                	jmp    800fc0 <strncmp+0xe>
		n--, p++, q++;
  800fb7:	ff 4d 10             	decl   0x10(%ebp)
  800fba:	ff 45 08             	incl   0x8(%ebp)
  800fbd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fc0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc4:	74 17                	je     800fdd <strncmp+0x2b>
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	84 c0                	test   %al,%al
  800fcd:	74 0e                	je     800fdd <strncmp+0x2b>
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 10                	mov    (%eax),%dl
  800fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd7:	8a 00                	mov    (%eax),%al
  800fd9:	38 c2                	cmp    %al,%dl
  800fdb:	74 da                	je     800fb7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fdd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe1:	75 07                	jne    800fea <strncmp+0x38>
		return 0;
  800fe3:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe8:	eb 14                	jmp    800ffe <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	8a 00                	mov    (%eax),%al
  800fef:	0f b6 d0             	movzbl %al,%edx
  800ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff5:	8a 00                	mov    (%eax),%al
  800ff7:	0f b6 c0             	movzbl %al,%eax
  800ffa:	29 c2                	sub    %eax,%edx
  800ffc:	89 d0                	mov    %edx,%eax
}
  800ffe:	5d                   	pop    %ebp
  800fff:	c3                   	ret    

00801000 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 04             	sub    $0x4,%esp
  801006:	8b 45 0c             	mov    0xc(%ebp),%eax
  801009:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80100c:	eb 12                	jmp    801020 <strchr+0x20>
		if (*s == c)
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801016:	75 05                	jne    80101d <strchr+0x1d>
			return (char *) s;
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	eb 11                	jmp    80102e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80101d:	ff 45 08             	incl   0x8(%ebp)
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	84 c0                	test   %al,%al
  801027:	75 e5                	jne    80100e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801029:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80102e:	c9                   	leave  
  80102f:	c3                   	ret    

00801030 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
  801033:	83 ec 04             	sub    $0x4,%esp
  801036:	8b 45 0c             	mov    0xc(%ebp),%eax
  801039:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80103c:	eb 0d                	jmp    80104b <strfind+0x1b>
		if (*s == c)
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	8a 00                	mov    (%eax),%al
  801043:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801046:	74 0e                	je     801056 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801048:	ff 45 08             	incl   0x8(%ebp)
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	84 c0                	test   %al,%al
  801052:	75 ea                	jne    80103e <strfind+0xe>
  801054:	eb 01                	jmp    801057 <strfind+0x27>
		if (*s == c)
			break;
  801056:	90                   	nop
	return (char *) s;
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80105a:	c9                   	leave  
  80105b:	c3                   	ret    

0080105c <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
  80105f:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801068:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80106c:	76 63                	jbe    8010d1 <memset+0x75>
		uint64 data_block = c;
  80106e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801071:	99                   	cltd   
  801072:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801075:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80107b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80107e:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801082:	c1 e0 08             	shl    $0x8,%eax
  801085:	09 45 f0             	or     %eax,-0x10(%ebp)
  801088:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80108b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80108e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801091:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801095:	c1 e0 10             	shl    $0x10,%eax
  801098:	09 45 f0             	or     %eax,-0x10(%ebp)
  80109b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80109e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a4:	89 c2                	mov    %eax,%edx
  8010a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ab:	09 45 f0             	or     %eax,-0x10(%ebp)
  8010ae:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8010b1:	eb 18                	jmp    8010cb <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8010b3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010b6:	8d 41 08             	lea    0x8(%ecx),%eax
  8010b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8010bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c2:	89 01                	mov    %eax,(%ecx)
  8010c4:	89 51 04             	mov    %edx,0x4(%ecx)
  8010c7:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8010cb:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010cf:	77 e2                	ja     8010b3 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8010d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d5:	74 23                	je     8010fa <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8010d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010da:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010dd:	eb 0e                	jmp    8010ed <memset+0x91>
			*p8++ = (uint8)c;
  8010df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e2:	8d 50 01             	lea    0x1(%eax),%edx
  8010e5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010eb:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f6:	85 c0                	test   %eax,%eax
  8010f8:	75 e5                	jne    8010df <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010fd:	c9                   	leave  
  8010fe:	c3                   	ret    

008010ff <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010ff:	55                   	push   %ebp
  801100:	89 e5                	mov    %esp,%ebp
  801102:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801105:	8b 45 0c             	mov    0xc(%ebp),%eax
  801108:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801111:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801115:	76 24                	jbe    80113b <memcpy+0x3c>
		while(n >= 8){
  801117:	eb 1c                	jmp    801135 <memcpy+0x36>
			*d64 = *s64;
  801119:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111c:	8b 50 04             	mov    0x4(%eax),%edx
  80111f:	8b 00                	mov    (%eax),%eax
  801121:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801124:	89 01                	mov    %eax,(%ecx)
  801126:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801129:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80112d:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801131:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801135:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801139:	77 de                	ja     801119 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80113b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80113f:	74 31                	je     801172 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801141:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801144:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801147:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80114a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80114d:	eb 16                	jmp    801165 <memcpy+0x66>
			*d8++ = *s8++;
  80114f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801152:	8d 50 01             	lea    0x1(%eax),%edx
  801155:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801158:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80115b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80115e:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801161:	8a 12                	mov    (%edx),%dl
  801163:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801165:	8b 45 10             	mov    0x10(%ebp),%eax
  801168:	8d 50 ff             	lea    -0x1(%eax),%edx
  80116b:	89 55 10             	mov    %edx,0x10(%ebp)
  80116e:	85 c0                	test   %eax,%eax
  801170:	75 dd                	jne    80114f <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801172:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801175:	c9                   	leave  
  801176:	c3                   	ret    

00801177 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
  80117a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80117d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801180:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801189:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80118f:	73 50                	jae    8011e1 <memmove+0x6a>
  801191:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801194:	8b 45 10             	mov    0x10(%ebp),%eax
  801197:	01 d0                	add    %edx,%eax
  801199:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80119c:	76 43                	jbe    8011e1 <memmove+0x6a>
		s += n;
  80119e:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8011a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8011aa:	eb 10                	jmp    8011bc <memmove+0x45>
			*--d = *--s;
  8011ac:	ff 4d f8             	decl   -0x8(%ebp)
  8011af:	ff 4d fc             	decl   -0x4(%ebp)
  8011b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b5:	8a 10                	mov    (%eax),%dl
  8011b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ba:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8011bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011c2:	89 55 10             	mov    %edx,0x10(%ebp)
  8011c5:	85 c0                	test   %eax,%eax
  8011c7:	75 e3                	jne    8011ac <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011c9:	eb 23                	jmp    8011ee <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ce:	8d 50 01             	lea    0x1(%eax),%edx
  8011d1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011da:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011dd:	8a 12                	mov    (%edx),%dl
  8011df:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011e7:	89 55 10             	mov    %edx,0x10(%ebp)
  8011ea:	85 c0                	test   %eax,%eax
  8011ec:	75 dd                	jne    8011cb <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011f1:	c9                   	leave  
  8011f2:	c3                   	ret    

008011f3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801202:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801205:	eb 2a                	jmp    801231 <memcmp+0x3e>
		if (*s1 != *s2)
  801207:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80120a:	8a 10                	mov    (%eax),%dl
  80120c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	38 c2                	cmp    %al,%dl
  801213:	74 16                	je     80122b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801215:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	0f b6 d0             	movzbl %al,%edx
  80121d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801220:	8a 00                	mov    (%eax),%al
  801222:	0f b6 c0             	movzbl %al,%eax
  801225:	29 c2                	sub    %eax,%edx
  801227:	89 d0                	mov    %edx,%eax
  801229:	eb 18                	jmp    801243 <memcmp+0x50>
		s1++, s2++;
  80122b:	ff 45 fc             	incl   -0x4(%ebp)
  80122e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801231:	8b 45 10             	mov    0x10(%ebp),%eax
  801234:	8d 50 ff             	lea    -0x1(%eax),%edx
  801237:	89 55 10             	mov    %edx,0x10(%ebp)
  80123a:	85 c0                	test   %eax,%eax
  80123c:	75 c9                	jne    801207 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80123e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801243:	c9                   	leave  
  801244:	c3                   	ret    

00801245 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
  801248:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80124b:	8b 55 08             	mov    0x8(%ebp),%edx
  80124e:	8b 45 10             	mov    0x10(%ebp),%eax
  801251:	01 d0                	add    %edx,%eax
  801253:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801256:	eb 15                	jmp    80126d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	0f b6 d0             	movzbl %al,%edx
  801260:	8b 45 0c             	mov    0xc(%ebp),%eax
  801263:	0f b6 c0             	movzbl %al,%eax
  801266:	39 c2                	cmp    %eax,%edx
  801268:	74 0d                	je     801277 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80126a:	ff 45 08             	incl   0x8(%ebp)
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801273:	72 e3                	jb     801258 <memfind+0x13>
  801275:	eb 01                	jmp    801278 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801277:	90                   	nop
	return (void *) s;
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80127b:	c9                   	leave  
  80127c:	c3                   	ret    

0080127d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801283:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80128a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801291:	eb 03                	jmp    801296 <strtol+0x19>
		s++;
  801293:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801296:	8b 45 08             	mov    0x8(%ebp),%eax
  801299:	8a 00                	mov    (%eax),%al
  80129b:	3c 20                	cmp    $0x20,%al
  80129d:	74 f4                	je     801293 <strtol+0x16>
  80129f:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a2:	8a 00                	mov    (%eax),%al
  8012a4:	3c 09                	cmp    $0x9,%al
  8012a6:	74 eb                	je     801293 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ab:	8a 00                	mov    (%eax),%al
  8012ad:	3c 2b                	cmp    $0x2b,%al
  8012af:	75 05                	jne    8012b6 <strtol+0x39>
		s++;
  8012b1:	ff 45 08             	incl   0x8(%ebp)
  8012b4:	eb 13                	jmp    8012c9 <strtol+0x4c>
	else if (*s == '-')
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	8a 00                	mov    (%eax),%al
  8012bb:	3c 2d                	cmp    $0x2d,%al
  8012bd:	75 0a                	jne    8012c9 <strtol+0x4c>
		s++, neg = 1;
  8012bf:	ff 45 08             	incl   0x8(%ebp)
  8012c2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012cd:	74 06                	je     8012d5 <strtol+0x58>
  8012cf:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012d3:	75 20                	jne    8012f5 <strtol+0x78>
  8012d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d8:	8a 00                	mov    (%eax),%al
  8012da:	3c 30                	cmp    $0x30,%al
  8012dc:	75 17                	jne    8012f5 <strtol+0x78>
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	40                   	inc    %eax
  8012e2:	8a 00                	mov    (%eax),%al
  8012e4:	3c 78                	cmp    $0x78,%al
  8012e6:	75 0d                	jne    8012f5 <strtol+0x78>
		s += 2, base = 16;
  8012e8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012ec:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012f3:	eb 28                	jmp    80131d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012f5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012f9:	75 15                	jne    801310 <strtol+0x93>
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	8a 00                	mov    (%eax),%al
  801300:	3c 30                	cmp    $0x30,%al
  801302:	75 0c                	jne    801310 <strtol+0x93>
		s++, base = 8;
  801304:	ff 45 08             	incl   0x8(%ebp)
  801307:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80130e:	eb 0d                	jmp    80131d <strtol+0xa0>
	else if (base == 0)
  801310:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801314:	75 07                	jne    80131d <strtol+0xa0>
		base = 10;
  801316:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80131d:	8b 45 08             	mov    0x8(%ebp),%eax
  801320:	8a 00                	mov    (%eax),%al
  801322:	3c 2f                	cmp    $0x2f,%al
  801324:	7e 19                	jle    80133f <strtol+0xc2>
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	8a 00                	mov    (%eax),%al
  80132b:	3c 39                	cmp    $0x39,%al
  80132d:	7f 10                	jg     80133f <strtol+0xc2>
			dig = *s - '0';
  80132f:	8b 45 08             	mov    0x8(%ebp),%eax
  801332:	8a 00                	mov    (%eax),%al
  801334:	0f be c0             	movsbl %al,%eax
  801337:	83 e8 30             	sub    $0x30,%eax
  80133a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80133d:	eb 42                	jmp    801381 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	8a 00                	mov    (%eax),%al
  801344:	3c 60                	cmp    $0x60,%al
  801346:	7e 19                	jle    801361 <strtol+0xe4>
  801348:	8b 45 08             	mov    0x8(%ebp),%eax
  80134b:	8a 00                	mov    (%eax),%al
  80134d:	3c 7a                	cmp    $0x7a,%al
  80134f:	7f 10                	jg     801361 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	8a 00                	mov    (%eax),%al
  801356:	0f be c0             	movsbl %al,%eax
  801359:	83 e8 57             	sub    $0x57,%eax
  80135c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80135f:	eb 20                	jmp    801381 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801361:	8b 45 08             	mov    0x8(%ebp),%eax
  801364:	8a 00                	mov    (%eax),%al
  801366:	3c 40                	cmp    $0x40,%al
  801368:	7e 39                	jle    8013a3 <strtol+0x126>
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	8a 00                	mov    (%eax),%al
  80136f:	3c 5a                	cmp    $0x5a,%al
  801371:	7f 30                	jg     8013a3 <strtol+0x126>
			dig = *s - 'A' + 10;
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	8a 00                	mov    (%eax),%al
  801378:	0f be c0             	movsbl %al,%eax
  80137b:	83 e8 37             	sub    $0x37,%eax
  80137e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801384:	3b 45 10             	cmp    0x10(%ebp),%eax
  801387:	7d 19                	jge    8013a2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801389:	ff 45 08             	incl   0x8(%ebp)
  80138c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80138f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801393:	89 c2                	mov    %eax,%edx
  801395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801398:	01 d0                	add    %edx,%eax
  80139a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80139d:	e9 7b ff ff ff       	jmp    80131d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8013a2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8013a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013a7:	74 08                	je     8013b1 <strtol+0x134>
		*endptr = (char *) s;
  8013a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8013af:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8013b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013b5:	74 07                	je     8013be <strtol+0x141>
  8013b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ba:	f7 d8                	neg    %eax
  8013bc:	eb 03                	jmp    8013c1 <strtol+0x144>
  8013be:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013c1:	c9                   	leave  
  8013c2:	c3                   	ret    

008013c3 <ltostr>:

void
ltostr(long value, char *str)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
  8013c6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8013c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013d0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013db:	79 13                	jns    8013f0 <ltostr+0x2d>
	{
		neg = 1;
  8013dd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013ea:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013ed:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013f8:	99                   	cltd   
  8013f9:	f7 f9                	idiv   %ecx
  8013fb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801401:	8d 50 01             	lea    0x1(%eax),%edx
  801404:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801407:	89 c2                	mov    %eax,%edx
  801409:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140c:	01 d0                	add    %edx,%eax
  80140e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801411:	83 c2 30             	add    $0x30,%edx
  801414:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801416:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801419:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80141e:	f7 e9                	imul   %ecx
  801420:	c1 fa 02             	sar    $0x2,%edx
  801423:	89 c8                	mov    %ecx,%eax
  801425:	c1 f8 1f             	sar    $0x1f,%eax
  801428:	29 c2                	sub    %eax,%edx
  80142a:	89 d0                	mov    %edx,%eax
  80142c:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80142f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801433:	75 bb                	jne    8013f0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801435:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80143c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80143f:	48                   	dec    %eax
  801440:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801443:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801447:	74 3d                	je     801486 <ltostr+0xc3>
		start = 1 ;
  801449:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801450:	eb 34                	jmp    801486 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801452:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801455:	8b 45 0c             	mov    0xc(%ebp),%eax
  801458:	01 d0                	add    %edx,%eax
  80145a:	8a 00                	mov    (%eax),%al
  80145c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80145f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801462:	8b 45 0c             	mov    0xc(%ebp),%eax
  801465:	01 c2                	add    %eax,%edx
  801467:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80146a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146d:	01 c8                	add    %ecx,%eax
  80146f:	8a 00                	mov    (%eax),%al
  801471:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801473:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801476:	8b 45 0c             	mov    0xc(%ebp),%eax
  801479:	01 c2                	add    %eax,%edx
  80147b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80147e:	88 02                	mov    %al,(%edx)
		start++ ;
  801480:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801483:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801489:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80148c:	7c c4                	jl     801452 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80148e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801491:	8b 45 0c             	mov    0xc(%ebp),%eax
  801494:	01 d0                	add    %edx,%eax
  801496:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801499:	90                   	nop
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8014a2:	ff 75 08             	pushl  0x8(%ebp)
  8014a5:	e8 c4 f9 ff ff       	call   800e6e <strlen>
  8014aa:	83 c4 04             	add    $0x4,%esp
  8014ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	e8 b6 f9 ff ff       	call   800e6e <strlen>
  8014b8:	83 c4 04             	add    $0x4,%esp
  8014bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8014be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014cc:	eb 17                	jmp    8014e5 <strcconcat+0x49>
		final[s] = str1[s] ;
  8014ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d4:	01 c2                	add    %eax,%edx
  8014d6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	01 c8                	add    %ecx,%eax
  8014de:	8a 00                	mov    (%eax),%al
  8014e0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014e2:	ff 45 fc             	incl   -0x4(%ebp)
  8014e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014eb:	7c e1                	jl     8014ce <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014ed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014fb:	eb 1f                	jmp    80151c <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801500:	8d 50 01             	lea    0x1(%eax),%edx
  801503:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801506:	89 c2                	mov    %eax,%edx
  801508:	8b 45 10             	mov    0x10(%ebp),%eax
  80150b:	01 c2                	add    %eax,%edx
  80150d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801510:	8b 45 0c             	mov    0xc(%ebp),%eax
  801513:	01 c8                	add    %ecx,%eax
  801515:	8a 00                	mov    (%eax),%al
  801517:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801519:	ff 45 f8             	incl   -0x8(%ebp)
  80151c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80151f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801522:	7c d9                	jl     8014fd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801524:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801527:	8b 45 10             	mov    0x10(%ebp),%eax
  80152a:	01 d0                	add    %edx,%eax
  80152c:	c6 00 00             	movb   $0x0,(%eax)
}
  80152f:	90                   	nop
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801535:	8b 45 14             	mov    0x14(%ebp),%eax
  801538:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80153e:	8b 45 14             	mov    0x14(%ebp),%eax
  801541:	8b 00                	mov    (%eax),%eax
  801543:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80154a:	8b 45 10             	mov    0x10(%ebp),%eax
  80154d:	01 d0                	add    %edx,%eax
  80154f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801555:	eb 0c                	jmp    801563 <strsplit+0x31>
			*string++ = 0;
  801557:	8b 45 08             	mov    0x8(%ebp),%eax
  80155a:	8d 50 01             	lea    0x1(%eax),%edx
  80155d:	89 55 08             	mov    %edx,0x8(%ebp)
  801560:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801563:	8b 45 08             	mov    0x8(%ebp),%eax
  801566:	8a 00                	mov    (%eax),%al
  801568:	84 c0                	test   %al,%al
  80156a:	74 18                	je     801584 <strsplit+0x52>
  80156c:	8b 45 08             	mov    0x8(%ebp),%eax
  80156f:	8a 00                	mov    (%eax),%al
  801571:	0f be c0             	movsbl %al,%eax
  801574:	50                   	push   %eax
  801575:	ff 75 0c             	pushl  0xc(%ebp)
  801578:	e8 83 fa ff ff       	call   801000 <strchr>
  80157d:	83 c4 08             	add    $0x8,%esp
  801580:	85 c0                	test   %eax,%eax
  801582:	75 d3                	jne    801557 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
  801587:	8a 00                	mov    (%eax),%al
  801589:	84 c0                	test   %al,%al
  80158b:	74 5a                	je     8015e7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80158d:	8b 45 14             	mov    0x14(%ebp),%eax
  801590:	8b 00                	mov    (%eax),%eax
  801592:	83 f8 0f             	cmp    $0xf,%eax
  801595:	75 07                	jne    80159e <strsplit+0x6c>
		{
			return 0;
  801597:	b8 00 00 00 00       	mov    $0x0,%eax
  80159c:	eb 66                	jmp    801604 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80159e:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a1:	8b 00                	mov    (%eax),%eax
  8015a3:	8d 48 01             	lea    0x1(%eax),%ecx
  8015a6:	8b 55 14             	mov    0x14(%ebp),%edx
  8015a9:	89 0a                	mov    %ecx,(%edx)
  8015ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b5:	01 c2                	add    %eax,%edx
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ba:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015bc:	eb 03                	jmp    8015c1 <strsplit+0x8f>
			string++;
  8015be:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c4:	8a 00                	mov    (%eax),%al
  8015c6:	84 c0                	test   %al,%al
  8015c8:	74 8b                	je     801555 <strsplit+0x23>
  8015ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cd:	8a 00                	mov    (%eax),%al
  8015cf:	0f be c0             	movsbl %al,%eax
  8015d2:	50                   	push   %eax
  8015d3:	ff 75 0c             	pushl  0xc(%ebp)
  8015d6:	e8 25 fa ff ff       	call   801000 <strchr>
  8015db:	83 c4 08             	add    $0x8,%esp
  8015de:	85 c0                	test   %eax,%eax
  8015e0:	74 dc                	je     8015be <strsplit+0x8c>
			string++;
	}
  8015e2:	e9 6e ff ff ff       	jmp    801555 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015e7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8015eb:	8b 00                	mov    (%eax),%eax
  8015ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f7:	01 d0                	add    %edx,%eax
  8015f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015ff:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801604:	c9                   	leave  
  801605:	c3                   	ret    

00801606 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801612:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801619:	eb 4a                	jmp    801665 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80161b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80161e:	8b 45 08             	mov    0x8(%ebp),%eax
  801621:	01 c2                	add    %eax,%edx
  801623:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801626:	8b 45 0c             	mov    0xc(%ebp),%eax
  801629:	01 c8                	add    %ecx,%eax
  80162b:	8a 00                	mov    (%eax),%al
  80162d:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80162f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801632:	8b 45 0c             	mov    0xc(%ebp),%eax
  801635:	01 d0                	add    %edx,%eax
  801637:	8a 00                	mov    (%eax),%al
  801639:	3c 40                	cmp    $0x40,%al
  80163b:	7e 25                	jle    801662 <str2lower+0x5c>
  80163d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801640:	8b 45 0c             	mov    0xc(%ebp),%eax
  801643:	01 d0                	add    %edx,%eax
  801645:	8a 00                	mov    (%eax),%al
  801647:	3c 5a                	cmp    $0x5a,%al
  801649:	7f 17                	jg     801662 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80164b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	01 d0                	add    %edx,%eax
  801653:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801656:	8b 55 08             	mov    0x8(%ebp),%edx
  801659:	01 ca                	add    %ecx,%edx
  80165b:	8a 12                	mov    (%edx),%dl
  80165d:	83 c2 20             	add    $0x20,%edx
  801660:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801662:	ff 45 fc             	incl   -0x4(%ebp)
  801665:	ff 75 0c             	pushl  0xc(%ebp)
  801668:	e8 01 f8 ff ff       	call   800e6e <strlen>
  80166d:	83 c4 04             	add    $0x4,%esp
  801670:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801673:	7f a6                	jg     80161b <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801675:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801678:	c9                   	leave  
  801679:	c3                   	ret    

0080167a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	57                   	push   %edi
  80167e:	56                   	push   %esi
  80167f:	53                   	push   %ebx
  801680:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	8b 55 0c             	mov    0xc(%ebp),%edx
  801689:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80168c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80168f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801692:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801695:	cd 30                	int    $0x30
  801697:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80169a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80169d:	83 c4 10             	add    $0x10,%esp
  8016a0:	5b                   	pop    %ebx
  8016a1:	5e                   	pop    %esi
  8016a2:	5f                   	pop    %edi
  8016a3:	5d                   	pop    %ebp
  8016a4:	c3                   	ret    

008016a5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
  8016a8:	83 ec 04             	sub    $0x4,%esp
  8016ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ae:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8016b1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016b4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bb:	6a 00                	push   $0x0
  8016bd:	51                   	push   %ecx
  8016be:	52                   	push   %edx
  8016bf:	ff 75 0c             	pushl  0xc(%ebp)
  8016c2:	50                   	push   %eax
  8016c3:	6a 00                	push   $0x0
  8016c5:	e8 b0 ff ff ff       	call   80167a <syscall>
  8016ca:	83 c4 18             	add    $0x18,%esp
}
  8016cd:	90                   	nop
  8016ce:	c9                   	leave  
  8016cf:	c3                   	ret    

008016d0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 02                	push   $0x2
  8016df:	e8 96 ff ff ff       	call   80167a <syscall>
  8016e4:	83 c4 18             	add    $0x18,%esp
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 03                	push   $0x3
  8016f8:	e8 7d ff ff ff       	call   80167a <syscall>
  8016fd:	83 c4 18             	add    $0x18,%esp
}
  801700:	90                   	nop
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 04                	push   $0x4
  801712:	e8 63 ff ff ff       	call   80167a <syscall>
  801717:	83 c4 18             	add    $0x18,%esp
}
  80171a:	90                   	nop
  80171b:	c9                   	leave  
  80171c:	c3                   	ret    

0080171d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801720:	8b 55 0c             	mov    0xc(%ebp),%edx
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	52                   	push   %edx
  80172d:	50                   	push   %eax
  80172e:	6a 08                	push   $0x8
  801730:	e8 45 ff ff ff       	call   80167a <syscall>
  801735:	83 c4 18             	add    $0x18,%esp
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	56                   	push   %esi
  80173e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80173f:	8b 75 18             	mov    0x18(%ebp),%esi
  801742:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801745:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801748:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	56                   	push   %esi
  80174f:	53                   	push   %ebx
  801750:	51                   	push   %ecx
  801751:	52                   	push   %edx
  801752:	50                   	push   %eax
  801753:	6a 09                	push   $0x9
  801755:	e8 20 ff ff ff       	call   80167a <syscall>
  80175a:	83 c4 18             	add    $0x18,%esp
}
  80175d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801760:	5b                   	pop    %ebx
  801761:	5e                   	pop    %esi
  801762:	5d                   	pop    %ebp
  801763:	c3                   	ret    

00801764 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	ff 75 08             	pushl  0x8(%ebp)
  801772:	6a 0a                	push   $0xa
  801774:	e8 01 ff ff ff       	call   80167a <syscall>
  801779:	83 c4 18             	add    $0x18,%esp
}
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    

0080177e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	ff 75 0c             	pushl  0xc(%ebp)
  80178a:	ff 75 08             	pushl  0x8(%ebp)
  80178d:	6a 0b                	push   $0xb
  80178f:	e8 e6 fe ff ff       	call   80167a <syscall>
  801794:	83 c4 18             	add    $0x18,%esp
}
  801797:	c9                   	leave  
  801798:	c3                   	ret    

00801799 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801799:	55                   	push   %ebp
  80179a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 0c                	push   $0xc
  8017a8:	e8 cd fe ff ff       	call   80167a <syscall>
  8017ad:	83 c4 18             	add    $0x18,%esp
}
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    

008017b2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 0d                	push   $0xd
  8017c1:	e8 b4 fe ff ff       	call   80167a <syscall>
  8017c6:	83 c4 18             	add    $0x18,%esp
}
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 0e                	push   $0xe
  8017da:	e8 9b fe ff ff       	call   80167a <syscall>
  8017df:	83 c4 18             	add    $0x18,%esp
}
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    

008017e4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 0f                	push   $0xf
  8017f3:	e8 82 fe ff ff       	call   80167a <syscall>
  8017f8:	83 c4 18             	add    $0x18,%esp
}
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	ff 75 08             	pushl  0x8(%ebp)
  80180b:	6a 10                	push   $0x10
  80180d:	e8 68 fe ff ff       	call   80167a <syscall>
  801812:	83 c4 18             	add    $0x18,%esp
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 11                	push   $0x11
  801826:	e8 4f fe ff ff       	call   80167a <syscall>
  80182b:	83 c4 18             	add    $0x18,%esp
}
  80182e:	90                   	nop
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sys_cputc>:

void
sys_cputc(const char c)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
  801834:	83 ec 04             	sub    $0x4,%esp
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80183d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	50                   	push   %eax
  80184a:	6a 01                	push   $0x1
  80184c:	e8 29 fe ff ff       	call   80167a <syscall>
  801851:	83 c4 18             	add    $0x18,%esp
}
  801854:	90                   	nop
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 14                	push   $0x14
  801866:	e8 0f fe ff ff       	call   80167a <syscall>
  80186b:	83 c4 18             	add    $0x18,%esp
}
  80186e:	90                   	nop
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
  801874:	83 ec 04             	sub    $0x4,%esp
  801877:	8b 45 10             	mov    0x10(%ebp),%eax
  80187a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80187d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801880:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801884:	8b 45 08             	mov    0x8(%ebp),%eax
  801887:	6a 00                	push   $0x0
  801889:	51                   	push   %ecx
  80188a:	52                   	push   %edx
  80188b:	ff 75 0c             	pushl  0xc(%ebp)
  80188e:	50                   	push   %eax
  80188f:	6a 15                	push   $0x15
  801891:	e8 e4 fd ff ff       	call   80167a <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80189e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	52                   	push   %edx
  8018ab:	50                   	push   %eax
  8018ac:	6a 16                	push   $0x16
  8018ae:	e8 c7 fd ff ff       	call   80167a <syscall>
  8018b3:	83 c4 18             	add    $0x18,%esp
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	51                   	push   %ecx
  8018c9:	52                   	push   %edx
  8018ca:	50                   	push   %eax
  8018cb:	6a 17                	push   $0x17
  8018cd:	e8 a8 fd ff ff       	call   80167a <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
}
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	52                   	push   %edx
  8018e7:	50                   	push   %eax
  8018e8:	6a 18                	push   $0x18
  8018ea:	e8 8b fd ff ff       	call   80167a <syscall>
  8018ef:	83 c4 18             	add    $0x18,%esp
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	6a 00                	push   $0x0
  8018fc:	ff 75 14             	pushl  0x14(%ebp)
  8018ff:	ff 75 10             	pushl  0x10(%ebp)
  801902:	ff 75 0c             	pushl  0xc(%ebp)
  801905:	50                   	push   %eax
  801906:	6a 19                	push   $0x19
  801908:	e8 6d fd ff ff       	call   80167a <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	50                   	push   %eax
  801921:	6a 1a                	push   $0x1a
  801923:	e8 52 fd ff ff       	call   80167a <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
}
  80192b:	90                   	nop
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801931:	8b 45 08             	mov    0x8(%ebp),%eax
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	50                   	push   %eax
  80193d:	6a 1b                	push   $0x1b
  80193f:	e8 36 fd ff ff       	call   80167a <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
}
  801947:	c9                   	leave  
  801948:	c3                   	ret    

00801949 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 05                	push   $0x5
  801958:	e8 1d fd ff ff       	call   80167a <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 06                	push   $0x6
  801971:	e8 04 fd ff ff       	call   80167a <syscall>
  801976:	83 c4 18             	add    $0x18,%esp
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 07                	push   $0x7
  80198a:	e8 eb fc ff ff       	call   80167a <syscall>
  80198f:	83 c4 18             	add    $0x18,%esp
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_exit_env>:


void sys_exit_env(void)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 1c                	push   $0x1c
  8019a3:	e8 d2 fc ff ff       	call   80167a <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
}
  8019ab:	90                   	nop
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
  8019b1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019b4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019b7:	8d 50 04             	lea    0x4(%eax),%edx
  8019ba:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	52                   	push   %edx
  8019c4:	50                   	push   %eax
  8019c5:	6a 1d                	push   $0x1d
  8019c7:	e8 ae fc ff ff       	call   80167a <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
	return result;
  8019cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019d8:	89 01                	mov    %eax,(%ecx)
  8019da:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	c9                   	leave  
  8019e1:	c2 04 00             	ret    $0x4

008019e4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	ff 75 10             	pushl  0x10(%ebp)
  8019ee:	ff 75 0c             	pushl  0xc(%ebp)
  8019f1:	ff 75 08             	pushl  0x8(%ebp)
  8019f4:	6a 13                	push   $0x13
  8019f6:	e8 7f fc ff ff       	call   80167a <syscall>
  8019fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8019fe:	90                   	nop
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 1e                	push   $0x1e
  801a10:	e8 65 fc ff ff       	call   80167a <syscall>
  801a15:	83 c4 18             	add    $0x18,%esp
}
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	83 ec 04             	sub    $0x4,%esp
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a26:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	50                   	push   %eax
  801a33:	6a 1f                	push   $0x1f
  801a35:	e8 40 fc ff ff       	call   80167a <syscall>
  801a3a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3d:	90                   	nop
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <rsttst>:
void rsttst()
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 21                	push   $0x21
  801a4f:	e8 26 fc ff ff       	call   80167a <syscall>
  801a54:	83 c4 18             	add    $0x18,%esp
	return ;
  801a57:	90                   	nop
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	83 ec 04             	sub    $0x4,%esp
  801a60:	8b 45 14             	mov    0x14(%ebp),%eax
  801a63:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a66:	8b 55 18             	mov    0x18(%ebp),%edx
  801a69:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a6d:	52                   	push   %edx
  801a6e:	50                   	push   %eax
  801a6f:	ff 75 10             	pushl  0x10(%ebp)
  801a72:	ff 75 0c             	pushl  0xc(%ebp)
  801a75:	ff 75 08             	pushl  0x8(%ebp)
  801a78:	6a 20                	push   $0x20
  801a7a:	e8 fb fb ff ff       	call   80167a <syscall>
  801a7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a82:	90                   	nop
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <chktst>:
void chktst(uint32 n)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	ff 75 08             	pushl  0x8(%ebp)
  801a93:	6a 22                	push   $0x22
  801a95:	e8 e0 fb ff ff       	call   80167a <syscall>
  801a9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a9d:	90                   	nop
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <inctst>:

void inctst()
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 23                	push   $0x23
  801aaf:	e8 c6 fb ff ff       	call   80167a <syscall>
  801ab4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab7:	90                   	nop
}
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <gettst>:
uint32 gettst()
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 24                	push   $0x24
  801ac9:	e8 ac fb ff ff       	call   80167a <syscall>
  801ace:	83 c4 18             	add    $0x18,%esp
}
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 25                	push   $0x25
  801ae2:	e8 93 fb ff ff       	call   80167a <syscall>
  801ae7:	83 c4 18             	add    $0x18,%esp
  801aea:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801aef:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801af9:	8b 45 08             	mov    0x8(%ebp),%eax
  801afc:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	ff 75 08             	pushl  0x8(%ebp)
  801b0c:	6a 26                	push   $0x26
  801b0e:	e8 67 fb ff ff       	call   80167a <syscall>
  801b13:	83 c4 18             	add    $0x18,%esp
	return ;
  801b16:	90                   	nop
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b1d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b20:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	6a 00                	push   $0x0
  801b2b:	53                   	push   %ebx
  801b2c:	51                   	push   %ecx
  801b2d:	52                   	push   %edx
  801b2e:	50                   	push   %eax
  801b2f:	6a 27                	push   $0x27
  801b31:	e8 44 fb ff ff       	call   80167a <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	52                   	push   %edx
  801b4e:	50                   	push   %eax
  801b4f:	6a 28                	push   $0x28
  801b51:	e8 24 fb ff ff       	call   80167a <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b5e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	6a 00                	push   $0x0
  801b69:	51                   	push   %ecx
  801b6a:	ff 75 10             	pushl  0x10(%ebp)
  801b6d:	52                   	push   %edx
  801b6e:	50                   	push   %eax
  801b6f:	6a 29                	push   $0x29
  801b71:	e8 04 fb ff ff       	call   80167a <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	ff 75 10             	pushl  0x10(%ebp)
  801b85:	ff 75 0c             	pushl  0xc(%ebp)
  801b88:	ff 75 08             	pushl  0x8(%ebp)
  801b8b:	6a 12                	push   $0x12
  801b8d:	e8 e8 fa ff ff       	call   80167a <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
	return ;
  801b95:	90                   	nop
}
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	52                   	push   %edx
  801ba8:	50                   	push   %eax
  801ba9:	6a 2a                	push   $0x2a
  801bab:	e8 ca fa ff ff       	call   80167a <syscall>
  801bb0:	83 c4 18             	add    $0x18,%esp
	return;
  801bb3:	90                   	nop
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 2b                	push   $0x2b
  801bc5:	e8 b0 fa ff ff       	call   80167a <syscall>
  801bca:	83 c4 18             	add    $0x18,%esp
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	ff 75 0c             	pushl  0xc(%ebp)
  801bdb:	ff 75 08             	pushl  0x8(%ebp)
  801bde:	6a 2d                	push   $0x2d
  801be0:	e8 95 fa ff ff       	call   80167a <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
	return;
  801be8:	90                   	nop
}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	ff 75 0c             	pushl  0xc(%ebp)
  801bf7:	ff 75 08             	pushl  0x8(%ebp)
  801bfa:	6a 2c                	push   $0x2c
  801bfc:	e8 79 fa ff ff       	call   80167a <syscall>
  801c01:	83 c4 18             	add    $0x18,%esp
	return ;
  801c04:	90                   	nop
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801c0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	52                   	push   %edx
  801c17:	50                   	push   %eax
  801c18:	6a 2e                	push   $0x2e
  801c1a:	e8 5b fa ff ff       	call   80167a <syscall>
  801c1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c22:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    
  801c25:	66 90                	xchg   %ax,%ax
  801c27:	90                   	nop

00801c28 <__udivdi3>:
  801c28:	55                   	push   %ebp
  801c29:	57                   	push   %edi
  801c2a:	56                   	push   %esi
  801c2b:	53                   	push   %ebx
  801c2c:	83 ec 1c             	sub    $0x1c,%esp
  801c2f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c33:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c3b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c3f:	89 ca                	mov    %ecx,%edx
  801c41:	89 f8                	mov    %edi,%eax
  801c43:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c47:	85 f6                	test   %esi,%esi
  801c49:	75 2d                	jne    801c78 <__udivdi3+0x50>
  801c4b:	39 cf                	cmp    %ecx,%edi
  801c4d:	77 65                	ja     801cb4 <__udivdi3+0x8c>
  801c4f:	89 fd                	mov    %edi,%ebp
  801c51:	85 ff                	test   %edi,%edi
  801c53:	75 0b                	jne    801c60 <__udivdi3+0x38>
  801c55:	b8 01 00 00 00       	mov    $0x1,%eax
  801c5a:	31 d2                	xor    %edx,%edx
  801c5c:	f7 f7                	div    %edi
  801c5e:	89 c5                	mov    %eax,%ebp
  801c60:	31 d2                	xor    %edx,%edx
  801c62:	89 c8                	mov    %ecx,%eax
  801c64:	f7 f5                	div    %ebp
  801c66:	89 c1                	mov    %eax,%ecx
  801c68:	89 d8                	mov    %ebx,%eax
  801c6a:	f7 f5                	div    %ebp
  801c6c:	89 cf                	mov    %ecx,%edi
  801c6e:	89 fa                	mov    %edi,%edx
  801c70:	83 c4 1c             	add    $0x1c,%esp
  801c73:	5b                   	pop    %ebx
  801c74:	5e                   	pop    %esi
  801c75:	5f                   	pop    %edi
  801c76:	5d                   	pop    %ebp
  801c77:	c3                   	ret    
  801c78:	39 ce                	cmp    %ecx,%esi
  801c7a:	77 28                	ja     801ca4 <__udivdi3+0x7c>
  801c7c:	0f bd fe             	bsr    %esi,%edi
  801c7f:	83 f7 1f             	xor    $0x1f,%edi
  801c82:	75 40                	jne    801cc4 <__udivdi3+0x9c>
  801c84:	39 ce                	cmp    %ecx,%esi
  801c86:	72 0a                	jb     801c92 <__udivdi3+0x6a>
  801c88:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c8c:	0f 87 9e 00 00 00    	ja     801d30 <__udivdi3+0x108>
  801c92:	b8 01 00 00 00       	mov    $0x1,%eax
  801c97:	89 fa                	mov    %edi,%edx
  801c99:	83 c4 1c             	add    $0x1c,%esp
  801c9c:	5b                   	pop    %ebx
  801c9d:	5e                   	pop    %esi
  801c9e:	5f                   	pop    %edi
  801c9f:	5d                   	pop    %ebp
  801ca0:	c3                   	ret    
  801ca1:	8d 76 00             	lea    0x0(%esi),%esi
  801ca4:	31 ff                	xor    %edi,%edi
  801ca6:	31 c0                	xor    %eax,%eax
  801ca8:	89 fa                	mov    %edi,%edx
  801caa:	83 c4 1c             	add    $0x1c,%esp
  801cad:	5b                   	pop    %ebx
  801cae:	5e                   	pop    %esi
  801caf:	5f                   	pop    %edi
  801cb0:	5d                   	pop    %ebp
  801cb1:	c3                   	ret    
  801cb2:	66 90                	xchg   %ax,%ax
  801cb4:	89 d8                	mov    %ebx,%eax
  801cb6:	f7 f7                	div    %edi
  801cb8:	31 ff                	xor    %edi,%edi
  801cba:	89 fa                	mov    %edi,%edx
  801cbc:	83 c4 1c             	add    $0x1c,%esp
  801cbf:	5b                   	pop    %ebx
  801cc0:	5e                   	pop    %esi
  801cc1:	5f                   	pop    %edi
  801cc2:	5d                   	pop    %ebp
  801cc3:	c3                   	ret    
  801cc4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cc9:	89 eb                	mov    %ebp,%ebx
  801ccb:	29 fb                	sub    %edi,%ebx
  801ccd:	89 f9                	mov    %edi,%ecx
  801ccf:	d3 e6                	shl    %cl,%esi
  801cd1:	89 c5                	mov    %eax,%ebp
  801cd3:	88 d9                	mov    %bl,%cl
  801cd5:	d3 ed                	shr    %cl,%ebp
  801cd7:	89 e9                	mov    %ebp,%ecx
  801cd9:	09 f1                	or     %esi,%ecx
  801cdb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801cdf:	89 f9                	mov    %edi,%ecx
  801ce1:	d3 e0                	shl    %cl,%eax
  801ce3:	89 c5                	mov    %eax,%ebp
  801ce5:	89 d6                	mov    %edx,%esi
  801ce7:	88 d9                	mov    %bl,%cl
  801ce9:	d3 ee                	shr    %cl,%esi
  801ceb:	89 f9                	mov    %edi,%ecx
  801ced:	d3 e2                	shl    %cl,%edx
  801cef:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cf3:	88 d9                	mov    %bl,%cl
  801cf5:	d3 e8                	shr    %cl,%eax
  801cf7:	09 c2                	or     %eax,%edx
  801cf9:	89 d0                	mov    %edx,%eax
  801cfb:	89 f2                	mov    %esi,%edx
  801cfd:	f7 74 24 0c          	divl   0xc(%esp)
  801d01:	89 d6                	mov    %edx,%esi
  801d03:	89 c3                	mov    %eax,%ebx
  801d05:	f7 e5                	mul    %ebp
  801d07:	39 d6                	cmp    %edx,%esi
  801d09:	72 19                	jb     801d24 <__udivdi3+0xfc>
  801d0b:	74 0b                	je     801d18 <__udivdi3+0xf0>
  801d0d:	89 d8                	mov    %ebx,%eax
  801d0f:	31 ff                	xor    %edi,%edi
  801d11:	e9 58 ff ff ff       	jmp    801c6e <__udivdi3+0x46>
  801d16:	66 90                	xchg   %ax,%ax
  801d18:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d1c:	89 f9                	mov    %edi,%ecx
  801d1e:	d3 e2                	shl    %cl,%edx
  801d20:	39 c2                	cmp    %eax,%edx
  801d22:	73 e9                	jae    801d0d <__udivdi3+0xe5>
  801d24:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d27:	31 ff                	xor    %edi,%edi
  801d29:	e9 40 ff ff ff       	jmp    801c6e <__udivdi3+0x46>
  801d2e:	66 90                	xchg   %ax,%ax
  801d30:	31 c0                	xor    %eax,%eax
  801d32:	e9 37 ff ff ff       	jmp    801c6e <__udivdi3+0x46>
  801d37:	90                   	nop

00801d38 <__umoddi3>:
  801d38:	55                   	push   %ebp
  801d39:	57                   	push   %edi
  801d3a:	56                   	push   %esi
  801d3b:	53                   	push   %ebx
  801d3c:	83 ec 1c             	sub    $0x1c,%esp
  801d3f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d43:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d47:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d4b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d4f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d53:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d57:	89 f3                	mov    %esi,%ebx
  801d59:	89 fa                	mov    %edi,%edx
  801d5b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d5f:	89 34 24             	mov    %esi,(%esp)
  801d62:	85 c0                	test   %eax,%eax
  801d64:	75 1a                	jne    801d80 <__umoddi3+0x48>
  801d66:	39 f7                	cmp    %esi,%edi
  801d68:	0f 86 a2 00 00 00    	jbe    801e10 <__umoddi3+0xd8>
  801d6e:	89 c8                	mov    %ecx,%eax
  801d70:	89 f2                	mov    %esi,%edx
  801d72:	f7 f7                	div    %edi
  801d74:	89 d0                	mov    %edx,%eax
  801d76:	31 d2                	xor    %edx,%edx
  801d78:	83 c4 1c             	add    $0x1c,%esp
  801d7b:	5b                   	pop    %ebx
  801d7c:	5e                   	pop    %esi
  801d7d:	5f                   	pop    %edi
  801d7e:	5d                   	pop    %ebp
  801d7f:	c3                   	ret    
  801d80:	39 f0                	cmp    %esi,%eax
  801d82:	0f 87 ac 00 00 00    	ja     801e34 <__umoddi3+0xfc>
  801d88:	0f bd e8             	bsr    %eax,%ebp
  801d8b:	83 f5 1f             	xor    $0x1f,%ebp
  801d8e:	0f 84 ac 00 00 00    	je     801e40 <__umoddi3+0x108>
  801d94:	bf 20 00 00 00       	mov    $0x20,%edi
  801d99:	29 ef                	sub    %ebp,%edi
  801d9b:	89 fe                	mov    %edi,%esi
  801d9d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801da1:	89 e9                	mov    %ebp,%ecx
  801da3:	d3 e0                	shl    %cl,%eax
  801da5:	89 d7                	mov    %edx,%edi
  801da7:	89 f1                	mov    %esi,%ecx
  801da9:	d3 ef                	shr    %cl,%edi
  801dab:	09 c7                	or     %eax,%edi
  801dad:	89 e9                	mov    %ebp,%ecx
  801daf:	d3 e2                	shl    %cl,%edx
  801db1:	89 14 24             	mov    %edx,(%esp)
  801db4:	89 d8                	mov    %ebx,%eax
  801db6:	d3 e0                	shl    %cl,%eax
  801db8:	89 c2                	mov    %eax,%edx
  801dba:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dbe:	d3 e0                	shl    %cl,%eax
  801dc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dc4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dc8:	89 f1                	mov    %esi,%ecx
  801dca:	d3 e8                	shr    %cl,%eax
  801dcc:	09 d0                	or     %edx,%eax
  801dce:	d3 eb                	shr    %cl,%ebx
  801dd0:	89 da                	mov    %ebx,%edx
  801dd2:	f7 f7                	div    %edi
  801dd4:	89 d3                	mov    %edx,%ebx
  801dd6:	f7 24 24             	mull   (%esp)
  801dd9:	89 c6                	mov    %eax,%esi
  801ddb:	89 d1                	mov    %edx,%ecx
  801ddd:	39 d3                	cmp    %edx,%ebx
  801ddf:	0f 82 87 00 00 00    	jb     801e6c <__umoddi3+0x134>
  801de5:	0f 84 91 00 00 00    	je     801e7c <__umoddi3+0x144>
  801deb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801def:	29 f2                	sub    %esi,%edx
  801df1:	19 cb                	sbb    %ecx,%ebx
  801df3:	89 d8                	mov    %ebx,%eax
  801df5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801df9:	d3 e0                	shl    %cl,%eax
  801dfb:	89 e9                	mov    %ebp,%ecx
  801dfd:	d3 ea                	shr    %cl,%edx
  801dff:	09 d0                	or     %edx,%eax
  801e01:	89 e9                	mov    %ebp,%ecx
  801e03:	d3 eb                	shr    %cl,%ebx
  801e05:	89 da                	mov    %ebx,%edx
  801e07:	83 c4 1c             	add    $0x1c,%esp
  801e0a:	5b                   	pop    %ebx
  801e0b:	5e                   	pop    %esi
  801e0c:	5f                   	pop    %edi
  801e0d:	5d                   	pop    %ebp
  801e0e:	c3                   	ret    
  801e0f:	90                   	nop
  801e10:	89 fd                	mov    %edi,%ebp
  801e12:	85 ff                	test   %edi,%edi
  801e14:	75 0b                	jne    801e21 <__umoddi3+0xe9>
  801e16:	b8 01 00 00 00       	mov    $0x1,%eax
  801e1b:	31 d2                	xor    %edx,%edx
  801e1d:	f7 f7                	div    %edi
  801e1f:	89 c5                	mov    %eax,%ebp
  801e21:	89 f0                	mov    %esi,%eax
  801e23:	31 d2                	xor    %edx,%edx
  801e25:	f7 f5                	div    %ebp
  801e27:	89 c8                	mov    %ecx,%eax
  801e29:	f7 f5                	div    %ebp
  801e2b:	89 d0                	mov    %edx,%eax
  801e2d:	e9 44 ff ff ff       	jmp    801d76 <__umoddi3+0x3e>
  801e32:	66 90                	xchg   %ax,%ax
  801e34:	89 c8                	mov    %ecx,%eax
  801e36:	89 f2                	mov    %esi,%edx
  801e38:	83 c4 1c             	add    $0x1c,%esp
  801e3b:	5b                   	pop    %ebx
  801e3c:	5e                   	pop    %esi
  801e3d:	5f                   	pop    %edi
  801e3e:	5d                   	pop    %ebp
  801e3f:	c3                   	ret    
  801e40:	3b 04 24             	cmp    (%esp),%eax
  801e43:	72 06                	jb     801e4b <__umoddi3+0x113>
  801e45:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e49:	77 0f                	ja     801e5a <__umoddi3+0x122>
  801e4b:	89 f2                	mov    %esi,%edx
  801e4d:	29 f9                	sub    %edi,%ecx
  801e4f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e53:	89 14 24             	mov    %edx,(%esp)
  801e56:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e5a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e5e:	8b 14 24             	mov    (%esp),%edx
  801e61:	83 c4 1c             	add    $0x1c,%esp
  801e64:	5b                   	pop    %ebx
  801e65:	5e                   	pop    %esi
  801e66:	5f                   	pop    %edi
  801e67:	5d                   	pop    %ebp
  801e68:	c3                   	ret    
  801e69:	8d 76 00             	lea    0x0(%esi),%esi
  801e6c:	2b 04 24             	sub    (%esp),%eax
  801e6f:	19 fa                	sbb    %edi,%edx
  801e71:	89 d1                	mov    %edx,%ecx
  801e73:	89 c6                	mov    %eax,%esi
  801e75:	e9 71 ff ff ff       	jmp    801deb <__umoddi3+0xb3>
  801e7a:	66 90                	xchg   %ax,%ax
  801e7c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e80:	72 ea                	jb     801e6c <__umoddi3+0x134>
  801e82:	89 d9                	mov    %ebx,%ecx
  801e84:	e9 62 ff ff ff       	jmp    801deb <__umoddi3+0xb3>
