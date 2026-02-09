
obj/user/tst_ksemaphore_1master:     file format elf32-i386


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
  800031:	e8 f7 02 00 00       	call   80032d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the semaphores, run slaves and wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec ec 01 00 00    	sub    $0x1ec,%esp
	int envID = sys_getenvid();
  800044:	e8 36 19 00 00       	call   80197f <sys_getenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int semVal ;
	//Initialize the kernel semaphores
	char initCmd1[64] = "__KSem@0@Init";
  80004c:	8d 45 94             	lea    -0x6c(%ebp),%eax
  80004f:	bb 9e 1f 80 00       	mov    $0x801f9e,%ebx
  800054:	ba 0e 00 00 00       	mov    $0xe,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800061:	8d 55 a2             	lea    -0x5e(%ebp),%edx
  800064:	b9 32 00 00 00       	mov    $0x32,%ecx
  800069:	b0 00                	mov    $0x0,%al
  80006b:	89 d7                	mov    %edx,%edi
  80006d:	f3 aa                	rep stos %al,%es:(%edi)
	char initCmd2[64] = "__KSem@1@Init";
  80006f:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800075:	bb de 1f 80 00       	mov    $0x801fde,%ebx
  80007a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80007f:	89 c7                	mov    %eax,%edi
  800081:	89 de                	mov    %ebx,%esi
  800083:	89 d1                	mov    %edx,%ecx
  800085:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800087:	8d 95 62 ff ff ff    	lea    -0x9e(%ebp),%edx
  80008d:	b9 32 00 00 00       	mov    $0x32,%ecx
  800092:	b0 00                	mov    $0x0,%al
  800094:	89 d7                	mov    %edx,%edi
  800096:	f3 aa                	rep stos %al,%es:(%edi)
	semVal = 1;
  800098:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
	sys_utilities(initCmd1, (uint32)(&semVal));
  80009f:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	50                   	push   %eax
  8000a6:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000a9:	50                   	push   %eax
  8000aa:	e8 1f 1b 00 00       	call   801bce <sys_utilities>
  8000af:	83 c4 10             	add    $0x10,%esp
	semVal = 0;
  8000b2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	sys_utilities(initCmd2, (uint32)(&semVal));
  8000b9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  8000bc:	83 ec 08             	sub    $0x8,%esp
  8000bf:	50                   	push   %eax
  8000c0:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  8000c6:	50                   	push   %eax
  8000c7:	e8 02 1b 00 00       	call   801bce <sys_utilities>
  8000cc:	83 c4 10             	add    $0x10,%esp

	//Run Slave Processes
	int id1, id2, id3;
	id1 = sys_create_env("ksem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000cf:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d4:	8b 90 70 06 00 00    	mov    0x670(%eax),%edx
  8000da:	a1 20 30 80 00       	mov    0x803020,%eax
  8000df:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  8000e5:	89 c1                	mov    %eax,%ecx
  8000e7:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ec:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000f2:	52                   	push   %edx
  8000f3:	51                   	push   %ecx
  8000f4:	50                   	push   %eax
  8000f5:	68 c0 1e 80 00       	push   $0x801ec0
  8000fa:	e8 2b 18 00 00       	call   80192a <sys_create_env>
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	89 45 e0             	mov    %eax,-0x20(%ebp)
	id2 = sys_create_env("ksem1Slave", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800105:	a1 20 30 80 00       	mov    0x803020,%eax
  80010a:	8b 90 70 06 00 00    	mov    0x670(%eax),%edx
  800110:	a1 20 30 80 00       	mov    0x803020,%eax
  800115:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  80011b:	89 c1                	mov    %eax,%ecx
  80011d:	a1 20 30 80 00       	mov    0x803020,%eax
  800122:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800128:	52                   	push   %edx
  800129:	51                   	push   %ecx
  80012a:	50                   	push   %eax
  80012b:	68 c0 1e 80 00       	push   $0x801ec0
  800130:	e8 f5 17 00 00       	call   80192a <sys_create_env>
  800135:	83 c4 10             	add    $0x10,%esp
  800138:	89 45 dc             	mov    %eax,-0x24(%ebp)
	id3 = sys_create_env("ksem1Slave", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80013b:	a1 20 30 80 00       	mov    0x803020,%eax
  800140:	8b 90 70 06 00 00    	mov    0x670(%eax),%edx
  800146:	a1 20 30 80 00       	mov    0x803020,%eax
  80014b:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  800151:	89 c1                	mov    %eax,%ecx
  800153:	a1 20 30 80 00       	mov    0x803020,%eax
  800158:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80015e:	52                   	push   %edx
  80015f:	51                   	push   %ecx
  800160:	50                   	push   %eax
  800161:	68 c0 1e 80 00       	push   $0x801ec0
  800166:	e8 bf 17 00 00       	call   80192a <sys_create_env>
  80016b:	83 c4 10             	add    $0x10,%esp
  80016e:	89 45 d8             	mov    %eax,-0x28(%ebp)

	sys_run_env(id1);
  800171:	83 ec 0c             	sub    $0xc,%esp
  800174:	ff 75 e0             	pushl  -0x20(%ebp)
  800177:	e8 cc 17 00 00       	call   801948 <sys_run_env>
  80017c:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80017f:	83 ec 0c             	sub    $0xc,%esp
  800182:	ff 75 dc             	pushl  -0x24(%ebp)
  800185:	e8 be 17 00 00       	call   801948 <sys_run_env>
  80018a:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80018d:	83 ec 0c             	sub    $0xc,%esp
  800190:	ff 75 d8             	pushl  -0x28(%ebp)
  800193:	e8 b0 17 00 00       	call   801948 <sys_run_env>
  800198:	83 c4 10             	add    $0x10,%esp

	//Wait until all finished
	char waitCmd1[64] = "__KSem@1@Wait";
  80019b:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  8001a1:	bb 1e 20 80 00       	mov    $0x80201e,%ebx
  8001a6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001ab:	89 c7                	mov    %eax,%edi
  8001ad:	89 de                	mov    %ebx,%esi
  8001af:	89 d1                	mov    %edx,%ecx
  8001b1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001b3:	8d 95 22 ff ff ff    	lea    -0xde(%ebp),%edx
  8001b9:	b9 32 00 00 00       	mov    $0x32,%ecx
  8001be:	b0 00                	mov    $0x0,%al
  8001c0:	89 d7                	mov    %edx,%edi
  8001c2:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd1, 0);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	6a 00                	push   $0x0
  8001c9:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  8001cf:	50                   	push   %eax
  8001d0:	e8 f9 19 00 00       	call   801bce <sys_utilities>
  8001d5:	83 c4 10             	add    $0x10,%esp
	//cprintf("after 1st wait\n");
	char waitCmd2[64] = "__KSem@1@Wait";
  8001d8:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  8001de:	bb 1e 20 80 00       	mov    $0x80201e,%ebx
  8001e3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001e8:	89 c7                	mov    %eax,%edi
  8001ea:	89 de                	mov    %ebx,%esi
  8001ec:	89 d1                	mov    %edx,%ecx
  8001ee:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001f0:	8d 95 e2 fe ff ff    	lea    -0x11e(%ebp),%edx
  8001f6:	b9 32 00 00 00       	mov    $0x32,%ecx
  8001fb:	b0 00                	mov    $0x0,%al
  8001fd:	89 d7                	mov    %edx,%edi
  8001ff:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd2, 0);
  800201:	83 ec 08             	sub    $0x8,%esp
  800204:	6a 00                	push   $0x0
  800206:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  80020c:	50                   	push   %eax
  80020d:	e8 bc 19 00 00       	call   801bce <sys_utilities>
  800212:	83 c4 10             	add    $0x10,%esp
	//cprintf("after 2nd wait\n");
	char waitCmd3[64] = "__KSem@1@Wait";
  800215:	8d 85 94 fe ff ff    	lea    -0x16c(%ebp),%eax
  80021b:	bb 1e 20 80 00       	mov    $0x80201e,%ebx
  800220:	ba 0e 00 00 00       	mov    $0xe,%edx
  800225:	89 c7                	mov    %eax,%edi
  800227:	89 de                	mov    %ebx,%esi
  800229:	89 d1                	mov    %edx,%ecx
  80022b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80022d:	8d 95 a2 fe ff ff    	lea    -0x15e(%ebp),%edx
  800233:	b9 32 00 00 00       	mov    $0x32,%ecx
  800238:	b0 00                	mov    $0x0,%al
  80023a:	89 d7                	mov    %edx,%edi
  80023c:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd3, 0);
  80023e:	83 ec 08             	sub    $0x8,%esp
  800241:	6a 00                	push   $0x0
  800243:	8d 85 94 fe ff ff    	lea    -0x16c(%ebp),%eax
  800249:	50                   	push   %eax
  80024a:	e8 7f 19 00 00       	call   801bce <sys_utilities>
  80024f:	83 c4 10             	add    $0x10,%esp
	//cprintf("after 3rd wait\n");

	//Check Sem Values
	int sem1val ;
	int sem2val ;
	char getCmd1[64] = "__KSem@0@Get";
  800252:	8d 85 4c fe ff ff    	lea    -0x1b4(%ebp),%eax
  800258:	bb 5e 20 80 00       	mov    $0x80205e,%ebx
  80025d:	ba 0d 00 00 00       	mov    $0xd,%edx
  800262:	89 c7                	mov    %eax,%edi
  800264:	89 de                	mov    %ebx,%esi
  800266:	89 d1                	mov    %edx,%ecx
  800268:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80026a:	8d 95 59 fe ff ff    	lea    -0x1a7(%ebp),%edx
  800270:	b9 33 00 00 00       	mov    $0x33,%ecx
  800275:	b0 00                	mov    $0x0,%al
  800277:	89 d7                	mov    %edx,%edi
  800279:	f3 aa                	rep stos %al,%es:(%edi)
	char getCmd2[64] = "__KSem@1@Get";
  80027b:	8d 85 0c fe ff ff    	lea    -0x1f4(%ebp),%eax
  800281:	bb 9e 20 80 00       	mov    $0x80209e,%ebx
  800286:	ba 0d 00 00 00       	mov    $0xd,%edx
  80028b:	89 c7                	mov    %eax,%edi
  80028d:	89 de                	mov    %ebx,%esi
  80028f:	89 d1                	mov    %edx,%ecx
  800291:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800293:	8d 95 19 fe ff ff    	lea    -0x1e7(%ebp),%edx
  800299:	b9 33 00 00 00       	mov    $0x33,%ecx
  80029e:	b0 00                	mov    $0x0,%al
  8002a0:	89 d7                	mov    %edx,%edi
  8002a2:	f3 aa                	rep stos %al,%es:(%edi)

	sys_utilities(getCmd1, (uint32)(&sem1val));
  8002a4:	8d 85 90 fe ff ff    	lea    -0x170(%ebp),%eax
  8002aa:	83 ec 08             	sub    $0x8,%esp
  8002ad:	50                   	push   %eax
  8002ae:	8d 85 4c fe ff ff    	lea    -0x1b4(%ebp),%eax
  8002b4:	50                   	push   %eax
  8002b5:	e8 14 19 00 00       	call   801bce <sys_utilities>
  8002ba:	83 c4 10             	add    $0x10,%esp
	sys_utilities(getCmd2, (uint32)(&sem2val));
  8002bd:	8d 85 8c fe ff ff    	lea    -0x174(%ebp),%eax
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	50                   	push   %eax
  8002c7:	8d 85 0c fe ff ff    	lea    -0x1f4(%ebp),%eax
  8002cd:	50                   	push   %eax
  8002ce:	e8 fb 18 00 00       	call   801bce <sys_utilities>
  8002d3:	83 c4 10             	add    $0x10,%esp

	if (sem2val == 0 && sem1val == 1)
  8002d6:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  8002dc:	85 c0                	test   %eax,%eax
  8002de:	75 1f                	jne    8002ff <_main+0x2c7>
  8002e0:	8b 85 90 fe ff ff    	mov    -0x170(%ebp),%eax
  8002e6:	83 f8 01             	cmp    $0x1,%eax
  8002e9:	75 14                	jne    8002ff <_main+0x2c7>
		cprintf_colored(TEXT_light_green, "Congratulations!! Test of Semaphores [1] completed successfully!!\n\n\n");
  8002eb:	83 ec 08             	sub    $0x8,%esp
  8002ee:	68 cc 1e 80 00       	push   $0x801ecc
  8002f3:	6a 0a                	push   $0xa
  8002f5:	e8 fe 04 00 00       	call   8007f8 <cprintf_colored>
  8002fa:	83 c4 10             	add    $0x10,%esp
	else
		panic("Error: wrong semaphore value... please review your semaphore code again! Expected = %d, %d, Actual = %d, %d", 1, 0, sem1val, sem2val);

	return;
  8002fd:	eb 26                	jmp    800325 <_main+0x2ed>
	sys_utilities(getCmd2, (uint32)(&sem2val));

	if (sem2val == 0 && sem1val == 1)
		cprintf_colored(TEXT_light_green, "Congratulations!! Test of Semaphores [1] completed successfully!!\n\n\n");
	else
		panic("Error: wrong semaphore value... please review your semaphore code again! Expected = %d, %d, Actual = %d, %d", 1, 0, sem1val, sem2val);
  8002ff:	8b 95 8c fe ff ff    	mov    -0x174(%ebp),%edx
  800305:	8b 85 90 fe ff ff    	mov    -0x170(%ebp),%eax
  80030b:	83 ec 04             	sub    $0x4,%esp
  80030e:	52                   	push   %edx
  80030f:	50                   	push   %eax
  800310:	6a 00                	push   $0x0
  800312:	6a 01                	push   $0x1
  800314:	68 14 1f 80 00       	push   $0x801f14
  800319:	6a 33                	push   $0x33
  80031b:	68 80 1f 80 00       	push   $0x801f80
  800320:	e8 b8 01 00 00       	call   8004dd <_panic>

	return;
}
  800325:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800328:	5b                   	pop    %ebx
  800329:	5e                   	pop    %esi
  80032a:	5f                   	pop    %edi
  80032b:	5d                   	pop    %ebp
  80032c:	c3                   	ret    

