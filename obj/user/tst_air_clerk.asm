
obj/user/tst_air_clerk:     file format elf32-i386


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
  800031:	e8 5b 07 00 00       	call   800791 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <user/air.h>

extern volatile bool printStats;
void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec dc 01 00 00    	sub    $0x1dc,%esp
	//disable the print of prog stats after finishing
	printStats = 0;
  800044:	c7 05 00 50 80 00 00 	movl   $0x0,0x805000
  80004b:	00 00 00 

	int parentenvID = sys_getparentenvid();
  80004e:	e8 ca 2a 00 00       	call   802b1d <sys_getparentenvid>
  800053:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _isOpened[] = "isOpened";
  800056:	8d 45 ab             	lea    -0x55(%ebp),%eax
  800059:	bb ff 3e 80 00       	mov    $0x803eff,%ebx
  80005e:	ba 09 00 00 00       	mov    $0x9,%edx
  800063:	89 c7                	mov    %eax,%edi
  800065:	89 de                	mov    %ebx,%esi
  800067:	89 d1                	mov    %edx,%ecx
  800069:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _customers[] = "customers";
  80006b:	8d 45 a1             	lea    -0x5f(%ebp),%eax
  80006e:	bb 08 3f 80 00       	mov    $0x803f08,%ebx
  800073:	ba 0a 00 00 00       	mov    $0xa,%edx
  800078:	89 c7                	mov    %eax,%edi
  80007a:	89 de                	mov    %ebx,%esi
  80007c:	89 d1                	mov    %edx,%ecx
  80007e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800080:	8d 45 95             	lea    -0x6b(%ebp),%eax
  800083:	bb 12 3f 80 00       	mov    $0x803f12,%ebx
  800088:	ba 03 00 00 00       	mov    $0x3,%edx
  80008d:	89 c7                	mov    %eax,%edi
  80008f:	89 de                	mov    %ebx,%esi
  800091:	89 d1                	mov    %edx,%ecx
  800093:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800095:	8d 45 86             	lea    -0x7a(%ebp),%eax
  800098:	bb 1e 3f 80 00       	mov    $0x803f1e,%ebx
  80009d:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000a2:	89 c7                	mov    %eax,%edi
  8000a4:	89 de                	mov    %ebx,%esi
  8000a6:	89 d1                	mov    %edx,%ecx
  8000a8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000aa:	8d 85 77 ff ff ff    	lea    -0x89(%ebp),%eax
  8000b0:	bb 2d 3f 80 00       	mov    $0x803f2d,%ebx
  8000b5:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ba:	89 c7                	mov    %eax,%edi
  8000bc:	89 de                	mov    %ebx,%esi
  8000be:	89 d1                	mov    %edx,%ecx
  8000c0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000c2:	8d 85 62 ff ff ff    	lea    -0x9e(%ebp),%eax
  8000c8:	bb 3c 3f 80 00       	mov    $0x803f3c,%ebx
  8000cd:	ba 15 00 00 00       	mov    $0x15,%edx
  8000d2:	89 c7                	mov    %eax,%edi
  8000d4:	89 de                	mov    %ebx,%esi
  8000d6:	89 d1                	mov    %edx,%ecx
  8000d8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000da:	8d 85 4d ff ff ff    	lea    -0xb3(%ebp),%eax
  8000e0:	bb 51 3f 80 00       	mov    $0x803f51,%ebx
  8000e5:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ea:	89 c7                	mov    %eax,%edi
  8000ec:	89 de                	mov    %ebx,%esi
  8000ee:	89 d1                	mov    %edx,%ecx
  8000f0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000f2:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
  8000f8:	bb 66 3f 80 00       	mov    $0x803f66,%ebx
  8000fd:	ba 11 00 00 00       	mov    $0x11,%edx
  800102:	89 c7                	mov    %eax,%edi
  800104:	89 de                	mov    %ebx,%esi
  800106:	89 d1                	mov    %edx,%ecx
  800108:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80010a:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  800110:	bb 77 3f 80 00       	mov    $0x803f77,%ebx
  800115:	ba 11 00 00 00       	mov    $0x11,%edx
  80011a:	89 c7                	mov    %eax,%edi
  80011c:	89 de                	mov    %ebx,%esi
  80011e:	89 d1                	mov    %edx,%ecx
  800120:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800122:	8d 85 1a ff ff ff    	lea    -0xe6(%ebp),%eax
  800128:	bb 88 3f 80 00       	mov    $0x803f88,%ebx
  80012d:	ba 11 00 00 00       	mov    $0x11,%edx
  800132:	89 c7                	mov    %eax,%edi
  800134:	89 de                	mov    %ebx,%esi
  800136:	89 d1                	mov    %edx,%ecx
  800138:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80013a:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800140:	bb 99 3f 80 00       	mov    $0x803f99,%ebx
  800145:	ba 09 00 00 00       	mov    $0x9,%edx
  80014a:	89 c7                	mov    %eax,%edi
  80014c:	89 de                	mov    %ebx,%esi
  80014e:	89 d1                	mov    %edx,%ecx
  800150:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800152:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  800158:	bb a2 3f 80 00       	mov    $0x803fa2,%ebx
  80015d:	ba 0a 00 00 00       	mov    $0xa,%edx
  800162:	89 c7                	mov    %eax,%edi
  800164:	89 de                	mov    %ebx,%esi
  800166:	89 d1                	mov    %edx,%ecx
  800168:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80016a:	8d 85 fc fe ff ff    	lea    -0x104(%ebp),%eax
  800170:	bb ac 3f 80 00       	mov    $0x803fac,%ebx
  800175:	ba 0b 00 00 00       	mov    $0xb,%edx
  80017a:	89 c7                	mov    %eax,%edi
  80017c:	89 de                	mov    %ebx,%esi
  80017e:	89 d1                	mov    %edx,%ecx
  800180:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800182:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800188:	bb b7 3f 80 00       	mov    $0x803fb7,%ebx
  80018d:	ba 03 00 00 00       	mov    $0x3,%edx
  800192:	89 c7                	mov    %eax,%edi
  800194:	89 de                	mov    %ebx,%esi
  800196:	89 d1                	mov    %edx,%ecx
  800198:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  80019a:	8d 85 e6 fe ff ff    	lea    -0x11a(%ebp),%eax
  8001a0:	bb c3 3f 80 00       	mov    $0x803fc3,%ebx
  8001a5:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001aa:	89 c7                	mov    %eax,%edi
  8001ac:	89 de                	mov    %ebx,%esi
  8001ae:	89 d1                	mov    %edx,%ecx
  8001b0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001b2:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  8001b8:	bb cd 3f 80 00       	mov    $0x803fcd,%ebx
  8001bd:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001c2:	89 c7                	mov    %eax,%edi
  8001c4:	89 de                	mov    %ebx,%esi
  8001c6:	89 d1                	mov    %edx,%ecx
  8001c8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001ca:	c7 85 d6 fe ff ff 63 	movl   $0x72656c63,-0x12a(%ebp)
  8001d1:	6c 65 72 
  8001d4:	66 c7 85 da fe ff ff 	movw   $0x6b,-0x126(%ebp)
  8001db:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001dd:	8d 85 c8 fe ff ff    	lea    -0x138(%ebp),%eax
  8001e3:	bb d7 3f 80 00       	mov    $0x803fd7,%ebx
  8001e8:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001ed:	89 c7                	mov    %eax,%edi
  8001ef:	89 de                	mov    %ebx,%esi
  8001f1:	89 d1                	mov    %edx,%ecx
  8001f3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001f5:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  8001fb:	bb e5 3f 80 00       	mov    $0x803fe5,%ebx
  800200:	ba 0f 00 00 00       	mov    $0xf,%edx
  800205:	89 c7                	mov    %eax,%edi
  800207:	89 de                	mov    %ebx,%esi
  800209:	89 d1                	mov    %edx,%ecx
  80020b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _clerkTerminated[] = "clerkTerminated";
  80020d:	8d 85 a9 fe ff ff    	lea    -0x157(%ebp),%eax
  800213:	bb f4 3f 80 00       	mov    $0x803ff4,%ebx
  800218:	ba 04 00 00 00       	mov    $0x4,%edx
  80021d:	89 c7                	mov    %eax,%edi
  80021f:	89 de                	mov    %ebx,%esi
  800221:	89 d1                	mov    %edx,%ecx
  800223:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800225:	8d 85 a2 fe ff ff    	lea    -0x15e(%ebp),%eax
  80022b:	bb 04 40 80 00       	mov    $0x804004,%ebx
  800230:	ba 07 00 00 00       	mov    $0x7,%edx
  800235:	89 c7                	mov    %eax,%edi
  800237:	89 de                	mov    %ebx,%esi
  800239:	89 d1                	mov    %edx,%ecx
  80023b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  80023d:	8d 85 9b fe ff ff    	lea    -0x165(%ebp),%eax
  800243:	bb 0b 40 80 00       	mov    $0x80400b,%ebx
  800248:	ba 07 00 00 00       	mov    $0x7,%edx
  80024d:	89 c7                	mov    %eax,%edi
  80024f:	89 de                	mov    %ebx,%esi
  800251:	89 d1                	mov    %edx,%ecx
  800253:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * customers = sget(parentenvID, _customers);
  800255:	83 ec 08             	sub    $0x8,%esp
  800258:	8d 45 a1             	lea    -0x5f(%ebp),%eax
  80025b:	50                   	push   %eax
  80025c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025f:	e8 16 24 00 00       	call   80267a <sget>
  800264:	83 c4 10             	add    $0x10,%esp
  800267:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* isOpened = sget(parentenvID, _isOpened);
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	8d 45 ab             	lea    -0x55(%ebp),%eax
  800270:	50                   	push   %eax
  800271:	ff 75 e4             	pushl  -0x1c(%ebp)
  800274:	e8 01 24 00 00       	call   80267a <sget>
  800279:	83 c4 10             	add    $0x10,%esp
  80027c:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* flight1Counter = sget(parentenvID, _flight1Counter);
  80027f:	83 ec 08             	sub    $0x8,%esp
  800282:	8d 45 86             	lea    -0x7a(%ebp),%eax
  800285:	50                   	push   %eax
  800286:	ff 75 e4             	pushl  -0x1c(%ebp)
  800289:	e8 ec 23 00 00       	call   80267a <sget>
  80028e:	83 c4 10             	add    $0x10,%esp
  800291:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int* flight2Counter = sget(parentenvID, _flight2Counter);
  800294:	83 ec 08             	sub    $0x8,%esp
  800297:	8d 85 77 ff ff ff    	lea    -0x89(%ebp),%eax
  80029d:	50                   	push   %eax
  80029e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a1:	e8 d4 23 00 00       	call   80267a <sget>
  8002a6:	83 c4 10             	add    $0x10,%esp
  8002a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int* flight1BookedCounter = sget(parentenvID, _flightBooked1Counter);
  8002ac:	83 ec 08             	sub    $0x8,%esp
  8002af:	8d 85 62 ff ff ff    	lea    -0x9e(%ebp),%eax
  8002b5:	50                   	push   %eax
  8002b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b9:	e8 bc 23 00 00       	call   80267a <sget>
  8002be:	83 c4 10             	add    $0x10,%esp
  8002c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int* flight2BookedCounter = sget(parentenvID, _flightBooked2Counter);
  8002c4:	83 ec 08             	sub    $0x8,%esp
  8002c7:	8d 85 4d ff ff ff    	lea    -0xb3(%ebp),%eax
  8002cd:	50                   	push   %eax
  8002ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d1:	e8 a4 23 00 00       	call   80267a <sget>
  8002d6:	83 c4 10             	add    $0x10,%esp
  8002d9:	89 45 cc             	mov    %eax,-0x34(%ebp)

	int* flight1BookedArr = sget(parentenvID, _flightBooked1Arr);
  8002dc:	83 ec 08             	sub    $0x8,%esp
  8002df:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
  8002e5:	50                   	push   %eax
  8002e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e9:	e8 8c 23 00 00       	call   80267a <sget>
  8002ee:	83 c4 10             	add    $0x10,%esp
  8002f1:	89 45 c8             	mov    %eax,-0x38(%ebp)
	int* flight2BookedArr = sget(parentenvID, _flightBooked2Arr);
  8002f4:	83 ec 08             	sub    $0x8,%esp
  8002f7:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8002fd:	50                   	push   %eax
  8002fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800301:	e8 74 23 00 00       	call   80267a <sget>
  800306:	83 c4 10             	add    $0x10,%esp
  800309:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  80030c:	83 ec 08             	sub    $0x8,%esp
  80030f:	8d 85 1a ff ff ff    	lea    -0xe6(%ebp),%eax
  800315:	50                   	push   %eax
  800316:	ff 75 e4             	pushl  -0x1c(%ebp)
  800319:	e8 5c 23 00 00       	call   80267a <sget>
  80031e:	83 c4 10             	add    $0x10,%esp
  800321:	89 45 c0             	mov    %eax,-0x40(%ebp)

	int* queue_out = sget(parentenvID, _queue_out);
  800324:	83 ec 08             	sub    $0x8,%esp
  800327:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80032d:	50                   	push   %eax
  80032e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800331:	e8 44 23 00 00       	call   80267a <sget>
  800336:	83 c4 10             	add    $0x10,%esp
  800339:	89 45 bc             	mov    %eax,-0x44(%ebp)
	//cprintf("address of queue_out = %d\n", queue_out);
	// *********************************************************************************

	struct semaphore cust_ready = get_semaphore(parentenvID, _cust_ready);
  80033c:	8d 85 94 fe ff ff    	lea    -0x16c(%ebp),%eax
  800342:	83 ec 04             	sub    $0x4,%esp
  800345:	8d 95 fc fe ff ff    	lea    -0x104(%ebp),%edx
  80034b:	52                   	push   %edx
  80034c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80034f:	50                   	push   %eax
  800350:	e8 ad 37 00 00       	call   803b02 <get_semaphore>
  800355:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  800358:	8d 85 90 fe ff ff    	lea    -0x170(%ebp),%eax
  80035e:	83 ec 04             	sub    $0x4,%esp
  800361:	8d 95 f0 fe ff ff    	lea    -0x110(%ebp),%edx
  800367:	52                   	push   %edx
  800368:	ff 75 e4             	pushl  -0x1c(%ebp)
  80036b:	50                   	push   %eax
  80036c:	e8 91 37 00 00       	call   803b02 <get_semaphore>
  800371:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight1CS = get_semaphore(parentenvID, _flight1CS);
  800374:	8d 85 8c fe ff ff    	lea    -0x174(%ebp),%eax
  80037a:	83 ec 04             	sub    $0x4,%esp
  80037d:	8d 95 e6 fe ff ff    	lea    -0x11a(%ebp),%edx
  800383:	52                   	push   %edx
  800384:	ff 75 e4             	pushl  -0x1c(%ebp)
  800387:	50                   	push   %eax
  800388:	e8 75 37 00 00       	call   803b02 <get_semaphore>
  80038d:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = get_semaphore(parentenvID, _flight2CS);
  800390:	8d 85 88 fe ff ff    	lea    -0x178(%ebp),%eax
  800396:	83 ec 04             	sub    $0x4,%esp
  800399:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  80039f:	52                   	push   %edx
  8003a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a3:	50                   	push   %eax
  8003a4:	e8 59 37 00 00       	call   803b02 <get_semaphore>
  8003a9:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  8003ac:	8d 85 84 fe ff ff    	lea    -0x17c(%ebp),%eax
  8003b2:	83 ec 04             	sub    $0x4,%esp
  8003b5:	8d 95 d6 fe ff ff    	lea    -0x12a(%ebp),%edx
  8003bb:	52                   	push   %edx
  8003bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003bf:	50                   	push   %eax
  8003c0:	e8 3d 37 00 00       	call   803b02 <get_semaphore>
  8003c5:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerkTerminated = get_semaphore(parentenvID, _clerkTerminated);
  8003c8:	8d 85 80 fe ff ff    	lea    -0x180(%ebp),%eax
  8003ce:	83 ec 04             	sub    $0x4,%esp
  8003d1:	8d 95 a9 fe ff ff    	lea    -0x157(%ebp),%edx
  8003d7:	52                   	push   %edx
  8003d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003db:	50                   	push   %eax
  8003dc:	e8 21 37 00 00       	call   803b02 <get_semaphore>
  8003e1:	83 c4 0c             	add    $0xc,%esp

	while(*isOpened)
  8003e4:	e9 71 03 00 00       	jmp    80075a <_main+0x722>
	{
		int custId;
		//wait for a customer
		wait_semaphore(cust_ready);
  8003e9:	83 ec 0c             	sub    $0xc,%esp
  8003ec:	ff b5 94 fe ff ff    	pushl  -0x16c(%ebp)
  8003f2:	e8 25 37 00 00       	call   803b1c <wait_semaphore>
  8003f7:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		wait_semaphore(custQueueCS);
  8003fa:	83 ec 0c             	sub    $0xc,%esp
  8003fd:	ff b5 90 fe ff ff    	pushl  -0x170(%ebp)
  800403:	e8 14 37 00 00       	call   803b1c <wait_semaphore>
  800408:	83 c4 10             	add    $0x10,%esp
		{
			//cprintf("*queue_out = %d\n", *queue_out);
			custId = cust_ready_queue[*queue_out];
  80040b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800417:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80041a:	01 d0                	add    %edx,%eax
  80041c:	8b 00                	mov    (%eax),%eax
  80041e:	89 45 b8             	mov    %eax,-0x48(%ebp)
			//there's no more customers for now...
			if (custId == -1)
  800421:	83 7d b8 ff          	cmpl   $0xffffffff,-0x48(%ebp)
  800425:	75 16                	jne    80043d <_main+0x405>
			{
				signal_semaphore(custQueueCS);
  800427:	83 ec 0c             	sub    $0xc,%esp
  80042a:	ff b5 90 fe ff ff    	pushl  -0x170(%ebp)
  800430:	e8 01 37 00 00       	call   803b36 <signal_semaphore>
  800435:	83 c4 10             	add    $0x10,%esp
  800438:	e9 1d 03 00 00       	jmp    80075a <_main+0x722>
				continue;
			}
			*queue_out = *queue_out +1;
  80043d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800440:	8b 00                	mov    (%eax),%eax
  800442:	8d 50 01             	lea    0x1(%eax),%edx
  800445:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800448:	89 10                	mov    %edx,(%eax)
		}
		signal_semaphore(custQueueCS);
  80044a:	83 ec 0c             	sub    $0xc,%esp
  80044d:	ff b5 90 fe ff ff    	pushl  -0x170(%ebp)
  800453:	e8 de 36 00 00       	call   803b36 <signal_semaphore>
  800458:	83 c4 10             	add    $0x10,%esp

		//try reserving on the required flight
		int custFlightType = customers[custId].flightType;
  80045b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80045e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800465:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800468:	01 d0                	add    %edx,%eax
  80046a:	8b 00                	mov    (%eax),%eax
  80046c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		//cprintf("custId dequeued = %d, ft = %d\n", custId, customers[custId].flightType);

		switch (custFlightType)
  80046f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800472:	83 f8 02             	cmp    $0x2,%eax
  800475:	0f 84 9d 00 00 00    	je     800518 <_main+0x4e0>
  80047b:	83 f8 03             	cmp    $0x3,%eax
  80047e:	0f 84 1f 01 00 00    	je     8005a3 <_main+0x56b>
  800484:	83 f8 01             	cmp    $0x1,%eax
  800487:	0f 85 17 02 00 00    	jne    8006a4 <_main+0x66c>
		{
		case 1:
		{
			//Check and update Flight1
			wait_semaphore(flight1CS);
  80048d:	83 ec 0c             	sub    $0xc,%esp
  800490:	ff b5 8c fe ff ff    	pushl  -0x174(%ebp)
  800496:	e8 81 36 00 00       	call   803b1c <wait_semaphore>
  80049b:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0)
  80049e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004a1:	8b 00                	mov    (%eax),%eax
  8004a3:	85 c0                	test   %eax,%eax
  8004a5:	7e 48                	jle    8004ef <_main+0x4b7>
				{
					*flight1Counter = *flight1Counter - 1;
  8004a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004aa:	8b 00                	mov    (%eax),%eax
  8004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  8004af:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004b2:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  8004b4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004b7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8004be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  8004ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004cd:	8b 00                	mov    (%eax),%eax
  8004cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004d9:	01 c2                	add    %eax,%edx
  8004db:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004de:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  8004e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004e3:	8b 00                	mov    (%eax),%eax
  8004e5:	8d 50 01             	lea    0x1(%eax),%edx
  8004e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004eb:	89 10                	mov    %edx,(%eax)
  8004ed:	eb 13                	jmp    800502 <_main+0x4ca>
				}
				else
				{
					cprintf("%~\nFlight#1 is FULL! Reservation request of customer#%d is rejected\n", custId);
  8004ef:	83 ec 08             	sub    $0x8,%esp
  8004f2:	ff 75 b8             	pushl  -0x48(%ebp)
  8004f5:	68 c0 3d 80 00       	push   $0x803dc0
  8004fa:	e8 30 07 00 00       	call   800c2f <cprintf>
  8004ff:	83 c4 10             	add    $0x10,%esp
				}
			}
			signal_semaphore(flight1CS);
  800502:	83 ec 0c             	sub    $0xc,%esp
  800505:	ff b5 8c fe ff ff    	pushl  -0x174(%ebp)
  80050b:	e8 26 36 00 00       	call   803b36 <signal_semaphore>
  800510:	83 c4 10             	add    $0x10,%esp
		}

		break;
  800513:	e9 a3 01 00 00       	jmp    8006bb <_main+0x683>
		case 2:
		{
			//Check and update Flight2
			wait_semaphore(flight2CS);
  800518:	83 ec 0c             	sub    $0xc,%esp
  80051b:	ff b5 88 fe ff ff    	pushl  -0x178(%ebp)
  800521:	e8 f6 35 00 00       	call   803b1c <wait_semaphore>
  800526:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight2Counter > 0)
  800529:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80052c:	8b 00                	mov    (%eax),%eax
  80052e:	85 c0                	test   %eax,%eax
  800530:	7e 48                	jle    80057a <_main+0x542>
				{
					*flight2Counter = *flight2Counter - 1;
  800532:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800535:	8b 00                	mov    (%eax),%eax
  800537:	8d 50 ff             	lea    -0x1(%eax),%edx
  80053a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80053d:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  80053f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800542:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800549:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054c:	01 d0                	add    %edx,%eax
  80054e:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  800555:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800561:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800564:	01 c2                	add    %eax,%edx
  800566:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800569:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  80056b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	8d 50 01             	lea    0x1(%eax),%edx
  800573:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800576:	89 10                	mov    %edx,(%eax)
  800578:	eb 13                	jmp    80058d <_main+0x555>
				}
				else
				{
					cprintf("%~\nFlight#2 is FULL! Reservation request of customer#%d is rejected\n", custId);
  80057a:	83 ec 08             	sub    $0x8,%esp
  80057d:	ff 75 b8             	pushl  -0x48(%ebp)
  800580:	68 08 3e 80 00       	push   $0x803e08
  800585:	e8 a5 06 00 00       	call   800c2f <cprintf>
  80058a:	83 c4 10             	add    $0x10,%esp
				}
			}
			signal_semaphore(flight2CS);
  80058d:	83 ec 0c             	sub    $0xc,%esp
  800590:	ff b5 88 fe ff ff    	pushl  -0x178(%ebp)
  800596:	e8 9b 35 00 00       	call   803b36 <signal_semaphore>
  80059b:	83 c4 10             	add    $0x10,%esp
		}
		break;
  80059e:	e9 18 01 00 00       	jmp    8006bb <_main+0x683>
		case 3:
		{
			//Check and update Both Flights
			wait_semaphore(flight1CS); wait_semaphore(flight2CS);
  8005a3:	83 ec 0c             	sub    $0xc,%esp
  8005a6:	ff b5 8c fe ff ff    	pushl  -0x174(%ebp)
  8005ac:	e8 6b 35 00 00       	call   803b1c <wait_semaphore>
  8005b1:	83 c4 10             	add    $0x10,%esp
  8005b4:	83 ec 0c             	sub    $0xc,%esp
  8005b7:	ff b5 88 fe ff ff    	pushl  -0x178(%ebp)
  8005bd:	e8 5a 35 00 00       	call   803b1c <wait_semaphore>
  8005c2:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0 && *flight2Counter >0 )
  8005c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	85 c0                	test   %eax,%eax
  8005cc:	0f 8e 9b 00 00 00    	jle    80066d <_main+0x635>
  8005d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	85 c0                	test   %eax,%eax
  8005d9:	0f 8e 8e 00 00 00    	jle    80066d <_main+0x635>
				{
					*flight1Counter = *flight1Counter - 1;
  8005df:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8005e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005ea:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  8005ec:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8005ef:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8005f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f9:	01 d0                	add    %edx,%eax
  8005fb:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  800602:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800605:	8b 00                	mov    (%eax),%eax
  800607:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80060e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800611:	01 c2                	add    %eax,%edx
  800613:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800616:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  800618:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	8d 50 01             	lea    0x1(%eax),%edx
  800620:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800623:	89 10                	mov    %edx,(%eax)

					*flight2Counter = *flight2Counter - 1;
  800625:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80062d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800630:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800632:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800635:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80063c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80063f:	01 d0                	add    %edx,%eax
  800641:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  800648:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80064b:	8b 00                	mov    (%eax),%eax
  80064d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800654:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800657:	01 c2                	add    %eax,%edx
  800659:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80065c:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  80065e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800661:	8b 00                	mov    (%eax),%eax
  800663:	8d 50 01             	lea    0x1(%eax),%edx
  800666:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800669:	89 10                	mov    %edx,(%eax)
  80066b:	eb 13                	jmp    800680 <_main+0x648>

				}
				else
				{
					cprintf("%~\nFlight#1 and/or Flight#2 is FULL! Reservation request of customer#%d is rejected\n", custId);
  80066d:	83 ec 08             	sub    $0x8,%esp
  800670:	ff 75 b8             	pushl  -0x48(%ebp)
  800673:	68 50 3e 80 00       	push   $0x803e50
  800678:	e8 b2 05 00 00       	call   800c2f <cprintf>
  80067d:	83 c4 10             	add    $0x10,%esp
				}
			}
			signal_semaphore(flight1CS); signal_semaphore(flight2CS);
  800680:	83 ec 0c             	sub    $0xc,%esp
  800683:	ff b5 8c fe ff ff    	pushl  -0x174(%ebp)
  800689:	e8 a8 34 00 00       	call   803b36 <signal_semaphore>
  80068e:	83 c4 10             	add    $0x10,%esp
  800691:	83 ec 0c             	sub    $0xc,%esp
  800694:	ff b5 88 fe ff ff    	pushl  -0x178(%ebp)
  80069a:	e8 97 34 00 00       	call   803b36 <signal_semaphore>
  80069f:	83 c4 10             	add    $0x10,%esp
		}
		break;
  8006a2:	eb 17                	jmp    8006bb <_main+0x683>
		default:
			panic("customer must have flight type\n");
  8006a4:	83 ec 04             	sub    $0x4,%esp
  8006a7:	68 a8 3e 80 00       	push   $0x803ea8
  8006ac:	68 a4 00 00 00       	push   $0xa4
  8006b1:	68 c8 3e 80 00       	push   $0x803ec8
  8006b6:	e8 86 02 00 00       	call   800941 <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  8006bb:	8d 85 62 fe ff ff    	lea    -0x19e(%ebp),%eax
  8006c1:	bb 12 40 80 00       	mov    $0x804012,%ebx
  8006c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8006cb:	89 c7                	mov    %eax,%edi
  8006cd:	89 de                	mov    %ebx,%esi
  8006cf:	89 d1                	mov    %edx,%ecx
  8006d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8006d3:	8d 95 70 fe ff ff    	lea    -0x190(%ebp),%edx
  8006d9:	b9 04 00 00 00       	mov    $0x4,%ecx
  8006de:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e3:	89 d7                	mov    %edx,%edi
  8006e5:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(custId, id);
  8006e7:	83 ec 08             	sub    $0x8,%esp
  8006ea:	8d 85 5d fe ff ff    	lea    -0x1a3(%ebp),%eax
  8006f0:	50                   	push   %eax
  8006f1:	ff 75 b8             	pushl  -0x48(%ebp)
  8006f4:	e8 64 11 00 00       	call   80185d <ltostr>
  8006f9:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	8d 85 26 fe ff ff    	lea    -0x1da(%ebp),%eax
  800705:	50                   	push   %eax
  800706:	8d 85 5d fe ff ff    	lea    -0x1a3(%ebp),%eax
  80070c:	50                   	push   %eax
  80070d:	8d 85 62 fe ff ff    	lea    -0x19e(%ebp),%eax
  800713:	50                   	push   %eax
  800714:	e8 1d 12 00 00       	call   801936 <strcconcat>
  800719:	83 c4 10             	add    $0x10,%esp
		//sys_signalSemaphore(parentenvID, sname);
		struct semaphore cust_finished = get_semaphore(parentenvID, sname);
  80071c:	8d 85 58 fe ff ff    	lea    -0x1a8(%ebp),%eax
  800722:	83 ec 04             	sub    $0x4,%esp
  800725:	8d 95 26 fe ff ff    	lea    -0x1da(%ebp),%edx
  80072b:	52                   	push   %edx
  80072c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80072f:	50                   	push   %eax
  800730:	e8 cd 33 00 00       	call   803b02 <get_semaphore>
  800735:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(cust_finished);
  800738:	83 ec 0c             	sub    $0xc,%esp
  80073b:	ff b5 58 fe ff ff    	pushl  -0x1a8(%ebp)
  800741:	e8 f0 33 00 00       	call   803b36 <signal_semaphore>
  800746:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		signal_semaphore(clerk);
  800749:	83 ec 0c             	sub    $0xc,%esp
  80074c:	ff b5 84 fe ff ff    	pushl  -0x17c(%ebp)
  800752:	e8 df 33 00 00       	call   803b36 <signal_semaphore>
  800757:	83 c4 10             	add    $0x10,%esp
	struct semaphore flight1CS = get_semaphore(parentenvID, _flight1CS);
	struct semaphore flight2CS = get_semaphore(parentenvID, _flight2CS);
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
	struct semaphore clerkTerminated = get_semaphore(parentenvID, _clerkTerminated);

	while(*isOpened)
  80075a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80075d:	8b 00                	mov    (%eax),%eax
  80075f:	85 c0                	test   %eax,%eax
  800761:	0f 85 82 fc ff ff    	jne    8003e9 <_main+0x3b1>

		//signal the clerk
		signal_semaphore(clerk);
	}

	cprintf("\nclerk is finished...........\n");
  800767:	83 ec 0c             	sub    $0xc,%esp
  80076a:	68 e0 3e 80 00       	push   $0x803ee0
  80076f:	e8 bb 04 00 00       	call   800c2f <cprintf>
  800774:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(clerkTerminated);
  800777:	83 ec 0c             	sub    $0xc,%esp
  80077a:	ff b5 80 fe ff ff    	pushl  -0x180(%ebp)
  800780:	e8 b1 33 00 00       	call   803b36 <signal_semaphore>
  800785:	83 c4 10             	add    $0x10,%esp
}
  800788:	90                   	nop
  800789:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80078c:	5b                   	pop    %ebx
  80078d:	5e                   	pop    %esi
  80078e:	5f                   	pop    %edi
  80078f:	5d                   	pop    %ebp
  800790:	c3                   	ret    

