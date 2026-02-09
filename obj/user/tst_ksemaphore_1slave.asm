
obj/user/tst_ksemaphore_1slave:     file format elf32-i386


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
  800031:	e8 f4 01 00 00       	call   80022a <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
extern volatile bool printStats ;

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
	int32 parentenvID = sys_getparentenvid();
  800044:	e8 65 18 00 00       	call   8018ae <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int id = sys_getenvindex();
  80004c:	e8 44 18 00 00       	call   801895 <sys_getenvindex>
  800051:	89 45 e0             	mov    %eax,-0x20(%ebp)

	cprintf_colored(TEXT_light_blue, "%d: before the critical section\n", id);
  800054:	83 ec 04             	sub    $0x4,%esp
  800057:	ff 75 e0             	pushl  -0x20(%ebp)
  80005a:	68 80 1e 80 00       	push   $0x801e80
  80005f:	6a 09                	push   $0x9
  800061:	e8 8f 06 00 00       	call   8006f5 <cprintf_colored>
  800066:	83 c4 10             	add    $0x10,%esp
	//wait_semaphore(cs1);
	char waitCmd[64] = "__KSem@0@Wait";
  800069:	8d 45 98             	lea    -0x68(%ebp),%eax
  80006c:	bb aa 1f 80 00       	mov    $0x801faa,%ebx
  800071:	ba 0e 00 00 00       	mov    $0xe,%edx
  800076:	89 c7                	mov    %eax,%edi
  800078:	89 de                	mov    %ebx,%esi
  80007a:	89 d1                	mov    %edx,%ecx
  80007c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80007e:	8d 55 a6             	lea    -0x5a(%ebp),%edx
  800081:	b9 32 00 00 00       	mov    $0x32,%ecx
  800086:	b0 00                	mov    $0x0,%al
  800088:	89 d7                	mov    %edx,%edi
  80008a:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd, 0);
  80008c:	83 ec 08             	sub    $0x8,%esp
  80008f:	6a 00                	push   $0x0
  800091:	8d 45 98             	lea    -0x68(%ebp),%eax
  800094:	50                   	push   %eax
  800095:	e8 31 1a 00 00       	call   801acb <sys_utilities>
  80009a:	83 c4 10             	add    $0x10,%esp
	{
		cprintf_colored(TEXT_light_cyan, "%d: inside the critical section\n", id) ;
  80009d:	83 ec 04             	sub    $0x4,%esp
  8000a0:	ff 75 e0             	pushl  -0x20(%ebp)
  8000a3:	68 a4 1e 80 00       	push   $0x801ea4
  8000a8:	6a 0b                	push   $0xb
  8000aa:	e8 46 06 00 00       	call   8006f5 <cprintf_colored>
  8000af:	83 c4 10             	add    $0x10,%esp
		cprintf_colored(TEXT_light_cyan, "my ID is %d\n", id);
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	ff 75 e0             	pushl  -0x20(%ebp)
  8000b8:	68 c5 1e 80 00       	push   $0x801ec5
  8000bd:	6a 0b                	push   $0xb
  8000bf:	e8 31 06 00 00       	call   8006f5 <cprintf_colored>
  8000c4:	83 c4 10             	add    $0x10,%esp
		int sem1val ;
		char getCmd[64] = "__KSem@0@Get";
  8000c7:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  8000cd:	bb ea 1f 80 00       	mov    $0x801fea,%ebx
  8000d2:	ba 0d 00 00 00       	mov    $0xd,%edx
  8000d7:	89 c7                	mov    %eax,%edi
  8000d9:	89 de                	mov    %ebx,%esi
  8000db:	89 d1                	mov    %edx,%ecx
  8000dd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000df:	8d 95 e1 fe ff ff    	lea    -0x11f(%ebp),%edx
  8000e5:	b9 33 00 00 00       	mov    $0x33,%ecx
  8000ea:	b0 00                	mov    $0x0,%al
  8000ec:	89 d7                	mov    %edx,%edi
  8000ee:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(getCmd, (uint32)(&sem1val));
  8000f0:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  8000f6:	83 ec 08             	sub    $0x8,%esp
  8000f9:	50                   	push   %eax
  8000fa:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800100:	50                   	push   %eax
  800101:	e8 c5 19 00 00       	call   801acb <sys_utilities>
  800106:	83 c4 10             	add    $0x10,%esp
		if (sem1val > 0)
  800109:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  80010f:	85 c0                	test   %eax,%eax
  800111:	7e 14                	jle    800127 <_main+0xef>
			panic("Error: more than 1 process inside the CS... please review your semaphore code again...");
  800113:	83 ec 04             	sub    $0x4,%esp
  800116:	68 d4 1e 80 00       	push   $0x801ed4
  80011b:	6a 17                	push   $0x17
  80011d:	68 2b 1f 80 00       	push   $0x801f2b
  800122:	e8 b3 02 00 00       	call   8003da <_panic>
		env_sleep(RAND(1000, 5000)) ;
  800127:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80012a:	83 ec 0c             	sub    $0xc,%esp
  80012d:	50                   	push   %eax
  80012e:	e8 ae 17 00 00       	call   8018e1 <sys_get_virtual_time>
  800133:	83 c4 0c             	add    $0xc,%esp
  800136:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800139:	b9 a0 0f 00 00       	mov    $0xfa0,%ecx
  80013e:	ba 00 00 00 00       	mov    $0x0,%edx
  800143:	f7 f1                	div    %ecx
  800145:	89 d0                	mov    %edx,%eax
  800147:	05 e8 03 00 00       	add    $0x3e8,%eax
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	50                   	push   %eax
  800150:	e8 03 1a 00 00       	call   801b58 <env_sleep>
  800155:	83 c4 10             	add    $0x10,%esp
		cprintf_colored(TEXT_light_blue, "%d: leaving the critical section...\n", id);
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	ff 75 e0             	pushl  -0x20(%ebp)
  80015e:	68 48 1f 80 00       	push   $0x801f48
  800163:	6a 09                	push   $0x9
  800165:	e8 8b 05 00 00       	call   8006f5 <cprintf_colored>
  80016a:	83 c4 10             	add    $0x10,%esp
	}
	char signalCmd1[64] = "__KSem@0@Signal";
  80016d:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  800173:	bb 2a 20 80 00       	mov    $0x80202a,%ebx
  800178:	ba 04 00 00 00       	mov    $0x4,%edx
  80017d:	89 c7                	mov    %eax,%edi
  80017f:	89 de                	mov    %ebx,%esi
  800181:	89 d1                	mov    %edx,%ecx
  800183:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800185:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  80018b:	b9 0c 00 00 00       	mov    $0xc,%ecx
  800190:	b8 00 00 00 00       	mov    $0x0,%eax
  800195:	89 d7                	mov    %edx,%edi
  800197:	f3 ab                	rep stos %eax,%es:(%edi)
	sys_utilities(signalCmd1, 0);
  800199:	83 ec 08             	sub    $0x8,%esp
  80019c:	6a 00                	push   $0x0
  80019e:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  8001a4:	50                   	push   %eax
  8001a5:	e8 21 19 00 00       	call   801acb <sys_utilities>
  8001aa:	83 c4 10             	add    $0x10,%esp
	//signal_semaphore(cs1);
	cprintf_colored(TEXT_light_blue, "%d: after the critical section\n", id);
  8001ad:	83 ec 04             	sub    $0x4,%esp
  8001b0:	ff 75 e0             	pushl  -0x20(%ebp)
  8001b3:	68 70 1f 80 00       	push   $0x801f70
  8001b8:	6a 09                	push   $0x9
  8001ba:	e8 36 05 00 00       	call   8006f5 <cprintf_colored>
  8001bf:	83 c4 10             	add    $0x10,%esp

	//signal_semaphore(depend1);
	char signalCmd2[64] = "__KSem@1@Signal";
  8001c2:	8d 85 18 ff ff ff    	lea    -0xe8(%ebp),%eax
  8001c8:	bb 6a 20 80 00       	mov    $0x80206a,%ebx
  8001cd:	ba 04 00 00 00       	mov    $0x4,%edx
  8001d2:	89 c7                	mov    %eax,%edi
  8001d4:	89 de                	mov    %ebx,%esi
  8001d6:	89 d1                	mov    %edx,%ecx
  8001d8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8001da:	8d 95 28 ff ff ff    	lea    -0xd8(%ebp),%edx
  8001e0:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8001e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ea:	89 d7                	mov    %edx,%edi
  8001ec:	f3 ab                	rep stos %eax,%es:(%edi)
	sys_utilities(signalCmd2, 0);
  8001ee:	83 ec 08             	sub    $0x8,%esp
  8001f1:	6a 00                	push   $0x0
  8001f3:	8d 85 18 ff ff ff    	lea    -0xe8(%ebp),%eax
  8001f9:	50                   	push   %eax
  8001fa:	e8 cc 18 00 00       	call   801acb <sys_utilities>
  8001ff:	83 c4 10             	add    $0x10,%esp

	cprintf_colored(TEXT_light_magenta, ">>> Slave %d is Finished\n", id);
  800202:	83 ec 04             	sub    $0x4,%esp
  800205:	ff 75 e0             	pushl  -0x20(%ebp)
  800208:	68 90 1f 80 00       	push   $0x801f90
  80020d:	6a 0d                	push   $0xd
  80020f:	e8 e1 04 00 00       	call   8006f5 <cprintf_colored>
  800214:	83 c4 10             	add    $0x10,%esp
	printStats = 0;
  800217:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  80021e:	00 00 00 

	return;
  800221:	90                   	nop
}
  800222:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800225:	5b                   	pop    %ebx
  800226:	5e                   	pop    %esi
  800227:	5f                   	pop    %edi
  800228:	5d                   	pop    %ebp
  800229:	c3                   	ret    

0080022a <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80022a:	55                   	push   %ebp
  80022b:	89 e5                	mov    %esp,%ebp
  80022d:	57                   	push   %edi
  80022e:	56                   	push   %esi
  80022f:	53                   	push   %ebx
  800230:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800233:	e8 5d 16 00 00       	call   801895 <sys_getenvindex>
  800238:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80023b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80023e:	89 d0                	mov    %edx,%eax
  800240:	01 c0                	add    %eax,%eax
  800242:	01 d0                	add    %edx,%eax
  800244:	c1 e0 02             	shl    $0x2,%eax
  800247:	01 d0                	add    %edx,%eax
  800249:	c1 e0 02             	shl    $0x2,%eax
  80024c:	01 d0                	add    %edx,%eax
  80024e:	c1 e0 03             	shl    $0x3,%eax
  800251:	01 d0                	add    %edx,%eax
  800253:	c1 e0 02             	shl    $0x2,%eax
  800256:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80025b:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800260:	a1 20 30 80 00       	mov    0x803020,%eax
  800265:	8a 40 20             	mov    0x20(%eax),%al
  800268:	84 c0                	test   %al,%al
  80026a:	74 0d                	je     800279 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80026c:	a1 20 30 80 00       	mov    0x803020,%eax
  800271:	83 c0 20             	add    $0x20,%eax
  800274:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800279:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80027d:	7e 0a                	jle    800289 <libmain+0x5f>
		binaryname = argv[0];
  80027f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800282:	8b 00                	mov    (%eax),%eax
  800284:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800289:	83 ec 08             	sub    $0x8,%esp
  80028c:	ff 75 0c             	pushl  0xc(%ebp)
  80028f:	ff 75 08             	pushl  0x8(%ebp)
  800292:	e8 a1 fd ff ff       	call   800038 <_main>
  800297:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80029a:	a1 00 30 80 00       	mov    0x803000,%eax
  80029f:	85 c0                	test   %eax,%eax
  8002a1:	0f 84 01 01 00 00    	je     8003a8 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8002a7:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002ad:	bb a4 21 80 00       	mov    $0x8021a4,%ebx
  8002b2:	ba 0e 00 00 00       	mov    $0xe,%edx
  8002b7:	89 c7                	mov    %eax,%edi
  8002b9:	89 de                	mov    %ebx,%esi
  8002bb:	89 d1                	mov    %edx,%ecx
  8002bd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8002bf:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8002c2:	b9 56 00 00 00       	mov    $0x56,%ecx
  8002c7:	b0 00                	mov    $0x0,%al
  8002c9:	89 d7                	mov    %edx,%edi
  8002cb:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8002cd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8002d4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8002d7:	83 ec 08             	sub    $0x8,%esp
  8002da:	50                   	push   %eax
  8002db:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002e1:	50                   	push   %eax
  8002e2:	e8 e4 17 00 00       	call   801acb <sys_utilities>
  8002e7:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8002ea:	e8 2d 13 00 00       	call   80161c <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8002ef:	83 ec 0c             	sub    $0xc,%esp
  8002f2:	68 c4 20 80 00       	push   $0x8020c4
  8002f7:	e8 cc 03 00 00       	call   8006c8 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8002ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800302:	85 c0                	test   %eax,%eax
  800304:	74 18                	je     80031e <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800306:	e8 de 17 00 00       	call   801ae9 <sys_get_optimal_num_faults>
  80030b:	83 ec 08             	sub    $0x8,%esp
  80030e:	50                   	push   %eax
  80030f:	68 ec 20 80 00       	push   $0x8020ec
  800314:	e8 af 03 00 00       	call   8006c8 <cprintf>
  800319:	83 c4 10             	add    $0x10,%esp
  80031c:	eb 59                	jmp    800377 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80031e:	a1 20 30 80 00       	mov    0x803020,%eax
  800323:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800329:	a1 20 30 80 00       	mov    0x803020,%eax
  80032e:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800334:	83 ec 04             	sub    $0x4,%esp
  800337:	52                   	push   %edx
  800338:	50                   	push   %eax
  800339:	68 10 21 80 00       	push   $0x802110
  80033e:	e8 85 03 00 00       	call   8006c8 <cprintf>
  800343:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800346:	a1 20 30 80 00       	mov    0x803020,%eax
  80034b:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800351:	a1 20 30 80 00       	mov    0x803020,%eax
  800356:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  80035c:	a1 20 30 80 00       	mov    0x803020,%eax
  800361:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800367:	51                   	push   %ecx
  800368:	52                   	push   %edx
  800369:	50                   	push   %eax
  80036a:	68 38 21 80 00       	push   $0x802138
  80036f:	e8 54 03 00 00       	call   8006c8 <cprintf>
  800374:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800377:	a1 20 30 80 00       	mov    0x803020,%eax
  80037c:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800382:	83 ec 08             	sub    $0x8,%esp
  800385:	50                   	push   %eax
  800386:	68 90 21 80 00       	push   $0x802190
  80038b:	e8 38 03 00 00       	call   8006c8 <cprintf>
  800390:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800393:	83 ec 0c             	sub    $0xc,%esp
  800396:	68 c4 20 80 00       	push   $0x8020c4
  80039b:	e8 28 03 00 00       	call   8006c8 <cprintf>
  8003a0:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8003a3:	e8 8e 12 00 00       	call   801636 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8003a8:	e8 1f 00 00 00       	call   8003cc <exit>
}
  8003ad:	90                   	nop
  8003ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003b1:	5b                   	pop    %ebx
  8003b2:	5e                   	pop    %esi
  8003b3:	5f                   	pop    %edi
  8003b4:	5d                   	pop    %ebp
  8003b5:	c3                   	ret    