0080032d <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80032d:	55                   	push   %ebp
  80032e:	89 e5                	mov    %esp,%ebp
  800330:	57                   	push   %edi
  800331:	56                   	push   %esi
  800332:	53                   	push   %ebx
  800333:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800336:	e8 5d 16 00 00       	call   801998 <sys_getenvindex>
  80033b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80033e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800341:	89 d0                	mov    %edx,%eax
  800343:	01 c0                	add    %eax,%eax
  800345:	01 d0                	add    %edx,%eax
  800347:	c1 e0 02             	shl    $0x2,%eax
  80034a:	01 d0                	add    %edx,%eax
  80034c:	c1 e0 02             	shl    $0x2,%eax
  80034f:	01 d0                	add    %edx,%eax
  800351:	c1 e0 03             	shl    $0x3,%eax
  800354:	01 d0                	add    %edx,%eax
  800356:	c1 e0 02             	shl    $0x2,%eax
  800359:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80035e:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800363:	a1 20 30 80 00       	mov    0x803020,%eax
  800368:	8a 40 20             	mov    0x20(%eax),%al
  80036b:	84 c0                	test   %al,%al
  80036d:	74 0d                	je     80037c <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80036f:	a1 20 30 80 00       	mov    0x803020,%eax
  800374:	83 c0 20             	add    $0x20,%eax
  800377:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80037c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800380:	7e 0a                	jle    80038c <libmain+0x5f>
		binaryname = argv[0];
  800382:	8b 45 0c             	mov    0xc(%ebp),%eax
  800385:	8b 00                	mov    (%eax),%eax
  800387:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80038c:	83 ec 08             	sub    $0x8,%esp
  80038f:	ff 75 0c             	pushl  0xc(%ebp)
  800392:	ff 75 08             	pushl  0x8(%ebp)
  800395:	e8 9e fc ff ff       	call   800038 <_main>
  80039a:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80039d:	a1 00 30 80 00       	mov    0x803000,%eax
  8003a2:	85 c0                	test   %eax,%eax
  8003a4:	0f 84 01 01 00 00    	je     8004ab <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8003aa:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003b0:	bb d8 21 80 00       	mov    $0x8021d8,%ebx
  8003b5:	ba 0e 00 00 00       	mov    $0xe,%edx
  8003ba:	89 c7                	mov    %eax,%edi
  8003bc:	89 de                	mov    %ebx,%esi
  8003be:	89 d1                	mov    %edx,%ecx
  8003c0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8003c2:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8003c5:	b9 56 00 00 00       	mov    $0x56,%ecx
  8003ca:	b0 00                	mov    $0x0,%al
  8003cc:	89 d7                	mov    %edx,%edi
  8003ce:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8003d0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8003d7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8003da:	83 ec 08             	sub    $0x8,%esp
  8003dd:	50                   	push   %eax
  8003de:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003e4:	50                   	push   %eax
  8003e5:	e8 e4 17 00 00       	call   801bce <sys_utilities>
  8003ea:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003ed:	e8 2d 13 00 00       	call   80171f <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003f2:	83 ec 0c             	sub    $0xc,%esp
  8003f5:	68 f8 20 80 00       	push   $0x8020f8
  8003fa:	e8 cc 03 00 00       	call   8007cb <cprintf>
  8003ff:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800402:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800405:	85 c0                	test   %eax,%eax
  800407:	74 18                	je     800421 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800409:	e8 de 17 00 00       	call   801bec <sys_get_optimal_num_faults>
  80040e:	83 ec 08             	sub    $0x8,%esp
  800411:	50                   	push   %eax
  800412:	68 20 21 80 00       	push   $0x802120
  800417:	e8 af 03 00 00       	call   8007cb <cprintf>
  80041c:	83 c4 10             	add    $0x10,%esp
  80041f:	eb 59                	jmp    80047a <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800421:	a1 20 30 80 00       	mov    0x803020,%eax
  800426:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  80042c:	a1 20 30 80 00       	mov    0x803020,%eax
  800431:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800437:	83 ec 04             	sub    $0x4,%esp
  80043a:	52                   	push   %edx
  80043b:	50                   	push   %eax
  80043c:	68 44 21 80 00       	push   $0x802144
  800441:	e8 85 03 00 00       	call   8007cb <cprintf>
  800446:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800449:	a1 20 30 80 00       	mov    0x803020,%eax
  80044e:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800454:	a1 20 30 80 00       	mov    0x803020,%eax
  800459:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  80045f:	a1 20 30 80 00       	mov    0x803020,%eax
  800464:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  80046a:	51                   	push   %ecx
  80046b:	52                   	push   %edx
  80046c:	50                   	push   %eax
  80046d:	68 6c 21 80 00       	push   $0x80216c
  800472:	e8 54 03 00 00       	call   8007cb <cprintf>
  800477:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80047a:	a1 20 30 80 00       	mov    0x803020,%eax
  80047f:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800485:	83 ec 08             	sub    $0x8,%esp
  800488:	50                   	push   %eax
  800489:	68 c4 21 80 00       	push   $0x8021c4
  80048e:	e8 38 03 00 00       	call   8007cb <cprintf>
  800493:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800496:	83 ec 0c             	sub    $0xc,%esp
  800499:	68 f8 20 80 00       	push   $0x8020f8
  80049e:	e8 28 03 00 00       	call   8007cb <cprintf>
  8004a3:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8004a6:	e8 8e 12 00 00       	call   801739 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8004ab:	e8 1f 00 00 00       	call   8004cf <exit>
}
  8004b0:	90                   	nop
  8004b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004b4:	5b                   	pop    %ebx
  8004b5:	5e                   	pop    %esi
  8004b6:	5f                   	pop    %edi
  8004b7:	5d                   	pop    %ebp
  8004b8:	c3                   	ret    

008004b9 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004b9:	55                   	push   %ebp
  8004ba:	89 e5                	mov    %esp,%ebp
  8004bc:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004bf:	83 ec 0c             	sub    $0xc,%esp
  8004c2:	6a 00                	push   $0x0
  8004c4:	e8 9b 14 00 00       	call   801964 <sys_destroy_env>
  8004c9:	83 c4 10             	add    $0x10,%esp
}
  8004cc:	90                   	nop
  8004cd:	c9                   	leave  
  8004ce:	c3                   	ret    

008004cf <exit>:

void
exit(void)
{
  8004cf:	55                   	push   %ebp
  8004d0:	89 e5                	mov    %esp,%ebp
  8004d2:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004d5:	e8 f0 14 00 00       	call   8019ca <sys_exit_env>
}
  8004da:	90                   	nop
  8004db:	c9                   	leave  
  8004dc:	c3                   	ret    

008004dd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004dd:	55                   	push   %ebp
  8004de:	89 e5                	mov    %esp,%ebp
  8004e0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004e3:	8d 45 10             	lea    0x10(%ebp),%eax
  8004e6:	83 c0 04             	add    $0x4,%eax
  8004e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004ec:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8004f1:	85 c0                	test   %eax,%eax
  8004f3:	74 16                	je     80050b <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004f5:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8004fa:	83 ec 08             	sub    $0x8,%esp
  8004fd:	50                   	push   %eax
  8004fe:	68 3c 22 80 00       	push   $0x80223c
  800503:	e8 c3 02 00 00       	call   8007cb <cprintf>
  800508:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80050b:	a1 04 30 80 00       	mov    0x803004,%eax
  800510:	83 ec 0c             	sub    $0xc,%esp
  800513:	ff 75 0c             	pushl  0xc(%ebp)
  800516:	ff 75 08             	pushl  0x8(%ebp)
  800519:	50                   	push   %eax
  80051a:	68 44 22 80 00       	push   $0x802244
  80051f:	6a 74                	push   $0x74
  800521:	e8 d2 02 00 00       	call   8007f8 <cprintf_colored>
  800526:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800529:	8b 45 10             	mov    0x10(%ebp),%eax
  80052c:	83 ec 08             	sub    $0x8,%esp
  80052f:	ff 75 f4             	pushl  -0xc(%ebp)
  800532:	50                   	push   %eax
  800533:	e8 24 02 00 00       	call   80075c <vcprintf>
  800538:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	6a 00                	push   $0x0
  800540:	68 6c 22 80 00       	push   $0x80226c
  800545:	e8 12 02 00 00       	call   80075c <vcprintf>
  80054a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80054d:	e8 7d ff ff ff       	call   8004cf <exit>

	// should not return here
	while (1) ;
  800552:	eb fe                	jmp    800552 <_panic+0x75>

00800554 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800554:	55                   	push   %ebp
  800555:	89 e5                	mov    %esp,%ebp
  800557:	53                   	push   %ebx
  800558:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80055b:	a1 20 30 80 00       	mov    0x803020,%eax
  800560:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800566:	8b 45 0c             	mov    0xc(%ebp),%eax
  800569:	39 c2                	cmp    %eax,%edx
  80056b:	74 14                	je     800581 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80056d:	83 ec 04             	sub    $0x4,%esp
  800570:	68 70 22 80 00       	push   $0x802270
  800575:	6a 26                	push   $0x26
  800577:	68 bc 22 80 00       	push   $0x8022bc
  80057c:	e8 5c ff ff ff       	call   8004dd <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800581:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800588:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80058f:	e9 d9 00 00 00       	jmp    80066d <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800594:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800597:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059e:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a1:	01 d0                	add    %edx,%eax
  8005a3:	8b 00                	mov    (%eax),%eax
  8005a5:	85 c0                	test   %eax,%eax
  8005a7:	75 08                	jne    8005b1 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8005a9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005ac:	e9 b9 00 00 00       	jmp    80066a <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8005b1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005b8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005bf:	eb 79                	jmp    80063a <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005c1:	a1 20 30 80 00       	mov    0x803020,%eax
  8005c6:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8005cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005cf:	89 d0                	mov    %edx,%eax
  8005d1:	01 c0                	add    %eax,%eax
  8005d3:	01 d0                	add    %edx,%eax
  8005d5:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8005dc:	01 d8                	add    %ebx,%eax
  8005de:	01 d0                	add    %edx,%eax
  8005e0:	01 c8                	add    %ecx,%eax
  8005e2:	8a 40 04             	mov    0x4(%eax),%al
  8005e5:	84 c0                	test   %al,%al
  8005e7:	75 4e                	jne    800637 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005e9:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ee:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8005f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005f7:	89 d0                	mov    %edx,%eax
  8005f9:	01 c0                	add    %eax,%eax
  8005fb:	01 d0                	add    %edx,%eax
  8005fd:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800604:	01 d8                	add    %ebx,%eax
  800606:	01 d0                	add    %edx,%eax
  800608:	01 c8                	add    %ecx,%eax
  80060a:	8b 00                	mov    (%eax),%eax
  80060c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80060f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800612:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800617:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800623:	8b 45 08             	mov    0x8(%ebp),%eax
  800626:	01 c8                	add    %ecx,%eax
  800628:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80062a:	39 c2                	cmp    %eax,%edx
  80062c:	75 09                	jne    800637 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  80062e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800635:	eb 19                	jmp    800650 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800637:	ff 45 e8             	incl   -0x18(%ebp)
  80063a:	a1 20 30 80 00       	mov    0x803020,%eax
  80063f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800645:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800648:	39 c2                	cmp    %eax,%edx
  80064a:	0f 87 71 ff ff ff    	ja     8005c1 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800650:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800654:	75 14                	jne    80066a <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800656:	83 ec 04             	sub    $0x4,%esp
  800659:	68 c8 22 80 00       	push   $0x8022c8
  80065e:	6a 3a                	push   $0x3a
  800660:	68 bc 22 80 00       	push   $0x8022bc
  800665:	e8 73 fe ff ff       	call   8004dd <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80066a:	ff 45 f0             	incl   -0x10(%ebp)
  80066d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800670:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800673:	0f 8c 1b ff ff ff    	jl     800594 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800679:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800680:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800687:	eb 2e                	jmp    8006b7 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800689:	a1 20 30 80 00       	mov    0x803020,%eax
  80068e:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800694:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800697:	89 d0                	mov    %edx,%eax
  800699:	01 c0                	add    %eax,%eax
  80069b:	01 d0                	add    %edx,%eax
  80069d:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8006a4:	01 d8                	add    %ebx,%eax
  8006a6:	01 d0                	add    %edx,%eax
  8006a8:	01 c8                	add    %ecx,%eax
  8006aa:	8a 40 04             	mov    0x4(%eax),%al
  8006ad:	3c 01                	cmp    $0x1,%al
  8006af:	75 03                	jne    8006b4 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  8006b1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006b4:	ff 45 e0             	incl   -0x20(%ebp)
  8006b7:	a1 20 30 80 00       	mov    0x803020,%eax
  8006bc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8006c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c5:	39 c2                	cmp    %eax,%edx
  8006c7:	77 c0                	ja     800689 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006cc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006cf:	74 14                	je     8006e5 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  8006d1:	83 ec 04             	sub    $0x4,%esp
  8006d4:	68 1c 23 80 00       	push   $0x80231c
  8006d9:	6a 44                	push   $0x44
  8006db:	68 bc 22 80 00       	push   $0x8022bc
  8006e0:	e8 f8 fd ff ff       	call   8004dd <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006e5:	90                   	nop
  8006e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006e9:	c9                   	leave  
  8006ea:	c3                   	ret    