00800791 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
  800794:	57                   	push   %edi
  800795:	56                   	push   %esi
  800796:	53                   	push   %ebx
  800797:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80079a:	e8 65 23 00 00       	call   802b04 <sys_getenvindex>
  80079f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8007a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007a5:	89 d0                	mov    %edx,%eax
  8007a7:	01 c0                	add    %eax,%eax
  8007a9:	01 d0                	add    %edx,%eax
  8007ab:	c1 e0 02             	shl    $0x2,%eax
  8007ae:	01 d0                	add    %edx,%eax
  8007b0:	c1 e0 02             	shl    $0x2,%eax
  8007b3:	01 d0                	add    %edx,%eax
  8007b5:	c1 e0 03             	shl    $0x3,%eax
  8007b8:	01 d0                	add    %edx,%eax
  8007ba:	c1 e0 02             	shl    $0x2,%eax
  8007bd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007c2:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007c7:	a1 20 50 80 00       	mov    0x805020,%eax
  8007cc:	8a 40 20             	mov    0x20(%eax),%al
  8007cf:	84 c0                	test   %al,%al
  8007d1:	74 0d                	je     8007e0 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8007d3:	a1 20 50 80 00       	mov    0x805020,%eax
  8007d8:	83 c0 20             	add    $0x20,%eax
  8007db:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007e4:	7e 0a                	jle    8007f0 <libmain+0x5f>
		binaryname = argv[0];
  8007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e9:	8b 00                	mov    (%eax),%eax
  8007eb:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8007f0:	83 ec 08             	sub    $0x8,%esp
  8007f3:	ff 75 0c             	pushl  0xc(%ebp)
  8007f6:	ff 75 08             	pushl  0x8(%ebp)
  8007f9:	e8 3a f8 ff ff       	call   800038 <_main>
  8007fe:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800801:	a1 00 50 80 00       	mov    0x805000,%eax
  800806:	85 c0                	test   %eax,%eax
  800808:	0f 84 01 01 00 00    	je     80090f <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80080e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800814:	bb 28 41 80 00       	mov    $0x804128,%ebx
  800819:	ba 0e 00 00 00       	mov    $0xe,%edx
  80081e:	89 c7                	mov    %eax,%edi
  800820:	89 de                	mov    %ebx,%esi
  800822:	89 d1                	mov    %edx,%ecx
  800824:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800826:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800829:	b9 56 00 00 00       	mov    $0x56,%ecx
  80082e:	b0 00                	mov    $0x0,%al
  800830:	89 d7                	mov    %edx,%edi
  800832:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800834:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80083b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80083e:	83 ec 08             	sub    $0x8,%esp
  800841:	50                   	push   %eax
  800842:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800848:	50                   	push   %eax
  800849:	e8 ec 24 00 00       	call   802d3a <sys_utilities>
  80084e:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800851:	e8 35 20 00 00       	call   80288b <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800856:	83 ec 0c             	sub    $0xc,%esp
  800859:	68 48 40 80 00       	push   $0x804048
  80085e:	e8 cc 03 00 00       	call   800c2f <cprintf>
  800863:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800866:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800869:	85 c0                	test   %eax,%eax
  80086b:	74 18                	je     800885 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80086d:	e8 e6 24 00 00       	call   802d58 <sys_get_optimal_num_faults>
  800872:	83 ec 08             	sub    $0x8,%esp
  800875:	50                   	push   %eax
  800876:	68 70 40 80 00       	push   $0x804070
  80087b:	e8 af 03 00 00       	call   800c2f <cprintf>
  800880:	83 c4 10             	add    $0x10,%esp
  800883:	eb 59                	jmp    8008de <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800885:	a1 20 50 80 00       	mov    0x805020,%eax
  80088a:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800890:	a1 20 50 80 00       	mov    0x805020,%eax
  800895:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  80089b:	83 ec 04             	sub    $0x4,%esp
  80089e:	52                   	push   %edx
  80089f:	50                   	push   %eax
  8008a0:	68 94 40 80 00       	push   $0x804094
  8008a5:	e8 85 03 00 00       	call   800c2f <cprintf>
  8008aa:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8008ad:	a1 20 50 80 00       	mov    0x805020,%eax
  8008b2:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8008b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8008bd:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8008c3:	a1 20 50 80 00       	mov    0x805020,%eax
  8008c8:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  8008ce:	51                   	push   %ecx
  8008cf:	52                   	push   %edx
  8008d0:	50                   	push   %eax
  8008d1:	68 bc 40 80 00       	push   $0x8040bc
  8008d6:	e8 54 03 00 00       	call   800c2f <cprintf>
  8008db:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008de:	a1 20 50 80 00       	mov    0x805020,%eax
  8008e3:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	50                   	push   %eax
  8008ed:	68 14 41 80 00       	push   $0x804114
  8008f2:	e8 38 03 00 00       	call   800c2f <cprintf>
  8008f7:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8008fa:	83 ec 0c             	sub    $0xc,%esp
  8008fd:	68 48 40 80 00       	push   $0x804048
  800902:	e8 28 03 00 00       	call   800c2f <cprintf>
  800907:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80090a:	e8 96 1f 00 00       	call   8028a5 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80090f:	e8 1f 00 00 00       	call   800933 <exit>
}
  800914:	90                   	nop
  800915:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800918:	5b                   	pop    %ebx
  800919:	5e                   	pop    %esi
  80091a:	5f                   	pop    %edi
  80091b:	5d                   	pop    %ebp
  80091c:	c3                   	ret    

0080091d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80091d:	55                   	push   %ebp
  80091e:	89 e5                	mov    %esp,%ebp
  800920:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800923:	83 ec 0c             	sub    $0xc,%esp
  800926:	6a 00                	push   $0x0
  800928:	e8 a3 21 00 00       	call   802ad0 <sys_destroy_env>
  80092d:	83 c4 10             	add    $0x10,%esp
}
  800930:	90                   	nop
  800931:	c9                   	leave  
  800932:	c3                   	ret    

00800933 <exit>:

void
exit(void)
{
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800939:	e8 f8 21 00 00       	call   802b36 <sys_exit_env>
}
  80093e:	90                   	nop
  80093f:	c9                   	leave  
  800940:	c3                   	ret    

00800941 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800947:	8d 45 10             	lea    0x10(%ebp),%eax
  80094a:	83 c0 04             	add    $0x4,%eax
  80094d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800950:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800955:	85 c0                	test   %eax,%eax
  800957:	74 16                	je     80096f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800959:	a1 18 d1 81 00       	mov    0x81d118,%eax
  80095e:	83 ec 08             	sub    $0x8,%esp
  800961:	50                   	push   %eax
  800962:	68 8c 41 80 00       	push   $0x80418c
  800967:	e8 c3 02 00 00       	call   800c2f <cprintf>
  80096c:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80096f:	a1 04 50 80 00       	mov    0x805004,%eax
  800974:	83 ec 0c             	sub    $0xc,%esp
  800977:	ff 75 0c             	pushl  0xc(%ebp)
  80097a:	ff 75 08             	pushl  0x8(%ebp)
  80097d:	50                   	push   %eax
  80097e:	68 94 41 80 00       	push   $0x804194
  800983:	6a 74                	push   $0x74
  800985:	e8 d2 02 00 00       	call   800c5c <cprintf_colored>
  80098a:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80098d:	8b 45 10             	mov    0x10(%ebp),%eax
  800990:	83 ec 08             	sub    $0x8,%esp
  800993:	ff 75 f4             	pushl  -0xc(%ebp)
  800996:	50                   	push   %eax
  800997:	e8 24 02 00 00       	call   800bc0 <vcprintf>
  80099c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80099f:	83 ec 08             	sub    $0x8,%esp
  8009a2:	6a 00                	push   $0x0
  8009a4:	68 bc 41 80 00       	push   $0x8041bc
  8009a9:	e8 12 02 00 00       	call   800bc0 <vcprintf>
  8009ae:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8009b1:	e8 7d ff ff ff       	call   800933 <exit>

	// should not return here
	while (1) ;
  8009b6:	eb fe                	jmp    8009b6 <_panic+0x75>

008009b8 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	53                   	push   %ebx
  8009bc:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8009bf:	a1 20 50 80 00       	mov    0x805020,%eax
  8009c4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8009ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cd:	39 c2                	cmp    %eax,%edx
  8009cf:	74 14                	je     8009e5 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8009d1:	83 ec 04             	sub    $0x4,%esp
  8009d4:	68 c0 41 80 00       	push   $0x8041c0
  8009d9:	6a 26                	push   $0x26
  8009db:	68 0c 42 80 00       	push   $0x80420c
  8009e0:	e8 5c ff ff ff       	call   800941 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009f3:	e9 d9 00 00 00       	jmp    800ad1 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8009f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	01 d0                	add    %edx,%eax
  800a07:	8b 00                	mov    (%eax),%eax
  800a09:	85 c0                	test   %eax,%eax
  800a0b:	75 08                	jne    800a15 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  800a0d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800a10:	e9 b9 00 00 00       	jmp    800ace <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800a15:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a1c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a23:	eb 79                	jmp    800a9e <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a25:	a1 20 50 80 00       	mov    0x805020,%eax
  800a2a:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800a30:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a33:	89 d0                	mov    %edx,%eax
  800a35:	01 c0                	add    %eax,%eax
  800a37:	01 d0                	add    %edx,%eax
  800a39:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800a40:	01 d8                	add    %ebx,%eax
  800a42:	01 d0                	add    %edx,%eax
  800a44:	01 c8                	add    %ecx,%eax
  800a46:	8a 40 04             	mov    0x4(%eax),%al
  800a49:	84 c0                	test   %al,%al
  800a4b:	75 4e                	jne    800a9b <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a4d:	a1 20 50 80 00       	mov    0x805020,%eax
  800a52:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800a58:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a5b:	89 d0                	mov    %edx,%eax
  800a5d:	01 c0                	add    %eax,%eax
  800a5f:	01 d0                	add    %edx,%eax
  800a61:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800a68:	01 d8                	add    %ebx,%eax
  800a6a:	01 d0                	add    %edx,%eax
  800a6c:	01 c8                	add    %ecx,%eax
  800a6e:	8b 00                	mov    (%eax),%eax
  800a70:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a73:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a7b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a80:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	01 c8                	add    %ecx,%eax
  800a8c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a8e:	39 c2                	cmp    %eax,%edx
  800a90:	75 09                	jne    800a9b <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  800a92:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a99:	eb 19                	jmp    800ab4 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a9b:	ff 45 e8             	incl   -0x18(%ebp)
  800a9e:	a1 20 50 80 00       	mov    0x805020,%eax
  800aa3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800aa9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800aac:	39 c2                	cmp    %eax,%edx
  800aae:	0f 87 71 ff ff ff    	ja     800a25 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800ab4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ab8:	75 14                	jne    800ace <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800aba:	83 ec 04             	sub    $0x4,%esp
  800abd:	68 18 42 80 00       	push   $0x804218
  800ac2:	6a 3a                	push   $0x3a
  800ac4:	68 0c 42 80 00       	push   $0x80420c
  800ac9:	e8 73 fe ff ff       	call   800941 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800ace:	ff 45 f0             	incl   -0x10(%ebp)
  800ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ad4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800ad7:	0f 8c 1b ff ff ff    	jl     8009f8 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800add:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ae4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800aeb:	eb 2e                	jmp    800b1b <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800aed:	a1 20 50 80 00       	mov    0x805020,%eax
  800af2:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800af8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800afb:	89 d0                	mov    %edx,%eax
  800afd:	01 c0                	add    %eax,%eax
  800aff:	01 d0                	add    %edx,%eax
  800b01:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800b08:	01 d8                	add    %ebx,%eax
  800b0a:	01 d0                	add    %edx,%eax
  800b0c:	01 c8                	add    %ecx,%eax
  800b0e:	8a 40 04             	mov    0x4(%eax),%al
  800b11:	3c 01                	cmp    $0x1,%al
  800b13:	75 03                	jne    800b18 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800b15:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b18:	ff 45 e0             	incl   -0x20(%ebp)
  800b1b:	a1 20 50 80 00       	mov    0x805020,%eax
  800b20:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800b26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b29:	39 c2                	cmp    %eax,%edx
  800b2b:	77 c0                	ja     800aed <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b30:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b33:	74 14                	je     800b49 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800b35:	83 ec 04             	sub    $0x4,%esp
  800b38:	68 6c 42 80 00       	push   $0x80426c
  800b3d:	6a 44                	push   $0x44
  800b3f:	68 0c 42 80 00       	push   $0x80420c
  800b44:	e8 f8 fd ff ff       	call   800941 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b49:	90                   	nop
  800b4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b4d:	c9                   	leave  
  800b4e:	c3                   	ret    

00800b4f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	53                   	push   %ebx
  800b53:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b59:	8b 00                	mov    (%eax),%eax
  800b5b:	8d 48 01             	lea    0x1(%eax),%ecx
  800b5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b61:	89 0a                	mov    %ecx,(%edx)
  800b63:	8b 55 08             	mov    0x8(%ebp),%edx
  800b66:	88 d1                	mov    %dl,%cl
  800b68:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b72:	8b 00                	mov    (%eax),%eax
  800b74:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b79:	75 30                	jne    800bab <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800b7b:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800b81:	a0 44 50 80 00       	mov    0x805044,%al
  800b86:	0f b6 c0             	movzbl %al,%eax
  800b89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b8c:	8b 09                	mov    (%ecx),%ecx
  800b8e:	89 cb                	mov    %ecx,%ebx
  800b90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b93:	83 c1 08             	add    $0x8,%ecx
  800b96:	52                   	push   %edx
  800b97:	50                   	push   %eax
  800b98:	53                   	push   %ebx
  800b99:	51                   	push   %ecx
  800b9a:	e8 a8 1c 00 00       	call   802847 <sys_cputs>
  800b9f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ba2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800bab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bae:	8b 40 04             	mov    0x4(%eax),%eax
  800bb1:	8d 50 01             	lea    0x1(%eax),%edx
  800bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb7:	89 50 04             	mov    %edx,0x4(%eax)
}
  800bba:	90                   	nop
  800bbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800bc9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800bd0:	00 00 00 
	b.cnt = 0;
  800bd3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800bda:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800bdd:	ff 75 0c             	pushl  0xc(%ebp)
  800be0:	ff 75 08             	pushl  0x8(%ebp)
  800be3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800be9:	50                   	push   %eax
  800bea:	68 4f 0b 80 00       	push   $0x800b4f
  800bef:	e8 5a 02 00 00       	call   800e4e <vprintfmt>
  800bf4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800bf7:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800bfd:	a0 44 50 80 00       	mov    0x805044,%al
  800c02:	0f b6 c0             	movzbl %al,%eax
  800c05:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800c0b:	52                   	push   %edx
  800c0c:	50                   	push   %eax
  800c0d:	51                   	push   %ecx
  800c0e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c14:	83 c0 08             	add    $0x8,%eax
  800c17:	50                   	push   %eax
  800c18:	e8 2a 1c 00 00       	call   802847 <sys_cputs>
  800c1d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c20:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  800c27:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c2d:	c9                   	leave  
  800c2e:	c3                   	ret    

00800c2f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c35:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800c3c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	83 ec 08             	sub    $0x8,%esp
  800c48:	ff 75 f4             	pushl  -0xc(%ebp)
  800c4b:	50                   	push   %eax
  800c4c:	e8 6f ff ff ff       	call   800bc0 <vcprintf>
  800c51:	83 c4 10             	add    $0x10,%esp
  800c54:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c5a:	c9                   	leave  
  800c5b:	c3                   	ret    

00800c5c <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c62:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	c1 e0 08             	shl    $0x8,%eax
  800c6f:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  800c74:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c77:	83 c0 04             	add    $0x4,%eax
  800c7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c80:	83 ec 08             	sub    $0x8,%esp
  800c83:	ff 75 f4             	pushl  -0xc(%ebp)
  800c86:	50                   	push   %eax
  800c87:	e8 34 ff ff ff       	call   800bc0 <vcprintf>
  800c8c:	83 c4 10             	add    $0x10,%esp
  800c8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800c92:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  800c99:	07 00 00 

	return cnt;
  800c9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c9f:	c9                   	leave  
  800ca0:	c3                   	ret    

00800ca1 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800ca1:	55                   	push   %ebp
  800ca2:	89 e5                	mov    %esp,%ebp
  800ca4:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800ca7:	e8 df 1b 00 00       	call   80288b <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800cac:	8d 45 0c             	lea    0xc(%ebp),%eax
  800caf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	83 ec 08             	sub    $0x8,%esp
  800cb8:	ff 75 f4             	pushl  -0xc(%ebp)
  800cbb:	50                   	push   %eax
  800cbc:	e8 ff fe ff ff       	call   800bc0 <vcprintf>
  800cc1:	83 c4 10             	add    $0x10,%esp
  800cc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800cc7:	e8 d9 1b 00 00       	call   8028a5 <sys_unlock_cons>
	return cnt;
  800ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ccf:	c9                   	leave  
  800cd0:	c3                   	ret    

00800cd1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	53                   	push   %ebx
  800cd5:	83 ec 14             	sub    $0x14,%esp
  800cd8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cde:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ce4:	8b 45 18             	mov    0x18(%ebp),%eax
  800ce7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cec:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cef:	77 55                	ja     800d46 <printnum+0x75>
  800cf1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cf4:	72 05                	jb     800cfb <printnum+0x2a>
  800cf6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800cf9:	77 4b                	ja     800d46 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800cfb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800cfe:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800d01:	8b 45 18             	mov    0x18(%ebp),%eax
  800d04:	ba 00 00 00 00       	mov    $0x0,%edx
  800d09:	52                   	push   %edx
  800d0a:	50                   	push   %eax
  800d0b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d0e:	ff 75 f0             	pushl  -0x10(%ebp)
  800d11:	e8 46 2e 00 00       	call   803b5c <__udivdi3>
  800d16:	83 c4 10             	add    $0x10,%esp
  800d19:	83 ec 04             	sub    $0x4,%esp
  800d1c:	ff 75 20             	pushl  0x20(%ebp)
  800d1f:	53                   	push   %ebx
  800d20:	ff 75 18             	pushl  0x18(%ebp)
  800d23:	52                   	push   %edx
  800d24:	50                   	push   %eax
  800d25:	ff 75 0c             	pushl  0xc(%ebp)
  800d28:	ff 75 08             	pushl  0x8(%ebp)
  800d2b:	e8 a1 ff ff ff       	call   800cd1 <printnum>
  800d30:	83 c4 20             	add    $0x20,%esp
  800d33:	eb 1a                	jmp    800d4f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d35:	83 ec 08             	sub    $0x8,%esp
  800d38:	ff 75 0c             	pushl  0xc(%ebp)
  800d3b:	ff 75 20             	pushl  0x20(%ebp)
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	ff d0                	call   *%eax
  800d43:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d46:	ff 4d 1c             	decl   0x1c(%ebp)
  800d49:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d4d:	7f e6                	jg     800d35 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d4f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d52:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d5d:	53                   	push   %ebx
  800d5e:	51                   	push   %ecx
  800d5f:	52                   	push   %edx
  800d60:	50                   	push   %eax
  800d61:	e8 06 2f 00 00       	call   803c6c <__umoddi3>
  800d66:	83 c4 10             	add    $0x10,%esp
  800d69:	05 d4 44 80 00       	add    $0x8044d4,%eax
  800d6e:	8a 00                	mov    (%eax),%al
  800d70:	0f be c0             	movsbl %al,%eax
  800d73:	83 ec 08             	sub    $0x8,%esp
  800d76:	ff 75 0c             	pushl  0xc(%ebp)
  800d79:	50                   	push   %eax
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7d:	ff d0                	call   *%eax
  800d7f:	83 c4 10             	add    $0x10,%esp
}
  800d82:	90                   	nop
  800d83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d86:	c9                   	leave  
  800d87:	c3                   	ret    

00800d88 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d8b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d8f:	7e 1c                	jle    800dad <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
  800d94:	8b 00                	mov    (%eax),%eax
  800d96:	8d 50 08             	lea    0x8(%eax),%edx
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	89 10                	mov    %edx,(%eax)
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8b 00                	mov    (%eax),%eax
  800da3:	83 e8 08             	sub    $0x8,%eax
  800da6:	8b 50 04             	mov    0x4(%eax),%edx
  800da9:	8b 00                	mov    (%eax),%eax
  800dab:	eb 40                	jmp    800ded <getuint+0x65>
	else if (lflag)
  800dad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db1:	74 1e                	je     800dd1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	8b 00                	mov    (%eax),%eax
  800db8:	8d 50 04             	lea    0x4(%eax),%edx
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	89 10                	mov    %edx,(%eax)
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8b 00                	mov    (%eax),%eax
  800dc5:	83 e8 04             	sub    $0x4,%eax
  800dc8:	8b 00                	mov    (%eax),%eax
  800dca:	ba 00 00 00 00       	mov    $0x0,%edx
  800dcf:	eb 1c                	jmp    800ded <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	8b 00                	mov    (%eax),%eax
  800dd6:	8d 50 04             	lea    0x4(%eax),%edx
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	89 10                	mov    %edx,(%eax)
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	8b 00                	mov    (%eax),%eax
  800de3:	83 e8 04             	sub    $0x4,%eax
  800de6:	8b 00                	mov    (%eax),%eax
  800de8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ded:	5d                   	pop    %ebp
  800dee:	c3                   	ret    

00800def <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800df2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800df6:	7e 1c                	jle    800e14 <getint+0x25>
		return va_arg(*ap, long long);
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8b 00                	mov    (%eax),%eax
  800dfd:	8d 50 08             	lea    0x8(%eax),%edx
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	89 10                	mov    %edx,(%eax)
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8b 00                	mov    (%eax),%eax
  800e0a:	83 e8 08             	sub    $0x8,%eax
  800e0d:	8b 50 04             	mov    0x4(%eax),%edx
  800e10:	8b 00                	mov    (%eax),%eax
  800e12:	eb 38                	jmp    800e4c <getint+0x5d>
	else if (lflag)
  800e14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e18:	74 1a                	je     800e34 <getint+0x45>
		return va_arg(*ap, long);
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	8b 00                	mov    (%eax),%eax
  800e1f:	8d 50 04             	lea    0x4(%eax),%edx
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	89 10                	mov    %edx,(%eax)
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8b 00                	mov    (%eax),%eax
  800e2c:	83 e8 04             	sub    $0x4,%eax
  800e2f:	8b 00                	mov    (%eax),%eax
  800e31:	99                   	cltd   
  800e32:	eb 18                	jmp    800e4c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	8b 00                	mov    (%eax),%eax
  800e39:	8d 50 04             	lea    0x4(%eax),%edx
  800e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3f:	89 10                	mov    %edx,(%eax)
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8b 00                	mov    (%eax),%eax
  800e46:	83 e8 04             	sub    $0x4,%eax
  800e49:	8b 00                	mov    (%eax),%eax
  800e4b:	99                   	cltd   
}
  800e4c:	5d                   	pop    %ebp
  800e4d:	c3                   	ret    

