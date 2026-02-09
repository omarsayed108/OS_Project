
obj/user/tst_ksemaphore_2master:     file format elf32-i386


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
  800031:	e8 a8 02 00 00       	call   8002de <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: take user input, create the semaphores, run slaves and wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 6c 02 00 00    	sub    $0x26c,%esp
	int envID = sys_getenvid();
  800044:	e8 ef 1a 00 00       	call   801b38 <sys_getenvid>
  800049:	89 45 e0             	mov    %eax,-0x20(%ebp)
	char line[256] ;
	readline("Enter total number of customers: ", line) ;
  80004c:	83 ec 08             	sub    $0x8,%esp
  80004f:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800055:	50                   	push   %eax
  800056:	68 80 21 80 00       	push   $0x802180
  80005b:	e8 f5 0d 00 00       	call   800e55 <readline>
  800060:	83 c4 10             	add    $0x10,%esp
	int totalNumOfCusts = strtol(line, NULL, 10);
  800063:	83 ec 04             	sub    $0x4,%esp
  800066:	6a 0a                	push   $0xa
  800068:	6a 00                	push   $0x0
  80006a:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800070:	50                   	push   %eax
  800071:	e8 f6 13 00 00       	call   80146c <strtol>
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	89 45 dc             	mov    %eax,-0x24(%ebp)
	readline("Enter shop capacity: ", line) ;
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800085:	50                   	push   %eax
  800086:	68 a2 21 80 00       	push   $0x8021a2
  80008b:	e8 c5 0d 00 00       	call   800e55 <readline>
  800090:	83 c4 10             	add    $0x10,%esp
	int shopCapacity = strtol(line, NULL, 10);
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	6a 0a                	push   $0xa
  800098:	6a 00                	push   $0x0
  80009a:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  8000a0:	50                   	push   %eax
  8000a1:	e8 c6 13 00 00       	call   80146c <strtol>
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int semVal ;
	//Initialize the kernel semaphores
	char initCmd1[64] = "__KSem@0@Init";
  8000ac:	8d 85 90 fe ff ff    	lea    -0x170(%ebp),%eax
  8000b2:	bb c5 22 80 00       	mov    $0x8022c5,%ebx
  8000b7:	ba 0e 00 00 00       	mov    $0xe,%edx
  8000bc:	89 c7                	mov    %eax,%edi
  8000be:	89 de                	mov    %ebx,%esi
  8000c0:	89 d1                	mov    %edx,%ecx
  8000c2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000c4:	8d 95 9e fe ff ff    	lea    -0x162(%ebp),%edx
  8000ca:	b9 32 00 00 00       	mov    $0x32,%ecx
  8000cf:	b0 00                	mov    $0x0,%al
  8000d1:	89 d7                	mov    %edx,%edi
  8000d3:	f3 aa                	rep stos %al,%es:(%edi)
	char initCmd2[64] = "__KSem@1@Init";
  8000d5:	8d 85 50 fe ff ff    	lea    -0x1b0(%ebp),%eax
  8000db:	bb 05 23 80 00       	mov    $0x802305,%ebx
  8000e0:	ba 0e 00 00 00       	mov    $0xe,%edx
  8000e5:	89 c7                	mov    %eax,%edi
  8000e7:	89 de                	mov    %ebx,%esi
  8000e9:	89 d1                	mov    %edx,%ecx
  8000eb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000ed:	8d 95 5e fe ff ff    	lea    -0x1a2(%ebp),%edx
  8000f3:	b9 32 00 00 00       	mov    $0x32,%ecx
  8000f8:	b0 00                	mov    $0x0,%al
  8000fa:	89 d7                	mov    %edx,%edi
  8000fc:	f3 aa                	rep stos %al,%es:(%edi)
	semVal = shopCapacity;
  8000fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800101:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
	sys_utilities(initCmd1, (uint32)(&semVal));
  800107:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80010d:	83 ec 08             	sub    $0x8,%esp
  800110:	50                   	push   %eax
  800111:	8d 85 90 fe ff ff    	lea    -0x170(%ebp),%eax
  800117:	50                   	push   %eax
  800118:	e8 6a 1c 00 00       	call   801d87 <sys_utilities>
  80011d:	83 c4 10             	add    $0x10,%esp
	semVal = 0;
  800120:	c7 85 d0 fe ff ff 00 	movl   $0x0,-0x130(%ebp)
  800127:	00 00 00 
	sys_utilities(initCmd2, (uint32)(&semVal));
  80012a:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  800130:	83 ec 08             	sub    $0x8,%esp
  800133:	50                   	push   %eax
  800134:	8d 85 50 fe ff ff    	lea    -0x1b0(%ebp),%eax
  80013a:	50                   	push   %eax
  80013b:	e8 47 1c 00 00       	call   801d87 <sys_utilities>
  800140:	83 c4 10             	add    $0x10,%esp

	int i = 0 ;
  800143:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int id ;
	for (; i<totalNumOfCusts; i++)
  80014a:	eb 61                	jmp    8001ad <_main+0x175>
	{
		id = sys_create_env("ksem2Slave", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80014c:	a1 20 30 80 00       	mov    0x803020,%eax
  800151:	8b 90 70 06 00 00    	mov    0x670(%eax),%edx
  800157:	a1 20 30 80 00       	mov    0x803020,%eax
  80015c:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  800162:	89 c1                	mov    %eax,%ecx
  800164:	a1 20 30 80 00       	mov    0x803020,%eax
  800169:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80016f:	52                   	push   %edx
  800170:	51                   	push   %ecx
  800171:	50                   	push   %eax
  800172:	68 b8 21 80 00       	push   $0x8021b8
  800177:	e8 67 19 00 00       	call   801ae3 <sys_create_env>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (id == E_ENV_CREATION_ERROR)
  800182:	83 7d d4 ef          	cmpl   $0xffffffef,-0x2c(%ebp)
  800186:	75 14                	jne    80019c <_main+0x164>
			panic("NO AVAILABLE ENVs... Please reduce the number of customers and try again...");
  800188:	83 ec 04             	sub    $0x4,%esp
  80018b:	68 c4 21 80 00       	push   $0x8021c4
  800190:	6a 1e                	push   $0x1e
  800192:	68 10 22 80 00       	push   $0x802210
  800197:	e8 f2 02 00 00       	call   80048e <_panic>
		sys_run_env(id) ;
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001a2:	e8 5a 19 00 00       	call   801b01 <sys_run_env>
  8001a7:	83 c4 10             	add    $0x10,%esp
	semVal = 0;
	sys_utilities(initCmd2, (uint32)(&semVal));

	int i = 0 ;
	int id ;
	for (; i<totalNumOfCusts; i++)
  8001aa:	ff 45 e4             	incl   -0x1c(%ebp)
  8001ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001b0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001b3:	7c 97                	jl     80014c <_main+0x114>
			panic("NO AVAILABLE ENVs... Please reduce the number of customers and try again...");
		sys_run_env(id) ;
	}

	//Wait until all finished
	for (i = 0 ; i<totalNumOfCusts; i++)
  8001b5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001bc:	eb 40                	jmp    8001fe <_main+0x1c6>
	{
		char waitCmd[64] = "__KSem@1@Wait";
  8001be:	8d 85 88 fd ff ff    	lea    -0x278(%ebp),%eax
  8001c4:	bb 45 23 80 00       	mov    $0x802345,%ebx
  8001c9:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001ce:	89 c7                	mov    %eax,%edi
  8001d0:	89 de                	mov    %ebx,%esi
  8001d2:	89 d1                	mov    %edx,%ecx
  8001d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001d6:	8d 95 96 fd ff ff    	lea    -0x26a(%ebp),%edx
  8001dc:	b9 32 00 00 00       	mov    $0x32,%ecx
  8001e1:	b0 00                	mov    $0x0,%al
  8001e3:	89 d7                	mov    %edx,%edi
  8001e5:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(waitCmd, 0);
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	6a 00                	push   $0x0
  8001ec:	8d 85 88 fd ff ff    	lea    -0x278(%ebp),%eax
  8001f2:	50                   	push   %eax
  8001f3:	e8 8f 1b 00 00       	call   801d87 <sys_utilities>
  8001f8:	83 c4 10             	add    $0x10,%esp
			panic("NO AVAILABLE ENVs... Please reduce the number of customers and try again...");
		sys_run_env(id) ;
	}

	//Wait until all finished
	for (i = 0 ; i<totalNumOfCusts; i++)
  8001fb:	ff 45 e4             	incl   -0x1c(%ebp)
  8001fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800201:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800204:	7c b8                	jl     8001be <_main+0x186>
	}

	//Check semaphore values
	int sem1val ;
	int sem2val ;
	char getCmd1[64] = "__KSem@0@Get";
  800206:	8d 85 08 fe ff ff    	lea    -0x1f8(%ebp),%eax
  80020c:	bb 85 23 80 00       	mov    $0x802385,%ebx
  800211:	ba 0d 00 00 00       	mov    $0xd,%edx
  800216:	89 c7                	mov    %eax,%edi
  800218:	89 de                	mov    %ebx,%esi
  80021a:	89 d1                	mov    %edx,%ecx
  80021c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80021e:	8d 95 15 fe ff ff    	lea    -0x1eb(%ebp),%edx
  800224:	b9 33 00 00 00       	mov    $0x33,%ecx
  800229:	b0 00                	mov    $0x0,%al
  80022b:	89 d7                	mov    %edx,%edi
  80022d:	f3 aa                	rep stos %al,%es:(%edi)
	char getCmd2[64] = "__KSem@1@Get";
  80022f:	8d 85 c8 fd ff ff    	lea    -0x238(%ebp),%eax
  800235:	bb c5 23 80 00       	mov    $0x8023c5,%ebx
  80023a:	ba 0d 00 00 00       	mov    $0xd,%edx
  80023f:	89 c7                	mov    %eax,%edi
  800241:	89 de                	mov    %ebx,%esi
  800243:	89 d1                	mov    %edx,%ecx
  800245:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800247:	8d 95 d5 fd ff ff    	lea    -0x22b(%ebp),%edx
  80024d:	b9 33 00 00 00       	mov    $0x33,%ecx
  800252:	b0 00                	mov    $0x0,%al
  800254:	89 d7                	mov    %edx,%edi
  800256:	f3 aa                	rep stos %al,%es:(%edi)

	sys_utilities(getCmd1, (uint32)(&sem1val));
  800258:	8d 85 4c fe ff ff    	lea    -0x1b4(%ebp),%eax
  80025e:	83 ec 08             	sub    $0x8,%esp
  800261:	50                   	push   %eax
  800262:	8d 85 08 fe ff ff    	lea    -0x1f8(%ebp),%eax
  800268:	50                   	push   %eax
  800269:	e8 19 1b 00 00       	call   801d87 <sys_utilities>
  80026e:	83 c4 10             	add    $0x10,%esp
	sys_utilities(getCmd2, (uint32)(&sem2val));
  800271:	8d 85 48 fe ff ff    	lea    -0x1b8(%ebp),%eax
  800277:	83 ec 08             	sub    $0x8,%esp
  80027a:	50                   	push   %eax
  80027b:	8d 85 c8 fd ff ff    	lea    -0x238(%ebp),%eax
  800281:	50                   	push   %eax
  800282:	e8 00 1b 00 00       	call   801d87 <sys_utilities>
  800287:	83 c4 10             	add    $0x10,%esp

	//wait a while to allow the slaves to finish printing their closing messages
	env_sleep(10000);
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	68 10 27 00 00       	push   $0x2710
  800292:	e8 7d 1b 00 00       	call   801e14 <env_sleep>
  800297:	83 c4 10             	add    $0x10,%esp
	if (sem2val == 0 && sem1val == shopCapacity)
  80029a:	8b 85 48 fe ff ff    	mov    -0x1b8(%ebp),%eax
  8002a0:	85 c0                	test   %eax,%eax
  8002a2:	75 1f                	jne    8002c3 <_main+0x28b>
  8002a4:	8b 85 4c fe ff ff    	mov    -0x1b4(%ebp),%eax
  8002aa:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8002ad:	75 14                	jne    8002c3 <_main+0x28b>
		cprintf_colored(TEXT_light_green,"\nCongratulations!! Test of Semaphores [2] completed successfully!!\n\n\n");
  8002af:	83 ec 08             	sub    $0x8,%esp
  8002b2:	68 30 22 80 00       	push   $0x802230
  8002b7:	6a 0a                	push   $0xa
  8002b9:	e8 eb 04 00 00       	call   8007a9 <cprintf_colored>
  8002be:	83 c4 10             	add    $0x10,%esp
  8002c1:	eb 12                	jmp    8002d5 <_main+0x29d>
	else
		cprintf_colored(TEXT_TESTERR_CLR,"\nError: wrong semaphore value... please review your semaphore code again...\n");
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	68 78 22 80 00       	push   $0x802278
  8002cb:	6a 0c                	push   $0xc
  8002cd:	e8 d7 04 00 00       	call   8007a9 <cprintf_colored>
  8002d2:	83 c4 10             	add    $0x10,%esp

	return;
  8002d5:	90                   	nop
}
  8002d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d9:	5b                   	pop    %ebx
  8002da:	5e                   	pop    %esi
  8002db:	5f                   	pop    %edi
  8002dc:	5d                   	pop    %ebp
  8002dd:	c3                   	ret    