008003b6 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
  8003b9:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003bc:	83 ec 0c             	sub    $0xc,%esp
  8003bf:	6a 00                	push   $0x0
  8003c1:	e8 9b 14 00 00       	call   801861 <sys_destroy_env>
  8003c6:	83 c4 10             	add    $0x10,%esp
}
  8003c9:	90                   	nop
  8003ca:	c9                   	leave  
  8003cb:	c3                   	ret    

008003cc <exit>:

void
exit(void)
{
  8003cc:	55                   	push   %ebp
  8003cd:	89 e5                	mov    %esp,%ebp
  8003cf:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003d2:	e8 f0 14 00 00       	call   8018c7 <sys_exit_env>
}
  8003d7:	90                   	nop
  8003d8:	c9                   	leave  
  8003d9:	c3                   	ret    

008003da <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003da:	55                   	push   %ebp
  8003db:	89 e5                	mov    %esp,%ebp
  8003dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003e0:	8d 45 10             	lea    0x10(%ebp),%eax
  8003e3:	83 c0 04             	add    $0x4,%eax
  8003e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003e9:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8003ee:	85 c0                	test   %eax,%eax
  8003f0:	74 16                	je     800408 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003f2:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8003f7:	83 ec 08             	sub    $0x8,%esp
  8003fa:	50                   	push   %eax
  8003fb:	68 08 22 80 00       	push   $0x802208
  800400:	e8 c3 02 00 00       	call   8006c8 <cprintf>
  800405:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800408:	a1 04 30 80 00       	mov    0x803004,%eax
  80040d:	83 ec 0c             	sub    $0xc,%esp
  800410:	ff 75 0c             	pushl  0xc(%ebp)
  800413:	ff 75 08             	pushl  0x8(%ebp)
  800416:	50                   	push   %eax
  800417:	68 10 22 80 00       	push   $0x802210
  80041c:	6a 74                	push   $0x74
  80041e:	e8 d2 02 00 00       	call   8006f5 <cprintf_colored>
  800423:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800426:	8b 45 10             	mov    0x10(%ebp),%eax
  800429:	83 ec 08             	sub    $0x8,%esp
  80042c:	ff 75 f4             	pushl  -0xc(%ebp)
  80042f:	50                   	push   %eax
  800430:	e8 24 02 00 00       	call   800659 <vcprintf>
  800435:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800438:	83 ec 08             	sub    $0x8,%esp
  80043b:	6a 00                	push   $0x0
  80043d:	68 38 22 80 00       	push   $0x802238
  800442:	e8 12 02 00 00       	call   800659 <vcprintf>
  800447:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80044a:	e8 7d ff ff ff       	call   8003cc <exit>

	// should not return here
	while (1) ;
  80044f:	eb fe                	jmp    80044f <_panic+0x75>

00800451 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800451:	55                   	push   %ebp
  800452:	89 e5                	mov    %esp,%ebp
  800454:	53                   	push   %ebx
  800455:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800458:	a1 20 30 80 00       	mov    0x803020,%eax
  80045d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800463:	8b 45 0c             	mov    0xc(%ebp),%eax
  800466:	39 c2                	cmp    %eax,%edx
  800468:	74 14                	je     80047e <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80046a:	83 ec 04             	sub    $0x4,%esp
  80046d:	68 3c 22 80 00       	push   $0x80223c
  800472:	6a 26                	push   $0x26
  800474:	68 88 22 80 00       	push   $0x802288
  800479:	e8 5c ff ff ff       	call   8003da <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80047e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800485:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80048c:	e9 d9 00 00 00       	jmp    80056a <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800491:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800494:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80049b:	8b 45 08             	mov    0x8(%ebp),%eax
  80049e:	01 d0                	add    %edx,%eax
  8004a0:	8b 00                	mov    (%eax),%eax
  8004a2:	85 c0                	test   %eax,%eax
  8004a4:	75 08                	jne    8004ae <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8004a6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004a9:	e9 b9 00 00 00       	jmp    800567 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8004ae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004b5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004bc:	eb 79                	jmp    800537 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004be:	a1 20 30 80 00       	mov    0x803020,%eax
  8004c3:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8004c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004cc:	89 d0                	mov    %edx,%eax
  8004ce:	01 c0                	add    %eax,%eax
  8004d0:	01 d0                	add    %edx,%eax
  8004d2:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8004d9:	01 d8                	add    %ebx,%eax
  8004db:	01 d0                	add    %edx,%eax
  8004dd:	01 c8                	add    %ecx,%eax
  8004df:	8a 40 04             	mov    0x4(%eax),%al
  8004e2:	84 c0                	test   %al,%al
  8004e4:	75 4e                	jne    800534 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004e6:	a1 20 30 80 00       	mov    0x803020,%eax
  8004eb:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8004f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004f4:	89 d0                	mov    %edx,%eax
  8004f6:	01 c0                	add    %eax,%eax
  8004f8:	01 d0                	add    %edx,%eax
  8004fa:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800501:	01 d8                	add    %ebx,%eax
  800503:	01 d0                	add    %edx,%eax
  800505:	01 c8                	add    %ecx,%eax
  800507:	8b 00                	mov    (%eax),%eax
  800509:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80050c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80050f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800514:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800516:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800519:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800520:	8b 45 08             	mov    0x8(%ebp),%eax
  800523:	01 c8                	add    %ecx,%eax
  800525:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800527:	39 c2                	cmp    %eax,%edx
  800529:	75 09                	jne    800534 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  80052b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800532:	eb 19                	jmp    80054d <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800534:	ff 45 e8             	incl   -0x18(%ebp)
  800537:	a1 20 30 80 00       	mov    0x803020,%eax
  80053c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800542:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800545:	39 c2                	cmp    %eax,%edx
  800547:	0f 87 71 ff ff ff    	ja     8004be <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80054d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800551:	75 14                	jne    800567 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800553:	83 ec 04             	sub    $0x4,%esp
  800556:	68 94 22 80 00       	push   $0x802294
  80055b:	6a 3a                	push   $0x3a
  80055d:	68 88 22 80 00       	push   $0x802288
  800562:	e8 73 fe ff ff       	call   8003da <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800567:	ff 45 f0             	incl   -0x10(%ebp)
  80056a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800570:	0f 8c 1b ff ff ff    	jl     800491 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800576:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80057d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800584:	eb 2e                	jmp    8005b4 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800586:	a1 20 30 80 00       	mov    0x803020,%eax
  80058b:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800591:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800594:	89 d0                	mov    %edx,%eax
  800596:	01 c0                	add    %eax,%eax
  800598:	01 d0                	add    %edx,%eax
  80059a:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8005a1:	01 d8                	add    %ebx,%eax
  8005a3:	01 d0                	add    %edx,%eax
  8005a5:	01 c8                	add    %ecx,%eax
  8005a7:	8a 40 04             	mov    0x4(%eax),%al
  8005aa:	3c 01                	cmp    $0x1,%al
  8005ac:	75 03                	jne    8005b1 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  8005ae:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005b1:	ff 45 e0             	incl   -0x20(%ebp)
  8005b4:	a1 20 30 80 00       	mov    0x803020,%eax
  8005b9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005c2:	39 c2                	cmp    %eax,%edx
  8005c4:	77 c0                	ja     800586 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005c9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005cc:	74 14                	je     8005e2 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  8005ce:	83 ec 04             	sub    $0x4,%esp
  8005d1:	68 e8 22 80 00       	push   $0x8022e8
  8005d6:	6a 44                	push   $0x44
  8005d8:	68 88 22 80 00       	push   $0x802288
  8005dd:	e8 f8 fd ff ff       	call   8003da <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005e2:	90                   	nop
  8005e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005e6:	c9                   	leave  
  8005e7:	c3                   	ret    

008005e8 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005e8:	55                   	push   %ebp
  8005e9:	89 e5                	mov    %esp,%ebp
  8005eb:	53                   	push   %ebx
  8005ec:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8005ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f2:	8b 00                	mov    (%eax),%eax
  8005f4:	8d 48 01             	lea    0x1(%eax),%ecx
  8005f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005fa:	89 0a                	mov    %ecx,(%edx)
  8005fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8005ff:	88 d1                	mov    %dl,%cl
  800601:	8b 55 0c             	mov    0xc(%ebp),%edx
  800604:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800608:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060b:	8b 00                	mov    (%eax),%eax
  80060d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800612:	75 30                	jne    800644 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800614:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80061a:	a0 44 30 80 00       	mov    0x803044,%al
  80061f:	0f b6 c0             	movzbl %al,%eax
  800622:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800625:	8b 09                	mov    (%ecx),%ecx
  800627:	89 cb                	mov    %ecx,%ebx
  800629:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80062c:	83 c1 08             	add    $0x8,%ecx
  80062f:	52                   	push   %edx
  800630:	50                   	push   %eax
  800631:	53                   	push   %ebx
  800632:	51                   	push   %ecx
  800633:	e8 a0 0f 00 00       	call   8015d8 <sys_cputs>
  800638:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80063b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800644:	8b 45 0c             	mov    0xc(%ebp),%eax
  800647:	8b 40 04             	mov    0x4(%eax),%eax
  80064a:	8d 50 01             	lea    0x1(%eax),%edx
  80064d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800650:	89 50 04             	mov    %edx,0x4(%eax)
}
  800653:	90                   	nop
  800654:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800657:	c9                   	leave  
  800658:	c3                   	ret    

00800659 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800659:	55                   	push   %ebp
  80065a:	89 e5                	mov    %esp,%ebp
  80065c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800662:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800669:	00 00 00 
	b.cnt = 0;
  80066c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800673:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800676:	ff 75 0c             	pushl  0xc(%ebp)
  800679:	ff 75 08             	pushl  0x8(%ebp)
  80067c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800682:	50                   	push   %eax
  800683:	68 e8 05 80 00       	push   $0x8005e8
  800688:	e8 5a 02 00 00       	call   8008e7 <vprintfmt>
  80068d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800690:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800696:	a0 44 30 80 00       	mov    0x803044,%al
  80069b:	0f b6 c0             	movzbl %al,%eax
  80069e:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8006a4:	52                   	push   %edx
  8006a5:	50                   	push   %eax
  8006a6:	51                   	push   %ecx
  8006a7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006ad:	83 c0 08             	add    $0x8,%eax
  8006b0:	50                   	push   %eax
  8006b1:	e8 22 0f 00 00       	call   8015d8 <sys_cputs>
  8006b6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006b9:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8006c0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006c6:	c9                   	leave  
  8006c7:	c3                   	ret    

008006c8 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006c8:	55                   	push   %ebp
  8006c9:	89 e5                	mov    %esp,%ebp
  8006cb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006ce:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8006d5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	83 ec 08             	sub    $0x8,%esp
  8006e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8006e4:	50                   	push   %eax
  8006e5:	e8 6f ff ff ff       	call   800659 <vcprintf>
  8006ea:	83 c4 10             	add    $0x10,%esp
  8006ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006f3:	c9                   	leave  
  8006f4:	c3                   	ret    

008006f5 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8006f5:	55                   	push   %ebp
  8006f6:	89 e5                	mov    %esp,%ebp
  8006f8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006fb:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	c1 e0 08             	shl    $0x8,%eax
  800708:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  80070d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800710:	83 c0 04             	add    $0x4,%eax
  800713:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800716:	8b 45 0c             	mov    0xc(%ebp),%eax
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	ff 75 f4             	pushl  -0xc(%ebp)
  80071f:	50                   	push   %eax
  800720:	e8 34 ff ff ff       	call   800659 <vcprintf>
  800725:	83 c4 10             	add    $0x10,%esp
  800728:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80072b:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800732:	07 00 00 

	return cnt;
  800735:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800738:	c9                   	leave  
  800739:	c3                   	ret    

0080073a <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80073a:	55                   	push   %ebp
  80073b:	89 e5                	mov    %esp,%ebp
  80073d:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800740:	e8 d7 0e 00 00       	call   80161c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800745:	8d 45 0c             	lea    0xc(%ebp),%eax
  800748:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	ff 75 f4             	pushl  -0xc(%ebp)
  800754:	50                   	push   %eax
  800755:	e8 ff fe ff ff       	call   800659 <vcprintf>
  80075a:	83 c4 10             	add    $0x10,%esp
  80075d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800760:	e8 d1 0e 00 00       	call   801636 <sys_unlock_cons>
	return cnt;
  800765:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800768:	c9                   	leave  
  800769:	c3                   	ret    