00800e4e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e4e:	55                   	push   %ebp
  800e4f:	89 e5                	mov    %esp,%ebp
  800e51:	56                   	push   %esi
  800e52:	53                   	push   %ebx
  800e53:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e56:	eb 17                	jmp    800e6f <vprintfmt+0x21>
			if (ch == '\0')
  800e58:	85 db                	test   %ebx,%ebx
  800e5a:	0f 84 c1 03 00 00    	je     801221 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800e60:	83 ec 08             	sub    $0x8,%esp
  800e63:	ff 75 0c             	pushl  0xc(%ebp)
  800e66:	53                   	push   %ebx
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	ff d0                	call   *%eax
  800e6c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e72:	8d 50 01             	lea    0x1(%eax),%edx
  800e75:	89 55 10             	mov    %edx,0x10(%ebp)
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	0f b6 d8             	movzbl %al,%ebx
  800e7d:	83 fb 25             	cmp    $0x25,%ebx
  800e80:	75 d6                	jne    800e58 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e82:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e86:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e8d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e94:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e9b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ea2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea5:	8d 50 01             	lea    0x1(%eax),%edx
  800ea8:	89 55 10             	mov    %edx,0x10(%ebp)
  800eab:	8a 00                	mov    (%eax),%al
  800ead:	0f b6 d8             	movzbl %al,%ebx
  800eb0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800eb3:	83 f8 5b             	cmp    $0x5b,%eax
  800eb6:	0f 87 3d 03 00 00    	ja     8011f9 <vprintfmt+0x3ab>
  800ebc:	8b 04 85 f8 44 80 00 	mov    0x8044f8(,%eax,4),%eax
  800ec3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ec5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ec9:	eb d7                	jmp    800ea2 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ecb:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ecf:	eb d1                	jmp    800ea2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ed1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ed8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800edb:	89 d0                	mov    %edx,%eax
  800edd:	c1 e0 02             	shl    $0x2,%eax
  800ee0:	01 d0                	add    %edx,%eax
  800ee2:	01 c0                	add    %eax,%eax
  800ee4:	01 d8                	add    %ebx,%eax
  800ee6:	83 e8 30             	sub    $0x30,%eax
  800ee9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800eec:	8b 45 10             	mov    0x10(%ebp),%eax
  800eef:	8a 00                	mov    (%eax),%al
  800ef1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ef4:	83 fb 2f             	cmp    $0x2f,%ebx
  800ef7:	7e 3e                	jle    800f37 <vprintfmt+0xe9>
  800ef9:	83 fb 39             	cmp    $0x39,%ebx
  800efc:	7f 39                	jg     800f37 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800efe:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800f01:	eb d5                	jmp    800ed8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800f03:	8b 45 14             	mov    0x14(%ebp),%eax
  800f06:	83 c0 04             	add    $0x4,%eax
  800f09:	89 45 14             	mov    %eax,0x14(%ebp)
  800f0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0f:	83 e8 04             	sub    $0x4,%eax
  800f12:	8b 00                	mov    (%eax),%eax
  800f14:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800f17:	eb 1f                	jmp    800f38 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800f19:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f1d:	79 83                	jns    800ea2 <vprintfmt+0x54>
				width = 0;
  800f1f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f26:	e9 77 ff ff ff       	jmp    800ea2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f2b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f32:	e9 6b ff ff ff       	jmp    800ea2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f37:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f38:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f3c:	0f 89 60 ff ff ff    	jns    800ea2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800f42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f48:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f4f:	e9 4e ff ff ff       	jmp    800ea2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f54:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f57:	e9 46 ff ff ff       	jmp    800ea2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f5f:	83 c0 04             	add    $0x4,%eax
  800f62:	89 45 14             	mov    %eax,0x14(%ebp)
  800f65:	8b 45 14             	mov    0x14(%ebp),%eax
  800f68:	83 e8 04             	sub    $0x4,%eax
  800f6b:	8b 00                	mov    (%eax),%eax
  800f6d:	83 ec 08             	sub    $0x8,%esp
  800f70:	ff 75 0c             	pushl  0xc(%ebp)
  800f73:	50                   	push   %eax
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	ff d0                	call   *%eax
  800f79:	83 c4 10             	add    $0x10,%esp
			break;
  800f7c:	e9 9b 02 00 00       	jmp    80121c <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f81:	8b 45 14             	mov    0x14(%ebp),%eax
  800f84:	83 c0 04             	add    $0x4,%eax
  800f87:	89 45 14             	mov    %eax,0x14(%ebp)
  800f8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8d:	83 e8 04             	sub    $0x4,%eax
  800f90:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f92:	85 db                	test   %ebx,%ebx
  800f94:	79 02                	jns    800f98 <vprintfmt+0x14a>
				err = -err;
  800f96:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f98:	83 fb 64             	cmp    $0x64,%ebx
  800f9b:	7f 0b                	jg     800fa8 <vprintfmt+0x15a>
  800f9d:	8b 34 9d 40 43 80 00 	mov    0x804340(,%ebx,4),%esi
  800fa4:	85 f6                	test   %esi,%esi
  800fa6:	75 19                	jne    800fc1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800fa8:	53                   	push   %ebx
  800fa9:	68 e5 44 80 00       	push   $0x8044e5
  800fae:	ff 75 0c             	pushl  0xc(%ebp)
  800fb1:	ff 75 08             	pushl  0x8(%ebp)
  800fb4:	e8 70 02 00 00       	call   801229 <printfmt>
  800fb9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800fbc:	e9 5b 02 00 00       	jmp    80121c <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800fc1:	56                   	push   %esi
  800fc2:	68 ee 44 80 00       	push   $0x8044ee
  800fc7:	ff 75 0c             	pushl  0xc(%ebp)
  800fca:	ff 75 08             	pushl  0x8(%ebp)
  800fcd:	e8 57 02 00 00       	call   801229 <printfmt>
  800fd2:	83 c4 10             	add    $0x10,%esp
			break;
  800fd5:	e9 42 02 00 00       	jmp    80121c <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fda:	8b 45 14             	mov    0x14(%ebp),%eax
  800fdd:	83 c0 04             	add    $0x4,%eax
  800fe0:	89 45 14             	mov    %eax,0x14(%ebp)
  800fe3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe6:	83 e8 04             	sub    $0x4,%eax
  800fe9:	8b 30                	mov    (%eax),%esi
  800feb:	85 f6                	test   %esi,%esi
  800fed:	75 05                	jne    800ff4 <vprintfmt+0x1a6>
				p = "(null)";
  800fef:	be f1 44 80 00       	mov    $0x8044f1,%esi
			if (width > 0 && padc != '-')
  800ff4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ff8:	7e 6d                	jle    801067 <vprintfmt+0x219>
  800ffa:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ffe:	74 67                	je     801067 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801000:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801003:	83 ec 08             	sub    $0x8,%esp
  801006:	50                   	push   %eax
  801007:	56                   	push   %esi
  801008:	e8 1e 03 00 00       	call   80132b <strnlen>
  80100d:	83 c4 10             	add    $0x10,%esp
  801010:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801013:	eb 16                	jmp    80102b <vprintfmt+0x1dd>
					putch(padc, putdat);
  801015:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801019:	83 ec 08             	sub    $0x8,%esp
  80101c:	ff 75 0c             	pushl  0xc(%ebp)
  80101f:	50                   	push   %eax
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	ff d0                	call   *%eax
  801025:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801028:	ff 4d e4             	decl   -0x1c(%ebp)
  80102b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80102f:	7f e4                	jg     801015 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801031:	eb 34                	jmp    801067 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801033:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801037:	74 1c                	je     801055 <vprintfmt+0x207>
  801039:	83 fb 1f             	cmp    $0x1f,%ebx
  80103c:	7e 05                	jle    801043 <vprintfmt+0x1f5>
  80103e:	83 fb 7e             	cmp    $0x7e,%ebx
  801041:	7e 12                	jle    801055 <vprintfmt+0x207>
					putch('?', putdat);
  801043:	83 ec 08             	sub    $0x8,%esp
  801046:	ff 75 0c             	pushl  0xc(%ebp)
  801049:	6a 3f                	push   $0x3f
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	ff d0                	call   *%eax
  801050:	83 c4 10             	add    $0x10,%esp
  801053:	eb 0f                	jmp    801064 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801055:	83 ec 08             	sub    $0x8,%esp
  801058:	ff 75 0c             	pushl  0xc(%ebp)
  80105b:	53                   	push   %ebx
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	ff d0                	call   *%eax
  801061:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801064:	ff 4d e4             	decl   -0x1c(%ebp)
  801067:	89 f0                	mov    %esi,%eax
  801069:	8d 70 01             	lea    0x1(%eax),%esi
  80106c:	8a 00                	mov    (%eax),%al
  80106e:	0f be d8             	movsbl %al,%ebx
  801071:	85 db                	test   %ebx,%ebx
  801073:	74 24                	je     801099 <vprintfmt+0x24b>
  801075:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801079:	78 b8                	js     801033 <vprintfmt+0x1e5>
  80107b:	ff 4d e0             	decl   -0x20(%ebp)
  80107e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801082:	79 af                	jns    801033 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801084:	eb 13                	jmp    801099 <vprintfmt+0x24b>
				putch(' ', putdat);
  801086:	83 ec 08             	sub    $0x8,%esp
  801089:	ff 75 0c             	pushl  0xc(%ebp)
  80108c:	6a 20                	push   $0x20
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	ff d0                	call   *%eax
  801093:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801096:	ff 4d e4             	decl   -0x1c(%ebp)
  801099:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80109d:	7f e7                	jg     801086 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80109f:	e9 78 01 00 00       	jmp    80121c <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8010a4:	83 ec 08             	sub    $0x8,%esp
  8010a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8010aa:	8d 45 14             	lea    0x14(%ebp),%eax
  8010ad:	50                   	push   %eax
  8010ae:	e8 3c fd ff ff       	call   800def <getint>
  8010b3:	83 c4 10             	add    $0x10,%esp
  8010b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8010bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c2:	85 d2                	test   %edx,%edx
  8010c4:	79 23                	jns    8010e9 <vprintfmt+0x29b>
				putch('-', putdat);
  8010c6:	83 ec 08             	sub    $0x8,%esp
  8010c9:	ff 75 0c             	pushl  0xc(%ebp)
  8010cc:	6a 2d                	push   $0x2d
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d1:	ff d0                	call   *%eax
  8010d3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8010d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010dc:	f7 d8                	neg    %eax
  8010de:	83 d2 00             	adc    $0x0,%edx
  8010e1:	f7 da                	neg    %edx
  8010e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010e6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010e9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010f0:	e9 bc 00 00 00       	jmp    8011b1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010f5:	83 ec 08             	sub    $0x8,%esp
  8010f8:	ff 75 e8             	pushl  -0x18(%ebp)
  8010fb:	8d 45 14             	lea    0x14(%ebp),%eax
  8010fe:	50                   	push   %eax
  8010ff:	e8 84 fc ff ff       	call   800d88 <getuint>
  801104:	83 c4 10             	add    $0x10,%esp
  801107:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80110a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80110d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801114:	e9 98 00 00 00       	jmp    8011b1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801119:	83 ec 08             	sub    $0x8,%esp
  80111c:	ff 75 0c             	pushl  0xc(%ebp)
  80111f:	6a 58                	push   $0x58
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	ff d0                	call   *%eax
  801126:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801129:	83 ec 08             	sub    $0x8,%esp
  80112c:	ff 75 0c             	pushl  0xc(%ebp)
  80112f:	6a 58                	push   $0x58
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	ff d0                	call   *%eax
  801136:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801139:	83 ec 08             	sub    $0x8,%esp
  80113c:	ff 75 0c             	pushl  0xc(%ebp)
  80113f:	6a 58                	push   $0x58
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	ff d0                	call   *%eax
  801146:	83 c4 10             	add    $0x10,%esp
			break;
  801149:	e9 ce 00 00 00       	jmp    80121c <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80114e:	83 ec 08             	sub    $0x8,%esp
  801151:	ff 75 0c             	pushl  0xc(%ebp)
  801154:	6a 30                	push   $0x30
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	ff d0                	call   *%eax
  80115b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80115e:	83 ec 08             	sub    $0x8,%esp
  801161:	ff 75 0c             	pushl  0xc(%ebp)
  801164:	6a 78                	push   $0x78
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	ff d0                	call   *%eax
  80116b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80116e:	8b 45 14             	mov    0x14(%ebp),%eax
  801171:	83 c0 04             	add    $0x4,%eax
  801174:	89 45 14             	mov    %eax,0x14(%ebp)
  801177:	8b 45 14             	mov    0x14(%ebp),%eax
  80117a:	83 e8 04             	sub    $0x4,%eax
  80117d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80117f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801182:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801189:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801190:	eb 1f                	jmp    8011b1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801192:	83 ec 08             	sub    $0x8,%esp
  801195:	ff 75 e8             	pushl  -0x18(%ebp)
  801198:	8d 45 14             	lea    0x14(%ebp),%eax
  80119b:	50                   	push   %eax
  80119c:	e8 e7 fb ff ff       	call   800d88 <getuint>
  8011a1:	83 c4 10             	add    $0x10,%esp
  8011a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011a7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8011aa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8011b1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8011b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011b8:	83 ec 04             	sub    $0x4,%esp
  8011bb:	52                   	push   %edx
  8011bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011bf:	50                   	push   %eax
  8011c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8011c3:	ff 75 f0             	pushl  -0x10(%ebp)
  8011c6:	ff 75 0c             	pushl  0xc(%ebp)
  8011c9:	ff 75 08             	pushl  0x8(%ebp)
  8011cc:	e8 00 fb ff ff       	call   800cd1 <printnum>
  8011d1:	83 c4 20             	add    $0x20,%esp
			break;
  8011d4:	eb 46                	jmp    80121c <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011d6:	83 ec 08             	sub    $0x8,%esp
  8011d9:	ff 75 0c             	pushl  0xc(%ebp)
  8011dc:	53                   	push   %ebx
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	ff d0                	call   *%eax
  8011e2:	83 c4 10             	add    $0x10,%esp
			break;
  8011e5:	eb 35                	jmp    80121c <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8011e7:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  8011ee:	eb 2c                	jmp    80121c <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8011f0:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  8011f7:	eb 23                	jmp    80121c <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011f9:	83 ec 08             	sub    $0x8,%esp
  8011fc:	ff 75 0c             	pushl  0xc(%ebp)
  8011ff:	6a 25                	push   $0x25
  801201:	8b 45 08             	mov    0x8(%ebp),%eax
  801204:	ff d0                	call   *%eax
  801206:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801209:	ff 4d 10             	decl   0x10(%ebp)
  80120c:	eb 03                	jmp    801211 <vprintfmt+0x3c3>
  80120e:	ff 4d 10             	decl   0x10(%ebp)
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	48                   	dec    %eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	3c 25                	cmp    $0x25,%al
  801219:	75 f3                	jne    80120e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80121b:	90                   	nop
		}
	}
  80121c:	e9 35 fc ff ff       	jmp    800e56 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801221:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801222:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801225:	5b                   	pop    %ebx
  801226:	5e                   	pop    %esi
  801227:	5d                   	pop    %ebp
  801228:	c3                   	ret    

00801229 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80122f:	8d 45 10             	lea    0x10(%ebp),%eax
  801232:	83 c0 04             	add    $0x4,%eax
  801235:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801238:	8b 45 10             	mov    0x10(%ebp),%eax
  80123b:	ff 75 f4             	pushl  -0xc(%ebp)
  80123e:	50                   	push   %eax
  80123f:	ff 75 0c             	pushl  0xc(%ebp)
  801242:	ff 75 08             	pushl  0x8(%ebp)
  801245:	e8 04 fc ff ff       	call   800e4e <vprintfmt>
  80124a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80124d:	90                   	nop
  80124e:	c9                   	leave  
  80124f:	c3                   	ret    

00801250 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801253:	8b 45 0c             	mov    0xc(%ebp),%eax
  801256:	8b 40 08             	mov    0x8(%eax),%eax
  801259:	8d 50 01             	lea    0x1(%eax),%edx
  80125c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801262:	8b 45 0c             	mov    0xc(%ebp),%eax
  801265:	8b 10                	mov    (%eax),%edx
  801267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126a:	8b 40 04             	mov    0x4(%eax),%eax
  80126d:	39 c2                	cmp    %eax,%edx
  80126f:	73 12                	jae    801283 <sprintputch+0x33>
		*b->buf++ = ch;
  801271:	8b 45 0c             	mov    0xc(%ebp),%eax
  801274:	8b 00                	mov    (%eax),%eax
  801276:	8d 48 01             	lea    0x1(%eax),%ecx
  801279:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127c:	89 0a                	mov    %ecx,(%edx)
  80127e:	8b 55 08             	mov    0x8(%ebp),%edx
  801281:	88 10                	mov    %dl,(%eax)
}
  801283:	90                   	nop
  801284:	5d                   	pop    %ebp
  801285:	c3                   	ret    

00801286 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
  801289:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80128c:	8b 45 08             	mov    0x8(%ebp),%eax
  80128f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801292:	8b 45 0c             	mov    0xc(%ebp),%eax
  801295:	8d 50 ff             	lea    -0x1(%eax),%edx
  801298:	8b 45 08             	mov    0x8(%ebp),%eax
  80129b:	01 d0                	add    %edx,%eax
  80129d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8012a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012ab:	74 06                	je     8012b3 <vsnprintf+0x2d>
  8012ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012b1:	7f 07                	jg     8012ba <vsnprintf+0x34>
		return -E_INVAL;
  8012b3:	b8 03 00 00 00       	mov    $0x3,%eax
  8012b8:	eb 20                	jmp    8012da <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8012ba:	ff 75 14             	pushl  0x14(%ebp)
  8012bd:	ff 75 10             	pushl  0x10(%ebp)
  8012c0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8012c3:	50                   	push   %eax
  8012c4:	68 50 12 80 00       	push   $0x801250
  8012c9:	e8 80 fb ff ff       	call   800e4e <vprintfmt>
  8012ce:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8012d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012d4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8012d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8012da:	c9                   	leave  
  8012db:	c3                   	ret    

008012dc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012dc:	55                   	push   %ebp
  8012dd:	89 e5                	mov    %esp,%ebp
  8012df:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012e2:	8d 45 10             	lea    0x10(%ebp),%eax
  8012e5:	83 c0 04             	add    $0x4,%eax
  8012e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8012f1:	50                   	push   %eax
  8012f2:	ff 75 0c             	pushl  0xc(%ebp)
  8012f5:	ff 75 08             	pushl  0x8(%ebp)
  8012f8:	e8 89 ff ff ff       	call   801286 <vsnprintf>
  8012fd:	83 c4 10             	add    $0x10,%esp
  801300:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801303:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801306:	c9                   	leave  
  801307:	c3                   	ret    

00801308 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801308:	55                   	push   %ebp
  801309:	89 e5                	mov    %esp,%ebp
  80130b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80130e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801315:	eb 06                	jmp    80131d <strlen+0x15>
		n++;
  801317:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80131a:	ff 45 08             	incl   0x8(%ebp)
  80131d:	8b 45 08             	mov    0x8(%ebp),%eax
  801320:	8a 00                	mov    (%eax),%al
  801322:	84 c0                	test   %al,%al
  801324:	75 f1                	jne    801317 <strlen+0xf>
		n++;
	return n;
  801326:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801329:	c9                   	leave  
  80132a:	c3                   	ret    

0080132b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
  80132e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801331:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801338:	eb 09                	jmp    801343 <strnlen+0x18>
		n++;
  80133a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80133d:	ff 45 08             	incl   0x8(%ebp)
  801340:	ff 4d 0c             	decl   0xc(%ebp)
  801343:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801347:	74 09                	je     801352 <strnlen+0x27>
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	8a 00                	mov    (%eax),%al
  80134e:	84 c0                	test   %al,%al
  801350:	75 e8                	jne    80133a <strnlen+0xf>
		n++;
	return n;
  801352:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801355:	c9                   	leave  
  801356:	c3                   	ret    

00801357 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
  80135a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80135d:	8b 45 08             	mov    0x8(%ebp),%eax
  801360:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801363:	90                   	nop
  801364:	8b 45 08             	mov    0x8(%ebp),%eax
  801367:	8d 50 01             	lea    0x1(%eax),%edx
  80136a:	89 55 08             	mov    %edx,0x8(%ebp)
  80136d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801370:	8d 4a 01             	lea    0x1(%edx),%ecx
  801373:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801376:	8a 12                	mov    (%edx),%dl
  801378:	88 10                	mov    %dl,(%eax)
  80137a:	8a 00                	mov    (%eax),%al
  80137c:	84 c0                	test   %al,%al
  80137e:	75 e4                	jne    801364 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801380:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801383:	c9                   	leave  
  801384:	c3                   	ret    

00801385 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801385:	55                   	push   %ebp
  801386:	89 e5                	mov    %esp,%ebp
  801388:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80138b:	8b 45 08             	mov    0x8(%ebp),%eax
  80138e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801391:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801398:	eb 1f                	jmp    8013b9 <strncpy+0x34>
		*dst++ = *src;
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	8d 50 01             	lea    0x1(%eax),%edx
  8013a0:	89 55 08             	mov    %edx,0x8(%ebp)
  8013a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a6:	8a 12                	mov    (%edx),%dl
  8013a8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ad:	8a 00                	mov    (%eax),%al
  8013af:	84 c0                	test   %al,%al
  8013b1:	74 03                	je     8013b6 <strncpy+0x31>
			src++;
  8013b3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013b6:	ff 45 fc             	incl   -0x4(%ebp)
  8013b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013bc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013bf:	72 d9                	jb     80139a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013c4:	c9                   	leave  
  8013c5:	c3                   	ret    

008013c6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8013cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8013d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d6:	74 30                	je     801408 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8013d8:	eb 16                	jmp    8013f0 <strlcpy+0x2a>
			*dst++ = *src++;
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dd:	8d 50 01             	lea    0x1(%eax),%edx
  8013e0:	89 55 08             	mov    %edx,0x8(%ebp)
  8013e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013e9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013ec:	8a 12                	mov    (%edx),%dl
  8013ee:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013f0:	ff 4d 10             	decl   0x10(%ebp)
  8013f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013f7:	74 09                	je     801402 <strlcpy+0x3c>
  8013f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fc:	8a 00                	mov    (%eax),%al
  8013fe:	84 c0                	test   %al,%al
  801400:	75 d8                	jne    8013da <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801408:	8b 55 08             	mov    0x8(%ebp),%edx
  80140b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80140e:	29 c2                	sub    %eax,%edx
  801410:	89 d0                	mov    %edx,%eax
}
  801412:	c9                   	leave  
  801413:	c3                   	ret    

00801414 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801417:	eb 06                	jmp    80141f <strcmp+0xb>
		p++, q++;
  801419:	ff 45 08             	incl   0x8(%ebp)
  80141c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80141f:	8b 45 08             	mov    0x8(%ebp),%eax
  801422:	8a 00                	mov    (%eax),%al
  801424:	84 c0                	test   %al,%al
  801426:	74 0e                	je     801436 <strcmp+0x22>
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8a 10                	mov    (%eax),%dl
  80142d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	38 c2                	cmp    %al,%dl
  801434:	74 e3                	je     801419 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	8a 00                	mov    (%eax),%al
  80143b:	0f b6 d0             	movzbl %al,%edx
  80143e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801441:	8a 00                	mov    (%eax),%al
  801443:	0f b6 c0             	movzbl %al,%eax
  801446:	29 c2                	sub    %eax,%edx
  801448:	89 d0                	mov    %edx,%eax
}
  80144a:	5d                   	pop    %ebp
  80144b:	c3                   	ret    

0080144c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80144f:	eb 09                	jmp    80145a <strncmp+0xe>
		n--, p++, q++;
  801451:	ff 4d 10             	decl   0x10(%ebp)
  801454:	ff 45 08             	incl   0x8(%ebp)
  801457:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80145a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80145e:	74 17                	je     801477 <strncmp+0x2b>
  801460:	8b 45 08             	mov    0x8(%ebp),%eax
  801463:	8a 00                	mov    (%eax),%al
  801465:	84 c0                	test   %al,%al
  801467:	74 0e                	je     801477 <strncmp+0x2b>
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	8a 10                	mov    (%eax),%dl
  80146e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801471:	8a 00                	mov    (%eax),%al
  801473:	38 c2                	cmp    %al,%dl
  801475:	74 da                	je     801451 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801477:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80147b:	75 07                	jne    801484 <strncmp+0x38>
		return 0;
  80147d:	b8 00 00 00 00       	mov    $0x0,%eax
  801482:	eb 14                	jmp    801498 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801484:	8b 45 08             	mov    0x8(%ebp),%eax
  801487:	8a 00                	mov    (%eax),%al
  801489:	0f b6 d0             	movzbl %al,%edx
  80148c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148f:	8a 00                	mov    (%eax),%al
  801491:	0f b6 c0             	movzbl %al,%eax
  801494:	29 c2                	sub    %eax,%edx
  801496:	89 d0                	mov    %edx,%eax
}
  801498:	5d                   	pop    %ebp
  801499:	c3                   	ret    

0080149a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80149a:	55                   	push   %ebp
  80149b:	89 e5                	mov    %esp,%ebp
  80149d:	83 ec 04             	sub    $0x4,%esp
  8014a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014a6:	eb 12                	jmp    8014ba <strchr+0x20>
		if (*s == c)
  8014a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ab:	8a 00                	mov    (%eax),%al
  8014ad:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014b0:	75 05                	jne    8014b7 <strchr+0x1d>
			return (char *) s;
  8014b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b5:	eb 11                	jmp    8014c8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014b7:	ff 45 08             	incl   0x8(%ebp)
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	8a 00                	mov    (%eax),%al
  8014bf:	84 c0                	test   %al,%al
  8014c1:	75 e5                	jne    8014a8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8014c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c8:	c9                   	leave  
  8014c9:	c3                   	ret    

008014ca <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	83 ec 04             	sub    $0x4,%esp
  8014d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014d6:	eb 0d                	jmp    8014e5 <strfind+0x1b>
		if (*s == c)
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	8a 00                	mov    (%eax),%al
  8014dd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014e0:	74 0e                	je     8014f0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014e2:	ff 45 08             	incl   0x8(%ebp)
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8a 00                	mov    (%eax),%al
  8014ea:	84 c0                	test   %al,%al
  8014ec:	75 ea                	jne    8014d8 <strfind+0xe>
  8014ee:	eb 01                	jmp    8014f1 <strfind+0x27>
		if (*s == c)
			break;
  8014f0:	90                   	nop
	return (char *) s;
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
  8014f9:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801502:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801506:	76 63                	jbe    80156b <memset+0x75>
		uint64 data_block = c;
  801508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150b:	99                   	cltd   
  80150c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80150f:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801512:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801515:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801518:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80151c:	c1 e0 08             	shl    $0x8,%eax
  80151f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801522:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801525:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801528:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80152b:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80152f:	c1 e0 10             	shl    $0x10,%eax
  801532:	09 45 f0             	or     %eax,-0x10(%ebp)
  801535:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801538:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80153e:	89 c2                	mov    %eax,%edx
  801540:	b8 00 00 00 00       	mov    $0x0,%eax
  801545:	09 45 f0             	or     %eax,-0x10(%ebp)
  801548:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80154b:	eb 18                	jmp    801565 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80154d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801550:	8d 41 08             	lea    0x8(%ecx),%eax
  801553:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801556:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801559:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80155c:	89 01                	mov    %eax,(%ecx)
  80155e:	89 51 04             	mov    %edx,0x4(%ecx)
  801561:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801565:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801569:	77 e2                	ja     80154d <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80156b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80156f:	74 23                	je     801594 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801571:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801574:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801577:	eb 0e                	jmp    801587 <memset+0x91>
			*p8++ = (uint8)c;
  801579:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80157c:	8d 50 01             	lea    0x1(%eax),%edx
  80157f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801582:	8b 55 0c             	mov    0xc(%ebp),%edx
  801585:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801587:	8b 45 10             	mov    0x10(%ebp),%eax
  80158a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80158d:	89 55 10             	mov    %edx,0x10(%ebp)
  801590:	85 c0                	test   %eax,%eax
  801592:	75 e5                	jne    801579 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801594:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801597:	c9                   	leave  
  801598:	c3                   	ret    