008002de <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	57                   	push   %edi
  8002e2:	56                   	push   %esi
  8002e3:	53                   	push   %ebx
  8002e4:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002e7:	e8 65 18 00 00       	call   801b51 <sys_getenvindex>
  8002ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002f2:	89 d0                	mov    %edx,%eax
  8002f4:	01 c0                	add    %eax,%eax
  8002f6:	01 d0                	add    %edx,%eax
  8002f8:	c1 e0 02             	shl    $0x2,%eax
  8002fb:	01 d0                	add    %edx,%eax
  8002fd:	c1 e0 02             	shl    $0x2,%eax
  800300:	01 d0                	add    %edx,%eax
  800302:	c1 e0 03             	shl    $0x3,%eax
  800305:	01 d0                	add    %edx,%eax
  800307:	c1 e0 02             	shl    $0x2,%eax
  80030a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80030f:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800314:	a1 20 30 80 00       	mov    0x803020,%eax
  800319:	8a 40 20             	mov    0x20(%eax),%al
  80031c:	84 c0                	test   %al,%al
  80031e:	74 0d                	je     80032d <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800320:	a1 20 30 80 00       	mov    0x803020,%eax
  800325:	83 c0 20             	add    $0x20,%eax
  800328:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80032d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800331:	7e 0a                	jle    80033d <libmain+0x5f>
		binaryname = argv[0];
  800333:	8b 45 0c             	mov    0xc(%ebp),%eax
  800336:	8b 00                	mov    (%eax),%eax
  800338:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80033d:	83 ec 08             	sub    $0x8,%esp
  800340:	ff 75 0c             	pushl  0xc(%ebp)
  800343:	ff 75 08             	pushl  0x8(%ebp)
  800346:	e8 ed fc ff ff       	call   800038 <_main>
  80034b:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80034e:	a1 00 30 80 00       	mov    0x803000,%eax
  800353:	85 c0                	test   %eax,%eax
  800355:	0f 84 01 01 00 00    	je     80045c <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80035b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800361:	bb 00 25 80 00       	mov    $0x802500,%ebx
  800366:	ba 0e 00 00 00       	mov    $0xe,%edx
  80036b:	89 c7                	mov    %eax,%edi
  80036d:	89 de                	mov    %ebx,%esi
  80036f:	89 d1                	mov    %edx,%ecx
  800371:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800373:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800376:	b9 56 00 00 00       	mov    $0x56,%ecx
  80037b:	b0 00                	mov    $0x0,%al
  80037d:	89 d7                	mov    %edx,%edi
  80037f:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800381:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800388:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80038b:	83 ec 08             	sub    $0x8,%esp
  80038e:	50                   	push   %eax
  80038f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800395:	50                   	push   %eax
  800396:	e8 ec 19 00 00       	call   801d87 <sys_utilities>
  80039b:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80039e:	e8 35 15 00 00       	call   8018d8 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003a3:	83 ec 0c             	sub    $0xc,%esp
  8003a6:	68 20 24 80 00       	push   $0x802420
  8003ab:	e8 cc 03 00 00       	call   80077c <cprintf>
  8003b0:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b6:	85 c0                	test   %eax,%eax
  8003b8:	74 18                	je     8003d2 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003ba:	e8 e6 19 00 00       	call   801da5 <sys_get_optimal_num_faults>
  8003bf:	83 ec 08             	sub    $0x8,%esp
  8003c2:	50                   	push   %eax
  8003c3:	68 48 24 80 00       	push   $0x802448
  8003c8:	e8 af 03 00 00       	call   80077c <cprintf>
  8003cd:	83 c4 10             	add    $0x10,%esp
  8003d0:	eb 59                	jmp    80042b <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003d2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d7:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8003dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e2:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8003e8:	83 ec 04             	sub    $0x4,%esp
  8003eb:	52                   	push   %edx
  8003ec:	50                   	push   %eax
  8003ed:	68 6c 24 80 00       	push   $0x80246c
  8003f2:	e8 85 03 00 00       	call   80077c <cprintf>
  8003f7:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003fa:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ff:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800405:	a1 20 30 80 00       	mov    0x803020,%eax
  80040a:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800410:	a1 20 30 80 00       	mov    0x803020,%eax
  800415:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  80041b:	51                   	push   %ecx
  80041c:	52                   	push   %edx
  80041d:	50                   	push   %eax
  80041e:	68 94 24 80 00       	push   $0x802494
  800423:	e8 54 03 00 00       	call   80077c <cprintf>
  800428:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80042b:	a1 20 30 80 00       	mov    0x803020,%eax
  800430:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800436:	83 ec 08             	sub    $0x8,%esp
  800439:	50                   	push   %eax
  80043a:	68 ec 24 80 00       	push   $0x8024ec
  80043f:	e8 38 03 00 00       	call   80077c <cprintf>
  800444:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800447:	83 ec 0c             	sub    $0xc,%esp
  80044a:	68 20 24 80 00       	push   $0x802420
  80044f:	e8 28 03 00 00       	call   80077c <cprintf>
  800454:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800457:	e8 96 14 00 00       	call   8018f2 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80045c:	e8 1f 00 00 00       	call   800480 <exit>
}
  800461:	90                   	nop
  800462:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800465:	5b                   	pop    %ebx
  800466:	5e                   	pop    %esi
  800467:	5f                   	pop    %edi
  800468:	5d                   	pop    %ebp
  800469:	c3                   	ret    

0080046a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80046a:	55                   	push   %ebp
  80046b:	89 e5                	mov    %esp,%ebp
  80046d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800470:	83 ec 0c             	sub    $0xc,%esp
  800473:	6a 00                	push   $0x0
  800475:	e8 a3 16 00 00       	call   801b1d <sys_destroy_env>
  80047a:	83 c4 10             	add    $0x10,%esp
}
  80047d:	90                   	nop
  80047e:	c9                   	leave  
  80047f:	c3                   	ret    

00800480 <exit>:

void
exit(void)
{
  800480:	55                   	push   %ebp
  800481:	89 e5                	mov    %esp,%ebp
  800483:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800486:	e8 f8 16 00 00       	call   801b83 <sys_exit_env>
}
  80048b:	90                   	nop
  80048c:	c9                   	leave  
  80048d:	c3                   	ret    

0080048e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80048e:	55                   	push   %ebp
  80048f:	89 e5                	mov    %esp,%ebp
  800491:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800494:	8d 45 10             	lea    0x10(%ebp),%eax
  800497:	83 c0 04             	add    $0x4,%eax
  80049a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80049d:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8004a2:	85 c0                	test   %eax,%eax
  8004a4:	74 16                	je     8004bc <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004a6:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8004ab:	83 ec 08             	sub    $0x8,%esp
  8004ae:	50                   	push   %eax
  8004af:	68 64 25 80 00       	push   $0x802564
  8004b4:	e8 c3 02 00 00       	call   80077c <cprintf>
  8004b9:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004bc:	a1 04 30 80 00       	mov    0x803004,%eax
  8004c1:	83 ec 0c             	sub    $0xc,%esp
  8004c4:	ff 75 0c             	pushl  0xc(%ebp)
  8004c7:	ff 75 08             	pushl  0x8(%ebp)
  8004ca:	50                   	push   %eax
  8004cb:	68 6c 25 80 00       	push   $0x80256c
  8004d0:	6a 74                	push   $0x74
  8004d2:	e8 d2 02 00 00       	call   8007a9 <cprintf_colored>
  8004d7:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004da:	8b 45 10             	mov    0x10(%ebp),%eax
  8004dd:	83 ec 08             	sub    $0x8,%esp
  8004e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e3:	50                   	push   %eax
  8004e4:	e8 24 02 00 00       	call   80070d <vcprintf>
  8004e9:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004ec:	83 ec 08             	sub    $0x8,%esp
  8004ef:	6a 00                	push   $0x0
  8004f1:	68 94 25 80 00       	push   $0x802594
  8004f6:	e8 12 02 00 00       	call   80070d <vcprintf>
  8004fb:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004fe:	e8 7d ff ff ff       	call   800480 <exit>

	// should not return here
	while (1) ;
  800503:	eb fe                	jmp    800503 <_panic+0x75>

00800505 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800505:	55                   	push   %ebp
  800506:	89 e5                	mov    %esp,%ebp
  800508:	53                   	push   %ebx
  800509:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80050c:	a1 20 30 80 00       	mov    0x803020,%eax
  800511:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051a:	39 c2                	cmp    %eax,%edx
  80051c:	74 14                	je     800532 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80051e:	83 ec 04             	sub    $0x4,%esp
  800521:	68 98 25 80 00       	push   $0x802598
  800526:	6a 26                	push   $0x26
  800528:	68 e4 25 80 00       	push   $0x8025e4
  80052d:	e8 5c ff ff ff       	call   80048e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800532:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800539:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800540:	e9 d9 00 00 00       	jmp    80061e <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800545:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800548:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80054f:	8b 45 08             	mov    0x8(%ebp),%eax
  800552:	01 d0                	add    %edx,%eax
  800554:	8b 00                	mov    (%eax),%eax
  800556:	85 c0                	test   %eax,%eax
  800558:	75 08                	jne    800562 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  80055a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80055d:	e9 b9 00 00 00       	jmp    80061b <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800562:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800569:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800570:	eb 79                	jmp    8005eb <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800572:	a1 20 30 80 00       	mov    0x803020,%eax
  800577:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80057d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800580:	89 d0                	mov    %edx,%eax
  800582:	01 c0                	add    %eax,%eax
  800584:	01 d0                	add    %edx,%eax
  800586:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80058d:	01 d8                	add    %ebx,%eax
  80058f:	01 d0                	add    %edx,%eax
  800591:	01 c8                	add    %ecx,%eax
  800593:	8a 40 04             	mov    0x4(%eax),%al
  800596:	84 c0                	test   %al,%al
  800598:	75 4e                	jne    8005e8 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80059a:	a1 20 30 80 00       	mov    0x803020,%eax
  80059f:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8005a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a8:	89 d0                	mov    %edx,%eax
  8005aa:	01 c0                	add    %eax,%eax
  8005ac:	01 d0                	add    %edx,%eax
  8005ae:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8005b5:	01 d8                	add    %ebx,%eax
  8005b7:	01 d0                	add    %edx,%eax
  8005b9:	01 c8                	add    %ecx,%eax
  8005bb:	8b 00                	mov    (%eax),%eax
  8005bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005c8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005cd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d7:	01 c8                	add    %ecx,%eax
  8005d9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005db:	39 c2                	cmp    %eax,%edx
  8005dd:	75 09                	jne    8005e8 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8005df:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005e6:	eb 19                	jmp    800601 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e8:	ff 45 e8             	incl   -0x18(%ebp)
  8005eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8005f0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005f9:	39 c2                	cmp    %eax,%edx
  8005fb:	0f 87 71 ff ff ff    	ja     800572 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800601:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800605:	75 14                	jne    80061b <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800607:	83 ec 04             	sub    $0x4,%esp
  80060a:	68 f0 25 80 00       	push   $0x8025f0
  80060f:	6a 3a                	push   $0x3a
  800611:	68 e4 25 80 00       	push   $0x8025e4
  800616:	e8 73 fe ff ff       	call   80048e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80061b:	ff 45 f0             	incl   -0x10(%ebp)
  80061e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800621:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800624:	0f 8c 1b ff ff ff    	jl     800545 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80062a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800631:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800638:	eb 2e                	jmp    800668 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80063a:	a1 20 30 80 00       	mov    0x803020,%eax
  80063f:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800645:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800648:	89 d0                	mov    %edx,%eax
  80064a:	01 c0                	add    %eax,%eax
  80064c:	01 d0                	add    %edx,%eax
  80064e:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800655:	01 d8                	add    %ebx,%eax
  800657:	01 d0                	add    %edx,%eax
  800659:	01 c8                	add    %ecx,%eax
  80065b:	8a 40 04             	mov    0x4(%eax),%al
  80065e:	3c 01                	cmp    $0x1,%al
  800660:	75 03                	jne    800665 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800662:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800665:	ff 45 e0             	incl   -0x20(%ebp)
  800668:	a1 20 30 80 00       	mov    0x803020,%eax
  80066d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800673:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800676:	39 c2                	cmp    %eax,%edx
  800678:	77 c0                	ja     80063a <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80067d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800680:	74 14                	je     800696 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800682:	83 ec 04             	sub    $0x4,%esp
  800685:	68 44 26 80 00       	push   $0x802644
  80068a:	6a 44                	push   $0x44
  80068c:	68 e4 25 80 00       	push   $0x8025e4
  800691:	e8 f8 fd ff ff       	call   80048e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800696:	90                   	nop
  800697:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80069a:	c9                   	leave  
  80069b:	c3                   	ret    

0080069c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80069c:	55                   	push   %ebp
  80069d:	89 e5                	mov    %esp,%ebp
  80069f:	53                   	push   %ebx
  8006a0:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8006a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a6:	8b 00                	mov    (%eax),%eax
  8006a8:	8d 48 01             	lea    0x1(%eax),%ecx
  8006ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ae:	89 0a                	mov    %ecx,(%edx)
  8006b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8006b3:	88 d1                	mov    %dl,%cl
  8006b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006c6:	75 30                	jne    8006f8 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006c8:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006ce:	a0 44 30 80 00       	mov    0x803044,%al
  8006d3:	0f b6 c0             	movzbl %al,%eax
  8006d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006d9:	8b 09                	mov    (%ecx),%ecx
  8006db:	89 cb                	mov    %ecx,%ebx
  8006dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006e0:	83 c1 08             	add    $0x8,%ecx
  8006e3:	52                   	push   %edx
  8006e4:	50                   	push   %eax
  8006e5:	53                   	push   %ebx
  8006e6:	51                   	push   %ecx
  8006e7:	e8 a8 11 00 00       	call   801894 <sys_cputs>
  8006ec:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006fb:	8b 40 04             	mov    0x4(%eax),%eax
  8006fe:	8d 50 01             	lea    0x1(%eax),%edx
  800701:	8b 45 0c             	mov    0xc(%ebp),%eax
  800704:	89 50 04             	mov    %edx,0x4(%eax)
}
  800707:	90                   	nop
  800708:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80070b:	c9                   	leave  
  80070c:	c3                   	ret    

0080070d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80070d:	55                   	push   %ebp
  80070e:	89 e5                	mov    %esp,%ebp
  800710:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800716:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80071d:	00 00 00 
	b.cnt = 0;
  800720:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800727:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80072a:	ff 75 0c             	pushl  0xc(%ebp)
  80072d:	ff 75 08             	pushl  0x8(%ebp)
  800730:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800736:	50                   	push   %eax
  800737:	68 9c 06 80 00       	push   $0x80069c
  80073c:	e8 5a 02 00 00       	call   80099b <vprintfmt>
  800741:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800744:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80074a:	a0 44 30 80 00       	mov    0x803044,%al
  80074f:	0f b6 c0             	movzbl %al,%eax
  800752:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800758:	52                   	push   %edx
  800759:	50                   	push   %eax
  80075a:	51                   	push   %ecx
  80075b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800761:	83 c0 08             	add    $0x8,%eax
  800764:	50                   	push   %eax
  800765:	e8 2a 11 00 00       	call   801894 <sys_cputs>
  80076a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80076d:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800774:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80077a:	c9                   	leave  
  80077b:	c3                   	ret    

0080077c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80077c:	55                   	push   %ebp
  80077d:	89 e5                	mov    %esp,%ebp
  80077f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800782:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800789:	8d 45 0c             	lea    0xc(%ebp),%eax
  80078c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	83 ec 08             	sub    $0x8,%esp
  800795:	ff 75 f4             	pushl  -0xc(%ebp)
  800798:	50                   	push   %eax
  800799:	e8 6f ff ff ff       	call   80070d <vcprintf>
  80079e:	83 c4 10             	add    $0x10,%esp
  8007a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007a7:	c9                   	leave  
  8007a8:	c3                   	ret    

008007a9 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8007a9:	55                   	push   %ebp
  8007aa:	89 e5                	mov    %esp,%ebp
  8007ac:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007af:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	c1 e0 08             	shl    $0x8,%eax
  8007bc:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8007c1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007c4:	83 c0 04             	add    $0x4,%eax
  8007c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d3:	50                   	push   %eax
  8007d4:	e8 34 ff ff ff       	call   80070d <vcprintf>
  8007d9:	83 c4 10             	add    $0x10,%esp
  8007dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007df:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8007e6:	07 00 00 

	return cnt;
  8007e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007ec:	c9                   	leave  
  8007ed:	c3                   	ret    

008007ee <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007ee:	55                   	push   %ebp
  8007ef:	89 e5                	mov    %esp,%ebp
  8007f1:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007f4:	e8 df 10 00 00       	call   8018d8 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007f9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	83 ec 08             	sub    $0x8,%esp
  800805:	ff 75 f4             	pushl  -0xc(%ebp)
  800808:	50                   	push   %eax
  800809:	e8 ff fe ff ff       	call   80070d <vcprintf>
  80080e:	83 c4 10             	add    $0x10,%esp
  800811:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800814:	e8 d9 10 00 00       	call   8018f2 <sys_unlock_cons>
	return cnt;
  800819:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80081c:	c9                   	leave  
  80081d:	c3                   	ret    