008006eb <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8006eb:	55                   	push   %ebp
  8006ec:	89 e5                	mov    %esp,%ebp
  8006ee:	53                   	push   %ebx
  8006ef:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8006f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	8d 48 01             	lea    0x1(%eax),%ecx
  8006fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006fd:	89 0a                	mov    %ecx,(%edx)
  8006ff:	8b 55 08             	mov    0x8(%ebp),%edx
  800702:	88 d1                	mov    %dl,%cl
  800704:	8b 55 0c             	mov    0xc(%ebp),%edx
  800707:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80070b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80070e:	8b 00                	mov    (%eax),%eax
  800710:	3d ff 00 00 00       	cmp    $0xff,%eax
  800715:	75 30                	jne    800747 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800717:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80071d:	a0 44 30 80 00       	mov    0x803044,%al
  800722:	0f b6 c0             	movzbl %al,%eax
  800725:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800728:	8b 09                	mov    (%ecx),%ecx
  80072a:	89 cb                	mov    %ecx,%ebx
  80072c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80072f:	83 c1 08             	add    $0x8,%ecx
  800732:	52                   	push   %edx
  800733:	50                   	push   %eax
  800734:	53                   	push   %ebx
  800735:	51                   	push   %ecx
  800736:	e8 a0 0f 00 00       	call   8016db <sys_cputs>
  80073b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80073e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800741:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800747:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074a:	8b 40 04             	mov    0x4(%eax),%eax
  80074d:	8d 50 01             	lea    0x1(%eax),%edx
  800750:	8b 45 0c             	mov    0xc(%ebp),%eax
  800753:	89 50 04             	mov    %edx,0x4(%eax)
}
  800756:	90                   	nop
  800757:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80075a:	c9                   	leave  
  80075b:	c3                   	ret    

0080075c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800765:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80076c:	00 00 00 
	b.cnt = 0;
  80076f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800776:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800779:	ff 75 0c             	pushl  0xc(%ebp)
  80077c:	ff 75 08             	pushl  0x8(%ebp)
  80077f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800785:	50                   	push   %eax
  800786:	68 eb 06 80 00       	push   $0x8006eb
  80078b:	e8 5a 02 00 00       	call   8009ea <vprintfmt>
  800790:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800793:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800799:	a0 44 30 80 00       	mov    0x803044,%al
  80079e:	0f b6 c0             	movzbl %al,%eax
  8007a1:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8007a7:	52                   	push   %edx
  8007a8:	50                   	push   %eax
  8007a9:	51                   	push   %ecx
  8007aa:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007b0:	83 c0 08             	add    $0x8,%eax
  8007b3:	50                   	push   %eax
  8007b4:	e8 22 0f 00 00       	call   8016db <sys_cputs>
  8007b9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007bc:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8007c3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007c9:	c9                   	leave  
  8007ca:	c3                   	ret    

008007cb <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8007cb:	55                   	push   %ebp
  8007cc:	89 e5                	mov    %esp,%ebp
  8007ce:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007d1:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8007d8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e7:	50                   	push   %eax
  8007e8:	e8 6f ff ff ff       	call   80075c <vcprintf>
  8007ed:	83 c4 10             	add    $0x10,%esp
  8007f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007f6:	c9                   	leave  
  8007f7:	c3                   	ret    

008007f8 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007fe:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	c1 e0 08             	shl    $0x8,%eax
  80080b:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800810:	8d 45 0c             	lea    0xc(%ebp),%eax
  800813:	83 c0 04             	add    $0x4,%eax
  800816:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800819:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	ff 75 f4             	pushl  -0xc(%ebp)
  800822:	50                   	push   %eax
  800823:	e8 34 ff ff ff       	call   80075c <vcprintf>
  800828:	83 c4 10             	add    $0x10,%esp
  80082b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80082e:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800835:	07 00 00 

	return cnt;
  800838:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80083b:	c9                   	leave  
  80083c:	c3                   	ret    

0080083d <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80083d:	55                   	push   %ebp
  80083e:	89 e5                	mov    %esp,%ebp
  800840:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800843:	e8 d7 0e 00 00       	call   80171f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800848:	8d 45 0c             	lea    0xc(%ebp),%eax
  80084b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80084e:	8b 45 08             	mov    0x8(%ebp),%eax
  800851:	83 ec 08             	sub    $0x8,%esp
  800854:	ff 75 f4             	pushl  -0xc(%ebp)
  800857:	50                   	push   %eax
  800858:	e8 ff fe ff ff       	call   80075c <vcprintf>
  80085d:	83 c4 10             	add    $0x10,%esp
  800860:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800863:	e8 d1 0e 00 00       	call   801739 <sys_unlock_cons>
	return cnt;
  800868:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80086b:	c9                   	leave  
  80086c:	c3                   	ret    

0080086d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80086d:	55                   	push   %ebp
  80086e:	89 e5                	mov    %esp,%ebp
  800870:	53                   	push   %ebx
  800871:	83 ec 14             	sub    $0x14,%esp
  800874:	8b 45 10             	mov    0x10(%ebp),%eax
  800877:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80087a:	8b 45 14             	mov    0x14(%ebp),%eax
  80087d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800880:	8b 45 18             	mov    0x18(%ebp),%eax
  800883:	ba 00 00 00 00       	mov    $0x0,%edx
  800888:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80088b:	77 55                	ja     8008e2 <printnum+0x75>
  80088d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800890:	72 05                	jb     800897 <printnum+0x2a>
  800892:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800895:	77 4b                	ja     8008e2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800897:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80089a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80089d:	8b 45 18             	mov    0x18(%ebp),%eax
  8008a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a5:	52                   	push   %edx
  8008a6:	50                   	push   %eax
  8008a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8008aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8008ad:	e8 aa 13 00 00       	call   801c5c <__udivdi3>
  8008b2:	83 c4 10             	add    $0x10,%esp
  8008b5:	83 ec 04             	sub    $0x4,%esp
  8008b8:	ff 75 20             	pushl  0x20(%ebp)
  8008bb:	53                   	push   %ebx
  8008bc:	ff 75 18             	pushl  0x18(%ebp)
  8008bf:	52                   	push   %edx
  8008c0:	50                   	push   %eax
  8008c1:	ff 75 0c             	pushl  0xc(%ebp)
  8008c4:	ff 75 08             	pushl  0x8(%ebp)
  8008c7:	e8 a1 ff ff ff       	call   80086d <printnum>
  8008cc:	83 c4 20             	add    $0x20,%esp
  8008cf:	eb 1a                	jmp    8008eb <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008d1:	83 ec 08             	sub    $0x8,%esp
  8008d4:	ff 75 0c             	pushl  0xc(%ebp)
  8008d7:	ff 75 20             	pushl  0x20(%ebp)
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	ff d0                	call   *%eax
  8008df:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008e2:	ff 4d 1c             	decl   0x1c(%ebp)
  8008e5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008e9:	7f e6                	jg     8008d1 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008eb:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008f9:	53                   	push   %ebx
  8008fa:	51                   	push   %ecx
  8008fb:	52                   	push   %edx
  8008fc:	50                   	push   %eax
  8008fd:	e8 6a 14 00 00       	call   801d6c <__umoddi3>
  800902:	83 c4 10             	add    $0x10,%esp
  800905:	05 94 25 80 00       	add    $0x802594,%eax
  80090a:	8a 00                	mov    (%eax),%al
  80090c:	0f be c0             	movsbl %al,%eax
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	ff 75 0c             	pushl  0xc(%ebp)
  800915:	50                   	push   %eax
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	ff d0                	call   *%eax
  80091b:	83 c4 10             	add    $0x10,%esp
}
  80091e:	90                   	nop
  80091f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800922:	c9                   	leave  
  800923:	c3                   	ret    

00800924 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800927:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80092b:	7e 1c                	jle    800949 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	8b 00                	mov    (%eax),%eax
  800932:	8d 50 08             	lea    0x8(%eax),%edx
  800935:	8b 45 08             	mov    0x8(%ebp),%eax
  800938:	89 10                	mov    %edx,(%eax)
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	8b 00                	mov    (%eax),%eax
  80093f:	83 e8 08             	sub    $0x8,%eax
  800942:	8b 50 04             	mov    0x4(%eax),%edx
  800945:	8b 00                	mov    (%eax),%eax
  800947:	eb 40                	jmp    800989 <getuint+0x65>
	else if (lflag)
  800949:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80094d:	74 1e                	je     80096d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	8b 00                	mov    (%eax),%eax
  800954:	8d 50 04             	lea    0x4(%eax),%edx
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	89 10                	mov    %edx,(%eax)
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	8b 00                	mov    (%eax),%eax
  800961:	83 e8 04             	sub    $0x4,%eax
  800964:	8b 00                	mov    (%eax),%eax
  800966:	ba 00 00 00 00       	mov    $0x0,%edx
  80096b:	eb 1c                	jmp    800989 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	8b 00                	mov    (%eax),%eax
  800972:	8d 50 04             	lea    0x4(%eax),%edx
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	89 10                	mov    %edx,(%eax)
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	8b 00                	mov    (%eax),%eax
  80097f:	83 e8 04             	sub    $0x4,%eax
  800982:	8b 00                	mov    (%eax),%eax
  800984:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800989:	5d                   	pop    %ebp
  80098a:	c3                   	ret    

0080098b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80098b:	55                   	push   %ebp
  80098c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80098e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800992:	7e 1c                	jle    8009b0 <getint+0x25>
		return va_arg(*ap, long long);
  800994:	8b 45 08             	mov    0x8(%ebp),%eax
  800997:	8b 00                	mov    (%eax),%eax
  800999:	8d 50 08             	lea    0x8(%eax),%edx
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	89 10                	mov    %edx,(%eax)
  8009a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a4:	8b 00                	mov    (%eax),%eax
  8009a6:	83 e8 08             	sub    $0x8,%eax
  8009a9:	8b 50 04             	mov    0x4(%eax),%edx
  8009ac:	8b 00                	mov    (%eax),%eax
  8009ae:	eb 38                	jmp    8009e8 <getint+0x5d>
	else if (lflag)
  8009b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009b4:	74 1a                	je     8009d0 <getint+0x45>
		return va_arg(*ap, long);
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	8b 00                	mov    (%eax),%eax
  8009bb:	8d 50 04             	lea    0x4(%eax),%edx
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	89 10                	mov    %edx,(%eax)
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	8b 00                	mov    (%eax),%eax
  8009c8:	83 e8 04             	sub    $0x4,%eax
  8009cb:	8b 00                	mov    (%eax),%eax
  8009cd:	99                   	cltd   
  8009ce:	eb 18                	jmp    8009e8 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d3:	8b 00                	mov    (%eax),%eax
  8009d5:	8d 50 04             	lea    0x4(%eax),%edx
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	89 10                	mov    %edx,(%eax)
  8009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e0:	8b 00                	mov    (%eax),%eax
  8009e2:	83 e8 04             	sub    $0x4,%eax
  8009e5:	8b 00                	mov    (%eax),%eax
  8009e7:	99                   	cltd   
}
  8009e8:	5d                   	pop    %ebp
  8009e9:	c3                   	ret    

