
obj/user/tst_envfree2:     file format elf32-i386


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
  800031:	e8 73 02 00 00       	call   8002a9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests environment free run tef2 10 5
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	// Testing scenario 2: using dynamic allocation and free
	// Testing removing the allocated pages (static & dynamic) in mem, WS, mapped page tables, env's directory and env's page file

	char getksbrkCmd[100] = "__getKernelSBreak__";
  800044:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  80004a:	bb 31 20 80 00       	mov    $0x802031,%ebx
  80004f:	ba 05 00 00 00       	mov    $0x5,%edx
  800054:	89 c7                	mov    %eax,%edi
  800056:	89 de                	mov    %ebx,%esi
  800058:	89 d1                	mov    %edx,%ecx
  80005a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80005c:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
  800062:	b9 14 00 00 00       	mov    $0x14,%ecx
  800067:	b8 00 00 00 00       	mov    $0x0,%eax
  80006c:	89 d7                	mov    %edx,%edi
  80006e:	f3 ab                	rep stos %eax,%es:(%edi)
	uint32 ksbrk_before ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_before);
  800070:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800076:	83 ec 08             	sub    $0x8,%esp
  800079:	50                   	push   %eax
  80007a:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  800080:	50                   	push   %eax
  800081:	e8 c4 1a 00 00       	call   801b4a <sys_utilities>
  800086:	83 c4 10             	add    $0x10,%esp

	int freeFrames_before = sys_calculate_free_frames() ;
  800089:	e8 bd 16 00 00       	call   80174b <sys_calculate_free_frames>
  80008e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800091:	e8 00 17 00 00       	call   801796 <sys_pf_calculate_allocated_pages>
  800096:	89 45 e0             	mov    %eax,-0x20(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  800099:	83 ec 08             	sub    $0x8,%esp
  80009c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80009f:	68 40 1e 80 00       	push   $0x801e40
  8000a4:	e8 9e 06 00 00       	call   800747 <cprintf>
  8000a9:	83 c4 10             	add    $0x10,%esp

	/*[4] CREATE AND RUN ProcessA & ProcessB*/
	//Create 3 processes
	int32 envIdProcessA = sys_create_env("sc_ms_leak_small", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000ac:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b1:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  8000b7:	89 c2                	mov    %eax,%edx
  8000b9:	a1 20 30 80 00       	mov    0x803020,%eax
  8000be:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000c4:	6a 32                	push   $0x32
  8000c6:	52                   	push   %edx
  8000c7:	50                   	push   %eax
  8000c8:	68 73 1e 80 00       	push   $0x801e73
  8000cd:	e8 d4 17 00 00       	call   8018a6 <sys_create_env>
  8000d2:	83 c4 10             	add    $0x10,%esp
  8000d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdProcessB = sys_create_env("sc_ms_noleak_small", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8000dd:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  8000e3:	89 c2                	mov    %eax,%edx
  8000e5:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ea:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000f0:	6a 32                	push   $0x32
  8000f2:	52                   	push   %edx
  8000f3:	50                   	push   %eax
  8000f4:	68 84 1e 80 00       	push   $0x801e84
  8000f9:	e8 a8 17 00 00       	call   8018a6 <sys_create_env>
  8000fe:	83 c4 10             	add    $0x10,%esp
  800101:	89 45 d8             	mov    %eax,-0x28(%ebp)

	rsttst();
  800104:	e8 e9 18 00 00       	call   8019f2 <rsttst>

	//Run 2 processes
	sys_run_env(envIdProcessA);
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	ff 75 dc             	pushl  -0x24(%ebp)
  80010f:	e8 b0 17 00 00       	call   8018c4 <sys_run_env>
  800114:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800117:	83 ec 0c             	sub    $0xc,%esp
  80011a:	ff 75 d8             	pushl  -0x28(%ebp)
  80011d:	e8 a2 17 00 00       	call   8018c4 <sys_run_env>
  800122:	83 c4 10             	add    $0x10,%esp

	//env_sleep(30000);

	//to ensure that the slave environments completed successfully
	while (gettst()!=2) ;// panic("test failed");
  800125:	90                   	nop
  800126:	e8 41 19 00 00       	call   801a6c <gettst>
  80012b:	83 f8 02             	cmp    $0x2,%eax
  80012e:	75 f6                	jne    800126 <_main+0xee>

	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  800130:	e8 16 16 00 00       	call   80174b <sys_calculate_free_frames>
  800135:	83 ec 08             	sub    $0x8,%esp
  800138:	50                   	push   %eax
  800139:	68 98 1e 80 00       	push   $0x801e98
  80013e:	e8 04 06 00 00       	call   800747 <cprintf>
  800143:	83 c4 10             	add    $0x10,%esp

	uint32 ksbrk_after ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_after);
  800146:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  80014c:	83 ec 08             	sub    $0x8,%esp
  80014f:	50                   	push   %eax
  800150:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  800156:	50                   	push   %eax
  800157:	e8 ee 19 00 00       	call   801b4a <sys_utilities>
  80015c:	83 c4 10             	add    $0x10,%esp
	//Kill the 2 processes
	//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
	//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
	//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
	//	2. changing the # free frames
	char changeIntCmd[100] = "__changeInterruptStatus__";
  80015f:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
  800165:	bb 95 20 80 00       	mov    $0x802095,%ebx
  80016a:	ba 1a 00 00 00       	mov    $0x1a,%edx
  80016f:	89 c7                	mov    %eax,%edi
  800171:	89 de                	mov    %ebx,%esi
  800173:	89 d1                	mov    %edx,%ecx
  800175:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800177:	8d 95 06 ff ff ff    	lea    -0xfa(%ebp),%edx
  80017d:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  800182:	b0 00                	mov    $0x0,%al
  800184:	89 d7                	mov    %edx,%edi
  800186:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(changeIntCmd, 0);
  800188:	83 ec 08             	sub    $0x8,%esp
  80018b:	6a 00                	push   $0x0
  80018d:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
  800193:	50                   	push   %eax
  800194:	e8 b1 19 00 00       	call   801b4a <sys_utilities>
  800199:	83 c4 10             	add    $0x10,%esp
	{
		sys_destroy_env(envIdProcessA);
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	ff 75 dc             	pushl  -0x24(%ebp)
  8001a2:	e8 39 17 00 00       	call   8018e0 <sys_destroy_env>
  8001a7:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001aa:	83 ec 0c             	sub    $0xc,%esp
  8001ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8001b0:	e8 2b 17 00 00       	call   8018e0 <sys_destroy_env>
  8001b5:	83 c4 10             	add    $0x10,%esp
	}
	sys_utilities(changeIntCmd, 1);
  8001b8:	83 ec 08             	sub    $0x8,%esp
  8001bb:	6a 01                	push   $0x1
  8001bd:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
  8001c3:	50                   	push   %eax
  8001c4:	e8 81 19 00 00       	call   801b4a <sys_utilities>
  8001c9:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8001cc:	e8 7a 15 00 00       	call   80174b <sys_calculate_free_frames>
  8001d1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8001d4:	e8 bd 15 00 00       	call   801796 <sys_pf_calculate_allocated_pages>
  8001d9:	89 45 d0             	mov    %eax,-0x30(%ebp)

	int expected = (ROUNDUP((uint32)ksbrk_after, PAGE_SIZE) - ROUNDUP((uint32)ksbrk_before, PAGE_SIZE)) / PAGE_SIZE;
  8001dc:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8001e3:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  8001e9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ec:	01 d0                	add    %edx,%eax
  8001ee:	48                   	dec    %eax
  8001ef:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8001f2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8001fa:	f7 75 cc             	divl   -0x34(%ebp)
  8001fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800200:	29 d0                	sub    %edx,%eax
  800202:	89 c1                	mov    %eax,%ecx
  800204:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80020b:	8b 95 54 ff ff ff    	mov    -0xac(%ebp),%edx
  800211:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800214:	01 d0                	add    %edx,%eax
  800216:	48                   	dec    %eax
  800217:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80021a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80021d:	ba 00 00 00 00       	mov    $0x0,%edx
  800222:	f7 75 c4             	divl   -0x3c(%ebp)
  800225:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800228:	29 d0                	sub    %edx,%eax
  80022a:	29 c1                	sub    %eax,%ecx
  80022c:	89 c8                	mov    %ecx,%eax
  80022e:	c1 e8 0c             	shr    $0xc,%eax
  800231:	89 45 bc             	mov    %eax,-0x44(%ebp)
	cprintf("expected = %d\n",expected);
  800234:	83 ec 08             	sub    $0x8,%esp
  800237:	ff 75 bc             	pushl  -0x44(%ebp)
  80023a:	68 ca 1e 80 00       	push   $0x801eca
  80023f:	e8 03 05 00 00       	call   800747 <cprintf>
  800244:	83 c4 10             	add    $0x10,%esp
	if ((freeFrames_before - freeFrames_after) != expected) {
  800247:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80024a:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80024d:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  800250:	74 2e                	je     800280 <_main+0x248>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d, expected = %d\n",
  800252:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800255:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800258:	ff 75 bc             	pushl  -0x44(%ebp)
  80025b:	50                   	push   %eax
  80025c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80025f:	68 dc 1e 80 00       	push   $0x801edc
  800264:	e8 de 04 00 00       	call   800747 <cprintf>
  800269:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before, expected);
		panic("env_free() does not work correctly... check it again.");
  80026c:	83 ec 04             	sub    $0x4,%esp
  80026f:	68 4c 1f 80 00       	push   $0x801f4c
  800274:	6a 3c                	push   $0x3c
  800276:	68 82 1f 80 00       	push   $0x801f82
  80027b:	e8 d9 01 00 00       	call   800459 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back as expected\n");
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	68 98 1f 80 00       	push   $0x801f98
  800288:	e8 ba 04 00 00       	call   800747 <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 2 for envfree completed successfully.\n");
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 e8 1f 80 00       	push   $0x801fe8
  800298:	e8 aa 04 00 00       	call   800747 <cprintf>
  80029d:	83 c4 10             	add    $0x10,%esp
	return;
  8002a0:	90                   	nop
}
  8002a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a4:	5b                   	pop    %ebx
  8002a5:	5e                   	pop    %esi
  8002a6:	5f                   	pop    %edi
  8002a7:	5d                   	pop    %ebp
  8002a8:	c3                   	ret    

008002a9 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002a9:	55                   	push   %ebp
  8002aa:	89 e5                	mov    %esp,%ebp
  8002ac:	57                   	push   %edi
  8002ad:	56                   	push   %esi
  8002ae:	53                   	push   %ebx
  8002af:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002b2:	e8 5d 16 00 00       	call   801914 <sys_getenvindex>
  8002b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002bd:	89 d0                	mov    %edx,%eax
  8002bf:	01 c0                	add    %eax,%eax
  8002c1:	01 d0                	add    %edx,%eax
  8002c3:	c1 e0 02             	shl    $0x2,%eax
  8002c6:	01 d0                	add    %edx,%eax
  8002c8:	c1 e0 02             	shl    $0x2,%eax
  8002cb:	01 d0                	add    %edx,%eax
  8002cd:	c1 e0 03             	shl    $0x3,%eax
  8002d0:	01 d0                	add    %edx,%eax
  8002d2:	c1 e0 02             	shl    $0x2,%eax
  8002d5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002da:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002df:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e4:	8a 40 20             	mov    0x20(%eax),%al
  8002e7:	84 c0                	test   %al,%al
  8002e9:	74 0d                	je     8002f8 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8002eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f0:	83 c0 20             	add    $0x20,%eax
  8002f3:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002fc:	7e 0a                	jle    800308 <libmain+0x5f>
		binaryname = argv[0];
  8002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800301:	8b 00                	mov    (%eax),%eax
  800303:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800308:	83 ec 08             	sub    $0x8,%esp
  80030b:	ff 75 0c             	pushl  0xc(%ebp)
  80030e:	ff 75 08             	pushl  0x8(%ebp)
  800311:	e8 22 fd ff ff       	call   800038 <_main>
  800316:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800319:	a1 00 30 80 00       	mov    0x803000,%eax
  80031e:	85 c0                	test   %eax,%eax
  800320:	0f 84 01 01 00 00    	je     800427 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800326:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80032c:	bb f4 21 80 00       	mov    $0x8021f4,%ebx
  800331:	ba 0e 00 00 00       	mov    $0xe,%edx
  800336:	89 c7                	mov    %eax,%edi
  800338:	89 de                	mov    %ebx,%esi
  80033a:	89 d1                	mov    %edx,%ecx
  80033c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80033e:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800341:	b9 56 00 00 00       	mov    $0x56,%ecx
  800346:	b0 00                	mov    $0x0,%al
  800348:	89 d7                	mov    %edx,%edi
  80034a:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80034c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800353:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800356:	83 ec 08             	sub    $0x8,%esp
  800359:	50                   	push   %eax
  80035a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800360:	50                   	push   %eax
  800361:	e8 e4 17 00 00       	call   801b4a <sys_utilities>
  800366:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800369:	e8 2d 13 00 00       	call   80169b <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80036e:	83 ec 0c             	sub    $0xc,%esp
  800371:	68 14 21 80 00       	push   $0x802114
  800376:	e8 cc 03 00 00       	call   800747 <cprintf>
  80037b:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80037e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800381:	85 c0                	test   %eax,%eax
  800383:	74 18                	je     80039d <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800385:	e8 de 17 00 00       	call   801b68 <sys_get_optimal_num_faults>
  80038a:	83 ec 08             	sub    $0x8,%esp
  80038d:	50                   	push   %eax
  80038e:	68 3c 21 80 00       	push   $0x80213c
  800393:	e8 af 03 00 00       	call   800747 <cprintf>
  800398:	83 c4 10             	add    $0x10,%esp
  80039b:	eb 59                	jmp    8003f6 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80039d:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a2:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8003a8:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ad:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8003b3:	83 ec 04             	sub    $0x4,%esp
  8003b6:	52                   	push   %edx
  8003b7:	50                   	push   %eax
  8003b8:	68 60 21 80 00       	push   $0x802160
  8003bd:	e8 85 03 00 00       	call   800747 <cprintf>
  8003c2:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003c5:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ca:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8003d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d5:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8003db:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e0:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  8003e6:	51                   	push   %ecx
  8003e7:	52                   	push   %edx
  8003e8:	50                   	push   %eax
  8003e9:	68 88 21 80 00       	push   $0x802188
  8003ee:	e8 54 03 00 00       	call   800747 <cprintf>
  8003f3:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003fb:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800401:	83 ec 08             	sub    $0x8,%esp
  800404:	50                   	push   %eax
  800405:	68 e0 21 80 00       	push   $0x8021e0
  80040a:	e8 38 03 00 00       	call   800747 <cprintf>
  80040f:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800412:	83 ec 0c             	sub    $0xc,%esp
  800415:	68 14 21 80 00       	push   $0x802114
  80041a:	e8 28 03 00 00       	call   800747 <cprintf>
  80041f:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800422:	e8 8e 12 00 00       	call   8016b5 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800427:	e8 1f 00 00 00       	call   80044b <exit>
}
  80042c:	90                   	nop
  80042d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800430:	5b                   	pop    %ebx
  800431:	5e                   	pop    %esi
  800432:	5f                   	pop    %edi
  800433:	5d                   	pop    %ebp
  800434:	c3                   	ret    