0080081e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	53                   	push   %ebx
  800822:	83 ec 14             	sub    $0x14,%esp
  800825:	8b 45 10             	mov    0x10(%ebp),%eax
  800828:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800831:	8b 45 18             	mov    0x18(%ebp),%eax
  800834:	ba 00 00 00 00       	mov    $0x0,%edx
  800839:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80083c:	77 55                	ja     800893 <printnum+0x75>
  80083e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800841:	72 05                	jb     800848 <printnum+0x2a>
  800843:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800846:	77 4b                	ja     800893 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800848:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80084b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80084e:	8b 45 18             	mov    0x18(%ebp),%eax
  800851:	ba 00 00 00 00       	mov    $0x0,%edx
  800856:	52                   	push   %edx
  800857:	50                   	push   %eax
  800858:	ff 75 f4             	pushl  -0xc(%ebp)
  80085b:	ff 75 f0             	pushl  -0x10(%ebp)
  80085e:	e8 ad 16 00 00       	call   801f10 <__udivdi3>
  800863:	83 c4 10             	add    $0x10,%esp
  800866:	83 ec 04             	sub    $0x4,%esp
  800869:	ff 75 20             	pushl  0x20(%ebp)
  80086c:	53                   	push   %ebx
  80086d:	ff 75 18             	pushl  0x18(%ebp)
  800870:	52                   	push   %edx
  800871:	50                   	push   %eax
  800872:	ff 75 0c             	pushl  0xc(%ebp)
  800875:	ff 75 08             	pushl  0x8(%ebp)
  800878:	e8 a1 ff ff ff       	call   80081e <printnum>
  80087d:	83 c4 20             	add    $0x20,%esp
  800880:	eb 1a                	jmp    80089c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800882:	83 ec 08             	sub    $0x8,%esp
  800885:	ff 75 0c             	pushl  0xc(%ebp)
  800888:	ff 75 20             	pushl  0x20(%ebp)
  80088b:	8b 45 08             	mov    0x8(%ebp),%eax
  80088e:	ff d0                	call   *%eax
  800890:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800893:	ff 4d 1c             	decl   0x1c(%ebp)
  800896:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80089a:	7f e6                	jg     800882 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80089c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80089f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008aa:	53                   	push   %ebx
  8008ab:	51                   	push   %ecx
  8008ac:	52                   	push   %edx
  8008ad:	50                   	push   %eax
  8008ae:	e8 6d 17 00 00       	call   802020 <__umoddi3>
  8008b3:	83 c4 10             	add    $0x10,%esp
  8008b6:	05 b4 28 80 00       	add    $0x8028b4,%eax
  8008bb:	8a 00                	mov    (%eax),%al
  8008bd:	0f be c0             	movsbl %al,%eax
  8008c0:	83 ec 08             	sub    $0x8,%esp
  8008c3:	ff 75 0c             	pushl  0xc(%ebp)
  8008c6:	50                   	push   %eax
  8008c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ca:	ff d0                	call   *%eax
  8008cc:	83 c4 10             	add    $0x10,%esp
}
  8008cf:	90                   	nop
  8008d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008d3:	c9                   	leave  
  8008d4:	c3                   	ret    

008008d5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008d5:	55                   	push   %ebp
  8008d6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008d8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008dc:	7e 1c                	jle    8008fa <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	8b 00                	mov    (%eax),%eax
  8008e3:	8d 50 08             	lea    0x8(%eax),%edx
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	89 10                	mov    %edx,(%eax)
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	8b 00                	mov    (%eax),%eax
  8008f0:	83 e8 08             	sub    $0x8,%eax
  8008f3:	8b 50 04             	mov    0x4(%eax),%edx
  8008f6:	8b 00                	mov    (%eax),%eax
  8008f8:	eb 40                	jmp    80093a <getuint+0x65>
	else if (lflag)
  8008fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008fe:	74 1e                	je     80091e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	8b 00                	mov    (%eax),%eax
  800905:	8d 50 04             	lea    0x4(%eax),%edx
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	89 10                	mov    %edx,(%eax)
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	83 e8 04             	sub    $0x4,%eax
  800915:	8b 00                	mov    (%eax),%eax
  800917:	ba 00 00 00 00       	mov    $0x0,%edx
  80091c:	eb 1c                	jmp    80093a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	8d 50 04             	lea    0x4(%eax),%edx
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	89 10                	mov    %edx,(%eax)
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	8b 00                	mov    (%eax),%eax
  800930:	83 e8 04             	sub    $0x4,%eax
  800933:	8b 00                	mov    (%eax),%eax
  800935:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80093a:	5d                   	pop    %ebp
  80093b:	c3                   	ret    

0080093c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80093f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800943:	7e 1c                	jle    800961 <getint+0x25>
		return va_arg(*ap, long long);
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	8b 00                	mov    (%eax),%eax
  80094a:	8d 50 08             	lea    0x8(%eax),%edx
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	89 10                	mov    %edx,(%eax)
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	8b 00                	mov    (%eax),%eax
  800957:	83 e8 08             	sub    $0x8,%eax
  80095a:	8b 50 04             	mov    0x4(%eax),%edx
  80095d:	8b 00                	mov    (%eax),%eax
  80095f:	eb 38                	jmp    800999 <getint+0x5d>
	else if (lflag)
  800961:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800965:	74 1a                	je     800981 <getint+0x45>
		return va_arg(*ap, long);
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	8b 00                	mov    (%eax),%eax
  80096c:	8d 50 04             	lea    0x4(%eax),%edx
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	89 10                	mov    %edx,(%eax)
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	8b 00                	mov    (%eax),%eax
  800979:	83 e8 04             	sub    $0x4,%eax
  80097c:	8b 00                	mov    (%eax),%eax
  80097e:	99                   	cltd   
  80097f:	eb 18                	jmp    800999 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	8b 00                	mov    (%eax),%eax
  800986:	8d 50 04             	lea    0x4(%eax),%edx
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	89 10                	mov    %edx,(%eax)
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	8b 00                	mov    (%eax),%eax
  800993:	83 e8 04             	sub    $0x4,%eax
  800996:	8b 00                	mov    (%eax),%eax
  800998:	99                   	cltd   
}
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    

0080099b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	56                   	push   %esi
  80099f:	53                   	push   %ebx
  8009a0:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a3:	eb 17                	jmp    8009bc <vprintfmt+0x21>
			if (ch == '\0')
  8009a5:	85 db                	test   %ebx,%ebx
  8009a7:	0f 84 c1 03 00 00    	je     800d6e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009ad:	83 ec 08             	sub    $0x8,%esp
  8009b0:	ff 75 0c             	pushl  0xc(%ebp)
  8009b3:	53                   	push   %ebx
  8009b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b7:	ff d0                	call   *%eax
  8009b9:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8009bf:	8d 50 01             	lea    0x1(%eax),%edx
  8009c2:	89 55 10             	mov    %edx,0x10(%ebp)
  8009c5:	8a 00                	mov    (%eax),%al
  8009c7:	0f b6 d8             	movzbl %al,%ebx
  8009ca:	83 fb 25             	cmp    $0x25,%ebx
  8009cd:	75 d6                	jne    8009a5 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009cf:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009d3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009da:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009e1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009e8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f2:	8d 50 01             	lea    0x1(%eax),%edx
  8009f5:	89 55 10             	mov    %edx,0x10(%ebp)
  8009f8:	8a 00                	mov    (%eax),%al
  8009fa:	0f b6 d8             	movzbl %al,%ebx
  8009fd:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a00:	83 f8 5b             	cmp    $0x5b,%eax
  800a03:	0f 87 3d 03 00 00    	ja     800d46 <vprintfmt+0x3ab>
  800a09:	8b 04 85 d8 28 80 00 	mov    0x8028d8(,%eax,4),%eax
  800a10:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a12:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a16:	eb d7                	jmp    8009ef <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a18:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a1c:	eb d1                	jmp    8009ef <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a1e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a25:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a28:	89 d0                	mov    %edx,%eax
  800a2a:	c1 e0 02             	shl    $0x2,%eax
  800a2d:	01 d0                	add    %edx,%eax
  800a2f:	01 c0                	add    %eax,%eax
  800a31:	01 d8                	add    %ebx,%eax
  800a33:	83 e8 30             	sub    $0x30,%eax
  800a36:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a39:	8b 45 10             	mov    0x10(%ebp),%eax
  800a3c:	8a 00                	mov    (%eax),%al
  800a3e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a41:	83 fb 2f             	cmp    $0x2f,%ebx
  800a44:	7e 3e                	jle    800a84 <vprintfmt+0xe9>
  800a46:	83 fb 39             	cmp    $0x39,%ebx
  800a49:	7f 39                	jg     800a84 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a4b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a4e:	eb d5                	jmp    800a25 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a50:	8b 45 14             	mov    0x14(%ebp),%eax
  800a53:	83 c0 04             	add    $0x4,%eax
  800a56:	89 45 14             	mov    %eax,0x14(%ebp)
  800a59:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5c:	83 e8 04             	sub    $0x4,%eax
  800a5f:	8b 00                	mov    (%eax),%eax
  800a61:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a64:	eb 1f                	jmp    800a85 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a66:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6a:	79 83                	jns    8009ef <vprintfmt+0x54>
				width = 0;
  800a6c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a73:	e9 77 ff ff ff       	jmp    8009ef <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a78:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a7f:	e9 6b ff ff ff       	jmp    8009ef <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a84:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a85:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a89:	0f 89 60 ff ff ff    	jns    8009ef <vprintfmt+0x54>
				width = precision, precision = -1;
  800a8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a95:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a9c:	e9 4e ff ff ff       	jmp    8009ef <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800aa1:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800aa4:	e9 46 ff ff ff       	jmp    8009ef <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800aa9:	8b 45 14             	mov    0x14(%ebp),%eax
  800aac:	83 c0 04             	add    $0x4,%eax
  800aaf:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab5:	83 e8 04             	sub    $0x4,%eax
  800ab8:	8b 00                	mov    (%eax),%eax
  800aba:	83 ec 08             	sub    $0x8,%esp
  800abd:	ff 75 0c             	pushl  0xc(%ebp)
  800ac0:	50                   	push   %eax
  800ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac4:	ff d0                	call   *%eax
  800ac6:	83 c4 10             	add    $0x10,%esp
			break;
  800ac9:	e9 9b 02 00 00       	jmp    800d69 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ace:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad1:	83 c0 04             	add    $0x4,%eax
  800ad4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad7:	8b 45 14             	mov    0x14(%ebp),%eax
  800ada:	83 e8 04             	sub    $0x4,%eax
  800add:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800adf:	85 db                	test   %ebx,%ebx
  800ae1:	79 02                	jns    800ae5 <vprintfmt+0x14a>
				err = -err;
  800ae3:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ae5:	83 fb 64             	cmp    $0x64,%ebx
  800ae8:	7f 0b                	jg     800af5 <vprintfmt+0x15a>
  800aea:	8b 34 9d 20 27 80 00 	mov    0x802720(,%ebx,4),%esi
  800af1:	85 f6                	test   %esi,%esi
  800af3:	75 19                	jne    800b0e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800af5:	53                   	push   %ebx
  800af6:	68 c5 28 80 00       	push   $0x8028c5
  800afb:	ff 75 0c             	pushl  0xc(%ebp)
  800afe:	ff 75 08             	pushl  0x8(%ebp)
  800b01:	e8 70 02 00 00       	call   800d76 <printfmt>
  800b06:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b09:	e9 5b 02 00 00       	jmp    800d69 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b0e:	56                   	push   %esi
  800b0f:	68 ce 28 80 00       	push   $0x8028ce
  800b14:	ff 75 0c             	pushl  0xc(%ebp)
  800b17:	ff 75 08             	pushl  0x8(%ebp)
  800b1a:	e8 57 02 00 00       	call   800d76 <printfmt>
  800b1f:	83 c4 10             	add    $0x10,%esp
			break;
  800b22:	e9 42 02 00 00       	jmp    800d69 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b27:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2a:	83 c0 04             	add    $0x4,%eax
  800b2d:	89 45 14             	mov    %eax,0x14(%ebp)
  800b30:	8b 45 14             	mov    0x14(%ebp),%eax
  800b33:	83 e8 04             	sub    $0x4,%eax
  800b36:	8b 30                	mov    (%eax),%esi
  800b38:	85 f6                	test   %esi,%esi
  800b3a:	75 05                	jne    800b41 <vprintfmt+0x1a6>
				p = "(null)";
  800b3c:	be d1 28 80 00       	mov    $0x8028d1,%esi
			if (width > 0 && padc != '-')
  800b41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b45:	7e 6d                	jle    800bb4 <vprintfmt+0x219>
  800b47:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b4b:	74 67                	je     800bb4 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b50:	83 ec 08             	sub    $0x8,%esp
  800b53:	50                   	push   %eax
  800b54:	56                   	push   %esi
  800b55:	e8 26 05 00 00       	call   801080 <strnlen>
  800b5a:	83 c4 10             	add    $0x10,%esp
  800b5d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b60:	eb 16                	jmp    800b78 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b62:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b66:	83 ec 08             	sub    $0x8,%esp
  800b69:	ff 75 0c             	pushl  0xc(%ebp)
  800b6c:	50                   	push   %eax
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	ff d0                	call   *%eax
  800b72:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b75:	ff 4d e4             	decl   -0x1c(%ebp)
  800b78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b7c:	7f e4                	jg     800b62 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b7e:	eb 34                	jmp    800bb4 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b80:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b84:	74 1c                	je     800ba2 <vprintfmt+0x207>
  800b86:	83 fb 1f             	cmp    $0x1f,%ebx
  800b89:	7e 05                	jle    800b90 <vprintfmt+0x1f5>
  800b8b:	83 fb 7e             	cmp    $0x7e,%ebx
  800b8e:	7e 12                	jle    800ba2 <vprintfmt+0x207>
					putch('?', putdat);
  800b90:	83 ec 08             	sub    $0x8,%esp
  800b93:	ff 75 0c             	pushl  0xc(%ebp)
  800b96:	6a 3f                	push   $0x3f
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	ff d0                	call   *%eax
  800b9d:	83 c4 10             	add    $0x10,%esp
  800ba0:	eb 0f                	jmp    800bb1 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ba2:	83 ec 08             	sub    $0x8,%esp
  800ba5:	ff 75 0c             	pushl  0xc(%ebp)
  800ba8:	53                   	push   %ebx
  800ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bac:	ff d0                	call   *%eax
  800bae:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bb1:	ff 4d e4             	decl   -0x1c(%ebp)
  800bb4:	89 f0                	mov    %esi,%eax
  800bb6:	8d 70 01             	lea    0x1(%eax),%esi
  800bb9:	8a 00                	mov    (%eax),%al
  800bbb:	0f be d8             	movsbl %al,%ebx
  800bbe:	85 db                	test   %ebx,%ebx
  800bc0:	74 24                	je     800be6 <vprintfmt+0x24b>
  800bc2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bc6:	78 b8                	js     800b80 <vprintfmt+0x1e5>
  800bc8:	ff 4d e0             	decl   -0x20(%ebp)
  800bcb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bcf:	79 af                	jns    800b80 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bd1:	eb 13                	jmp    800be6 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bd3:	83 ec 08             	sub    $0x8,%esp
  800bd6:	ff 75 0c             	pushl  0xc(%ebp)
  800bd9:	6a 20                	push   $0x20
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	ff d0                	call   *%eax
  800be0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800be3:	ff 4d e4             	decl   -0x1c(%ebp)
  800be6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bea:	7f e7                	jg     800bd3 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bec:	e9 78 01 00 00       	jmp    800d69 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bf1:	83 ec 08             	sub    $0x8,%esp
  800bf4:	ff 75 e8             	pushl  -0x18(%ebp)
  800bf7:	8d 45 14             	lea    0x14(%ebp),%eax
  800bfa:	50                   	push   %eax
  800bfb:	e8 3c fd ff ff       	call   80093c <getint>
  800c00:	83 c4 10             	add    $0x10,%esp
  800c03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c06:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0f:	85 d2                	test   %edx,%edx
  800c11:	79 23                	jns    800c36 <vprintfmt+0x29b>
				putch('-', putdat);
  800c13:	83 ec 08             	sub    $0x8,%esp
  800c16:	ff 75 0c             	pushl  0xc(%ebp)
  800c19:	6a 2d                	push   $0x2d
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	ff d0                	call   *%eax
  800c20:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c29:	f7 d8                	neg    %eax
  800c2b:	83 d2 00             	adc    $0x0,%edx
  800c2e:	f7 da                	neg    %edx
  800c30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c33:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c36:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c3d:	e9 bc 00 00 00       	jmp    800cfe <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c42:	83 ec 08             	sub    $0x8,%esp
  800c45:	ff 75 e8             	pushl  -0x18(%ebp)
  800c48:	8d 45 14             	lea    0x14(%ebp),%eax
  800c4b:	50                   	push   %eax
  800c4c:	e8 84 fc ff ff       	call   8008d5 <getuint>
  800c51:	83 c4 10             	add    $0x10,%esp
  800c54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c57:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c5a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c61:	e9 98 00 00 00       	jmp    800cfe <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c66:	83 ec 08             	sub    $0x8,%esp
  800c69:	ff 75 0c             	pushl  0xc(%ebp)
  800c6c:	6a 58                	push   $0x58
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	ff d0                	call   *%eax
  800c73:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c76:	83 ec 08             	sub    $0x8,%esp
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	6a 58                	push   $0x58
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	ff d0                	call   *%eax
  800c83:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c86:	83 ec 08             	sub    $0x8,%esp
  800c89:	ff 75 0c             	pushl  0xc(%ebp)
  800c8c:	6a 58                	push   $0x58
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	ff d0                	call   *%eax
  800c93:	83 c4 10             	add    $0x10,%esp
			break;
  800c96:	e9 ce 00 00 00       	jmp    800d69 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c9b:	83 ec 08             	sub    $0x8,%esp
  800c9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ca1:	6a 30                	push   $0x30
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	ff d0                	call   *%eax
  800ca8:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cab:	83 ec 08             	sub    $0x8,%esp
  800cae:	ff 75 0c             	pushl  0xc(%ebp)
  800cb1:	6a 78                	push   $0x78
  800cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb6:	ff d0                	call   *%eax
  800cb8:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cbb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbe:	83 c0 04             	add    $0x4,%eax
  800cc1:	89 45 14             	mov    %eax,0x14(%ebp)
  800cc4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc7:	83 e8 04             	sub    $0x4,%eax
  800cca:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ccc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ccf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cd6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cdd:	eb 1f                	jmp    800cfe <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cdf:	83 ec 08             	sub    $0x8,%esp
  800ce2:	ff 75 e8             	pushl  -0x18(%ebp)
  800ce5:	8d 45 14             	lea    0x14(%ebp),%eax
  800ce8:	50                   	push   %eax
  800ce9:	e8 e7 fb ff ff       	call   8008d5 <getuint>
  800cee:	83 c4 10             	add    $0x10,%esp
  800cf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cf4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cf7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cfe:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d05:	83 ec 04             	sub    $0x4,%esp
  800d08:	52                   	push   %edx
  800d09:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d0c:	50                   	push   %eax
  800d0d:	ff 75 f4             	pushl  -0xc(%ebp)
  800d10:	ff 75 f0             	pushl  -0x10(%ebp)
  800d13:	ff 75 0c             	pushl  0xc(%ebp)
  800d16:	ff 75 08             	pushl  0x8(%ebp)
  800d19:	e8 00 fb ff ff       	call   80081e <printnum>
  800d1e:	83 c4 20             	add    $0x20,%esp
			break;
  800d21:	eb 46                	jmp    800d69 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d23:	83 ec 08             	sub    $0x8,%esp
  800d26:	ff 75 0c             	pushl  0xc(%ebp)
  800d29:	53                   	push   %ebx
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	ff d0                	call   *%eax
  800d2f:	83 c4 10             	add    $0x10,%esp
			break;
  800d32:	eb 35                	jmp    800d69 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d34:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800d3b:	eb 2c                	jmp    800d69 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d3d:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800d44:	eb 23                	jmp    800d69 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d46:	83 ec 08             	sub    $0x8,%esp
  800d49:	ff 75 0c             	pushl  0xc(%ebp)
  800d4c:	6a 25                	push   $0x25
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	ff d0                	call   *%eax
  800d53:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d56:	ff 4d 10             	decl   0x10(%ebp)
  800d59:	eb 03                	jmp    800d5e <vprintfmt+0x3c3>
  800d5b:	ff 4d 10             	decl   0x10(%ebp)
  800d5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d61:	48                   	dec    %eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	3c 25                	cmp    $0x25,%al
  800d66:	75 f3                	jne    800d5b <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d68:	90                   	nop
		}
	}
  800d69:	e9 35 fc ff ff       	jmp    8009a3 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d6e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d72:	5b                   	pop    %ebx
  800d73:	5e                   	pop    %esi
  800d74:	5d                   	pop    %ebp
  800d75:	c3                   	ret    