008009ea <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	56                   	push   %esi
  8009ee:	53                   	push   %ebx
  8009ef:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009f2:	eb 17                	jmp    800a0b <vprintfmt+0x21>
			if (ch == '\0')
  8009f4:	85 db                	test   %ebx,%ebx
  8009f6:	0f 84 c1 03 00 00    	je     800dbd <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009fc:	83 ec 08             	sub    $0x8,%esp
  8009ff:	ff 75 0c             	pushl  0xc(%ebp)
  800a02:	53                   	push   %ebx
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	ff d0                	call   *%eax
  800a08:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0e:	8d 50 01             	lea    0x1(%eax),%edx
  800a11:	89 55 10             	mov    %edx,0x10(%ebp)
  800a14:	8a 00                	mov    (%eax),%al
  800a16:	0f b6 d8             	movzbl %al,%ebx
  800a19:	83 fb 25             	cmp    $0x25,%ebx
  800a1c:	75 d6                	jne    8009f4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a1e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a22:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a29:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a30:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a37:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a41:	8d 50 01             	lea    0x1(%eax),%edx
  800a44:	89 55 10             	mov    %edx,0x10(%ebp)
  800a47:	8a 00                	mov    (%eax),%al
  800a49:	0f b6 d8             	movzbl %al,%ebx
  800a4c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a4f:	83 f8 5b             	cmp    $0x5b,%eax
  800a52:	0f 87 3d 03 00 00    	ja     800d95 <vprintfmt+0x3ab>
  800a58:	8b 04 85 b8 25 80 00 	mov    0x8025b8(,%eax,4),%eax
  800a5f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a61:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a65:	eb d7                	jmp    800a3e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a67:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a6b:	eb d1                	jmp    800a3e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a6d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a74:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a77:	89 d0                	mov    %edx,%eax
  800a79:	c1 e0 02             	shl    $0x2,%eax
  800a7c:	01 d0                	add    %edx,%eax
  800a7e:	01 c0                	add    %eax,%eax
  800a80:	01 d8                	add    %ebx,%eax
  800a82:	83 e8 30             	sub    $0x30,%eax
  800a85:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a88:	8b 45 10             	mov    0x10(%ebp),%eax
  800a8b:	8a 00                	mov    (%eax),%al
  800a8d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a90:	83 fb 2f             	cmp    $0x2f,%ebx
  800a93:	7e 3e                	jle    800ad3 <vprintfmt+0xe9>
  800a95:	83 fb 39             	cmp    $0x39,%ebx
  800a98:	7f 39                	jg     800ad3 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a9a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a9d:	eb d5                	jmp    800a74 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa2:	83 c0 04             	add    $0x4,%eax
  800aa5:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa8:	8b 45 14             	mov    0x14(%ebp),%eax
  800aab:	83 e8 04             	sub    $0x4,%eax
  800aae:	8b 00                	mov    (%eax),%eax
  800ab0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ab3:	eb 1f                	jmp    800ad4 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ab5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ab9:	79 83                	jns    800a3e <vprintfmt+0x54>
				width = 0;
  800abb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ac2:	e9 77 ff ff ff       	jmp    800a3e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ac7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ace:	e9 6b ff ff ff       	jmp    800a3e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ad3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ad4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad8:	0f 89 60 ff ff ff    	jns    800a3e <vprintfmt+0x54>
				width = precision, precision = -1;
  800ade:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ae1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ae4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800aeb:	e9 4e ff ff ff       	jmp    800a3e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800af0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800af3:	e9 46 ff ff ff       	jmp    800a3e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800af8:	8b 45 14             	mov    0x14(%ebp),%eax
  800afb:	83 c0 04             	add    $0x4,%eax
  800afe:	89 45 14             	mov    %eax,0x14(%ebp)
  800b01:	8b 45 14             	mov    0x14(%ebp),%eax
  800b04:	83 e8 04             	sub    $0x4,%eax
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	83 ec 08             	sub    $0x8,%esp
  800b0c:	ff 75 0c             	pushl  0xc(%ebp)
  800b0f:	50                   	push   %eax
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	ff d0                	call   *%eax
  800b15:	83 c4 10             	add    $0x10,%esp
			break;
  800b18:	e9 9b 02 00 00       	jmp    800db8 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b20:	83 c0 04             	add    $0x4,%eax
  800b23:	89 45 14             	mov    %eax,0x14(%ebp)
  800b26:	8b 45 14             	mov    0x14(%ebp),%eax
  800b29:	83 e8 04             	sub    $0x4,%eax
  800b2c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b2e:	85 db                	test   %ebx,%ebx
  800b30:	79 02                	jns    800b34 <vprintfmt+0x14a>
				err = -err;
  800b32:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b34:	83 fb 64             	cmp    $0x64,%ebx
  800b37:	7f 0b                	jg     800b44 <vprintfmt+0x15a>
  800b39:	8b 34 9d 00 24 80 00 	mov    0x802400(,%ebx,4),%esi
  800b40:	85 f6                	test   %esi,%esi
  800b42:	75 19                	jne    800b5d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b44:	53                   	push   %ebx
  800b45:	68 a5 25 80 00       	push   $0x8025a5
  800b4a:	ff 75 0c             	pushl  0xc(%ebp)
  800b4d:	ff 75 08             	pushl  0x8(%ebp)
  800b50:	e8 70 02 00 00       	call   800dc5 <printfmt>
  800b55:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b58:	e9 5b 02 00 00       	jmp    800db8 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b5d:	56                   	push   %esi
  800b5e:	68 ae 25 80 00       	push   $0x8025ae
  800b63:	ff 75 0c             	pushl  0xc(%ebp)
  800b66:	ff 75 08             	pushl  0x8(%ebp)
  800b69:	e8 57 02 00 00       	call   800dc5 <printfmt>
  800b6e:	83 c4 10             	add    $0x10,%esp
			break;
  800b71:	e9 42 02 00 00       	jmp    800db8 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b76:	8b 45 14             	mov    0x14(%ebp),%eax
  800b79:	83 c0 04             	add    $0x4,%eax
  800b7c:	89 45 14             	mov    %eax,0x14(%ebp)
  800b7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b82:	83 e8 04             	sub    $0x4,%eax
  800b85:	8b 30                	mov    (%eax),%esi
  800b87:	85 f6                	test   %esi,%esi
  800b89:	75 05                	jne    800b90 <vprintfmt+0x1a6>
				p = "(null)";
  800b8b:	be b1 25 80 00       	mov    $0x8025b1,%esi
			if (width > 0 && padc != '-')
  800b90:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b94:	7e 6d                	jle    800c03 <vprintfmt+0x219>
  800b96:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b9a:	74 67                	je     800c03 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b9f:	83 ec 08             	sub    $0x8,%esp
  800ba2:	50                   	push   %eax
  800ba3:	56                   	push   %esi
  800ba4:	e8 1e 03 00 00       	call   800ec7 <strnlen>
  800ba9:	83 c4 10             	add    $0x10,%esp
  800bac:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800baf:	eb 16                	jmp    800bc7 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800bb1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800bb5:	83 ec 08             	sub    $0x8,%esp
  800bb8:	ff 75 0c             	pushl  0xc(%ebp)
  800bbb:	50                   	push   %eax
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	ff d0                	call   *%eax
  800bc1:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bc4:	ff 4d e4             	decl   -0x1c(%ebp)
  800bc7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bcb:	7f e4                	jg     800bb1 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bcd:	eb 34                	jmp    800c03 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800bcf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bd3:	74 1c                	je     800bf1 <vprintfmt+0x207>
  800bd5:	83 fb 1f             	cmp    $0x1f,%ebx
  800bd8:	7e 05                	jle    800bdf <vprintfmt+0x1f5>
  800bda:	83 fb 7e             	cmp    $0x7e,%ebx
  800bdd:	7e 12                	jle    800bf1 <vprintfmt+0x207>
					putch('?', putdat);
  800bdf:	83 ec 08             	sub    $0x8,%esp
  800be2:	ff 75 0c             	pushl  0xc(%ebp)
  800be5:	6a 3f                	push   $0x3f
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	ff d0                	call   *%eax
  800bec:	83 c4 10             	add    $0x10,%esp
  800bef:	eb 0f                	jmp    800c00 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bf1:	83 ec 08             	sub    $0x8,%esp
  800bf4:	ff 75 0c             	pushl  0xc(%ebp)
  800bf7:	53                   	push   %ebx
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	ff d0                	call   *%eax
  800bfd:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c00:	ff 4d e4             	decl   -0x1c(%ebp)
  800c03:	89 f0                	mov    %esi,%eax
  800c05:	8d 70 01             	lea    0x1(%eax),%esi
  800c08:	8a 00                	mov    (%eax),%al
  800c0a:	0f be d8             	movsbl %al,%ebx
  800c0d:	85 db                	test   %ebx,%ebx
  800c0f:	74 24                	je     800c35 <vprintfmt+0x24b>
  800c11:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c15:	78 b8                	js     800bcf <vprintfmt+0x1e5>
  800c17:	ff 4d e0             	decl   -0x20(%ebp)
  800c1a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c1e:	79 af                	jns    800bcf <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c20:	eb 13                	jmp    800c35 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c22:	83 ec 08             	sub    $0x8,%esp
  800c25:	ff 75 0c             	pushl  0xc(%ebp)
  800c28:	6a 20                	push   $0x20
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	ff d0                	call   *%eax
  800c2f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c32:	ff 4d e4             	decl   -0x1c(%ebp)
  800c35:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c39:	7f e7                	jg     800c22 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c3b:	e9 78 01 00 00       	jmp    800db8 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c40:	83 ec 08             	sub    $0x8,%esp
  800c43:	ff 75 e8             	pushl  -0x18(%ebp)
  800c46:	8d 45 14             	lea    0x14(%ebp),%eax
  800c49:	50                   	push   %eax
  800c4a:	e8 3c fd ff ff       	call   80098b <getint>
  800c4f:	83 c4 10             	add    $0x10,%esp
  800c52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c55:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c5e:	85 d2                	test   %edx,%edx
  800c60:	79 23                	jns    800c85 <vprintfmt+0x29b>
				putch('-', putdat);
  800c62:	83 ec 08             	sub    $0x8,%esp
  800c65:	ff 75 0c             	pushl  0xc(%ebp)
  800c68:	6a 2d                	push   $0x2d
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	ff d0                	call   *%eax
  800c6f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c78:	f7 d8                	neg    %eax
  800c7a:	83 d2 00             	adc    $0x0,%edx
  800c7d:	f7 da                	neg    %edx
  800c7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c82:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c85:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c8c:	e9 bc 00 00 00       	jmp    800d4d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c91:	83 ec 08             	sub    $0x8,%esp
  800c94:	ff 75 e8             	pushl  -0x18(%ebp)
  800c97:	8d 45 14             	lea    0x14(%ebp),%eax
  800c9a:	50                   	push   %eax
  800c9b:	e8 84 fc ff ff       	call   800924 <getuint>
  800ca0:	83 c4 10             	add    $0x10,%esp
  800ca3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ca9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cb0:	e9 98 00 00 00       	jmp    800d4d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800cb5:	83 ec 08             	sub    $0x8,%esp
  800cb8:	ff 75 0c             	pushl  0xc(%ebp)
  800cbb:	6a 58                	push   $0x58
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	ff d0                	call   *%eax
  800cc2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cc5:	83 ec 08             	sub    $0x8,%esp
  800cc8:	ff 75 0c             	pushl  0xc(%ebp)
  800ccb:	6a 58                	push   $0x58
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	ff d0                	call   *%eax
  800cd2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cd5:	83 ec 08             	sub    $0x8,%esp
  800cd8:	ff 75 0c             	pushl  0xc(%ebp)
  800cdb:	6a 58                	push   $0x58
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	ff d0                	call   *%eax
  800ce2:	83 c4 10             	add    $0x10,%esp
			break;
  800ce5:	e9 ce 00 00 00       	jmp    800db8 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800cea:	83 ec 08             	sub    $0x8,%esp
  800ced:	ff 75 0c             	pushl  0xc(%ebp)
  800cf0:	6a 30                	push   $0x30
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	ff d0                	call   *%eax
  800cf7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cfa:	83 ec 08             	sub    $0x8,%esp
  800cfd:	ff 75 0c             	pushl  0xc(%ebp)
  800d00:	6a 78                	push   $0x78
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	ff d0                	call   *%eax
  800d07:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0d:	83 c0 04             	add    $0x4,%eax
  800d10:	89 45 14             	mov    %eax,0x14(%ebp)
  800d13:	8b 45 14             	mov    0x14(%ebp),%eax
  800d16:	83 e8 04             	sub    $0x4,%eax
  800d19:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d25:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d2c:	eb 1f                	jmp    800d4d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d2e:	83 ec 08             	sub    $0x8,%esp
  800d31:	ff 75 e8             	pushl  -0x18(%ebp)
  800d34:	8d 45 14             	lea    0x14(%ebp),%eax
  800d37:	50                   	push   %eax
  800d38:	e8 e7 fb ff ff       	call   800924 <getuint>
  800d3d:	83 c4 10             	add    $0x10,%esp
  800d40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d43:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d46:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d4d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d54:	83 ec 04             	sub    $0x4,%esp
  800d57:	52                   	push   %edx
  800d58:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d5b:	50                   	push   %eax
  800d5c:	ff 75 f4             	pushl  -0xc(%ebp)
  800d5f:	ff 75 f0             	pushl  -0x10(%ebp)
  800d62:	ff 75 0c             	pushl  0xc(%ebp)
  800d65:	ff 75 08             	pushl  0x8(%ebp)
  800d68:	e8 00 fb ff ff       	call   80086d <printnum>
  800d6d:	83 c4 20             	add    $0x20,%esp
			break;
  800d70:	eb 46                	jmp    800db8 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d72:	83 ec 08             	sub    $0x8,%esp
  800d75:	ff 75 0c             	pushl  0xc(%ebp)
  800d78:	53                   	push   %ebx
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	ff d0                	call   *%eax
  800d7e:	83 c4 10             	add    $0x10,%esp
			break;
  800d81:	eb 35                	jmp    800db8 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d83:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800d8a:	eb 2c                	jmp    800db8 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d8c:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800d93:	eb 23                	jmp    800db8 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d95:	83 ec 08             	sub    $0x8,%esp
  800d98:	ff 75 0c             	pushl  0xc(%ebp)
  800d9b:	6a 25                	push   $0x25
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	ff d0                	call   *%eax
  800da2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800da5:	ff 4d 10             	decl   0x10(%ebp)
  800da8:	eb 03                	jmp    800dad <vprintfmt+0x3c3>
  800daa:	ff 4d 10             	decl   0x10(%ebp)
  800dad:	8b 45 10             	mov    0x10(%ebp),%eax
  800db0:	48                   	dec    %eax
  800db1:	8a 00                	mov    (%eax),%al
  800db3:	3c 25                	cmp    $0x25,%al
  800db5:	75 f3                	jne    800daa <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800db7:	90                   	nop
		}
	}
  800db8:	e9 35 fc ff ff       	jmp    8009f2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800dbd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800dbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dc1:	5b                   	pop    %ebx
  800dc2:	5e                   	pop    %esi
  800dc3:	5d                   	pop    %ebp
  800dc4:	c3                   	ret    

00800dc5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800dcb:	8d 45 10             	lea    0x10(%ebp),%eax
  800dce:	83 c0 04             	add    $0x4,%eax
  800dd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800dd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800dda:	50                   	push   %eax
  800ddb:	ff 75 0c             	pushl  0xc(%ebp)
  800dde:	ff 75 08             	pushl  0x8(%ebp)
  800de1:	e8 04 fc ff ff       	call   8009ea <vprintfmt>
  800de6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800de9:	90                   	nop
  800dea:	c9                   	leave  
  800deb:	c3                   	ret    

00800dec <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800def:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df2:	8b 40 08             	mov    0x8(%eax),%eax
  800df5:	8d 50 01             	lea    0x1(%eax),%edx
  800df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e01:	8b 10                	mov    (%eax),%edx
  800e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e06:	8b 40 04             	mov    0x4(%eax),%eax
  800e09:	39 c2                	cmp    %eax,%edx
  800e0b:	73 12                	jae    800e1f <sprintputch+0x33>
		*b->buf++ = ch;
  800e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e10:	8b 00                	mov    (%eax),%eax
  800e12:	8d 48 01             	lea    0x1(%eax),%ecx
  800e15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e18:	89 0a                	mov    %ecx,(%edx)
  800e1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1d:	88 10                	mov    %dl,(%eax)
}
  800e1f:	90                   	nop
  800e20:	5d                   	pop    %ebp
  800e21:	c3                   	ret    

00800e22 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	01 d0                	add    %edx,%eax
  800e39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e47:	74 06                	je     800e4f <vsnprintf+0x2d>
  800e49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e4d:	7f 07                	jg     800e56 <vsnprintf+0x34>
		return -E_INVAL;
  800e4f:	b8 03 00 00 00       	mov    $0x3,%eax
  800e54:	eb 20                	jmp    800e76 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e56:	ff 75 14             	pushl  0x14(%ebp)
  800e59:	ff 75 10             	pushl  0x10(%ebp)
  800e5c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e5f:	50                   	push   %eax
  800e60:	68 ec 0d 80 00       	push   $0x800dec
  800e65:	e8 80 fb ff ff       	call   8009ea <vprintfmt>
  800e6a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e70:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e76:	c9                   	leave  
  800e77:	c3                   	ret    

00800e78 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e7e:	8d 45 10             	lea    0x10(%ebp),%eax
  800e81:	83 c0 04             	add    $0x4,%eax
  800e84:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e87:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8a:	ff 75 f4             	pushl  -0xc(%ebp)
  800e8d:	50                   	push   %eax
  800e8e:	ff 75 0c             	pushl  0xc(%ebp)
  800e91:	ff 75 08             	pushl  0x8(%ebp)
  800e94:	e8 89 ff ff ff       	call   800e22 <vsnprintf>
  800e99:	83 c4 10             	add    $0x10,%esp
  800e9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ea2:	c9                   	leave  
  800ea3:	c3                   	ret    