00800435 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800435:	55                   	push   %ebp
  800436:	89 e5                	mov    %esp,%ebp
  800438:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80043b:	83 ec 0c             	sub    $0xc,%esp
  80043e:	6a 00                	push   $0x0
  800440:	e8 9b 14 00 00       	call   8018e0 <sys_destroy_env>
  800445:	83 c4 10             	add    $0x10,%esp
}
  800448:	90                   	nop
  800449:	c9                   	leave  
  80044a:	c3                   	ret    

0080044b <exit>:

void
exit(void)
{
  80044b:	55                   	push   %ebp
  80044c:	89 e5                	mov    %esp,%ebp
  80044e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800451:	e8 f0 14 00 00       	call   801946 <sys_exit_env>
}
  800456:	90                   	nop
  800457:	c9                   	leave  
  800458:	c3                   	ret    

00800459 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800459:	55                   	push   %ebp
  80045a:	89 e5                	mov    %esp,%ebp
  80045c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80045f:	8d 45 10             	lea    0x10(%ebp),%eax
  800462:	83 c0 04             	add    $0x4,%eax
  800465:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800468:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80046d:	85 c0                	test   %eax,%eax
  80046f:	74 16                	je     800487 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800471:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800476:	83 ec 08             	sub    $0x8,%esp
  800479:	50                   	push   %eax
  80047a:	68 58 22 80 00       	push   $0x802258
  80047f:	e8 c3 02 00 00       	call   800747 <cprintf>
  800484:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800487:	a1 04 30 80 00       	mov    0x803004,%eax
  80048c:	83 ec 0c             	sub    $0xc,%esp
  80048f:	ff 75 0c             	pushl  0xc(%ebp)
  800492:	ff 75 08             	pushl  0x8(%ebp)
  800495:	50                   	push   %eax
  800496:	68 60 22 80 00       	push   $0x802260
  80049b:	6a 74                	push   $0x74
  80049d:	e8 d2 02 00 00       	call   800774 <cprintf_colored>
  8004a2:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a8:	83 ec 08             	sub    $0x8,%esp
  8004ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ae:	50                   	push   %eax
  8004af:	e8 24 02 00 00       	call   8006d8 <vcprintf>
  8004b4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004b7:	83 ec 08             	sub    $0x8,%esp
  8004ba:	6a 00                	push   $0x0
  8004bc:	68 88 22 80 00       	push   $0x802288
  8004c1:	e8 12 02 00 00       	call   8006d8 <vcprintf>
  8004c6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004c9:	e8 7d ff ff ff       	call   80044b <exit>

	// should not return here
	while (1) ;
  8004ce:	eb fe                	jmp    8004ce <_panic+0x75>

008004d0 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004d0:	55                   	push   %ebp
  8004d1:	89 e5                	mov    %esp,%ebp
  8004d3:	53                   	push   %ebx
  8004d4:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004d7:	a1 20 30 80 00       	mov    0x803020,%eax
  8004dc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e5:	39 c2                	cmp    %eax,%edx
  8004e7:	74 14                	je     8004fd <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004e9:	83 ec 04             	sub    $0x4,%esp
  8004ec:	68 8c 22 80 00       	push   $0x80228c
  8004f1:	6a 26                	push   $0x26
  8004f3:	68 d8 22 80 00       	push   $0x8022d8
  8004f8:	e8 5c ff ff ff       	call   800459 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800504:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80050b:	e9 d9 00 00 00       	jmp    8005e9 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800510:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800513:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80051a:	8b 45 08             	mov    0x8(%ebp),%eax
  80051d:	01 d0                	add    %edx,%eax
  80051f:	8b 00                	mov    (%eax),%eax
  800521:	85 c0                	test   %eax,%eax
  800523:	75 08                	jne    80052d <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  800525:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800528:	e9 b9 00 00 00       	jmp    8005e6 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  80052d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800534:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80053b:	eb 79                	jmp    8005b6 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80053d:	a1 20 30 80 00       	mov    0x803020,%eax
  800542:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800548:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80054b:	89 d0                	mov    %edx,%eax
  80054d:	01 c0                	add    %eax,%eax
  80054f:	01 d0                	add    %edx,%eax
  800551:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800558:	01 d8                	add    %ebx,%eax
  80055a:	01 d0                	add    %edx,%eax
  80055c:	01 c8                	add    %ecx,%eax
  80055e:	8a 40 04             	mov    0x4(%eax),%al
  800561:	84 c0                	test   %al,%al
  800563:	75 4e                	jne    8005b3 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800565:	a1 20 30 80 00       	mov    0x803020,%eax
  80056a:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800570:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800573:	89 d0                	mov    %edx,%eax
  800575:	01 c0                	add    %eax,%eax
  800577:	01 d0                	add    %edx,%eax
  800579:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800580:	01 d8                	add    %ebx,%eax
  800582:	01 d0                	add    %edx,%eax
  800584:	01 c8                	add    %ecx,%eax
  800586:	8b 00                	mov    (%eax),%eax
  800588:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80058b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80058e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800593:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800595:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800598:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80059f:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a2:	01 c8                	add    %ecx,%eax
  8005a4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005a6:	39 c2                	cmp    %eax,%edx
  8005a8:	75 09                	jne    8005b3 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8005aa:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005b1:	eb 19                	jmp    8005cc <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005b3:	ff 45 e8             	incl   -0x18(%ebp)
  8005b6:	a1 20 30 80 00       	mov    0x803020,%eax
  8005bb:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005c4:	39 c2                	cmp    %eax,%edx
  8005c6:	0f 87 71 ff ff ff    	ja     80053d <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005d0:	75 14                	jne    8005e6 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  8005d2:	83 ec 04             	sub    $0x4,%esp
  8005d5:	68 e4 22 80 00       	push   $0x8022e4
  8005da:	6a 3a                	push   $0x3a
  8005dc:	68 d8 22 80 00       	push   $0x8022d8
  8005e1:	e8 73 fe ff ff       	call   800459 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005e6:	ff 45 f0             	incl   -0x10(%ebp)
  8005e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005ef:	0f 8c 1b ff ff ff    	jl     800510 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005f5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005fc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800603:	eb 2e                	jmp    800633 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800605:	a1 20 30 80 00       	mov    0x803020,%eax
  80060a:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800610:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800613:	89 d0                	mov    %edx,%eax
  800615:	01 c0                	add    %eax,%eax
  800617:	01 d0                	add    %edx,%eax
  800619:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800620:	01 d8                	add    %ebx,%eax
  800622:	01 d0                	add    %edx,%eax
  800624:	01 c8                	add    %ecx,%eax
  800626:	8a 40 04             	mov    0x4(%eax),%al
  800629:	3c 01                	cmp    $0x1,%al
  80062b:	75 03                	jne    800630 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  80062d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800630:	ff 45 e0             	incl   -0x20(%ebp)
  800633:	a1 20 30 80 00       	mov    0x803020,%eax
  800638:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80063e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800641:	39 c2                	cmp    %eax,%edx
  800643:	77 c0                	ja     800605 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800648:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80064b:	74 14                	je     800661 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  80064d:	83 ec 04             	sub    $0x4,%esp
  800650:	68 38 23 80 00       	push   $0x802338
  800655:	6a 44                	push   $0x44
  800657:	68 d8 22 80 00       	push   $0x8022d8
  80065c:	e8 f8 fd ff ff       	call   800459 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800661:	90                   	nop
  800662:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800665:	c9                   	leave  
  800666:	c3                   	ret    

00800667 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800667:	55                   	push   %ebp
  800668:	89 e5                	mov    %esp,%ebp
  80066a:	53                   	push   %ebx
  80066b:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80066e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800671:	8b 00                	mov    (%eax),%eax
  800673:	8d 48 01             	lea    0x1(%eax),%ecx
  800676:	8b 55 0c             	mov    0xc(%ebp),%edx
  800679:	89 0a                	mov    %ecx,(%edx)
  80067b:	8b 55 08             	mov    0x8(%ebp),%edx
  80067e:	88 d1                	mov    %dl,%cl
  800680:	8b 55 0c             	mov    0xc(%ebp),%edx
  800683:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800687:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800691:	75 30                	jne    8006c3 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800693:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800699:	a0 44 30 80 00       	mov    0x803044,%al
  80069e:	0f b6 c0             	movzbl %al,%eax
  8006a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006a4:	8b 09                	mov    (%ecx),%ecx
  8006a6:	89 cb                	mov    %ecx,%ebx
  8006a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006ab:	83 c1 08             	add    $0x8,%ecx
  8006ae:	52                   	push   %edx
  8006af:	50                   	push   %eax
  8006b0:	53                   	push   %ebx
  8006b1:	51                   	push   %ecx
  8006b2:	e8 a0 0f 00 00       	call   801657 <sys_cputs>
  8006b7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c6:	8b 40 04             	mov    0x4(%eax),%eax
  8006c9:	8d 50 01             	lea    0x1(%eax),%edx
  8006cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cf:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006d2:	90                   	nop
  8006d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006d6:	c9                   	leave  
  8006d7:	c3                   	ret    

008006d8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006d8:	55                   	push   %ebp
  8006d9:	89 e5                	mov    %esp,%ebp
  8006db:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006e1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006e8:	00 00 00 
	b.cnt = 0;
  8006eb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006f2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006f5:	ff 75 0c             	pushl  0xc(%ebp)
  8006f8:	ff 75 08             	pushl  0x8(%ebp)
  8006fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800701:	50                   	push   %eax
  800702:	68 67 06 80 00       	push   $0x800667
  800707:	e8 5a 02 00 00       	call   800966 <vprintfmt>
  80070c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80070f:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800715:	a0 44 30 80 00       	mov    0x803044,%al
  80071a:	0f b6 c0             	movzbl %al,%eax
  80071d:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800723:	52                   	push   %edx
  800724:	50                   	push   %eax
  800725:	51                   	push   %ecx
  800726:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80072c:	83 c0 08             	add    $0x8,%eax
  80072f:	50                   	push   %eax
  800730:	e8 22 0f 00 00       	call   801657 <sys_cputs>
  800735:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800738:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  80073f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800745:	c9                   	leave  
  800746:	c3                   	ret    

00800747 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800747:	55                   	push   %ebp
  800748:	89 e5                	mov    %esp,%ebp
  80074a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80074d:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800754:	8d 45 0c             	lea    0xc(%ebp),%eax
  800757:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	ff 75 f4             	pushl  -0xc(%ebp)
  800763:	50                   	push   %eax
  800764:	e8 6f ff ff ff       	call   8006d8 <vcprintf>
  800769:	83 c4 10             	add    $0x10,%esp
  80076c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80076f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800772:	c9                   	leave  
  800773:	c3                   	ret    

00800774 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800774:	55                   	push   %ebp
  800775:	89 e5                	mov    %esp,%ebp
  800777:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80077a:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800781:	8b 45 08             	mov    0x8(%ebp),%eax
  800784:	c1 e0 08             	shl    $0x8,%eax
  800787:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  80078c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80078f:	83 c0 04             	add    $0x4,%eax
  800792:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800795:	8b 45 0c             	mov    0xc(%ebp),%eax
  800798:	83 ec 08             	sub    $0x8,%esp
  80079b:	ff 75 f4             	pushl  -0xc(%ebp)
  80079e:	50                   	push   %eax
  80079f:	e8 34 ff ff ff       	call   8006d8 <vcprintf>
  8007a4:	83 c4 10             	add    $0x10,%esp
  8007a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007aa:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8007b1:	07 00 00 

	return cnt;
  8007b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b7:	c9                   	leave  
  8007b8:	c3                   	ret    