00801599 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
  80159c:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80159f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8015a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8015ab:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015af:	76 24                	jbe    8015d5 <memcpy+0x3c>
		while(n >= 8){
  8015b1:	eb 1c                	jmp    8015cf <memcpy+0x36>
			*d64 = *s64;
  8015b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015b6:	8b 50 04             	mov    0x4(%eax),%edx
  8015b9:	8b 00                	mov    (%eax),%eax
  8015bb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015be:	89 01                	mov    %eax,(%ecx)
  8015c0:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8015c3:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8015c7:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8015cb:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8015cf:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015d3:	77 de                	ja     8015b3 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8015d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015d9:	74 31                	je     80160c <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8015db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015de:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8015e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8015e7:	eb 16                	jmp    8015ff <memcpy+0x66>
			*d8++ = *s8++;
  8015e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ec:	8d 50 01             	lea    0x1(%eax),%edx
  8015ef:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8015f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015f8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8015fb:	8a 12                	mov    (%edx),%dl
  8015fd:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8015ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801602:	8d 50 ff             	lea    -0x1(%eax),%edx
  801605:	89 55 10             	mov    %edx,0x10(%ebp)
  801608:	85 c0                	test   %eax,%eax
  80160a:	75 dd                	jne    8015e9 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80160f:	c9                   	leave  
  801610:	c3                   	ret    

00801611 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
  801614:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801617:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80161d:	8b 45 08             	mov    0x8(%ebp),%eax
  801620:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801623:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801626:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801629:	73 50                	jae    80167b <memmove+0x6a>
  80162b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80162e:	8b 45 10             	mov    0x10(%ebp),%eax
  801631:	01 d0                	add    %edx,%eax
  801633:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801636:	76 43                	jbe    80167b <memmove+0x6a>
		s += n;
  801638:	8b 45 10             	mov    0x10(%ebp),%eax
  80163b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80163e:	8b 45 10             	mov    0x10(%ebp),%eax
  801641:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801644:	eb 10                	jmp    801656 <memmove+0x45>
			*--d = *--s;
  801646:	ff 4d f8             	decl   -0x8(%ebp)
  801649:	ff 4d fc             	decl   -0x4(%ebp)
  80164c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80164f:	8a 10                	mov    (%eax),%dl
  801651:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801654:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801656:	8b 45 10             	mov    0x10(%ebp),%eax
  801659:	8d 50 ff             	lea    -0x1(%eax),%edx
  80165c:	89 55 10             	mov    %edx,0x10(%ebp)
  80165f:	85 c0                	test   %eax,%eax
  801661:	75 e3                	jne    801646 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801663:	eb 23                	jmp    801688 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801665:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801668:	8d 50 01             	lea    0x1(%eax),%edx
  80166b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80166e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801671:	8d 4a 01             	lea    0x1(%edx),%ecx
  801674:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801677:	8a 12                	mov    (%edx),%dl
  801679:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80167b:	8b 45 10             	mov    0x10(%ebp),%eax
  80167e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801681:	89 55 10             	mov    %edx,0x10(%ebp)
  801684:	85 c0                	test   %eax,%eax
  801686:	75 dd                	jne    801665 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
  801690:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801699:	8b 45 0c             	mov    0xc(%ebp),%eax
  80169c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80169f:	eb 2a                	jmp    8016cb <memcmp+0x3e>
		if (*s1 != *s2)
  8016a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a4:	8a 10                	mov    (%eax),%dl
  8016a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016a9:	8a 00                	mov    (%eax),%al
  8016ab:	38 c2                	cmp    %al,%dl
  8016ad:	74 16                	je     8016c5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016b2:	8a 00                	mov    (%eax),%al
  8016b4:	0f b6 d0             	movzbl %al,%edx
  8016b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ba:	8a 00                	mov    (%eax),%al
  8016bc:	0f b6 c0             	movzbl %al,%eax
  8016bf:	29 c2                	sub    %eax,%edx
  8016c1:	89 d0                	mov    %edx,%eax
  8016c3:	eb 18                	jmp    8016dd <memcmp+0x50>
		s1++, s2++;
  8016c5:	ff 45 fc             	incl   -0x4(%ebp)
  8016c8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ce:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8016d4:	85 c0                	test   %eax,%eax
  8016d6:	75 c9                	jne    8016a1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016dd:	c9                   	leave  
  8016de:	c3                   	ret    

008016df <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
  8016e2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016eb:	01 d0                	add    %edx,%eax
  8016ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016f0:	eb 15                	jmp    801707 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f5:	8a 00                	mov    (%eax),%al
  8016f7:	0f b6 d0             	movzbl %al,%edx
  8016fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016fd:	0f b6 c0             	movzbl %al,%eax
  801700:	39 c2                	cmp    %eax,%edx
  801702:	74 0d                	je     801711 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801704:	ff 45 08             	incl   0x8(%ebp)
  801707:	8b 45 08             	mov    0x8(%ebp),%eax
  80170a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80170d:	72 e3                	jb     8016f2 <memfind+0x13>
  80170f:	eb 01                	jmp    801712 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801711:	90                   	nop
	return (void *) s;
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80171d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801724:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80172b:	eb 03                	jmp    801730 <strtol+0x19>
		s++;
  80172d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801730:	8b 45 08             	mov    0x8(%ebp),%eax
  801733:	8a 00                	mov    (%eax),%al
  801735:	3c 20                	cmp    $0x20,%al
  801737:	74 f4                	je     80172d <strtol+0x16>
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	8a 00                	mov    (%eax),%al
  80173e:	3c 09                	cmp    $0x9,%al
  801740:	74 eb                	je     80172d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801742:	8b 45 08             	mov    0x8(%ebp),%eax
  801745:	8a 00                	mov    (%eax),%al
  801747:	3c 2b                	cmp    $0x2b,%al
  801749:	75 05                	jne    801750 <strtol+0x39>
		s++;
  80174b:	ff 45 08             	incl   0x8(%ebp)
  80174e:	eb 13                	jmp    801763 <strtol+0x4c>
	else if (*s == '-')
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
  801753:	8a 00                	mov    (%eax),%al
  801755:	3c 2d                	cmp    $0x2d,%al
  801757:	75 0a                	jne    801763 <strtol+0x4c>
		s++, neg = 1;
  801759:	ff 45 08             	incl   0x8(%ebp)
  80175c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801763:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801767:	74 06                	je     80176f <strtol+0x58>
  801769:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80176d:	75 20                	jne    80178f <strtol+0x78>
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	8a 00                	mov    (%eax),%al
  801774:	3c 30                	cmp    $0x30,%al
  801776:	75 17                	jne    80178f <strtol+0x78>
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	40                   	inc    %eax
  80177c:	8a 00                	mov    (%eax),%al
  80177e:	3c 78                	cmp    $0x78,%al
  801780:	75 0d                	jne    80178f <strtol+0x78>
		s += 2, base = 16;
  801782:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801786:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80178d:	eb 28                	jmp    8017b7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80178f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801793:	75 15                	jne    8017aa <strtol+0x93>
  801795:	8b 45 08             	mov    0x8(%ebp),%eax
  801798:	8a 00                	mov    (%eax),%al
  80179a:	3c 30                	cmp    $0x30,%al
  80179c:	75 0c                	jne    8017aa <strtol+0x93>
		s++, base = 8;
  80179e:	ff 45 08             	incl   0x8(%ebp)
  8017a1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017a8:	eb 0d                	jmp    8017b7 <strtol+0xa0>
	else if (base == 0)
  8017aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ae:	75 07                	jne    8017b7 <strtol+0xa0>
		base = 10;
  8017b0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ba:	8a 00                	mov    (%eax),%al
  8017bc:	3c 2f                	cmp    $0x2f,%al
  8017be:	7e 19                	jle    8017d9 <strtol+0xc2>
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	8a 00                	mov    (%eax),%al
  8017c5:	3c 39                	cmp    $0x39,%al
  8017c7:	7f 10                	jg     8017d9 <strtol+0xc2>
			dig = *s - '0';
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	8a 00                	mov    (%eax),%al
  8017ce:	0f be c0             	movsbl %al,%eax
  8017d1:	83 e8 30             	sub    $0x30,%eax
  8017d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017d7:	eb 42                	jmp    80181b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dc:	8a 00                	mov    (%eax),%al
  8017de:	3c 60                	cmp    $0x60,%al
  8017e0:	7e 19                	jle    8017fb <strtol+0xe4>
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	8a 00                	mov    (%eax),%al
  8017e7:	3c 7a                	cmp    $0x7a,%al
  8017e9:	7f 10                	jg     8017fb <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	8a 00                	mov    (%eax),%al
  8017f0:	0f be c0             	movsbl %al,%eax
  8017f3:	83 e8 57             	sub    $0x57,%eax
  8017f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017f9:	eb 20                	jmp    80181b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	8a 00                	mov    (%eax),%al
  801800:	3c 40                	cmp    $0x40,%al
  801802:	7e 39                	jle    80183d <strtol+0x126>
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	8a 00                	mov    (%eax),%al
  801809:	3c 5a                	cmp    $0x5a,%al
  80180b:	7f 30                	jg     80183d <strtol+0x126>
			dig = *s - 'A' + 10;
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8a 00                	mov    (%eax),%al
  801812:	0f be c0             	movsbl %al,%eax
  801815:	83 e8 37             	sub    $0x37,%eax
  801818:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80181b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801821:	7d 19                	jge    80183c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801823:	ff 45 08             	incl   0x8(%ebp)
  801826:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801829:	0f af 45 10          	imul   0x10(%ebp),%eax
  80182d:	89 c2                	mov    %eax,%edx
  80182f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801832:	01 d0                	add    %edx,%eax
  801834:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801837:	e9 7b ff ff ff       	jmp    8017b7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80183c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80183d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801841:	74 08                	je     80184b <strtol+0x134>
		*endptr = (char *) s;
  801843:	8b 45 0c             	mov    0xc(%ebp),%eax
  801846:	8b 55 08             	mov    0x8(%ebp),%edx
  801849:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80184b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80184f:	74 07                	je     801858 <strtol+0x141>
  801851:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801854:	f7 d8                	neg    %eax
  801856:	eb 03                	jmp    80185b <strtol+0x144>
  801858:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <ltostr>:

void
ltostr(long value, char *str)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801863:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80186a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801871:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801875:	79 13                	jns    80188a <ltostr+0x2d>
	{
		neg = 1;
  801877:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80187e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801881:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801884:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801887:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801892:	99                   	cltd   
  801893:	f7 f9                	idiv   %ecx
  801895:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801898:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80189b:	8d 50 01             	lea    0x1(%eax),%edx
  80189e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018a1:	89 c2                	mov    %eax,%edx
  8018a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a6:	01 d0                	add    %edx,%eax
  8018a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018ab:	83 c2 30             	add    $0x30,%edx
  8018ae:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018b3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018b8:	f7 e9                	imul   %ecx
  8018ba:	c1 fa 02             	sar    $0x2,%edx
  8018bd:	89 c8                	mov    %ecx,%eax
  8018bf:	c1 f8 1f             	sar    $0x1f,%eax
  8018c2:	29 c2                	sub    %eax,%edx
  8018c4:	89 d0                	mov    %edx,%eax
  8018c6:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8018c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018cd:	75 bb                	jne    80188a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d9:	48                   	dec    %eax
  8018da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018e1:	74 3d                	je     801920 <ltostr+0xc3>
		start = 1 ;
  8018e3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018ea:	eb 34                	jmp    801920 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8018ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f2:	01 d0                	add    %edx,%eax
  8018f4:	8a 00                	mov    (%eax),%al
  8018f6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ff:	01 c2                	add    %eax,%edx
  801901:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801904:	8b 45 0c             	mov    0xc(%ebp),%eax
  801907:	01 c8                	add    %ecx,%eax
  801909:	8a 00                	mov    (%eax),%al
  80190b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80190d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801910:	8b 45 0c             	mov    0xc(%ebp),%eax
  801913:	01 c2                	add    %eax,%edx
  801915:	8a 45 eb             	mov    -0x15(%ebp),%al
  801918:	88 02                	mov    %al,(%edx)
		start++ ;
  80191a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80191d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801923:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801926:	7c c4                	jl     8018ec <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801928:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80192b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192e:	01 d0                	add    %edx,%eax
  801930:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801933:	90                   	nop
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80193c:	ff 75 08             	pushl  0x8(%ebp)
  80193f:	e8 c4 f9 ff ff       	call   801308 <strlen>
  801944:	83 c4 04             	add    $0x4,%esp
  801947:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80194a:	ff 75 0c             	pushl  0xc(%ebp)
  80194d:	e8 b6 f9 ff ff       	call   801308 <strlen>
  801952:	83 c4 04             	add    $0x4,%esp
  801955:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801958:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80195f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801966:	eb 17                	jmp    80197f <strcconcat+0x49>
		final[s] = str1[s] ;
  801968:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80196b:	8b 45 10             	mov    0x10(%ebp),%eax
  80196e:	01 c2                	add    %eax,%edx
  801970:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801973:	8b 45 08             	mov    0x8(%ebp),%eax
  801976:	01 c8                	add    %ecx,%eax
  801978:	8a 00                	mov    (%eax),%al
  80197a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80197c:	ff 45 fc             	incl   -0x4(%ebp)
  80197f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801982:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801985:	7c e1                	jl     801968 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801987:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80198e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801995:	eb 1f                	jmp    8019b6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801997:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80199a:	8d 50 01             	lea    0x1(%eax),%edx
  80199d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019a0:	89 c2                	mov    %eax,%edx
  8019a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a5:	01 c2                	add    %eax,%edx
  8019a7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ad:	01 c8                	add    %ecx,%eax
  8019af:	8a 00                	mov    (%eax),%al
  8019b1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019b3:	ff 45 f8             	incl   -0x8(%ebp)
  8019b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019b9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019bc:	7c d9                	jl     801997 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c4:	01 d0                	add    %edx,%eax
  8019c6:	c6 00 00             	movb   $0x0,(%eax)
}
  8019c9:	90                   	nop
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8019db:	8b 00                	mov    (%eax),%eax
  8019dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e7:	01 d0                	add    %edx,%eax
  8019e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019ef:	eb 0c                	jmp    8019fd <strsplit+0x31>
			*string++ = 0;
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	8d 50 01             	lea    0x1(%eax),%edx
  8019f7:	89 55 08             	mov    %edx,0x8(%ebp)
  8019fa:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801a00:	8a 00                	mov    (%eax),%al
  801a02:	84 c0                	test   %al,%al
  801a04:	74 18                	je     801a1e <strsplit+0x52>
  801a06:	8b 45 08             	mov    0x8(%ebp),%eax
  801a09:	8a 00                	mov    (%eax),%al
  801a0b:	0f be c0             	movsbl %al,%eax
  801a0e:	50                   	push   %eax
  801a0f:	ff 75 0c             	pushl  0xc(%ebp)
  801a12:	e8 83 fa ff ff       	call   80149a <strchr>
  801a17:	83 c4 08             	add    $0x8,%esp
  801a1a:	85 c0                	test   %eax,%eax
  801a1c:	75 d3                	jne    8019f1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a21:	8a 00                	mov    (%eax),%al
  801a23:	84 c0                	test   %al,%al
  801a25:	74 5a                	je     801a81 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a27:	8b 45 14             	mov    0x14(%ebp),%eax
  801a2a:	8b 00                	mov    (%eax),%eax
  801a2c:	83 f8 0f             	cmp    $0xf,%eax
  801a2f:	75 07                	jne    801a38 <strsplit+0x6c>
		{
			return 0;
  801a31:	b8 00 00 00 00       	mov    $0x0,%eax
  801a36:	eb 66                	jmp    801a9e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a38:	8b 45 14             	mov    0x14(%ebp),%eax
  801a3b:	8b 00                	mov    (%eax),%eax
  801a3d:	8d 48 01             	lea    0x1(%eax),%ecx
  801a40:	8b 55 14             	mov    0x14(%ebp),%edx
  801a43:	89 0a                	mov    %ecx,(%edx)
  801a45:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a4c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4f:	01 c2                	add    %eax,%edx
  801a51:	8b 45 08             	mov    0x8(%ebp),%eax
  801a54:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a56:	eb 03                	jmp    801a5b <strsplit+0x8f>
			string++;
  801a58:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	8a 00                	mov    (%eax),%al
  801a60:	84 c0                	test   %al,%al
  801a62:	74 8b                	je     8019ef <strsplit+0x23>
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	8a 00                	mov    (%eax),%al
  801a69:	0f be c0             	movsbl %al,%eax
  801a6c:	50                   	push   %eax
  801a6d:	ff 75 0c             	pushl  0xc(%ebp)
  801a70:	e8 25 fa ff ff       	call   80149a <strchr>
  801a75:	83 c4 08             	add    $0x8,%esp
  801a78:	85 c0                	test   %eax,%eax
  801a7a:	74 dc                	je     801a58 <strsplit+0x8c>
			string++;
	}
  801a7c:	e9 6e ff ff ff       	jmp    8019ef <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a81:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a82:	8b 45 14             	mov    0x14(%ebp),%eax
  801a85:	8b 00                	mov    (%eax),%eax
  801a87:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a8e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a91:	01 d0                	add    %edx,%eax
  801a93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a99:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
  801aa3:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801aac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ab3:	eb 4a                	jmp    801aff <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801ab5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  801abb:	01 c2                	add    %eax,%edx
  801abd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ac0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac3:	01 c8                	add    %ecx,%eax
  801ac5:	8a 00                	mov    (%eax),%al
  801ac7:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801ac9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801acc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801acf:	01 d0                	add    %edx,%eax
  801ad1:	8a 00                	mov    (%eax),%al
  801ad3:	3c 40                	cmp    $0x40,%al
  801ad5:	7e 25                	jle    801afc <str2lower+0x5c>
  801ad7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ada:	8b 45 0c             	mov    0xc(%ebp),%eax
  801add:	01 d0                	add    %edx,%eax
  801adf:	8a 00                	mov    (%eax),%al
  801ae1:	3c 5a                	cmp    $0x5a,%al
  801ae3:	7f 17                	jg     801afc <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801ae5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aeb:	01 d0                	add    %edx,%eax
  801aed:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801af0:	8b 55 08             	mov    0x8(%ebp),%edx
  801af3:	01 ca                	add    %ecx,%edx
  801af5:	8a 12                	mov    (%edx),%dl
  801af7:	83 c2 20             	add    $0x20,%edx
  801afa:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801afc:	ff 45 fc             	incl   -0x4(%ebp)
  801aff:	ff 75 0c             	pushl  0xc(%ebp)
  801b02:	e8 01 f8 ff ff       	call   801308 <strlen>
  801b07:	83 c4 04             	add    $0x4,%esp
  801b0a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b0d:	7f a6                	jg     801ab5 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801b0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
  801b17:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  801b1a:	83 ec 0c             	sub    $0xc,%esp
  801b1d:	6a 10                	push   $0x10
  801b1f:	e8 b2 15 00 00       	call   8030d6 <alloc_block>
  801b24:	83 c4 10             	add    $0x10,%esp
  801b27:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  801b2a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b2e:	75 14                	jne    801b44 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  801b30:	83 ec 04             	sub    $0x4,%esp
  801b33:	68 68 46 80 00       	push   $0x804668
  801b38:	6a 14                	push   $0x14
  801b3a:	68 91 46 80 00       	push   $0x804691
  801b3f:	e8 fd ed ff ff       	call   800941 <_panic>

	node->start = start;
  801b44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b47:	8b 55 08             	mov    0x8(%ebp),%edx
  801b4a:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  801b4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b52:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  801b55:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  801b5c:	a1 24 50 80 00       	mov    0x805024,%eax
  801b61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b64:	eb 18                	jmp    801b7e <insert_page_alloc+0x6a>
		if (start < it->start)
  801b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b69:	8b 00                	mov    (%eax),%eax
  801b6b:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b6e:	77 37                	ja     801ba7 <insert_page_alloc+0x93>
			break;
		prev = it;
  801b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b73:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  801b76:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801b7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b82:	74 08                	je     801b8c <insert_page_alloc+0x78>
  801b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b87:	8b 40 08             	mov    0x8(%eax),%eax
  801b8a:	eb 05                	jmp    801b91 <insert_page_alloc+0x7d>
  801b8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b91:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801b96:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801b9b:	85 c0                	test   %eax,%eax
  801b9d:	75 c7                	jne    801b66 <insert_page_alloc+0x52>
  801b9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ba3:	75 c1                	jne    801b66 <insert_page_alloc+0x52>
  801ba5:	eb 01                	jmp    801ba8 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  801ba7:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  801ba8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bac:	75 64                	jne    801c12 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  801bae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bb2:	75 14                	jne    801bc8 <insert_page_alloc+0xb4>
  801bb4:	83 ec 04             	sub    $0x4,%esp
  801bb7:	68 a0 46 80 00       	push   $0x8046a0
  801bbc:	6a 21                	push   $0x21
  801bbe:	68 91 46 80 00       	push   $0x804691
  801bc3:	e8 79 ed ff ff       	call   800941 <_panic>
  801bc8:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801bce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bd1:	89 50 08             	mov    %edx,0x8(%eax)
  801bd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bd7:	8b 40 08             	mov    0x8(%eax),%eax
  801bda:	85 c0                	test   %eax,%eax
  801bdc:	74 0d                	je     801beb <insert_page_alloc+0xd7>
  801bde:	a1 24 50 80 00       	mov    0x805024,%eax
  801be3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801be6:	89 50 0c             	mov    %edx,0xc(%eax)
  801be9:	eb 08                	jmp    801bf3 <insert_page_alloc+0xdf>
  801beb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bee:	a3 28 50 80 00       	mov    %eax,0x805028
  801bf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bf6:	a3 24 50 80 00       	mov    %eax,0x805024
  801bfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bfe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801c05:	a1 30 50 80 00       	mov    0x805030,%eax
  801c0a:	40                   	inc    %eax
  801c0b:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  801c10:	eb 71                	jmp    801c83 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  801c12:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c16:	74 06                	je     801c1e <insert_page_alloc+0x10a>
  801c18:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c1c:	75 14                	jne    801c32 <insert_page_alloc+0x11e>
  801c1e:	83 ec 04             	sub    $0x4,%esp
  801c21:	68 c4 46 80 00       	push   $0x8046c4
  801c26:	6a 23                	push   $0x23
  801c28:	68 91 46 80 00       	push   $0x804691
  801c2d:	e8 0f ed ff ff       	call   800941 <_panic>
  801c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c35:	8b 50 08             	mov    0x8(%eax),%edx
  801c38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c3b:	89 50 08             	mov    %edx,0x8(%eax)
  801c3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c41:	8b 40 08             	mov    0x8(%eax),%eax
  801c44:	85 c0                	test   %eax,%eax
  801c46:	74 0c                	je     801c54 <insert_page_alloc+0x140>
  801c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c4b:	8b 40 08             	mov    0x8(%eax),%eax
  801c4e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c51:	89 50 0c             	mov    %edx,0xc(%eax)
  801c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c57:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c5a:	89 50 08             	mov    %edx,0x8(%eax)
  801c5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c60:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c63:	89 50 0c             	mov    %edx,0xc(%eax)
  801c66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c69:	8b 40 08             	mov    0x8(%eax),%eax
  801c6c:	85 c0                	test   %eax,%eax
  801c6e:	75 08                	jne    801c78 <insert_page_alloc+0x164>
  801c70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c73:	a3 28 50 80 00       	mov    %eax,0x805028
  801c78:	a1 30 50 80 00       	mov    0x805030,%eax
  801c7d:	40                   	inc    %eax
  801c7e:	a3 30 50 80 00       	mov    %eax,0x805030
}
  801c83:	90                   	nop
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
  801c89:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  801c8c:	a1 24 50 80 00       	mov    0x805024,%eax
  801c91:	85 c0                	test   %eax,%eax
  801c93:	75 0c                	jne    801ca1 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  801c95:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801c9a:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  801c9f:	eb 67                	jmp    801d08 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  801ca1:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ca6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801ca9:	a1 24 50 80 00       	mov    0x805024,%eax
  801cae:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801cb1:	eb 26                	jmp    801cd9 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  801cb3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cb6:	8b 10                	mov    (%eax),%edx
  801cb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cbb:	8b 40 04             	mov    0x4(%eax),%eax
  801cbe:	01 d0                	add    %edx,%eax
  801cc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  801cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801cc9:	76 06                	jbe    801cd1 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  801ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cce:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801cd1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801cd6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801cd9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801cdd:	74 08                	je     801ce7 <recompute_page_alloc_break+0x61>
  801cdf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ce2:	8b 40 08             	mov    0x8(%eax),%eax
  801ce5:	eb 05                	jmp    801cec <recompute_page_alloc_break+0x66>
  801ce7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cec:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801cf1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801cf6:	85 c0                	test   %eax,%eax
  801cf8:	75 b9                	jne    801cb3 <recompute_page_alloc_break+0x2d>
  801cfa:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801cfe:	75 b3                	jne    801cb3 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  801d00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d03:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801d10:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801d17:	8b 55 08             	mov    0x8(%ebp),%edx
  801d1a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d1d:	01 d0                	add    %edx,%eax
  801d1f:	48                   	dec    %eax
  801d20:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801d23:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d26:	ba 00 00 00 00       	mov    $0x0,%edx
  801d2b:	f7 75 d8             	divl   -0x28(%ebp)
  801d2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d31:	29 d0                	sub    %edx,%eax
  801d33:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  801d36:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801d3a:	75 0a                	jne    801d46 <alloc_pages_custom_fit+0x3c>
		return NULL;
  801d3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d41:	e9 7e 01 00 00       	jmp    801ec4 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  801d46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  801d4d:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801d51:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801d58:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  801d5f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801d64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801d67:	a1 24 50 80 00       	mov    0x805024,%eax
  801d6c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d6f:	eb 69                	jmp    801dda <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  801d71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d74:	8b 00                	mov    (%eax),%eax
  801d76:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801d79:	76 47                	jbe    801dc2 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  801d7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d7e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  801d81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d84:	8b 00                	mov    (%eax),%eax
  801d86:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801d89:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  801d8c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d8f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801d92:	72 2e                	jb     801dc2 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801d94:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801d98:	75 14                	jne    801dae <alloc_pages_custom_fit+0xa4>
  801d9a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d9d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801da0:	75 0c                	jne    801dae <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  801da2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801da5:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  801da8:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801dac:	eb 14                	jmp    801dc2 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  801dae:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801db1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801db4:	76 0c                	jbe    801dc2 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  801db6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801db9:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  801dbc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801dbf:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  801dc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dc5:	8b 10                	mov    (%eax),%edx
  801dc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dca:	8b 40 04             	mov    0x4(%eax),%eax
  801dcd:	01 d0                	add    %edx,%eax
  801dcf:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801dd2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801dd7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801dda:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801dde:	74 08                	je     801de8 <alloc_pages_custom_fit+0xde>
  801de0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801de3:	8b 40 08             	mov    0x8(%eax),%eax
  801de6:	eb 05                	jmp    801ded <alloc_pages_custom_fit+0xe3>
  801de8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ded:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801df2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801df7:	85 c0                	test   %eax,%eax
  801df9:	0f 85 72 ff ff ff    	jne    801d71 <alloc_pages_custom_fit+0x67>
  801dff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e03:	0f 85 68 ff ff ff    	jne    801d71 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  801e09:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801e0e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801e11:	76 47                	jbe    801e5a <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801e13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e16:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  801e19:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801e1e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801e21:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801e24:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e27:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801e2a:	72 2e                	jb     801e5a <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  801e2c:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801e30:	75 14                	jne    801e46 <alloc_pages_custom_fit+0x13c>
  801e32:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e35:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801e38:	75 0c                	jne    801e46 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  801e3a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801e3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  801e40:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801e44:	eb 14                	jmp    801e5a <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  801e46:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e49:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801e4c:	76 0c                	jbe    801e5a <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  801e4e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801e51:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801e54:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e57:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  801e5a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  801e61:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801e65:	74 08                	je     801e6f <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  801e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801e6d:	eb 40                	jmp    801eaf <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  801e6f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e73:	74 08                	je     801e7d <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  801e75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e78:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801e7b:	eb 32                	jmp    801eaf <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  801e7d:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801e82:	2b 45 d0             	sub    -0x30(%ebp),%eax
  801e85:	89 c2                	mov    %eax,%edx
  801e87:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801e8c:	39 c2                	cmp    %eax,%edx
  801e8e:	73 07                	jae    801e97 <alloc_pages_custom_fit+0x18d>
			return NULL;
  801e90:	b8 00 00 00 00       	mov    $0x0,%eax
  801e95:	eb 2d                	jmp    801ec4 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  801e97:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801e9c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  801e9f:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801ea5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ea8:	01 d0                	add    %edx,%eax
  801eaa:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  801eaf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801eb2:	83 ec 08             	sub    $0x8,%esp
  801eb5:	ff 75 d0             	pushl  -0x30(%ebp)
  801eb8:	50                   	push   %eax
  801eb9:	e8 56 fc ff ff       	call   801b14 <insert_page_alloc>
  801ebe:	83 c4 10             	add    $0x10,%esp

	return result;
  801ec1:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  801ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecf:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801ed2:	a1 24 50 80 00       	mov    0x805024,%eax
  801ed7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801eda:	eb 1a                	jmp    801ef6 <find_allocated_size+0x30>
		if (it->start == va)
  801edc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801edf:	8b 00                	mov    (%eax),%eax
  801ee1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801ee4:	75 08                	jne    801eee <find_allocated_size+0x28>
			return it->size;
  801ee6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ee9:	8b 40 04             	mov    0x4(%eax),%eax
  801eec:	eb 34                	jmp    801f22 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801eee:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801ef3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ef6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801efa:	74 08                	je     801f04 <find_allocated_size+0x3e>
  801efc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eff:	8b 40 08             	mov    0x8(%eax),%eax
  801f02:	eb 05                	jmp    801f09 <find_allocated_size+0x43>
  801f04:	b8 00 00 00 00       	mov    $0x0,%eax
  801f09:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801f0e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801f13:	85 c0                	test   %eax,%eax
  801f15:	75 c5                	jne    801edc <find_allocated_size+0x16>
  801f17:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f1b:	75 bf                	jne    801edc <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  801f1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f22:	c9                   	leave  
  801f23:	c3                   	ret    

00801f24 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
  801f27:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  801f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801f30:	a1 24 50 80 00       	mov    0x805024,%eax
  801f35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f38:	e9 e1 01 00 00       	jmp    80211e <free_pages+0x1fa>
		if (it->start == va) {
  801f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f40:	8b 00                	mov    (%eax),%eax
  801f42:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f45:	0f 85 cb 01 00 00    	jne    802116 <free_pages+0x1f2>

			uint32 start = it->start;
  801f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4e:	8b 00                	mov    (%eax),%eax
  801f50:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f56:	8b 40 04             	mov    0x4(%eax),%eax
  801f59:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801f5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f5f:	f7 d0                	not    %eax
  801f61:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801f64:	73 1d                	jae    801f83 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801f66:	83 ec 0c             	sub    $0xc,%esp
  801f69:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f6c:	ff 75 e8             	pushl  -0x18(%ebp)
  801f6f:	68 f8 46 80 00       	push   $0x8046f8
  801f74:	68 a5 00 00 00       	push   $0xa5
  801f79:	68 91 46 80 00       	push   $0x804691
  801f7e:	e8 be e9 ff ff       	call   800941 <_panic>
			}

			uint32 start_end = start + size;
  801f83:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f89:	01 d0                	add    %edx,%eax
  801f8b:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801f8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f91:	85 c0                	test   %eax,%eax
  801f93:	79 19                	jns    801fae <free_pages+0x8a>
  801f95:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801f9c:	77 10                	ja     801fae <free_pages+0x8a>
  801f9e:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801fa5:	77 07                	ja     801fae <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  801fa7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801faa:	85 c0                	test   %eax,%eax
  801fac:	78 2c                	js     801fda <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  801fae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fb1:	83 ec 0c             	sub    $0xc,%esp
  801fb4:	68 00 00 00 a0       	push   $0xa0000000
  801fb9:	ff 75 e0             	pushl  -0x20(%ebp)
  801fbc:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fbf:	ff 75 e8             	pushl  -0x18(%ebp)
  801fc2:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fc5:	50                   	push   %eax
  801fc6:	68 3c 47 80 00       	push   $0x80473c
  801fcb:	68 ad 00 00 00       	push   $0xad
  801fd0:	68 91 46 80 00       	push   $0x804691
  801fd5:	e8 67 e9 ff ff       	call   800941 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801fda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fe0:	e9 88 00 00 00       	jmp    80206d <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  801fe5:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  801fec:	76 17                	jbe    802005 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  801fee:	ff 75 f0             	pushl  -0x10(%ebp)
  801ff1:	68 a0 47 80 00       	push   $0x8047a0
  801ff6:	68 b4 00 00 00       	push   $0xb4
  801ffb:	68 91 46 80 00       	push   $0x804691
  802000:	e8 3c e9 ff ff       	call   800941 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  802005:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802008:	05 00 10 00 00       	add    $0x1000,%eax
  80200d:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  802010:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802013:	85 c0                	test   %eax,%eax
  802015:	79 2e                	jns    802045 <free_pages+0x121>
  802017:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  80201e:	77 25                	ja     802045 <free_pages+0x121>
  802020:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802027:	77 1c                	ja     802045 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  802029:	83 ec 08             	sub    $0x8,%esp
  80202c:	68 00 10 00 00       	push   $0x1000
  802031:	ff 75 f0             	pushl  -0x10(%ebp)
  802034:	e8 38 0d 00 00       	call   802d71 <sys_free_user_mem>
  802039:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  80203c:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  802043:	eb 28                	jmp    80206d <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  802045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802048:	68 00 00 00 a0       	push   $0xa0000000
  80204d:	ff 75 dc             	pushl  -0x24(%ebp)
  802050:	68 00 10 00 00       	push   $0x1000
  802055:	ff 75 f0             	pushl  -0x10(%ebp)
  802058:	50                   	push   %eax
  802059:	68 e0 47 80 00       	push   $0x8047e0
  80205e:	68 bd 00 00 00       	push   $0xbd
  802063:	68 91 46 80 00       	push   $0x804691
  802068:	e8 d4 e8 ff ff       	call   800941 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  80206d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802070:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802073:	0f 82 6c ff ff ff    	jb     801fe5 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  802079:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80207d:	75 17                	jne    802096 <free_pages+0x172>
  80207f:	83 ec 04             	sub    $0x4,%esp
  802082:	68 42 48 80 00       	push   $0x804842
  802087:	68 c1 00 00 00       	push   $0xc1
  80208c:	68 91 46 80 00       	push   $0x804691
  802091:	e8 ab e8 ff ff       	call   800941 <_panic>
  802096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802099:	8b 40 08             	mov    0x8(%eax),%eax
  80209c:	85 c0                	test   %eax,%eax
  80209e:	74 11                	je     8020b1 <free_pages+0x18d>
  8020a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a3:	8b 40 08             	mov    0x8(%eax),%eax
  8020a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a9:	8b 52 0c             	mov    0xc(%edx),%edx
  8020ac:	89 50 0c             	mov    %edx,0xc(%eax)
  8020af:	eb 0b                	jmp    8020bc <free_pages+0x198>
  8020b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8020b7:	a3 28 50 80 00       	mov    %eax,0x805028
  8020bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8020c2:	85 c0                	test   %eax,%eax
  8020c4:	74 11                	je     8020d7 <free_pages+0x1b3>
  8020c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8020cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020cf:	8b 52 08             	mov    0x8(%edx),%edx
  8020d2:	89 50 08             	mov    %edx,0x8(%eax)
  8020d5:	eb 0b                	jmp    8020e2 <free_pages+0x1be>
  8020d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020da:	8b 40 08             	mov    0x8(%eax),%eax
  8020dd:	a3 24 50 80 00       	mov    %eax,0x805024
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8020ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ef:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8020f6:	a1 30 50 80 00       	mov    0x805030,%eax
  8020fb:	48                   	dec    %eax
  8020fc:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  802101:	83 ec 0c             	sub    $0xc,%esp
  802104:	ff 75 f4             	pushl  -0xc(%ebp)
  802107:	e8 24 15 00 00       	call   803630 <free_block>
  80210c:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  80210f:	e8 72 fb ff ff       	call   801c86 <recompute_page_alloc_break>

			return;
  802114:	eb 37                	jmp    80214d <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802116:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80211b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80211e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802122:	74 08                	je     80212c <free_pages+0x208>
  802124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802127:	8b 40 08             	mov    0x8(%eax),%eax
  80212a:	eb 05                	jmp    802131 <free_pages+0x20d>
  80212c:	b8 00 00 00 00       	mov    $0x0,%eax
  802131:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802136:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80213b:	85 c0                	test   %eax,%eax
  80213d:	0f 85 fa fd ff ff    	jne    801f3d <free_pages+0x19>
  802143:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802147:	0f 85 f0 fd ff ff    	jne    801f3d <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  80214d:	c9                   	leave  
  80214e:	c3                   	ret    