00800ea4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
  800ea7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800eaa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb1:	eb 06                	jmp    800eb9 <strlen+0x15>
		n++;
  800eb3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800eb6:	ff 45 08             	incl   0x8(%ebp)
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	8a 00                	mov    (%eax),%al
  800ebe:	84 c0                	test   %al,%al
  800ec0:	75 f1                	jne    800eb3 <strlen+0xf>
		n++;
	return n;
  800ec2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ec5:	c9                   	leave  
  800ec6:	c3                   	ret    

00800ec7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ecd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ed4:	eb 09                	jmp    800edf <strnlen+0x18>
		n++;
  800ed6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ed9:	ff 45 08             	incl   0x8(%ebp)
  800edc:	ff 4d 0c             	decl   0xc(%ebp)
  800edf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ee3:	74 09                	je     800eee <strnlen+0x27>
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	8a 00                	mov    (%eax),%al
  800eea:	84 c0                	test   %al,%al
  800eec:	75 e8                	jne    800ed6 <strnlen+0xf>
		n++;
	return n;
  800eee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ef1:	c9                   	leave  
  800ef2:	c3                   	ret    

00800ef3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800eff:	90                   	nop
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	8d 50 01             	lea    0x1(%eax),%edx
  800f06:	89 55 08             	mov    %edx,0x8(%ebp)
  800f09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f0c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f0f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f12:	8a 12                	mov    (%edx),%dl
  800f14:	88 10                	mov    %dl,(%eax)
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	84 c0                	test   %al,%al
  800f1a:	75 e4                	jne    800f00 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f1f:	c9                   	leave  
  800f20:	c3                   	ret    

00800f21 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
  800f24:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f34:	eb 1f                	jmp    800f55 <strncpy+0x34>
		*dst++ = *src;
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	8d 50 01             	lea    0x1(%eax),%edx
  800f3c:	89 55 08             	mov    %edx,0x8(%ebp)
  800f3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f42:	8a 12                	mov    (%edx),%dl
  800f44:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	84 c0                	test   %al,%al
  800f4d:	74 03                	je     800f52 <strncpy+0x31>
			src++;
  800f4f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f52:	ff 45 fc             	incl   -0x4(%ebp)
  800f55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f58:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f5b:	72 d9                	jb     800f36 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f60:	c9                   	leave  
  800f61:	c3                   	ret    

00800f62 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f72:	74 30                	je     800fa4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f74:	eb 16                	jmp    800f8c <strlcpy+0x2a>
			*dst++ = *src++;
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	8d 50 01             	lea    0x1(%eax),%edx
  800f7c:	89 55 08             	mov    %edx,0x8(%ebp)
  800f7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f82:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f85:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f88:	8a 12                	mov    (%edx),%dl
  800f8a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f8c:	ff 4d 10             	decl   0x10(%ebp)
  800f8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f93:	74 09                	je     800f9e <strlcpy+0x3c>
  800f95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f98:	8a 00                	mov    (%eax),%al
  800f9a:	84 c0                	test   %al,%al
  800f9c:	75 d8                	jne    800f76 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fa4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800faa:	29 c2                	sub    %eax,%edx
  800fac:	89 d0                	mov    %edx,%eax
}
  800fae:	c9                   	leave  
  800faf:	c3                   	ret    

00800fb0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800fb3:	eb 06                	jmp    800fbb <strcmp+0xb>
		p++, q++;
  800fb5:	ff 45 08             	incl   0x8(%ebp)
  800fb8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	8a 00                	mov    (%eax),%al
  800fc0:	84 c0                	test   %al,%al
  800fc2:	74 0e                	je     800fd2 <strcmp+0x22>
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	8a 10                	mov    (%eax),%dl
  800fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	38 c2                	cmp    %al,%dl
  800fd0:	74 e3                	je     800fb5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	0f b6 d0             	movzbl %al,%edx
  800fda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	0f b6 c0             	movzbl %al,%eax
  800fe2:	29 c2                	sub    %eax,%edx
  800fe4:	89 d0                	mov    %edx,%eax
}
  800fe6:	5d                   	pop    %ebp
  800fe7:	c3                   	ret    

00800fe8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800feb:	eb 09                	jmp    800ff6 <strncmp+0xe>
		n--, p++, q++;
  800fed:	ff 4d 10             	decl   0x10(%ebp)
  800ff0:	ff 45 08             	incl   0x8(%ebp)
  800ff3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ff6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffa:	74 17                	je     801013 <strncmp+0x2b>
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	84 c0                	test   %al,%al
  801003:	74 0e                	je     801013 <strncmp+0x2b>
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 10                	mov    (%eax),%dl
  80100a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	38 c2                	cmp    %al,%dl
  801011:	74 da                	je     800fed <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801013:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801017:	75 07                	jne    801020 <strncmp+0x38>
		return 0;
  801019:	b8 00 00 00 00       	mov    $0x0,%eax
  80101e:	eb 14                	jmp    801034 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	0f b6 d0             	movzbl %al,%edx
  801028:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	0f b6 c0             	movzbl %al,%eax
  801030:	29 c2                	sub    %eax,%edx
  801032:	89 d0                	mov    %edx,%eax
}
  801034:	5d                   	pop    %ebp
  801035:	c3                   	ret    

00801036 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801036:	55                   	push   %ebp
  801037:	89 e5                	mov    %esp,%ebp
  801039:	83 ec 04             	sub    $0x4,%esp
  80103c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801042:	eb 12                	jmp    801056 <strchr+0x20>
		if (*s == c)
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	8a 00                	mov    (%eax),%al
  801049:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80104c:	75 05                	jne    801053 <strchr+0x1d>
			return (char *) s;
  80104e:	8b 45 08             	mov    0x8(%ebp),%eax
  801051:	eb 11                	jmp    801064 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801053:	ff 45 08             	incl   0x8(%ebp)
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
  801059:	8a 00                	mov    (%eax),%al
  80105b:	84 c0                	test   %al,%al
  80105d:	75 e5                	jne    801044 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80105f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 04             	sub    $0x4,%esp
  80106c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801072:	eb 0d                	jmp    801081 <strfind+0x1b>
		if (*s == c)
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80107c:	74 0e                	je     80108c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80107e:	ff 45 08             	incl   0x8(%ebp)
  801081:	8b 45 08             	mov    0x8(%ebp),%eax
  801084:	8a 00                	mov    (%eax),%al
  801086:	84 c0                	test   %al,%al
  801088:	75 ea                	jne    801074 <strfind+0xe>
  80108a:	eb 01                	jmp    80108d <strfind+0x27>
		if (*s == c)
			break;
  80108c:	90                   	nop
	return (char *) s;
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801090:	c9                   	leave  
  801091:	c3                   	ret    

00801092 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80109e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010a2:	76 63                	jbe    801107 <memset+0x75>
		uint64 data_block = c;
  8010a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a7:	99                   	cltd   
  8010a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8010ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010b4:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8010b8:	c1 e0 08             	shl    $0x8,%eax
  8010bb:	09 45 f0             	or     %eax,-0x10(%ebp)
  8010be:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8010c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c7:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8010cb:	c1 e0 10             	shl    $0x10,%eax
  8010ce:	09 45 f0             	or     %eax,-0x10(%ebp)
  8010d1:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8010d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010da:	89 c2                	mov    %eax,%edx
  8010dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e1:	09 45 f0             	or     %eax,-0x10(%ebp)
  8010e4:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8010e7:	eb 18                	jmp    801101 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8010e9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010ec:	8d 41 08             	lea    0x8(%ecx),%eax
  8010ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8010f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f8:	89 01                	mov    %eax,(%ecx)
  8010fa:	89 51 04             	mov    %edx,0x4(%ecx)
  8010fd:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801101:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801105:	77 e2                	ja     8010e9 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801107:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110b:	74 23                	je     801130 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80110d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801110:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801113:	eb 0e                	jmp    801123 <memset+0x91>
			*p8++ = (uint8)c;
  801115:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801118:	8d 50 01             	lea    0x1(%eax),%edx
  80111b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80111e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801121:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801123:	8b 45 10             	mov    0x10(%ebp),%eax
  801126:	8d 50 ff             	lea    -0x1(%eax),%edx
  801129:	89 55 10             	mov    %edx,0x10(%ebp)
  80112c:	85 c0                	test   %eax,%eax
  80112e:	75 e5                	jne    801115 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801133:	c9                   	leave  
  801134:	c3                   	ret    