008007b9 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007b9:	55                   	push   %ebp
  8007ba:	89 e5                	mov    %esp,%ebp
  8007bc:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007bf:	e8 d7 0e 00 00       	call   80169b <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007c4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d3:	50                   	push   %eax
  8007d4:	e8 ff fe ff ff       	call   8006d8 <vcprintf>
  8007d9:	83 c4 10             	add    $0x10,%esp
  8007dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007df:	e8 d1 0e 00 00       	call   8016b5 <sys_unlock_cons>
	return cnt;
  8007e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007e7:	c9                   	leave  
  8007e8:	c3                   	ret    

008007e9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007e9:	55                   	push   %ebp
  8007ea:	89 e5                	mov    %esp,%ebp
  8007ec:	53                   	push   %ebx
  8007ed:	83 ec 14             	sub    $0x14,%esp
  8007f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007fc:	8b 45 18             	mov    0x18(%ebp),%eax
  8007ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800804:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800807:	77 55                	ja     80085e <printnum+0x75>
  800809:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80080c:	72 05                	jb     800813 <printnum+0x2a>
  80080e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800811:	77 4b                	ja     80085e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800813:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800816:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800819:	8b 45 18             	mov    0x18(%ebp),%eax
  80081c:	ba 00 00 00 00       	mov    $0x0,%edx
  800821:	52                   	push   %edx
  800822:	50                   	push   %eax
  800823:	ff 75 f4             	pushl  -0xc(%ebp)
  800826:	ff 75 f0             	pushl  -0x10(%ebp)
  800829:	e8 aa 13 00 00       	call   801bd8 <__udivdi3>
  80082e:	83 c4 10             	add    $0x10,%esp
  800831:	83 ec 04             	sub    $0x4,%esp
  800834:	ff 75 20             	pushl  0x20(%ebp)
  800837:	53                   	push   %ebx
  800838:	ff 75 18             	pushl  0x18(%ebp)
  80083b:	52                   	push   %edx
  80083c:	50                   	push   %eax
  80083d:	ff 75 0c             	pushl  0xc(%ebp)
  800840:	ff 75 08             	pushl  0x8(%ebp)
  800843:	e8 a1 ff ff ff       	call   8007e9 <printnum>
  800848:	83 c4 20             	add    $0x20,%esp
  80084b:	eb 1a                	jmp    800867 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80084d:	83 ec 08             	sub    $0x8,%esp
  800850:	ff 75 0c             	pushl  0xc(%ebp)
  800853:	ff 75 20             	pushl  0x20(%ebp)
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	ff d0                	call   *%eax
  80085b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80085e:	ff 4d 1c             	decl   0x1c(%ebp)
  800861:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800865:	7f e6                	jg     80084d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800867:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80086a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80086f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800872:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800875:	53                   	push   %ebx
  800876:	51                   	push   %ecx
  800877:	52                   	push   %edx
  800878:	50                   	push   %eax
  800879:	e8 6a 14 00 00       	call   801ce8 <__umoddi3>
  80087e:	83 c4 10             	add    $0x10,%esp
  800881:	05 b4 25 80 00       	add    $0x8025b4,%eax
  800886:	8a 00                	mov    (%eax),%al
  800888:	0f be c0             	movsbl %al,%eax
  80088b:	83 ec 08             	sub    $0x8,%esp
  80088e:	ff 75 0c             	pushl  0xc(%ebp)
  800891:	50                   	push   %eax
  800892:	8b 45 08             	mov    0x8(%ebp),%eax
  800895:	ff d0                	call   *%eax
  800897:	83 c4 10             	add    $0x10,%esp
}
  80089a:	90                   	nop
  80089b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80089e:	c9                   	leave  
  80089f:	c3                   	ret    

008008a0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008a3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008a7:	7e 1c                	jle    8008c5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ac:	8b 00                	mov    (%eax),%eax
  8008ae:	8d 50 08             	lea    0x8(%eax),%edx
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	89 10                	mov    %edx,(%eax)
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	8b 00                	mov    (%eax),%eax
  8008bb:	83 e8 08             	sub    $0x8,%eax
  8008be:	8b 50 04             	mov    0x4(%eax),%edx
  8008c1:	8b 00                	mov    (%eax),%eax
  8008c3:	eb 40                	jmp    800905 <getuint+0x65>
	else if (lflag)
  8008c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008c9:	74 1e                	je     8008e9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	8b 00                	mov    (%eax),%eax
  8008d0:	8d 50 04             	lea    0x4(%eax),%edx
  8008d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d6:	89 10                	mov    %edx,(%eax)
  8008d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	83 e8 04             	sub    $0x4,%eax
  8008e0:	8b 00                	mov    (%eax),%eax
  8008e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e7:	eb 1c                	jmp    800905 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	8b 00                	mov    (%eax),%eax
  8008ee:	8d 50 04             	lea    0x4(%eax),%edx
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	89 10                	mov    %edx,(%eax)
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	8b 00                	mov    (%eax),%eax
  8008fb:	83 e8 04             	sub    $0x4,%eax
  8008fe:	8b 00                	mov    (%eax),%eax
  800900:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800905:	5d                   	pop    %ebp
  800906:	c3                   	ret    

00800907 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80090a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80090e:	7e 1c                	jle    80092c <getint+0x25>
		return va_arg(*ap, long long);
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	8b 00                	mov    (%eax),%eax
  800915:	8d 50 08             	lea    0x8(%eax),%edx
  800918:	8b 45 08             	mov    0x8(%ebp),%eax
  80091b:	89 10                	mov    %edx,(%eax)
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	8b 00                	mov    (%eax),%eax
  800922:	83 e8 08             	sub    $0x8,%eax
  800925:	8b 50 04             	mov    0x4(%eax),%edx
  800928:	8b 00                	mov    (%eax),%eax
  80092a:	eb 38                	jmp    800964 <getint+0x5d>
	else if (lflag)
  80092c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800930:	74 1a                	je     80094c <getint+0x45>
		return va_arg(*ap, long);
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	8b 00                	mov    (%eax),%eax
  800937:	8d 50 04             	lea    0x4(%eax),%edx
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	89 10                	mov    %edx,(%eax)
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	8b 00                	mov    (%eax),%eax
  800944:	83 e8 04             	sub    $0x4,%eax
  800947:	8b 00                	mov    (%eax),%eax
  800949:	99                   	cltd   
  80094a:	eb 18                	jmp    800964 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	8d 50 04             	lea    0x4(%eax),%edx
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	89 10                	mov    %edx,(%eax)
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	83 e8 04             	sub    $0x4,%eax
  800961:	8b 00                	mov    (%eax),%eax
  800963:	99                   	cltd   
}
  800964:	5d                   	pop    %ebp
  800965:	c3                   	ret    