00800d76 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d76:	55                   	push   %ebp
  800d77:	89 e5                	mov    %esp,%ebp
  800d79:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d7c:	8d 45 10             	lea    0x10(%ebp),%eax
  800d7f:	83 c0 04             	add    $0x4,%eax
  800d82:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d85:	8b 45 10             	mov    0x10(%ebp),%eax
  800d88:	ff 75 f4             	pushl  -0xc(%ebp)
  800d8b:	50                   	push   %eax
  800d8c:	ff 75 0c             	pushl  0xc(%ebp)
  800d8f:	ff 75 08             	pushl  0x8(%ebp)
  800d92:	e8 04 fc ff ff       	call   80099b <vprintfmt>
  800d97:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d9a:	90                   	nop
  800d9b:	c9                   	leave  
  800d9c:	c3                   	ret    

00800d9d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da3:	8b 40 08             	mov    0x8(%eax),%eax
  800da6:	8d 50 01             	lea    0x1(%eax),%edx
  800da9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dac:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800daf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db2:	8b 10                	mov    (%eax),%edx
  800db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db7:	8b 40 04             	mov    0x4(%eax),%eax
  800dba:	39 c2                	cmp    %eax,%edx
  800dbc:	73 12                	jae    800dd0 <sprintputch+0x33>
		*b->buf++ = ch;
  800dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc1:	8b 00                	mov    (%eax),%eax
  800dc3:	8d 48 01             	lea    0x1(%eax),%ecx
  800dc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc9:	89 0a                	mov    %ecx,(%edx)
  800dcb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dce:	88 10                	mov    %dl,(%eax)
}
  800dd0:	90                   	nop
  800dd1:	5d                   	pop    %ebp
  800dd2:	c3                   	ret    

00800dd3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	01 d0                	add    %edx,%eax
  800dea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ded:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800df4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800df8:	74 06                	je     800e00 <vsnprintf+0x2d>
  800dfa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dfe:	7f 07                	jg     800e07 <vsnprintf+0x34>
		return -E_INVAL;
  800e00:	b8 03 00 00 00       	mov    $0x3,%eax
  800e05:	eb 20                	jmp    800e27 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e07:	ff 75 14             	pushl  0x14(%ebp)
  800e0a:	ff 75 10             	pushl  0x10(%ebp)
  800e0d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e10:	50                   	push   %eax
  800e11:	68 9d 0d 80 00       	push   $0x800d9d
  800e16:	e8 80 fb ff ff       	call   80099b <vprintfmt>
  800e1b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e21:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e27:	c9                   	leave  
  800e28:	c3                   	ret    

00800e29 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e2f:	8d 45 10             	lea    0x10(%ebp),%eax
  800e32:	83 c0 04             	add    $0x4,%eax
  800e35:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e38:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3b:	ff 75 f4             	pushl  -0xc(%ebp)
  800e3e:	50                   	push   %eax
  800e3f:	ff 75 0c             	pushl  0xc(%ebp)
  800e42:	ff 75 08             	pushl  0x8(%ebp)
  800e45:	e8 89 ff ff ff       	call   800dd3 <vsnprintf>
  800e4a:	83 c4 10             	add    $0x10,%esp
  800e4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e53:	c9                   	leave  
  800e54:	c3                   	ret    

00800e55 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800e55:	55                   	push   %ebp
  800e56:	89 e5                	mov    %esp,%ebp
  800e58:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800e5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e5f:	74 13                	je     800e74 <readline+0x1f>
		cprintf("%s", prompt);
  800e61:	83 ec 08             	sub    $0x8,%esp
  800e64:	ff 75 08             	pushl  0x8(%ebp)
  800e67:	68 48 2a 80 00       	push   $0x802a48
  800e6c:	e8 0b f9 ff ff       	call   80077c <cprintf>
  800e71:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800e74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800e7b:	83 ec 0c             	sub    $0xc,%esp
  800e7e:	6a 00                	push   $0x0
  800e80:	e8 7f 10 00 00       	call   801f04 <iscons>
  800e85:	83 c4 10             	add    $0x10,%esp
  800e88:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800e8b:	e8 61 10 00 00       	call   801ef1 <getchar>
  800e90:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800e93:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e97:	79 22                	jns    800ebb <readline+0x66>
			if (c != -E_EOF)
  800e99:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800e9d:	0f 84 ad 00 00 00    	je     800f50 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800ea3:	83 ec 08             	sub    $0x8,%esp
  800ea6:	ff 75 ec             	pushl  -0x14(%ebp)
  800ea9:	68 4b 2a 80 00       	push   $0x802a4b
  800eae:	e8 c9 f8 ff ff       	call   80077c <cprintf>
  800eb3:	83 c4 10             	add    $0x10,%esp
			break;
  800eb6:	e9 95 00 00 00       	jmp    800f50 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ebb:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ebf:	7e 34                	jle    800ef5 <readline+0xa0>
  800ec1:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ec8:	7f 2b                	jg     800ef5 <readline+0xa0>
			if (echoing)
  800eca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ece:	74 0e                	je     800ede <readline+0x89>
				cputchar(c);
  800ed0:	83 ec 0c             	sub    $0xc,%esp
  800ed3:	ff 75 ec             	pushl  -0x14(%ebp)
  800ed6:	e8 f7 0f 00 00       	call   801ed2 <cputchar>
  800edb:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee1:	8d 50 01             	lea    0x1(%eax),%edx
  800ee4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800ee7:	89 c2                	mov    %eax,%edx
  800ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eec:	01 d0                	add    %edx,%eax
  800eee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ef1:	88 10                	mov    %dl,(%eax)
  800ef3:	eb 56                	jmp    800f4b <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800ef5:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800ef9:	75 1f                	jne    800f1a <readline+0xc5>
  800efb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800eff:	7e 19                	jle    800f1a <readline+0xc5>
			if (echoing)
  800f01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f05:	74 0e                	je     800f15 <readline+0xc0>
				cputchar(c);
  800f07:	83 ec 0c             	sub    $0xc,%esp
  800f0a:	ff 75 ec             	pushl  -0x14(%ebp)
  800f0d:	e8 c0 0f 00 00       	call   801ed2 <cputchar>
  800f12:	83 c4 10             	add    $0x10,%esp

			i--;
  800f15:	ff 4d f4             	decl   -0xc(%ebp)
  800f18:	eb 31                	jmp    800f4b <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800f1a:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800f1e:	74 0a                	je     800f2a <readline+0xd5>
  800f20:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800f24:	0f 85 61 ff ff ff    	jne    800e8b <readline+0x36>
			if (echoing)
  800f2a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f2e:	74 0e                	je     800f3e <readline+0xe9>
				cputchar(c);
  800f30:	83 ec 0c             	sub    $0xc,%esp
  800f33:	ff 75 ec             	pushl  -0x14(%ebp)
  800f36:	e8 97 0f 00 00       	call   801ed2 <cputchar>
  800f3b:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800f3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f44:	01 d0                	add    %edx,%eax
  800f46:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800f49:	eb 06                	jmp    800f51 <readline+0xfc>
		}
	}
  800f4b:	e9 3b ff ff ff       	jmp    800e8b <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800f50:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800f51:	90                   	nop
  800f52:	c9                   	leave  
  800f53:	c3                   	ret    

00800f54 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800f54:	55                   	push   %ebp
  800f55:	89 e5                	mov    %esp,%ebp
  800f57:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800f5a:	e8 79 09 00 00       	call   8018d8 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800f5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f63:	74 13                	je     800f78 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800f65:	83 ec 08             	sub    $0x8,%esp
  800f68:	ff 75 08             	pushl  0x8(%ebp)
  800f6b:	68 48 2a 80 00       	push   $0x802a48
  800f70:	e8 07 f8 ff ff       	call   80077c <cprintf>
  800f75:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800f78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800f7f:	83 ec 0c             	sub    $0xc,%esp
  800f82:	6a 00                	push   $0x0
  800f84:	e8 7b 0f 00 00       	call   801f04 <iscons>
  800f89:	83 c4 10             	add    $0x10,%esp
  800f8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800f8f:	e8 5d 0f 00 00       	call   801ef1 <getchar>
  800f94:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800f97:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f9b:	79 22                	jns    800fbf <atomic_readline+0x6b>
				if (c != -E_EOF)
  800f9d:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800fa1:	0f 84 ad 00 00 00    	je     801054 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800fa7:	83 ec 08             	sub    $0x8,%esp
  800faa:	ff 75 ec             	pushl  -0x14(%ebp)
  800fad:	68 4b 2a 80 00       	push   $0x802a4b
  800fb2:	e8 c5 f7 ff ff       	call   80077c <cprintf>
  800fb7:	83 c4 10             	add    $0x10,%esp
				break;
  800fba:	e9 95 00 00 00       	jmp    801054 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800fbf:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800fc3:	7e 34                	jle    800ff9 <atomic_readline+0xa5>
  800fc5:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800fcc:	7f 2b                	jg     800ff9 <atomic_readline+0xa5>
				if (echoing)
  800fce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fd2:	74 0e                	je     800fe2 <atomic_readline+0x8e>
					cputchar(c);
  800fd4:	83 ec 0c             	sub    $0xc,%esp
  800fd7:	ff 75 ec             	pushl  -0x14(%ebp)
  800fda:	e8 f3 0e 00 00       	call   801ed2 <cputchar>
  800fdf:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe5:	8d 50 01             	lea    0x1(%eax),%edx
  800fe8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800feb:	89 c2                	mov    %eax,%edx
  800fed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff0:	01 d0                	add    %edx,%eax
  800ff2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ff5:	88 10                	mov    %dl,(%eax)
  800ff7:	eb 56                	jmp    80104f <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800ff9:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800ffd:	75 1f                	jne    80101e <atomic_readline+0xca>
  800fff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801003:	7e 19                	jle    80101e <atomic_readline+0xca>
				if (echoing)
  801005:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801009:	74 0e                	je     801019 <atomic_readline+0xc5>
					cputchar(c);
  80100b:	83 ec 0c             	sub    $0xc,%esp
  80100e:	ff 75 ec             	pushl  -0x14(%ebp)
  801011:	e8 bc 0e 00 00       	call   801ed2 <cputchar>
  801016:	83 c4 10             	add    $0x10,%esp
				i--;
  801019:	ff 4d f4             	decl   -0xc(%ebp)
  80101c:	eb 31                	jmp    80104f <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80101e:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801022:	74 0a                	je     80102e <atomic_readline+0xda>
  801024:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801028:	0f 85 61 ff ff ff    	jne    800f8f <atomic_readline+0x3b>
				if (echoing)
  80102e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801032:	74 0e                	je     801042 <atomic_readline+0xee>
					cputchar(c);
  801034:	83 ec 0c             	sub    $0xc,%esp
  801037:	ff 75 ec             	pushl  -0x14(%ebp)
  80103a:	e8 93 0e 00 00       	call   801ed2 <cputchar>
  80103f:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801042:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801045:	8b 45 0c             	mov    0xc(%ebp),%eax
  801048:	01 d0                	add    %edx,%eax
  80104a:	c6 00 00             	movb   $0x0,(%eax)
				break;
  80104d:	eb 06                	jmp    801055 <atomic_readline+0x101>
			}
		}
  80104f:	e9 3b ff ff ff       	jmp    800f8f <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801054:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801055:	e8 98 08 00 00       	call   8018f2 <sys_unlock_cons>
}
  80105a:	90                   	nop
  80105b:	c9                   	leave  
  80105c:	c3                   	ret    