00801135 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
  801138:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80113b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801147:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80114b:	76 24                	jbe    801171 <memcpy+0x3c>
		while(n >= 8){
  80114d:	eb 1c                	jmp    80116b <memcpy+0x36>
			*d64 = *s64;
  80114f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801152:	8b 50 04             	mov    0x4(%eax),%edx
  801155:	8b 00                	mov    (%eax),%eax
  801157:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80115a:	89 01                	mov    %eax,(%ecx)
  80115c:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80115f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801163:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801167:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80116b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80116f:	77 de                	ja     80114f <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801171:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801175:	74 31                	je     8011a8 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801177:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80117d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801180:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801183:	eb 16                	jmp    80119b <memcpy+0x66>
			*d8++ = *s8++;
  801185:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801188:	8d 50 01             	lea    0x1(%eax),%edx
  80118b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80118e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801191:	8d 4a 01             	lea    0x1(%edx),%ecx
  801194:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801197:	8a 12                	mov    (%edx),%dl
  801199:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80119b:	8b 45 10             	mov    0x10(%ebp),%eax
  80119e:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011a1:	89 55 10             	mov    %edx,0x10(%ebp)
  8011a4:	85 c0                	test   %eax,%eax
  8011a6:	75 dd                	jne    801185 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011ab:	c9                   	leave  
  8011ac:	c3                   	ret    

008011ad <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8011ad:	55                   	push   %ebp
  8011ae:	89 e5                	mov    %esp,%ebp
  8011b0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8011bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8011c5:	73 50                	jae    801217 <memmove+0x6a>
  8011c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cd:	01 d0                	add    %edx,%eax
  8011cf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8011d2:	76 43                	jbe    801217 <memmove+0x6a>
		s += n;
  8011d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d7:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8011da:	8b 45 10             	mov    0x10(%ebp),%eax
  8011dd:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8011e0:	eb 10                	jmp    8011f2 <memmove+0x45>
			*--d = *--s;
  8011e2:	ff 4d f8             	decl   -0x8(%ebp)
  8011e5:	ff 4d fc             	decl   -0x4(%ebp)
  8011e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011eb:	8a 10                	mov    (%eax),%dl
  8011ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f0:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8011f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011f8:	89 55 10             	mov    %edx,0x10(%ebp)
  8011fb:	85 c0                	test   %eax,%eax
  8011fd:	75 e3                	jne    8011e2 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011ff:	eb 23                	jmp    801224 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801201:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801204:	8d 50 01             	lea    0x1(%eax),%edx
  801207:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80120a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80120d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801210:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801213:	8a 12                	mov    (%edx),%dl
  801215:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801217:	8b 45 10             	mov    0x10(%ebp),%eax
  80121a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80121d:	89 55 10             	mov    %edx,0x10(%ebp)
  801220:	85 c0                	test   %eax,%eax
  801222:	75 dd                	jne    801201 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801227:	c9                   	leave  
  801228:	c3                   	ret    

00801229 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801235:	8b 45 0c             	mov    0xc(%ebp),%eax
  801238:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80123b:	eb 2a                	jmp    801267 <memcmp+0x3e>
		if (*s1 != *s2)
  80123d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801240:	8a 10                	mov    (%eax),%dl
  801242:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801245:	8a 00                	mov    (%eax),%al
  801247:	38 c2                	cmp    %al,%dl
  801249:	74 16                	je     801261 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80124b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80124e:	8a 00                	mov    (%eax),%al
  801250:	0f b6 d0             	movzbl %al,%edx
  801253:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801256:	8a 00                	mov    (%eax),%al
  801258:	0f b6 c0             	movzbl %al,%eax
  80125b:	29 c2                	sub    %eax,%edx
  80125d:	89 d0                	mov    %edx,%eax
  80125f:	eb 18                	jmp    801279 <memcmp+0x50>
		s1++, s2++;
  801261:	ff 45 fc             	incl   -0x4(%ebp)
  801264:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801267:	8b 45 10             	mov    0x10(%ebp),%eax
  80126a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80126d:	89 55 10             	mov    %edx,0x10(%ebp)
  801270:	85 c0                	test   %eax,%eax
  801272:	75 c9                	jne    80123d <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801274:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801279:	c9                   	leave  
  80127a:	c3                   	ret    

0080127b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
  80127e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801281:	8b 55 08             	mov    0x8(%ebp),%edx
  801284:	8b 45 10             	mov    0x10(%ebp),%eax
  801287:	01 d0                	add    %edx,%eax
  801289:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80128c:	eb 15                	jmp    8012a3 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80128e:	8b 45 08             	mov    0x8(%ebp),%eax
  801291:	8a 00                	mov    (%eax),%al
  801293:	0f b6 d0             	movzbl %al,%edx
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	0f b6 c0             	movzbl %al,%eax
  80129c:	39 c2                	cmp    %eax,%edx
  80129e:	74 0d                	je     8012ad <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8012a0:	ff 45 08             	incl   0x8(%ebp)
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8012a9:	72 e3                	jb     80128e <memfind+0x13>
  8012ab:	eb 01                	jmp    8012ae <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8012ad:	90                   	nop
	return (void *) s;
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012b1:	c9                   	leave  
  8012b2:	c3                   	ret    

008012b3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
  8012b6:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8012b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8012c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8012c7:	eb 03                	jmp    8012cc <strtol+0x19>
		s++;
  8012c9:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	8a 00                	mov    (%eax),%al
  8012d1:	3c 20                	cmp    $0x20,%al
  8012d3:	74 f4                	je     8012c9 <strtol+0x16>
  8012d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d8:	8a 00                	mov    (%eax),%al
  8012da:	3c 09                	cmp    $0x9,%al
  8012dc:	74 eb                	je     8012c9 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	8a 00                	mov    (%eax),%al
  8012e3:	3c 2b                	cmp    $0x2b,%al
  8012e5:	75 05                	jne    8012ec <strtol+0x39>
		s++;
  8012e7:	ff 45 08             	incl   0x8(%ebp)
  8012ea:	eb 13                	jmp    8012ff <strtol+0x4c>
	else if (*s == '-')
  8012ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ef:	8a 00                	mov    (%eax),%al
  8012f1:	3c 2d                	cmp    $0x2d,%al
  8012f3:	75 0a                	jne    8012ff <strtol+0x4c>
		s++, neg = 1;
  8012f5:	ff 45 08             	incl   0x8(%ebp)
  8012f8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801303:	74 06                	je     80130b <strtol+0x58>
  801305:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801309:	75 20                	jne    80132b <strtol+0x78>
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
  80130e:	8a 00                	mov    (%eax),%al
  801310:	3c 30                	cmp    $0x30,%al
  801312:	75 17                	jne    80132b <strtol+0x78>
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	40                   	inc    %eax
  801318:	8a 00                	mov    (%eax),%al
  80131a:	3c 78                	cmp    $0x78,%al
  80131c:	75 0d                	jne    80132b <strtol+0x78>
		s += 2, base = 16;
  80131e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801322:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801329:	eb 28                	jmp    801353 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80132b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80132f:	75 15                	jne    801346 <strtol+0x93>
  801331:	8b 45 08             	mov    0x8(%ebp),%eax
  801334:	8a 00                	mov    (%eax),%al
  801336:	3c 30                	cmp    $0x30,%al
  801338:	75 0c                	jne    801346 <strtol+0x93>
		s++, base = 8;
  80133a:	ff 45 08             	incl   0x8(%ebp)
  80133d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801344:	eb 0d                	jmp    801353 <strtol+0xa0>
	else if (base == 0)
  801346:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80134a:	75 07                	jne    801353 <strtol+0xa0>
		base = 10;
  80134c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	8a 00                	mov    (%eax),%al
  801358:	3c 2f                	cmp    $0x2f,%al
  80135a:	7e 19                	jle    801375 <strtol+0xc2>
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	8a 00                	mov    (%eax),%al
  801361:	3c 39                	cmp    $0x39,%al
  801363:	7f 10                	jg     801375 <strtol+0xc2>
			dig = *s - '0';
  801365:	8b 45 08             	mov    0x8(%ebp),%eax
  801368:	8a 00                	mov    (%eax),%al
  80136a:	0f be c0             	movsbl %al,%eax
  80136d:	83 e8 30             	sub    $0x30,%eax
  801370:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801373:	eb 42                	jmp    8013b7 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801375:	8b 45 08             	mov    0x8(%ebp),%eax
  801378:	8a 00                	mov    (%eax),%al
  80137a:	3c 60                	cmp    $0x60,%al
  80137c:	7e 19                	jle    801397 <strtol+0xe4>
  80137e:	8b 45 08             	mov    0x8(%ebp),%eax
  801381:	8a 00                	mov    (%eax),%al
  801383:	3c 7a                	cmp    $0x7a,%al
  801385:	7f 10                	jg     801397 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	0f be c0             	movsbl %al,%eax
  80138f:	83 e8 57             	sub    $0x57,%eax
  801392:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801395:	eb 20                	jmp    8013b7 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	8a 00                	mov    (%eax),%al
  80139c:	3c 40                	cmp    $0x40,%al
  80139e:	7e 39                	jle    8013d9 <strtol+0x126>
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8a 00                	mov    (%eax),%al
  8013a5:	3c 5a                	cmp    $0x5a,%al
  8013a7:	7f 30                	jg     8013d9 <strtol+0x126>
			dig = *s - 'A' + 10;
  8013a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ac:	8a 00                	mov    (%eax),%al
  8013ae:	0f be c0             	movsbl %al,%eax
  8013b1:	83 e8 37             	sub    $0x37,%eax
  8013b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8013b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ba:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013bd:	7d 19                	jge    8013d8 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8013bf:	ff 45 08             	incl   0x8(%ebp)
  8013c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c5:	0f af 45 10          	imul   0x10(%ebp),%eax
  8013c9:	89 c2                	mov    %eax,%edx
  8013cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ce:	01 d0                	add    %edx,%eax
  8013d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8013d3:	e9 7b ff ff ff       	jmp    801353 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8013d8:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8013d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013dd:	74 08                	je     8013e7 <strtol+0x134>
		*endptr = (char *) s;
  8013df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8013e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013eb:	74 07                	je     8013f4 <strtol+0x141>
  8013ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f0:	f7 d8                	neg    %eax
  8013f2:	eb 03                	jmp    8013f7 <strtol+0x144>
  8013f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013f7:	c9                   	leave  
  8013f8:	c3                   	ret    

008013f9 <ltostr>:

void
ltostr(long value, char *str)
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8013ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801406:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80140d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801411:	79 13                	jns    801426 <ltostr+0x2d>
	{
		neg = 1;
  801413:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80141a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801420:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801423:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801426:	8b 45 08             	mov    0x8(%ebp),%eax
  801429:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80142e:	99                   	cltd   
  80142f:	f7 f9                	idiv   %ecx
  801431:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801434:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801437:	8d 50 01             	lea    0x1(%eax),%edx
  80143a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80143d:	89 c2                	mov    %eax,%edx
  80143f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801442:	01 d0                	add    %edx,%eax
  801444:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801447:	83 c2 30             	add    $0x30,%edx
  80144a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80144c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80144f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801454:	f7 e9                	imul   %ecx
  801456:	c1 fa 02             	sar    $0x2,%edx
  801459:	89 c8                	mov    %ecx,%eax
  80145b:	c1 f8 1f             	sar    $0x1f,%eax
  80145e:	29 c2                	sub    %eax,%edx
  801460:	89 d0                	mov    %edx,%eax
  801462:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801465:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801469:	75 bb                	jne    801426 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80146b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801472:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801475:	48                   	dec    %eax
  801476:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801479:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80147d:	74 3d                	je     8014bc <ltostr+0xc3>
		start = 1 ;
  80147f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801486:	eb 34                	jmp    8014bc <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801488:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80148b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148e:	01 d0                	add    %edx,%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801495:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801498:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149b:	01 c2                	add    %eax,%edx
  80149d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8014a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a3:	01 c8                	add    %ecx,%eax
  8014a5:	8a 00                	mov    (%eax),%al
  8014a7:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8014a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014af:	01 c2                	add    %eax,%edx
  8014b1:	8a 45 eb             	mov    -0x15(%ebp),%al
  8014b4:	88 02                	mov    %al,(%edx)
		start++ ;
  8014b6:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8014b9:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8014bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014bf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014c2:	7c c4                	jl     801488 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8014c4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8014c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ca:	01 d0                	add    %edx,%eax
  8014cc:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8014cf:	90                   	nop
  8014d0:	c9                   	leave  
  8014d1:	c3                   	ret    

008014d2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
  8014d5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8014d8:	ff 75 08             	pushl  0x8(%ebp)
  8014db:	e8 c4 f9 ff ff       	call   800ea4 <strlen>
  8014e0:	83 c4 04             	add    $0x4,%esp
  8014e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8014e6:	ff 75 0c             	pushl  0xc(%ebp)
  8014e9:	e8 b6 f9 ff ff       	call   800ea4 <strlen>
  8014ee:	83 c4 04             	add    $0x4,%esp
  8014f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8014f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801502:	eb 17                	jmp    80151b <strcconcat+0x49>
		final[s] = str1[s] ;
  801504:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801507:	8b 45 10             	mov    0x10(%ebp),%eax
  80150a:	01 c2                	add    %eax,%edx
  80150c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	01 c8                	add    %ecx,%eax
  801514:	8a 00                	mov    (%eax),%al
  801516:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801518:	ff 45 fc             	incl   -0x4(%ebp)
  80151b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80151e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801521:	7c e1                	jl     801504 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801523:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80152a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801531:	eb 1f                	jmp    801552 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801533:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801536:	8d 50 01             	lea    0x1(%eax),%edx
  801539:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80153c:	89 c2                	mov    %eax,%edx
  80153e:	8b 45 10             	mov    0x10(%ebp),%eax
  801541:	01 c2                	add    %eax,%edx
  801543:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801546:	8b 45 0c             	mov    0xc(%ebp),%eax
  801549:	01 c8                	add    %ecx,%eax
  80154b:	8a 00                	mov    (%eax),%al
  80154d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80154f:	ff 45 f8             	incl   -0x8(%ebp)
  801552:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801555:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801558:	7c d9                	jl     801533 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80155a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80155d:	8b 45 10             	mov    0x10(%ebp),%eax
  801560:	01 d0                	add    %edx,%eax
  801562:	c6 00 00             	movb   $0x0,(%eax)
}
  801565:	90                   	nop
  801566:	c9                   	leave  
  801567:	c3                   	ret    

00801568 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80156b:	8b 45 14             	mov    0x14(%ebp),%eax
  80156e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801574:	8b 45 14             	mov    0x14(%ebp),%eax
  801577:	8b 00                	mov    (%eax),%eax
  801579:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801580:	8b 45 10             	mov    0x10(%ebp),%eax
  801583:	01 d0                	add    %edx,%eax
  801585:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80158b:	eb 0c                	jmp    801599 <strsplit+0x31>
			*string++ = 0;
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
  801590:	8d 50 01             	lea    0x1(%eax),%edx
  801593:	89 55 08             	mov    %edx,0x8(%ebp)
  801596:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	8a 00                	mov    (%eax),%al
  80159e:	84 c0                	test   %al,%al
  8015a0:	74 18                	je     8015ba <strsplit+0x52>
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	8a 00                	mov    (%eax),%al
  8015a7:	0f be c0             	movsbl %al,%eax
  8015aa:	50                   	push   %eax
  8015ab:	ff 75 0c             	pushl  0xc(%ebp)
  8015ae:	e8 83 fa ff ff       	call   801036 <strchr>
  8015b3:	83 c4 08             	add    $0x8,%esp
  8015b6:	85 c0                	test   %eax,%eax
  8015b8:	75 d3                	jne    80158d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8015ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bd:	8a 00                	mov    (%eax),%al
  8015bf:	84 c0                	test   %al,%al
  8015c1:	74 5a                	je     80161d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8015c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c6:	8b 00                	mov    (%eax),%eax
  8015c8:	83 f8 0f             	cmp    $0xf,%eax
  8015cb:	75 07                	jne    8015d4 <strsplit+0x6c>
		{
			return 0;
  8015cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d2:	eb 66                	jmp    80163a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8015d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d7:	8b 00                	mov    (%eax),%eax
  8015d9:	8d 48 01             	lea    0x1(%eax),%ecx
  8015dc:	8b 55 14             	mov    0x14(%ebp),%edx
  8015df:	89 0a                	mov    %ecx,(%edx)
  8015e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015eb:	01 c2                	add    %eax,%edx
  8015ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015f2:	eb 03                	jmp    8015f7 <strsplit+0x8f>
			string++;
  8015f4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	8a 00                	mov    (%eax),%al
  8015fc:	84 c0                	test   %al,%al
  8015fe:	74 8b                	je     80158b <strsplit+0x23>
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
  801603:	8a 00                	mov    (%eax),%al
  801605:	0f be c0             	movsbl %al,%eax
  801608:	50                   	push   %eax
  801609:	ff 75 0c             	pushl  0xc(%ebp)
  80160c:	e8 25 fa ff ff       	call   801036 <strchr>
  801611:	83 c4 08             	add    $0x8,%esp
  801614:	85 c0                	test   %eax,%eax
  801616:	74 dc                	je     8015f4 <strsplit+0x8c>
			string++;
	}
  801618:	e9 6e ff ff ff       	jmp    80158b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80161d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80161e:	8b 45 14             	mov    0x14(%ebp),%eax
  801621:	8b 00                	mov    (%eax),%eax
  801623:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80162a:	8b 45 10             	mov    0x10(%ebp),%eax
  80162d:	01 d0                	add    %edx,%eax
  80162f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801635:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    

0080163c <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801648:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80164f:	eb 4a                	jmp    80169b <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801651:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	01 c2                	add    %eax,%edx
  801659:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80165c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165f:	01 c8                	add    %ecx,%eax
  801661:	8a 00                	mov    (%eax),%al
  801663:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801665:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801668:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166b:	01 d0                	add    %edx,%eax
  80166d:	8a 00                	mov    (%eax),%al
  80166f:	3c 40                	cmp    $0x40,%al
  801671:	7e 25                	jle    801698 <str2lower+0x5c>
  801673:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801676:	8b 45 0c             	mov    0xc(%ebp),%eax
  801679:	01 d0                	add    %edx,%eax
  80167b:	8a 00                	mov    (%eax),%al
  80167d:	3c 5a                	cmp    $0x5a,%al
  80167f:	7f 17                	jg     801698 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801681:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	01 d0                	add    %edx,%eax
  801689:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80168c:	8b 55 08             	mov    0x8(%ebp),%edx
  80168f:	01 ca                	add    %ecx,%edx
  801691:	8a 12                	mov    (%edx),%dl
  801693:	83 c2 20             	add    $0x20,%edx
  801696:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801698:	ff 45 fc             	incl   -0x4(%ebp)
  80169b:	ff 75 0c             	pushl  0xc(%ebp)
  80169e:	e8 01 f8 ff ff       	call   800ea4 <strlen>
  8016a3:	83 c4 04             	add    $0x4,%esp
  8016a6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016a9:	7f a6                	jg     801651 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8016ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	57                   	push   %edi
  8016b4:	56                   	push   %esi
  8016b5:	53                   	push   %ebx
  8016b6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016c2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016c5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016c8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016cb:	cd 30                	int    $0x30
  8016cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8016d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016d3:	83 c4 10             	add    $0x10,%esp
  8016d6:	5b                   	pop    %ebx
  8016d7:	5e                   	pop    %esi
  8016d8:	5f                   	pop    %edi
  8016d9:	5d                   	pop    %ebp
  8016da:	c3                   	ret    

008016db <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	83 ec 04             	sub    $0x4,%esp
  8016e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8016e7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016ea:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f1:	6a 00                	push   $0x0
  8016f3:	51                   	push   %ecx
  8016f4:	52                   	push   %edx
  8016f5:	ff 75 0c             	pushl  0xc(%ebp)
  8016f8:	50                   	push   %eax
  8016f9:	6a 00                	push   $0x0
  8016fb:	e8 b0 ff ff ff       	call   8016b0 <syscall>
  801700:	83 c4 18             	add    $0x18,%esp
}
  801703:	90                   	nop
  801704:	c9                   	leave  
  801705:	c3                   	ret    