0080076a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	53                   	push   %ebx
  80076e:	83 ec 14             	sub    $0x14,%esp
  800771:	8b 45 10             	mov    0x10(%ebp),%eax
  800774:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800777:	8b 45 14             	mov    0x14(%ebp),%eax
  80077a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80077d:	8b 45 18             	mov    0x18(%ebp),%eax
  800780:	ba 00 00 00 00       	mov    $0x0,%edx
  800785:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800788:	77 55                	ja     8007df <printnum+0x75>
  80078a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80078d:	72 05                	jb     800794 <printnum+0x2a>
  80078f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800792:	77 4b                	ja     8007df <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800794:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800797:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80079a:	8b 45 18             	mov    0x18(%ebp),%eax
  80079d:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a2:	52                   	push   %edx
  8007a3:	50                   	push   %eax
  8007a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8007aa:	e8 69 14 00 00       	call   801c18 <__udivdi3>
  8007af:	83 c4 10             	add    $0x10,%esp
  8007b2:	83 ec 04             	sub    $0x4,%esp
  8007b5:	ff 75 20             	pushl  0x20(%ebp)
  8007b8:	53                   	push   %ebx
  8007b9:	ff 75 18             	pushl  0x18(%ebp)
  8007bc:	52                   	push   %edx
  8007bd:	50                   	push   %eax
  8007be:	ff 75 0c             	pushl  0xc(%ebp)
  8007c1:	ff 75 08             	pushl  0x8(%ebp)
  8007c4:	e8 a1 ff ff ff       	call   80076a <printnum>
  8007c9:	83 c4 20             	add    $0x20,%esp
  8007cc:	eb 1a                	jmp    8007e8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007ce:	83 ec 08             	sub    $0x8,%esp
  8007d1:	ff 75 0c             	pushl  0xc(%ebp)
  8007d4:	ff 75 20             	pushl  0x20(%ebp)
  8007d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007da:	ff d0                	call   *%eax
  8007dc:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007df:	ff 4d 1c             	decl   0x1c(%ebp)
  8007e2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8007e6:	7f e6                	jg     8007ce <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007e8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8007eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007f6:	53                   	push   %ebx
  8007f7:	51                   	push   %ecx
  8007f8:	52                   	push   %edx
  8007f9:	50                   	push   %eax
  8007fa:	e8 29 15 00 00       	call   801d28 <__umoddi3>
  8007ff:	83 c4 10             	add    $0x10,%esp
  800802:	05 54 25 80 00       	add    $0x802554,%eax
  800807:	8a 00                	mov    (%eax),%al
  800809:	0f be c0             	movsbl %al,%eax
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	ff 75 0c             	pushl  0xc(%ebp)
  800812:	50                   	push   %eax
  800813:	8b 45 08             	mov    0x8(%ebp),%eax
  800816:	ff d0                	call   *%eax
  800818:	83 c4 10             	add    $0x10,%esp
}
  80081b:	90                   	nop
  80081c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80081f:	c9                   	leave  
  800820:	c3                   	ret    

00800821 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800821:	55                   	push   %ebp
  800822:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800824:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800828:	7e 1c                	jle    800846 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80082a:	8b 45 08             	mov    0x8(%ebp),%eax
  80082d:	8b 00                	mov    (%eax),%eax
  80082f:	8d 50 08             	lea    0x8(%eax),%edx
  800832:	8b 45 08             	mov    0x8(%ebp),%eax
  800835:	89 10                	mov    %edx,(%eax)
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	8b 00                	mov    (%eax),%eax
  80083c:	83 e8 08             	sub    $0x8,%eax
  80083f:	8b 50 04             	mov    0x4(%eax),%edx
  800842:	8b 00                	mov    (%eax),%eax
  800844:	eb 40                	jmp    800886 <getuint+0x65>
	else if (lflag)
  800846:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80084a:	74 1e                	je     80086a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	8b 00                	mov    (%eax),%eax
  800851:	8d 50 04             	lea    0x4(%eax),%edx
  800854:	8b 45 08             	mov    0x8(%ebp),%eax
  800857:	89 10                	mov    %edx,(%eax)
  800859:	8b 45 08             	mov    0x8(%ebp),%eax
  80085c:	8b 00                	mov    (%eax),%eax
  80085e:	83 e8 04             	sub    $0x4,%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	ba 00 00 00 00       	mov    $0x0,%edx
  800868:	eb 1c                	jmp    800886 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	8d 50 04             	lea    0x4(%eax),%edx
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	89 10                	mov    %edx,(%eax)
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	8b 00                	mov    (%eax),%eax
  80087c:	83 e8 04             	sub    $0x4,%eax
  80087f:	8b 00                	mov    (%eax),%eax
  800881:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800886:	5d                   	pop    %ebp
  800887:	c3                   	ret    

00800888 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80088b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80088f:	7e 1c                	jle    8008ad <getint+0x25>
		return va_arg(*ap, long long);
  800891:	8b 45 08             	mov    0x8(%ebp),%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	8d 50 08             	lea    0x8(%eax),%edx
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	89 10                	mov    %edx,(%eax)
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	8b 00                	mov    (%eax),%eax
  8008a3:	83 e8 08             	sub    $0x8,%eax
  8008a6:	8b 50 04             	mov    0x4(%eax),%edx
  8008a9:	8b 00                	mov    (%eax),%eax
  8008ab:	eb 38                	jmp    8008e5 <getint+0x5d>
	else if (lflag)
  8008ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008b1:	74 1a                	je     8008cd <getint+0x45>
		return va_arg(*ap, long);
  8008b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b6:	8b 00                	mov    (%eax),%eax
  8008b8:	8d 50 04             	lea    0x4(%eax),%edx
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	89 10                	mov    %edx,(%eax)
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	8b 00                	mov    (%eax),%eax
  8008c5:	83 e8 04             	sub    $0x4,%eax
  8008c8:	8b 00                	mov    (%eax),%eax
  8008ca:	99                   	cltd   
  8008cb:	eb 18                	jmp    8008e5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	8d 50 04             	lea    0x4(%eax),%edx
  8008d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d8:	89 10                	mov    %edx,(%eax)
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	8b 00                	mov    (%eax),%eax
  8008df:	83 e8 04             	sub    $0x4,%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	99                   	cltd   
}
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    