0080214f <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  802152:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802157:	5d                   	pop    %ebp
  802158:	c3                   	ret    

00802159 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
  80215c:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80215f:	a1 08 50 80 00       	mov    0x805008,%eax
  802164:	85 c0                	test   %eax,%eax
  802166:	74 60                	je     8021c8 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802168:	83 ec 08             	sub    $0x8,%esp
  80216b:	68 00 00 00 82       	push   $0x82000000
  802170:	68 00 00 00 80       	push   $0x80000000
  802175:	e8 0d 0d 00 00       	call   802e87 <initialize_dynamic_allocator>
  80217a:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80217d:	e8 f3 0a 00 00       	call   802c75 <sys_get_uheap_strategy>
  802182:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802187:	a1 40 50 80 00       	mov    0x805040,%eax
  80218c:	05 00 10 00 00       	add    $0x1000,%eax
  802191:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  802196:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80219b:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  8021a0:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  8021a7:	00 00 00 
  8021aa:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  8021b1:	00 00 00 
  8021b4:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  8021bb:	00 00 00 

		__firstTimeFlag = 0;
  8021be:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8021c5:	00 00 00 
	}
}
  8021c8:	90                   	nop
  8021c9:	c9                   	leave  
  8021ca:	c3                   	ret    

008021cb <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8021cb:	55                   	push   %ebp
  8021cc:	89 e5                	mov    %esp,%ebp
  8021ce:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8021df:	83 ec 08             	sub    $0x8,%esp
  8021e2:	68 06 04 00 00       	push   $0x406
  8021e7:	50                   	push   %eax
  8021e8:	e8 d2 06 00 00       	call   8028bf <__sys_allocate_page>
  8021ed:	83 c4 10             	add    $0x10,%esp
  8021f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8021f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021f7:	79 17                	jns    802210 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  8021f9:	83 ec 04             	sub    $0x4,%esp
  8021fc:	68 60 48 80 00       	push   $0x804860
  802201:	68 ea 00 00 00       	push   $0xea
  802206:	68 91 46 80 00       	push   $0x804691
  80220b:	e8 31 e7 ff ff       	call   800941 <_panic>
	return 0;
  802210:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802215:	c9                   	leave  
  802216:	c3                   	ret    

00802217 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802217:	55                   	push   %ebp
  802218:	89 e5                	mov    %esp,%ebp
  80221a:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80221d:	8b 45 08             	mov    0x8(%ebp),%eax
  802220:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802226:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80222b:	83 ec 0c             	sub    $0xc,%esp
  80222e:	50                   	push   %eax
  80222f:	e8 d2 06 00 00       	call   802906 <__sys_unmap_frame>
  802234:	83 c4 10             	add    $0x10,%esp
  802237:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80223a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80223e:	79 17                	jns    802257 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  802240:	83 ec 04             	sub    $0x4,%esp
  802243:	68 9c 48 80 00       	push   $0x80489c
  802248:	68 f5 00 00 00       	push   $0xf5
  80224d:	68 91 46 80 00       	push   $0x804691
  802252:	e8 ea e6 ff ff       	call   800941 <_panic>
}
  802257:	90                   	nop
  802258:	c9                   	leave  
  802259:	c3                   	ret    

0080225a <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80225a:	55                   	push   %ebp
  80225b:	89 e5                	mov    %esp,%ebp
  80225d:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802260:	e8 f4 fe ff ff       	call   802159 <uheap_init>
	if (size == 0) return NULL ;
  802265:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802269:	75 0a                	jne    802275 <malloc+0x1b>
  80226b:	b8 00 00 00 00       	mov    $0x0,%eax
  802270:	e9 67 01 00 00       	jmp    8023dc <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  802275:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  80227c:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802283:	77 16                	ja     80229b <malloc+0x41>
		result = alloc_block(size);
  802285:	83 ec 0c             	sub    $0xc,%esp
  802288:	ff 75 08             	pushl  0x8(%ebp)
  80228b:	e8 46 0e 00 00       	call   8030d6 <alloc_block>
  802290:	83 c4 10             	add    $0x10,%esp
  802293:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802296:	e9 3e 01 00 00       	jmp    8023d9 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  80229b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8022a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a8:	01 d0                	add    %edx,%eax
  8022aa:	48                   	dec    %eax
  8022ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8022ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8022b6:	f7 75 f0             	divl   -0x10(%ebp)
  8022b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022bc:	29 d0                	sub    %edx,%eax
  8022be:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  8022c1:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8022c6:	85 c0                	test   %eax,%eax
  8022c8:	75 0a                	jne    8022d4 <malloc+0x7a>
			return NULL;
  8022ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8022cf:	e9 08 01 00 00       	jmp    8023dc <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  8022d4:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8022d9:	85 c0                	test   %eax,%eax
  8022db:	74 0f                	je     8022ec <malloc+0x92>
  8022dd:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8022e3:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8022e8:	39 c2                	cmp    %eax,%edx
  8022ea:	73 0a                	jae    8022f6 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  8022ec:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8022f1:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  8022f6:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8022fb:	83 f8 05             	cmp    $0x5,%eax
  8022fe:	75 11                	jne    802311 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  802300:	83 ec 0c             	sub    $0xc,%esp
  802303:	ff 75 e8             	pushl  -0x18(%ebp)
  802306:	e8 ff f9 ff ff       	call   801d0a <alloc_pages_custom_fit>
  80230b:	83 c4 10             	add    $0x10,%esp
  80230e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  802311:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802315:	0f 84 be 00 00 00    	je     8023d9 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  80231b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  802321:	83 ec 0c             	sub    $0xc,%esp
  802324:	ff 75 f4             	pushl  -0xc(%ebp)
  802327:	e8 9a fb ff ff       	call   801ec6 <find_allocated_size>
  80232c:	83 c4 10             	add    $0x10,%esp
  80232f:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  802332:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802336:	75 17                	jne    80234f <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  802338:	ff 75 f4             	pushl  -0xc(%ebp)
  80233b:	68 dc 48 80 00       	push   $0x8048dc
  802340:	68 24 01 00 00       	push   $0x124
  802345:	68 91 46 80 00       	push   $0x804691
  80234a:	e8 f2 e5 ff ff       	call   800941 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  80234f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802352:	f7 d0                	not    %eax
  802354:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802357:	73 1d                	jae    802376 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  802359:	83 ec 0c             	sub    $0xc,%esp
  80235c:	ff 75 e0             	pushl  -0x20(%ebp)
  80235f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802362:	68 24 49 80 00       	push   $0x804924
  802367:	68 29 01 00 00       	push   $0x129
  80236c:	68 91 46 80 00       	push   $0x804691
  802371:	e8 cb e5 ff ff       	call   800941 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  802376:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802379:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80237c:	01 d0                	add    %edx,%eax
  80237e:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  802381:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802384:	85 c0                	test   %eax,%eax
  802386:	79 2c                	jns    8023b4 <malloc+0x15a>
  802388:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  80238f:	77 23                	ja     8023b4 <malloc+0x15a>
  802391:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802398:	77 1a                	ja     8023b4 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  80239a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80239d:	85 c0                	test   %eax,%eax
  80239f:	79 13                	jns    8023b4 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  8023a1:	83 ec 08             	sub    $0x8,%esp
  8023a4:	ff 75 e0             	pushl  -0x20(%ebp)
  8023a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8023aa:	e8 de 09 00 00       	call   802d8d <sys_allocate_user_mem>
  8023af:	83 c4 10             	add    $0x10,%esp
  8023b2:	eb 25                	jmp    8023d9 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  8023b4:	68 00 00 00 a0       	push   $0xa0000000
  8023b9:	ff 75 dc             	pushl  -0x24(%ebp)
  8023bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8023bf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8023c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8023c5:	68 60 49 80 00       	push   $0x804960
  8023ca:	68 33 01 00 00       	push   $0x133
  8023cf:	68 91 46 80 00       	push   $0x804691
  8023d4:	e8 68 e5 ff ff       	call   800941 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  8023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  8023dc:	c9                   	leave  
  8023dd:	c3                   	ret    

008023de <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8023de:	55                   	push   %ebp
  8023df:	89 e5                	mov    %esp,%ebp
  8023e1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  8023e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023e8:	0f 84 26 01 00 00    	je     802514 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  8023ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  8023f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f7:	85 c0                	test   %eax,%eax
  8023f9:	79 1c                	jns    802417 <free+0x39>
  8023fb:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  802402:	77 13                	ja     802417 <free+0x39>
		free_block(virtual_address);
  802404:	83 ec 0c             	sub    $0xc,%esp
  802407:	ff 75 08             	pushl  0x8(%ebp)
  80240a:	e8 21 12 00 00       	call   803630 <free_block>
  80240f:	83 c4 10             	add    $0x10,%esp
		return;
  802412:	e9 01 01 00 00       	jmp    802518 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  802417:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80241c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  80241f:	0f 82 d8 00 00 00    	jb     8024fd <free+0x11f>
  802425:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  80242c:	0f 87 cb 00 00 00    	ja     8024fd <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  802432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802435:	25 ff 0f 00 00       	and    $0xfff,%eax
  80243a:	85 c0                	test   %eax,%eax
  80243c:	74 17                	je     802455 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  80243e:	ff 75 08             	pushl  0x8(%ebp)
  802441:	68 d0 49 80 00       	push   $0x8049d0
  802446:	68 57 01 00 00       	push   $0x157
  80244b:	68 91 46 80 00       	push   $0x804691
  802450:	e8 ec e4 ff ff       	call   800941 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  802455:	83 ec 0c             	sub    $0xc,%esp
  802458:	ff 75 08             	pushl  0x8(%ebp)
  80245b:	e8 66 fa ff ff       	call   801ec6 <find_allocated_size>
  802460:	83 c4 10             	add    $0x10,%esp
  802463:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  802466:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80246a:	0f 84 a7 00 00 00    	je     802517 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  802470:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802473:	f7 d0                	not    %eax
  802475:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802478:	73 1d                	jae    802497 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  80247a:	83 ec 0c             	sub    $0xc,%esp
  80247d:	ff 75 f0             	pushl  -0x10(%ebp)
  802480:	ff 75 f4             	pushl  -0xc(%ebp)
  802483:	68 f8 49 80 00       	push   $0x8049f8
  802488:	68 61 01 00 00       	push   $0x161
  80248d:	68 91 46 80 00       	push   $0x804691
  802492:	e8 aa e4 ff ff       	call   800941 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  802497:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249d:	01 d0                	add    %edx,%eax
  80249f:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  8024a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a5:	85 c0                	test   %eax,%eax
  8024a7:	79 19                	jns    8024c2 <free+0xe4>
  8024a9:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  8024b0:	77 10                	ja     8024c2 <free+0xe4>
  8024b2:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  8024b9:	77 07                	ja     8024c2 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  8024bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024be:	85 c0                	test   %eax,%eax
  8024c0:	78 2b                	js     8024ed <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  8024c2:	83 ec 0c             	sub    $0xc,%esp
  8024c5:	68 00 00 00 a0       	push   $0xa0000000
  8024ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8024cd:	ff 75 f0             	pushl  -0x10(%ebp)
  8024d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8024d3:	ff 75 f0             	pushl  -0x10(%ebp)
  8024d6:	ff 75 08             	pushl  0x8(%ebp)
  8024d9:	68 34 4a 80 00       	push   $0x804a34
  8024de:	68 69 01 00 00       	push   $0x169
  8024e3:	68 91 46 80 00       	push   $0x804691
  8024e8:	e8 54 e4 ff ff       	call   800941 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  8024ed:	83 ec 0c             	sub    $0xc,%esp
  8024f0:	ff 75 08             	pushl  0x8(%ebp)
  8024f3:	e8 2c fa ff ff       	call   801f24 <free_pages>
  8024f8:	83 c4 10             	add    $0x10,%esp
		return;
  8024fb:	eb 1b                	jmp    802518 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  8024fd:	ff 75 08             	pushl  0x8(%ebp)
  802500:	68 90 4a 80 00       	push   $0x804a90
  802505:	68 70 01 00 00       	push   $0x170
  80250a:	68 91 46 80 00       	push   $0x804691
  80250f:	e8 2d e4 ff ff       	call   800941 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  802514:	90                   	nop
  802515:	eb 01                	jmp    802518 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  802517:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  802518:	c9                   	leave  
  802519:	c3                   	ret    

0080251a <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80251a:	55                   	push   %ebp
  80251b:	89 e5                	mov    %esp,%ebp
  80251d:	83 ec 38             	sub    $0x38,%esp
  802520:	8b 45 10             	mov    0x10(%ebp),%eax
  802523:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802526:	e8 2e fc ff ff       	call   802159 <uheap_init>
	if (size == 0) return NULL ;
  80252b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80252f:	75 0a                	jne    80253b <smalloc+0x21>
  802531:	b8 00 00 00 00       	mov    $0x0,%eax
  802536:	e9 3d 01 00 00       	jmp    802678 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  80253b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80253e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  802541:	8b 45 0c             	mov    0xc(%ebp),%eax
  802544:	25 ff 0f 00 00       	and    $0xfff,%eax
  802549:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  80254c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802550:	74 0e                	je     802560 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802558:	05 00 10 00 00       	add    $0x1000,%eax
  80255d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  802560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802563:	c1 e8 0c             	shr    $0xc,%eax
  802566:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  802569:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80256e:	85 c0                	test   %eax,%eax
  802570:	75 0a                	jne    80257c <smalloc+0x62>
		return NULL;
  802572:	b8 00 00 00 00       	mov    $0x0,%eax
  802577:	e9 fc 00 00 00       	jmp    802678 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  80257c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802581:	85 c0                	test   %eax,%eax
  802583:	74 0f                	je     802594 <smalloc+0x7a>
  802585:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80258b:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802590:	39 c2                	cmp    %eax,%edx
  802592:	73 0a                	jae    80259e <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  802594:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802599:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  80259e:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8025a3:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8025a8:	29 c2                	sub    %eax,%edx
  8025aa:	89 d0                	mov    %edx,%eax
  8025ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8025af:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8025b5:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8025ba:	29 c2                	sub    %eax,%edx
  8025bc:	89 d0                	mov    %edx,%eax
  8025be:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8025c7:	77 13                	ja     8025dc <smalloc+0xc2>
  8025c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025cc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8025cf:	77 0b                	ja     8025dc <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  8025d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d4:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8025d7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8025da:	73 0a                	jae    8025e6 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  8025dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e1:	e9 92 00 00 00       	jmp    802678 <smalloc+0x15e>
	}

	void *va = NULL;
  8025e6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  8025ed:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8025f2:	83 f8 05             	cmp    $0x5,%eax
  8025f5:	75 11                	jne    802608 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  8025f7:	83 ec 0c             	sub    $0xc,%esp
  8025fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8025fd:	e8 08 f7 ff ff       	call   801d0a <alloc_pages_custom_fit>
  802602:	83 c4 10             	add    $0x10,%esp
  802605:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  802608:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80260c:	75 27                	jne    802635 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  80260e:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  802615:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802618:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80261b:	89 c2                	mov    %eax,%edx
  80261d:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802622:	39 c2                	cmp    %eax,%edx
  802624:	73 07                	jae    80262d <smalloc+0x113>
			return NULL;}
  802626:	b8 00 00 00 00       	mov    $0x0,%eax
  80262b:	eb 4b                	jmp    802678 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  80262d:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802632:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  802635:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802639:	ff 75 f0             	pushl  -0x10(%ebp)
  80263c:	50                   	push   %eax
  80263d:	ff 75 0c             	pushl  0xc(%ebp)
  802640:	ff 75 08             	pushl  0x8(%ebp)
  802643:	e8 cb 03 00 00       	call   802a13 <sys_create_shared_object>
  802648:	83 c4 10             	add    $0x10,%esp
  80264b:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  80264e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802652:	79 07                	jns    80265b <smalloc+0x141>
		return NULL;
  802654:	b8 00 00 00 00       	mov    $0x0,%eax
  802659:	eb 1d                	jmp    802678 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  80265b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802660:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802663:	75 10                	jne    802675 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  802665:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266e:	01 d0                	add    %edx,%eax
  802670:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  802675:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  802678:	c9                   	leave  
  802679:	c3                   	ret    

0080267a <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80267a:	55                   	push   %ebp
  80267b:	89 e5                	mov    %esp,%ebp
  80267d:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802680:	e8 d4 fa ff ff       	call   802159 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802685:	83 ec 08             	sub    $0x8,%esp
  802688:	ff 75 0c             	pushl  0xc(%ebp)
  80268b:	ff 75 08             	pushl  0x8(%ebp)
  80268e:	e8 aa 03 00 00       	call   802a3d <sys_size_of_shared_object>
  802693:	83 c4 10             	add    $0x10,%esp
  802696:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  802699:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80269d:	7f 0a                	jg     8026a9 <sget+0x2f>
		return NULL;
  80269f:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a4:	e9 32 01 00 00       	jmp    8027db <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  8026a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  8026af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b2:	25 ff 0f 00 00       	and    $0xfff,%eax
  8026b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  8026ba:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026be:	74 0e                	je     8026ce <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  8026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c3:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8026c6:	05 00 10 00 00       	add    $0x1000,%eax
  8026cb:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  8026ce:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8026d3:	85 c0                	test   %eax,%eax
  8026d5:	75 0a                	jne    8026e1 <sget+0x67>
		return NULL;
  8026d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026dc:	e9 fa 00 00 00       	jmp    8027db <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8026e1:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8026e6:	85 c0                	test   %eax,%eax
  8026e8:	74 0f                	je     8026f9 <sget+0x7f>
  8026ea:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8026f0:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8026f5:	39 c2                	cmp    %eax,%edx
  8026f7:	73 0a                	jae    802703 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  8026f9:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8026fe:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802703:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802708:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80270d:	29 c2                	sub    %eax,%edx
  80270f:	89 d0                	mov    %edx,%eax
  802711:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802714:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80271a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80271f:	29 c2                	sub    %eax,%edx
  802721:	89 d0                	mov    %edx,%eax
  802723:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802729:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80272c:	77 13                	ja     802741 <sget+0xc7>
  80272e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802731:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802734:	77 0b                	ja     802741 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  802736:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802739:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  80273c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80273f:	73 0a                	jae    80274b <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  802741:	b8 00 00 00 00       	mov    $0x0,%eax
  802746:	e9 90 00 00 00       	jmp    8027db <sget+0x161>

	void *va = NULL;
  80274b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  802752:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802757:	83 f8 05             	cmp    $0x5,%eax
  80275a:	75 11                	jne    80276d <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  80275c:	83 ec 0c             	sub    $0xc,%esp
  80275f:	ff 75 f4             	pushl  -0xc(%ebp)
  802762:	e8 a3 f5 ff ff       	call   801d0a <alloc_pages_custom_fit>
  802767:	83 c4 10             	add    $0x10,%esp
  80276a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  80276d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802771:	75 27                	jne    80279a <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802773:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  80277a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80277d:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802780:	89 c2                	mov    %eax,%edx
  802782:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802787:	39 c2                	cmp    %eax,%edx
  802789:	73 07                	jae    802792 <sget+0x118>
			return NULL;
  80278b:	b8 00 00 00 00       	mov    $0x0,%eax
  802790:	eb 49                	jmp    8027db <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  802792:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802797:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  80279a:	83 ec 04             	sub    $0x4,%esp
  80279d:	ff 75 f0             	pushl  -0x10(%ebp)
  8027a0:	ff 75 0c             	pushl  0xc(%ebp)
  8027a3:	ff 75 08             	pushl  0x8(%ebp)
  8027a6:	e8 af 02 00 00       	call   802a5a <sys_get_shared_object>
  8027ab:	83 c4 10             	add    $0x10,%esp
  8027ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  8027b1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8027b5:	79 07                	jns    8027be <sget+0x144>
		return NULL;
  8027b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bc:	eb 1d                	jmp    8027db <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  8027be:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8027c3:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8027c6:	75 10                	jne    8027d8 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  8027c8:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8027ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d1:	01 d0                	add    %edx,%eax
  8027d3:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  8027d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  8027db:	c9                   	leave  
  8027dc:	c3                   	ret    

008027dd <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8027dd:	55                   	push   %ebp
  8027de:	89 e5                	mov    %esp,%ebp
  8027e0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8027e3:	e8 71 f9 ff ff       	call   802159 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8027e8:	83 ec 04             	sub    $0x4,%esp
  8027eb:	68 b4 4a 80 00       	push   $0x804ab4
  8027f0:	68 19 02 00 00       	push   $0x219
  8027f5:	68 91 46 80 00       	push   $0x804691
  8027fa:	e8 42 e1 ff ff       	call   800941 <_panic>

008027ff <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8027ff:	55                   	push   %ebp
  802800:	89 e5                	mov    %esp,%ebp
  802802:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802805:	83 ec 04             	sub    $0x4,%esp
  802808:	68 dc 4a 80 00       	push   $0x804adc
  80280d:	68 2b 02 00 00       	push   $0x22b
  802812:	68 91 46 80 00       	push   $0x804691
  802817:	e8 25 e1 ff ff       	call   800941 <_panic>

0080281c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80281c:	55                   	push   %ebp
  80281d:	89 e5                	mov    %esp,%ebp
  80281f:	57                   	push   %edi
  802820:	56                   	push   %esi
  802821:	53                   	push   %ebx
  802822:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802825:	8b 45 08             	mov    0x8(%ebp),%eax
  802828:	8b 55 0c             	mov    0xc(%ebp),%edx
  80282b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80282e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802831:	8b 7d 18             	mov    0x18(%ebp),%edi
  802834:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802837:	cd 30                	int    $0x30
  802839:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80283c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80283f:	83 c4 10             	add    $0x10,%esp
  802842:	5b                   	pop    %ebx
  802843:	5e                   	pop    %esi
  802844:	5f                   	pop    %edi
  802845:	5d                   	pop    %ebp
  802846:	c3                   	ret    

00802847 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802847:	55                   	push   %ebp
  802848:	89 e5                	mov    %esp,%ebp
  80284a:	83 ec 04             	sub    $0x4,%esp
  80284d:	8b 45 10             	mov    0x10(%ebp),%eax
  802850:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802853:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802856:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80285a:	8b 45 08             	mov    0x8(%ebp),%eax
  80285d:	6a 00                	push   $0x0
  80285f:	51                   	push   %ecx
  802860:	52                   	push   %edx
  802861:	ff 75 0c             	pushl  0xc(%ebp)
  802864:	50                   	push   %eax
  802865:	6a 00                	push   $0x0
  802867:	e8 b0 ff ff ff       	call   80281c <syscall>
  80286c:	83 c4 18             	add    $0x18,%esp
}
  80286f:	90                   	nop
  802870:	c9                   	leave  
  802871:	c3                   	ret    

00802872 <sys_cgetc>:

int
sys_cgetc(void)
{
  802872:	55                   	push   %ebp
  802873:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802875:	6a 00                	push   $0x0
  802877:	6a 00                	push   $0x0
  802879:	6a 00                	push   $0x0
  80287b:	6a 00                	push   $0x0
  80287d:	6a 00                	push   $0x0
  80287f:	6a 02                	push   $0x2
  802881:	e8 96 ff ff ff       	call   80281c <syscall>
  802886:	83 c4 18             	add    $0x18,%esp
}
  802889:	c9                   	leave  
  80288a:	c3                   	ret    

0080288b <sys_lock_cons>:

void sys_lock_cons(void)
{
  80288b:	55                   	push   %ebp
  80288c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80288e:	6a 00                	push   $0x0
  802890:	6a 00                	push   $0x0
  802892:	6a 00                	push   $0x0
  802894:	6a 00                	push   $0x0
  802896:	6a 00                	push   $0x0
  802898:	6a 03                	push   $0x3
  80289a:	e8 7d ff ff ff       	call   80281c <syscall>
  80289f:	83 c4 18             	add    $0x18,%esp
}
  8028a2:	90                   	nop
  8028a3:	c9                   	leave  
  8028a4:	c3                   	ret    

008028a5 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8028a5:	55                   	push   %ebp
  8028a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8028a8:	6a 00                	push   $0x0
  8028aa:	6a 00                	push   $0x0
  8028ac:	6a 00                	push   $0x0
  8028ae:	6a 00                	push   $0x0
  8028b0:	6a 00                	push   $0x0
  8028b2:	6a 04                	push   $0x4
  8028b4:	e8 63 ff ff ff       	call   80281c <syscall>
  8028b9:	83 c4 18             	add    $0x18,%esp
}
  8028bc:	90                   	nop
  8028bd:	c9                   	leave  
  8028be:	c3                   	ret    

008028bf <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8028bf:	55                   	push   %ebp
  8028c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8028c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c8:	6a 00                	push   $0x0
  8028ca:	6a 00                	push   $0x0
  8028cc:	6a 00                	push   $0x0
  8028ce:	52                   	push   %edx
  8028cf:	50                   	push   %eax
  8028d0:	6a 08                	push   $0x8
  8028d2:	e8 45 ff ff ff       	call   80281c <syscall>
  8028d7:	83 c4 18             	add    $0x18,%esp
}
  8028da:	c9                   	leave  
  8028db:	c3                   	ret    

008028dc <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8028dc:	55                   	push   %ebp
  8028dd:	89 e5                	mov    %esp,%ebp
  8028df:	56                   	push   %esi
  8028e0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8028e1:	8b 75 18             	mov    0x18(%ebp),%esi
  8028e4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f0:	56                   	push   %esi
  8028f1:	53                   	push   %ebx
  8028f2:	51                   	push   %ecx
  8028f3:	52                   	push   %edx
  8028f4:	50                   	push   %eax
  8028f5:	6a 09                	push   $0x9
  8028f7:	e8 20 ff ff ff       	call   80281c <syscall>
  8028fc:	83 c4 18             	add    $0x18,%esp
}
  8028ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802902:	5b                   	pop    %ebx
  802903:	5e                   	pop    %esi
  802904:	5d                   	pop    %ebp
  802905:	c3                   	ret    

00802906 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802906:	55                   	push   %ebp
  802907:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802909:	6a 00                	push   $0x0
  80290b:	6a 00                	push   $0x0
  80290d:	6a 00                	push   $0x0
  80290f:	6a 00                	push   $0x0
  802911:	ff 75 08             	pushl  0x8(%ebp)
  802914:	6a 0a                	push   $0xa
  802916:	e8 01 ff ff ff       	call   80281c <syscall>
  80291b:	83 c4 18             	add    $0x18,%esp
}
  80291e:	c9                   	leave  
  80291f:	c3                   	ret    