00800966 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800966:	55                   	push   %ebp
  800967:	89 e5                	mov    %esp,%ebp
  800969:	56                   	push   %esi
  80096a:	53                   	push   %ebx
  80096b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096e:	eb 17                	jmp    800987 <vprintfmt+0x21>
			if (ch == '\0')
  800970:	85 db                	test   %ebx,%ebx
  800972:	0f 84 c1 03 00 00    	je     800d39 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	ff 75 0c             	pushl  0xc(%ebp)
  80097e:	53                   	push   %ebx
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	ff d0                	call   *%eax
  800984:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800987:	8b 45 10             	mov    0x10(%ebp),%eax
  80098a:	8d 50 01             	lea    0x1(%eax),%edx
  80098d:	89 55 10             	mov    %edx,0x10(%ebp)
  800990:	8a 00                	mov    (%eax),%al
  800992:	0f b6 d8             	movzbl %al,%ebx
  800995:	83 fb 25             	cmp    $0x25,%ebx
  800998:	75 d6                	jne    800970 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80099a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80099e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009a5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009ac:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009b3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8009bd:	8d 50 01             	lea    0x1(%eax),%edx
  8009c0:	89 55 10             	mov    %edx,0x10(%ebp)
  8009c3:	8a 00                	mov    (%eax),%al
  8009c5:	0f b6 d8             	movzbl %al,%ebx
  8009c8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009cb:	83 f8 5b             	cmp    $0x5b,%eax
  8009ce:	0f 87 3d 03 00 00    	ja     800d11 <vprintfmt+0x3ab>
  8009d4:	8b 04 85 d8 25 80 00 	mov    0x8025d8(,%eax,4),%eax
  8009db:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009dd:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009e1:	eb d7                	jmp    8009ba <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009e3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009e7:	eb d1                	jmp    8009ba <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009f3:	89 d0                	mov    %edx,%eax
  8009f5:	c1 e0 02             	shl    $0x2,%eax
  8009f8:	01 d0                	add    %edx,%eax
  8009fa:	01 c0                	add    %eax,%eax
  8009fc:	01 d8                	add    %ebx,%eax
  8009fe:	83 e8 30             	sub    $0x30,%eax
  800a01:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a04:	8b 45 10             	mov    0x10(%ebp),%eax
  800a07:	8a 00                	mov    (%eax),%al
  800a09:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a0c:	83 fb 2f             	cmp    $0x2f,%ebx
  800a0f:	7e 3e                	jle    800a4f <vprintfmt+0xe9>
  800a11:	83 fb 39             	cmp    $0x39,%ebx
  800a14:	7f 39                	jg     800a4f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a16:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a19:	eb d5                	jmp    8009f0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1e:	83 c0 04             	add    $0x4,%eax
  800a21:	89 45 14             	mov    %eax,0x14(%ebp)
  800a24:	8b 45 14             	mov    0x14(%ebp),%eax
  800a27:	83 e8 04             	sub    $0x4,%eax
  800a2a:	8b 00                	mov    (%eax),%eax
  800a2c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a2f:	eb 1f                	jmp    800a50 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a31:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a35:	79 83                	jns    8009ba <vprintfmt+0x54>
				width = 0;
  800a37:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a3e:	e9 77 ff ff ff       	jmp    8009ba <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a43:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a4a:	e9 6b ff ff ff       	jmp    8009ba <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a4f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a50:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a54:	0f 89 60 ff ff ff    	jns    8009ba <vprintfmt+0x54>
				width = precision, precision = -1;
  800a5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a5d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a60:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a67:	e9 4e ff ff ff       	jmp    8009ba <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a6c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a6f:	e9 46 ff ff ff       	jmp    8009ba <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a74:	8b 45 14             	mov    0x14(%ebp),%eax
  800a77:	83 c0 04             	add    $0x4,%eax
  800a7a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a80:	83 e8 04             	sub    $0x4,%eax
  800a83:	8b 00                	mov    (%eax),%eax
  800a85:	83 ec 08             	sub    $0x8,%esp
  800a88:	ff 75 0c             	pushl  0xc(%ebp)
  800a8b:	50                   	push   %eax
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	ff d0                	call   *%eax
  800a91:	83 c4 10             	add    $0x10,%esp
			break;
  800a94:	e9 9b 02 00 00       	jmp    800d34 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a99:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9c:	83 c0 04             	add    $0x4,%eax
  800a9f:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa5:	83 e8 04             	sub    $0x4,%eax
  800aa8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aaa:	85 db                	test   %ebx,%ebx
  800aac:	79 02                	jns    800ab0 <vprintfmt+0x14a>
				err = -err;
  800aae:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ab0:	83 fb 64             	cmp    $0x64,%ebx
  800ab3:	7f 0b                	jg     800ac0 <vprintfmt+0x15a>
  800ab5:	8b 34 9d 20 24 80 00 	mov    0x802420(,%ebx,4),%esi
  800abc:	85 f6                	test   %esi,%esi
  800abe:	75 19                	jne    800ad9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ac0:	53                   	push   %ebx
  800ac1:	68 c5 25 80 00       	push   $0x8025c5
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	ff 75 08             	pushl  0x8(%ebp)
  800acc:	e8 70 02 00 00       	call   800d41 <printfmt>
  800ad1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ad4:	e9 5b 02 00 00       	jmp    800d34 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ad9:	56                   	push   %esi
  800ada:	68 ce 25 80 00       	push   $0x8025ce
  800adf:	ff 75 0c             	pushl  0xc(%ebp)
  800ae2:	ff 75 08             	pushl  0x8(%ebp)
  800ae5:	e8 57 02 00 00       	call   800d41 <printfmt>
  800aea:	83 c4 10             	add    $0x10,%esp
			break;
  800aed:	e9 42 02 00 00       	jmp    800d34 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800af2:	8b 45 14             	mov    0x14(%ebp),%eax
  800af5:	83 c0 04             	add    $0x4,%eax
  800af8:	89 45 14             	mov    %eax,0x14(%ebp)
  800afb:	8b 45 14             	mov    0x14(%ebp),%eax
  800afe:	83 e8 04             	sub    $0x4,%eax
  800b01:	8b 30                	mov    (%eax),%esi
  800b03:	85 f6                	test   %esi,%esi
  800b05:	75 05                	jne    800b0c <vprintfmt+0x1a6>
				p = "(null)";
  800b07:	be d1 25 80 00       	mov    $0x8025d1,%esi
			if (width > 0 && padc != '-')
  800b0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b10:	7e 6d                	jle    800b7f <vprintfmt+0x219>
  800b12:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b16:	74 67                	je     800b7f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b18:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b1b:	83 ec 08             	sub    $0x8,%esp
  800b1e:	50                   	push   %eax
  800b1f:	56                   	push   %esi
  800b20:	e8 1e 03 00 00       	call   800e43 <strnlen>
  800b25:	83 c4 10             	add    $0x10,%esp
  800b28:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b2b:	eb 16                	jmp    800b43 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b2d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	ff 75 0c             	pushl  0xc(%ebp)
  800b37:	50                   	push   %eax
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	ff d0                	call   *%eax
  800b3d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b40:	ff 4d e4             	decl   -0x1c(%ebp)
  800b43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b47:	7f e4                	jg     800b2d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b49:	eb 34                	jmp    800b7f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b4b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b4f:	74 1c                	je     800b6d <vprintfmt+0x207>
  800b51:	83 fb 1f             	cmp    $0x1f,%ebx
  800b54:	7e 05                	jle    800b5b <vprintfmt+0x1f5>
  800b56:	83 fb 7e             	cmp    $0x7e,%ebx
  800b59:	7e 12                	jle    800b6d <vprintfmt+0x207>
					putch('?', putdat);
  800b5b:	83 ec 08             	sub    $0x8,%esp
  800b5e:	ff 75 0c             	pushl  0xc(%ebp)
  800b61:	6a 3f                	push   $0x3f
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	ff d0                	call   *%eax
  800b68:	83 c4 10             	add    $0x10,%esp
  800b6b:	eb 0f                	jmp    800b7c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	53                   	push   %ebx
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	ff d0                	call   *%eax
  800b79:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b7c:	ff 4d e4             	decl   -0x1c(%ebp)
  800b7f:	89 f0                	mov    %esi,%eax
  800b81:	8d 70 01             	lea    0x1(%eax),%esi
  800b84:	8a 00                	mov    (%eax),%al
  800b86:	0f be d8             	movsbl %al,%ebx
  800b89:	85 db                	test   %ebx,%ebx
  800b8b:	74 24                	je     800bb1 <vprintfmt+0x24b>
  800b8d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b91:	78 b8                	js     800b4b <vprintfmt+0x1e5>
  800b93:	ff 4d e0             	decl   -0x20(%ebp)
  800b96:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b9a:	79 af                	jns    800b4b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b9c:	eb 13                	jmp    800bb1 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b9e:	83 ec 08             	sub    $0x8,%esp
  800ba1:	ff 75 0c             	pushl  0xc(%ebp)
  800ba4:	6a 20                	push   $0x20
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	ff d0                	call   *%eax
  800bab:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bae:	ff 4d e4             	decl   -0x1c(%ebp)
  800bb1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb5:	7f e7                	jg     800b9e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bb7:	e9 78 01 00 00       	jmp    800d34 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bbc:	83 ec 08             	sub    $0x8,%esp
  800bbf:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc2:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc5:	50                   	push   %eax
  800bc6:	e8 3c fd ff ff       	call   800907 <getint>
  800bcb:	83 c4 10             	add    $0x10,%esp
  800bce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bda:	85 d2                	test   %edx,%edx
  800bdc:	79 23                	jns    800c01 <vprintfmt+0x29b>
				putch('-', putdat);
  800bde:	83 ec 08             	sub    $0x8,%esp
  800be1:	ff 75 0c             	pushl  0xc(%ebp)
  800be4:	6a 2d                	push   $0x2d
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	ff d0                	call   *%eax
  800beb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf4:	f7 d8                	neg    %eax
  800bf6:	83 d2 00             	adc    $0x0,%edx
  800bf9:	f7 da                	neg    %edx
  800bfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c01:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c08:	e9 bc 00 00 00       	jmp    800cc9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c0d:	83 ec 08             	sub    $0x8,%esp
  800c10:	ff 75 e8             	pushl  -0x18(%ebp)
  800c13:	8d 45 14             	lea    0x14(%ebp),%eax
  800c16:	50                   	push   %eax
  800c17:	e8 84 fc ff ff       	call   8008a0 <getuint>
  800c1c:	83 c4 10             	add    $0x10,%esp
  800c1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c25:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c2c:	e9 98 00 00 00       	jmp    800cc9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c31:	83 ec 08             	sub    $0x8,%esp
  800c34:	ff 75 0c             	pushl  0xc(%ebp)
  800c37:	6a 58                	push   $0x58
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	ff d0                	call   *%eax
  800c3e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c41:	83 ec 08             	sub    $0x8,%esp
  800c44:	ff 75 0c             	pushl  0xc(%ebp)
  800c47:	6a 58                	push   $0x58
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	ff d0                	call   *%eax
  800c4e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c51:	83 ec 08             	sub    $0x8,%esp
  800c54:	ff 75 0c             	pushl  0xc(%ebp)
  800c57:	6a 58                	push   $0x58
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	ff d0                	call   *%eax
  800c5e:	83 c4 10             	add    $0x10,%esp
			break;
  800c61:	e9 ce 00 00 00       	jmp    800d34 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c66:	83 ec 08             	sub    $0x8,%esp
  800c69:	ff 75 0c             	pushl  0xc(%ebp)
  800c6c:	6a 30                	push   $0x30
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	ff d0                	call   *%eax
  800c73:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c76:	83 ec 08             	sub    $0x8,%esp
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	6a 78                	push   $0x78
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	ff d0                	call   *%eax
  800c83:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c86:	8b 45 14             	mov    0x14(%ebp),%eax
  800c89:	83 c0 04             	add    $0x4,%eax
  800c8c:	89 45 14             	mov    %eax,0x14(%ebp)
  800c8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c92:	83 e8 04             	sub    $0x4,%eax
  800c95:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ca1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ca8:	eb 1f                	jmp    800cc9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800caa:	83 ec 08             	sub    $0x8,%esp
  800cad:	ff 75 e8             	pushl  -0x18(%ebp)
  800cb0:	8d 45 14             	lea    0x14(%ebp),%eax
  800cb3:	50                   	push   %eax
  800cb4:	e8 e7 fb ff ff       	call   8008a0 <getuint>
  800cb9:	83 c4 10             	add    $0x10,%esp
  800cbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cc2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cc9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ccd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cd0:	83 ec 04             	sub    $0x4,%esp
  800cd3:	52                   	push   %edx
  800cd4:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cd7:	50                   	push   %eax
  800cd8:	ff 75 f4             	pushl  -0xc(%ebp)
  800cdb:	ff 75 f0             	pushl  -0x10(%ebp)
  800cde:	ff 75 0c             	pushl  0xc(%ebp)
  800ce1:	ff 75 08             	pushl  0x8(%ebp)
  800ce4:	e8 00 fb ff ff       	call   8007e9 <printnum>
  800ce9:	83 c4 20             	add    $0x20,%esp
			break;
  800cec:	eb 46                	jmp    800d34 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cee:	83 ec 08             	sub    $0x8,%esp
  800cf1:	ff 75 0c             	pushl  0xc(%ebp)
  800cf4:	53                   	push   %ebx
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	ff d0                	call   *%eax
  800cfa:	83 c4 10             	add    $0x10,%esp
			break;
  800cfd:	eb 35                	jmp    800d34 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800cff:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800d06:	eb 2c                	jmp    800d34 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d08:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800d0f:	eb 23                	jmp    800d34 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d11:	83 ec 08             	sub    $0x8,%esp
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	6a 25                	push   $0x25
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	ff d0                	call   *%eax
  800d1e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d21:	ff 4d 10             	decl   0x10(%ebp)
  800d24:	eb 03                	jmp    800d29 <vprintfmt+0x3c3>
  800d26:	ff 4d 10             	decl   0x10(%ebp)
  800d29:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2c:	48                   	dec    %eax
  800d2d:	8a 00                	mov    (%eax),%al
  800d2f:	3c 25                	cmp    $0x25,%al
  800d31:	75 f3                	jne    800d26 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d33:	90                   	nop
		}
	}
  800d34:	e9 35 fc ff ff       	jmp    80096e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d39:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d3d:	5b                   	pop    %ebx
  800d3e:	5e                   	pop    %esi
  800d3f:	5d                   	pop    %ebp
  800d40:	c3                   	ret    

00800d41 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
  800d44:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d47:	8d 45 10             	lea    0x10(%ebp),%eax
  800d4a:	83 c0 04             	add    $0x4,%eax
  800d4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d50:	8b 45 10             	mov    0x10(%ebp),%eax
  800d53:	ff 75 f4             	pushl  -0xc(%ebp)
  800d56:	50                   	push   %eax
  800d57:	ff 75 0c             	pushl  0xc(%ebp)
  800d5a:	ff 75 08             	pushl  0x8(%ebp)
  800d5d:	e8 04 fc ff ff       	call   800966 <vprintfmt>
  800d62:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d65:	90                   	nop
  800d66:	c9                   	leave  
  800d67:	c3                   	ret    

00800d68 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6e:	8b 40 08             	mov    0x8(%eax),%eax
  800d71:	8d 50 01             	lea    0x1(%eax),%edx
  800d74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d77:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7d:	8b 10                	mov    (%eax),%edx
  800d7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d82:	8b 40 04             	mov    0x4(%eax),%eax
  800d85:	39 c2                	cmp    %eax,%edx
  800d87:	73 12                	jae    800d9b <sprintputch+0x33>
		*b->buf++ = ch;
  800d89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8c:	8b 00                	mov    (%eax),%eax
  800d8e:	8d 48 01             	lea    0x1(%eax),%ecx
  800d91:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d94:	89 0a                	mov    %ecx,(%edx)
  800d96:	8b 55 08             	mov    0x8(%ebp),%edx
  800d99:	88 10                	mov    %dl,(%eax)
}
  800d9b:	90                   	nop
  800d9c:	5d                   	pop    %ebp
  800d9d:	c3                   	ret    

00800d9e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d9e:	55                   	push   %ebp
  800d9f:	89 e5                	mov    %esp,%ebp
  800da1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dad:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	01 d0                	add    %edx,%eax
  800db5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800db8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dbf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dc3:	74 06                	je     800dcb <vsnprintf+0x2d>
  800dc5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dc9:	7f 07                	jg     800dd2 <vsnprintf+0x34>
		return -E_INVAL;
  800dcb:	b8 03 00 00 00       	mov    $0x3,%eax
  800dd0:	eb 20                	jmp    800df2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dd2:	ff 75 14             	pushl  0x14(%ebp)
  800dd5:	ff 75 10             	pushl  0x10(%ebp)
  800dd8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ddb:	50                   	push   %eax
  800ddc:	68 68 0d 80 00       	push   $0x800d68
  800de1:	e8 80 fb ff ff       	call   800966 <vprintfmt>
  800de6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800de9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dec:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800def:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800df2:	c9                   	leave  
  800df3:	c3                   	ret    

00800df4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dfa:	8d 45 10             	lea    0x10(%ebp),%eax
  800dfd:	83 c0 04             	add    $0x4,%eax
  800e00:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e03:	8b 45 10             	mov    0x10(%ebp),%eax
  800e06:	ff 75 f4             	pushl  -0xc(%ebp)
  800e09:	50                   	push   %eax
  800e0a:	ff 75 0c             	pushl  0xc(%ebp)
  800e0d:	ff 75 08             	pushl  0x8(%ebp)
  800e10:	e8 89 ff ff ff       	call   800d9e <vsnprintf>
  800e15:	83 c4 10             	add    $0x10,%esp
  800e18:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e1e:	c9                   	leave  
  800e1f:	c3                   	ret    

00800e20 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e2d:	eb 06                	jmp    800e35 <strlen+0x15>
		n++;
  800e2f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e32:	ff 45 08             	incl   0x8(%ebp)
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
  800e38:	8a 00                	mov    (%eax),%al
  800e3a:	84 c0                	test   %al,%al
  800e3c:	75 f1                	jne    800e2f <strlen+0xf>
		n++;
	return n;
  800e3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e41:	c9                   	leave  
  800e42:	c3                   	ret    

00800e43 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
  800e46:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e49:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e50:	eb 09                	jmp    800e5b <strnlen+0x18>
		n++;
  800e52:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e55:	ff 45 08             	incl   0x8(%ebp)
  800e58:	ff 4d 0c             	decl   0xc(%ebp)
  800e5b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e5f:	74 09                	je     800e6a <strnlen+0x27>
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	8a 00                	mov    (%eax),%al
  800e66:	84 c0                	test   %al,%al
  800e68:	75 e8                	jne    800e52 <strnlen+0xf>
		n++;
	return n;
  800e6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e6d:	c9                   	leave  
  800e6e:	c3                   	ret    

00800e6f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e6f:	55                   	push   %ebp
  800e70:	89 e5                	mov    %esp,%ebp
  800e72:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e7b:	90                   	nop
  800e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7f:	8d 50 01             	lea    0x1(%eax),%edx
  800e82:	89 55 08             	mov    %edx,0x8(%ebp)
  800e85:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e88:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e8b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e8e:	8a 12                	mov    (%edx),%dl
  800e90:	88 10                	mov    %dl,(%eax)
  800e92:	8a 00                	mov    (%eax),%al
  800e94:	84 c0                	test   %al,%al
  800e96:	75 e4                	jne    800e7c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e98:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e9b:	c9                   	leave  
  800e9c:	c3                   	ret    

00800e9d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e9d:	55                   	push   %ebp
  800e9e:	89 e5                	mov    %esp,%ebp
  800ea0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ea9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb0:	eb 1f                	jmp    800ed1 <strncpy+0x34>
		*dst++ = *src;
  800eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb5:	8d 50 01             	lea    0x1(%eax),%edx
  800eb8:	89 55 08             	mov    %edx,0x8(%ebp)
  800ebb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ebe:	8a 12                	mov    (%edx),%dl
  800ec0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec5:	8a 00                	mov    (%eax),%al
  800ec7:	84 c0                	test   %al,%al
  800ec9:	74 03                	je     800ece <strncpy+0x31>
			src++;
  800ecb:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ece:	ff 45 fc             	incl   -0x4(%ebp)
  800ed1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed4:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ed7:	72 d9                	jb     800eb2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ed9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800edc:	c9                   	leave  
  800edd:	c3                   	ret    