00801706 <sys_cgetc>:

int
sys_cgetc(void)
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 02                	push   $0x2
  801715:	e8 96 ff ff ff       	call   8016b0 <syscall>
  80171a:	83 c4 18             	add    $0x18,%esp
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 03                	push   $0x3
  80172e:	e8 7d ff ff ff       	call   8016b0 <syscall>
  801733:	83 c4 18             	add    $0x18,%esp
}
  801736:	90                   	nop
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 04                	push   $0x4
  801748:	e8 63 ff ff ff       	call   8016b0 <syscall>
  80174d:	83 c4 18             	add    $0x18,%esp
}
  801750:	90                   	nop
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801756:	8b 55 0c             	mov    0xc(%ebp),%edx
  801759:	8b 45 08             	mov    0x8(%ebp),%eax
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	52                   	push   %edx
  801763:	50                   	push   %eax
  801764:	6a 08                	push   $0x8
  801766:	e8 45 ff ff ff       	call   8016b0 <syscall>
  80176b:	83 c4 18             	add    $0x18,%esp
}
  80176e:	c9                   	leave  
  80176f:	c3                   	ret    

00801770 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	56                   	push   %esi
  801774:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801775:	8b 75 18             	mov    0x18(%ebp),%esi
  801778:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80177b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80177e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801781:	8b 45 08             	mov    0x8(%ebp),%eax
  801784:	56                   	push   %esi
  801785:	53                   	push   %ebx
  801786:	51                   	push   %ecx
  801787:	52                   	push   %edx
  801788:	50                   	push   %eax
  801789:	6a 09                	push   $0x9
  80178b:	e8 20 ff ff ff       	call   8016b0 <syscall>
  801790:	83 c4 18             	add    $0x18,%esp
}
  801793:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801796:	5b                   	pop    %ebx
  801797:	5e                   	pop    %esi
  801798:	5d                   	pop    %ebp
  801799:	c3                   	ret    

0080179a <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	ff 75 08             	pushl  0x8(%ebp)
  8017a8:	6a 0a                	push   $0xa
  8017aa:	e8 01 ff ff ff       	call   8016b0 <syscall>
  8017af:	83 c4 18             	add    $0x18,%esp
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	ff 75 0c             	pushl  0xc(%ebp)
  8017c0:	ff 75 08             	pushl  0x8(%ebp)
  8017c3:	6a 0b                	push   $0xb
  8017c5:	e8 e6 fe ff ff       	call   8016b0 <syscall>
  8017ca:	83 c4 18             	add    $0x18,%esp
}
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 0c                	push   $0xc
  8017de:	e8 cd fe ff ff       	call   8016b0 <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
}
  8017e6:	c9                   	leave  
  8017e7:	c3                   	ret    

008017e8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 0d                	push   $0xd
  8017f7:	e8 b4 fe ff ff       	call   8016b0 <syscall>
  8017fc:	83 c4 18             	add    $0x18,%esp
}
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    

00801801 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 0e                	push   $0xe
  801810:	e8 9b fe ff ff       	call   8016b0 <syscall>
  801815:	83 c4 18             	add    $0x18,%esp
}
  801818:	c9                   	leave  
  801819:	c3                   	ret    

0080181a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 0f                	push   $0xf
  801829:	e8 82 fe ff ff       	call   8016b0 <syscall>
  80182e:	83 c4 18             	add    $0x18,%esp
}
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	ff 75 08             	pushl  0x8(%ebp)
  801841:	6a 10                	push   $0x10
  801843:	e8 68 fe ff ff       	call   8016b0 <syscall>
  801848:	83 c4 18             	add    $0x18,%esp
}
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 11                	push   $0x11
  80185c:	e8 4f fe ff ff       	call   8016b0 <syscall>
  801861:	83 c4 18             	add    $0x18,%esp
}
  801864:	90                   	nop
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <sys_cputc>:

void
sys_cputc(const char c)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	83 ec 04             	sub    $0x4,%esp
  80186d:	8b 45 08             	mov    0x8(%ebp),%eax
  801870:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801873:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	50                   	push   %eax
  801880:	6a 01                	push   $0x1
  801882:	e8 29 fe ff ff       	call   8016b0 <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
}
  80188a:	90                   	nop
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 14                	push   $0x14
  80189c:	e8 0f fe ff ff       	call   8016b0 <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
}
  8018a4:	90                   	nop
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
  8018aa:	83 ec 04             	sub    $0x4,%esp
  8018ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018b3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018b6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bd:	6a 00                	push   $0x0
  8018bf:	51                   	push   %ecx
  8018c0:	52                   	push   %edx
  8018c1:	ff 75 0c             	pushl  0xc(%ebp)
  8018c4:	50                   	push   %eax
  8018c5:	6a 15                	push   $0x15
  8018c7:	e8 e4 fd ff ff       	call   8016b0 <syscall>
  8018cc:	83 c4 18             	add    $0x18,%esp
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	52                   	push   %edx
  8018e1:	50                   	push   %eax
  8018e2:	6a 16                	push   $0x16
  8018e4:	e8 c7 fd ff ff       	call   8016b0 <syscall>
  8018e9:	83 c4 18             	add    $0x18,%esp
}
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    

008018ee <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	51                   	push   %ecx
  8018ff:	52                   	push   %edx
  801900:	50                   	push   %eax
  801901:	6a 17                	push   $0x17
  801903:	e8 a8 fd ff ff       	call   8016b0 <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
}
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801910:	8b 55 0c             	mov    0xc(%ebp),%edx
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	52                   	push   %edx
  80191d:	50                   	push   %eax
  80191e:	6a 18                	push   $0x18
  801920:	e8 8b fd ff ff       	call   8016b0 <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80192d:	8b 45 08             	mov    0x8(%ebp),%eax
  801930:	6a 00                	push   $0x0
  801932:	ff 75 14             	pushl  0x14(%ebp)
  801935:	ff 75 10             	pushl  0x10(%ebp)
  801938:	ff 75 0c             	pushl  0xc(%ebp)
  80193b:	50                   	push   %eax
  80193c:	6a 19                	push   $0x19
  80193e:	e8 6d fd ff ff       	call   8016b0 <syscall>
  801943:	83 c4 18             	add    $0x18,%esp
}
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80194b:	8b 45 08             	mov    0x8(%ebp),%eax
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	50                   	push   %eax
  801957:	6a 1a                	push   $0x1a
  801959:	e8 52 fd ff ff       	call   8016b0 <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
}
  801961:	90                   	nop
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801967:	8b 45 08             	mov    0x8(%ebp),%eax
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	50                   	push   %eax
  801973:	6a 1b                	push   $0x1b
  801975:	e8 36 fd ff ff       	call   8016b0 <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 05                	push   $0x5
  80198e:	e8 1d fd ff ff       	call   8016b0 <syscall>
  801993:	83 c4 18             	add    $0x18,%esp
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 06                	push   $0x6
  8019a7:	e8 04 fd ff ff       	call   8016b0 <syscall>
  8019ac:	83 c4 18             	add    $0x18,%esp
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 07                	push   $0x7
  8019c0:	e8 eb fc ff ff       	call   8016b0 <syscall>
  8019c5:	83 c4 18             	add    $0x18,%esp
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sys_exit_env>:


void sys_exit_env(void)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 1c                	push   $0x1c
  8019d9:	e8 d2 fc ff ff       	call   8016b0 <syscall>
  8019de:	83 c4 18             	add    $0x18,%esp
}
  8019e1:	90                   	nop
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019ea:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019ed:	8d 50 04             	lea    0x4(%eax),%edx
  8019f0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	52                   	push   %edx
  8019fa:	50                   	push   %eax
  8019fb:	6a 1d                	push   $0x1d
  8019fd:	e8 ae fc ff ff       	call   8016b0 <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
	return result;
  801a05:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a08:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a0b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a0e:	89 01                	mov    %eax,(%ecx)
  801a10:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	c9                   	leave  
  801a17:	c2 04 00             	ret    $0x4

00801a1a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	ff 75 10             	pushl  0x10(%ebp)
  801a24:	ff 75 0c             	pushl  0xc(%ebp)
  801a27:	ff 75 08             	pushl  0x8(%ebp)
  801a2a:	6a 13                	push   $0x13
  801a2c:	e8 7f fc ff ff       	call   8016b0 <syscall>
  801a31:	83 c4 18             	add    $0x18,%esp
	return ;
  801a34:	90                   	nop
}
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 1e                	push   $0x1e
  801a46:	e8 65 fc ff ff       	call   8016b0 <syscall>
  801a4b:	83 c4 18             	add    $0x18,%esp
}
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	83 ec 04             	sub    $0x4,%esp
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
  801a59:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a5c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	50                   	push   %eax
  801a69:	6a 1f                	push   $0x1f
  801a6b:	e8 40 fc ff ff       	call   8016b0 <syscall>
  801a70:	83 c4 18             	add    $0x18,%esp
	return ;
  801a73:	90                   	nop
}
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <rsttst>:
void rsttst()
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 21                	push   $0x21
  801a85:	e8 26 fc ff ff       	call   8016b0 <syscall>
  801a8a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a8d:	90                   	nop
}
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
  801a93:	83 ec 04             	sub    $0x4,%esp
  801a96:	8b 45 14             	mov    0x14(%ebp),%eax
  801a99:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a9c:	8b 55 18             	mov    0x18(%ebp),%edx
  801a9f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801aa3:	52                   	push   %edx
  801aa4:	50                   	push   %eax
  801aa5:	ff 75 10             	pushl  0x10(%ebp)
  801aa8:	ff 75 0c             	pushl  0xc(%ebp)
  801aab:	ff 75 08             	pushl  0x8(%ebp)
  801aae:	6a 20                	push   $0x20
  801ab0:	e8 fb fb ff ff       	call   8016b0 <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab8:	90                   	nop
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <chktst>:
void chktst(uint32 n)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	ff 75 08             	pushl  0x8(%ebp)
  801ac9:	6a 22                	push   $0x22
  801acb:	e8 e0 fb ff ff       	call   8016b0 <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad3:	90                   	nop
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <inctst>:

void inctst()
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 23                	push   $0x23
  801ae5:	e8 c6 fb ff ff       	call   8016b0 <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
	return ;
  801aed:	90                   	nop
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <gettst>:
uint32 gettst()
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 24                	push   $0x24
  801aff:	e8 ac fb ff ff       	call   8016b0 <syscall>
  801b04:	83 c4 18             	add    $0x18,%esp
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 25                	push   $0x25
  801b18:	e8 93 fb ff ff       	call   8016b0 <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
  801b20:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801b25:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b32:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	ff 75 08             	pushl  0x8(%ebp)
  801b42:	6a 26                	push   $0x26
  801b44:	e8 67 fb ff ff       	call   8016b0 <syscall>
  801b49:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4c:	90                   	nop
}
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b53:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b56:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	6a 00                	push   $0x0
  801b61:	53                   	push   %ebx
  801b62:	51                   	push   %ecx
  801b63:	52                   	push   %edx
  801b64:	50                   	push   %eax
  801b65:	6a 27                	push   $0x27
  801b67:	e8 44 fb ff ff       	call   8016b0 <syscall>
  801b6c:	83 c4 18             	add    $0x18,%esp
}
  801b6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	52                   	push   %edx
  801b84:	50                   	push   %eax
  801b85:	6a 28                	push   $0x28
  801b87:	e8 24 fb ff ff       	call   8016b0 <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b94:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9d:	6a 00                	push   $0x0
  801b9f:	51                   	push   %ecx
  801ba0:	ff 75 10             	pushl  0x10(%ebp)
  801ba3:	52                   	push   %edx
  801ba4:	50                   	push   %eax
  801ba5:	6a 29                	push   $0x29
  801ba7:	e8 04 fb ff ff       	call   8016b0 <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	ff 75 10             	pushl  0x10(%ebp)
  801bbb:	ff 75 0c             	pushl  0xc(%ebp)
  801bbe:	ff 75 08             	pushl  0x8(%ebp)
  801bc1:	6a 12                	push   $0x12
  801bc3:	e8 e8 fa ff ff       	call   8016b0 <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bcb:	90                   	nop
}
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	52                   	push   %edx
  801bde:	50                   	push   %eax
  801bdf:	6a 2a                	push   $0x2a
  801be1:	e8 ca fa ff ff       	call   8016b0 <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
	return;
  801be9:	90                   	nop
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 2b                	push   $0x2b
  801bfb:	e8 b0 fa ff ff       	call   8016b0 <syscall>
  801c00:	83 c4 18             	add    $0x18,%esp
}
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	ff 75 0c             	pushl  0xc(%ebp)
  801c11:	ff 75 08             	pushl  0x8(%ebp)
  801c14:	6a 2d                	push   $0x2d
  801c16:	e8 95 fa ff ff       	call   8016b0 <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
	return;
  801c1e:	90                   	nop
}
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	ff 75 0c             	pushl  0xc(%ebp)
  801c2d:	ff 75 08             	pushl  0x8(%ebp)
  801c30:	6a 2c                	push   $0x2c
  801c32:	e8 79 fa ff ff       	call   8016b0 <syscall>
  801c37:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3a:	90                   	nop
}
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801c40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c43:	8b 45 08             	mov    0x8(%ebp),%eax
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	52                   	push   %edx
  801c4d:	50                   	push   %eax
  801c4e:	6a 2e                	push   $0x2e
  801c50:	e8 5b fa ff ff       	call   8016b0 <syscall>
  801c55:	83 c4 18             	add    $0x18,%esp
	return ;
  801c58:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    
  801c5b:	90                   	nop