00802920 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802920:	55                   	push   %ebp
  802921:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802923:	6a 00                	push   $0x0
  802925:	6a 00                	push   $0x0
  802927:	6a 00                	push   $0x0
  802929:	ff 75 0c             	pushl  0xc(%ebp)
  80292c:	ff 75 08             	pushl  0x8(%ebp)
  80292f:	6a 0b                	push   $0xb
  802931:	e8 e6 fe ff ff       	call   80281c <syscall>
  802936:	83 c4 18             	add    $0x18,%esp
}
  802939:	c9                   	leave  
  80293a:	c3                   	ret    

0080293b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80293b:	55                   	push   %ebp
  80293c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80293e:	6a 00                	push   $0x0
  802940:	6a 00                	push   $0x0
  802942:	6a 00                	push   $0x0
  802944:	6a 00                	push   $0x0
  802946:	6a 00                	push   $0x0
  802948:	6a 0c                	push   $0xc
  80294a:	e8 cd fe ff ff       	call   80281c <syscall>
  80294f:	83 c4 18             	add    $0x18,%esp
}
  802952:	c9                   	leave  
  802953:	c3                   	ret    

00802954 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802954:	55                   	push   %ebp
  802955:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802957:	6a 00                	push   $0x0
  802959:	6a 00                	push   $0x0
  80295b:	6a 00                	push   $0x0
  80295d:	6a 00                	push   $0x0
  80295f:	6a 00                	push   $0x0
  802961:	6a 0d                	push   $0xd
  802963:	e8 b4 fe ff ff       	call   80281c <syscall>
  802968:	83 c4 18             	add    $0x18,%esp
}
  80296b:	c9                   	leave  
  80296c:	c3                   	ret    

0080296d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80296d:	55                   	push   %ebp
  80296e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802970:	6a 00                	push   $0x0
  802972:	6a 00                	push   $0x0
  802974:	6a 00                	push   $0x0
  802976:	6a 00                	push   $0x0
  802978:	6a 00                	push   $0x0
  80297a:	6a 0e                	push   $0xe
  80297c:	e8 9b fe ff ff       	call   80281c <syscall>
  802981:	83 c4 18             	add    $0x18,%esp
}
  802984:	c9                   	leave  
  802985:	c3                   	ret    

00802986 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802986:	55                   	push   %ebp
  802987:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802989:	6a 00                	push   $0x0
  80298b:	6a 00                	push   $0x0
  80298d:	6a 00                	push   $0x0
  80298f:	6a 00                	push   $0x0
  802991:	6a 00                	push   $0x0
  802993:	6a 0f                	push   $0xf
  802995:	e8 82 fe ff ff       	call   80281c <syscall>
  80299a:	83 c4 18             	add    $0x18,%esp
}
  80299d:	c9                   	leave  
  80299e:	c3                   	ret    

0080299f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80299f:	55                   	push   %ebp
  8029a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8029a2:	6a 00                	push   $0x0
  8029a4:	6a 00                	push   $0x0
  8029a6:	6a 00                	push   $0x0
  8029a8:	6a 00                	push   $0x0
  8029aa:	ff 75 08             	pushl  0x8(%ebp)
  8029ad:	6a 10                	push   $0x10
  8029af:	e8 68 fe ff ff       	call   80281c <syscall>
  8029b4:	83 c4 18             	add    $0x18,%esp
}
  8029b7:	c9                   	leave  
  8029b8:	c3                   	ret    

008029b9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8029b9:	55                   	push   %ebp
  8029ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8029bc:	6a 00                	push   $0x0
  8029be:	6a 00                	push   $0x0
  8029c0:	6a 00                	push   $0x0
  8029c2:	6a 00                	push   $0x0
  8029c4:	6a 00                	push   $0x0
  8029c6:	6a 11                	push   $0x11
  8029c8:	e8 4f fe ff ff       	call   80281c <syscall>
  8029cd:	83 c4 18             	add    $0x18,%esp
}
  8029d0:	90                   	nop
  8029d1:	c9                   	leave  
  8029d2:	c3                   	ret    

008029d3 <sys_cputc>:

void
sys_cputc(const char c)
{
  8029d3:	55                   	push   %ebp
  8029d4:	89 e5                	mov    %esp,%ebp
  8029d6:	83 ec 04             	sub    $0x4,%esp
  8029d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8029df:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8029e3:	6a 00                	push   $0x0
  8029e5:	6a 00                	push   $0x0
  8029e7:	6a 00                	push   $0x0
  8029e9:	6a 00                	push   $0x0
  8029eb:	50                   	push   %eax
  8029ec:	6a 01                	push   $0x1
  8029ee:	e8 29 fe ff ff       	call   80281c <syscall>
  8029f3:	83 c4 18             	add    $0x18,%esp
}
  8029f6:	90                   	nop
  8029f7:	c9                   	leave  
  8029f8:	c3                   	ret    

008029f9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8029f9:	55                   	push   %ebp
  8029fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8029fc:	6a 00                	push   $0x0
  8029fe:	6a 00                	push   $0x0
  802a00:	6a 00                	push   $0x0
  802a02:	6a 00                	push   $0x0
  802a04:	6a 00                	push   $0x0
  802a06:	6a 14                	push   $0x14
  802a08:	e8 0f fe ff ff       	call   80281c <syscall>
  802a0d:	83 c4 18             	add    $0x18,%esp
}
  802a10:	90                   	nop
  802a11:	c9                   	leave  
  802a12:	c3                   	ret    

00802a13 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802a13:	55                   	push   %ebp
  802a14:	89 e5                	mov    %esp,%ebp
  802a16:	83 ec 04             	sub    $0x4,%esp
  802a19:	8b 45 10             	mov    0x10(%ebp),%eax
  802a1c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802a1f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802a22:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802a26:	8b 45 08             	mov    0x8(%ebp),%eax
  802a29:	6a 00                	push   $0x0
  802a2b:	51                   	push   %ecx
  802a2c:	52                   	push   %edx
  802a2d:	ff 75 0c             	pushl  0xc(%ebp)
  802a30:	50                   	push   %eax
  802a31:	6a 15                	push   $0x15
  802a33:	e8 e4 fd ff ff       	call   80281c <syscall>
  802a38:	83 c4 18             	add    $0x18,%esp
}
  802a3b:	c9                   	leave  
  802a3c:	c3                   	ret    

00802a3d <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802a3d:	55                   	push   %ebp
  802a3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802a40:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a43:	8b 45 08             	mov    0x8(%ebp),%eax
  802a46:	6a 00                	push   $0x0
  802a48:	6a 00                	push   $0x0
  802a4a:	6a 00                	push   $0x0
  802a4c:	52                   	push   %edx
  802a4d:	50                   	push   %eax
  802a4e:	6a 16                	push   $0x16
  802a50:	e8 c7 fd ff ff       	call   80281c <syscall>
  802a55:	83 c4 18             	add    $0x18,%esp
}
  802a58:	c9                   	leave  
  802a59:	c3                   	ret    

00802a5a <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802a5a:	55                   	push   %ebp
  802a5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802a5d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a60:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a63:	8b 45 08             	mov    0x8(%ebp),%eax
  802a66:	6a 00                	push   $0x0
  802a68:	6a 00                	push   $0x0
  802a6a:	51                   	push   %ecx
  802a6b:	52                   	push   %edx
  802a6c:	50                   	push   %eax
  802a6d:	6a 17                	push   $0x17
  802a6f:	e8 a8 fd ff ff       	call   80281c <syscall>
  802a74:	83 c4 18             	add    $0x18,%esp
}
  802a77:	c9                   	leave  
  802a78:	c3                   	ret    

00802a79 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802a79:	55                   	push   %ebp
  802a7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802a7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a82:	6a 00                	push   $0x0
  802a84:	6a 00                	push   $0x0
  802a86:	6a 00                	push   $0x0
  802a88:	52                   	push   %edx
  802a89:	50                   	push   %eax
  802a8a:	6a 18                	push   $0x18
  802a8c:	e8 8b fd ff ff       	call   80281c <syscall>
  802a91:	83 c4 18             	add    $0x18,%esp
}
  802a94:	c9                   	leave  
  802a95:	c3                   	ret    

00802a96 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802a96:	55                   	push   %ebp
  802a97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802a99:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9c:	6a 00                	push   $0x0
  802a9e:	ff 75 14             	pushl  0x14(%ebp)
  802aa1:	ff 75 10             	pushl  0x10(%ebp)
  802aa4:	ff 75 0c             	pushl  0xc(%ebp)
  802aa7:	50                   	push   %eax
  802aa8:	6a 19                	push   $0x19
  802aaa:	e8 6d fd ff ff       	call   80281c <syscall>
  802aaf:	83 c4 18             	add    $0x18,%esp
}
  802ab2:	c9                   	leave  
  802ab3:	c3                   	ret    

00802ab4 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802ab4:	55                   	push   %ebp
  802ab5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aba:	6a 00                	push   $0x0
  802abc:	6a 00                	push   $0x0
  802abe:	6a 00                	push   $0x0
  802ac0:	6a 00                	push   $0x0
  802ac2:	50                   	push   %eax
  802ac3:	6a 1a                	push   $0x1a
  802ac5:	e8 52 fd ff ff       	call   80281c <syscall>
  802aca:	83 c4 18             	add    $0x18,%esp
}
  802acd:	90                   	nop
  802ace:	c9                   	leave  
  802acf:	c3                   	ret    

00802ad0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802ad0:	55                   	push   %ebp
  802ad1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad6:	6a 00                	push   $0x0
  802ad8:	6a 00                	push   $0x0
  802ada:	6a 00                	push   $0x0
  802adc:	6a 00                	push   $0x0
  802ade:	50                   	push   %eax
  802adf:	6a 1b                	push   $0x1b
  802ae1:	e8 36 fd ff ff       	call   80281c <syscall>
  802ae6:	83 c4 18             	add    $0x18,%esp
}
  802ae9:	c9                   	leave  
  802aea:	c3                   	ret    

00802aeb <sys_getenvid>:

int32 sys_getenvid(void)
{
  802aeb:	55                   	push   %ebp
  802aec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802aee:	6a 00                	push   $0x0
  802af0:	6a 00                	push   $0x0
  802af2:	6a 00                	push   $0x0
  802af4:	6a 00                	push   $0x0
  802af6:	6a 00                	push   $0x0
  802af8:	6a 05                	push   $0x5
  802afa:	e8 1d fd ff ff       	call   80281c <syscall>
  802aff:	83 c4 18             	add    $0x18,%esp
}
  802b02:	c9                   	leave  
  802b03:	c3                   	ret    

00802b04 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802b04:	55                   	push   %ebp
  802b05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802b07:	6a 00                	push   $0x0
  802b09:	6a 00                	push   $0x0
  802b0b:	6a 00                	push   $0x0
  802b0d:	6a 00                	push   $0x0
  802b0f:	6a 00                	push   $0x0
  802b11:	6a 06                	push   $0x6
  802b13:	e8 04 fd ff ff       	call   80281c <syscall>
  802b18:	83 c4 18             	add    $0x18,%esp
}
  802b1b:	c9                   	leave  
  802b1c:	c3                   	ret    

00802b1d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802b1d:	55                   	push   %ebp
  802b1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802b20:	6a 00                	push   $0x0
  802b22:	6a 00                	push   $0x0
  802b24:	6a 00                	push   $0x0
  802b26:	6a 00                	push   $0x0
  802b28:	6a 00                	push   $0x0
  802b2a:	6a 07                	push   $0x7
  802b2c:	e8 eb fc ff ff       	call   80281c <syscall>
  802b31:	83 c4 18             	add    $0x18,%esp
}
  802b34:	c9                   	leave  
  802b35:	c3                   	ret    

00802b36 <sys_exit_env>:


void sys_exit_env(void)
{
  802b36:	55                   	push   %ebp
  802b37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802b39:	6a 00                	push   $0x0
  802b3b:	6a 00                	push   $0x0
  802b3d:	6a 00                	push   $0x0
  802b3f:	6a 00                	push   $0x0
  802b41:	6a 00                	push   $0x0
  802b43:	6a 1c                	push   $0x1c
  802b45:	e8 d2 fc ff ff       	call   80281c <syscall>
  802b4a:	83 c4 18             	add    $0x18,%esp
}
  802b4d:	90                   	nop
  802b4e:	c9                   	leave  
  802b4f:	c3                   	ret    

00802b50 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802b50:	55                   	push   %ebp
  802b51:	89 e5                	mov    %esp,%ebp
  802b53:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802b56:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802b59:	8d 50 04             	lea    0x4(%eax),%edx
  802b5c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802b5f:	6a 00                	push   $0x0
  802b61:	6a 00                	push   $0x0
  802b63:	6a 00                	push   $0x0
  802b65:	52                   	push   %edx
  802b66:	50                   	push   %eax
  802b67:	6a 1d                	push   $0x1d
  802b69:	e8 ae fc ff ff       	call   80281c <syscall>
  802b6e:	83 c4 18             	add    $0x18,%esp
	return result;
  802b71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802b77:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802b7a:	89 01                	mov    %eax,(%ecx)
  802b7c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b82:	c9                   	leave  
  802b83:	c2 04 00             	ret    $0x4

00802b86 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802b86:	55                   	push   %ebp
  802b87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802b89:	6a 00                	push   $0x0
  802b8b:	6a 00                	push   $0x0
  802b8d:	ff 75 10             	pushl  0x10(%ebp)
  802b90:	ff 75 0c             	pushl  0xc(%ebp)
  802b93:	ff 75 08             	pushl  0x8(%ebp)
  802b96:	6a 13                	push   $0x13
  802b98:	e8 7f fc ff ff       	call   80281c <syscall>
  802b9d:	83 c4 18             	add    $0x18,%esp
	return ;
  802ba0:	90                   	nop
}
  802ba1:	c9                   	leave  
  802ba2:	c3                   	ret    

00802ba3 <sys_rcr2>:
uint32 sys_rcr2()
{
  802ba3:	55                   	push   %ebp
  802ba4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802ba6:	6a 00                	push   $0x0
  802ba8:	6a 00                	push   $0x0
  802baa:	6a 00                	push   $0x0
  802bac:	6a 00                	push   $0x0
  802bae:	6a 00                	push   $0x0
  802bb0:	6a 1e                	push   $0x1e
  802bb2:	e8 65 fc ff ff       	call   80281c <syscall>
  802bb7:	83 c4 18             	add    $0x18,%esp
}
  802bba:	c9                   	leave  
  802bbb:	c3                   	ret    

00802bbc <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802bbc:	55                   	push   %ebp
  802bbd:	89 e5                	mov    %esp,%ebp
  802bbf:	83 ec 04             	sub    $0x4,%esp
  802bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802bc8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802bcc:	6a 00                	push   $0x0
  802bce:	6a 00                	push   $0x0
  802bd0:	6a 00                	push   $0x0
  802bd2:	6a 00                	push   $0x0
  802bd4:	50                   	push   %eax
  802bd5:	6a 1f                	push   $0x1f
  802bd7:	e8 40 fc ff ff       	call   80281c <syscall>
  802bdc:	83 c4 18             	add    $0x18,%esp
	return ;
  802bdf:	90                   	nop
}
  802be0:	c9                   	leave  
  802be1:	c3                   	ret    

00802be2 <rsttst>:
void rsttst()
{
  802be2:	55                   	push   %ebp
  802be3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802be5:	6a 00                	push   $0x0
  802be7:	6a 00                	push   $0x0
  802be9:	6a 00                	push   $0x0
  802beb:	6a 00                	push   $0x0
  802bed:	6a 00                	push   $0x0
  802bef:	6a 21                	push   $0x21
  802bf1:	e8 26 fc ff ff       	call   80281c <syscall>
  802bf6:	83 c4 18             	add    $0x18,%esp
	return ;
  802bf9:	90                   	nop
}
  802bfa:	c9                   	leave  
  802bfb:	c3                   	ret    

00802bfc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802bfc:	55                   	push   %ebp
  802bfd:	89 e5                	mov    %esp,%ebp
  802bff:	83 ec 04             	sub    $0x4,%esp
  802c02:	8b 45 14             	mov    0x14(%ebp),%eax
  802c05:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802c08:	8b 55 18             	mov    0x18(%ebp),%edx
  802c0b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802c0f:	52                   	push   %edx
  802c10:	50                   	push   %eax
  802c11:	ff 75 10             	pushl  0x10(%ebp)
  802c14:	ff 75 0c             	pushl  0xc(%ebp)
  802c17:	ff 75 08             	pushl  0x8(%ebp)
  802c1a:	6a 20                	push   $0x20
  802c1c:	e8 fb fb ff ff       	call   80281c <syscall>
  802c21:	83 c4 18             	add    $0x18,%esp
	return ;
  802c24:	90                   	nop
}
  802c25:	c9                   	leave  
  802c26:	c3                   	ret    

00802c27 <chktst>:
void chktst(uint32 n)
{
  802c27:	55                   	push   %ebp
  802c28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802c2a:	6a 00                	push   $0x0
  802c2c:	6a 00                	push   $0x0
  802c2e:	6a 00                	push   $0x0
  802c30:	6a 00                	push   $0x0
  802c32:	ff 75 08             	pushl  0x8(%ebp)
  802c35:	6a 22                	push   $0x22
  802c37:	e8 e0 fb ff ff       	call   80281c <syscall>
  802c3c:	83 c4 18             	add    $0x18,%esp
	return ;
  802c3f:	90                   	nop
}
  802c40:	c9                   	leave  
  802c41:	c3                   	ret    

00802c42 <inctst>:

void inctst()
{
  802c42:	55                   	push   %ebp
  802c43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802c45:	6a 00                	push   $0x0
  802c47:	6a 00                	push   $0x0
  802c49:	6a 00                	push   $0x0
  802c4b:	6a 00                	push   $0x0
  802c4d:	6a 00                	push   $0x0
  802c4f:	6a 23                	push   $0x23
  802c51:	e8 c6 fb ff ff       	call   80281c <syscall>
  802c56:	83 c4 18             	add    $0x18,%esp
	return ;
  802c59:	90                   	nop
}
  802c5a:	c9                   	leave  
  802c5b:	c3                   	ret    

00802c5c <gettst>:
uint32 gettst()
{
  802c5c:	55                   	push   %ebp
  802c5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802c5f:	6a 00                	push   $0x0
  802c61:	6a 00                	push   $0x0
  802c63:	6a 00                	push   $0x0
  802c65:	6a 00                	push   $0x0
  802c67:	6a 00                	push   $0x0
  802c69:	6a 24                	push   $0x24
  802c6b:	e8 ac fb ff ff       	call   80281c <syscall>
  802c70:	83 c4 18             	add    $0x18,%esp
}
  802c73:	c9                   	leave  
  802c74:	c3                   	ret    

00802c75 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802c75:	55                   	push   %ebp
  802c76:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c78:	6a 00                	push   $0x0
  802c7a:	6a 00                	push   $0x0
  802c7c:	6a 00                	push   $0x0
  802c7e:	6a 00                	push   $0x0
  802c80:	6a 00                	push   $0x0
  802c82:	6a 25                	push   $0x25
  802c84:	e8 93 fb ff ff       	call   80281c <syscall>
  802c89:	83 c4 18             	add    $0x18,%esp
  802c8c:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802c91:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  802c96:	c9                   	leave  
  802c97:	c3                   	ret    

00802c98 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802c98:	55                   	push   %ebp
  802c99:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9e:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802ca3:	6a 00                	push   $0x0
  802ca5:	6a 00                	push   $0x0
  802ca7:	6a 00                	push   $0x0
  802ca9:	6a 00                	push   $0x0
  802cab:	ff 75 08             	pushl  0x8(%ebp)
  802cae:	6a 26                	push   $0x26
  802cb0:	e8 67 fb ff ff       	call   80281c <syscall>
  802cb5:	83 c4 18             	add    $0x18,%esp
	return ;
  802cb8:	90                   	nop
}
  802cb9:	c9                   	leave  
  802cba:	c3                   	ret    

00802cbb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802cbb:	55                   	push   %ebp
  802cbc:	89 e5                	mov    %esp,%ebp
  802cbe:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802cbf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802cc2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802cc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccb:	6a 00                	push   $0x0
  802ccd:	53                   	push   %ebx
  802cce:	51                   	push   %ecx
  802ccf:	52                   	push   %edx
  802cd0:	50                   	push   %eax
  802cd1:	6a 27                	push   $0x27
  802cd3:	e8 44 fb ff ff       	call   80281c <syscall>
  802cd8:	83 c4 18             	add    $0x18,%esp
}
  802cdb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802cde:	c9                   	leave  
  802cdf:	c3                   	ret    

00802ce0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802ce0:	55                   	push   %ebp
  802ce1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802ce3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce9:	6a 00                	push   $0x0
  802ceb:	6a 00                	push   $0x0
  802ced:	6a 00                	push   $0x0
  802cef:	52                   	push   %edx
  802cf0:	50                   	push   %eax
  802cf1:	6a 28                	push   $0x28
  802cf3:	e8 24 fb ff ff       	call   80281c <syscall>
  802cf8:	83 c4 18             	add    $0x18,%esp
}
  802cfb:	c9                   	leave  
  802cfc:	c3                   	ret    

00802cfd <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802cfd:	55                   	push   %ebp
  802cfe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802d00:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802d03:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d06:	8b 45 08             	mov    0x8(%ebp),%eax
  802d09:	6a 00                	push   $0x0
  802d0b:	51                   	push   %ecx
  802d0c:	ff 75 10             	pushl  0x10(%ebp)
  802d0f:	52                   	push   %edx
  802d10:	50                   	push   %eax
  802d11:	6a 29                	push   $0x29
  802d13:	e8 04 fb ff ff       	call   80281c <syscall>
  802d18:	83 c4 18             	add    $0x18,%esp
}
  802d1b:	c9                   	leave  
  802d1c:	c3                   	ret    

00802d1d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802d1d:	55                   	push   %ebp
  802d1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802d20:	6a 00                	push   $0x0
  802d22:	6a 00                	push   $0x0
  802d24:	ff 75 10             	pushl  0x10(%ebp)
  802d27:	ff 75 0c             	pushl  0xc(%ebp)
  802d2a:	ff 75 08             	pushl  0x8(%ebp)
  802d2d:	6a 12                	push   $0x12
  802d2f:	e8 e8 fa ff ff       	call   80281c <syscall>
  802d34:	83 c4 18             	add    $0x18,%esp
	return ;
  802d37:	90                   	nop
}
  802d38:	c9                   	leave  
  802d39:	c3                   	ret    

00802d3a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802d3a:	55                   	push   %ebp
  802d3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802d3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d40:	8b 45 08             	mov    0x8(%ebp),%eax
  802d43:	6a 00                	push   $0x0
  802d45:	6a 00                	push   $0x0
  802d47:	6a 00                	push   $0x0
  802d49:	52                   	push   %edx
  802d4a:	50                   	push   %eax
  802d4b:	6a 2a                	push   $0x2a
  802d4d:	e8 ca fa ff ff       	call   80281c <syscall>
  802d52:	83 c4 18             	add    $0x18,%esp
	return;
  802d55:	90                   	nop
}
  802d56:	c9                   	leave  
  802d57:	c3                   	ret    

00802d58 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802d58:	55                   	push   %ebp
  802d59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802d5b:	6a 00                	push   $0x0
  802d5d:	6a 00                	push   $0x0
  802d5f:	6a 00                	push   $0x0
  802d61:	6a 00                	push   $0x0
  802d63:	6a 00                	push   $0x0
  802d65:	6a 2b                	push   $0x2b
  802d67:	e8 b0 fa ff ff       	call   80281c <syscall>
  802d6c:	83 c4 18             	add    $0x18,%esp
}
  802d6f:	c9                   	leave  
  802d70:	c3                   	ret    

00802d71 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802d71:	55                   	push   %ebp
  802d72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802d74:	6a 00                	push   $0x0
  802d76:	6a 00                	push   $0x0
  802d78:	6a 00                	push   $0x0
  802d7a:	ff 75 0c             	pushl  0xc(%ebp)
  802d7d:	ff 75 08             	pushl  0x8(%ebp)
  802d80:	6a 2d                	push   $0x2d
  802d82:	e8 95 fa ff ff       	call   80281c <syscall>
  802d87:	83 c4 18             	add    $0x18,%esp
	return;
  802d8a:	90                   	nop
}
  802d8b:	c9                   	leave  
  802d8c:	c3                   	ret    

00802d8d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802d8d:	55                   	push   %ebp
  802d8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802d90:	6a 00                	push   $0x0
  802d92:	6a 00                	push   $0x0
  802d94:	6a 00                	push   $0x0
  802d96:	ff 75 0c             	pushl  0xc(%ebp)
  802d99:	ff 75 08             	pushl  0x8(%ebp)
  802d9c:	6a 2c                	push   $0x2c
  802d9e:	e8 79 fa ff ff       	call   80281c <syscall>
  802da3:	83 c4 18             	add    $0x18,%esp
	return ;
  802da6:	90                   	nop
}
  802da7:	c9                   	leave  
  802da8:	c3                   	ret    

00802da9 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802da9:	55                   	push   %ebp
  802daa:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802dac:	8b 55 0c             	mov    0xc(%ebp),%edx
  802daf:	8b 45 08             	mov    0x8(%ebp),%eax
  802db2:	6a 00                	push   $0x0
  802db4:	6a 00                	push   $0x0
  802db6:	6a 00                	push   $0x0
  802db8:	52                   	push   %edx
  802db9:	50                   	push   %eax
  802dba:	6a 2e                	push   $0x2e
  802dbc:	e8 5b fa ff ff       	call   80281c <syscall>
  802dc1:	83 c4 18             	add    $0x18,%esp
	return ;
  802dc4:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  802dc5:	c9                   	leave  
  802dc6:	c3                   	ret    

00802dc7 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802dc7:	55                   	push   %ebp
  802dc8:	89 e5                	mov    %esp,%ebp
  802dca:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802dcd:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  802dd4:	72 09                	jb     802ddf <to_page_va+0x18>
  802dd6:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  802ddd:	72 14                	jb     802df3 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802ddf:	83 ec 04             	sub    $0x4,%esp
  802de2:	68 00 4b 80 00       	push   $0x804b00
  802de7:	6a 15                	push   $0x15
  802de9:	68 2b 4b 80 00       	push   $0x804b2b
  802dee:	e8 4e db ff ff       	call   800941 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802df3:	8b 45 08             	mov    0x8(%ebp),%eax
  802df6:	ba 60 50 80 00       	mov    $0x805060,%edx
  802dfb:	29 d0                	sub    %edx,%eax
  802dfd:	c1 f8 02             	sar    $0x2,%eax
  802e00:	89 c2                	mov    %eax,%edx
  802e02:	89 d0                	mov    %edx,%eax
  802e04:	c1 e0 02             	shl    $0x2,%eax
  802e07:	01 d0                	add    %edx,%eax
  802e09:	c1 e0 02             	shl    $0x2,%eax
  802e0c:	01 d0                	add    %edx,%eax
  802e0e:	c1 e0 02             	shl    $0x2,%eax
  802e11:	01 d0                	add    %edx,%eax
  802e13:	89 c1                	mov    %eax,%ecx
  802e15:	c1 e1 08             	shl    $0x8,%ecx
  802e18:	01 c8                	add    %ecx,%eax
  802e1a:	89 c1                	mov    %eax,%ecx
  802e1c:	c1 e1 10             	shl    $0x10,%ecx
  802e1f:	01 c8                	add    %ecx,%eax
  802e21:	01 c0                	add    %eax,%eax
  802e23:	01 d0                	add    %edx,%eax
  802e25:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2b:	c1 e0 0c             	shl    $0xc,%eax
  802e2e:	89 c2                	mov    %eax,%edx
  802e30:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802e35:	01 d0                	add    %edx,%eax
}
  802e37:	c9                   	leave  
  802e38:	c3                   	ret    

00802e39 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802e39:	55                   	push   %ebp
  802e3a:	89 e5                	mov    %esp,%ebp
  802e3c:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802e3f:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802e44:	8b 55 08             	mov    0x8(%ebp),%edx
  802e47:	29 c2                	sub    %eax,%edx
  802e49:	89 d0                	mov    %edx,%eax
  802e4b:	c1 e8 0c             	shr    $0xc,%eax
  802e4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802e51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e55:	78 09                	js     802e60 <to_page_info+0x27>
  802e57:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802e5e:	7e 14                	jle    802e74 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802e60:	83 ec 04             	sub    $0x4,%esp
  802e63:	68 44 4b 80 00       	push   $0x804b44
  802e68:	6a 22                	push   $0x22
  802e6a:	68 2b 4b 80 00       	push   $0x804b2b
  802e6f:	e8 cd da ff ff       	call   800941 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802e74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e77:	89 d0                	mov    %edx,%eax
  802e79:	01 c0                	add    %eax,%eax
  802e7b:	01 d0                	add    %edx,%eax
  802e7d:	c1 e0 02             	shl    $0x2,%eax
  802e80:	05 60 50 80 00       	add    $0x805060,%eax
}
  802e85:	c9                   	leave  
  802e86:	c3                   	ret    