0080105d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
  801060:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801063:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80106a:	eb 06                	jmp    801072 <strlen+0x15>
		n++;
  80106c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80106f:	ff 45 08             	incl   0x8(%ebp)
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	8a 00                	mov    (%eax),%al
  801077:	84 c0                	test   %al,%al
  801079:	75 f1                	jne    80106c <strlen+0xf>
		n++;
	return n;
  80107b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80107e:	c9                   	leave  
  80107f:	c3                   	ret    

00801080 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801080:	55                   	push   %ebp
  801081:	89 e5                	mov    %esp,%ebp
  801083:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801086:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80108d:	eb 09                	jmp    801098 <strnlen+0x18>
		n++;
  80108f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801092:	ff 45 08             	incl   0x8(%ebp)
  801095:	ff 4d 0c             	decl   0xc(%ebp)
  801098:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109c:	74 09                	je     8010a7 <strnlen+0x27>
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8a 00                	mov    (%eax),%al
  8010a3:	84 c0                	test   %al,%al
  8010a5:	75 e8                	jne    80108f <strnlen+0xf>
		n++;
	return n;
  8010a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010aa:	c9                   	leave  
  8010ab:	c3                   	ret    

008010ac <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010ac:	55                   	push   %ebp
  8010ad:	89 e5                	mov    %esp,%ebp
  8010af:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010b8:	90                   	nop
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	8d 50 01             	lea    0x1(%eax),%edx
  8010bf:	89 55 08             	mov    %edx,0x8(%ebp)
  8010c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010cb:	8a 12                	mov    (%edx),%dl
  8010cd:	88 10                	mov    %dl,(%eax)
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	84 c0                	test   %al,%al
  8010d3:	75 e4                	jne    8010b9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010d8:	c9                   	leave  
  8010d9:	c3                   	ret    

008010da <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010ed:	eb 1f                	jmp    80110e <strncpy+0x34>
		*dst++ = *src;
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	8d 50 01             	lea    0x1(%eax),%edx
  8010f5:	89 55 08             	mov    %edx,0x8(%ebp)
  8010f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010fb:	8a 12                	mov    (%edx),%dl
  8010fd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801102:	8a 00                	mov    (%eax),%al
  801104:	84 c0                	test   %al,%al
  801106:	74 03                	je     80110b <strncpy+0x31>
			src++;
  801108:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80110b:	ff 45 fc             	incl   -0x4(%ebp)
  80110e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801111:	3b 45 10             	cmp    0x10(%ebp),%eax
  801114:	72 d9                	jb     8010ef <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801116:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801119:	c9                   	leave  
  80111a:	c3                   	ret    

0080111b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80111b:	55                   	push   %ebp
  80111c:	89 e5                	mov    %esp,%ebp
  80111e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801127:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80112b:	74 30                	je     80115d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80112d:	eb 16                	jmp    801145 <strlcpy+0x2a>
			*dst++ = *src++;
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	8d 50 01             	lea    0x1(%eax),%edx
  801135:	89 55 08             	mov    %edx,0x8(%ebp)
  801138:	8b 55 0c             	mov    0xc(%ebp),%edx
  80113b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80113e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801141:	8a 12                	mov    (%edx),%dl
  801143:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801145:	ff 4d 10             	decl   0x10(%ebp)
  801148:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80114c:	74 09                	je     801157 <strlcpy+0x3c>
  80114e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801151:	8a 00                	mov    (%eax),%al
  801153:	84 c0                	test   %al,%al
  801155:	75 d8                	jne    80112f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80115d:	8b 55 08             	mov    0x8(%ebp),%edx
  801160:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801163:	29 c2                	sub    %eax,%edx
  801165:	89 d0                	mov    %edx,%eax
}
  801167:	c9                   	leave  
  801168:	c3                   	ret    

00801169 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80116c:	eb 06                	jmp    801174 <strcmp+0xb>
		p++, q++;
  80116e:	ff 45 08             	incl   0x8(%ebp)
  801171:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	8a 00                	mov    (%eax),%al
  801179:	84 c0                	test   %al,%al
  80117b:	74 0e                	je     80118b <strcmp+0x22>
  80117d:	8b 45 08             	mov    0x8(%ebp),%eax
  801180:	8a 10                	mov    (%eax),%dl
  801182:	8b 45 0c             	mov    0xc(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	38 c2                	cmp    %al,%dl
  801189:	74 e3                	je     80116e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	8a 00                	mov    (%eax),%al
  801190:	0f b6 d0             	movzbl %al,%edx
  801193:	8b 45 0c             	mov    0xc(%ebp),%eax
  801196:	8a 00                	mov    (%eax),%al
  801198:	0f b6 c0             	movzbl %al,%eax
  80119b:	29 c2                	sub    %eax,%edx
  80119d:	89 d0                	mov    %edx,%eax
}
  80119f:	5d                   	pop    %ebp
  8011a0:	c3                   	ret    

008011a1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8011a1:	55                   	push   %ebp
  8011a2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8011a4:	eb 09                	jmp    8011af <strncmp+0xe>
		n--, p++, q++;
  8011a6:	ff 4d 10             	decl   0x10(%ebp)
  8011a9:	ff 45 08             	incl   0x8(%ebp)
  8011ac:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b3:	74 17                	je     8011cc <strncmp+0x2b>
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	84 c0                	test   %al,%al
  8011bc:	74 0e                	je     8011cc <strncmp+0x2b>
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	8a 10                	mov    (%eax),%dl
  8011c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c6:	8a 00                	mov    (%eax),%al
  8011c8:	38 c2                	cmp    %al,%dl
  8011ca:	74 da                	je     8011a6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d0:	75 07                	jne    8011d9 <strncmp+0x38>
		return 0;
  8011d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8011d7:	eb 14                	jmp    8011ed <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dc:	8a 00                	mov    (%eax),%al
  8011de:	0f b6 d0             	movzbl %al,%edx
  8011e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	0f b6 c0             	movzbl %al,%eax
  8011e9:	29 c2                	sub    %eax,%edx
  8011eb:	89 d0                	mov    %edx,%eax
}
  8011ed:	5d                   	pop    %ebp
  8011ee:	c3                   	ret    

008011ef <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011ef:	55                   	push   %ebp
  8011f0:	89 e5                	mov    %esp,%ebp
  8011f2:	83 ec 04             	sub    $0x4,%esp
  8011f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011fb:	eb 12                	jmp    80120f <strchr+0x20>
		if (*s == c)
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801205:	75 05                	jne    80120c <strchr+0x1d>
			return (char *) s;
  801207:	8b 45 08             	mov    0x8(%ebp),%eax
  80120a:	eb 11                	jmp    80121d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80120c:	ff 45 08             	incl   0x8(%ebp)
  80120f:	8b 45 08             	mov    0x8(%ebp),%eax
  801212:	8a 00                	mov    (%eax),%al
  801214:	84 c0                	test   %al,%al
  801216:	75 e5                	jne    8011fd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801218:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80121d:	c9                   	leave  
  80121e:	c3                   	ret    

0080121f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80121f:	55                   	push   %ebp
  801220:	89 e5                	mov    %esp,%ebp
  801222:	83 ec 04             	sub    $0x4,%esp
  801225:	8b 45 0c             	mov    0xc(%ebp),%eax
  801228:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80122b:	eb 0d                	jmp    80123a <strfind+0x1b>
		if (*s == c)
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	8a 00                	mov    (%eax),%al
  801232:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801235:	74 0e                	je     801245 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801237:	ff 45 08             	incl   0x8(%ebp)
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	8a 00                	mov    (%eax),%al
  80123f:	84 c0                	test   %al,%al
  801241:	75 ea                	jne    80122d <strfind+0xe>
  801243:	eb 01                	jmp    801246 <strfind+0x27>
		if (*s == c)
			break;
  801245:	90                   	nop
	return (char *) s;
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801249:	c9                   	leave  
  80124a:	c3                   	ret    

0080124b <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
  80124e:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801257:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80125b:	76 63                	jbe    8012c0 <memset+0x75>
		uint64 data_block = c;
  80125d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801260:	99                   	cltd   
  801261:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801264:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801267:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80126a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80126d:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801271:	c1 e0 08             	shl    $0x8,%eax
  801274:	09 45 f0             	or     %eax,-0x10(%ebp)
  801277:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80127a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80127d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801280:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801284:	c1 e0 10             	shl    $0x10,%eax
  801287:	09 45 f0             	or     %eax,-0x10(%ebp)
  80128a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80128d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801290:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801293:	89 c2                	mov    %eax,%edx
  801295:	b8 00 00 00 00       	mov    $0x0,%eax
  80129a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80129d:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8012a0:	eb 18                	jmp    8012ba <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8012a2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012a5:	8d 41 08             	lea    0x8(%ecx),%eax
  8012a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8012ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b1:	89 01                	mov    %eax,(%ecx)
  8012b3:	89 51 04             	mov    %edx,0x4(%ecx)
  8012b6:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8012ba:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012be:	77 e2                	ja     8012a2 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8012c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c4:	74 23                	je     8012e9 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8012c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012cc:	eb 0e                	jmp    8012dc <memset+0x91>
			*p8++ = (uint8)c;
  8012ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d1:	8d 50 01             	lea    0x1(%eax),%edx
  8012d4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012da:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8012dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e5:	85 c0                	test   %eax,%eax
  8012e7:	75 e5                	jne    8012ce <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8012e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ec:	c9                   	leave  
  8012ed:	c3                   	ret    