008008e7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	56                   	push   %esi
  8008eb:	53                   	push   %ebx
  8008ec:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008ef:	eb 17                	jmp    800908 <vprintfmt+0x21>
			if (ch == '\0')
  8008f1:	85 db                	test   %ebx,%ebx
  8008f3:	0f 84 c1 03 00 00    	je     800cba <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8008f9:	83 ec 08             	sub    $0x8,%esp
  8008fc:	ff 75 0c             	pushl  0xc(%ebp)
  8008ff:	53                   	push   %ebx
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	ff d0                	call   *%eax
  800905:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800908:	8b 45 10             	mov    0x10(%ebp),%eax
  80090b:	8d 50 01             	lea    0x1(%eax),%edx
  80090e:	89 55 10             	mov    %edx,0x10(%ebp)
  800911:	8a 00                	mov    (%eax),%al
  800913:	0f b6 d8             	movzbl %al,%ebx
  800916:	83 fb 25             	cmp    $0x25,%ebx
  800919:	75 d6                	jne    8008f1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80091b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80091f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800926:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80092d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800934:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80093b:	8b 45 10             	mov    0x10(%ebp),%eax
  80093e:	8d 50 01             	lea    0x1(%eax),%edx
  800941:	89 55 10             	mov    %edx,0x10(%ebp)
  800944:	8a 00                	mov    (%eax),%al
  800946:	0f b6 d8             	movzbl %al,%ebx
  800949:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80094c:	83 f8 5b             	cmp    $0x5b,%eax
  80094f:	0f 87 3d 03 00 00    	ja     800c92 <vprintfmt+0x3ab>
  800955:	8b 04 85 78 25 80 00 	mov    0x802578(,%eax,4),%eax
  80095c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80095e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800962:	eb d7                	jmp    80093b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800964:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800968:	eb d1                	jmp    80093b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80096a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800971:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800974:	89 d0                	mov    %edx,%eax
  800976:	c1 e0 02             	shl    $0x2,%eax
  800979:	01 d0                	add    %edx,%eax
  80097b:	01 c0                	add    %eax,%eax
  80097d:	01 d8                	add    %ebx,%eax
  80097f:	83 e8 30             	sub    $0x30,%eax
  800982:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800985:	8b 45 10             	mov    0x10(%ebp),%eax
  800988:	8a 00                	mov    (%eax),%al
  80098a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80098d:	83 fb 2f             	cmp    $0x2f,%ebx
  800990:	7e 3e                	jle    8009d0 <vprintfmt+0xe9>
  800992:	83 fb 39             	cmp    $0x39,%ebx
  800995:	7f 39                	jg     8009d0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800997:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80099a:	eb d5                	jmp    800971 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80099c:	8b 45 14             	mov    0x14(%ebp),%eax
  80099f:	83 c0 04             	add    $0x4,%eax
  8009a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a8:	83 e8 04             	sub    $0x4,%eax
  8009ab:	8b 00                	mov    (%eax),%eax
  8009ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009b0:	eb 1f                	jmp    8009d1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b6:	79 83                	jns    80093b <vprintfmt+0x54>
				width = 0;
  8009b8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009bf:	e9 77 ff ff ff       	jmp    80093b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009c4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009cb:	e9 6b ff ff ff       	jmp    80093b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009d0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d5:	0f 89 60 ff ff ff    	jns    80093b <vprintfmt+0x54>
				width = precision, precision = -1;
  8009db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009e1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8009e8:	e9 4e ff ff ff       	jmp    80093b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009ed:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009f0:	e9 46 ff ff ff       	jmp    80093b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f8:	83 c0 04             	add    $0x4,%eax
  8009fb:	89 45 14             	mov    %eax,0x14(%ebp)
  8009fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800a01:	83 e8 04             	sub    $0x4,%eax
  800a04:	8b 00                	mov    (%eax),%eax
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	ff 75 0c             	pushl  0xc(%ebp)
  800a0c:	50                   	push   %eax
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	ff d0                	call   *%eax
  800a12:	83 c4 10             	add    $0x10,%esp
			break;
  800a15:	e9 9b 02 00 00       	jmp    800cb5 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1d:	83 c0 04             	add    $0x4,%eax
  800a20:	89 45 14             	mov    %eax,0x14(%ebp)
  800a23:	8b 45 14             	mov    0x14(%ebp),%eax
  800a26:	83 e8 04             	sub    $0x4,%eax
  800a29:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a2b:	85 db                	test   %ebx,%ebx
  800a2d:	79 02                	jns    800a31 <vprintfmt+0x14a>
				err = -err;
  800a2f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a31:	83 fb 64             	cmp    $0x64,%ebx
  800a34:	7f 0b                	jg     800a41 <vprintfmt+0x15a>
  800a36:	8b 34 9d c0 23 80 00 	mov    0x8023c0(,%ebx,4),%esi
  800a3d:	85 f6                	test   %esi,%esi
  800a3f:	75 19                	jne    800a5a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a41:	53                   	push   %ebx
  800a42:	68 65 25 80 00       	push   $0x802565
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	ff 75 08             	pushl  0x8(%ebp)
  800a4d:	e8 70 02 00 00       	call   800cc2 <printfmt>
  800a52:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a55:	e9 5b 02 00 00       	jmp    800cb5 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a5a:	56                   	push   %esi
  800a5b:	68 6e 25 80 00       	push   $0x80256e
  800a60:	ff 75 0c             	pushl  0xc(%ebp)
  800a63:	ff 75 08             	pushl  0x8(%ebp)
  800a66:	e8 57 02 00 00       	call   800cc2 <printfmt>
  800a6b:	83 c4 10             	add    $0x10,%esp
			break;
  800a6e:	e9 42 02 00 00       	jmp    800cb5 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a73:	8b 45 14             	mov    0x14(%ebp),%eax
  800a76:	83 c0 04             	add    $0x4,%eax
  800a79:	89 45 14             	mov    %eax,0x14(%ebp)
  800a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7f:	83 e8 04             	sub    $0x4,%eax
  800a82:	8b 30                	mov    (%eax),%esi
  800a84:	85 f6                	test   %esi,%esi
  800a86:	75 05                	jne    800a8d <vprintfmt+0x1a6>
				p = "(null)";
  800a88:	be 71 25 80 00       	mov    $0x802571,%esi
			if (width > 0 && padc != '-')
  800a8d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a91:	7e 6d                	jle    800b00 <vprintfmt+0x219>
  800a93:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a97:	74 67                	je     800b00 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a9c:	83 ec 08             	sub    $0x8,%esp
  800a9f:	50                   	push   %eax
  800aa0:	56                   	push   %esi
  800aa1:	e8 1e 03 00 00       	call   800dc4 <strnlen>
  800aa6:	83 c4 10             	add    $0x10,%esp
  800aa9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800aac:	eb 16                	jmp    800ac4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800aae:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ab2:	83 ec 08             	sub    $0x8,%esp
  800ab5:	ff 75 0c             	pushl  0xc(%ebp)
  800ab8:	50                   	push   %eax
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	ff d0                	call   *%eax
  800abe:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ac1:	ff 4d e4             	decl   -0x1c(%ebp)
  800ac4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac8:	7f e4                	jg     800aae <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aca:	eb 34                	jmp    800b00 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800acc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ad0:	74 1c                	je     800aee <vprintfmt+0x207>
  800ad2:	83 fb 1f             	cmp    $0x1f,%ebx
  800ad5:	7e 05                	jle    800adc <vprintfmt+0x1f5>
  800ad7:	83 fb 7e             	cmp    $0x7e,%ebx
  800ada:	7e 12                	jle    800aee <vprintfmt+0x207>
					putch('?', putdat);
  800adc:	83 ec 08             	sub    $0x8,%esp
  800adf:	ff 75 0c             	pushl  0xc(%ebp)
  800ae2:	6a 3f                	push   $0x3f
  800ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae7:	ff d0                	call   *%eax
  800ae9:	83 c4 10             	add    $0x10,%esp
  800aec:	eb 0f                	jmp    800afd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800aee:	83 ec 08             	sub    $0x8,%esp
  800af1:	ff 75 0c             	pushl  0xc(%ebp)
  800af4:	53                   	push   %ebx
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	ff d0                	call   *%eax
  800afa:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800afd:	ff 4d e4             	decl   -0x1c(%ebp)
  800b00:	89 f0                	mov    %esi,%eax
  800b02:	8d 70 01             	lea    0x1(%eax),%esi
  800b05:	8a 00                	mov    (%eax),%al
  800b07:	0f be d8             	movsbl %al,%ebx
  800b0a:	85 db                	test   %ebx,%ebx
  800b0c:	74 24                	je     800b32 <vprintfmt+0x24b>
  800b0e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b12:	78 b8                	js     800acc <vprintfmt+0x1e5>
  800b14:	ff 4d e0             	decl   -0x20(%ebp)
  800b17:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b1b:	79 af                	jns    800acc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b1d:	eb 13                	jmp    800b32 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b1f:	83 ec 08             	sub    $0x8,%esp
  800b22:	ff 75 0c             	pushl  0xc(%ebp)
  800b25:	6a 20                	push   $0x20
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	ff d0                	call   *%eax
  800b2c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b2f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b32:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b36:	7f e7                	jg     800b1f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b38:	e9 78 01 00 00       	jmp    800cb5 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b3d:	83 ec 08             	sub    $0x8,%esp
  800b40:	ff 75 e8             	pushl  -0x18(%ebp)
  800b43:	8d 45 14             	lea    0x14(%ebp),%eax
  800b46:	50                   	push   %eax
  800b47:	e8 3c fd ff ff       	call   800888 <getint>
  800b4c:	83 c4 10             	add    $0x10,%esp
  800b4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b52:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b5b:	85 d2                	test   %edx,%edx
  800b5d:	79 23                	jns    800b82 <vprintfmt+0x29b>
				putch('-', putdat);
  800b5f:	83 ec 08             	sub    $0x8,%esp
  800b62:	ff 75 0c             	pushl  0xc(%ebp)
  800b65:	6a 2d                	push   $0x2d
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	ff d0                	call   *%eax
  800b6c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b75:	f7 d8                	neg    %eax
  800b77:	83 d2 00             	adc    $0x0,%edx
  800b7a:	f7 da                	neg    %edx
  800b7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b7f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b82:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b89:	e9 bc 00 00 00       	jmp    800c4a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b8e:	83 ec 08             	sub    $0x8,%esp
  800b91:	ff 75 e8             	pushl  -0x18(%ebp)
  800b94:	8d 45 14             	lea    0x14(%ebp),%eax
  800b97:	50                   	push   %eax
  800b98:	e8 84 fc ff ff       	call   800821 <getuint>
  800b9d:	83 c4 10             	add    $0x10,%esp
  800ba0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ba6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bad:	e9 98 00 00 00       	jmp    800c4a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bb2:	83 ec 08             	sub    $0x8,%esp
  800bb5:	ff 75 0c             	pushl  0xc(%ebp)
  800bb8:	6a 58                	push   $0x58
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	ff d0                	call   *%eax
  800bbf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bc2:	83 ec 08             	sub    $0x8,%esp
  800bc5:	ff 75 0c             	pushl  0xc(%ebp)
  800bc8:	6a 58                	push   $0x58
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	ff d0                	call   *%eax
  800bcf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bd2:	83 ec 08             	sub    $0x8,%esp
  800bd5:	ff 75 0c             	pushl  0xc(%ebp)
  800bd8:	6a 58                	push   $0x58
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	ff d0                	call   *%eax
  800bdf:	83 c4 10             	add    $0x10,%esp
			break;
  800be2:	e9 ce 00 00 00       	jmp    800cb5 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800be7:	83 ec 08             	sub    $0x8,%esp
  800bea:	ff 75 0c             	pushl  0xc(%ebp)
  800bed:	6a 30                	push   $0x30
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	ff d0                	call   *%eax
  800bf4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800bf7:	83 ec 08             	sub    $0x8,%esp
  800bfa:	ff 75 0c             	pushl  0xc(%ebp)
  800bfd:	6a 78                	push   $0x78
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	ff d0                	call   *%eax
  800c04:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c07:	8b 45 14             	mov    0x14(%ebp),%eax
  800c0a:	83 c0 04             	add    $0x4,%eax
  800c0d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c10:	8b 45 14             	mov    0x14(%ebp),%eax
  800c13:	83 e8 04             	sub    $0x4,%eax
  800c16:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c22:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c29:	eb 1f                	jmp    800c4a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c2b:	83 ec 08             	sub    $0x8,%esp
  800c2e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c31:	8d 45 14             	lea    0x14(%ebp),%eax
  800c34:	50                   	push   %eax
  800c35:	e8 e7 fb ff ff       	call   800821 <getuint>
  800c3a:	83 c4 10             	add    $0x10,%esp
  800c3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c40:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c43:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c4a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c51:	83 ec 04             	sub    $0x4,%esp
  800c54:	52                   	push   %edx
  800c55:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c58:	50                   	push   %eax
  800c59:	ff 75 f4             	pushl  -0xc(%ebp)
  800c5c:	ff 75 f0             	pushl  -0x10(%ebp)
  800c5f:	ff 75 0c             	pushl  0xc(%ebp)
  800c62:	ff 75 08             	pushl  0x8(%ebp)
  800c65:	e8 00 fb ff ff       	call   80076a <printnum>
  800c6a:	83 c4 20             	add    $0x20,%esp
			break;
  800c6d:	eb 46                	jmp    800cb5 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c6f:	83 ec 08             	sub    $0x8,%esp
  800c72:	ff 75 0c             	pushl  0xc(%ebp)
  800c75:	53                   	push   %ebx
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	ff d0                	call   *%eax
  800c7b:	83 c4 10             	add    $0x10,%esp
			break;
  800c7e:	eb 35                	jmp    800cb5 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c80:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800c87:	eb 2c                	jmp    800cb5 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c89:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800c90:	eb 23                	jmp    800cb5 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c92:	83 ec 08             	sub    $0x8,%esp
  800c95:	ff 75 0c             	pushl  0xc(%ebp)
  800c98:	6a 25                	push   $0x25
  800c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9d:	ff d0                	call   *%eax
  800c9f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ca2:	ff 4d 10             	decl   0x10(%ebp)
  800ca5:	eb 03                	jmp    800caa <vprintfmt+0x3c3>
  800ca7:	ff 4d 10             	decl   0x10(%ebp)
  800caa:	8b 45 10             	mov    0x10(%ebp),%eax
  800cad:	48                   	dec    %eax
  800cae:	8a 00                	mov    (%eax),%al
  800cb0:	3c 25                	cmp    $0x25,%al
  800cb2:	75 f3                	jne    800ca7 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800cb4:	90                   	nop
		}
	}
  800cb5:	e9 35 fc ff ff       	jmp    8008ef <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cba:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cbb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cbe:	5b                   	pop    %ebx
  800cbf:	5e                   	pop    %esi
  800cc0:	5d                   	pop    %ebp
  800cc1:	c3                   	ret    

00800cc2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cc8:	8d 45 10             	lea    0x10(%ebp),%eax
  800ccb:	83 c0 04             	add    $0x4,%eax
  800cce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd4:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd7:	50                   	push   %eax
  800cd8:	ff 75 0c             	pushl  0xc(%ebp)
  800cdb:	ff 75 08             	pushl  0x8(%ebp)
  800cde:	e8 04 fc ff ff       	call   8008e7 <vprintfmt>
  800ce3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ce6:	90                   	nop
  800ce7:	c9                   	leave  
  800ce8:	c3                   	ret    

00800ce9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800cec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cef:	8b 40 08             	mov    0x8(%eax),%eax
  800cf2:	8d 50 01             	lea    0x1(%eax),%edx
  800cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfe:	8b 10                	mov    (%eax),%edx
  800d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d03:	8b 40 04             	mov    0x4(%eax),%eax
  800d06:	39 c2                	cmp    %eax,%edx
  800d08:	73 12                	jae    800d1c <sprintputch+0x33>
		*b->buf++ = ch;
  800d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0d:	8b 00                	mov    (%eax),%eax
  800d0f:	8d 48 01             	lea    0x1(%eax),%ecx
  800d12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d15:	89 0a                	mov    %ecx,(%edx)
  800d17:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1a:	88 10                	mov    %dl,(%eax)
}
  800d1c:	90                   	nop
  800d1d:	5d                   	pop    %ebp
  800d1e:	c3                   	ret    

00800d1f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
  800d22:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	01 d0                	add    %edx,%eax
  800d36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d44:	74 06                	je     800d4c <vsnprintf+0x2d>
  800d46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d4a:	7f 07                	jg     800d53 <vsnprintf+0x34>
		return -E_INVAL;
  800d4c:	b8 03 00 00 00       	mov    $0x3,%eax
  800d51:	eb 20                	jmp    800d73 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d53:	ff 75 14             	pushl  0x14(%ebp)
  800d56:	ff 75 10             	pushl  0x10(%ebp)
  800d59:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d5c:	50                   	push   %eax
  800d5d:	68 e9 0c 80 00       	push   $0x800ce9
  800d62:	e8 80 fb ff ff       	call   8008e7 <vprintfmt>
  800d67:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d6d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d73:	c9                   	leave  
  800d74:	c3                   	ret    

00800d75 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d7b:	8d 45 10             	lea    0x10(%ebp),%eax
  800d7e:	83 c0 04             	add    $0x4,%eax
  800d81:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d84:	8b 45 10             	mov    0x10(%ebp),%eax
  800d87:	ff 75 f4             	pushl  -0xc(%ebp)
  800d8a:	50                   	push   %eax
  800d8b:	ff 75 0c             	pushl  0xc(%ebp)
  800d8e:	ff 75 08             	pushl  0x8(%ebp)
  800d91:	e8 89 ff ff ff       	call   800d1f <vsnprintf>
  800d96:	83 c4 10             	add    $0x10,%esp
  800d99:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d9f:	c9                   	leave  
  800da0:	c3                   	ret    

00800da1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800da1:	55                   	push   %ebp
  800da2:	89 e5                	mov    %esp,%ebp
  800da4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800da7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dae:	eb 06                	jmp    800db6 <strlen+0x15>
		n++;
  800db0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800db3:	ff 45 08             	incl   0x8(%ebp)
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	84 c0                	test   %al,%al
  800dbd:	75 f1                	jne    800db0 <strlen+0xf>
		n++;
	return n;
  800dbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dc2:	c9                   	leave  
  800dc3:	c3                   	ret    

00800dc4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dd1:	eb 09                	jmp    800ddc <strnlen+0x18>
		n++;
  800dd3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dd6:	ff 45 08             	incl   0x8(%ebp)
  800dd9:	ff 4d 0c             	decl   0xc(%ebp)
  800ddc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de0:	74 09                	je     800deb <strnlen+0x27>
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	84 c0                	test   %al,%al
  800de9:	75 e8                	jne    800dd3 <strnlen+0xf>
		n++;
	return n;
  800deb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dee:	c9                   	leave  
  800def:	c3                   	ret    

00800df0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800dfc:	90                   	nop
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8d 50 01             	lea    0x1(%eax),%edx
  800e03:	89 55 08             	mov    %edx,0x8(%ebp)
  800e06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e09:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e0c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e0f:	8a 12                	mov    (%edx),%dl
  800e11:	88 10                	mov    %dl,(%eax)
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	84 c0                	test   %al,%al
  800e17:	75 e4                	jne    800dfd <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e19:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e1c:	c9                   	leave  
  800e1d:	c3                   	ret    

00800e1e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e31:	eb 1f                	jmp    800e52 <strncpy+0x34>
		*dst++ = *src;
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	8d 50 01             	lea    0x1(%eax),%edx
  800e39:	89 55 08             	mov    %edx,0x8(%ebp)
  800e3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3f:	8a 12                	mov    (%edx),%dl
  800e41:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	8a 00                	mov    (%eax),%al
  800e48:	84 c0                	test   %al,%al
  800e4a:	74 03                	je     800e4f <strncpy+0x31>
			src++;
  800e4c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e4f:	ff 45 fc             	incl   -0x4(%ebp)
  800e52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e55:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e58:	72 d9                	jb     800e33 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e5d:	c9                   	leave  
  800e5e:	c3                   	ret    

00800e5f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e6f:	74 30                	je     800ea1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e71:	eb 16                	jmp    800e89 <strlcpy+0x2a>
			*dst++ = *src++;
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	8d 50 01             	lea    0x1(%eax),%edx
  800e79:	89 55 08             	mov    %edx,0x8(%ebp)
  800e7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e82:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e85:	8a 12                	mov    (%edx),%dl
  800e87:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e89:	ff 4d 10             	decl   0x10(%ebp)
  800e8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e90:	74 09                	je     800e9b <strlcpy+0x3c>
  800e92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e95:	8a 00                	mov    (%eax),%al
  800e97:	84 c0                	test   %al,%al
  800e99:	75 d8                	jne    800e73 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ea1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea7:	29 c2                	sub    %eax,%edx
  800ea9:	89 d0                	mov    %edx,%eax
}
  800eab:	c9                   	leave  
  800eac:	c3                   	ret    