00801c5c <__udivdi3>:
  801c5c:	55                   	push   %ebp
  801c5d:	57                   	push   %edi
  801c5e:	56                   	push   %esi
  801c5f:	53                   	push   %ebx
  801c60:	83 ec 1c             	sub    $0x1c,%esp
  801c63:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c67:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c6f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c73:	89 ca                	mov    %ecx,%edx
  801c75:	89 f8                	mov    %edi,%eax
  801c77:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c7b:	85 f6                	test   %esi,%esi
  801c7d:	75 2d                	jne    801cac <__udivdi3+0x50>
  801c7f:	39 cf                	cmp    %ecx,%edi
  801c81:	77 65                	ja     801ce8 <__udivdi3+0x8c>
  801c83:	89 fd                	mov    %edi,%ebp
  801c85:	85 ff                	test   %edi,%edi
  801c87:	75 0b                	jne    801c94 <__udivdi3+0x38>
  801c89:	b8 01 00 00 00       	mov    $0x1,%eax
  801c8e:	31 d2                	xor    %edx,%edx
  801c90:	f7 f7                	div    %edi
  801c92:	89 c5                	mov    %eax,%ebp
  801c94:	31 d2                	xor    %edx,%edx
  801c96:	89 c8                	mov    %ecx,%eax
  801c98:	f7 f5                	div    %ebp
  801c9a:	89 c1                	mov    %eax,%ecx
  801c9c:	89 d8                	mov    %ebx,%eax
  801c9e:	f7 f5                	div    %ebp
  801ca0:	89 cf                	mov    %ecx,%edi
  801ca2:	89 fa                	mov    %edi,%edx
  801ca4:	83 c4 1c             	add    $0x1c,%esp
  801ca7:	5b                   	pop    %ebx
  801ca8:	5e                   	pop    %esi
  801ca9:	5f                   	pop    %edi
  801caa:	5d                   	pop    %ebp
  801cab:	c3                   	ret    
  801cac:	39 ce                	cmp    %ecx,%esi
  801cae:	77 28                	ja     801cd8 <__udivdi3+0x7c>
  801cb0:	0f bd fe             	bsr    %esi,%edi
  801cb3:	83 f7 1f             	xor    $0x1f,%edi
  801cb6:	75 40                	jne    801cf8 <__udivdi3+0x9c>
  801cb8:	39 ce                	cmp    %ecx,%esi
  801cba:	72 0a                	jb     801cc6 <__udivdi3+0x6a>
  801cbc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801cc0:	0f 87 9e 00 00 00    	ja     801d64 <__udivdi3+0x108>
  801cc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ccb:	89 fa                	mov    %edi,%edx
  801ccd:	83 c4 1c             	add    $0x1c,%esp
  801cd0:	5b                   	pop    %ebx
  801cd1:	5e                   	pop    %esi
  801cd2:	5f                   	pop    %edi
  801cd3:	5d                   	pop    %ebp
  801cd4:	c3                   	ret    
  801cd5:	8d 76 00             	lea    0x0(%esi),%esi
  801cd8:	31 ff                	xor    %edi,%edi
  801cda:	31 c0                	xor    %eax,%eax
  801cdc:	89 fa                	mov    %edi,%edx
  801cde:	83 c4 1c             	add    $0x1c,%esp
  801ce1:	5b                   	pop    %ebx
  801ce2:	5e                   	pop    %esi
  801ce3:	5f                   	pop    %edi
  801ce4:	5d                   	pop    %ebp
  801ce5:	c3                   	ret    
  801ce6:	66 90                	xchg   %ax,%ax
  801ce8:	89 d8                	mov    %ebx,%eax
  801cea:	f7 f7                	div    %edi
  801cec:	31 ff                	xor    %edi,%edi
  801cee:	89 fa                	mov    %edi,%edx
  801cf0:	83 c4 1c             	add    $0x1c,%esp
  801cf3:	5b                   	pop    %ebx
  801cf4:	5e                   	pop    %esi
  801cf5:	5f                   	pop    %edi
  801cf6:	5d                   	pop    %ebp
  801cf7:	c3                   	ret    
  801cf8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cfd:	89 eb                	mov    %ebp,%ebx
  801cff:	29 fb                	sub    %edi,%ebx
  801d01:	89 f9                	mov    %edi,%ecx
  801d03:	d3 e6                	shl    %cl,%esi
  801d05:	89 c5                	mov    %eax,%ebp
  801d07:	88 d9                	mov    %bl,%cl
  801d09:	d3 ed                	shr    %cl,%ebp
  801d0b:	89 e9                	mov    %ebp,%ecx
  801d0d:	09 f1                	or     %esi,%ecx
  801d0f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d13:	89 f9                	mov    %edi,%ecx
  801d15:	d3 e0                	shl    %cl,%eax
  801d17:	89 c5                	mov    %eax,%ebp
  801d19:	89 d6                	mov    %edx,%esi
  801d1b:	88 d9                	mov    %bl,%cl
  801d1d:	d3 ee                	shr    %cl,%esi
  801d1f:	89 f9                	mov    %edi,%ecx
  801d21:	d3 e2                	shl    %cl,%edx
  801d23:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d27:	88 d9                	mov    %bl,%cl
  801d29:	d3 e8                	shr    %cl,%eax
  801d2b:	09 c2                	or     %eax,%edx
  801d2d:	89 d0                	mov    %edx,%eax
  801d2f:	89 f2                	mov    %esi,%edx
  801d31:	f7 74 24 0c          	divl   0xc(%esp)
  801d35:	89 d6                	mov    %edx,%esi
  801d37:	89 c3                	mov    %eax,%ebx
  801d39:	f7 e5                	mul    %ebp
  801d3b:	39 d6                	cmp    %edx,%esi
  801d3d:	72 19                	jb     801d58 <__udivdi3+0xfc>
  801d3f:	74 0b                	je     801d4c <__udivdi3+0xf0>
  801d41:	89 d8                	mov    %ebx,%eax
  801d43:	31 ff                	xor    %edi,%edi
  801d45:	e9 58 ff ff ff       	jmp    801ca2 <__udivdi3+0x46>
  801d4a:	66 90                	xchg   %ax,%ax
  801d4c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d50:	89 f9                	mov    %edi,%ecx
  801d52:	d3 e2                	shl    %cl,%edx
  801d54:	39 c2                	cmp    %eax,%edx
  801d56:	73 e9                	jae    801d41 <__udivdi3+0xe5>
  801d58:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d5b:	31 ff                	xor    %edi,%edi
  801d5d:	e9 40 ff ff ff       	jmp    801ca2 <__udivdi3+0x46>
  801d62:	66 90                	xchg   %ax,%ax
  801d64:	31 c0                	xor    %eax,%eax
  801d66:	e9 37 ff ff ff       	jmp    801ca2 <__udivdi3+0x46>
  801d6b:	90                   	nop

00801d6c <__umoddi3>:
  801d6c:	55                   	push   %ebp
  801d6d:	57                   	push   %edi
  801d6e:	56                   	push   %esi
  801d6f:	53                   	push   %ebx
  801d70:	83 ec 1c             	sub    $0x1c,%esp
  801d73:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d77:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d7f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d8b:	89 f3                	mov    %esi,%ebx
  801d8d:	89 fa                	mov    %edi,%edx
  801d8f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d93:	89 34 24             	mov    %esi,(%esp)
  801d96:	85 c0                	test   %eax,%eax
  801d98:	75 1a                	jne    801db4 <__umoddi3+0x48>
  801d9a:	39 f7                	cmp    %esi,%edi
  801d9c:	0f 86 a2 00 00 00    	jbe    801e44 <__umoddi3+0xd8>
  801da2:	89 c8                	mov    %ecx,%eax
  801da4:	89 f2                	mov    %esi,%edx
  801da6:	f7 f7                	div    %edi
  801da8:	89 d0                	mov    %edx,%eax
  801daa:	31 d2                	xor    %edx,%edx
  801dac:	83 c4 1c             	add    $0x1c,%esp
  801daf:	5b                   	pop    %ebx
  801db0:	5e                   	pop    %esi
  801db1:	5f                   	pop    %edi
  801db2:	5d                   	pop    %ebp
  801db3:	c3                   	ret    
  801db4:	39 f0                	cmp    %esi,%eax
  801db6:	0f 87 ac 00 00 00    	ja     801e68 <__umoddi3+0xfc>
  801dbc:	0f bd e8             	bsr    %eax,%ebp
  801dbf:	83 f5 1f             	xor    $0x1f,%ebp
  801dc2:	0f 84 ac 00 00 00    	je     801e74 <__umoddi3+0x108>
  801dc8:	bf 20 00 00 00       	mov    $0x20,%edi
  801dcd:	29 ef                	sub    %ebp,%edi
  801dcf:	89 fe                	mov    %edi,%esi
  801dd1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801dd5:	89 e9                	mov    %ebp,%ecx
  801dd7:	d3 e0                	shl    %cl,%eax
  801dd9:	89 d7                	mov    %edx,%edi
  801ddb:	89 f1                	mov    %esi,%ecx
  801ddd:	d3 ef                	shr    %cl,%edi
  801ddf:	09 c7                	or     %eax,%edi
  801de1:	89 e9                	mov    %ebp,%ecx
  801de3:	d3 e2                	shl    %cl,%edx
  801de5:	89 14 24             	mov    %edx,(%esp)
  801de8:	89 d8                	mov    %ebx,%eax
  801dea:	d3 e0                	shl    %cl,%eax
  801dec:	89 c2                	mov    %eax,%edx
  801dee:	8b 44 24 08          	mov    0x8(%esp),%eax
  801df2:	d3 e0                	shl    %cl,%eax
  801df4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dfc:	89 f1                	mov    %esi,%ecx
  801dfe:	d3 e8                	shr    %cl,%eax
  801e00:	09 d0                	or     %edx,%eax
  801e02:	d3 eb                	shr    %cl,%ebx
  801e04:	89 da                	mov    %ebx,%edx
  801e06:	f7 f7                	div    %edi
  801e08:	89 d3                	mov    %edx,%ebx
  801e0a:	f7 24 24             	mull   (%esp)
  801e0d:	89 c6                	mov    %eax,%esi
  801e0f:	89 d1                	mov    %edx,%ecx
  801e11:	39 d3                	cmp    %edx,%ebx
  801e13:	0f 82 87 00 00 00    	jb     801ea0 <__umoddi3+0x134>
  801e19:	0f 84 91 00 00 00    	je     801eb0 <__umoddi3+0x144>
  801e1f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e23:	29 f2                	sub    %esi,%edx
  801e25:	19 cb                	sbb    %ecx,%ebx
  801e27:	89 d8                	mov    %ebx,%eax
  801e29:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e2d:	d3 e0                	shl    %cl,%eax
  801e2f:	89 e9                	mov    %ebp,%ecx
  801e31:	d3 ea                	shr    %cl,%edx
  801e33:	09 d0                	or     %edx,%eax
  801e35:	89 e9                	mov    %ebp,%ecx
  801e37:	d3 eb                	shr    %cl,%ebx
  801e39:	89 da                	mov    %ebx,%edx
  801e3b:	83 c4 1c             	add    $0x1c,%esp
  801e3e:	5b                   	pop    %ebx
  801e3f:	5e                   	pop    %esi
  801e40:	5f                   	pop    %edi
  801e41:	5d                   	pop    %ebp
  801e42:	c3                   	ret    
  801e43:	90                   	nop
  801e44:	89 fd                	mov    %edi,%ebp
  801e46:	85 ff                	test   %edi,%edi
  801e48:	75 0b                	jne    801e55 <__umoddi3+0xe9>
  801e4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4f:	31 d2                	xor    %edx,%edx
  801e51:	f7 f7                	div    %edi
  801e53:	89 c5                	mov    %eax,%ebp
  801e55:	89 f0                	mov    %esi,%eax
  801e57:	31 d2                	xor    %edx,%edx
  801e59:	f7 f5                	div    %ebp
  801e5b:	89 c8                	mov    %ecx,%eax
  801e5d:	f7 f5                	div    %ebp
  801e5f:	89 d0                	mov    %edx,%eax
  801e61:	e9 44 ff ff ff       	jmp    801daa <__umoddi3+0x3e>
  801e66:	66 90                	xchg   %ax,%ax
  801e68:	89 c8                	mov    %ecx,%eax
  801e6a:	89 f2                	mov    %esi,%edx
  801e6c:	83 c4 1c             	add    $0x1c,%esp
  801e6f:	5b                   	pop    %ebx
  801e70:	5e                   	pop    %esi
  801e71:	5f                   	pop    %edi
  801e72:	5d                   	pop    %ebp
  801e73:	c3                   	ret    
  801e74:	3b 04 24             	cmp    (%esp),%eax
  801e77:	72 06                	jb     801e7f <__umoddi3+0x113>
  801e79:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e7d:	77 0f                	ja     801e8e <__umoddi3+0x122>
  801e7f:	89 f2                	mov    %esi,%edx
  801e81:	29 f9                	sub    %edi,%ecx
  801e83:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e87:	89 14 24             	mov    %edx,(%esp)
  801e8a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e8e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e92:	8b 14 24             	mov    (%esp),%edx
  801e95:	83 c4 1c             	add    $0x1c,%esp
  801e98:	5b                   	pop    %ebx
  801e99:	5e                   	pop    %esi
  801e9a:	5f                   	pop    %edi
  801e9b:	5d                   	pop    %ebp
  801e9c:	c3                   	ret    
  801e9d:	8d 76 00             	lea    0x0(%esi),%esi
  801ea0:	2b 04 24             	sub    (%esp),%eax
  801ea3:	19 fa                	sbb    %edi,%edx
  801ea5:	89 d1                	mov    %edx,%ecx
  801ea7:	89 c6                	mov    %eax,%esi
  801ea9:	e9 71 ff ff ff       	jmp    801e1f <__umoddi3+0xb3>
  801eae:	66 90                	xchg   %ax,%ax
  801eb0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801eb4:	72 ea                	jb     801ea0 <__umoddi3+0x134>
  801eb6:	89 d9                	mov    %ebx,%ecx
  801eb8:	e9 62 ff ff ff       	jmp    801e1f <__umoddi3+0xb3>