00800ede <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ede:	55                   	push   %ebp
  800edf:	89 e5                	mov    %esp,%ebp
  800ee1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800eea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eee:	74 30                	je     800f20 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ef0:	eb 16                	jmp    800f08 <strlcpy+0x2a>
			*dst++ = *src++;
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	8d 50 01             	lea    0x1(%eax),%edx
  800ef8:	89 55 08             	mov    %edx,0x8(%ebp)
  800efb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800efe:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f01:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f04:	8a 12                	mov    (%edx),%dl
  800f06:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f08:	ff 4d 10             	decl   0x10(%ebp)
  800f0b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f0f:	74 09                	je     800f1a <strlcpy+0x3c>
  800f11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	84 c0                	test   %al,%al
  800f18:	75 d8                	jne    800ef2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f20:	8b 55 08             	mov    0x8(%ebp),%edx
  800f23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f26:	29 c2                	sub    %eax,%edx
  800f28:	89 d0                	mov    %edx,%eax
}
  800f2a:	c9                   	leave  
  800f2b:	c3                   	ret    

00800f2c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f2f:	eb 06                	jmp    800f37 <strcmp+0xb>
		p++, q++;
  800f31:	ff 45 08             	incl   0x8(%ebp)
  800f34:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	8a 00                	mov    (%eax),%al
  800f3c:	84 c0                	test   %al,%al
  800f3e:	74 0e                	je     800f4e <strcmp+0x22>
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8a 10                	mov    (%eax),%dl
  800f45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f48:	8a 00                	mov    (%eax),%al
  800f4a:	38 c2                	cmp    %al,%dl
  800f4c:	74 e3                	je     800f31 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	0f b6 d0             	movzbl %al,%edx
  800f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	0f b6 c0             	movzbl %al,%eax
  800f5e:	29 c2                	sub    %eax,%edx
  800f60:	89 d0                	mov    %edx,%eax
}
  800f62:	5d                   	pop    %ebp
  800f63:	c3                   	ret    

00800f64 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f67:	eb 09                	jmp    800f72 <strncmp+0xe>
		n--, p++, q++;
  800f69:	ff 4d 10             	decl   0x10(%ebp)
  800f6c:	ff 45 08             	incl   0x8(%ebp)
  800f6f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f76:	74 17                	je     800f8f <strncmp+0x2b>
  800f78:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7b:	8a 00                	mov    (%eax),%al
  800f7d:	84 c0                	test   %al,%al
  800f7f:	74 0e                	je     800f8f <strncmp+0x2b>
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	8a 10                	mov    (%eax),%dl
  800f86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	38 c2                	cmp    %al,%dl
  800f8d:	74 da                	je     800f69 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f93:	75 07                	jne    800f9c <strncmp+0x38>
		return 0;
  800f95:	b8 00 00 00 00       	mov    $0x0,%eax
  800f9a:	eb 14                	jmp    800fb0 <strncmp+0x4c>
	else
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

00800fb2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fb2:	55                   	push   %ebp
  800fb3:	89 e5                	mov    %esp,%ebp
  800fb5:	83 ec 04             	sub    $0x4,%esp
  800fb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fbe:	eb 12                	jmp    800fd2 <strchr+0x20>
		if (*s == c)
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fc8:	75 05                	jne    800fcf <strchr+0x1d>
			return (char *) s;
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	eb 11                	jmp    800fe0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fcf:	ff 45 08             	incl   0x8(%ebp)
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	84 c0                	test   %al,%al
  800fd9:	75 e5                	jne    800fc0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fe0:	c9                   	leave  
  800fe1:	c3                   	ret    

00800fe2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fe2:	55                   	push   %ebp
  800fe3:	89 e5                	mov    %esp,%ebp
  800fe5:	83 ec 04             	sub    $0x4,%esp
  800fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800feb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fee:	eb 0d                	jmp    800ffd <strfind+0x1b>
		if (*s == c)
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	8a 00                	mov    (%eax),%al
  800ff5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ff8:	74 0e                	je     801008 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ffa:	ff 45 08             	incl   0x8(%ebp)
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	84 c0                	test   %al,%al
  801004:	75 ea                	jne    800ff0 <strfind+0xe>
  801006:	eb 01                	jmp    801009 <strfind+0x27>
		if (*s == c)
			break;
  801008:	90                   	nop
	return (char *) s;
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80100c:	c9                   	leave  
  80100d:	c3                   	ret    

0080100e <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80100e:	55                   	push   %ebp
  80100f:	89 e5                	mov    %esp,%ebp
  801011:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80101a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80101e:	76 63                	jbe    801083 <memset+0x75>
		uint64 data_block = c;
  801020:	8b 45 0c             	mov    0xc(%ebp),%eax
  801023:	99                   	cltd   
  801024:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801027:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80102a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80102d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801030:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801034:	c1 e0 08             	shl    $0x8,%eax
  801037:	09 45 f0             	or     %eax,-0x10(%ebp)
  80103a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80103d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801040:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801043:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801047:	c1 e0 10             	shl    $0x10,%eax
  80104a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80104d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801050:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801053:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801056:	89 c2                	mov    %eax,%edx
  801058:	b8 00 00 00 00       	mov    $0x0,%eax
  80105d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801060:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801063:	eb 18                	jmp    80107d <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801065:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801068:	8d 41 08             	lea    0x8(%ecx),%eax
  80106b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80106e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801071:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801074:	89 01                	mov    %eax,(%ecx)
  801076:	89 51 04             	mov    %edx,0x4(%ecx)
  801079:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80107d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801081:	77 e2                	ja     801065 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801083:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801087:	74 23                	je     8010ac <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801089:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80108c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80108f:	eb 0e                	jmp    80109f <memset+0x91>
			*p8++ = (uint8)c;
  801091:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801094:	8d 50 01             	lea    0x1(%eax),%edx
  801097:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80109a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80109d:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80109f:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010a5:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a8:	85 c0                	test   %eax,%eax
  8010aa:	75 e5                	jne    801091 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010af:	c9                   	leave  
  8010b0:	c3                   	ret    