00800ead <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800eb0:	eb 06                	jmp    800eb8 <strcmp+0xb>
		p++, q++;
  800eb2:	ff 45 08             	incl   0x8(%ebp)
  800eb5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	84 c0                	test   %al,%al
  800ebf:	74 0e                	je     800ecf <strcmp+0x22>
  800ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec4:	8a 10                	mov    (%eax),%dl
  800ec6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	38 c2                	cmp    %al,%dl
  800ecd:	74 e3                	je     800eb2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed2:	8a 00                	mov    (%eax),%al
  800ed4:	0f b6 d0             	movzbl %al,%edx
  800ed7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	0f b6 c0             	movzbl %al,%eax
  800edf:	29 c2                	sub    %eax,%edx
  800ee1:	89 d0                	mov    %edx,%eax
}
  800ee3:	5d                   	pop    %ebp
  800ee4:	c3                   	ret    

00800ee5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ee8:	eb 09                	jmp    800ef3 <strncmp+0xe>
		n--, p++, q++;
  800eea:	ff 4d 10             	decl   0x10(%ebp)
  800eed:	ff 45 08             	incl   0x8(%ebp)
  800ef0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ef3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef7:	74 17                	je     800f10 <strncmp+0x2b>
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	8a 00                	mov    (%eax),%al
  800efe:	84 c0                	test   %al,%al
  800f00:	74 0e                	je     800f10 <strncmp+0x2b>
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	8a 10                	mov    (%eax),%dl
  800f07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	38 c2                	cmp    %al,%dl
  800f0e:	74 da                	je     800eea <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f10:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f14:	75 07                	jne    800f1d <strncmp+0x38>
		return 0;
  800f16:	b8 00 00 00 00       	mov    $0x0,%eax
  800f1b:	eb 14                	jmp    800f31 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	8a 00                	mov    (%eax),%al
  800f22:	0f b6 d0             	movzbl %al,%edx
  800f25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f28:	8a 00                	mov    (%eax),%al
  800f2a:	0f b6 c0             	movzbl %al,%eax
  800f2d:	29 c2                	sub    %eax,%edx
  800f2f:	89 d0                	mov    %edx,%eax
}
  800f31:	5d                   	pop    %ebp
  800f32:	c3                   	ret    

00800f33 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f33:	55                   	push   %ebp
  800f34:	89 e5                	mov    %esp,%ebp
  800f36:	83 ec 04             	sub    $0x4,%esp
  800f39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f3f:	eb 12                	jmp    800f53 <strchr+0x20>
		if (*s == c)
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	8a 00                	mov    (%eax),%al
  800f46:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f49:	75 05                	jne    800f50 <strchr+0x1d>
			return (char *) s;
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	eb 11                	jmp    800f61 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f50:	ff 45 08             	incl   0x8(%ebp)
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	84 c0                	test   %al,%al
  800f5a:	75 e5                	jne    800f41 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f61:	c9                   	leave  
  800f62:	c3                   	ret    

00800f63 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	83 ec 04             	sub    $0x4,%esp
  800f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f6f:	eb 0d                	jmp    800f7e <strfind+0x1b>
		if (*s == c)
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f79:	74 0e                	je     800f89 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f7b:	ff 45 08             	incl   0x8(%ebp)
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	84 c0                	test   %al,%al
  800f85:	75 ea                	jne    800f71 <strfind+0xe>
  800f87:	eb 01                	jmp    800f8a <strfind+0x27>
		if (*s == c)
			break;
  800f89:	90                   	nop
	return (char *) s;
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f8d:	c9                   	leave  
  800f8e:	c3                   	ret    

00800f8f <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800f8f:	55                   	push   %ebp
  800f90:	89 e5                	mov    %esp,%ebp
  800f92:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
  800f98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800f9b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f9f:	76 63                	jbe    801004 <memset+0x75>
		uint64 data_block = c;
  800fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa4:	99                   	cltd   
  800fa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa8:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800fab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb1:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800fb5:	c1 e0 08             	shl    $0x8,%eax
  800fb8:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fbb:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800fbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fc4:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800fc8:	c1 e0 10             	shl    $0x10,%eax
  800fcb:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fce:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800fd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd7:	89 c2                	mov    %eax,%edx
  800fd9:	b8 00 00 00 00       	mov    $0x0,%eax
  800fde:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fe1:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800fe4:	eb 18                	jmp    800ffe <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800fe6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fe9:	8d 41 08             	lea    0x8(%ecx),%eax
  800fec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff5:	89 01                	mov    %eax,(%ecx)
  800ff7:	89 51 04             	mov    %edx,0x4(%ecx)
  800ffa:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ffe:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801002:	77 e2                	ja     800fe6 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801004:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801008:	74 23                	je     80102d <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80100a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801010:	eb 0e                	jmp    801020 <memset+0x91>
			*p8++ = (uint8)c;
  801012:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801015:	8d 50 01             	lea    0x1(%eax),%edx
  801018:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80101b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80101e:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801020:	8b 45 10             	mov    0x10(%ebp),%eax
  801023:	8d 50 ff             	lea    -0x1(%eax),%edx
  801026:	89 55 10             	mov    %edx,0x10(%ebp)
  801029:	85 c0                	test   %eax,%eax
  80102b:	75 e5                	jne    801012 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801030:	c9                   	leave  
  801031:	c3                   	ret    