008012ee <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8012f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801300:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801304:	76 24                	jbe    80132a <memcpy+0x3c>
		while(n >= 8){
  801306:	eb 1c                	jmp    801324 <memcpy+0x36>
			*d64 = *s64;
  801308:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80130b:	8b 50 04             	mov    0x4(%eax),%edx
  80130e:	8b 00                	mov    (%eax),%eax
  801310:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801313:	89 01                	mov    %eax,(%ecx)
  801315:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801318:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80131c:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801320:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801324:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801328:	77 de                	ja     801308 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80132a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80132e:	74 31                	je     801361 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801330:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801333:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801336:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801339:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80133c:	eb 16                	jmp    801354 <memcpy+0x66>
			*d8++ = *s8++;
  80133e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801341:	8d 50 01             	lea    0x1(%eax),%edx
  801344:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801347:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80134a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80134d:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801350:	8a 12                	mov    (%edx),%dl
  801352:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801354:	8b 45 10             	mov    0x10(%ebp),%eax
  801357:	8d 50 ff             	lea    -0x1(%eax),%edx
  80135a:	89 55 10             	mov    %edx,0x10(%ebp)
  80135d:	85 c0                	test   %eax,%eax
  80135f:	75 dd                	jne    80133e <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801361:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801364:	c9                   	leave  
  801365:	c3                   	ret    

00801366 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
  801369:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801378:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80137e:	73 50                	jae    8013d0 <memmove+0x6a>
  801380:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801383:	8b 45 10             	mov    0x10(%ebp),%eax
  801386:	01 d0                	add    %edx,%eax
  801388:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80138b:	76 43                	jbe    8013d0 <memmove+0x6a>
		s += n;
  80138d:	8b 45 10             	mov    0x10(%ebp),%eax
  801390:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801393:	8b 45 10             	mov    0x10(%ebp),%eax
  801396:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801399:	eb 10                	jmp    8013ab <memmove+0x45>
			*--d = *--s;
  80139b:	ff 4d f8             	decl   -0x8(%ebp)
  80139e:	ff 4d fc             	decl   -0x4(%ebp)
  8013a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a4:	8a 10                	mov    (%eax),%dl
  8013a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8013ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8013b4:	85 c0                	test   %eax,%eax
  8013b6:	75 e3                	jne    80139b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8013b8:	eb 23                	jmp    8013dd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8013ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013bd:	8d 50 01             	lea    0x1(%eax),%edx
  8013c0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013c9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013cc:	8a 12                	mov    (%edx),%dl
  8013ce:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	75 dd                	jne    8013ba <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013e0:	c9                   	leave  
  8013e1:	c3                   	ret    

008013e2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013e2:	55                   	push   %ebp
  8013e3:	89 e5                	mov    %esp,%ebp
  8013e5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013f4:	eb 2a                	jmp    801420 <memcmp+0x3e>
		if (*s1 != *s2)
  8013f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f9:	8a 10                	mov    (%eax),%dl
  8013fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	38 c2                	cmp    %al,%dl
  801402:	74 16                	je     80141a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801404:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801407:	8a 00                	mov    (%eax),%al
  801409:	0f b6 d0             	movzbl %al,%edx
  80140c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	0f b6 c0             	movzbl %al,%eax
  801414:	29 c2                	sub    %eax,%edx
  801416:	89 d0                	mov    %edx,%eax
  801418:	eb 18                	jmp    801432 <memcmp+0x50>
		s1++, s2++;
  80141a:	ff 45 fc             	incl   -0x4(%ebp)
  80141d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801420:	8b 45 10             	mov    0x10(%ebp),%eax
  801423:	8d 50 ff             	lea    -0x1(%eax),%edx
  801426:	89 55 10             	mov    %edx,0x10(%ebp)
  801429:	85 c0                	test   %eax,%eax
  80142b:	75 c9                	jne    8013f6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80142d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801432:	c9                   	leave  
  801433:	c3                   	ret    

00801434 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
  801437:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80143a:	8b 55 08             	mov    0x8(%ebp),%edx
  80143d:	8b 45 10             	mov    0x10(%ebp),%eax
  801440:	01 d0                	add    %edx,%eax
  801442:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801445:	eb 15                	jmp    80145c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	8a 00                	mov    (%eax),%al
  80144c:	0f b6 d0             	movzbl %al,%edx
  80144f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801452:	0f b6 c0             	movzbl %al,%eax
  801455:	39 c2                	cmp    %eax,%edx
  801457:	74 0d                	je     801466 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801459:	ff 45 08             	incl   0x8(%ebp)
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801462:	72 e3                	jb     801447 <memfind+0x13>
  801464:	eb 01                	jmp    801467 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801466:	90                   	nop
	return (void *) s;
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80146a:	c9                   	leave  
  80146b:	c3                   	ret    

0080146c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
  80146f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801472:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801479:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801480:	eb 03                	jmp    801485 <strtol+0x19>
		s++;
  801482:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801485:	8b 45 08             	mov    0x8(%ebp),%eax
  801488:	8a 00                	mov    (%eax),%al
  80148a:	3c 20                	cmp    $0x20,%al
  80148c:	74 f4                	je     801482 <strtol+0x16>
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	8a 00                	mov    (%eax),%al
  801493:	3c 09                	cmp    $0x9,%al
  801495:	74 eb                	je     801482 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
  80149a:	8a 00                	mov    (%eax),%al
  80149c:	3c 2b                	cmp    $0x2b,%al
  80149e:	75 05                	jne    8014a5 <strtol+0x39>
		s++;
  8014a0:	ff 45 08             	incl   0x8(%ebp)
  8014a3:	eb 13                	jmp    8014b8 <strtol+0x4c>
	else if (*s == '-')
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	8a 00                	mov    (%eax),%al
  8014aa:	3c 2d                	cmp    $0x2d,%al
  8014ac:	75 0a                	jne    8014b8 <strtol+0x4c>
		s++, neg = 1;
  8014ae:	ff 45 08             	incl   0x8(%ebp)
  8014b1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014bc:	74 06                	je     8014c4 <strtol+0x58>
  8014be:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014c2:	75 20                	jne    8014e4 <strtol+0x78>
  8014c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c7:	8a 00                	mov    (%eax),%al
  8014c9:	3c 30                	cmp    $0x30,%al
  8014cb:	75 17                	jne    8014e4 <strtol+0x78>
  8014cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d0:	40                   	inc    %eax
  8014d1:	8a 00                	mov    (%eax),%al
  8014d3:	3c 78                	cmp    $0x78,%al
  8014d5:	75 0d                	jne    8014e4 <strtol+0x78>
		s += 2, base = 16;
  8014d7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014db:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014e2:	eb 28                	jmp    80150c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e8:	75 15                	jne    8014ff <strtol+0x93>
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	8a 00                	mov    (%eax),%al
  8014ef:	3c 30                	cmp    $0x30,%al
  8014f1:	75 0c                	jne    8014ff <strtol+0x93>
		s++, base = 8;
  8014f3:	ff 45 08             	incl   0x8(%ebp)
  8014f6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014fd:	eb 0d                	jmp    80150c <strtol+0xa0>
	else if (base == 0)
  8014ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801503:	75 07                	jne    80150c <strtol+0xa0>
		base = 10;
  801505:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	8a 00                	mov    (%eax),%al
  801511:	3c 2f                	cmp    $0x2f,%al
  801513:	7e 19                	jle    80152e <strtol+0xc2>
  801515:	8b 45 08             	mov    0x8(%ebp),%eax
  801518:	8a 00                	mov    (%eax),%al
  80151a:	3c 39                	cmp    $0x39,%al
  80151c:	7f 10                	jg     80152e <strtol+0xc2>
			dig = *s - '0';
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	8a 00                	mov    (%eax),%al
  801523:	0f be c0             	movsbl %al,%eax
  801526:	83 e8 30             	sub    $0x30,%eax
  801529:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80152c:	eb 42                	jmp    801570 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	8a 00                	mov    (%eax),%al
  801533:	3c 60                	cmp    $0x60,%al
  801535:	7e 19                	jle    801550 <strtol+0xe4>
  801537:	8b 45 08             	mov    0x8(%ebp),%eax
  80153a:	8a 00                	mov    (%eax),%al
  80153c:	3c 7a                	cmp    $0x7a,%al
  80153e:	7f 10                	jg     801550 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801540:	8b 45 08             	mov    0x8(%ebp),%eax
  801543:	8a 00                	mov    (%eax),%al
  801545:	0f be c0             	movsbl %al,%eax
  801548:	83 e8 57             	sub    $0x57,%eax
  80154b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80154e:	eb 20                	jmp    801570 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801550:	8b 45 08             	mov    0x8(%ebp),%eax
  801553:	8a 00                	mov    (%eax),%al
  801555:	3c 40                	cmp    $0x40,%al
  801557:	7e 39                	jle    801592 <strtol+0x126>
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	8a 00                	mov    (%eax),%al
  80155e:	3c 5a                	cmp    $0x5a,%al
  801560:	7f 30                	jg     801592 <strtol+0x126>
			dig = *s - 'A' + 10;
  801562:	8b 45 08             	mov    0x8(%ebp),%eax
  801565:	8a 00                	mov    (%eax),%al
  801567:	0f be c0             	movsbl %al,%eax
  80156a:	83 e8 37             	sub    $0x37,%eax
  80156d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801573:	3b 45 10             	cmp    0x10(%ebp),%eax
  801576:	7d 19                	jge    801591 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801578:	ff 45 08             	incl   0x8(%ebp)
  80157b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80157e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801582:	89 c2                	mov    %eax,%edx
  801584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801587:	01 d0                	add    %edx,%eax
  801589:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80158c:	e9 7b ff ff ff       	jmp    80150c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801591:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801592:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801596:	74 08                	je     8015a0 <strtol+0x134>
		*endptr = (char *) s;
  801598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159b:	8b 55 08             	mov    0x8(%ebp),%edx
  80159e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8015a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015a4:	74 07                	je     8015ad <strtol+0x141>
  8015a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015a9:	f7 d8                	neg    %eax
  8015ab:	eb 03                	jmp    8015b0 <strtol+0x144>
  8015ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <ltostr>:

void
ltostr(long value, char *str)
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
  8015b5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8015b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8015bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015ca:	79 13                	jns    8015df <ltostr+0x2d>
	{
		neg = 1;
  8015cc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015d9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015dc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015e7:	99                   	cltd   
  8015e8:	f7 f9                	idiv   %ecx
  8015ea:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015f0:	8d 50 01             	lea    0x1(%eax),%edx
  8015f3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015f6:	89 c2                	mov    %eax,%edx
  8015f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fb:	01 d0                	add    %edx,%eax
  8015fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801600:	83 c2 30             	add    $0x30,%edx
  801603:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801605:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801608:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80160d:	f7 e9                	imul   %ecx
  80160f:	c1 fa 02             	sar    $0x2,%edx
  801612:	89 c8                	mov    %ecx,%eax
  801614:	c1 f8 1f             	sar    $0x1f,%eax
  801617:	29 c2                	sub    %eax,%edx
  801619:	89 d0                	mov    %edx,%eax
  80161b:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80161e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801622:	75 bb                	jne    8015df <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801624:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80162b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80162e:	48                   	dec    %eax
  80162f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801632:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801636:	74 3d                	je     801675 <ltostr+0xc3>
		start = 1 ;
  801638:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80163f:	eb 34                	jmp    801675 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801641:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801644:	8b 45 0c             	mov    0xc(%ebp),%eax
  801647:	01 d0                	add    %edx,%eax
  801649:	8a 00                	mov    (%eax),%al
  80164b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80164e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801651:	8b 45 0c             	mov    0xc(%ebp),%eax
  801654:	01 c2                	add    %eax,%edx
  801656:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801659:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165c:	01 c8                	add    %ecx,%eax
  80165e:	8a 00                	mov    (%eax),%al
  801660:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801662:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801665:	8b 45 0c             	mov    0xc(%ebp),%eax
  801668:	01 c2                	add    %eax,%edx
  80166a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80166d:	88 02                	mov    %al,(%edx)
		start++ ;
  80166f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801672:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801678:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80167b:	7c c4                	jl     801641 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80167d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801680:	8b 45 0c             	mov    0xc(%ebp),%eax
  801683:	01 d0                	add    %edx,%eax
  801685:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801688:	90                   	nop
  801689:	c9                   	leave  
  80168a:	c3                   	ret    

0080168b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801691:	ff 75 08             	pushl  0x8(%ebp)
  801694:	e8 c4 f9 ff ff       	call   80105d <strlen>
  801699:	83 c4 04             	add    $0x4,%esp
  80169c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80169f:	ff 75 0c             	pushl  0xc(%ebp)
  8016a2:	e8 b6 f9 ff ff       	call   80105d <strlen>
  8016a7:	83 c4 04             	add    $0x4,%esp
  8016aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8016b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016bb:	eb 17                	jmp    8016d4 <strcconcat+0x49>
		final[s] = str1[s] ;
  8016bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c3:	01 c2                	add    %eax,%edx
  8016c5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	01 c8                	add    %ecx,%eax
  8016cd:	8a 00                	mov    (%eax),%al
  8016cf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016d1:	ff 45 fc             	incl   -0x4(%ebp)
  8016d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016da:	7c e1                	jl     8016bd <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016dc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016e3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016ea:	eb 1f                	jmp    80170b <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ef:	8d 50 01             	lea    0x1(%eax),%edx
  8016f2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016f5:	89 c2                	mov    %eax,%edx
  8016f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fa:	01 c2                	add    %eax,%edx
  8016fc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801702:	01 c8                	add    %ecx,%eax
  801704:	8a 00                	mov    (%eax),%al
  801706:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801708:	ff 45 f8             	incl   -0x8(%ebp)
  80170b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80170e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801711:	7c d9                	jl     8016ec <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801713:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801716:	8b 45 10             	mov    0x10(%ebp),%eax
  801719:	01 d0                	add    %edx,%eax
  80171b:	c6 00 00             	movb   $0x0,(%eax)
}
  80171e:	90                   	nop
  80171f:	c9                   	leave  
  801720:	c3                   	ret    

00801721 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801724:	8b 45 14             	mov    0x14(%ebp),%eax
  801727:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80172d:	8b 45 14             	mov    0x14(%ebp),%eax
  801730:	8b 00                	mov    (%eax),%eax
  801732:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801739:	8b 45 10             	mov    0x10(%ebp),%eax
  80173c:	01 d0                	add    %edx,%eax
  80173e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801744:	eb 0c                	jmp    801752 <strsplit+0x31>
			*string++ = 0;
  801746:	8b 45 08             	mov    0x8(%ebp),%eax
  801749:	8d 50 01             	lea    0x1(%eax),%edx
  80174c:	89 55 08             	mov    %edx,0x8(%ebp)
  80174f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	8a 00                	mov    (%eax),%al
  801757:	84 c0                	test   %al,%al
  801759:	74 18                	je     801773 <strsplit+0x52>
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	8a 00                	mov    (%eax),%al
  801760:	0f be c0             	movsbl %al,%eax
  801763:	50                   	push   %eax
  801764:	ff 75 0c             	pushl  0xc(%ebp)
  801767:	e8 83 fa ff ff       	call   8011ef <strchr>
  80176c:	83 c4 08             	add    $0x8,%esp
  80176f:	85 c0                	test   %eax,%eax
  801771:	75 d3                	jne    801746 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801773:	8b 45 08             	mov    0x8(%ebp),%eax
  801776:	8a 00                	mov    (%eax),%al
  801778:	84 c0                	test   %al,%al
  80177a:	74 5a                	je     8017d6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80177c:	8b 45 14             	mov    0x14(%ebp),%eax
  80177f:	8b 00                	mov    (%eax),%eax
  801781:	83 f8 0f             	cmp    $0xf,%eax
  801784:	75 07                	jne    80178d <strsplit+0x6c>
		{
			return 0;
  801786:	b8 00 00 00 00       	mov    $0x0,%eax
  80178b:	eb 66                	jmp    8017f3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80178d:	8b 45 14             	mov    0x14(%ebp),%eax
  801790:	8b 00                	mov    (%eax),%eax
  801792:	8d 48 01             	lea    0x1(%eax),%ecx
  801795:	8b 55 14             	mov    0x14(%ebp),%edx
  801798:	89 0a                	mov    %ecx,(%edx)
  80179a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a4:	01 c2                	add    %eax,%edx
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017ab:	eb 03                	jmp    8017b0 <strsplit+0x8f>
			string++;
  8017ad:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	8a 00                	mov    (%eax),%al
  8017b5:	84 c0                	test   %al,%al
  8017b7:	74 8b                	je     801744 <strsplit+0x23>
  8017b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bc:	8a 00                	mov    (%eax),%al
  8017be:	0f be c0             	movsbl %al,%eax
  8017c1:	50                   	push   %eax
  8017c2:	ff 75 0c             	pushl  0xc(%ebp)
  8017c5:	e8 25 fa ff ff       	call   8011ef <strchr>
  8017ca:	83 c4 08             	add    $0x8,%esp
  8017cd:	85 c0                	test   %eax,%eax
  8017cf:	74 dc                	je     8017ad <strsplit+0x8c>
			string++;
	}
  8017d1:	e9 6e ff ff ff       	jmp    801744 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017d6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8017da:	8b 00                	mov    (%eax),%eax
  8017dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e6:	01 d0                	add    %edx,%eax
  8017e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017ee:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801801:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801808:	eb 4a                	jmp    801854 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80180a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	01 c2                	add    %eax,%edx
  801812:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801815:	8b 45 0c             	mov    0xc(%ebp),%eax
  801818:	01 c8                	add    %ecx,%eax
  80181a:	8a 00                	mov    (%eax),%al
  80181c:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80181e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801821:	8b 45 0c             	mov    0xc(%ebp),%eax
  801824:	01 d0                	add    %edx,%eax
  801826:	8a 00                	mov    (%eax),%al
  801828:	3c 40                	cmp    $0x40,%al
  80182a:	7e 25                	jle    801851 <str2lower+0x5c>
  80182c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80182f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801832:	01 d0                	add    %edx,%eax
  801834:	8a 00                	mov    (%eax),%al
  801836:	3c 5a                	cmp    $0x5a,%al
  801838:	7f 17                	jg     801851 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80183a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	01 d0                	add    %edx,%eax
  801842:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801845:	8b 55 08             	mov    0x8(%ebp),%edx
  801848:	01 ca                	add    %ecx,%edx
  80184a:	8a 12                	mov    (%edx),%dl
  80184c:	83 c2 20             	add    $0x20,%edx
  80184f:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801851:	ff 45 fc             	incl   -0x4(%ebp)
  801854:	ff 75 0c             	pushl  0xc(%ebp)
  801857:	e8 01 f8 ff ff       	call   80105d <strlen>
  80185c:	83 c4 04             	add    $0x4,%esp
  80185f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801862:	7f a6                	jg     80180a <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801864:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
  80186c:	57                   	push   %edi
  80186d:	56                   	push   %esi
  80186e:	53                   	push   %ebx
  80186f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	8b 55 0c             	mov    0xc(%ebp),%edx
  801878:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80187b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80187e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801881:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801884:	cd 30                	int    $0x30
  801886:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801889:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80188c:	83 c4 10             	add    $0x10,%esp
  80188f:	5b                   	pop    %ebx
  801890:	5e                   	pop    %esi
  801891:	5f                   	pop    %edi
  801892:	5d                   	pop    %ebp
  801893:	c3                   	ret    

00801894 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	83 ec 04             	sub    $0x4,%esp
  80189a:	8b 45 10             	mov    0x10(%ebp),%eax
  80189d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8018a0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018a3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018aa:	6a 00                	push   $0x0
  8018ac:	51                   	push   %ecx
  8018ad:	52                   	push   %edx
  8018ae:	ff 75 0c             	pushl  0xc(%ebp)
  8018b1:	50                   	push   %eax
  8018b2:	6a 00                	push   $0x0
  8018b4:	e8 b0 ff ff ff       	call   801869 <syscall>
  8018b9:	83 c4 18             	add    $0x18,%esp
}
  8018bc:	90                   	nop
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <sys_cgetc>:

int
sys_cgetc(void)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 02                	push   $0x2
  8018ce:	e8 96 ff ff ff       	call   801869 <syscall>
  8018d3:	83 c4 18             	add    $0x18,%esp
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 03                	push   $0x3
  8018e7:	e8 7d ff ff ff       	call   801869 <syscall>
  8018ec:	83 c4 18             	add    $0x18,%esp
}
  8018ef:	90                   	nop
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 04                	push   $0x4
  801901:	e8 63 ff ff ff       	call   801869 <syscall>
  801906:	83 c4 18             	add    $0x18,%esp
}
  801909:	90                   	nop
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80190f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	52                   	push   %edx
  80191c:	50                   	push   %eax
  80191d:	6a 08                	push   $0x8
  80191f:	e8 45 ff ff ff       	call   801869 <syscall>
  801924:	83 c4 18             	add    $0x18,%esp
}
  801927:	c9                   	leave  
  801928:	c3                   	ret    

00801929 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
  80192c:	56                   	push   %esi
  80192d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80192e:	8b 75 18             	mov    0x18(%ebp),%esi
  801931:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801934:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801937:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	56                   	push   %esi
  80193e:	53                   	push   %ebx
  80193f:	51                   	push   %ecx
  801940:	52                   	push   %edx
  801941:	50                   	push   %eax
  801942:	6a 09                	push   $0x9
  801944:	e8 20 ff ff ff       	call   801869 <syscall>
  801949:	83 c4 18             	add    $0x18,%esp
}
  80194c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80194f:	5b                   	pop    %ebx
  801950:	5e                   	pop    %esi
  801951:	5d                   	pop    %ebp
  801952:	c3                   	ret    

00801953 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	ff 75 08             	pushl  0x8(%ebp)
  801961:	6a 0a                	push   $0xa
  801963:	e8 01 ff ff ff       	call   801869 <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	ff 75 0c             	pushl  0xc(%ebp)
  801979:	ff 75 08             	pushl  0x8(%ebp)
  80197c:	6a 0b                	push   $0xb
  80197e:	e8 e6 fe ff ff       	call   801869 <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 0c                	push   $0xc
  801997:	e8 cd fe ff ff       	call   801869 <syscall>
  80199c:	83 c4 18             	add    $0x18,%esp
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 0d                	push   $0xd
  8019b0:	e8 b4 fe ff ff       	call   801869 <syscall>
  8019b5:	83 c4 18             	add    $0x18,%esp
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 0e                	push   $0xe
  8019c9:	e8 9b fe ff ff       	call   801869 <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 0f                	push   $0xf
  8019e2:	e8 82 fe ff ff       	call   801869 <syscall>
  8019e7:	83 c4 18             	add    $0x18,%esp
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	ff 75 08             	pushl  0x8(%ebp)
  8019fa:	6a 10                	push   $0x10
  8019fc:	e8 68 fe ff ff       	call   801869 <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
}
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 11                	push   $0x11
  801a15:	e8 4f fe ff ff       	call   801869 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
}
  801a1d:	90                   	nop
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <sys_cputc>:

void
sys_cputc(const char c)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	83 ec 04             	sub    $0x4,%esp
  801a26:	8b 45 08             	mov    0x8(%ebp),%eax
  801a29:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a2c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	50                   	push   %eax
  801a39:	6a 01                	push   $0x1
  801a3b:	e8 29 fe ff ff       	call   801869 <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
}
  801a43:	90                   	nop
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 14                	push   $0x14
  801a55:	e8 0f fe ff ff       	call   801869 <syscall>
  801a5a:	83 c4 18             	add    $0x18,%esp
}
  801a5d:	90                   	nop
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	83 ec 04             	sub    $0x4,%esp
  801a66:	8b 45 10             	mov    0x10(%ebp),%eax
  801a69:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a6c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a6f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a73:	8b 45 08             	mov    0x8(%ebp),%eax
  801a76:	6a 00                	push   $0x0
  801a78:	51                   	push   %ecx
  801a79:	52                   	push   %edx
  801a7a:	ff 75 0c             	pushl  0xc(%ebp)
  801a7d:	50                   	push   %eax
  801a7e:	6a 15                	push   $0x15
  801a80:	e8 e4 fd ff ff       	call   801869 <syscall>
  801a85:	83 c4 18             	add    $0x18,%esp
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	52                   	push   %edx
  801a9a:	50                   	push   %eax
  801a9b:	6a 16                	push   $0x16
  801a9d:	e8 c7 fd ff ff       	call   801869 <syscall>
  801aa2:	83 c4 18             	add    $0x18,%esp
}
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801aaa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	51                   	push   %ecx
  801ab8:	52                   	push   %edx
  801ab9:	50                   	push   %eax
  801aba:	6a 17                	push   $0x17
  801abc:	e8 a8 fd ff ff       	call   801869 <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
}
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ac9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acc:	8b 45 08             	mov    0x8(%ebp),%eax
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	52                   	push   %edx
  801ad6:	50                   	push   %eax
  801ad7:	6a 18                	push   $0x18
  801ad9:	e8 8b fd ff ff       	call   801869 <syscall>
  801ade:	83 c4 18             	add    $0x18,%esp
}
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae9:	6a 00                	push   $0x0
  801aeb:	ff 75 14             	pushl  0x14(%ebp)
  801aee:	ff 75 10             	pushl  0x10(%ebp)
  801af1:	ff 75 0c             	pushl  0xc(%ebp)
  801af4:	50                   	push   %eax
  801af5:	6a 19                	push   $0x19
  801af7:	e8 6d fd ff ff       	call   801869 <syscall>
  801afc:	83 c4 18             	add    $0x18,%esp
}
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	50                   	push   %eax
  801b10:	6a 1a                	push   $0x1a
  801b12:	e8 52 fd ff ff       	call   801869 <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
}
  801b1a:	90                   	nop
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b20:	8b 45 08             	mov    0x8(%ebp),%eax
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	50                   	push   %eax
  801b2c:	6a 1b                	push   $0x1b
  801b2e:	e8 36 fd ff ff       	call   801869 <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 05                	push   $0x5
  801b47:	e8 1d fd ff ff       	call   801869 <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 06                	push   $0x6
  801b60:	e8 04 fd ff ff       	call   801869 <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 07                	push   $0x7
  801b79:	e8 eb fc ff ff       	call   801869 <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <sys_exit_env>:


void sys_exit_env(void)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 1c                	push   $0x1c
  801b92:	e8 d2 fc ff ff       	call   801869 <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
}
  801b9a:	90                   	nop
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ba3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ba6:	8d 50 04             	lea    0x4(%eax),%edx
  801ba9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	52                   	push   %edx
  801bb3:	50                   	push   %eax
  801bb4:	6a 1d                	push   $0x1d
  801bb6:	e8 ae fc ff ff       	call   801869 <syscall>
  801bbb:	83 c4 18             	add    $0x18,%esp
	return result;
  801bbe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bc4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bc7:	89 01                	mov    %eax,(%ecx)
  801bc9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	c9                   	leave  
  801bd0:	c2 04 00             	ret    $0x4

00801bd3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	ff 75 10             	pushl  0x10(%ebp)
  801bdd:	ff 75 0c             	pushl  0xc(%ebp)
  801be0:	ff 75 08             	pushl  0x8(%ebp)
  801be3:	6a 13                	push   $0x13
  801be5:	e8 7f fc ff ff       	call   801869 <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
	return ;
  801bed:	90                   	nop
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 1e                	push   $0x1e
  801bff:	e8 65 fc ff ff       	call   801869 <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	83 ec 04             	sub    $0x4,%esp
  801c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c12:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c15:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	50                   	push   %eax
  801c22:	6a 1f                	push   $0x1f
  801c24:	e8 40 fc ff ff       	call   801869 <syscall>
  801c29:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2c:	90                   	nop
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <rsttst>:
void rsttst()
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 21                	push   $0x21
  801c3e:	e8 26 fc ff ff       	call   801869 <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
	return ;
  801c46:	90                   	nop
}
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
  801c4c:	83 ec 04             	sub    $0x4,%esp
  801c4f:	8b 45 14             	mov    0x14(%ebp),%eax
  801c52:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c55:	8b 55 18             	mov    0x18(%ebp),%edx
  801c58:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c5c:	52                   	push   %edx
  801c5d:	50                   	push   %eax
  801c5e:	ff 75 10             	pushl  0x10(%ebp)
  801c61:	ff 75 0c             	pushl  0xc(%ebp)
  801c64:	ff 75 08             	pushl  0x8(%ebp)
  801c67:	6a 20                	push   $0x20
  801c69:	e8 fb fb ff ff       	call   801869 <syscall>
  801c6e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c71:	90                   	nop
}
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <chktst>:
void chktst(uint32 n)
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	ff 75 08             	pushl  0x8(%ebp)
  801c82:	6a 22                	push   $0x22
  801c84:	e8 e0 fb ff ff       	call   801869 <syscall>
  801c89:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8c:	90                   	nop
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <inctst>:

void inctst()
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 23                	push   $0x23
  801c9e:	e8 c6 fb ff ff       	call   801869 <syscall>
  801ca3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca6:	90                   	nop
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <gettst>:
uint32 gettst()
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 24                	push   $0x24
  801cb8:	e8 ac fb ff ff       	call   801869 <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 25                	push   $0x25
  801cd1:	e8 93 fb ff ff       	call   801869 <syscall>
  801cd6:	83 c4 18             	add    $0x18,%esp
  801cd9:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801cde:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ceb:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	ff 75 08             	pushl  0x8(%ebp)
  801cfb:	6a 26                	push   $0x26
  801cfd:	e8 67 fb ff ff       	call   801869 <syscall>
  801d02:	83 c4 18             	add    $0x18,%esp
	return ;
  801d05:	90                   	nop
}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
  801d0b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d0c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d0f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d15:	8b 45 08             	mov    0x8(%ebp),%eax
  801d18:	6a 00                	push   $0x0
  801d1a:	53                   	push   %ebx
  801d1b:	51                   	push   %ecx
  801d1c:	52                   	push   %edx
  801d1d:	50                   	push   %eax
  801d1e:	6a 27                	push   $0x27
  801d20:	e8 44 fb ff ff       	call   801869 <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
}
  801d28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d33:	8b 45 08             	mov    0x8(%ebp),%eax
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	52                   	push   %edx
  801d3d:	50                   	push   %eax
  801d3e:	6a 28                	push   $0x28
  801d40:	e8 24 fb ff ff       	call   801869 <syscall>
  801d45:	83 c4 18             	add    $0x18,%esp
}
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d4d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d53:	8b 45 08             	mov    0x8(%ebp),%eax
  801d56:	6a 00                	push   $0x0
  801d58:	51                   	push   %ecx
  801d59:	ff 75 10             	pushl  0x10(%ebp)
  801d5c:	52                   	push   %edx
  801d5d:	50                   	push   %eax
  801d5e:	6a 29                	push   $0x29
  801d60:	e8 04 fb ff ff       	call   801869 <syscall>
  801d65:	83 c4 18             	add    $0x18,%esp
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	ff 75 10             	pushl  0x10(%ebp)
  801d74:	ff 75 0c             	pushl  0xc(%ebp)
  801d77:	ff 75 08             	pushl  0x8(%ebp)
  801d7a:	6a 12                	push   $0x12
  801d7c:	e8 e8 fa ff ff       	call   801869 <syscall>
  801d81:	83 c4 18             	add    $0x18,%esp
	return ;
  801d84:	90                   	nop
}
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	52                   	push   %edx
  801d97:	50                   	push   %eax
  801d98:	6a 2a                	push   $0x2a
  801d9a:	e8 ca fa ff ff       	call   801869 <syscall>
  801d9f:	83 c4 18             	add    $0x18,%esp
	return;
  801da2:	90                   	nop
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 2b                	push   $0x2b
  801db4:	e8 b0 fa ff ff       	call   801869 <syscall>
  801db9:	83 c4 18             	add    $0x18,%esp
}
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	ff 75 0c             	pushl  0xc(%ebp)
  801dca:	ff 75 08             	pushl  0x8(%ebp)
  801dcd:	6a 2d                	push   $0x2d
  801dcf:	e8 95 fa ff ff       	call   801869 <syscall>
  801dd4:	83 c4 18             	add    $0x18,%esp
	return;
  801dd7:	90                   	nop
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	ff 75 0c             	pushl  0xc(%ebp)
  801de6:	ff 75 08             	pushl  0x8(%ebp)
  801de9:	6a 2c                	push   $0x2c
  801deb:	e8 79 fa ff ff       	call   801869 <syscall>
  801df0:	83 c4 18             	add    $0x18,%esp
	return ;
  801df3:	90                   	nop
}
  801df4:	c9                   	leave  
  801df5:	c3                   	ret    

00801df6 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801df9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	52                   	push   %edx
  801e06:	50                   	push   %eax
  801e07:	6a 2e                	push   $0x2e
  801e09:	e8 5b fa ff ff       	call   801869 <syscall>
  801e0e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e11:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801e12:	c9                   	leave  
  801e13:	c3                   	ret    

00801e14 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801e14:	55                   	push   %ebp
  801e15:	89 e5                	mov    %esp,%ebp
  801e17:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801e1a:	8b 55 08             	mov    0x8(%ebp),%edx
  801e1d:	89 d0                	mov    %edx,%eax
  801e1f:	c1 e0 02             	shl    $0x2,%eax
  801e22:	01 d0                	add    %edx,%eax
  801e24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e2b:	01 d0                	add    %edx,%eax
  801e2d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e34:	01 d0                	add    %edx,%eax
  801e36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e3d:	01 d0                	add    %edx,%eax
  801e3f:	c1 e0 04             	shl    $0x4,%eax
  801e42:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801e45:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801e4c:	0f 31                	rdtsc  
  801e4e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e51:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801e54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e57:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e5d:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e60:	eb 46                	jmp    801ea8 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801e62:	0f 31                	rdtsc  
  801e64:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801e67:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801e6a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e6d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801e70:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e73:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801e76:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7c:	29 c2                	sub    %eax,%edx
  801e7e:	89 d0                	mov    %edx,%eax
  801e80:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801e83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e89:	89 d1                	mov    %edx,%ecx
  801e8b:	29 c1                	sub    %eax,%ecx
  801e8d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e93:	39 c2                	cmp    %eax,%edx
  801e95:	0f 97 c0             	seta   %al
  801e98:	0f b6 c0             	movzbl %al,%eax
  801e9b:	29 c1                	sub    %eax,%ecx
  801e9d:	89 c8                	mov    %ecx,%eax
  801e9f:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801ea2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ea5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801ea8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801eae:	72 b2                	jb     801e62 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801eb0:	90                   	nop
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801eb9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801ec0:	eb 03                	jmp    801ec5 <busy_wait+0x12>
  801ec2:	ff 45 fc             	incl   -0x4(%ebp)
  801ec5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ec8:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ecb:	72 f5                	jb     801ec2 <busy_wait+0xf>
	return i;
  801ecd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
  801ed5:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  801edb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801ede:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801ee2:	83 ec 0c             	sub    $0xc,%esp
  801ee5:	50                   	push   %eax
  801ee6:	e8 35 fb ff ff       	call   801a20 <sys_cputc>
  801eeb:	83 c4 10             	add    $0x10,%esp
}
  801eee:	90                   	nop
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    