00802e87 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802e87:	55                   	push   %ebp
  802e88:	89 e5                	mov    %esp,%ebp
  802e8a:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e90:	05 00 00 00 02       	add    $0x2000000,%eax
  802e95:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e98:	73 16                	jae    802eb0 <initialize_dynamic_allocator+0x29>
  802e9a:	68 68 4b 80 00       	push   $0x804b68
  802e9f:	68 8e 4b 80 00       	push   $0x804b8e
  802ea4:	6a 34                	push   $0x34
  802ea6:	68 2b 4b 80 00       	push   $0x804b2b
  802eab:	e8 91 da ff ff       	call   800941 <_panic>
		is_initialized = 1;
  802eb0:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  802eb7:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  802eba:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebd:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  802ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec5:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  802eca:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  802ed1:	00 00 00 
  802ed4:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802edb:	00 00 00 
  802ede:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  802ee5:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  802ee8:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  802eef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ef6:	eb 36                	jmp    802f2e <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  802ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efb:	c1 e0 04             	shl    $0x4,%eax
  802efe:	05 80 d0 81 00       	add    $0x81d080,%eax
  802f03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0c:	c1 e0 04             	shl    $0x4,%eax
  802f0f:	05 84 d0 81 00       	add    $0x81d084,%eax
  802f14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1d:	c1 e0 04             	shl    $0x4,%eax
  802f20:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  802f2b:	ff 45 f4             	incl   -0xc(%ebp)
  802f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f31:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802f34:	72 c2                	jb     802ef8 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  802f36:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802f3c:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802f41:	29 c2                	sub    %eax,%edx
  802f43:	89 d0                	mov    %edx,%eax
  802f45:	c1 e8 0c             	shr    $0xc,%eax
  802f48:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802f4b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802f52:	e9 c8 00 00 00       	jmp    80301f <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802f57:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f5a:	89 d0                	mov    %edx,%eax
  802f5c:	01 c0                	add    %eax,%eax
  802f5e:	01 d0                	add    %edx,%eax
  802f60:	c1 e0 02             	shl    $0x2,%eax
  802f63:	05 68 50 80 00       	add    $0x805068,%eax
  802f68:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802f6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f70:	89 d0                	mov    %edx,%eax
  802f72:	01 c0                	add    %eax,%eax
  802f74:	01 d0                	add    %edx,%eax
  802f76:	c1 e0 02             	shl    $0x2,%eax
  802f79:	05 6a 50 80 00       	add    $0x80506a,%eax
  802f7e:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802f83:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802f89:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802f8c:	89 c8                	mov    %ecx,%eax
  802f8e:	01 c0                	add    %eax,%eax
  802f90:	01 c8                	add    %ecx,%eax
  802f92:	c1 e0 02             	shl    $0x2,%eax
  802f95:	05 64 50 80 00       	add    $0x805064,%eax
  802f9a:	89 10                	mov    %edx,(%eax)
  802f9c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f9f:	89 d0                	mov    %edx,%eax
  802fa1:	01 c0                	add    %eax,%eax
  802fa3:	01 d0                	add    %edx,%eax
  802fa5:	c1 e0 02             	shl    $0x2,%eax
  802fa8:	05 64 50 80 00       	add    $0x805064,%eax
  802fad:	8b 00                	mov    (%eax),%eax
  802faf:	85 c0                	test   %eax,%eax
  802fb1:	74 1b                	je     802fce <initialize_dynamic_allocator+0x147>
  802fb3:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802fb9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802fbc:	89 c8                	mov    %ecx,%eax
  802fbe:	01 c0                	add    %eax,%eax
  802fc0:	01 c8                	add    %ecx,%eax
  802fc2:	c1 e0 02             	shl    $0x2,%eax
  802fc5:	05 60 50 80 00       	add    $0x805060,%eax
  802fca:	89 02                	mov    %eax,(%edx)
  802fcc:	eb 16                	jmp    802fe4 <initialize_dynamic_allocator+0x15d>
  802fce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fd1:	89 d0                	mov    %edx,%eax
  802fd3:	01 c0                	add    %eax,%eax
  802fd5:	01 d0                	add    %edx,%eax
  802fd7:	c1 e0 02             	shl    $0x2,%eax
  802fda:	05 60 50 80 00       	add    $0x805060,%eax
  802fdf:	a3 48 50 80 00       	mov    %eax,0x805048
  802fe4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fe7:	89 d0                	mov    %edx,%eax
  802fe9:	01 c0                	add    %eax,%eax
  802feb:	01 d0                	add    %edx,%eax
  802fed:	c1 e0 02             	shl    $0x2,%eax
  802ff0:	05 60 50 80 00       	add    $0x805060,%eax
  802ff5:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802ffa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ffd:	89 d0                	mov    %edx,%eax
  802fff:	01 c0                	add    %eax,%eax
  803001:	01 d0                	add    %edx,%eax
  803003:	c1 e0 02             	shl    $0x2,%eax
  803006:	05 60 50 80 00       	add    $0x805060,%eax
  80300b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803011:	a1 54 50 80 00       	mov    0x805054,%eax
  803016:	40                   	inc    %eax
  803017:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  80301c:	ff 45 f0             	incl   -0x10(%ebp)
  80301f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803022:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803025:	0f 82 2c ff ff ff    	jb     802f57 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  80302b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80302e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803031:	eb 2f                	jmp    803062 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  803033:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803036:	89 d0                	mov    %edx,%eax
  803038:	01 c0                	add    %eax,%eax
  80303a:	01 d0                	add    %edx,%eax
  80303c:	c1 e0 02             	shl    $0x2,%eax
  80303f:	05 68 50 80 00       	add    $0x805068,%eax
  803044:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  803049:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80304c:	89 d0                	mov    %edx,%eax
  80304e:	01 c0                	add    %eax,%eax
  803050:	01 d0                	add    %edx,%eax
  803052:	c1 e0 02             	shl    $0x2,%eax
  803055:	05 6a 50 80 00       	add    $0x80506a,%eax
  80305a:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  80305f:	ff 45 ec             	incl   -0x14(%ebp)
  803062:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  803069:	76 c8                	jbe    803033 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  80306b:	90                   	nop
  80306c:	c9                   	leave  
  80306d:	c3                   	ret    

0080306e <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80306e:	55                   	push   %ebp
  80306f:	89 e5                	mov    %esp,%ebp
  803071:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  803074:	8b 55 08             	mov    0x8(%ebp),%edx
  803077:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80307c:	29 c2                	sub    %eax,%edx
  80307e:	89 d0                	mov    %edx,%eax
  803080:	c1 e8 0c             	shr    $0xc,%eax
  803083:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  803086:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803089:	89 d0                	mov    %edx,%eax
  80308b:	01 c0                	add    %eax,%eax
  80308d:	01 d0                	add    %edx,%eax
  80308f:	c1 e0 02             	shl    $0x2,%eax
  803092:	05 68 50 80 00       	add    $0x805068,%eax
  803097:	8b 00                	mov    (%eax),%eax
  803099:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  80309c:	c9                   	leave  
  80309d:	c3                   	ret    

0080309e <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  80309e:	55                   	push   %ebp
  80309f:	89 e5                	mov    %esp,%ebp
  8030a1:	83 ec 14             	sub    $0x14,%esp
  8030a4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  8030a7:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8030ab:	77 07                	ja     8030b4 <nearest_pow2_ceil.1513+0x16>
  8030ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8030b2:	eb 20                	jmp    8030d4 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  8030b4:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  8030bb:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  8030be:	eb 08                	jmp    8030c8 <nearest_pow2_ceil.1513+0x2a>
  8030c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030c3:	01 c0                	add    %eax,%eax
  8030c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8030c8:	d1 6d 08             	shrl   0x8(%ebp)
  8030cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030cf:	75 ef                	jne    8030c0 <nearest_pow2_ceil.1513+0x22>
        return power;
  8030d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  8030d4:	c9                   	leave  
  8030d5:	c3                   	ret    

008030d6 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8030d6:	55                   	push   %ebp
  8030d7:	89 e5                	mov    %esp,%ebp
  8030d9:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8030dc:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8030e3:	76 16                	jbe    8030fb <alloc_block+0x25>
  8030e5:	68 a4 4b 80 00       	push   $0x804ba4
  8030ea:	68 8e 4b 80 00       	push   $0x804b8e
  8030ef:	6a 72                	push   $0x72
  8030f1:	68 2b 4b 80 00       	push   $0x804b2b
  8030f6:	e8 46 d8 ff ff       	call   800941 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  8030fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ff:	75 0a                	jne    80310b <alloc_block+0x35>
  803101:	b8 00 00 00 00       	mov    $0x0,%eax
  803106:	e9 bd 04 00 00       	jmp    8035c8 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  80310b:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  803112:	8b 45 08             	mov    0x8(%ebp),%eax
  803115:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803118:	73 06                	jae    803120 <alloc_block+0x4a>
        size = min_block_size;
  80311a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80311d:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  803120:	83 ec 0c             	sub    $0xc,%esp
  803123:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803126:	ff 75 08             	pushl  0x8(%ebp)
  803129:	89 c1                	mov    %eax,%ecx
  80312b:	e8 6e ff ff ff       	call   80309e <nearest_pow2_ceil.1513>
  803130:	83 c4 10             	add    $0x10,%esp
  803133:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  803136:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803139:	83 ec 0c             	sub    $0xc,%esp
  80313c:	8d 45 cc             	lea    -0x34(%ebp),%eax
  80313f:	52                   	push   %edx
  803140:	89 c1                	mov    %eax,%ecx
  803142:	e8 83 04 00 00       	call   8035ca <log2_ceil.1520>
  803147:	83 c4 10             	add    $0x10,%esp
  80314a:	83 e8 03             	sub    $0x3,%eax
  80314d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  803150:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803153:	c1 e0 04             	shl    $0x4,%eax
  803156:	05 80 d0 81 00       	add    $0x81d080,%eax
  80315b:	8b 00                	mov    (%eax),%eax
  80315d:	85 c0                	test   %eax,%eax
  80315f:	0f 84 d8 00 00 00    	je     80323d <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803165:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803168:	c1 e0 04             	shl    $0x4,%eax
  80316b:	05 80 d0 81 00       	add    $0x81d080,%eax
  803170:	8b 00                	mov    (%eax),%eax
  803172:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803175:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803179:	75 17                	jne    803192 <alloc_block+0xbc>
  80317b:	83 ec 04             	sub    $0x4,%esp
  80317e:	68 c5 4b 80 00       	push   $0x804bc5
  803183:	68 98 00 00 00       	push   $0x98
  803188:	68 2b 4b 80 00       	push   $0x804b2b
  80318d:	e8 af d7 ff ff       	call   800941 <_panic>
  803192:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803195:	8b 00                	mov    (%eax),%eax
  803197:	85 c0                	test   %eax,%eax
  803199:	74 10                	je     8031ab <alloc_block+0xd5>
  80319b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80319e:	8b 00                	mov    (%eax),%eax
  8031a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031a3:	8b 52 04             	mov    0x4(%edx),%edx
  8031a6:	89 50 04             	mov    %edx,0x4(%eax)
  8031a9:	eb 14                	jmp    8031bf <alloc_block+0xe9>
  8031ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031ae:	8b 40 04             	mov    0x4(%eax),%eax
  8031b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031b4:	c1 e2 04             	shl    $0x4,%edx
  8031b7:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8031bd:	89 02                	mov    %eax,(%edx)
  8031bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031c2:	8b 40 04             	mov    0x4(%eax),%eax
  8031c5:	85 c0                	test   %eax,%eax
  8031c7:	74 0f                	je     8031d8 <alloc_block+0x102>
  8031c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031cc:	8b 40 04             	mov    0x4(%eax),%eax
  8031cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031d2:	8b 12                	mov    (%edx),%edx
  8031d4:	89 10                	mov    %edx,(%eax)
  8031d6:	eb 13                	jmp    8031eb <alloc_block+0x115>
  8031d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031db:	8b 00                	mov    (%eax),%eax
  8031dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031e0:	c1 e2 04             	shl    $0x4,%edx
  8031e3:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8031e9:	89 02                	mov    %eax,(%edx)
  8031eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803201:	c1 e0 04             	shl    $0x4,%eax
  803204:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803209:	8b 00                	mov    (%eax),%eax
  80320b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80320e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803211:	c1 e0 04             	shl    $0x4,%eax
  803214:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803219:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  80321b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80321e:	83 ec 0c             	sub    $0xc,%esp
  803221:	50                   	push   %eax
  803222:	e8 12 fc ff ff       	call   802e39 <to_page_info>
  803227:	83 c4 10             	add    $0x10,%esp
  80322a:	89 c2                	mov    %eax,%edx
  80322c:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803230:	48                   	dec    %eax
  803231:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  803235:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803238:	e9 8b 03 00 00       	jmp    8035c8 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  80323d:	a1 48 50 80 00       	mov    0x805048,%eax
  803242:	85 c0                	test   %eax,%eax
  803244:	0f 84 64 02 00 00    	je     8034ae <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  80324a:	a1 48 50 80 00       	mov    0x805048,%eax
  80324f:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  803252:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803256:	75 17                	jne    80326f <alloc_block+0x199>
  803258:	83 ec 04             	sub    $0x4,%esp
  80325b:	68 c5 4b 80 00       	push   $0x804bc5
  803260:	68 a0 00 00 00       	push   $0xa0
  803265:	68 2b 4b 80 00       	push   $0x804b2b
  80326a:	e8 d2 d6 ff ff       	call   800941 <_panic>
  80326f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803272:	8b 00                	mov    (%eax),%eax
  803274:	85 c0                	test   %eax,%eax
  803276:	74 10                	je     803288 <alloc_block+0x1b2>
  803278:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80327b:	8b 00                	mov    (%eax),%eax
  80327d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803280:	8b 52 04             	mov    0x4(%edx),%edx
  803283:	89 50 04             	mov    %edx,0x4(%eax)
  803286:	eb 0b                	jmp    803293 <alloc_block+0x1bd>
  803288:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80328b:	8b 40 04             	mov    0x4(%eax),%eax
  80328e:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803293:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803296:	8b 40 04             	mov    0x4(%eax),%eax
  803299:	85 c0                	test   %eax,%eax
  80329b:	74 0f                	je     8032ac <alloc_block+0x1d6>
  80329d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032a0:	8b 40 04             	mov    0x4(%eax),%eax
  8032a3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032a6:	8b 12                	mov    (%edx),%edx
  8032a8:	89 10                	mov    %edx,(%eax)
  8032aa:	eb 0a                	jmp    8032b6 <alloc_block+0x1e0>
  8032ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032af:	8b 00                	mov    (%eax),%eax
  8032b1:	a3 48 50 80 00       	mov    %eax,0x805048
  8032b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032c9:	a1 54 50 80 00       	mov    0x805054,%eax
  8032ce:	48                   	dec    %eax
  8032cf:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  8032d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032da:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  8032de:	b8 00 10 00 00       	mov    $0x1000,%eax
  8032e3:	99                   	cltd   
  8032e4:	f7 7d e8             	idivl  -0x18(%ebp)
  8032e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032ea:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  8032ee:	83 ec 0c             	sub    $0xc,%esp
  8032f1:	ff 75 dc             	pushl  -0x24(%ebp)
  8032f4:	e8 ce fa ff ff       	call   802dc7 <to_page_va>
  8032f9:	83 c4 10             	add    $0x10,%esp
  8032fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  8032ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803302:	83 ec 0c             	sub    $0xc,%esp
  803305:	50                   	push   %eax
  803306:	e8 c0 ee ff ff       	call   8021cb <get_page>
  80330b:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  80330e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803315:	e9 aa 00 00 00       	jmp    8033c4 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  80331a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331d:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  803321:	89 c2                	mov    %eax,%edx
  803323:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803326:	01 d0                	add    %edx,%eax
  803328:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  80332b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80332f:	75 17                	jne    803348 <alloc_block+0x272>
  803331:	83 ec 04             	sub    $0x4,%esp
  803334:	68 e4 4b 80 00       	push   $0x804be4
  803339:	68 aa 00 00 00       	push   $0xaa
  80333e:	68 2b 4b 80 00       	push   $0x804b2b
  803343:	e8 f9 d5 ff ff       	call   800941 <_panic>
  803348:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80334b:	c1 e0 04             	shl    $0x4,%eax
  80334e:	05 84 d0 81 00       	add    $0x81d084,%eax
  803353:	8b 10                	mov    (%eax),%edx
  803355:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803358:	89 50 04             	mov    %edx,0x4(%eax)
  80335b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80335e:	8b 40 04             	mov    0x4(%eax),%eax
  803361:	85 c0                	test   %eax,%eax
  803363:	74 14                	je     803379 <alloc_block+0x2a3>
  803365:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803368:	c1 e0 04             	shl    $0x4,%eax
  80336b:	05 84 d0 81 00       	add    $0x81d084,%eax
  803370:	8b 00                	mov    (%eax),%eax
  803372:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803375:	89 10                	mov    %edx,(%eax)
  803377:	eb 11                	jmp    80338a <alloc_block+0x2b4>
  803379:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80337c:	c1 e0 04             	shl    $0x4,%eax
  80337f:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803385:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803388:	89 02                	mov    %eax,(%edx)
  80338a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80338d:	c1 e0 04             	shl    $0x4,%eax
  803390:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803396:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803399:	89 02                	mov    %eax,(%edx)
  80339b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80339e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033a7:	c1 e0 04             	shl    $0x4,%eax
  8033aa:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8033af:	8b 00                	mov    (%eax),%eax
  8033b1:	8d 50 01             	lea    0x1(%eax),%edx
  8033b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033b7:	c1 e0 04             	shl    $0x4,%eax
  8033ba:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8033bf:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  8033c1:	ff 45 f4             	incl   -0xc(%ebp)
  8033c4:	b8 00 10 00 00       	mov    $0x1000,%eax
  8033c9:	99                   	cltd   
  8033ca:	f7 7d e8             	idivl  -0x18(%ebp)
  8033cd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8033d0:	0f 8f 44 ff ff ff    	jg     80331a <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  8033d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033d9:	c1 e0 04             	shl    $0x4,%eax
  8033dc:	05 80 d0 81 00       	add    $0x81d080,%eax
  8033e1:	8b 00                	mov    (%eax),%eax
  8033e3:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  8033e6:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8033ea:	75 17                	jne    803403 <alloc_block+0x32d>
  8033ec:	83 ec 04             	sub    $0x4,%esp
  8033ef:	68 c5 4b 80 00       	push   $0x804bc5
  8033f4:	68 ae 00 00 00       	push   $0xae
  8033f9:	68 2b 4b 80 00       	push   $0x804b2b
  8033fe:	e8 3e d5 ff ff       	call   800941 <_panic>
  803403:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803406:	8b 00                	mov    (%eax),%eax
  803408:	85 c0                	test   %eax,%eax
  80340a:	74 10                	je     80341c <alloc_block+0x346>
  80340c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80340f:	8b 00                	mov    (%eax),%eax
  803411:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803414:	8b 52 04             	mov    0x4(%edx),%edx
  803417:	89 50 04             	mov    %edx,0x4(%eax)
  80341a:	eb 14                	jmp    803430 <alloc_block+0x35a>
  80341c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80341f:	8b 40 04             	mov    0x4(%eax),%eax
  803422:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803425:	c1 e2 04             	shl    $0x4,%edx
  803428:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  80342e:	89 02                	mov    %eax,(%edx)
  803430:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803433:	8b 40 04             	mov    0x4(%eax),%eax
  803436:	85 c0                	test   %eax,%eax
  803438:	74 0f                	je     803449 <alloc_block+0x373>
  80343a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80343d:	8b 40 04             	mov    0x4(%eax),%eax
  803440:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803443:	8b 12                	mov    (%edx),%edx
  803445:	89 10                	mov    %edx,(%eax)
  803447:	eb 13                	jmp    80345c <alloc_block+0x386>
  803449:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80344c:	8b 00                	mov    (%eax),%eax
  80344e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803451:	c1 e2 04             	shl    $0x4,%edx
  803454:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  80345a:	89 02                	mov    %eax,(%edx)
  80345c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80345f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803465:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803468:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80346f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803472:	c1 e0 04             	shl    $0x4,%eax
  803475:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80347a:	8b 00                	mov    (%eax),%eax
  80347c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80347f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803482:	c1 e0 04             	shl    $0x4,%eax
  803485:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80348a:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  80348c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80348f:	83 ec 0c             	sub    $0xc,%esp
  803492:	50                   	push   %eax
  803493:	e8 a1 f9 ff ff       	call   802e39 <to_page_info>
  803498:	83 c4 10             	add    $0x10,%esp
  80349b:	89 c2                	mov    %eax,%edx
  80349d:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8034a1:	48                   	dec    %eax
  8034a2:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  8034a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034a9:	e9 1a 01 00 00       	jmp    8035c8 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  8034ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b1:	40                   	inc    %eax
  8034b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8034b5:	e9 ed 00 00 00       	jmp    8035a7 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  8034ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034bd:	c1 e0 04             	shl    $0x4,%eax
  8034c0:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034c5:	8b 00                	mov    (%eax),%eax
  8034c7:	85 c0                	test   %eax,%eax
  8034c9:	0f 84 d5 00 00 00    	je     8035a4 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  8034cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034d2:	c1 e0 04             	shl    $0x4,%eax
  8034d5:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034da:	8b 00                	mov    (%eax),%eax
  8034dc:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  8034df:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8034e3:	75 17                	jne    8034fc <alloc_block+0x426>
  8034e5:	83 ec 04             	sub    $0x4,%esp
  8034e8:	68 c5 4b 80 00       	push   $0x804bc5
  8034ed:	68 b8 00 00 00       	push   $0xb8
  8034f2:	68 2b 4b 80 00       	push   $0x804b2b
  8034f7:	e8 45 d4 ff ff       	call   800941 <_panic>
  8034fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8034ff:	8b 00                	mov    (%eax),%eax
  803501:	85 c0                	test   %eax,%eax
  803503:	74 10                	je     803515 <alloc_block+0x43f>
  803505:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803508:	8b 00                	mov    (%eax),%eax
  80350a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80350d:	8b 52 04             	mov    0x4(%edx),%edx
  803510:	89 50 04             	mov    %edx,0x4(%eax)
  803513:	eb 14                	jmp    803529 <alloc_block+0x453>
  803515:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803518:	8b 40 04             	mov    0x4(%eax),%eax
  80351b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80351e:	c1 e2 04             	shl    $0x4,%edx
  803521:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803527:	89 02                	mov    %eax,(%edx)
  803529:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80352c:	8b 40 04             	mov    0x4(%eax),%eax
  80352f:	85 c0                	test   %eax,%eax
  803531:	74 0f                	je     803542 <alloc_block+0x46c>
  803533:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803536:	8b 40 04             	mov    0x4(%eax),%eax
  803539:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80353c:	8b 12                	mov    (%edx),%edx
  80353e:	89 10                	mov    %edx,(%eax)
  803540:	eb 13                	jmp    803555 <alloc_block+0x47f>
  803542:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803545:	8b 00                	mov    (%eax),%eax
  803547:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80354a:	c1 e2 04             	shl    $0x4,%edx
  80354d:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803553:	89 02                	mov    %eax,(%edx)
  803555:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803558:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80355e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803561:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803568:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80356b:	c1 e0 04             	shl    $0x4,%eax
  80356e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803573:	8b 00                	mov    (%eax),%eax
  803575:	8d 50 ff             	lea    -0x1(%eax),%edx
  803578:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80357b:	c1 e0 04             	shl    $0x4,%eax
  80357e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803583:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  803585:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803588:	83 ec 0c             	sub    $0xc,%esp
  80358b:	50                   	push   %eax
  80358c:	e8 a8 f8 ff ff       	call   802e39 <to_page_info>
  803591:	83 c4 10             	add    $0x10,%esp
  803594:	89 c2                	mov    %eax,%edx
  803596:	66 8b 42 0a          	mov    0xa(%edx),%ax
  80359a:	48                   	dec    %eax
  80359b:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  80359f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8035a2:	eb 24                	jmp    8035c8 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  8035a4:	ff 45 f0             	incl   -0x10(%ebp)
  8035a7:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8035ab:	0f 8e 09 ff ff ff    	jle    8034ba <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  8035b1:	83 ec 04             	sub    $0x4,%esp
  8035b4:	68 07 4c 80 00       	push   $0x804c07
  8035b9:	68 bf 00 00 00       	push   $0xbf
  8035be:	68 2b 4b 80 00       	push   $0x804b2b
  8035c3:	e8 79 d3 ff ff       	call   800941 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  8035c8:	c9                   	leave  
  8035c9:	c3                   	ret    

008035ca <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  8035ca:	55                   	push   %ebp
  8035cb:	89 e5                	mov    %esp,%ebp
  8035cd:	83 ec 14             	sub    $0x14,%esp
  8035d0:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  8035d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035d7:	75 07                	jne    8035e0 <log2_ceil.1520+0x16>
  8035d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8035de:	eb 1b                	jmp    8035fb <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  8035e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  8035e7:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  8035ea:	eb 06                	jmp    8035f2 <log2_ceil.1520+0x28>
            x >>= 1;
  8035ec:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  8035ef:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  8035f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035f6:	75 f4                	jne    8035ec <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  8035f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  8035fb:	c9                   	leave  
  8035fc:	c3                   	ret    

008035fd <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  8035fd:	55                   	push   %ebp
  8035fe:	89 e5                	mov    %esp,%ebp
  803600:	83 ec 14             	sub    $0x14,%esp
  803603:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  803606:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80360a:	75 07                	jne    803613 <log2_ceil.1547+0x16>
  80360c:	b8 00 00 00 00       	mov    $0x0,%eax
  803611:	eb 1b                	jmp    80362e <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  803613:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  80361a:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  80361d:	eb 06                	jmp    803625 <log2_ceil.1547+0x28>
			x >>= 1;
  80361f:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  803622:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  803625:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803629:	75 f4                	jne    80361f <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  80362b:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  80362e:	c9                   	leave  
  80362f:	c3                   	ret    