00801032 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
  801035:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801038:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801044:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801048:	76 24                	jbe    80106e <memcpy+0x3c>
		while(n >= 8){
  80104a:	eb 1c                	jmp    801068 <memcpy+0x36>
			*d64 = *s64;
  80104c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104f:	8b 50 04             	mov    0x4(%eax),%edx
  801052:	8b 00                	mov    (%eax),%eax
  801054:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801057:	89 01                	mov    %eax,(%ecx)
  801059:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80105c:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801060:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801064:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801068:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80106c:	77 de                	ja     80104c <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80106e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801072:	74 31                	je     8010a5 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801074:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801077:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80107a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801080:	eb 16                	jmp    801098 <memcpy+0x66>
			*d8++ = *s8++;
  801082:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801085:	8d 50 01             	lea    0x1(%eax),%edx
  801088:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80108b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80108e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801091:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801094:	8a 12                	mov    (%edx),%dl
  801096:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801098:	8b 45 10             	mov    0x10(%ebp),%eax
  80109b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80109e:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a1:	85 c0                	test   %eax,%eax
  8010a3:	75 dd                	jne    801082 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a8:	c9                   	leave  
  8010a9:	c3                   	ret    

008010aa <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010bf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010c2:	73 50                	jae    801114 <memmove+0x6a>
  8010c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ca:	01 d0                	add    %edx,%eax
  8010cc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010cf:	76 43                	jbe    801114 <memmove+0x6a>
		s += n;
  8010d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d4:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010da:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010dd:	eb 10                	jmp    8010ef <memmove+0x45>
			*--d = *--s;
  8010df:	ff 4d f8             	decl   -0x8(%ebp)
  8010e2:	ff 4d fc             	decl   -0x4(%ebp)
  8010e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e8:	8a 10                	mov    (%eax),%dl
  8010ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ed:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f5:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f8:	85 c0                	test   %eax,%eax
  8010fa:	75 e3                	jne    8010df <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010fc:	eb 23                	jmp    801121 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801101:	8d 50 01             	lea    0x1(%eax),%edx
  801104:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801107:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80110a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80110d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801110:	8a 12                	mov    (%edx),%dl
  801112:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801114:	8b 45 10             	mov    0x10(%ebp),%eax
  801117:	8d 50 ff             	lea    -0x1(%eax),%edx
  80111a:	89 55 10             	mov    %edx,0x10(%ebp)
  80111d:	85 c0                	test   %eax,%eax
  80111f:	75 dd                	jne    8010fe <memmove+0x54>
			*d++ = *s++;

	return dst;
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801124:	c9                   	leave  
  801125:	c3                   	ret    

00801126 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801126:	55                   	push   %ebp
  801127:	89 e5                	mov    %esp,%ebp
  801129:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801138:	eb 2a                	jmp    801164 <memcmp+0x3e>
		if (*s1 != *s2)
  80113a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80113d:	8a 10                	mov    (%eax),%dl
  80113f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	38 c2                	cmp    %al,%dl
  801146:	74 16                	je     80115e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801148:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	0f b6 d0             	movzbl %al,%edx
  801150:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801153:	8a 00                	mov    (%eax),%al
  801155:	0f b6 c0             	movzbl %al,%eax
  801158:	29 c2                	sub    %eax,%edx
  80115a:	89 d0                	mov    %edx,%eax
  80115c:	eb 18                	jmp    801176 <memcmp+0x50>
		s1++, s2++;
  80115e:	ff 45 fc             	incl   -0x4(%ebp)
  801161:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801164:	8b 45 10             	mov    0x10(%ebp),%eax
  801167:	8d 50 ff             	lea    -0x1(%eax),%edx
  80116a:	89 55 10             	mov    %edx,0x10(%ebp)
  80116d:	85 c0                	test   %eax,%eax
  80116f:	75 c9                	jne    80113a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801171:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801176:	c9                   	leave  
  801177:	c3                   	ret    

00801178 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
  80117b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80117e:	8b 55 08             	mov    0x8(%ebp),%edx
  801181:	8b 45 10             	mov    0x10(%ebp),%eax
  801184:	01 d0                	add    %edx,%eax
  801186:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801189:	eb 15                	jmp    8011a0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	8a 00                	mov    (%eax),%al
  801190:	0f b6 d0             	movzbl %al,%edx
  801193:	8b 45 0c             	mov    0xc(%ebp),%eax
  801196:	0f b6 c0             	movzbl %al,%eax
  801199:	39 c2                	cmp    %eax,%edx
  80119b:	74 0d                	je     8011aa <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80119d:	ff 45 08             	incl   0x8(%ebp)
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011a6:	72 e3                	jb     80118b <memfind+0x13>
  8011a8:	eb 01                	jmp    8011ab <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011aa:	90                   	nop
	return (void *) s;
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011ae:	c9                   	leave  
  8011af:	c3                   	ret    

008011b0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011bd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011c4:	eb 03                	jmp    8011c9 <strtol+0x19>
		s++;
  8011c6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	3c 20                	cmp    $0x20,%al
  8011d0:	74 f4                	je     8011c6 <strtol+0x16>
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d5:	8a 00                	mov    (%eax),%al
  8011d7:	3c 09                	cmp    $0x9,%al
  8011d9:	74 eb                	je     8011c6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	8a 00                	mov    (%eax),%al
  8011e0:	3c 2b                	cmp    $0x2b,%al
  8011e2:	75 05                	jne    8011e9 <strtol+0x39>
		s++;
  8011e4:	ff 45 08             	incl   0x8(%ebp)
  8011e7:	eb 13                	jmp    8011fc <strtol+0x4c>
	else if (*s == '-')
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	3c 2d                	cmp    $0x2d,%al
  8011f0:	75 0a                	jne    8011fc <strtol+0x4c>
		s++, neg = 1;
  8011f2:	ff 45 08             	incl   0x8(%ebp)
  8011f5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801200:	74 06                	je     801208 <strtol+0x58>
  801202:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801206:	75 20                	jne    801228 <strtol+0x78>
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	3c 30                	cmp    $0x30,%al
  80120f:	75 17                	jne    801228 <strtol+0x78>
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	40                   	inc    %eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	3c 78                	cmp    $0x78,%al
  801219:	75 0d                	jne    801228 <strtol+0x78>
		s += 2, base = 16;
  80121b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80121f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801226:	eb 28                	jmp    801250 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801228:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80122c:	75 15                	jne    801243 <strtol+0x93>
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	3c 30                	cmp    $0x30,%al
  801235:	75 0c                	jne    801243 <strtol+0x93>
		s++, base = 8;
  801237:	ff 45 08             	incl   0x8(%ebp)
  80123a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801241:	eb 0d                	jmp    801250 <strtol+0xa0>
	else if (base == 0)
  801243:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801247:	75 07                	jne    801250 <strtol+0xa0>
		base = 10;
  801249:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	3c 2f                	cmp    $0x2f,%al
  801257:	7e 19                	jle    801272 <strtol+0xc2>
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	8a 00                	mov    (%eax),%al
  80125e:	3c 39                	cmp    $0x39,%al
  801260:	7f 10                	jg     801272 <strtol+0xc2>
			dig = *s - '0';
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	8a 00                	mov    (%eax),%al
  801267:	0f be c0             	movsbl %al,%eax
  80126a:	83 e8 30             	sub    $0x30,%eax
  80126d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801270:	eb 42                	jmp    8012b4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	3c 60                	cmp    $0x60,%al
  801279:	7e 19                	jle    801294 <strtol+0xe4>
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	8a 00                	mov    (%eax),%al
  801280:	3c 7a                	cmp    $0x7a,%al
  801282:	7f 10                	jg     801294 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	0f be c0             	movsbl %al,%eax
  80128c:	83 e8 57             	sub    $0x57,%eax
  80128f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801292:	eb 20                	jmp    8012b4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
  801297:	8a 00                	mov    (%eax),%al
  801299:	3c 40                	cmp    $0x40,%al
  80129b:	7e 39                	jle    8012d6 <strtol+0x126>
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	8a 00                	mov    (%eax),%al
  8012a2:	3c 5a                	cmp    $0x5a,%al
  8012a4:	7f 30                	jg     8012d6 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a9:	8a 00                	mov    (%eax),%al
  8012ab:	0f be c0             	movsbl %al,%eax
  8012ae:	83 e8 37             	sub    $0x37,%eax
  8012b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012ba:	7d 19                	jge    8012d5 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012bc:	ff 45 08             	incl   0x8(%ebp)
  8012bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012c6:	89 c2                	mov    %eax,%edx
  8012c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012cb:	01 d0                	add    %edx,%eax
  8012cd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012d0:	e9 7b ff ff ff       	jmp    801250 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012d5:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012da:	74 08                	je     8012e4 <strtol+0x134>
		*endptr = (char *) s;
  8012dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012df:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e2:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012e8:	74 07                	je     8012f1 <strtol+0x141>
  8012ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ed:	f7 d8                	neg    %eax
  8012ef:	eb 03                	jmp    8012f4 <strtol+0x144>
  8012f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012f4:	c9                   	leave  
  8012f5:	c3                   	ret    

008012f6 <ltostr>:

void
ltostr(long value, char *str)
{
  8012f6:	55                   	push   %ebp
  8012f7:	89 e5                	mov    %esp,%ebp
  8012f9:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801303:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80130a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80130e:	79 13                	jns    801323 <ltostr+0x2d>
	{
		neg = 1;
  801310:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801317:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80131d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801320:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80132b:	99                   	cltd   
  80132c:	f7 f9                	idiv   %ecx
  80132e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801331:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801334:	8d 50 01             	lea    0x1(%eax),%edx
  801337:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80133a:	89 c2                	mov    %eax,%edx
  80133c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133f:	01 d0                	add    %edx,%eax
  801341:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801344:	83 c2 30             	add    $0x30,%edx
  801347:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801349:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80134c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801351:	f7 e9                	imul   %ecx
  801353:	c1 fa 02             	sar    $0x2,%edx
  801356:	89 c8                	mov    %ecx,%eax
  801358:	c1 f8 1f             	sar    $0x1f,%eax
  80135b:	29 c2                	sub    %eax,%edx
  80135d:	89 d0                	mov    %edx,%eax
  80135f:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801362:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801366:	75 bb                	jne    801323 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801368:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80136f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801372:	48                   	dec    %eax
  801373:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801376:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80137a:	74 3d                	je     8013b9 <ltostr+0xc3>
		start = 1 ;
  80137c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801383:	eb 34                	jmp    8013b9 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801385:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801388:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138b:	01 d0                	add    %edx,%eax
  80138d:	8a 00                	mov    (%eax),%al
  80138f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801392:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801395:	8b 45 0c             	mov    0xc(%ebp),%eax
  801398:	01 c2                	add    %eax,%edx
  80139a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80139d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a0:	01 c8                	add    %ecx,%eax
  8013a2:	8a 00                	mov    (%eax),%al
  8013a4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ac:	01 c2                	add    %eax,%edx
  8013ae:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013b1:	88 02                	mov    %al,(%edx)
		start++ ;
  8013b3:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013b6:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013bc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013bf:	7c c4                	jl     801385 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013c1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c7:	01 d0                	add    %edx,%eax
  8013c9:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013cc:	90                   	nop
  8013cd:	c9                   	leave  
  8013ce:	c3                   	ret    

008013cf <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
  8013d2:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013d5:	ff 75 08             	pushl  0x8(%ebp)
  8013d8:	e8 c4 f9 ff ff       	call   800da1 <strlen>
  8013dd:	83 c4 04             	add    $0x4,%esp
  8013e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013e3:	ff 75 0c             	pushl  0xc(%ebp)
  8013e6:	e8 b6 f9 ff ff       	call   800da1 <strlen>
  8013eb:	83 c4 04             	add    $0x4,%esp
  8013ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ff:	eb 17                	jmp    801418 <strcconcat+0x49>
		final[s] = str1[s] ;
  801401:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801404:	8b 45 10             	mov    0x10(%ebp),%eax
  801407:	01 c2                	add    %eax,%edx
  801409:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	01 c8                	add    %ecx,%eax
  801411:	8a 00                	mov    (%eax),%al
  801413:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801415:	ff 45 fc             	incl   -0x4(%ebp)
  801418:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80141b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80141e:	7c e1                	jl     801401 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801420:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801427:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80142e:	eb 1f                	jmp    80144f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801430:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801433:	8d 50 01             	lea    0x1(%eax),%edx
  801436:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801439:	89 c2                	mov    %eax,%edx
  80143b:	8b 45 10             	mov    0x10(%ebp),%eax
  80143e:	01 c2                	add    %eax,%edx
  801440:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801443:	8b 45 0c             	mov    0xc(%ebp),%eax
  801446:	01 c8                	add    %ecx,%eax
  801448:	8a 00                	mov    (%eax),%al
  80144a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80144c:	ff 45 f8             	incl   -0x8(%ebp)
  80144f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801452:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801455:	7c d9                	jl     801430 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801457:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80145a:	8b 45 10             	mov    0x10(%ebp),%eax
  80145d:	01 d0                	add    %edx,%eax
  80145f:	c6 00 00             	movb   $0x0,(%eax)
}
  801462:	90                   	nop
  801463:	c9                   	leave  
  801464:	c3                   	ret    

00801465 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801465:	55                   	push   %ebp
  801466:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801468:	8b 45 14             	mov    0x14(%ebp),%eax
  80146b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801471:	8b 45 14             	mov    0x14(%ebp),%eax
  801474:	8b 00                	mov    (%eax),%eax
  801476:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80147d:	8b 45 10             	mov    0x10(%ebp),%eax
  801480:	01 d0                	add    %edx,%eax
  801482:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801488:	eb 0c                	jmp    801496 <strsplit+0x31>
			*string++ = 0;
  80148a:	8b 45 08             	mov    0x8(%ebp),%eax
  80148d:	8d 50 01             	lea    0x1(%eax),%edx
  801490:	89 55 08             	mov    %edx,0x8(%ebp)
  801493:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	8a 00                	mov    (%eax),%al
  80149b:	84 c0                	test   %al,%al
  80149d:	74 18                	je     8014b7 <strsplit+0x52>
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	8a 00                	mov    (%eax),%al
  8014a4:	0f be c0             	movsbl %al,%eax
  8014a7:	50                   	push   %eax
  8014a8:	ff 75 0c             	pushl  0xc(%ebp)
  8014ab:	e8 83 fa ff ff       	call   800f33 <strchr>
  8014b0:	83 c4 08             	add    $0x8,%esp
  8014b3:	85 c0                	test   %eax,%eax
  8014b5:	75 d3                	jne    80148a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ba:	8a 00                	mov    (%eax),%al
  8014bc:	84 c0                	test   %al,%al
  8014be:	74 5a                	je     80151a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c3:	8b 00                	mov    (%eax),%eax
  8014c5:	83 f8 0f             	cmp    $0xf,%eax
  8014c8:	75 07                	jne    8014d1 <strsplit+0x6c>
		{
			return 0;
  8014ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8014cf:	eb 66                	jmp    801537 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d4:	8b 00                	mov    (%eax),%eax
  8014d6:	8d 48 01             	lea    0x1(%eax),%ecx
  8014d9:	8b 55 14             	mov    0x14(%ebp),%edx
  8014dc:	89 0a                	mov    %ecx,(%edx)
  8014de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e8:	01 c2                	add    %eax,%edx
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014ef:	eb 03                	jmp    8014f4 <strsplit+0x8f>
			string++;
  8014f1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	8a 00                	mov    (%eax),%al
  8014f9:	84 c0                	test   %al,%al
  8014fb:	74 8b                	je     801488 <strsplit+0x23>
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	8a 00                	mov    (%eax),%al
  801502:	0f be c0             	movsbl %al,%eax
  801505:	50                   	push   %eax
  801506:	ff 75 0c             	pushl  0xc(%ebp)
  801509:	e8 25 fa ff ff       	call   800f33 <strchr>
  80150e:	83 c4 08             	add    $0x8,%esp
  801511:	85 c0                	test   %eax,%eax
  801513:	74 dc                	je     8014f1 <strsplit+0x8c>
			string++;
	}
  801515:	e9 6e ff ff ff       	jmp    801488 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80151a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80151b:	8b 45 14             	mov    0x14(%ebp),%eax
  80151e:	8b 00                	mov    (%eax),%eax
  801520:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801527:	8b 45 10             	mov    0x10(%ebp),%eax
  80152a:	01 d0                	add    %edx,%eax
  80152c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801532:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801537:	c9                   	leave  
  801538:	c3                   	ret    

00801539 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
  80153c:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801545:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80154c:	eb 4a                	jmp    801598 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80154e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	01 c2                	add    %eax,%edx
  801556:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801559:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155c:	01 c8                	add    %ecx,%eax
  80155e:	8a 00                	mov    (%eax),%al
  801560:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801562:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801565:	8b 45 0c             	mov    0xc(%ebp),%eax
  801568:	01 d0                	add    %edx,%eax
  80156a:	8a 00                	mov    (%eax),%al
  80156c:	3c 40                	cmp    $0x40,%al
  80156e:	7e 25                	jle    801595 <str2lower+0x5c>
  801570:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801573:	8b 45 0c             	mov    0xc(%ebp),%eax
  801576:	01 d0                	add    %edx,%eax
  801578:	8a 00                	mov    (%eax),%al
  80157a:	3c 5a                	cmp    $0x5a,%al
  80157c:	7f 17                	jg     801595 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80157e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801581:	8b 45 08             	mov    0x8(%ebp),%eax
  801584:	01 d0                	add    %edx,%eax
  801586:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801589:	8b 55 08             	mov    0x8(%ebp),%edx
  80158c:	01 ca                	add    %ecx,%edx
  80158e:	8a 12                	mov    (%edx),%dl
  801590:	83 c2 20             	add    $0x20,%edx
  801593:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801595:	ff 45 fc             	incl   -0x4(%ebp)
  801598:	ff 75 0c             	pushl  0xc(%ebp)
  80159b:	e8 01 f8 ff ff       	call   800da1 <strlen>
  8015a0:	83 c4 04             	add    $0x4,%esp
  8015a3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015a6:	7f a6                	jg     80154e <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8015a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    

008015ad <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	57                   	push   %edi
  8015b1:	56                   	push   %esi
  8015b2:	53                   	push   %ebx
  8015b3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015bf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015c2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015c5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015c8:	cd 30                	int    $0x30
  8015ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8015cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015d0:	83 c4 10             	add    $0x10,%esp
  8015d3:	5b                   	pop    %ebx
  8015d4:	5e                   	pop    %esi
  8015d5:	5f                   	pop    %edi
  8015d6:	5d                   	pop    %ebp
  8015d7:	c3                   	ret    

008015d8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	83 ec 04             	sub    $0x4,%esp
  8015de:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8015e4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015e7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ee:	6a 00                	push   $0x0
  8015f0:	51                   	push   %ecx
  8015f1:	52                   	push   %edx
  8015f2:	ff 75 0c             	pushl  0xc(%ebp)
  8015f5:	50                   	push   %eax
  8015f6:	6a 00                	push   $0x0
  8015f8:	e8 b0 ff ff ff       	call   8015ad <syscall>
  8015fd:	83 c4 18             	add    $0x18,%esp
}
  801600:	90                   	nop
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <sys_cgetc>:

int
sys_cgetc(void)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 02                	push   $0x2
  801612:	e8 96 ff ff ff       	call   8015ad <syscall>
  801617:	83 c4 18             	add    $0x18,%esp
}
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <sys_lock_cons>:

void sys_lock_cons(void)
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 03                	push   $0x3
  80162b:	e8 7d ff ff ff       	call   8015ad <syscall>
  801630:	83 c4 18             	add    $0x18,%esp
}
  801633:	90                   	nop
  801634:	c9                   	leave  
  801635:	c3                   	ret    

00801636 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 04                	push   $0x4
  801645:	e8 63 ff ff ff       	call   8015ad <syscall>
  80164a:	83 c4 18             	add    $0x18,%esp
}
  80164d:	90                   	nop
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    

00801650 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801653:	8b 55 0c             	mov    0xc(%ebp),%edx
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	52                   	push   %edx
  801660:	50                   	push   %eax
  801661:	6a 08                	push   $0x8
  801663:	e8 45 ff ff ff       	call   8015ad <syscall>
  801668:	83 c4 18             	add    $0x18,%esp
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	56                   	push   %esi
  801671:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801672:	8b 75 18             	mov    0x18(%ebp),%esi
  801675:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801678:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80167b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167e:	8b 45 08             	mov    0x8(%ebp),%eax
  801681:	56                   	push   %esi
  801682:	53                   	push   %ebx
  801683:	51                   	push   %ecx
  801684:	52                   	push   %edx
  801685:	50                   	push   %eax
  801686:	6a 09                	push   $0x9
  801688:	e8 20 ff ff ff       	call   8015ad <syscall>
  80168d:	83 c4 18             	add    $0x18,%esp
}
  801690:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801693:	5b                   	pop    %ebx
  801694:	5e                   	pop    %esi
  801695:	5d                   	pop    %ebp
  801696:	c3                   	ret    

00801697 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	ff 75 08             	pushl  0x8(%ebp)
  8016a5:	6a 0a                	push   $0xa
  8016a7:	e8 01 ff ff ff       	call   8015ad <syscall>
  8016ac:	83 c4 18             	add    $0x18,%esp
}
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	ff 75 0c             	pushl  0xc(%ebp)
  8016bd:	ff 75 08             	pushl  0x8(%ebp)
  8016c0:	6a 0b                	push   $0xb
  8016c2:	e8 e6 fe ff ff       	call   8015ad <syscall>
  8016c7:	83 c4 18             	add    $0x18,%esp
}
  8016ca:	c9                   	leave  
  8016cb:	c3                   	ret    

008016cc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 0c                	push   $0xc
  8016db:	e8 cd fe ff ff       	call   8015ad <syscall>
  8016e0:	83 c4 18             	add    $0x18,%esp
}
  8016e3:	c9                   	leave  
  8016e4:	c3                   	ret    