008010b1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010b1:	55                   	push   %ebp
  8010b2:	89 e5                	mov    %esp,%ebp
  8010b4:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010c3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010c7:	76 24                	jbe    8010ed <memcpy+0x3c>
		while(n >= 8){
  8010c9:	eb 1c                	jmp    8010e7 <memcpy+0x36>
			*d64 = *s64;
  8010cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ce:	8b 50 04             	mov    0x4(%eax),%edx
  8010d1:	8b 00                	mov    (%eax),%eax
  8010d3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010d6:	89 01                	mov    %eax,(%ecx)
  8010d8:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010db:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010df:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010e3:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010e7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010eb:	77 de                	ja     8010cb <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f1:	74 31                	je     801124 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8010ff:	eb 16                	jmp    801117 <memcpy+0x66>
			*d8++ = *s8++;
  801101:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801104:	8d 50 01             	lea    0x1(%eax),%edx
  801107:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80110a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801110:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801113:	8a 12                	mov    (%edx),%dl
  801115:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801117:	8b 45 10             	mov    0x10(%ebp),%eax
  80111a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80111d:	89 55 10             	mov    %edx,0x10(%ebp)
  801120:	85 c0                	test   %eax,%eax
  801122:	75 dd                	jne    801101 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801124:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801127:	c9                   	leave  
  801128:	c3                   	ret    

00801129 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801129:	55                   	push   %ebp
  80112a:	89 e5                	mov    %esp,%ebp
  80112c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80112f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801132:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80113b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80113e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801141:	73 50                	jae    801193 <memmove+0x6a>
  801143:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801146:	8b 45 10             	mov    0x10(%ebp),%eax
  801149:	01 d0                	add    %edx,%eax
  80114b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80114e:	76 43                	jbe    801193 <memmove+0x6a>
		s += n;
  801150:	8b 45 10             	mov    0x10(%ebp),%eax
  801153:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801156:	8b 45 10             	mov    0x10(%ebp),%eax
  801159:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80115c:	eb 10                	jmp    80116e <memmove+0x45>
			*--d = *--s;
  80115e:	ff 4d f8             	decl   -0x8(%ebp)
  801161:	ff 4d fc             	decl   -0x4(%ebp)
  801164:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801167:	8a 10                	mov    (%eax),%dl
  801169:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80116c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80116e:	8b 45 10             	mov    0x10(%ebp),%eax
  801171:	8d 50 ff             	lea    -0x1(%eax),%edx
  801174:	89 55 10             	mov    %edx,0x10(%ebp)
  801177:	85 c0                	test   %eax,%eax
  801179:	75 e3                	jne    80115e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80117b:	eb 23                	jmp    8011a0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80117d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801180:	8d 50 01             	lea    0x1(%eax),%edx
  801183:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801186:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801189:	8d 4a 01             	lea    0x1(%edx),%ecx
  80118c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80118f:	8a 12                	mov    (%edx),%dl
  801191:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801193:	8b 45 10             	mov    0x10(%ebp),%eax
  801196:	8d 50 ff             	lea    -0x1(%eax),%edx
  801199:	89 55 10             	mov    %edx,0x10(%ebp)
  80119c:	85 c0                	test   %eax,%eax
  80119e:	75 dd                	jne    80117d <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011a3:	c9                   	leave  
  8011a4:	c3                   	ret    

008011a5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011b7:	eb 2a                	jmp    8011e3 <memcmp+0x3e>
		if (*s1 != *s2)
  8011b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011bc:	8a 10                	mov    (%eax),%dl
  8011be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c1:	8a 00                	mov    (%eax),%al
  8011c3:	38 c2                	cmp    %al,%dl
  8011c5:	74 16                	je     8011dd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	0f b6 d0             	movzbl %al,%edx
  8011cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	0f b6 c0             	movzbl %al,%eax
  8011d7:	29 c2                	sub    %eax,%edx
  8011d9:	89 d0                	mov    %edx,%eax
  8011db:	eb 18                	jmp    8011f5 <memcmp+0x50>
		s1++, s2++;
  8011dd:	ff 45 fc             	incl   -0x4(%ebp)
  8011e0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011e9:	89 55 10             	mov    %edx,0x10(%ebp)
  8011ec:	85 c0                	test   %eax,%eax
  8011ee:	75 c9                	jne    8011b9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011f5:	c9                   	leave  
  8011f6:	c3                   	ret    

008011f7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801200:	8b 45 10             	mov    0x10(%ebp),%eax
  801203:	01 d0                	add    %edx,%eax
  801205:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801208:	eb 15                	jmp    80121f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80120a:	8b 45 08             	mov    0x8(%ebp),%eax
  80120d:	8a 00                	mov    (%eax),%al
  80120f:	0f b6 d0             	movzbl %al,%edx
  801212:	8b 45 0c             	mov    0xc(%ebp),%eax
  801215:	0f b6 c0             	movzbl %al,%eax
  801218:	39 c2                	cmp    %eax,%edx
  80121a:	74 0d                	je     801229 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80121c:	ff 45 08             	incl   0x8(%ebp)
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801225:	72 e3                	jb     80120a <memfind+0x13>
  801227:	eb 01                	jmp    80122a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801229:	90                   	nop
	return (void *) s;
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80122d:	c9                   	leave  
  80122e:	c3                   	ret    

0080122f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80122f:	55                   	push   %ebp
  801230:	89 e5                	mov    %esp,%ebp
  801232:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801235:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80123c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801243:	eb 03                	jmp    801248 <strtol+0x19>
		s++;
  801245:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	8a 00                	mov    (%eax),%al
  80124d:	3c 20                	cmp    $0x20,%al
  80124f:	74 f4                	je     801245 <strtol+0x16>
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	8a 00                	mov    (%eax),%al
  801256:	3c 09                	cmp    $0x9,%al
  801258:	74 eb                	je     801245 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	8a 00                	mov    (%eax),%al
  80125f:	3c 2b                	cmp    $0x2b,%al
  801261:	75 05                	jne    801268 <strtol+0x39>
		s++;
  801263:	ff 45 08             	incl   0x8(%ebp)
  801266:	eb 13                	jmp    80127b <strtol+0x4c>
	else if (*s == '-')
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	8a 00                	mov    (%eax),%al
  80126d:	3c 2d                	cmp    $0x2d,%al
  80126f:	75 0a                	jne    80127b <strtol+0x4c>
		s++, neg = 1;
  801271:	ff 45 08             	incl   0x8(%ebp)
  801274:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80127b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80127f:	74 06                	je     801287 <strtol+0x58>
  801281:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801285:	75 20                	jne    8012a7 <strtol+0x78>
  801287:	8b 45 08             	mov    0x8(%ebp),%eax
  80128a:	8a 00                	mov    (%eax),%al
  80128c:	3c 30                	cmp    $0x30,%al
  80128e:	75 17                	jne    8012a7 <strtol+0x78>
  801290:	8b 45 08             	mov    0x8(%ebp),%eax
  801293:	40                   	inc    %eax
  801294:	8a 00                	mov    (%eax),%al
  801296:	3c 78                	cmp    $0x78,%al
  801298:	75 0d                	jne    8012a7 <strtol+0x78>
		s += 2, base = 16;
  80129a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80129e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012a5:	eb 28                	jmp    8012cf <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ab:	75 15                	jne    8012c2 <strtol+0x93>
  8012ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b0:	8a 00                	mov    (%eax),%al
  8012b2:	3c 30                	cmp    $0x30,%al
  8012b4:	75 0c                	jne    8012c2 <strtol+0x93>
		s++, base = 8;
  8012b6:	ff 45 08             	incl   0x8(%ebp)
  8012b9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012c0:	eb 0d                	jmp    8012cf <strtol+0xa0>
	else if (base == 0)
  8012c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c6:	75 07                	jne    8012cf <strtol+0xa0>
		base = 10;
  8012c8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	8a 00                	mov    (%eax),%al
  8012d4:	3c 2f                	cmp    $0x2f,%al
  8012d6:	7e 19                	jle    8012f1 <strtol+0xc2>
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	8a 00                	mov    (%eax),%al
  8012dd:	3c 39                	cmp    $0x39,%al
  8012df:	7f 10                	jg     8012f1 <strtol+0xc2>
			dig = *s - '0';
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	8a 00                	mov    (%eax),%al
  8012e6:	0f be c0             	movsbl %al,%eax
  8012e9:	83 e8 30             	sub    $0x30,%eax
  8012ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012ef:	eb 42                	jmp    801333 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	8a 00                	mov    (%eax),%al
  8012f6:	3c 60                	cmp    $0x60,%al
  8012f8:	7e 19                	jle    801313 <strtol+0xe4>
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	8a 00                	mov    (%eax),%al
  8012ff:	3c 7a                	cmp    $0x7a,%al
  801301:	7f 10                	jg     801313 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801303:	8b 45 08             	mov    0x8(%ebp),%eax
  801306:	8a 00                	mov    (%eax),%al
  801308:	0f be c0             	movsbl %al,%eax
  80130b:	83 e8 57             	sub    $0x57,%eax
  80130e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801311:	eb 20                	jmp    801333 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801313:	8b 45 08             	mov    0x8(%ebp),%eax
  801316:	8a 00                	mov    (%eax),%al
  801318:	3c 40                	cmp    $0x40,%al
  80131a:	7e 39                	jle    801355 <strtol+0x126>
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	8a 00                	mov    (%eax),%al
  801321:	3c 5a                	cmp    $0x5a,%al
  801323:	7f 30                	jg     801355 <strtol+0x126>
			dig = *s - 'A' + 10;
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
  801328:	8a 00                	mov    (%eax),%al
  80132a:	0f be c0             	movsbl %al,%eax
  80132d:	83 e8 37             	sub    $0x37,%eax
  801330:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801336:	3b 45 10             	cmp    0x10(%ebp),%eax
  801339:	7d 19                	jge    801354 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80133b:	ff 45 08             	incl   0x8(%ebp)
  80133e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801341:	0f af 45 10          	imul   0x10(%ebp),%eax
  801345:	89 c2                	mov    %eax,%edx
  801347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134a:	01 d0                	add    %edx,%eax
  80134c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80134f:	e9 7b ff ff ff       	jmp    8012cf <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801354:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801355:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801359:	74 08                	je     801363 <strtol+0x134>
		*endptr = (char *) s;
  80135b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135e:	8b 55 08             	mov    0x8(%ebp),%edx
  801361:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801363:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801367:	74 07                	je     801370 <strtol+0x141>
  801369:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136c:	f7 d8                	neg    %eax
  80136e:	eb 03                	jmp    801373 <strtol+0x144>
  801370:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801373:	c9                   	leave  
  801374:	c3                   	ret    

00801375 <ltostr>:

void
ltostr(long value, char *str)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
  801378:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80137b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801382:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801389:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80138d:	79 13                	jns    8013a2 <ltostr+0x2d>
	{
		neg = 1;
  80138f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801396:	8b 45 0c             	mov    0xc(%ebp),%eax
  801399:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80139c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80139f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013aa:	99                   	cltd   
  8013ab:	f7 f9                	idiv   %ecx
  8013ad:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013b3:	8d 50 01             	lea    0x1(%eax),%edx
  8013b6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013b9:	89 c2                	mov    %eax,%edx
  8013bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013be:	01 d0                	add    %edx,%eax
  8013c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013c3:	83 c2 30             	add    $0x30,%edx
  8013c6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013cb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013d0:	f7 e9                	imul   %ecx
  8013d2:	c1 fa 02             	sar    $0x2,%edx
  8013d5:	89 c8                	mov    %ecx,%eax
  8013d7:	c1 f8 1f             	sar    $0x1f,%eax
  8013da:	29 c2                	sub    %eax,%edx
  8013dc:	89 d0                	mov    %edx,%eax
  8013de:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013e5:	75 bb                	jne    8013a2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f1:	48                   	dec    %eax
  8013f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013f9:	74 3d                	je     801438 <ltostr+0xc3>
		start = 1 ;
  8013fb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801402:	eb 34                	jmp    801438 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801404:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801407:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140a:	01 d0                	add    %edx,%eax
  80140c:	8a 00                	mov    (%eax),%al
  80140e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801411:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801414:	8b 45 0c             	mov    0xc(%ebp),%eax
  801417:	01 c2                	add    %eax,%edx
  801419:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80141c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141f:	01 c8                	add    %ecx,%eax
  801421:	8a 00                	mov    (%eax),%al
  801423:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801425:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801428:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142b:	01 c2                	add    %eax,%edx
  80142d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801430:	88 02                	mov    %al,(%edx)
		start++ ;
  801432:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801435:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80143b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80143e:	7c c4                	jl     801404 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801440:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801443:	8b 45 0c             	mov    0xc(%ebp),%eax
  801446:	01 d0                	add    %edx,%eax
  801448:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80144b:	90                   	nop
  80144c:	c9                   	leave  
  80144d:	c3                   	ret    

0080144e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801454:	ff 75 08             	pushl  0x8(%ebp)
  801457:	e8 c4 f9 ff ff       	call   800e20 <strlen>
  80145c:	83 c4 04             	add    $0x4,%esp
  80145f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801462:	ff 75 0c             	pushl  0xc(%ebp)
  801465:	e8 b6 f9 ff ff       	call   800e20 <strlen>
  80146a:	83 c4 04             	add    $0x4,%esp
  80146d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801470:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801477:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80147e:	eb 17                	jmp    801497 <strcconcat+0x49>
		final[s] = str1[s] ;
  801480:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801483:	8b 45 10             	mov    0x10(%ebp),%eax
  801486:	01 c2                	add    %eax,%edx
  801488:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	01 c8                	add    %ecx,%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801494:	ff 45 fc             	incl   -0x4(%ebp)
  801497:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80149a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80149d:	7c e1                	jl     801480 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80149f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014ad:	eb 1f                	jmp    8014ce <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b2:	8d 50 01             	lea    0x1(%eax),%edx
  8014b5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014b8:	89 c2                	mov    %eax,%edx
  8014ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bd:	01 c2                	add    %eax,%edx
  8014bf:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c5:	01 c8                	add    %ecx,%eax
  8014c7:	8a 00                	mov    (%eax),%al
  8014c9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014cb:	ff 45 f8             	incl   -0x8(%ebp)
  8014ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014d1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014d4:	7c d9                	jl     8014af <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014dc:	01 d0                	add    %edx,%eax
  8014de:	c6 00 00             	movb   $0x0,(%eax)
}
  8014e1:	90                   	nop
  8014e2:	c9                   	leave  
  8014e3:	c3                   	ret    

008014e4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f3:	8b 00                	mov    (%eax),%eax
  8014f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ff:	01 d0                	add    %edx,%eax
  801501:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801507:	eb 0c                	jmp    801515 <strsplit+0x31>
			*string++ = 0;
  801509:	8b 45 08             	mov    0x8(%ebp),%eax
  80150c:	8d 50 01             	lea    0x1(%eax),%edx
  80150f:	89 55 08             	mov    %edx,0x8(%ebp)
  801512:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801515:	8b 45 08             	mov    0x8(%ebp),%eax
  801518:	8a 00                	mov    (%eax),%al
  80151a:	84 c0                	test   %al,%al
  80151c:	74 18                	je     801536 <strsplit+0x52>
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	8a 00                	mov    (%eax),%al
  801523:	0f be c0             	movsbl %al,%eax
  801526:	50                   	push   %eax
  801527:	ff 75 0c             	pushl  0xc(%ebp)
  80152a:	e8 83 fa ff ff       	call   800fb2 <strchr>
  80152f:	83 c4 08             	add    $0x8,%esp
  801532:	85 c0                	test   %eax,%eax
  801534:	75 d3                	jne    801509 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801536:	8b 45 08             	mov    0x8(%ebp),%eax
  801539:	8a 00                	mov    (%eax),%al
  80153b:	84 c0                	test   %al,%al
  80153d:	74 5a                	je     801599 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80153f:	8b 45 14             	mov    0x14(%ebp),%eax
  801542:	8b 00                	mov    (%eax),%eax
  801544:	83 f8 0f             	cmp    $0xf,%eax
  801547:	75 07                	jne    801550 <strsplit+0x6c>
		{
			return 0;
  801549:	b8 00 00 00 00       	mov    $0x0,%eax
  80154e:	eb 66                	jmp    8015b6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801550:	8b 45 14             	mov    0x14(%ebp),%eax
  801553:	8b 00                	mov    (%eax),%eax
  801555:	8d 48 01             	lea    0x1(%eax),%ecx
  801558:	8b 55 14             	mov    0x14(%ebp),%edx
  80155b:	89 0a                	mov    %ecx,(%edx)
  80155d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801564:	8b 45 10             	mov    0x10(%ebp),%eax
  801567:	01 c2                	add    %eax,%edx
  801569:	8b 45 08             	mov    0x8(%ebp),%eax
  80156c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80156e:	eb 03                	jmp    801573 <strsplit+0x8f>
			string++;
  801570:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801573:	8b 45 08             	mov    0x8(%ebp),%eax
  801576:	8a 00                	mov    (%eax),%al
  801578:	84 c0                	test   %al,%al
  80157a:	74 8b                	je     801507 <strsplit+0x23>
  80157c:	8b 45 08             	mov    0x8(%ebp),%eax
  80157f:	8a 00                	mov    (%eax),%al
  801581:	0f be c0             	movsbl %al,%eax
  801584:	50                   	push   %eax
  801585:	ff 75 0c             	pushl  0xc(%ebp)
  801588:	e8 25 fa ff ff       	call   800fb2 <strchr>
  80158d:	83 c4 08             	add    $0x8,%esp
  801590:	85 c0                	test   %eax,%eax
  801592:	74 dc                	je     801570 <strsplit+0x8c>
			string++;
	}
  801594:	e9 6e ff ff ff       	jmp    801507 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801599:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80159a:	8b 45 14             	mov    0x14(%ebp),%eax
  80159d:	8b 00                	mov    (%eax),%eax
  80159f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a9:	01 d0                	add    %edx,%eax
  8015ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015b1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015b6:	c9                   	leave  
  8015b7:	c3                   	ret    

008015b8 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015be:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015cb:	eb 4a                	jmp    801617 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	01 c2                	add    %eax,%edx
  8015d5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015db:	01 c8                	add    %ecx,%eax
  8015dd:	8a 00                	mov    (%eax),%al
  8015df:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e7:	01 d0                	add    %edx,%eax
  8015e9:	8a 00                	mov    (%eax),%al
  8015eb:	3c 40                	cmp    $0x40,%al
  8015ed:	7e 25                	jle    801614 <str2lower+0x5c>
  8015ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f5:	01 d0                	add    %edx,%eax
  8015f7:	8a 00                	mov    (%eax),%al
  8015f9:	3c 5a                	cmp    $0x5a,%al
  8015fb:	7f 17                	jg     801614 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8015fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
  801603:	01 d0                	add    %edx,%eax
  801605:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801608:	8b 55 08             	mov    0x8(%ebp),%edx
  80160b:	01 ca                	add    %ecx,%edx
  80160d:	8a 12                	mov    (%edx),%dl
  80160f:	83 c2 20             	add    $0x20,%edx
  801612:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801614:	ff 45 fc             	incl   -0x4(%ebp)
  801617:	ff 75 0c             	pushl  0xc(%ebp)
  80161a:	e8 01 f8 ff ff       	call   800e20 <strlen>
  80161f:	83 c4 04             	add    $0x4,%esp
  801622:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801625:	7f a6                	jg     8015cd <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801627:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    

0080162c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	57                   	push   %edi
  801630:	56                   	push   %esi
  801631:	53                   	push   %ebx
  801632:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80163e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801641:	8b 7d 18             	mov    0x18(%ebp),%edi
  801644:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801647:	cd 30                	int    $0x30
  801649:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80164c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80164f:	83 c4 10             	add    $0x10,%esp
  801652:	5b                   	pop    %ebx
  801653:	5e                   	pop    %esi
  801654:	5f                   	pop    %edi
  801655:	5d                   	pop    %ebp
  801656:	c3                   	ret    

00801657 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	83 ec 04             	sub    $0x4,%esp
  80165d:	8b 45 10             	mov    0x10(%ebp),%eax
  801660:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801663:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801666:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	6a 00                	push   $0x0
  80166f:	51                   	push   %ecx
  801670:	52                   	push   %edx
  801671:	ff 75 0c             	pushl  0xc(%ebp)
  801674:	50                   	push   %eax
  801675:	6a 00                	push   $0x0
  801677:	e8 b0 ff ff ff       	call   80162c <syscall>
  80167c:	83 c4 18             	add    $0x18,%esp
}
  80167f:	90                   	nop
  801680:	c9                   	leave  
  801681:	c3                   	ret    

00801682 <sys_cgetc>:

int
sys_cgetc(void)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 02                	push   $0x2
  801691:	e8 96 ff ff ff       	call   80162c <syscall>
  801696:	83 c4 18             	add    $0x18,%esp
}
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <sys_lock_cons>:

void sys_lock_cons(void)
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 03                	push   $0x3
  8016aa:	e8 7d ff ff ff       	call   80162c <syscall>
  8016af:	83 c4 18             	add    $0x18,%esp
}
  8016b2:	90                   	nop
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 04                	push   $0x4
  8016c4:	e8 63 ff ff ff       	call   80162c <syscall>
  8016c9:	83 c4 18             	add    $0x18,%esp
}
  8016cc:	90                   	nop
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	52                   	push   %edx
  8016df:	50                   	push   %eax
  8016e0:	6a 08                	push   $0x8
  8016e2:	e8 45 ff ff ff       	call   80162c <syscall>
  8016e7:	83 c4 18             	add    $0x18,%esp
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
  8016ef:	56                   	push   %esi
  8016f0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016f1:	8b 75 18             	mov    0x18(%ebp),%esi
  8016f4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	56                   	push   %esi
  801701:	53                   	push   %ebx
  801702:	51                   	push   %ecx
  801703:	52                   	push   %edx
  801704:	50                   	push   %eax
  801705:	6a 09                	push   $0x9
  801707:	e8 20 ff ff ff       	call   80162c <syscall>
  80170c:	83 c4 18             	add    $0x18,%esp
}
  80170f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801712:	5b                   	pop    %ebx
  801713:	5e                   	pop    %esi
  801714:	5d                   	pop    %ebp
  801715:	c3                   	ret    

00801716 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	ff 75 08             	pushl  0x8(%ebp)
  801724:	6a 0a                	push   $0xa
  801726:	e8 01 ff ff ff       	call   80162c <syscall>
  80172b:	83 c4 18             	add    $0x18,%esp
}
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	ff 75 0c             	pushl  0xc(%ebp)
  80173c:	ff 75 08             	pushl  0x8(%ebp)
  80173f:	6a 0b                	push   $0xb
  801741:	e8 e6 fe ff ff       	call   80162c <syscall>
  801746:	83 c4 18             	add    $0x18,%esp
}
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 0c                	push   $0xc
  80175a:	e8 cd fe ff ff       	call   80162c <syscall>
  80175f:	83 c4 18             	add    $0x18,%esp
}
  801762:	c9                   	leave  
  801763:	c3                   	ret    

00801764 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 0d                	push   $0xd
  801773:	e8 b4 fe ff ff       	call   80162c <syscall>
  801778:	83 c4 18             	add    $0x18,%esp
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 0e                	push   $0xe
  80178c:	e8 9b fe ff ff       	call   80162c <syscall>
  801791:	83 c4 18             	add    $0x18,%esp
}
  801794:	c9                   	leave  
  801795:	c3                   	ret    

00801796 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 0f                	push   $0xf
  8017a5:	e8 82 fe ff ff       	call   80162c <syscall>
  8017aa:	83 c4 18             	add    $0x18,%esp
}
  8017ad:	c9                   	leave  
  8017ae:	c3                   	ret    

008017af <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	ff 75 08             	pushl  0x8(%ebp)
  8017bd:	6a 10                	push   $0x10
  8017bf:	e8 68 fe ff ff       	call   80162c <syscall>
  8017c4:	83 c4 18             	add    $0x18,%esp
}
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    

008017c9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 11                	push   $0x11
  8017d8:	e8 4f fe ff ff       	call   80162c <syscall>
  8017dd:	83 c4 18             	add    $0x18,%esp
}
  8017e0:	90                   	nop
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    

008017e3 <sys_cputc>:

void
sys_cputc(const char c)
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
  8017e6:	83 ec 04             	sub    $0x4,%esp
  8017e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017ef:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	50                   	push   %eax
  8017fc:	6a 01                	push   $0x1
  8017fe:	e8 29 fe ff ff       	call   80162c <syscall>
  801803:	83 c4 18             	add    $0x18,%esp
}
  801806:	90                   	nop
  801807:	c9                   	leave  
  801808:	c3                   	ret    

00801809 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 14                	push   $0x14
  801818:	e8 0f fe ff ff       	call   80162c <syscall>
  80181d:	83 c4 18             	add    $0x18,%esp
}
  801820:	90                   	nop
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	83 ec 04             	sub    $0x4,%esp
  801829:	8b 45 10             	mov    0x10(%ebp),%eax
  80182c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80182f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801832:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
  801839:	6a 00                	push   $0x0
  80183b:	51                   	push   %ecx
  80183c:	52                   	push   %edx
  80183d:	ff 75 0c             	pushl  0xc(%ebp)
  801840:	50                   	push   %eax
  801841:	6a 15                	push   $0x15
  801843:	e8 e4 fd ff ff       	call   80162c <syscall>
  801848:	83 c4 18             	add    $0x18,%esp
}
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801850:	8b 55 0c             	mov    0xc(%ebp),%edx
  801853:	8b 45 08             	mov    0x8(%ebp),%eax
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	52                   	push   %edx
  80185d:	50                   	push   %eax
  80185e:	6a 16                	push   $0x16
  801860:	e8 c7 fd ff ff       	call   80162c <syscall>
  801865:	83 c4 18             	add    $0x18,%esp
}
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80186d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801870:	8b 55 0c             	mov    0xc(%ebp),%edx
  801873:	8b 45 08             	mov    0x8(%ebp),%eax
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	51                   	push   %ecx
  80187b:	52                   	push   %edx
  80187c:	50                   	push   %eax
  80187d:	6a 17                	push   $0x17
  80187f:	e8 a8 fd ff ff       	call   80162c <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80188c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188f:	8b 45 08             	mov    0x8(%ebp),%eax
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	52                   	push   %edx
  801899:	50                   	push   %eax
  80189a:	6a 18                	push   $0x18
  80189c:	e8 8b fd ff ff       	call   80162c <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	6a 00                	push   $0x0
  8018ae:	ff 75 14             	pushl  0x14(%ebp)
  8018b1:	ff 75 10             	pushl  0x10(%ebp)
  8018b4:	ff 75 0c             	pushl  0xc(%ebp)
  8018b7:	50                   	push   %eax
  8018b8:	6a 19                	push   $0x19
  8018ba:	e8 6d fd ff ff       	call   80162c <syscall>
  8018bf:	83 c4 18             	add    $0x18,%esp
}
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	50                   	push   %eax
  8018d3:	6a 1a                	push   $0x1a
  8018d5:	e8 52 fd ff ff       	call   80162c <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
}
  8018dd:	90                   	nop
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	50                   	push   %eax
  8018ef:	6a 1b                	push   $0x1b
  8018f1:	e8 36 fd ff ff       	call   80162c <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 05                	push   $0x5
  80190a:	e8 1d fd ff ff       	call   80162c <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 06                	push   $0x6
  801923:	e8 04 fd ff ff       	call   80162c <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
}
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 07                	push   $0x7
  80193c:	e8 eb fc ff ff       	call   80162c <syscall>
  801941:	83 c4 18             	add    $0x18,%esp
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_exit_env>:


void sys_exit_env(void)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 1c                	push   $0x1c
  801955:	e8 d2 fc ff ff       	call   80162c <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
}
  80195d:	90                   	nop
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801966:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801969:	8d 50 04             	lea    0x4(%eax),%edx
  80196c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	52                   	push   %edx
  801976:	50                   	push   %eax
  801977:	6a 1d                	push   $0x1d
  801979:	e8 ae fc ff ff       	call   80162c <syscall>
  80197e:	83 c4 18             	add    $0x18,%esp
	return result;
  801981:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801984:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801987:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80198a:	89 01                	mov    %eax,(%ecx)
  80198c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	c9                   	leave  
  801993:	c2 04 00             	ret    $0x4

00801996 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	ff 75 10             	pushl  0x10(%ebp)
  8019a0:	ff 75 0c             	pushl  0xc(%ebp)
  8019a3:	ff 75 08             	pushl  0x8(%ebp)
  8019a6:	6a 13                	push   $0x13
  8019a8:	e8 7f fc ff ff       	call   80162c <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b0:	90                   	nop
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 1e                	push   $0x1e
  8019c2:	e8 65 fc ff ff       	call   80162c <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	83 ec 04             	sub    $0x4,%esp
  8019d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019d8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	50                   	push   %eax
  8019e5:	6a 1f                	push   $0x1f
  8019e7:	e8 40 fc ff ff       	call   80162c <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ef:	90                   	nop
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <rsttst>:
void rsttst()
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 21                	push   $0x21
  801a01:	e8 26 fc ff ff       	call   80162c <syscall>
  801a06:	83 c4 18             	add    $0x18,%esp
	return ;
  801a09:	90                   	nop
}
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
  801a0f:	83 ec 04             	sub    $0x4,%esp
  801a12:	8b 45 14             	mov    0x14(%ebp),%eax
  801a15:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a18:	8b 55 18             	mov    0x18(%ebp),%edx
  801a1b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a1f:	52                   	push   %edx
  801a20:	50                   	push   %eax
  801a21:	ff 75 10             	pushl  0x10(%ebp)
  801a24:	ff 75 0c             	pushl  0xc(%ebp)
  801a27:	ff 75 08             	pushl  0x8(%ebp)
  801a2a:	6a 20                	push   $0x20
  801a2c:	e8 fb fb ff ff       	call   80162c <syscall>
  801a31:	83 c4 18             	add    $0x18,%esp
	return ;
  801a34:	90                   	nop
}
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <chktst>:
void chktst(uint32 n)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	ff 75 08             	pushl  0x8(%ebp)
  801a45:	6a 22                	push   $0x22
  801a47:	e8 e0 fb ff ff       	call   80162c <syscall>
  801a4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a4f:	90                   	nop
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <inctst>:

void inctst()
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 23                	push   $0x23
  801a61:	e8 c6 fb ff ff       	call   80162c <syscall>
  801a66:	83 c4 18             	add    $0x18,%esp
	return ;
  801a69:	90                   	nop
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <gettst>:
uint32 gettst()
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 24                	push   $0x24
  801a7b:	e8 ac fb ff ff       	call   80162c <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 25                	push   $0x25
  801a94:	e8 93 fb ff ff       	call   80162c <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
  801a9c:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801aa1:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801aa6:	c9                   	leave  
  801aa7:	c3                   	ret    

00801aa8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	ff 75 08             	pushl  0x8(%ebp)
  801abe:	6a 26                	push   $0x26
  801ac0:	e8 67 fb ff ff       	call   80162c <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac8:	90                   	nop
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
  801ace:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801acf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ad2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ad5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  801adb:	6a 00                	push   $0x0
  801add:	53                   	push   %ebx
  801ade:	51                   	push   %ecx
  801adf:	52                   	push   %edx
  801ae0:	50                   	push   %eax
  801ae1:	6a 27                	push   $0x27
  801ae3:	e8 44 fb ff ff       	call   80162c <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
}
  801aeb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801af3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	52                   	push   %edx
  801b00:	50                   	push   %eax
  801b01:	6a 28                	push   $0x28
  801b03:	e8 24 fb ff ff       	call   80162c <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b10:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b16:	8b 45 08             	mov    0x8(%ebp),%eax
  801b19:	6a 00                	push   $0x0
  801b1b:	51                   	push   %ecx
  801b1c:	ff 75 10             	pushl  0x10(%ebp)
  801b1f:	52                   	push   %edx
  801b20:	50                   	push   %eax
  801b21:	6a 29                	push   $0x29
  801b23:	e8 04 fb ff ff       	call   80162c <syscall>
  801b28:	83 c4 18             	add    $0x18,%esp
}
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	ff 75 10             	pushl  0x10(%ebp)
  801b37:	ff 75 0c             	pushl  0xc(%ebp)
  801b3a:	ff 75 08             	pushl  0x8(%ebp)
  801b3d:	6a 12                	push   $0x12
  801b3f:	e8 e8 fa ff ff       	call   80162c <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
	return ;
  801b47:	90                   	nop
}
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	52                   	push   %edx
  801b5a:	50                   	push   %eax
  801b5b:	6a 2a                	push   $0x2a
  801b5d:	e8 ca fa ff ff       	call   80162c <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
	return;
  801b65:	90                   	nop
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 2b                	push   $0x2b
  801b77:	e8 b0 fa ff ff       	call   80162c <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	ff 75 0c             	pushl  0xc(%ebp)
  801b8d:	ff 75 08             	pushl  0x8(%ebp)
  801b90:	6a 2d                	push   $0x2d
  801b92:	e8 95 fa ff ff       	call   80162c <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
	return;
  801b9a:	90                   	nop
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	ff 75 0c             	pushl  0xc(%ebp)
  801ba9:	ff 75 08             	pushl  0x8(%ebp)
  801bac:	6a 2c                	push   $0x2c
  801bae:	e8 79 fa ff ff       	call   80162c <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb6:	90                   	nop
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	52                   	push   %edx
  801bc9:	50                   	push   %eax
  801bca:	6a 2e                	push   $0x2e
  801bcc:	e8 5b fa ff ff       	call   80162c <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd4:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    
  801bd7:	90                   	nop