00803630 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803630:	55                   	push   %ebp
  803631:	89 e5                	mov    %esp,%ebp
  803633:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803636:	8b 55 08             	mov    0x8(%ebp),%edx
  803639:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80363e:	39 c2                	cmp    %eax,%edx
  803640:	72 0c                	jb     80364e <free_block+0x1e>
  803642:	8b 55 08             	mov    0x8(%ebp),%edx
  803645:	a1 40 50 80 00       	mov    0x805040,%eax
  80364a:	39 c2                	cmp    %eax,%edx
  80364c:	72 19                	jb     803667 <free_block+0x37>
  80364e:	68 0c 4c 80 00       	push   $0x804c0c
  803653:	68 8e 4b 80 00       	push   $0x804b8e
  803658:	68 d0 00 00 00       	push   $0xd0
  80365d:	68 2b 4b 80 00       	push   $0x804b2b
  803662:	e8 da d2 ff ff       	call   800941 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803667:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80366b:	0f 84 42 03 00 00    	je     8039b3 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  803671:	8b 55 08             	mov    0x8(%ebp),%edx
  803674:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803679:	39 c2                	cmp    %eax,%edx
  80367b:	72 0c                	jb     803689 <free_block+0x59>
  80367d:	8b 55 08             	mov    0x8(%ebp),%edx
  803680:	a1 40 50 80 00       	mov    0x805040,%eax
  803685:	39 c2                	cmp    %eax,%edx
  803687:	72 17                	jb     8036a0 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  803689:	83 ec 04             	sub    $0x4,%esp
  80368c:	68 44 4c 80 00       	push   $0x804c44
  803691:	68 e6 00 00 00       	push   $0xe6
  803696:	68 2b 4b 80 00       	push   $0x804b2b
  80369b:	e8 a1 d2 ff ff       	call   800941 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  8036a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8036a3:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8036a8:	29 c2                	sub    %eax,%edx
  8036aa:	89 d0                	mov    %edx,%eax
  8036ac:	83 e0 07             	and    $0x7,%eax
  8036af:	85 c0                	test   %eax,%eax
  8036b1:	74 17                	je     8036ca <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  8036b3:	83 ec 04             	sub    $0x4,%esp
  8036b6:	68 78 4c 80 00       	push   $0x804c78
  8036bb:	68 ea 00 00 00       	push   $0xea
  8036c0:	68 2b 4b 80 00       	push   $0x804b2b
  8036c5:	e8 77 d2 ff ff       	call   800941 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  8036ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cd:	83 ec 0c             	sub    $0xc,%esp
  8036d0:	50                   	push   %eax
  8036d1:	e8 63 f7 ff ff       	call   802e39 <to_page_info>
  8036d6:	83 c4 10             	add    $0x10,%esp
  8036d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  8036dc:	83 ec 0c             	sub    $0xc,%esp
  8036df:	ff 75 08             	pushl  0x8(%ebp)
  8036e2:	e8 87 f9 ff ff       	call   80306e <get_block_size>
  8036e7:	83 c4 10             	add    $0x10,%esp
  8036ea:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  8036ed:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036f1:	75 17                	jne    80370a <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  8036f3:	83 ec 04             	sub    $0x4,%esp
  8036f6:	68 a4 4c 80 00       	push   $0x804ca4
  8036fb:	68 f1 00 00 00       	push   $0xf1
  803700:	68 2b 4b 80 00       	push   $0x804b2b
  803705:	e8 37 d2 ff ff       	call   800941 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  80370a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80370d:	83 ec 0c             	sub    $0xc,%esp
  803710:	8d 45 d0             	lea    -0x30(%ebp),%eax
  803713:	52                   	push   %edx
  803714:	89 c1                	mov    %eax,%ecx
  803716:	e8 e2 fe ff ff       	call   8035fd <log2_ceil.1547>
  80371b:	83 c4 10             	add    $0x10,%esp
  80371e:	83 e8 03             	sub    $0x3,%eax
  803721:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  803724:	8b 45 08             	mov    0x8(%ebp),%eax
  803727:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  80372a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80372e:	75 17                	jne    803747 <free_block+0x117>
  803730:	83 ec 04             	sub    $0x4,%esp
  803733:	68 f0 4c 80 00       	push   $0x804cf0
  803738:	68 f6 00 00 00       	push   $0xf6
  80373d:	68 2b 4b 80 00       	push   $0x804b2b
  803742:	e8 fa d1 ff ff       	call   800941 <_panic>
  803747:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80374a:	c1 e0 04             	shl    $0x4,%eax
  80374d:	05 80 d0 81 00       	add    $0x81d080,%eax
  803752:	8b 10                	mov    (%eax),%edx
  803754:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803757:	89 10                	mov    %edx,(%eax)
  803759:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80375c:	8b 00                	mov    (%eax),%eax
  80375e:	85 c0                	test   %eax,%eax
  803760:	74 15                	je     803777 <free_block+0x147>
  803762:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803765:	c1 e0 04             	shl    $0x4,%eax
  803768:	05 80 d0 81 00       	add    $0x81d080,%eax
  80376d:	8b 00                	mov    (%eax),%eax
  80376f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803772:	89 50 04             	mov    %edx,0x4(%eax)
  803775:	eb 11                	jmp    803788 <free_block+0x158>
  803777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80377a:	c1 e0 04             	shl    $0x4,%eax
  80377d:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803783:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803786:	89 02                	mov    %eax,(%edx)
  803788:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80378b:	c1 e0 04             	shl    $0x4,%eax
  80378e:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803794:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803797:	89 02                	mov    %eax,(%edx)
  803799:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80379c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a6:	c1 e0 04             	shl    $0x4,%eax
  8037a9:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8037ae:	8b 00                	mov    (%eax),%eax
  8037b0:	8d 50 01             	lea    0x1(%eax),%edx
  8037b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b6:	c1 e0 04             	shl    $0x4,%eax
  8037b9:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8037be:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  8037c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037c3:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8037c7:	40                   	inc    %eax
  8037c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037cb:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  8037cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8037d2:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8037d7:	29 c2                	sub    %eax,%edx
  8037d9:	89 d0                	mov    %edx,%eax
  8037db:	c1 e8 0c             	shr    $0xc,%eax
  8037de:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  8037e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037e4:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8037e8:	0f b7 c8             	movzwl %ax,%ecx
  8037eb:	b8 00 10 00 00       	mov    $0x1000,%eax
  8037f0:	99                   	cltd   
  8037f1:	f7 7d e8             	idivl  -0x18(%ebp)
  8037f4:	39 c1                	cmp    %eax,%ecx
  8037f6:	0f 85 b8 01 00 00    	jne    8039b4 <free_block+0x384>
    	uint32 blocks_removed = 0;
  8037fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  803803:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803806:	c1 e0 04             	shl    $0x4,%eax
  803809:	05 80 d0 81 00       	add    $0x81d080,%eax
  80380e:	8b 00                	mov    (%eax),%eax
  803810:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803813:	e9 d5 00 00 00       	jmp    8038ed <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  803818:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80381b:	8b 00                	mov    (%eax),%eax
  80381d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  803820:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803823:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803828:	29 c2                	sub    %eax,%edx
  80382a:	89 d0                	mov    %edx,%eax
  80382c:	c1 e8 0c             	shr    $0xc,%eax
  80382f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  803832:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803835:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803838:	0f 85 a9 00 00 00    	jne    8038e7 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  80383e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803842:	75 17                	jne    80385b <free_block+0x22b>
  803844:	83 ec 04             	sub    $0x4,%esp
  803847:	68 c5 4b 80 00       	push   $0x804bc5
  80384c:	68 04 01 00 00       	push   $0x104
  803851:	68 2b 4b 80 00       	push   $0x804b2b
  803856:	e8 e6 d0 ff ff       	call   800941 <_panic>
  80385b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80385e:	8b 00                	mov    (%eax),%eax
  803860:	85 c0                	test   %eax,%eax
  803862:	74 10                	je     803874 <free_block+0x244>
  803864:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803867:	8b 00                	mov    (%eax),%eax
  803869:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80386c:	8b 52 04             	mov    0x4(%edx),%edx
  80386f:	89 50 04             	mov    %edx,0x4(%eax)
  803872:	eb 14                	jmp    803888 <free_block+0x258>
  803874:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803877:	8b 40 04             	mov    0x4(%eax),%eax
  80387a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80387d:	c1 e2 04             	shl    $0x4,%edx
  803880:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803886:	89 02                	mov    %eax,(%edx)
  803888:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80388b:	8b 40 04             	mov    0x4(%eax),%eax
  80388e:	85 c0                	test   %eax,%eax
  803890:	74 0f                	je     8038a1 <free_block+0x271>
  803892:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803895:	8b 40 04             	mov    0x4(%eax),%eax
  803898:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80389b:	8b 12                	mov    (%edx),%edx
  80389d:	89 10                	mov    %edx,(%eax)
  80389f:	eb 13                	jmp    8038b4 <free_block+0x284>
  8038a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038a4:	8b 00                	mov    (%eax),%eax
  8038a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038a9:	c1 e2 04             	shl    $0x4,%edx
  8038ac:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8038b2:	89 02                	mov    %eax,(%edx)
  8038b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ca:	c1 e0 04             	shl    $0x4,%eax
  8038cd:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8038d2:	8b 00                	mov    (%eax),%eax
  8038d4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8038d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038da:	c1 e0 04             	shl    $0x4,%eax
  8038dd:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8038e2:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  8038e4:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  8038e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8038ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8038ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038f1:	0f 85 21 ff ff ff    	jne    803818 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  8038f7:	b8 00 10 00 00       	mov    $0x1000,%eax
  8038fc:	99                   	cltd   
  8038fd:	f7 7d e8             	idivl  -0x18(%ebp)
  803900:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803903:	74 17                	je     80391c <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  803905:	83 ec 04             	sub    $0x4,%esp
  803908:	68 14 4d 80 00       	push   $0x804d14
  80390d:	68 0c 01 00 00       	push   $0x10c
  803912:	68 2b 4b 80 00       	push   $0x804b2b
  803917:	e8 25 d0 ff ff       	call   800941 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  80391c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80391f:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  803925:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803928:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  80392e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803932:	75 17                	jne    80394b <free_block+0x31b>
  803934:	83 ec 04             	sub    $0x4,%esp
  803937:	68 e4 4b 80 00       	push   $0x804be4
  80393c:	68 11 01 00 00       	push   $0x111
  803941:	68 2b 4b 80 00       	push   $0x804b2b
  803946:	e8 f6 cf ff ff       	call   800941 <_panic>
  80394b:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803951:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803954:	89 50 04             	mov    %edx,0x4(%eax)
  803957:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80395a:	8b 40 04             	mov    0x4(%eax),%eax
  80395d:	85 c0                	test   %eax,%eax
  80395f:	74 0c                	je     80396d <free_block+0x33d>
  803961:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803966:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803969:	89 10                	mov    %edx,(%eax)
  80396b:	eb 08                	jmp    803975 <free_block+0x345>
  80396d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803970:	a3 48 50 80 00       	mov    %eax,0x805048
  803975:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803978:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80397d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803980:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803986:	a1 54 50 80 00       	mov    0x805054,%eax
  80398b:	40                   	inc    %eax
  80398c:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  803991:	83 ec 0c             	sub    $0xc,%esp
  803994:	ff 75 ec             	pushl  -0x14(%ebp)
  803997:	e8 2b f4 ff ff       	call   802dc7 <to_page_va>
  80399c:	83 c4 10             	add    $0x10,%esp
  80399f:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  8039a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039a5:	83 ec 0c             	sub    $0xc,%esp
  8039a8:	50                   	push   %eax
  8039a9:	e8 69 e8 ff ff       	call   802217 <return_page>
  8039ae:	83 c4 10             	add    $0x10,%esp
  8039b1:	eb 01                	jmp    8039b4 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8039b3:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8039b4:	c9                   	leave  
  8039b5:	c3                   	ret    

008039b6 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  8039b6:	55                   	push   %ebp
  8039b7:	89 e5                	mov    %esp,%ebp
  8039b9:	83 ec 14             	sub    $0x14,%esp
  8039bc:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  8039bf:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8039c3:	77 07                	ja     8039cc <nearest_pow2_ceil.1572+0x16>
      return 1;
  8039c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8039ca:	eb 20                	jmp    8039ec <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  8039cc:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  8039d3:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  8039d6:	eb 08                	jmp    8039e0 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  8039d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8039db:	01 c0                	add    %eax,%eax
  8039dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  8039e0:	d1 6d 08             	shrl   0x8(%ebp)
  8039e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039e7:	75 ef                	jne    8039d8 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  8039e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  8039ec:	c9                   	leave  
  8039ed:	c3                   	ret    

008039ee <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  8039ee:	55                   	push   %ebp
  8039ef:	89 e5                	mov    %esp,%ebp
  8039f1:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  8039f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039f8:	75 13                	jne    803a0d <realloc_block+0x1f>
    return alloc_block(new_size);
  8039fa:	83 ec 0c             	sub    $0xc,%esp
  8039fd:	ff 75 0c             	pushl  0xc(%ebp)
  803a00:	e8 d1 f6 ff ff       	call   8030d6 <alloc_block>
  803a05:	83 c4 10             	add    $0x10,%esp
  803a08:	e9 d9 00 00 00       	jmp    803ae6 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  803a0d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a11:	75 18                	jne    803a2b <realloc_block+0x3d>
    free_block(va);
  803a13:	83 ec 0c             	sub    $0xc,%esp
  803a16:	ff 75 08             	pushl  0x8(%ebp)
  803a19:	e8 12 fc ff ff       	call   803630 <free_block>
  803a1e:	83 c4 10             	add    $0x10,%esp
    return NULL;
  803a21:	b8 00 00 00 00       	mov    $0x0,%eax
  803a26:	e9 bb 00 00 00       	jmp    803ae6 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  803a2b:	83 ec 0c             	sub    $0xc,%esp
  803a2e:	ff 75 08             	pushl  0x8(%ebp)
  803a31:	e8 38 f6 ff ff       	call   80306e <get_block_size>
  803a36:	83 c4 10             	add    $0x10,%esp
  803a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803a3c:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  803a43:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a46:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803a49:	73 06                	jae    803a51 <realloc_block+0x63>
    new_size = min_block_size;
  803a4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a4e:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  803a51:	83 ec 0c             	sub    $0xc,%esp
  803a54:	8d 45 d8             	lea    -0x28(%ebp),%eax
  803a57:	ff 75 0c             	pushl  0xc(%ebp)
  803a5a:	89 c1                	mov    %eax,%ecx
  803a5c:	e8 55 ff ff ff       	call   8039b6 <nearest_pow2_ceil.1572>
  803a61:	83 c4 10             	add    $0x10,%esp
  803a64:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  803a67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a6a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803a6d:	75 05                	jne    803a74 <realloc_block+0x86>
    return va;
  803a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a72:	eb 72                	jmp    803ae6 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  803a74:	83 ec 0c             	sub    $0xc,%esp
  803a77:	ff 75 0c             	pushl  0xc(%ebp)
  803a7a:	e8 57 f6 ff ff       	call   8030d6 <alloc_block>
  803a7f:	83 c4 10             	add    $0x10,%esp
  803a82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  803a85:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a89:	75 07                	jne    803a92 <realloc_block+0xa4>
    return NULL;
  803a8b:	b8 00 00 00 00       	mov    $0x0,%eax
  803a90:	eb 54                	jmp    803ae6 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  803a92:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a95:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a98:	39 d0                	cmp    %edx,%eax
  803a9a:	76 02                	jbe    803a9e <realloc_block+0xb0>
  803a9c:	89 d0                	mov    %edx,%eax
  803a9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  803aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  803aa7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aaa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  803aad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803ab4:	eb 17                	jmp    803acd <realloc_block+0xdf>
    dst[i] = src[i];
  803ab6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803abc:	01 c2                	add    %eax,%edx
  803abe:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  803ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac4:	01 c8                	add    %ecx,%eax
  803ac6:	8a 00                	mov    (%eax),%al
  803ac8:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  803aca:	ff 45 f4             	incl   -0xc(%ebp)
  803acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803ad3:	72 e1                	jb     803ab6 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  803ad5:	83 ec 0c             	sub    $0xc,%esp
  803ad8:	ff 75 08             	pushl  0x8(%ebp)
  803adb:	e8 50 fb ff ff       	call   803630 <free_block>
  803ae0:	83 c4 10             	add    $0x10,%esp

  return new_va;
  803ae3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  803ae6:	c9                   	leave  
  803ae7:	c3                   	ret    

00803ae8 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803ae8:	55                   	push   %ebp
  803ae9:	89 e5                	mov    %esp,%ebp
  803aeb:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  803aee:	83 ec 04             	sub    $0x4,%esp
  803af1:	68 48 4d 80 00       	push   $0x804d48
  803af6:	6a 07                	push   $0x7
  803af8:	68 77 4d 80 00       	push   $0x804d77
  803afd:	e8 3f ce ff ff       	call   800941 <_panic>

00803b02 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803b02:	55                   	push   %ebp
  803b03:	89 e5                	mov    %esp,%ebp
  803b05:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  803b08:	83 ec 04             	sub    $0x4,%esp
  803b0b:	68 88 4d 80 00       	push   $0x804d88
  803b10:	6a 0b                	push   $0xb
  803b12:	68 77 4d 80 00       	push   $0x804d77
  803b17:	e8 25 ce ff ff       	call   800941 <_panic>

00803b1c <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  803b1c:	55                   	push   %ebp
  803b1d:	89 e5                	mov    %esp,%ebp
  803b1f:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  803b22:	83 ec 04             	sub    $0x4,%esp
  803b25:	68 b4 4d 80 00       	push   $0x804db4
  803b2a:	6a 10                	push   $0x10
  803b2c:	68 77 4d 80 00       	push   $0x804d77
  803b31:	e8 0b ce ff ff       	call   800941 <_panic>

00803b36 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  803b36:	55                   	push   %ebp
  803b37:	89 e5                	mov    %esp,%ebp
  803b39:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  803b3c:	83 ec 04             	sub    $0x4,%esp
  803b3f:	68 e4 4d 80 00       	push   $0x804de4
  803b44:	6a 15                	push   $0x15
  803b46:	68 77 4d 80 00       	push   $0x804d77
  803b4b:	e8 f1 cd ff ff       	call   800941 <_panic>

00803b50 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  803b50:	55                   	push   %ebp
  803b51:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803b53:	8b 45 08             	mov    0x8(%ebp),%eax
  803b56:	8b 40 10             	mov    0x10(%eax),%eax
}
  803b59:	5d                   	pop    %ebp
  803b5a:	c3                   	ret    
  803b5b:	90                   	nop

00803b5c <__udivdi3>:
  803b5c:	55                   	push   %ebp
  803b5d:	57                   	push   %edi
  803b5e:	56                   	push   %esi
  803b5f:	53                   	push   %ebx
  803b60:	83 ec 1c             	sub    $0x1c,%esp
  803b63:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b67:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b6f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b73:	89 ca                	mov    %ecx,%edx
  803b75:	89 f8                	mov    %edi,%eax
  803b77:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b7b:	85 f6                	test   %esi,%esi
  803b7d:	75 2d                	jne    803bac <__udivdi3+0x50>
  803b7f:	39 cf                	cmp    %ecx,%edi
  803b81:	77 65                	ja     803be8 <__udivdi3+0x8c>
  803b83:	89 fd                	mov    %edi,%ebp
  803b85:	85 ff                	test   %edi,%edi
  803b87:	75 0b                	jne    803b94 <__udivdi3+0x38>
  803b89:	b8 01 00 00 00       	mov    $0x1,%eax
  803b8e:	31 d2                	xor    %edx,%edx
  803b90:	f7 f7                	div    %edi
  803b92:	89 c5                	mov    %eax,%ebp
  803b94:	31 d2                	xor    %edx,%edx
  803b96:	89 c8                	mov    %ecx,%eax
  803b98:	f7 f5                	div    %ebp
  803b9a:	89 c1                	mov    %eax,%ecx
  803b9c:	89 d8                	mov    %ebx,%eax
  803b9e:	f7 f5                	div    %ebp
  803ba0:	89 cf                	mov    %ecx,%edi
  803ba2:	89 fa                	mov    %edi,%edx
  803ba4:	83 c4 1c             	add    $0x1c,%esp
  803ba7:	5b                   	pop    %ebx
  803ba8:	5e                   	pop    %esi
  803ba9:	5f                   	pop    %edi
  803baa:	5d                   	pop    %ebp
  803bab:	c3                   	ret    
  803bac:	39 ce                	cmp    %ecx,%esi
  803bae:	77 28                	ja     803bd8 <__udivdi3+0x7c>
  803bb0:	0f bd fe             	bsr    %esi,%edi
  803bb3:	83 f7 1f             	xor    $0x1f,%edi
  803bb6:	75 40                	jne    803bf8 <__udivdi3+0x9c>
  803bb8:	39 ce                	cmp    %ecx,%esi
  803bba:	72 0a                	jb     803bc6 <__udivdi3+0x6a>
  803bbc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bc0:	0f 87 9e 00 00 00    	ja     803c64 <__udivdi3+0x108>
  803bc6:	b8 01 00 00 00       	mov    $0x1,%eax
  803bcb:	89 fa                	mov    %edi,%edx
  803bcd:	83 c4 1c             	add    $0x1c,%esp
  803bd0:	5b                   	pop    %ebx
  803bd1:	5e                   	pop    %esi
  803bd2:	5f                   	pop    %edi
  803bd3:	5d                   	pop    %ebp
  803bd4:	c3                   	ret    
  803bd5:	8d 76 00             	lea    0x0(%esi),%esi
  803bd8:	31 ff                	xor    %edi,%edi
  803bda:	31 c0                	xor    %eax,%eax
  803bdc:	89 fa                	mov    %edi,%edx
  803bde:	83 c4 1c             	add    $0x1c,%esp
  803be1:	5b                   	pop    %ebx
  803be2:	5e                   	pop    %esi
  803be3:	5f                   	pop    %edi
  803be4:	5d                   	pop    %ebp
  803be5:	c3                   	ret    
  803be6:	66 90                	xchg   %ax,%ax
  803be8:	89 d8                	mov    %ebx,%eax
  803bea:	f7 f7                	div    %edi
  803bec:	31 ff                	xor    %edi,%edi
  803bee:	89 fa                	mov    %edi,%edx
  803bf0:	83 c4 1c             	add    $0x1c,%esp
  803bf3:	5b                   	pop    %ebx
  803bf4:	5e                   	pop    %esi
  803bf5:	5f                   	pop    %edi
  803bf6:	5d                   	pop    %ebp
  803bf7:	c3                   	ret    
  803bf8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803bfd:	89 eb                	mov    %ebp,%ebx
  803bff:	29 fb                	sub    %edi,%ebx
  803c01:	89 f9                	mov    %edi,%ecx
  803c03:	d3 e6                	shl    %cl,%esi
  803c05:	89 c5                	mov    %eax,%ebp
  803c07:	88 d9                	mov    %bl,%cl
  803c09:	d3 ed                	shr    %cl,%ebp
  803c0b:	89 e9                	mov    %ebp,%ecx
  803c0d:	09 f1                	or     %esi,%ecx
  803c0f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c13:	89 f9                	mov    %edi,%ecx
  803c15:	d3 e0                	shl    %cl,%eax
  803c17:	89 c5                	mov    %eax,%ebp
  803c19:	89 d6                	mov    %edx,%esi
  803c1b:	88 d9                	mov    %bl,%cl
  803c1d:	d3 ee                	shr    %cl,%esi
  803c1f:	89 f9                	mov    %edi,%ecx
  803c21:	d3 e2                	shl    %cl,%edx
  803c23:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c27:	88 d9                	mov    %bl,%cl
  803c29:	d3 e8                	shr    %cl,%eax
  803c2b:	09 c2                	or     %eax,%edx
  803c2d:	89 d0                	mov    %edx,%eax
  803c2f:	89 f2                	mov    %esi,%edx
  803c31:	f7 74 24 0c          	divl   0xc(%esp)
  803c35:	89 d6                	mov    %edx,%esi
  803c37:	89 c3                	mov    %eax,%ebx
  803c39:	f7 e5                	mul    %ebp
  803c3b:	39 d6                	cmp    %edx,%esi
  803c3d:	72 19                	jb     803c58 <__udivdi3+0xfc>
  803c3f:	74 0b                	je     803c4c <__udivdi3+0xf0>
  803c41:	89 d8                	mov    %ebx,%eax
  803c43:	31 ff                	xor    %edi,%edi
  803c45:	e9 58 ff ff ff       	jmp    803ba2 <__udivdi3+0x46>
  803c4a:	66 90                	xchg   %ax,%ax
  803c4c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c50:	89 f9                	mov    %edi,%ecx
  803c52:	d3 e2                	shl    %cl,%edx
  803c54:	39 c2                	cmp    %eax,%edx
  803c56:	73 e9                	jae    803c41 <__udivdi3+0xe5>
  803c58:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c5b:	31 ff                	xor    %edi,%edi
  803c5d:	e9 40 ff ff ff       	jmp    803ba2 <__udivdi3+0x46>
  803c62:	66 90                	xchg   %ax,%ax
  803c64:	31 c0                	xor    %eax,%eax
  803c66:	e9 37 ff ff ff       	jmp    803ba2 <__udivdi3+0x46>
  803c6b:	90                   	nop

00803c6c <__umoddi3>:
  803c6c:	55                   	push   %ebp
  803c6d:	57                   	push   %edi
  803c6e:	56                   	push   %esi
  803c6f:	53                   	push   %ebx
  803c70:	83 ec 1c             	sub    $0x1c,%esp
  803c73:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c77:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c7f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c8b:	89 f3                	mov    %esi,%ebx
  803c8d:	89 fa                	mov    %edi,%edx
  803c8f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c93:	89 34 24             	mov    %esi,(%esp)
  803c96:	85 c0                	test   %eax,%eax
  803c98:	75 1a                	jne    803cb4 <__umoddi3+0x48>
  803c9a:	39 f7                	cmp    %esi,%edi
  803c9c:	0f 86 a2 00 00 00    	jbe    803d44 <__umoddi3+0xd8>
  803ca2:	89 c8                	mov    %ecx,%eax
  803ca4:	89 f2                	mov    %esi,%edx
  803ca6:	f7 f7                	div    %edi
  803ca8:	89 d0                	mov    %edx,%eax
  803caa:	31 d2                	xor    %edx,%edx
  803cac:	83 c4 1c             	add    $0x1c,%esp
  803caf:	5b                   	pop    %ebx
  803cb0:	5e                   	pop    %esi
  803cb1:	5f                   	pop    %edi
  803cb2:	5d                   	pop    %ebp
  803cb3:	c3                   	ret    
  803cb4:	39 f0                	cmp    %esi,%eax
  803cb6:	0f 87 ac 00 00 00    	ja     803d68 <__umoddi3+0xfc>
  803cbc:	0f bd e8             	bsr    %eax,%ebp
  803cbf:	83 f5 1f             	xor    $0x1f,%ebp
  803cc2:	0f 84 ac 00 00 00    	je     803d74 <__umoddi3+0x108>
  803cc8:	bf 20 00 00 00       	mov    $0x20,%edi
  803ccd:	29 ef                	sub    %ebp,%edi
  803ccf:	89 fe                	mov    %edi,%esi
  803cd1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803cd5:	89 e9                	mov    %ebp,%ecx
  803cd7:	d3 e0                	shl    %cl,%eax
  803cd9:	89 d7                	mov    %edx,%edi
  803cdb:	89 f1                	mov    %esi,%ecx
  803cdd:	d3 ef                	shr    %cl,%edi
  803cdf:	09 c7                	or     %eax,%edi
  803ce1:	89 e9                	mov    %ebp,%ecx
  803ce3:	d3 e2                	shl    %cl,%edx
  803ce5:	89 14 24             	mov    %edx,(%esp)
  803ce8:	89 d8                	mov    %ebx,%eax
  803cea:	d3 e0                	shl    %cl,%eax
  803cec:	89 c2                	mov    %eax,%edx
  803cee:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cf2:	d3 e0                	shl    %cl,%eax
  803cf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cf8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cfc:	89 f1                	mov    %esi,%ecx
  803cfe:	d3 e8                	shr    %cl,%eax
  803d00:	09 d0                	or     %edx,%eax
  803d02:	d3 eb                	shr    %cl,%ebx
  803d04:	89 da                	mov    %ebx,%edx
  803d06:	f7 f7                	div    %edi
  803d08:	89 d3                	mov    %edx,%ebx
  803d0a:	f7 24 24             	mull   (%esp)
  803d0d:	89 c6                	mov    %eax,%esi
  803d0f:	89 d1                	mov    %edx,%ecx
  803d11:	39 d3                	cmp    %edx,%ebx
  803d13:	0f 82 87 00 00 00    	jb     803da0 <__umoddi3+0x134>
  803d19:	0f 84 91 00 00 00    	je     803db0 <__umoddi3+0x144>
  803d1f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d23:	29 f2                	sub    %esi,%edx
  803d25:	19 cb                	sbb    %ecx,%ebx
  803d27:	89 d8                	mov    %ebx,%eax
  803d29:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d2d:	d3 e0                	shl    %cl,%eax
  803d2f:	89 e9                	mov    %ebp,%ecx
  803d31:	d3 ea                	shr    %cl,%edx
  803d33:	09 d0                	or     %edx,%eax
  803d35:	89 e9                	mov    %ebp,%ecx
  803d37:	d3 eb                	shr    %cl,%ebx
  803d39:	89 da                	mov    %ebx,%edx
  803d3b:	83 c4 1c             	add    $0x1c,%esp
  803d3e:	5b                   	pop    %ebx
  803d3f:	5e                   	pop    %esi
  803d40:	5f                   	pop    %edi
  803d41:	5d                   	pop    %ebp
  803d42:	c3                   	ret    
  803d43:	90                   	nop
  803d44:	89 fd                	mov    %edi,%ebp
  803d46:	85 ff                	test   %edi,%edi
  803d48:	75 0b                	jne    803d55 <__umoddi3+0xe9>
  803d4a:	b8 01 00 00 00       	mov    $0x1,%eax
  803d4f:	31 d2                	xor    %edx,%edx
  803d51:	f7 f7                	div    %edi
  803d53:	89 c5                	mov    %eax,%ebp
  803d55:	89 f0                	mov    %esi,%eax
  803d57:	31 d2                	xor    %edx,%edx
  803d59:	f7 f5                	div    %ebp
  803d5b:	89 c8                	mov    %ecx,%eax
  803d5d:	f7 f5                	div    %ebp
  803d5f:	89 d0                	mov    %edx,%eax
  803d61:	e9 44 ff ff ff       	jmp    803caa <__umoddi3+0x3e>
  803d66:	66 90                	xchg   %ax,%ax
  803d68:	89 c8                	mov    %ecx,%eax
  803d6a:	89 f2                	mov    %esi,%edx
  803d6c:	83 c4 1c             	add    $0x1c,%esp
  803d6f:	5b                   	pop    %ebx
  803d70:	5e                   	pop    %esi
  803d71:	5f                   	pop    %edi
  803d72:	5d                   	pop    %ebp
  803d73:	c3                   	ret    
  803d74:	3b 04 24             	cmp    (%esp),%eax
  803d77:	72 06                	jb     803d7f <__umoddi3+0x113>
  803d79:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d7d:	77 0f                	ja     803d8e <__umoddi3+0x122>
  803d7f:	89 f2                	mov    %esi,%edx
  803d81:	29 f9                	sub    %edi,%ecx
  803d83:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d87:	89 14 24             	mov    %edx,(%esp)
  803d8a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d8e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d92:	8b 14 24             	mov    (%esp),%edx
  803d95:	83 c4 1c             	add    $0x1c,%esp
  803d98:	5b                   	pop    %ebx
  803d99:	5e                   	pop    %esi
  803d9a:	5f                   	pop    %edi
  803d9b:	5d                   	pop    %ebp
  803d9c:	c3                   	ret    
  803d9d:	8d 76 00             	lea    0x0(%esi),%esi
  803da0:	2b 04 24             	sub    (%esp),%eax
  803da3:	19 fa                	sbb    %edi,%edx
  803da5:	89 d1                	mov    %edx,%ecx
  803da7:	89 c6                	mov    %eax,%esi
  803da9:	e9 71 ff ff ff       	jmp    803d1f <__umoddi3+0xb3>
  803dae:	66 90                	xchg   %ax,%ax
  803db0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803db4:	72 ea                	jb     803da0 <__umoddi3+0x134>
  803db6:	89 d9                	mov    %ebx,%ecx
  803db8:	e9 62 ff ff ff       	jmp    803d1f <__umoddi3+0xb3>