008016e5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 0d                	push   $0xd
  8016f4:	e8 b4 fe ff ff       	call   8015ad <syscall>
  8016f9:	83 c4 18             	add    $0x18,%esp
}
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 0e                	push   $0xe
  80170d:	e8 9b fe ff ff       	call   8015ad <syscall>
  801712:	83 c4 18             	add    $0x18,%esp
}
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 0f                	push   $0xf
  801726:	e8 82 fe ff ff       	call   8015ad <syscall>
  80172b:	83 c4 18             	add    $0x18,%esp
}
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	ff 75 08             	pushl  0x8(%ebp)
  80173e:	6a 10                	push   $0x10
  801740:	e8 68 fe ff ff       	call   8015ad <syscall>
  801745:	83 c4 18             	add    $0x18,%esp
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 11                	push   $0x11
  801759:	e8 4f fe ff ff       	call   8015ad <syscall>
  80175e:	83 c4 18             	add    $0x18,%esp
}
  801761:	90                   	nop
  801762:	c9                   	leave  
  801763:	c3                   	ret    

00801764 <sys_cputc>:

void
sys_cputc(const char c)
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
  801767:	83 ec 04             	sub    $0x4,%esp
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801770:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	50                   	push   %eax
  80177d:	6a 01                	push   $0x1
  80177f:	e8 29 fe ff ff       	call   8015ad <syscall>
  801784:	83 c4 18             	add    $0x18,%esp
}
  801787:	90                   	nop
  801788:	c9                   	leave  
  801789:	c3                   	ret    

0080178a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 14                	push   $0x14
  801799:	e8 0f fe ff ff       	call   8015ad <syscall>
  80179e:	83 c4 18             	add    $0x18,%esp
}
  8017a1:	90                   	nop
  8017a2:	c9                   	leave  
  8017a3:	c3                   	ret    

008017a4 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	83 ec 04             	sub    $0x4,%esp
  8017aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ad:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017b0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017b3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ba:	6a 00                	push   $0x0
  8017bc:	51                   	push   %ecx
  8017bd:	52                   	push   %edx
  8017be:	ff 75 0c             	pushl  0xc(%ebp)
  8017c1:	50                   	push   %eax
  8017c2:	6a 15                	push   $0x15
  8017c4:	e8 e4 fd ff ff       	call   8015ad <syscall>
  8017c9:	83 c4 18             	add    $0x18,%esp
}
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    

008017ce <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	52                   	push   %edx
  8017de:	50                   	push   %eax
  8017df:	6a 16                	push   $0x16
  8017e1:	e8 c7 fd ff ff       	call   8015ad <syscall>
  8017e6:	83 c4 18             	add    $0x18,%esp
}
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	51                   	push   %ecx
  8017fc:	52                   	push   %edx
  8017fd:	50                   	push   %eax
  8017fe:	6a 17                	push   $0x17
  801800:	e8 a8 fd ff ff       	call   8015ad <syscall>
  801805:	83 c4 18             	add    $0x18,%esp
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80180d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	52                   	push   %edx
  80181a:	50                   	push   %eax
  80181b:	6a 18                	push   $0x18
  80181d:	e8 8b fd ff ff       	call   8015ad <syscall>
  801822:	83 c4 18             	add    $0x18,%esp
}
  801825:	c9                   	leave  
  801826:	c3                   	ret    

00801827 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80182a:	8b 45 08             	mov    0x8(%ebp),%eax
  80182d:	6a 00                	push   $0x0
  80182f:	ff 75 14             	pushl  0x14(%ebp)
  801832:	ff 75 10             	pushl  0x10(%ebp)
  801835:	ff 75 0c             	pushl  0xc(%ebp)
  801838:	50                   	push   %eax
  801839:	6a 19                	push   $0x19
  80183b:	e8 6d fd ff ff       	call   8015ad <syscall>
  801840:	83 c4 18             	add    $0x18,%esp
}
  801843:	c9                   	leave  
  801844:	c3                   	ret    

00801845 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801848:	8b 45 08             	mov    0x8(%ebp),%eax
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	50                   	push   %eax
  801854:	6a 1a                	push   $0x1a
  801856:	e8 52 fd ff ff       	call   8015ad <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
}
  80185e:	90                   	nop
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801864:	8b 45 08             	mov    0x8(%ebp),%eax
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	50                   	push   %eax
  801870:	6a 1b                	push   $0x1b
  801872:	e8 36 fd ff ff       	call   8015ad <syscall>
  801877:	83 c4 18             	add    $0x18,%esp
}
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 05                	push   $0x5
  80188b:	e8 1d fd ff ff       	call   8015ad <syscall>
  801890:	83 c4 18             	add    $0x18,%esp
}
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 06                	push   $0x6
  8018a4:	e8 04 fd ff ff       	call   8015ad <syscall>
  8018a9:	83 c4 18             	add    $0x18,%esp
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 07                	push   $0x7
  8018bd:	e8 eb fc ff ff       	call   8015ad <syscall>
  8018c2:	83 c4 18             	add    $0x18,%esp
}
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <sys_exit_env>:


void sys_exit_env(void)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 1c                	push   $0x1c
  8018d6:	e8 d2 fc ff ff       	call   8015ad <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
}
  8018de:	90                   	nop
  8018df:	c9                   	leave  
  8018e0:	c3                   	ret    

008018e1 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
  8018e4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018e7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018ea:	8d 50 04             	lea    0x4(%eax),%edx
  8018ed:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	52                   	push   %edx
  8018f7:	50                   	push   %eax
  8018f8:	6a 1d                	push   $0x1d
  8018fa:	e8 ae fc ff ff       	call   8015ad <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
	return result;
  801902:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801905:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801908:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80190b:	89 01                	mov    %eax,(%ecx)
  80190d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	c9                   	leave  
  801914:	c2 04 00             	ret    $0x4

00801917 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	ff 75 10             	pushl  0x10(%ebp)
  801921:	ff 75 0c             	pushl  0xc(%ebp)
  801924:	ff 75 08             	pushl  0x8(%ebp)
  801927:	6a 13                	push   $0x13
  801929:	e8 7f fc ff ff       	call   8015ad <syscall>
  80192e:	83 c4 18             	add    $0x18,%esp
	return ;
  801931:	90                   	nop
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <sys_rcr2>:
uint32 sys_rcr2()
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 1e                	push   $0x1e
  801943:	e8 65 fc ff ff       	call   8015ad <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	83 ec 04             	sub    $0x4,%esp
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801959:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	50                   	push   %eax
  801966:	6a 1f                	push   $0x1f
  801968:	e8 40 fc ff ff       	call   8015ad <syscall>
  80196d:	83 c4 18             	add    $0x18,%esp
	return ;
  801970:	90                   	nop
}
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <rsttst>:
void rsttst()
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 21                	push   $0x21
  801982:	e8 26 fc ff ff       	call   8015ad <syscall>
  801987:	83 c4 18             	add    $0x18,%esp
	return ;
  80198a:	90                   	nop
}
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    

0080198d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
  801990:	83 ec 04             	sub    $0x4,%esp
  801993:	8b 45 14             	mov    0x14(%ebp),%eax
  801996:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801999:	8b 55 18             	mov    0x18(%ebp),%edx
  80199c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019a0:	52                   	push   %edx
  8019a1:	50                   	push   %eax
  8019a2:	ff 75 10             	pushl  0x10(%ebp)
  8019a5:	ff 75 0c             	pushl  0xc(%ebp)
  8019a8:	ff 75 08             	pushl  0x8(%ebp)
  8019ab:	6a 20                	push   $0x20
  8019ad:	e8 fb fb ff ff       	call   8015ad <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b5:	90                   	nop
}
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <chktst>:
void chktst(uint32 n)
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	ff 75 08             	pushl  0x8(%ebp)
  8019c6:	6a 22                	push   $0x22
  8019c8:	e8 e0 fb ff ff       	call   8015ad <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d0:	90                   	nop
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <inctst>:

void inctst()
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 23                	push   $0x23
  8019e2:	e8 c6 fb ff ff       	call   8015ad <syscall>
  8019e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ea:	90                   	nop
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <gettst>:
uint32 gettst()
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 24                	push   $0x24
  8019fc:	e8 ac fb ff ff       	call   8015ad <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
}
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 25                	push   $0x25
  801a15:	e8 93 fb ff ff       	call   8015ad <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
  801a1d:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801a22:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2f:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	ff 75 08             	pushl  0x8(%ebp)
  801a3f:	6a 26                	push   $0x26
  801a41:	e8 67 fb ff ff       	call   8015ad <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
	return ;
  801a49:	90                   	nop
}
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a50:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a53:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	6a 00                	push   $0x0
  801a5e:	53                   	push   %ebx
  801a5f:	51                   	push   %ecx
  801a60:	52                   	push   %edx
  801a61:	50                   	push   %eax
  801a62:	6a 27                	push   $0x27
  801a64:	e8 44 fb ff ff       	call   8015ad <syscall>
  801a69:	83 c4 18             	add    $0x18,%esp
}
  801a6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a74:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	52                   	push   %edx
  801a81:	50                   	push   %eax
  801a82:	6a 28                	push   $0x28
  801a84:	e8 24 fb ff ff       	call   8015ad <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801a91:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	6a 00                	push   $0x0
  801a9c:	51                   	push   %ecx
  801a9d:	ff 75 10             	pushl  0x10(%ebp)
  801aa0:	52                   	push   %edx
  801aa1:	50                   	push   %eax
  801aa2:	6a 29                	push   $0x29
  801aa4:	e8 04 fb ff ff       	call   8015ad <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	ff 75 10             	pushl  0x10(%ebp)
  801ab8:	ff 75 0c             	pushl  0xc(%ebp)
  801abb:	ff 75 08             	pushl  0x8(%ebp)
  801abe:	6a 12                	push   $0x12
  801ac0:	e8 e8 fa ff ff       	call   8015ad <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac8:	90                   	nop
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801ace:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	52                   	push   %edx
  801adb:	50                   	push   %eax
  801adc:	6a 2a                	push   $0x2a
  801ade:	e8 ca fa ff ff       	call   8015ad <syscall>
  801ae3:	83 c4 18             	add    $0x18,%esp
	return;
  801ae6:	90                   	nop
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 2b                	push   $0x2b
  801af8:	e8 b0 fa ff ff       	call   8015ad <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	ff 75 0c             	pushl  0xc(%ebp)
  801b0e:	ff 75 08             	pushl  0x8(%ebp)
  801b11:	6a 2d                	push   $0x2d
  801b13:	e8 95 fa ff ff       	call   8015ad <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
	return;
  801b1b:	90                   	nop
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	ff 75 0c             	pushl  0xc(%ebp)
  801b2a:	ff 75 08             	pushl  0x8(%ebp)
  801b2d:	6a 2c                	push   $0x2c
  801b2f:	e8 79 fa ff ff       	call   8015ad <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
	return ;
  801b37:	90                   	nop
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801b3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b40:	8b 45 08             	mov    0x8(%ebp),%eax
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	52                   	push   %edx
  801b4a:	50                   	push   %eax
  801b4b:	6a 2e                	push   $0x2e
  801b4d:	e8 5b fa ff ff       	call   8015ad <syscall>
  801b52:	83 c4 18             	add    $0x18,%esp
	return ;
  801b55:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
  801b5b:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801b5e:	8b 55 08             	mov    0x8(%ebp),%edx
  801b61:	89 d0                	mov    %edx,%eax
  801b63:	c1 e0 02             	shl    $0x2,%eax
  801b66:	01 d0                	add    %edx,%eax
  801b68:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b6f:	01 d0                	add    %edx,%eax
  801b71:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b78:	01 d0                	add    %edx,%eax
  801b7a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b81:	01 d0                	add    %edx,%eax
  801b83:	c1 e0 04             	shl    $0x4,%eax
  801b86:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801b89:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801b90:	0f 31                	rdtsc  
  801b92:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b95:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801b98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b9b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ba1:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801ba4:	eb 46                	jmp    801bec <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801ba6:	0f 31                	rdtsc  
  801ba8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801bab:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801bae:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801bb1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801bb4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801bb7:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801bba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc0:	29 c2                	sub    %eax,%edx
  801bc2:	89 d0                	mov    %edx,%eax
  801bc4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801bc7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bcd:	89 d1                	mov    %edx,%ecx
  801bcf:	29 c1                	sub    %eax,%ecx
  801bd1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801bd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bd7:	39 c2                	cmp    %eax,%edx
  801bd9:	0f 97 c0             	seta   %al
  801bdc:	0f b6 c0             	movzbl %al,%eax
  801bdf:	29 c1                	sub    %eax,%ecx
  801be1:	89 c8                	mov    %ecx,%eax
  801be3:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801be6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801be9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801bec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bef:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801bf2:	72 b2                	jb     801ba6 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801bf4:	90                   	nop
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801bfd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801c04:	eb 03                	jmp    801c09 <busy_wait+0x12>
  801c06:	ff 45 fc             	incl   -0x4(%ebp)
  801c09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c0c:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c0f:	72 f5                	jb     801c06 <busy_wait+0xf>
	return i;
  801c11:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    
  801c16:	66 90                	xchg   %ax,%ax