00801ef1 <getchar>:


int
getchar(void)
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801ef7:	e8 c3 f9 ff ff       	call   8018bf <sys_cgetc>
  801efc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f02:	c9                   	leave  
  801f03:	c3                   	ret    

00801f04 <iscons>:

int iscons(int fdnum)
{
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801f07:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f0c:	5d                   	pop    %ebp
  801f0d:	c3                   	ret    
  801f0e:	66 90                	xchg   %ax,%ax

00801f10 <__udivdi3>:
  801f10:	55                   	push   %ebp
  801f11:	57                   	push   %edi
  801f12:	56                   	push   %esi
  801f13:	53                   	push   %ebx
  801f14:	83 ec 1c             	sub    $0x1c,%esp
  801f17:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f1b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f23:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f27:	89 ca                	mov    %ecx,%edx
  801f29:	89 f8                	mov    %edi,%eax
  801f2b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f2f:	85 f6                	test   %esi,%esi
  801f31:	75 2d                	jne    801f60 <__udivdi3+0x50>
  801f33:	39 cf                	cmp    %ecx,%edi
  801f35:	77 65                	ja     801f9c <__udivdi3+0x8c>
  801f37:	89 fd                	mov    %edi,%ebp
  801f39:	85 ff                	test   %edi,%edi
  801f3b:	75 0b                	jne    801f48 <__udivdi3+0x38>
  801f3d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f42:	31 d2                	xor    %edx,%edx
  801f44:	f7 f7                	div    %edi
  801f46:	89 c5                	mov    %eax,%ebp
  801f48:	31 d2                	xor    %edx,%edx
  801f4a:	89 c8                	mov    %ecx,%eax
  801f4c:	f7 f5                	div    %ebp
  801f4e:	89 c1                	mov    %eax,%ecx
  801f50:	89 d8                	mov    %ebx,%eax
  801f52:	f7 f5                	div    %ebp
  801f54:	89 cf                	mov    %ecx,%edi
  801f56:	89 fa                	mov    %edi,%edx
  801f58:	83 c4 1c             	add    $0x1c,%esp
  801f5b:	5b                   	pop    %ebx
  801f5c:	5e                   	pop    %esi
  801f5d:	5f                   	pop    %edi
  801f5e:	5d                   	pop    %ebp
  801f5f:	c3                   	ret    
  801f60:	39 ce                	cmp    %ecx,%esi
  801f62:	77 28                	ja     801f8c <__udivdi3+0x7c>
  801f64:	0f bd fe             	bsr    %esi,%edi
  801f67:	83 f7 1f             	xor    $0x1f,%edi
  801f6a:	75 40                	jne    801fac <__udivdi3+0x9c>
  801f6c:	39 ce                	cmp    %ecx,%esi
  801f6e:	72 0a                	jb     801f7a <__udivdi3+0x6a>
  801f70:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801f74:	0f 87 9e 00 00 00    	ja     802018 <__udivdi3+0x108>
  801f7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f7f:	89 fa                	mov    %edi,%edx
  801f81:	83 c4 1c             	add    $0x1c,%esp
  801f84:	5b                   	pop    %ebx
  801f85:	5e                   	pop    %esi
  801f86:	5f                   	pop    %edi
  801f87:	5d                   	pop    %ebp
  801f88:	c3                   	ret    
  801f89:	8d 76 00             	lea    0x0(%esi),%esi
  801f8c:	31 ff                	xor    %edi,%edi
  801f8e:	31 c0                	xor    %eax,%eax
  801f90:	89 fa                	mov    %edi,%edx
  801f92:	83 c4 1c             	add    $0x1c,%esp
  801f95:	5b                   	pop    %ebx
  801f96:	5e                   	pop    %esi
  801f97:	5f                   	pop    %edi
  801f98:	5d                   	pop    %ebp
  801f99:	c3                   	ret    
  801f9a:	66 90                	xchg   %ax,%ax
  801f9c:	89 d8                	mov    %ebx,%eax
  801f9e:	f7 f7                	div    %edi
  801fa0:	31 ff                	xor    %edi,%edi
  801fa2:	89 fa                	mov    %edi,%edx
  801fa4:	83 c4 1c             	add    $0x1c,%esp
  801fa7:	5b                   	pop    %ebx
  801fa8:	5e                   	pop    %esi
  801fa9:	5f                   	pop    %edi
  801faa:	5d                   	pop    %ebp
  801fab:	c3                   	ret    
  801fac:	bd 20 00 00 00       	mov    $0x20,%ebp
  801fb1:	89 eb                	mov    %ebp,%ebx
  801fb3:	29 fb                	sub    %edi,%ebx
  801fb5:	89 f9                	mov    %edi,%ecx
  801fb7:	d3 e6                	shl    %cl,%esi
  801fb9:	89 c5                	mov    %eax,%ebp
  801fbb:	88 d9                	mov    %bl,%cl
  801fbd:	d3 ed                	shr    %cl,%ebp
  801fbf:	89 e9                	mov    %ebp,%ecx
  801fc1:	09 f1                	or     %esi,%ecx
  801fc3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801fc7:	89 f9                	mov    %edi,%ecx
  801fc9:	d3 e0                	shl    %cl,%eax
  801fcb:	89 c5                	mov    %eax,%ebp
  801fcd:	89 d6                	mov    %edx,%esi
  801fcf:	88 d9                	mov    %bl,%cl
  801fd1:	d3 ee                	shr    %cl,%esi
  801fd3:	89 f9                	mov    %edi,%ecx
  801fd5:	d3 e2                	shl    %cl,%edx
  801fd7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fdb:	88 d9                	mov    %bl,%cl
  801fdd:	d3 e8                	shr    %cl,%eax
  801fdf:	09 c2                	or     %eax,%edx
  801fe1:	89 d0                	mov    %edx,%eax
  801fe3:	89 f2                	mov    %esi,%edx
  801fe5:	f7 74 24 0c          	divl   0xc(%esp)
  801fe9:	89 d6                	mov    %edx,%esi
  801feb:	89 c3                	mov    %eax,%ebx
  801fed:	f7 e5                	mul    %ebp
  801fef:	39 d6                	cmp    %edx,%esi
  801ff1:	72 19                	jb     80200c <__udivdi3+0xfc>
  801ff3:	74 0b                	je     802000 <__udivdi3+0xf0>
  801ff5:	89 d8                	mov    %ebx,%eax
  801ff7:	31 ff                	xor    %edi,%edi
  801ff9:	e9 58 ff ff ff       	jmp    801f56 <__udivdi3+0x46>
  801ffe:	66 90                	xchg   %ax,%ax
  802000:	8b 54 24 08          	mov    0x8(%esp),%edx
  802004:	89 f9                	mov    %edi,%ecx
  802006:	d3 e2                	shl    %cl,%edx
  802008:	39 c2                	cmp    %eax,%edx
  80200a:	73 e9                	jae    801ff5 <__udivdi3+0xe5>
  80200c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80200f:	31 ff                	xor    %edi,%edi
  802011:	e9 40 ff ff ff       	jmp    801f56 <__udivdi3+0x46>
  802016:	66 90                	xchg   %ax,%ax
  802018:	31 c0                	xor    %eax,%eax
  80201a:	e9 37 ff ff ff       	jmp    801f56 <__udivdi3+0x46>
  80201f:	90                   	nop

00802020 <__umoddi3>:
  802020:	55                   	push   %ebp
  802021:	57                   	push   %edi
  802022:	56                   	push   %esi
  802023:	53                   	push   %ebx
  802024:	83 ec 1c             	sub    $0x1c,%esp
  802027:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80202b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80202f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802033:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802037:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80203b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80203f:	89 f3                	mov    %esi,%ebx
  802041:	89 fa                	mov    %edi,%edx
  802043:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802047:	89 34 24             	mov    %esi,(%esp)
  80204a:	85 c0                	test   %eax,%eax
  80204c:	75 1a                	jne    802068 <__umoddi3+0x48>
  80204e:	39 f7                	cmp    %esi,%edi
  802050:	0f 86 a2 00 00 00    	jbe    8020f8 <__umoddi3+0xd8>
  802056:	89 c8                	mov    %ecx,%eax
  802058:	89 f2                	mov    %esi,%edx
  80205a:	f7 f7                	div    %edi
  80205c:	89 d0                	mov    %edx,%eax
  80205e:	31 d2                	xor    %edx,%edx
  802060:	83 c4 1c             	add    $0x1c,%esp
  802063:	5b                   	pop    %ebx
  802064:	5e                   	pop    %esi
  802065:	5f                   	pop    %edi
  802066:	5d                   	pop    %ebp
  802067:	c3                   	ret    
  802068:	39 f0                	cmp    %esi,%eax
  80206a:	0f 87 ac 00 00 00    	ja     80211c <__umoddi3+0xfc>
  802070:	0f bd e8             	bsr    %eax,%ebp
  802073:	83 f5 1f             	xor    $0x1f,%ebp
  802076:	0f 84 ac 00 00 00    	je     802128 <__umoddi3+0x108>
  80207c:	bf 20 00 00 00       	mov    $0x20,%edi
  802081:	29 ef                	sub    %ebp,%edi
  802083:	89 fe                	mov    %edi,%esi
  802085:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802089:	89 e9                	mov    %ebp,%ecx
  80208b:	d3 e0                	shl    %cl,%eax
  80208d:	89 d7                	mov    %edx,%edi
  80208f:	89 f1                	mov    %esi,%ecx
  802091:	d3 ef                	shr    %cl,%edi
  802093:	09 c7                	or     %eax,%edi
  802095:	89 e9                	mov    %ebp,%ecx
  802097:	d3 e2                	shl    %cl,%edx
  802099:	89 14 24             	mov    %edx,(%esp)
  80209c:	89 d8                	mov    %ebx,%eax
  80209e:	d3 e0                	shl    %cl,%eax
  8020a0:	89 c2                	mov    %eax,%edx
  8020a2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020a6:	d3 e0                	shl    %cl,%eax
  8020a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ac:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020b0:	89 f1                	mov    %esi,%ecx
  8020b2:	d3 e8                	shr    %cl,%eax
  8020b4:	09 d0                	or     %edx,%eax
  8020b6:	d3 eb                	shr    %cl,%ebx
  8020b8:	89 da                	mov    %ebx,%edx
  8020ba:	f7 f7                	div    %edi
  8020bc:	89 d3                	mov    %edx,%ebx
  8020be:	f7 24 24             	mull   (%esp)
  8020c1:	89 c6                	mov    %eax,%esi
  8020c3:	89 d1                	mov    %edx,%ecx
  8020c5:	39 d3                	cmp    %edx,%ebx
  8020c7:	0f 82 87 00 00 00    	jb     802154 <__umoddi3+0x134>
  8020cd:	0f 84 91 00 00 00    	je     802164 <__umoddi3+0x144>
  8020d3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8020d7:	29 f2                	sub    %esi,%edx
  8020d9:	19 cb                	sbb    %ecx,%ebx
  8020db:	89 d8                	mov    %ebx,%eax
  8020dd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8020e1:	d3 e0                	shl    %cl,%eax
  8020e3:	89 e9                	mov    %ebp,%ecx
  8020e5:	d3 ea                	shr    %cl,%edx
  8020e7:	09 d0                	or     %edx,%eax
  8020e9:	89 e9                	mov    %ebp,%ecx
  8020eb:	d3 eb                	shr    %cl,%ebx
  8020ed:	89 da                	mov    %ebx,%edx
  8020ef:	83 c4 1c             	add    $0x1c,%esp
  8020f2:	5b                   	pop    %ebx
  8020f3:	5e                   	pop    %esi
  8020f4:	5f                   	pop    %edi
  8020f5:	5d                   	pop    %ebp
  8020f6:	c3                   	ret    
  8020f7:	90                   	nop
  8020f8:	89 fd                	mov    %edi,%ebp
  8020fa:	85 ff                	test   %edi,%edi
  8020fc:	75 0b                	jne    802109 <__umoddi3+0xe9>
  8020fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802103:	31 d2                	xor    %edx,%edx
  802105:	f7 f7                	div    %edi
  802107:	89 c5                	mov    %eax,%ebp
  802109:	89 f0                	mov    %esi,%eax
  80210b:	31 d2                	xor    %edx,%edx
  80210d:	f7 f5                	div    %ebp
  80210f:	89 c8                	mov    %ecx,%eax
  802111:	f7 f5                	div    %ebp
  802113:	89 d0                	mov    %edx,%eax
  802115:	e9 44 ff ff ff       	jmp    80205e <__umoddi3+0x3e>
  80211a:	66 90                	xchg   %ax,%ax
  80211c:	89 c8                	mov    %ecx,%eax
  80211e:	89 f2                	mov    %esi,%edx
  802120:	83 c4 1c             	add    $0x1c,%esp
  802123:	5b                   	pop    %ebx
  802124:	5e                   	pop    %esi
  802125:	5f                   	pop    %edi
  802126:	5d                   	pop    %ebp
  802127:	c3                   	ret    
  802128:	3b 04 24             	cmp    (%esp),%eax
  80212b:	72 06                	jb     802133 <__umoddi3+0x113>
  80212d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802131:	77 0f                	ja     802142 <__umoddi3+0x122>
  802133:	89 f2                	mov    %esi,%edx
  802135:	29 f9                	sub    %edi,%ecx
  802137:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80213b:	89 14 24             	mov    %edx,(%esp)
  80213e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802142:	8b 44 24 04          	mov    0x4(%esp),%eax
  802146:	8b 14 24             	mov    (%esp),%edx
  802149:	83 c4 1c             	add    $0x1c,%esp
  80214c:	5b                   	pop    %ebx
  80214d:	5e                   	pop    %esi
  80214e:	5f                   	pop    %edi
  80214f:	5d                   	pop    %ebp
  802150:	c3                   	ret    
  802151:	8d 76 00             	lea    0x0(%esi),%esi
  802154:	2b 04 24             	sub    (%esp),%eax
  802157:	19 fa                	sbb    %edi,%edx
  802159:	89 d1                	mov    %edx,%ecx
  80215b:	89 c6                	mov    %eax,%esi
  80215d:	e9 71 ff ff ff       	jmp    8020d3 <__umoddi3+0xb3>
  802162:	66 90                	xchg   %ax,%ax
  802164:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802168:	72 ea                	jb     802154 <__umoddi3+0x134>
  80216a:	89 d9                	mov    %ebx,%ecx
  80216c:	e9 62 ff ff ff       	jmp    8020d3 <__umoddi3+0xb3>