00801bd8 <__udivdi3>:
  801bd8:	55                   	push   %ebp
  801bd9:	57                   	push   %edi
  801bda:	56                   	push   %esi
  801bdb:	53                   	push   %ebx
  801bdc:	83 ec 1c             	sub    $0x1c,%esp
  801bdf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801be3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801be7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801beb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bef:	89 ca                	mov    %ecx,%edx
  801bf1:	89 f8                	mov    %edi,%eax
  801bf3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801bf7:	85 f6                	test   %esi,%esi
  801bf9:	75 2d                	jne    801c28 <__udivdi3+0x50>
  801bfb:	39 cf                	cmp    %ecx,%edi
  801bfd:	77 65                	ja     801c64 <__udivdi3+0x8c>
  801bff:	89 fd                	mov    %edi,%ebp
  801c01:	85 ff                	test   %edi,%edi
  801c03:	75 0b                	jne    801c10 <__udivdi3+0x38>
  801c05:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0a:	31 d2                	xor    %edx,%edx
  801c0c:	f7 f7                	div    %edi
  801c0e:	89 c5                	mov    %eax,%ebp
  801c10:	31 d2                	xor    %edx,%edx
  801c12:	89 c8                	mov    %ecx,%eax
  801c14:	f7 f5                	div    %ebp
  801c16:	89 c1                	mov    %eax,%ecx
  801c18:	89 d8                	mov    %ebx,%eax
  801c1a:	f7 f5                	div    %ebp
  801c1c:	89 cf                	mov    %ecx,%edi
  801c1e:	89 fa                	mov    %edi,%edx
  801c20:	83 c4 1c             	add    $0x1c,%esp
  801c23:	5b                   	pop    %ebx
  801c24:	5e                   	pop    %esi
  801c25:	5f                   	pop    %edi
  801c26:	5d                   	pop    %ebp
  801c27:	c3                   	ret    
  801c28:	39 ce                	cmp    %ecx,%esi
  801c2a:	77 28                	ja     801c54 <__udivdi3+0x7c>
  801c2c:	0f bd fe             	bsr    %esi,%edi
  801c2f:	83 f7 1f             	xor    $0x1f,%edi
  801c32:	75 40                	jne    801c74 <__udivdi3+0x9c>
  801c34:	39 ce                	cmp    %ecx,%esi
  801c36:	72 0a                	jb     801c42 <__udivdi3+0x6a>
  801c38:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c3c:	0f 87 9e 00 00 00    	ja     801ce0 <__udivdi3+0x108>
  801c42:	b8 01 00 00 00       	mov    $0x1,%eax
  801c47:	89 fa                	mov    %edi,%edx
  801c49:	83 c4 1c             	add    $0x1c,%esp
  801c4c:	5b                   	pop    %ebx
  801c4d:	5e                   	pop    %esi
  801c4e:	5f                   	pop    %edi
  801c4f:	5d                   	pop    %ebp
  801c50:	c3                   	ret    
  801c51:	8d 76 00             	lea    0x0(%esi),%esi
  801c54:	31 ff                	xor    %edi,%edi
  801c56:	31 c0                	xor    %eax,%eax
  801c58:	89 fa                	mov    %edi,%edx
  801c5a:	83 c4 1c             	add    $0x1c,%esp
  801c5d:	5b                   	pop    %ebx
  801c5e:	5e                   	pop    %esi
  801c5f:	5f                   	pop    %edi
  801c60:	5d                   	pop    %ebp
  801c61:	c3                   	ret    
  801c62:	66 90                	xchg   %ax,%ax
  801c64:	89 d8                	mov    %ebx,%eax
  801c66:	f7 f7                	div    %edi
  801c68:	31 ff                	xor    %edi,%edi
  801c6a:	89 fa                	mov    %edi,%edx
  801c6c:	83 c4 1c             	add    $0x1c,%esp
  801c6f:	5b                   	pop    %ebx
  801c70:	5e                   	pop    %esi
  801c71:	5f                   	pop    %edi
  801c72:	5d                   	pop    %ebp
  801c73:	c3                   	ret    
  801c74:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c79:	89 eb                	mov    %ebp,%ebx
  801c7b:	29 fb                	sub    %edi,%ebx
  801c7d:	89 f9                	mov    %edi,%ecx
  801c7f:	d3 e6                	shl    %cl,%esi
  801c81:	89 c5                	mov    %eax,%ebp
  801c83:	88 d9                	mov    %bl,%cl
  801c85:	d3 ed                	shr    %cl,%ebp
  801c87:	89 e9                	mov    %ebp,%ecx
  801c89:	09 f1                	or     %esi,%ecx
  801c8b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c8f:	89 f9                	mov    %edi,%ecx
  801c91:	d3 e0                	shl    %cl,%eax
  801c93:	89 c5                	mov    %eax,%ebp
  801c95:	89 d6                	mov    %edx,%esi
  801c97:	88 d9                	mov    %bl,%cl
  801c99:	d3 ee                	shr    %cl,%esi
  801c9b:	89 f9                	mov    %edi,%ecx
  801c9d:	d3 e2                	shl    %cl,%edx
  801c9f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ca3:	88 d9                	mov    %bl,%cl
  801ca5:	d3 e8                	shr    %cl,%eax
  801ca7:	09 c2                	or     %eax,%edx
  801ca9:	89 d0                	mov    %edx,%eax
  801cab:	89 f2                	mov    %esi,%edx
  801cad:	f7 74 24 0c          	divl   0xc(%esp)
  801cb1:	89 d6                	mov    %edx,%esi
  801cb3:	89 c3                	mov    %eax,%ebx
  801cb5:	f7 e5                	mul    %ebp
  801cb7:	39 d6                	cmp    %edx,%esi
  801cb9:	72 19                	jb     801cd4 <__udivdi3+0xfc>
  801cbb:	74 0b                	je     801cc8 <__udivdi3+0xf0>
  801cbd:	89 d8                	mov    %ebx,%eax
  801cbf:	31 ff                	xor    %edi,%edi
  801cc1:	e9 58 ff ff ff       	jmp    801c1e <__udivdi3+0x46>
  801cc6:	66 90                	xchg   %ax,%ax
  801cc8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ccc:	89 f9                	mov    %edi,%ecx
  801cce:	d3 e2                	shl    %cl,%edx
  801cd0:	39 c2                	cmp    %eax,%edx
  801cd2:	73 e9                	jae    801cbd <__udivdi3+0xe5>
  801cd4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801cd7:	31 ff                	xor    %edi,%edi
  801cd9:	e9 40 ff ff ff       	jmp    801c1e <__udivdi3+0x46>
  801cde:	66 90                	xchg   %ax,%ax
  801ce0:	31 c0                	xor    %eax,%eax
  801ce2:	e9 37 ff ff ff       	jmp    801c1e <__udivdi3+0x46>
  801ce7:	90                   	nop

00801ce8 <__umoddi3>:
  801ce8:	55                   	push   %ebp
  801ce9:	57                   	push   %edi
  801cea:	56                   	push   %esi
  801ceb:	53                   	push   %ebx
  801cec:	83 ec 1c             	sub    $0x1c,%esp
  801cef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801cf3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cf7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cfb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801cff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d07:	89 f3                	mov    %esi,%ebx
  801d09:	89 fa                	mov    %edi,%edx
  801d0b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d0f:	89 34 24             	mov    %esi,(%esp)
  801d12:	85 c0                	test   %eax,%eax
  801d14:	75 1a                	jne    801d30 <__umoddi3+0x48>
  801d16:	39 f7                	cmp    %esi,%edi
  801d18:	0f 86 a2 00 00 00    	jbe    801dc0 <__umoddi3+0xd8>
  801d1e:	89 c8                	mov    %ecx,%eax
  801d20:	89 f2                	mov    %esi,%edx
  801d22:	f7 f7                	div    %edi
  801d24:	89 d0                	mov    %edx,%eax
  801d26:	31 d2                	xor    %edx,%edx
  801d28:	83 c4 1c             	add    $0x1c,%esp
  801d2b:	5b                   	pop    %ebx
  801d2c:	5e                   	pop    %esi
  801d2d:	5f                   	pop    %edi
  801d2e:	5d                   	pop    %ebp
  801d2f:	c3                   	ret    
  801d30:	39 f0                	cmp    %esi,%eax
  801d32:	0f 87 ac 00 00 00    	ja     801de4 <__umoddi3+0xfc>
  801d38:	0f bd e8             	bsr    %eax,%ebp
  801d3b:	83 f5 1f             	xor    $0x1f,%ebp
  801d3e:	0f 84 ac 00 00 00    	je     801df0 <__umoddi3+0x108>
  801d44:	bf 20 00 00 00       	mov    $0x20,%edi
  801d49:	29 ef                	sub    %ebp,%edi
  801d4b:	89 fe                	mov    %edi,%esi
  801d4d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d51:	89 e9                	mov    %ebp,%ecx
  801d53:	d3 e0                	shl    %cl,%eax
  801d55:	89 d7                	mov    %edx,%edi
  801d57:	89 f1                	mov    %esi,%ecx
  801d59:	d3 ef                	shr    %cl,%edi
  801d5b:	09 c7                	or     %eax,%edi
  801d5d:	89 e9                	mov    %ebp,%ecx
  801d5f:	d3 e2                	shl    %cl,%edx
  801d61:	89 14 24             	mov    %edx,(%esp)
  801d64:	89 d8                	mov    %ebx,%eax
  801d66:	d3 e0                	shl    %cl,%eax
  801d68:	89 c2                	mov    %eax,%edx
  801d6a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d6e:	d3 e0                	shl    %cl,%eax
  801d70:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d74:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d78:	89 f1                	mov    %esi,%ecx
  801d7a:	d3 e8                	shr    %cl,%eax
  801d7c:	09 d0                	or     %edx,%eax
  801d7e:	d3 eb                	shr    %cl,%ebx
  801d80:	89 da                	mov    %ebx,%edx
  801d82:	f7 f7                	div    %edi
  801d84:	89 d3                	mov    %edx,%ebx
  801d86:	f7 24 24             	mull   (%esp)
  801d89:	89 c6                	mov    %eax,%esi
  801d8b:	89 d1                	mov    %edx,%ecx
  801d8d:	39 d3                	cmp    %edx,%ebx
  801d8f:	0f 82 87 00 00 00    	jb     801e1c <__umoddi3+0x134>
  801d95:	0f 84 91 00 00 00    	je     801e2c <__umoddi3+0x144>
  801d9b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d9f:	29 f2                	sub    %esi,%edx
  801da1:	19 cb                	sbb    %ecx,%ebx
  801da3:	89 d8                	mov    %ebx,%eax
  801da5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801da9:	d3 e0                	shl    %cl,%eax
  801dab:	89 e9                	mov    %ebp,%ecx
  801dad:	d3 ea                	shr    %cl,%edx
  801daf:	09 d0                	or     %edx,%eax
  801db1:	89 e9                	mov    %ebp,%ecx
  801db3:	d3 eb                	shr    %cl,%ebx
  801db5:	89 da                	mov    %ebx,%edx
  801db7:	83 c4 1c             	add    $0x1c,%esp
  801dba:	5b                   	pop    %ebx
  801dbb:	5e                   	pop    %esi
  801dbc:	5f                   	pop    %edi
  801dbd:	5d                   	pop    %ebp
  801dbe:	c3                   	ret    
  801dbf:	90                   	nop
  801dc0:	89 fd                	mov    %edi,%ebp
  801dc2:	85 ff                	test   %edi,%edi
  801dc4:	75 0b                	jne    801dd1 <__umoddi3+0xe9>
  801dc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcb:	31 d2                	xor    %edx,%edx
  801dcd:	f7 f7                	div    %edi
  801dcf:	89 c5                	mov    %eax,%ebp
  801dd1:	89 f0                	mov    %esi,%eax
  801dd3:	31 d2                	xor    %edx,%edx
  801dd5:	f7 f5                	div    %ebp
  801dd7:	89 c8                	mov    %ecx,%eax
  801dd9:	f7 f5                	div    %ebp
  801ddb:	89 d0                	mov    %edx,%eax
  801ddd:	e9 44 ff ff ff       	jmp    801d26 <__umoddi3+0x3e>
  801de2:	66 90                	xchg   %ax,%ax
  801de4:	89 c8                	mov    %ecx,%eax
  801de6:	89 f2                	mov    %esi,%edx
  801de8:	83 c4 1c             	add    $0x1c,%esp
  801deb:	5b                   	pop    %ebx
  801dec:	5e                   	pop    %esi
  801ded:	5f                   	pop    %edi
  801dee:	5d                   	pop    %ebp
  801def:	c3                   	ret    
  801df0:	3b 04 24             	cmp    (%esp),%eax
  801df3:	72 06                	jb     801dfb <__umoddi3+0x113>
  801df5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801df9:	77 0f                	ja     801e0a <__umoddi3+0x122>
  801dfb:	89 f2                	mov    %esi,%edx
  801dfd:	29 f9                	sub    %edi,%ecx
  801dff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e03:	89 14 24             	mov    %edx,(%esp)
  801e06:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e0a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e0e:	8b 14 24             	mov    (%esp),%edx
  801e11:	83 c4 1c             	add    $0x1c,%esp
  801e14:	5b                   	pop    %ebx
  801e15:	5e                   	pop    %esi
  801e16:	5f                   	pop    %edi
  801e17:	5d                   	pop    %ebp
  801e18:	c3                   	ret    
  801e19:	8d 76 00             	lea    0x0(%esi),%esi
  801e1c:	2b 04 24             	sub    (%esp),%eax
  801e1f:	19 fa                	sbb    %edi,%edx
  801e21:	89 d1                	mov    %edx,%ecx
  801e23:	89 c6                	mov    %eax,%esi
  801e25:	e9 71 ff ff ff       	jmp    801d9b <__umoddi3+0xb3>
  801e2a:	66 90                	xchg   %ax,%ax
  801e2c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e30:	72 ea                	jb     801e1c <__umoddi3+0x134>
  801e32:	89 d9                	mov    %ebx,%ecx
  801e34:	e9 62 ff ff ff       	jmp    801d9b <__umoddi3+0xb3>