00801c18 <__udivdi3>:
  801c18:	55                   	push   %ebp
  801c19:	57                   	push   %edi
  801c1a:	56                   	push   %esi
  801c1b:	53                   	push   %ebx
  801c1c:	83 ec 1c             	sub    $0x1c,%esp
  801c1f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c23:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c2b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c2f:	89 ca                	mov    %ecx,%edx
  801c31:	89 f8                	mov    %edi,%eax
  801c33:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c37:	85 f6                	test   %esi,%esi
  801c39:	75 2d                	jne    801c68 <__udivdi3+0x50>
  801c3b:	39 cf                	cmp    %ecx,%edi
  801c3d:	77 65                	ja     801ca4 <__udivdi3+0x8c>
  801c3f:	89 fd                	mov    %edi,%ebp
  801c41:	85 ff                	test   %edi,%edi
  801c43:	75 0b                	jne    801c50 <__udivdi3+0x38>
  801c45:	b8 01 00 00 00       	mov    $0x1,%eax
  801c4a:	31 d2                	xor    %edx,%edx
  801c4c:	f7 f7                	div    %edi
  801c4e:	89 c5                	mov    %eax,%ebp
  801c50:	31 d2                	xor    %edx,%edx
  801c52:	89 c8                	mov    %ecx,%eax
  801c54:	f7 f5                	div    %ebp
  801c56:	89 c1                	mov    %eax,%ecx
  801c58:	89 d8                	mov    %ebx,%eax
  801c5a:	f7 f5                	div    %ebp
  801c5c:	89 cf                	mov    %ecx,%edi
  801c5e:	89 fa                	mov    %edi,%edx
  801c60:	83 c4 1c             	add    $0x1c,%esp
  801c63:	5b                   	pop    %ebx
  801c64:	5e                   	pop    %esi
  801c65:	5f                   	pop    %edi
  801c66:	5d                   	pop    %ebp
  801c67:	c3                   	ret    
  801c68:	39 ce                	cmp    %ecx,%esi
  801c6a:	77 28                	ja     801c94 <__udivdi3+0x7c>
  801c6c:	0f bd fe             	bsr    %esi,%edi
  801c6f:	83 f7 1f             	xor    $0x1f,%edi
  801c72:	75 40                	jne    801cb4 <__udivdi3+0x9c>
  801c74:	39 ce                	cmp    %ecx,%esi
  801c76:	72 0a                	jb     801c82 <__udivdi3+0x6a>
  801c78:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c7c:	0f 87 9e 00 00 00    	ja     801d20 <__udivdi3+0x108>
  801c82:	b8 01 00 00 00       	mov    $0x1,%eax
  801c87:	89 fa                	mov    %edi,%edx
  801c89:	83 c4 1c             	add    $0x1c,%esp
  801c8c:	5b                   	pop    %ebx
  801c8d:	5e                   	pop    %esi
  801c8e:	5f                   	pop    %edi
  801c8f:	5d                   	pop    %ebp
  801c90:	c3                   	ret    
  801c91:	8d 76 00             	lea    0x0(%esi),%esi
  801c94:	31 ff                	xor    %edi,%edi
  801c96:	31 c0                	xor    %eax,%eax
  801c98:	89 fa                	mov    %edi,%edx
  801c9a:	83 c4 1c             	add    $0x1c,%esp
  801c9d:	5b                   	pop    %ebx
  801c9e:	5e                   	pop    %esi
  801c9f:	5f                   	pop    %edi
  801ca0:	5d                   	pop    %ebp
  801ca1:	c3                   	ret    
  801ca2:	66 90                	xchg   %ax,%ax
  801ca4:	89 d8                	mov    %ebx,%eax
  801ca6:	f7 f7                	div    %edi
  801ca8:	31 ff                	xor    %edi,%edi
  801caa:	89 fa                	mov    %edi,%edx
  801cac:	83 c4 1c             	add    $0x1c,%esp
  801caf:	5b                   	pop    %ebx
  801cb0:	5e                   	pop    %esi
  801cb1:	5f                   	pop    %edi
  801cb2:	5d                   	pop    %ebp
  801cb3:	c3                   	ret    
  801cb4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cb9:	89 eb                	mov    %ebp,%ebx
  801cbb:	29 fb                	sub    %edi,%ebx
  801cbd:	89 f9                	mov    %edi,%ecx
  801cbf:	d3 e6                	shl    %cl,%esi
  801cc1:	89 c5                	mov    %eax,%ebp
  801cc3:	88 d9                	mov    %bl,%cl
  801cc5:	d3 ed                	shr    %cl,%ebp
  801cc7:	89 e9                	mov    %ebp,%ecx
  801cc9:	09 f1                	or     %esi,%ecx
  801ccb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ccf:	89 f9                	mov    %edi,%ecx
  801cd1:	d3 e0                	shl    %cl,%eax
  801cd3:	89 c5                	mov    %eax,%ebp
  801cd5:	89 d6                	mov    %edx,%esi
  801cd7:	88 d9                	mov    %bl,%cl
  801cd9:	d3 ee                	shr    %cl,%esi
  801cdb:	89 f9                	mov    %edi,%ecx
  801cdd:	d3 e2                	shl    %cl,%edx
  801cdf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ce3:	88 d9                	mov    %bl,%cl
  801ce5:	d3 e8                	shr    %cl,%eax
  801ce7:	09 c2                	or     %eax,%edx
  801ce9:	89 d0                	mov    %edx,%eax
  801ceb:	89 f2                	mov    %esi,%edx
  801ced:	f7 74 24 0c          	divl   0xc(%esp)
  801cf1:	89 d6                	mov    %edx,%esi
  801cf3:	89 c3                	mov    %eax,%ebx
  801cf5:	f7 e5                	mul    %ebp
  801cf7:	39 d6                	cmp    %edx,%esi
  801cf9:	72 19                	jb     801d14 <__udivdi3+0xfc>
  801cfb:	74 0b                	je     801d08 <__udivdi3+0xf0>
  801cfd:	89 d8                	mov    %ebx,%eax
  801cff:	31 ff                	xor    %edi,%edi
  801d01:	e9 58 ff ff ff       	jmp    801c5e <__udivdi3+0x46>
  801d06:	66 90                	xchg   %ax,%ax
  801d08:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d0c:	89 f9                	mov    %edi,%ecx
  801d0e:	d3 e2                	shl    %cl,%edx
  801d10:	39 c2                	cmp    %eax,%edx
  801d12:	73 e9                	jae    801cfd <__udivdi3+0xe5>
  801d14:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d17:	31 ff                	xor    %edi,%edi
  801d19:	e9 40 ff ff ff       	jmp    801c5e <__udivdi3+0x46>
  801d1e:	66 90                	xchg   %ax,%ax
  801d20:	31 c0                	xor    %eax,%eax
  801d22:	e9 37 ff ff ff       	jmp    801c5e <__udivdi3+0x46>
  801d27:	90                   	nop

00801d28 <__umoddi3>:
  801d28:	55                   	push   %ebp
  801d29:	57                   	push   %edi
  801d2a:	56                   	push   %esi
  801d2b:	53                   	push   %ebx
  801d2c:	83 ec 1c             	sub    $0x1c,%esp
  801d2f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d33:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d3f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d43:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d47:	89 f3                	mov    %esi,%ebx
  801d49:	89 fa                	mov    %edi,%edx
  801d4b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d4f:	89 34 24             	mov    %esi,(%esp)
  801d52:	85 c0                	test   %eax,%eax
  801d54:	75 1a                	jne    801d70 <__umoddi3+0x48>
  801d56:	39 f7                	cmp    %esi,%edi
  801d58:	0f 86 a2 00 00 00    	jbe    801e00 <__umoddi3+0xd8>
  801d5e:	89 c8                	mov    %ecx,%eax
  801d60:	89 f2                	mov    %esi,%edx
  801d62:	f7 f7                	div    %edi
  801d64:	89 d0                	mov    %edx,%eax
  801d66:	31 d2                	xor    %edx,%edx
  801d68:	83 c4 1c             	add    $0x1c,%esp
  801d6b:	5b                   	pop    %ebx
  801d6c:	5e                   	pop    %esi
  801d6d:	5f                   	pop    %edi
  801d6e:	5d                   	pop    %ebp
  801d6f:	c3                   	ret    
  801d70:	39 f0                	cmp    %esi,%eax
  801d72:	0f 87 ac 00 00 00    	ja     801e24 <__umoddi3+0xfc>
  801d78:	0f bd e8             	bsr    %eax,%ebp
  801d7b:	83 f5 1f             	xor    $0x1f,%ebp
  801d7e:	0f 84 ac 00 00 00    	je     801e30 <__umoddi3+0x108>
  801d84:	bf 20 00 00 00       	mov    $0x20,%edi
  801d89:	29 ef                	sub    %ebp,%edi
  801d8b:	89 fe                	mov    %edi,%esi
  801d8d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d91:	89 e9                	mov    %ebp,%ecx
  801d93:	d3 e0                	shl    %cl,%eax
  801d95:	89 d7                	mov    %edx,%edi
  801d97:	89 f1                	mov    %esi,%ecx
  801d99:	d3 ef                	shr    %cl,%edi
  801d9b:	09 c7                	or     %eax,%edi
  801d9d:	89 e9                	mov    %ebp,%ecx
  801d9f:	d3 e2                	shl    %cl,%edx
  801da1:	89 14 24             	mov    %edx,(%esp)
  801da4:	89 d8                	mov    %ebx,%eax
  801da6:	d3 e0                	shl    %cl,%eax
  801da8:	89 c2                	mov    %eax,%edx
  801daa:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dae:	d3 e0                	shl    %cl,%eax
  801db0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801db8:	89 f1                	mov    %esi,%ecx
  801dba:	d3 e8                	shr    %cl,%eax
  801dbc:	09 d0                	or     %edx,%eax
  801dbe:	d3 eb                	shr    %cl,%ebx
  801dc0:	89 da                	mov    %ebx,%edx
  801dc2:	f7 f7                	div    %edi
  801dc4:	89 d3                	mov    %edx,%ebx
  801dc6:	f7 24 24             	mull   (%esp)
  801dc9:	89 c6                	mov    %eax,%esi
  801dcb:	89 d1                	mov    %edx,%ecx
  801dcd:	39 d3                	cmp    %edx,%ebx
  801dcf:	0f 82 87 00 00 00    	jb     801e5c <__umoddi3+0x134>
  801dd5:	0f 84 91 00 00 00    	je     801e6c <__umoddi3+0x144>
  801ddb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ddf:	29 f2                	sub    %esi,%edx
  801de1:	19 cb                	sbb    %ecx,%ebx
  801de3:	89 d8                	mov    %ebx,%eax
  801de5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801de9:	d3 e0                	shl    %cl,%eax
  801deb:	89 e9                	mov    %ebp,%ecx
  801ded:	d3 ea                	shr    %cl,%edx
  801def:	09 d0                	or     %edx,%eax
  801df1:	89 e9                	mov    %ebp,%ecx
  801df3:	d3 eb                	shr    %cl,%ebx
  801df5:	89 da                	mov    %ebx,%edx
  801df7:	83 c4 1c             	add    $0x1c,%esp
  801dfa:	5b                   	pop    %ebx
  801dfb:	5e                   	pop    %esi
  801dfc:	5f                   	pop    %edi
  801dfd:	5d                   	pop    %ebp
  801dfe:	c3                   	ret    
  801dff:	90                   	nop
  801e00:	89 fd                	mov    %edi,%ebp
  801e02:	85 ff                	test   %edi,%edi
  801e04:	75 0b                	jne    801e11 <__umoddi3+0xe9>
  801e06:	b8 01 00 00 00       	mov    $0x1,%eax
  801e0b:	31 d2                	xor    %edx,%edx
  801e0d:	f7 f7                	div    %edi
  801e0f:	89 c5                	mov    %eax,%ebp
  801e11:	89 f0                	mov    %esi,%eax
  801e13:	31 d2                	xor    %edx,%edx
  801e15:	f7 f5                	div    %ebp
  801e17:	89 c8                	mov    %ecx,%eax
  801e19:	f7 f5                	div    %ebp
  801e1b:	89 d0                	mov    %edx,%eax
  801e1d:	e9 44 ff ff ff       	jmp    801d66 <__umoddi3+0x3e>
  801e22:	66 90                	xchg   %ax,%ax
  801e24:	89 c8                	mov    %ecx,%eax
  801e26:	89 f2                	mov    %esi,%edx
  801e28:	83 c4 1c             	add    $0x1c,%esp
  801e2b:	5b                   	pop    %ebx
  801e2c:	5e                   	pop    %esi
  801e2d:	5f                   	pop    %edi
  801e2e:	5d                   	pop    %ebp
  801e2f:	c3                   	ret    
  801e30:	3b 04 24             	cmp    (%esp),%eax
  801e33:	72 06                	jb     801e3b <__umoddi3+0x113>
  801e35:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e39:	77 0f                	ja     801e4a <__umoddi3+0x122>
  801e3b:	89 f2                	mov    %esi,%edx
  801e3d:	29 f9                	sub    %edi,%ecx
  801e3f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e43:	89 14 24             	mov    %edx,(%esp)
  801e46:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e4a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e4e:	8b 14 24             	mov    (%esp),%edx
  801e51:	83 c4 1c             	add    $0x1c,%esp
  801e54:	5b                   	pop    %ebx
  801e55:	5e                   	pop    %esi
  801e56:	5f                   	pop    %edi
  801e57:	5d                   	pop    %ebp
  801e58:	c3                   	ret    
  801e59:	8d 76 00             	lea    0x0(%esi),%esi
  801e5c:	2b 04 24             	sub    (%esp),%eax
  801e5f:	19 fa                	sbb    %edi,%edx
  801e61:	89 d1                	mov    %edx,%ecx
  801e63:	89 c6                	mov    %eax,%esi
  801e65:	e9 71 ff ff ff       	jmp    801ddb <__umoddi3+0xb3>
  801e6a:	66 90                	xchg   %ax,%ax
  801e6c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e70:	72 ea                	jb     801e5c <__umoddi3+0x134>
  801e72:	89 d9                	mov    %ebx,%ecx
  801e74:	e9 62 ff ff ff       	jmp    801ddb <__umoddi3+0xb3>
