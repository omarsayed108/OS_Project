
obj/user/tst_air_customer:     file format elf32-i386


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
  800031:	e8 3a 06 00 00       	call   800670 <libmain>
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
  80003e:	81 ec 0c 02 00 00    	sub    $0x20c,%esp
	//disable the print of prog stats after finishing
	printStats = 0;
  800044:	c7 05 00 50 80 00 00 	movl   $0x0,0x805000
  80004b:	00 00 00 

	int32 parentenvID = sys_getparentenvid();
  80004e:	e8 9b 27 00 00       	call   8027ee <sys_getparentenvid>
  800053:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	char _agentCapacity[] = "agentCapacity";
  800056:	8d 45 a2             	lea    -0x5e(%ebp),%eax
  800059:	bb a9 3d 80 00       	mov    $0x803da9,%ebx
  80005e:	ba 0e 00 00 00       	mov    $0xe,%edx
  800063:	89 c7                	mov    %eax,%edi
  800065:	89 de                	mov    %ebx,%esi
  800067:	89 d1                	mov    %edx,%ecx
  800069:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _customers[] = "customers";
  80006b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80006e:	bb b7 3d 80 00       	mov    $0x803db7,%ebx
  800073:	ba 0a 00 00 00       	mov    $0xa,%edx
  800078:	89 c7                	mov    %eax,%edi
  80007a:	89 de                	mov    %ebx,%esi
  80007c:	89 d1                	mov    %edx,%ecx
  80007e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800080:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800083:	bb c1 3d 80 00       	mov    $0x803dc1,%ebx
  800088:	ba 03 00 00 00       	mov    $0x3,%edx
  80008d:	89 c7                	mov    %eax,%edi
  80008f:	89 de                	mov    %ebx,%esi
  800091:	89 d1                	mov    %edx,%ecx
  800093:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800095:	8d 85 7d ff ff ff    	lea    -0x83(%ebp),%eax
  80009b:	bb cd 3d 80 00       	mov    $0x803dcd,%ebx
  8000a0:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000a5:	89 c7                	mov    %eax,%edi
  8000a7:	89 de                	mov    %ebx,%esi
  8000a9:	89 d1                	mov    %edx,%ecx
  8000ab:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000ad:	8d 85 6e ff ff ff    	lea    -0x92(%ebp),%eax
  8000b3:	bb dc 3d 80 00       	mov    $0x803ddc,%ebx
  8000b8:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000bd:	89 c7                	mov    %eax,%edi
  8000bf:	89 de                	mov    %ebx,%esi
  8000c1:	89 d1                	mov    %edx,%ecx
  8000c3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000c5:	8d 85 59 ff ff ff    	lea    -0xa7(%ebp),%eax
  8000cb:	bb eb 3d 80 00       	mov    $0x803deb,%ebx
  8000d0:	ba 15 00 00 00       	mov    $0x15,%edx
  8000d5:	89 c7                	mov    %eax,%edi
  8000d7:	89 de                	mov    %ebx,%esi
  8000d9:	89 d1                	mov    %edx,%ecx
  8000db:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000dd:	8d 85 44 ff ff ff    	lea    -0xbc(%ebp),%eax
  8000e3:	bb 00 3e 80 00       	mov    $0x803e00,%ebx
  8000e8:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ed:	89 c7                	mov    %eax,%edi
  8000ef:	89 de                	mov    %ebx,%esi
  8000f1:	89 d1                	mov    %edx,%ecx
  8000f3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000f5:	8d 85 33 ff ff ff    	lea    -0xcd(%ebp),%eax
  8000fb:	bb 15 3e 80 00       	mov    $0x803e15,%ebx
  800100:	ba 11 00 00 00       	mov    $0x11,%edx
  800105:	89 c7                	mov    %eax,%edi
  800107:	89 de                	mov    %ebx,%esi
  800109:	89 d1                	mov    %edx,%ecx
  80010b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80010d:	8d 85 22 ff ff ff    	lea    -0xde(%ebp),%eax
  800113:	bb 26 3e 80 00       	mov    $0x803e26,%ebx
  800118:	ba 11 00 00 00       	mov    $0x11,%edx
  80011d:	89 c7                	mov    %eax,%edi
  80011f:	89 de                	mov    %ebx,%esi
  800121:	89 d1                	mov    %edx,%ecx
  800123:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800125:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  80012b:	bb 37 3e 80 00       	mov    $0x803e37,%ebx
  800130:	ba 11 00 00 00       	mov    $0x11,%edx
  800135:	89 c7                	mov    %eax,%edi
  800137:	89 de                	mov    %ebx,%esi
  800139:	89 d1                	mov    %edx,%ecx
  80013b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80013d:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
  800143:	bb 48 3e 80 00       	mov    $0x803e48,%ebx
  800148:	ba 09 00 00 00       	mov    $0x9,%edx
  80014d:	89 c7                	mov    %eax,%edi
  80014f:	89 de                	mov    %ebx,%esi
  800151:	89 d1                	mov    %edx,%ecx
  800153:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800155:	8d 85 fe fe ff ff    	lea    -0x102(%ebp),%eax
  80015b:	bb 51 3e 80 00       	mov    $0x803e51,%ebx
  800160:	ba 0a 00 00 00       	mov    $0xa,%edx
  800165:	89 c7                	mov    %eax,%edi
  800167:	89 de                	mov    %ebx,%esi
  800169:	89 d1                	mov    %edx,%ecx
  80016b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80016d:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800173:	bb 5b 3e 80 00       	mov    $0x803e5b,%ebx
  800178:	ba 0b 00 00 00       	mov    $0xb,%edx
  80017d:	89 c7                	mov    %eax,%edi
  80017f:	89 de                	mov    %ebx,%esi
  800181:	89 d1                	mov    %edx,%ecx
  800183:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800185:	8d 85 e7 fe ff ff    	lea    -0x119(%ebp),%eax
  80018b:	bb 66 3e 80 00       	mov    $0x803e66,%ebx
  800190:	ba 03 00 00 00       	mov    $0x3,%edx
  800195:	89 c7                	mov    %eax,%edi
  800197:	89 de                	mov    %ebx,%esi
  800199:	89 d1                	mov    %edx,%ecx
  80019b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  80019d:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
  8001a3:	bb 72 3e 80 00       	mov    $0x803e72,%ebx
  8001a8:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001ad:	89 c7                	mov    %eax,%edi
  8001af:	89 de                	mov    %ebx,%esi
  8001b1:	89 d1                	mov    %edx,%ecx
  8001b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001b5:	8d 85 d3 fe ff ff    	lea    -0x12d(%ebp),%eax
  8001bb:	bb 7c 3e 80 00       	mov    $0x803e7c,%ebx
  8001c0:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001c5:	89 c7                	mov    %eax,%edi
  8001c7:	89 de                	mov    %ebx,%esi
  8001c9:	89 d1                	mov    %edx,%ecx
  8001cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001cd:	c7 85 cd fe ff ff 63 	movl   $0x72656c63,-0x133(%ebp)
  8001d4:	6c 65 72 
  8001d7:	66 c7 85 d1 fe ff ff 	movw   $0x6b,-0x12f(%ebp)
  8001de:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001e0:	8d 85 bf fe ff ff    	lea    -0x141(%ebp),%eax
  8001e6:	bb 86 3e 80 00       	mov    $0x803e86,%ebx
  8001eb:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001f0:	89 c7                	mov    %eax,%edi
  8001f2:	89 de                	mov    %ebx,%esi
  8001f4:	89 d1                	mov    %edx,%ecx
  8001f6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001f8:	8d 85 b0 fe ff ff    	lea    -0x150(%ebp),%eax
  8001fe:	bb 94 3e 80 00       	mov    $0x803e94,%ebx
  800203:	ba 0f 00 00 00       	mov    $0xf,%edx
  800208:	89 c7                	mov    %eax,%edi
  80020a:	89 de                	mov    %ebx,%esi
  80020c:	89 d1                	mov    %edx,%ecx
  80020e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800210:	8d 85 a9 fe ff ff    	lea    -0x157(%ebp),%eax
  800216:	bb a3 3e 80 00       	mov    $0x803ea3,%ebx
  80021b:	ba 07 00 00 00       	mov    $0x7,%edx
  800220:	89 c7                	mov    %eax,%edi
  800222:	89 de                	mov    %ebx,%esi
  800224:	89 d1                	mov    %edx,%ecx
  800226:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800228:	8d 85 a2 fe ff ff    	lea    -0x15e(%ebp),%eax
  80022e:	bb aa 3e 80 00       	mov    $0x803eaa,%ebx
  800233:	ba 07 00 00 00       	mov    $0x7,%edx
  800238:	89 c7                	mov    %eax,%edi
  80023a:	89 de                	mov    %ebx,%esi
  80023c:	89 d1                	mov    %edx,%ecx
  80023e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _flight1Customers[] = "flight1Customers";
  800240:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  800246:	bb b1 3e 80 00       	mov    $0x803eb1,%ebx
  80024b:	ba 11 00 00 00       	mov    $0x11,%edx
  800250:	89 c7                	mov    %eax,%edi
  800252:	89 de                	mov    %ebx,%esi
  800254:	89 d1                	mov    %edx,%ecx
  800256:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Customers[] = "flight2Customers";
  800258:	8d 85 80 fe ff ff    	lea    -0x180(%ebp),%eax
  80025e:	bb c2 3e 80 00       	mov    $0x803ec2,%ebx
  800263:	ba 11 00 00 00       	mov    $0x11,%edx
  800268:	89 c7                	mov    %eax,%edi
  80026a:	89 de                	mov    %ebx,%esi
  80026c:	89 d1                	mov    %edx,%ecx
  80026e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight3Customers[] = "flight3Customers";
  800270:	8d 85 6f fe ff ff    	lea    -0x191(%ebp),%eax
  800276:	bb d3 3e 80 00       	mov    $0x803ed3,%ebx
  80027b:	ba 11 00 00 00       	mov    $0x11,%edx
  800280:	89 c7                	mov    %eax,%edi
  800282:	89 de                	mov    %ebx,%esi
  800284:	89 d1                	mov    %edx,%ecx
  800286:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	// Get the shared variables from the main program ***********************************

	struct Customer * customers = sget(parentenvID, _customers);
  800288:	83 ec 08             	sub    $0x8,%esp
  80028b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80028e:	50                   	push   %eax
  80028f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800292:	e8 b4 20 00 00       	call   80234b <sget>
  800297:	83 c4 10             	add    $0x10,%esp
  80029a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* custCounter = sget(parentenvID, _custCounter);
  80029d:	83 ec 08             	sub    $0x8,%esp
  8002a0:	8d 45 8c             	lea    -0x74(%ebp),%eax
  8002a3:	50                   	push   %eax
  8002a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a7:	e8 9f 20 00 00       	call   80234b <sget>
  8002ac:	83 c4 10             	add    $0x10,%esp
  8002af:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  8002b2:	83 ec 08             	sub    $0x8,%esp
  8002b5:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  8002bb:	50                   	push   %eax
  8002bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bf:	e8 87 20 00 00       	call   80234b <sget>
  8002c4:	83 c4 10             	add    $0x10,%esp
  8002c7:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* queue_in = sget(parentenvID, _queue_in);
  8002ca:	83 ec 08             	sub    $0x8,%esp
  8002cd:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
  8002d3:	50                   	push   %eax
  8002d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d7:	e8 6f 20 00 00       	call   80234b <sget>
  8002dc:	83 c4 10             	add    $0x10,%esp
  8002df:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int* flight1Customers = sget(parentenvID, _flight1Customers);
  8002e2:	83 ec 08             	sub    $0x8,%esp
  8002e5:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  8002eb:	50                   	push   %eax
  8002ec:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ef:	e8 57 20 00 00       	call   80234b <sget>
  8002f4:	83 c4 10             	add    $0x10,%esp
  8002f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int* flight2Customers = sget(parentenvID, _flight2Customers);
  8002fa:	83 ec 08             	sub    $0x8,%esp
  8002fd:	8d 85 80 fe ff ff    	lea    -0x180(%ebp),%eax
  800303:	50                   	push   %eax
  800304:	ff 75 e4             	pushl  -0x1c(%ebp)
  800307:	e8 3f 20 00 00       	call   80234b <sget>
  80030c:	83 c4 10             	add    $0x10,%esp
  80030f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int* flight3Customers = sget(parentenvID, _flight3Customers);
  800312:	83 ec 08             	sub    $0x8,%esp
  800315:	8d 85 6f fe ff ff    	lea    -0x191(%ebp),%eax
  80031b:	50                   	push   %eax
  80031c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80031f:	e8 27 20 00 00       	call   80234b <sget>
  800324:	83 c4 10             	add    $0x10,%esp
  800327:	89 45 c8             	mov    %eax,-0x38(%ebp)

	// Get the shared semaphores from the main program ***********************************

	struct semaphore capacity = get_semaphore(parentenvID, _agentCapacity);
  80032a:	8d 85 68 fe ff ff    	lea    -0x198(%ebp),%eax
  800330:	83 ec 04             	sub    $0x4,%esp
  800333:	8d 55 a2             	lea    -0x5e(%ebp),%edx
  800336:	52                   	push   %edx
  800337:	ff 75 e4             	pushl  -0x1c(%ebp)
  80033a:	50                   	push   %eax
  80033b:	e8 93 34 00 00       	call   8037d3 <get_semaphore>
  800340:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custCounterCS = get_semaphore(parentenvID, _custCounterCS);
  800343:	8d 85 64 fe ff ff    	lea    -0x19c(%ebp),%eax
  800349:	83 ec 04             	sub    $0x4,%esp
  80034c:	8d 95 bf fe ff ff    	lea    -0x141(%ebp),%edx
  800352:	52                   	push   %edx
  800353:	ff 75 e4             	pushl  -0x1c(%ebp)
  800356:	50                   	push   %eax
  800357:	e8 77 34 00 00       	call   8037d3 <get_semaphore>
  80035c:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  80035f:	8d 85 60 fe ff ff    	lea    -0x1a0(%ebp),%eax
  800365:	83 ec 04             	sub    $0x4,%esp
  800368:	8d 95 cd fe ff ff    	lea    -0x133(%ebp),%edx
  80036e:	52                   	push   %edx
  80036f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800372:	50                   	push   %eax
  800373:	e8 5b 34 00 00       	call   8037d3 <get_semaphore>
  800378:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  80037b:	8d 85 5c fe ff ff    	lea    -0x1a4(%ebp),%eax
  800381:	83 ec 04             	sub    $0x4,%esp
  800384:	8d 95 e7 fe ff ff    	lea    -0x119(%ebp),%edx
  80038a:	52                   	push   %edx
  80038b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80038e:	50                   	push   %eax
  80038f:	e8 3f 34 00 00       	call   8037d3 <get_semaphore>
  800394:	83 c4 0c             	add    $0xc,%esp
	struct semaphore cust_ready = get_semaphore(parentenvID, _cust_ready);
  800397:	8d 85 58 fe ff ff    	lea    -0x1a8(%ebp),%eax
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	8d 95 f3 fe ff ff    	lea    -0x10d(%ebp),%edx
  8003a6:	52                   	push   %edx
  8003a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003aa:	50                   	push   %eax
  8003ab:	e8 23 34 00 00       	call   8037d3 <get_semaphore>
  8003b0:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custTerminated = get_semaphore(parentenvID, _custTerminated);
  8003b3:	8d 85 54 fe ff ff    	lea    -0x1ac(%ebp),%eax
  8003b9:	83 ec 04             	sub    $0x4,%esp
  8003bc:	8d 95 b0 fe ff ff    	lea    -0x150(%ebp),%edx
  8003c2:	52                   	push   %edx
  8003c3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003c6:	50                   	push   %eax
  8003c7:	e8 07 34 00 00       	call   8037d3 <get_semaphore>
  8003cc:	83 c4 0c             	add    $0xc,%esp

	int custId, flightType;
	wait_semaphore(custCounterCS);
  8003cf:	83 ec 0c             	sub    $0xc,%esp
  8003d2:	ff b5 64 fe ff ff    	pushl  -0x19c(%ebp)
  8003d8:	e8 10 34 00 00       	call   8037ed <wait_semaphore>
  8003dd:	83 c4 10             	add    $0x10,%esp
	{
		custId = *custCounter;
  8003e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003e3:	8b 00                	mov    (%eax),%eax
  8003e5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		//cprintf("custCounter= %d\n", *custCounter);
		*custCounter = *custCounter +1;
  8003e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003eb:	8b 00                	mov    (%eax),%eax
  8003ed:	8d 50 01             	lea    0x1(%eax),%edx
  8003f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003f3:	89 10                	mov    %edx,(%eax)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8003f5:	0f 31                	rdtsc  
  8003f7:	89 85 44 fe ff ff    	mov    %eax,-0x1bc(%ebp)
  8003fd:	89 95 48 fe ff ff    	mov    %edx,-0x1b8(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  800403:	8b 85 44 fe ff ff    	mov    -0x1bc(%ebp),%eax
  800409:	8b 95 48 fe ff ff    	mov    -0x1b8(%ebp),%edx
  80040f:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800412:	89 55 b4             	mov    %edx,-0x4c(%ebp)
		repFlightSel:
		//get random flight
		flightType = RANDU(1, 4);
  800415:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800418:	b9 03 00 00 00       	mov    $0x3,%ecx
  80041d:	ba 00 00 00 00       	mov    $0x0,%edx
  800422:	f7 f1                	div    %ecx
  800424:	89 d0                	mov    %edx,%eax
  800426:	40                   	inc    %eax
  800427:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if(flightType == 1 && *flight1Customers > 0)		(*flight1Customers)--;
  80042a:	83 7d c0 01          	cmpl   $0x1,-0x40(%ebp)
  80042e:	75 18                	jne    800448 <_main+0x410>
  800430:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800433:	8b 00                	mov    (%eax),%eax
  800435:	85 c0                	test   %eax,%eax
  800437:	7e 0f                	jle    800448 <_main+0x410>
  800439:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80043c:	8b 00                	mov    (%eax),%eax
  80043e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800441:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800444:	89 10                	mov    %edx,(%eax)
  800446:	eb 3a                	jmp    800482 <_main+0x44a>
		else if(flightType == 2 && *flight2Customers > 0)	(*flight2Customers)--;
  800448:	83 7d c0 02          	cmpl   $0x2,-0x40(%ebp)
  80044c:	75 18                	jne    800466 <_main+0x42e>
  80044e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800451:	8b 00                	mov    (%eax),%eax
  800453:	85 c0                	test   %eax,%eax
  800455:	7e 0f                	jle    800466 <_main+0x42e>
  800457:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80045a:	8b 00                	mov    (%eax),%eax
  80045c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80045f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800462:	89 10                	mov    %edx,(%eax)
  800464:	eb 1c                	jmp    800482 <_main+0x44a>
		else if(flightType == 3 && *flight3Customers > 0)	(*flight3Customers)--;
  800466:	83 7d c0 03          	cmpl   $0x3,-0x40(%ebp)
  80046a:	75 89                	jne    8003f5 <_main+0x3bd>
  80046c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80046f:	8b 00                	mov    (%eax),%eax
  800471:	85 c0                	test   %eax,%eax
  800473:	7e 80                	jle    8003f5 <_main+0x3bd>
  800475:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80047d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800480:	89 10                	mov    %edx,(%eax)
		else goto repFlightSel;
	}
	signal_semaphore(custCounterCS);
  800482:	83 ec 0c             	sub    $0xc,%esp
  800485:	ff b5 64 fe ff ff    	pushl  -0x19c(%ebp)
  80048b:	e8 77 33 00 00       	call   803807 <signal_semaphore>
  800490:	83 c4 10             	add    $0x10,%esp

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  800493:	0f 31                	rdtsc  
  800495:	89 85 4c fe ff ff    	mov    %eax,-0x1b4(%ebp)
  80049b:	89 95 50 fe ff ff    	mov    %edx,-0x1b0(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8004a1:	8b 85 4c fe ff ff    	mov    -0x1b4(%ebp),%eax
  8004a7:	8b 95 50 fe ff ff    	mov    -0x1b0(%ebp),%edx
  8004ad:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8004b0:	89 55 bc             	mov    %edx,-0x44(%ebp)

	//delay for a random time
	env_sleep(RANDU(100, 10000));
  8004b3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004b6:	b9 ac 26 00 00       	mov    $0x26ac,%ecx
  8004bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c0:	f7 f1                	div    %ecx
  8004c2:	89 d0                	mov    %edx,%eax
  8004c4:	83 c0 64             	add    $0x64,%eax
  8004c7:	83 ec 0c             	sub    $0xc,%esp
  8004ca:	50                   	push   %eax
  8004cb:	e8 5c 33 00 00       	call   80382c <env_sleep>
  8004d0:	83 c4 10             	add    $0x10,%esp

	//enter the agent if there's a space
	wait_semaphore(capacity);
  8004d3:	83 ec 0c             	sub    $0xc,%esp
  8004d6:	ff b5 68 fe ff ff    	pushl  -0x198(%ebp)
  8004dc:	e8 0c 33 00 00       	call   8037ed <wait_semaphore>
  8004e1:	83 c4 10             	add    $0x10,%esp
	{
		//wait on one of the clerks
		wait_semaphore(clerk);
  8004e4:	83 ec 0c             	sub    $0xc,%esp
  8004e7:	ff b5 60 fe ff ff    	pushl  -0x1a0(%ebp)
  8004ed:	e8 fb 32 00 00       	call   8037ed <wait_semaphore>
  8004f2:	83 c4 10             	add    $0x10,%esp

		//enqueue the request
		customers[custId].booked = 0 ;
  8004f5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004f8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8004ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800502:	01 d0                	add    %edx,%eax
  800504:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		customers[custId].flightType = flightType ;
  80050b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80050e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800515:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800518:	01 c2                	add    %eax,%edx
  80051a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80051d:	89 02                	mov    %eax,(%edx)
		wait_semaphore(custQueueCS);
  80051f:	83 ec 0c             	sub    $0xc,%esp
  800522:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  800528:	e8 c0 32 00 00       	call   8037ed <wait_semaphore>
  80052d:	83 c4 10             	add    $0x10,%esp
		{
			cust_ready_queue[*queue_in] = custId;
  800530:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800533:	8b 00                	mov    (%eax),%eax
  800535:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80053c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80053f:	01 c2                	add    %eax,%edx
  800541:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800544:	89 02                	mov    %eax,(%edx)
			*queue_in = *queue_in +1;
  800546:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800549:	8b 00                	mov    (%eax),%eax
  80054b:	8d 50 01             	lea    0x1(%eax),%edx
  80054e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800551:	89 10                	mov    %edx,(%eax)
		}
		signal_semaphore(custQueueCS);
  800553:	83 ec 0c             	sub    $0xc,%esp
  800556:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  80055c:	e8 a6 32 00 00       	call   803807 <signal_semaphore>
  800561:	83 c4 10             	add    $0x10,%esp

		//signal ready
		signal_semaphore(cust_ready);
  800564:	83 ec 0c             	sub    $0xc,%esp
  800567:	ff b5 58 fe ff ff    	pushl  -0x1a8(%ebp)
  80056d:	e8 95 32 00 00       	call   803807 <signal_semaphore>
  800572:	83 c4 10             	add    $0x10,%esp

		//wait on finished
		char prefix[30]="cust_finished";
  800575:	8d 85 26 fe ff ff    	lea    -0x1da(%ebp),%eax
  80057b:	bb e4 3e 80 00       	mov    $0x803ee4,%ebx
  800580:	ba 0e 00 00 00       	mov    $0xe,%edx
  800585:	89 c7                	mov    %eax,%edi
  800587:	89 de                	mov    %ebx,%esi
  800589:	89 d1                	mov    %edx,%ecx
  80058b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80058d:	8d 95 34 fe ff ff    	lea    -0x1cc(%ebp),%edx
  800593:	b9 04 00 00 00       	mov    $0x4,%ecx
  800598:	b8 00 00 00 00       	mov    $0x0,%eax
  80059d:	89 d7                	mov    %edx,%edi
  80059f:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(custId, id);
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	8d 85 21 fe ff ff    	lea    -0x1df(%ebp),%eax
  8005aa:	50                   	push   %eax
  8005ab:	ff 75 c4             	pushl  -0x3c(%ebp)
  8005ae:	e8 7b 0f 00 00       	call   80152e <ltostr>
  8005b3:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  8005b6:	83 ec 04             	sub    $0x4,%esp
  8005b9:	8d 85 ea fd ff ff    	lea    -0x216(%ebp),%eax
  8005bf:	50                   	push   %eax
  8005c0:	8d 85 21 fe ff ff    	lea    -0x1df(%ebp),%eax
  8005c6:	50                   	push   %eax
  8005c7:	8d 85 26 fe ff ff    	lea    -0x1da(%ebp),%eax
  8005cd:	50                   	push   %eax
  8005ce:	e8 34 10 00 00       	call   801607 <strcconcat>
  8005d3:	83 c4 10             	add    $0x10,%esp
		//sys_waitSemaphore(parentenvID, sname);
		struct semaphore cust_finished = get_semaphore(parentenvID, sname);
  8005d6:	8d 85 1c fe ff ff    	lea    -0x1e4(%ebp),%eax
  8005dc:	83 ec 04             	sub    $0x4,%esp
  8005df:	8d 95 ea fd ff ff    	lea    -0x216(%ebp),%edx
  8005e5:	52                   	push   %edx
  8005e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005e9:	50                   	push   %eax
  8005ea:	e8 e4 31 00 00       	call   8037d3 <get_semaphore>
  8005ef:	83 c4 0c             	add    $0xc,%esp
		wait_semaphore(cust_finished);
  8005f2:	83 ec 0c             	sub    $0xc,%esp
  8005f5:	ff b5 1c fe ff ff    	pushl  -0x1e4(%ebp)
  8005fb:	e8 ed 31 00 00       	call   8037ed <wait_semaphore>
  800600:	83 c4 10             	add    $0x10,%esp

		//print the customer status
		if(customers[custId].booked == 1)
  800603:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800606:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800610:	01 d0                	add    %edx,%eax
  800612:	8b 40 04             	mov    0x4(%eax),%eax
  800615:	83 f8 01             	cmp    $0x1,%eax
  800618:	75 18                	jne    800632 <_main+0x5fa>
		{
			cprintf("cust %d: finished (BOOKED flight %d) \n", custId, flightType);
  80061a:	83 ec 04             	sub    $0x4,%esp
  80061d:	ff 75 c0             	pushl  -0x40(%ebp)
  800620:	ff 75 c4             	pushl  -0x3c(%ebp)
  800623:	68 60 3d 80 00       	push   $0x803d60
  800628:	e8 d3 02 00 00       	call   800900 <cprintf>
  80062d:	83 c4 10             	add    $0x10,%esp
  800630:	eb 13                	jmp    800645 <_main+0x60d>
		}
		else
		{
			cprintf("cust %d: finished (NOT BOOKED) \n", custId);
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	ff 75 c4             	pushl  -0x3c(%ebp)
  800638:	68 88 3d 80 00       	push   $0x803d88
  80063d:	e8 be 02 00 00       	call   800900 <cprintf>
  800642:	83 c4 10             	add    $0x10,%esp
		}
	}
	//exit the agent
	signal_semaphore(capacity);
  800645:	83 ec 0c             	sub    $0xc,%esp
  800648:	ff b5 68 fe ff ff    	pushl  -0x198(%ebp)
  80064e:	e8 b4 31 00 00       	call   803807 <signal_semaphore>
  800653:	83 c4 10             	add    $0x10,%esp

	//customer is terminated
	signal_semaphore(custTerminated);
  800656:	83 ec 0c             	sub    $0xc,%esp
  800659:	ff b5 54 fe ff ff    	pushl  -0x1ac(%ebp)
  80065f:	e8 a3 31 00 00       	call   803807 <signal_semaphore>
  800664:	83 c4 10             	add    $0x10,%esp

	return;
  800667:	90                   	nop
}
  800668:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80066b:	5b                   	pop    %ebx
  80066c:	5e                   	pop    %esi
  80066d:	5f                   	pop    %edi
  80066e:	5d                   	pop    %ebp
  80066f:	c3                   	ret    

00800670 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800670:	55                   	push   %ebp
  800671:	89 e5                	mov    %esp,%ebp
  800673:	57                   	push   %edi
  800674:	56                   	push   %esi
  800675:	53                   	push   %ebx
  800676:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800679:	e8 57 21 00 00       	call   8027d5 <sys_getenvindex>
  80067e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800681:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800684:	89 d0                	mov    %edx,%eax
  800686:	01 c0                	add    %eax,%eax
  800688:	01 d0                	add    %edx,%eax
  80068a:	c1 e0 02             	shl    $0x2,%eax
  80068d:	01 d0                	add    %edx,%eax
  80068f:	c1 e0 02             	shl    $0x2,%eax
  800692:	01 d0                	add    %edx,%eax
  800694:	c1 e0 03             	shl    $0x3,%eax
  800697:	01 d0                	add    %edx,%eax
  800699:	c1 e0 02             	shl    $0x2,%eax
  80069c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006a1:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006a6:	a1 20 50 80 00       	mov    0x805020,%eax
  8006ab:	8a 40 20             	mov    0x20(%eax),%al
  8006ae:	84 c0                	test   %al,%al
  8006b0:	74 0d                	je     8006bf <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8006b2:	a1 20 50 80 00       	mov    0x805020,%eax
  8006b7:	83 c0 20             	add    $0x20,%eax
  8006ba:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006c3:	7e 0a                	jle    8006cf <libmain+0x5f>
		binaryname = argv[0];
  8006c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c8:	8b 00                	mov    (%eax),%eax
  8006ca:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8006cf:	83 ec 08             	sub    $0x8,%esp
  8006d2:	ff 75 0c             	pushl  0xc(%ebp)
  8006d5:	ff 75 08             	pushl  0x8(%ebp)
  8006d8:	e8 5b f9 ff ff       	call   800038 <_main>
  8006dd:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8006e0:	a1 00 50 80 00       	mov    0x805000,%eax
  8006e5:	85 c0                	test   %eax,%eax
  8006e7:	0f 84 01 01 00 00    	je     8007ee <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8006ed:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8006f3:	bb fc 3f 80 00       	mov    $0x803ffc,%ebx
  8006f8:	ba 0e 00 00 00       	mov    $0xe,%edx
  8006fd:	89 c7                	mov    %eax,%edi
  8006ff:	89 de                	mov    %ebx,%esi
  800701:	89 d1                	mov    %edx,%ecx
  800703:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800705:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800708:	b9 56 00 00 00       	mov    $0x56,%ecx
  80070d:	b0 00                	mov    $0x0,%al
  80070f:	89 d7                	mov    %edx,%edi
  800711:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800713:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80071a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	50                   	push   %eax
  800721:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800727:	50                   	push   %eax
  800728:	e8 de 22 00 00       	call   802a0b <sys_utilities>
  80072d:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800730:	e8 27 1e 00 00       	call   80255c <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800735:	83 ec 0c             	sub    $0xc,%esp
  800738:	68 1c 3f 80 00       	push   $0x803f1c
  80073d:	e8 be 01 00 00       	call   800900 <cprintf>
  800742:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800745:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800748:	85 c0                	test   %eax,%eax
  80074a:	74 18                	je     800764 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80074c:	e8 d8 22 00 00       	call   802a29 <sys_get_optimal_num_faults>
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	50                   	push   %eax
  800755:	68 44 3f 80 00       	push   $0x803f44
  80075a:	e8 a1 01 00 00       	call   800900 <cprintf>
  80075f:	83 c4 10             	add    $0x10,%esp
  800762:	eb 59                	jmp    8007bd <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800764:	a1 20 50 80 00       	mov    0x805020,%eax
  800769:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  80076f:	a1 20 50 80 00       	mov    0x805020,%eax
  800774:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  80077a:	83 ec 04             	sub    $0x4,%esp
  80077d:	52                   	push   %edx
  80077e:	50                   	push   %eax
  80077f:	68 68 3f 80 00       	push   $0x803f68
  800784:	e8 77 01 00 00       	call   800900 <cprintf>
  800789:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80078c:	a1 20 50 80 00       	mov    0x805020,%eax
  800791:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800797:	a1 20 50 80 00       	mov    0x805020,%eax
  80079c:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8007a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8007a7:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  8007ad:	51                   	push   %ecx
  8007ae:	52                   	push   %edx
  8007af:	50                   	push   %eax
  8007b0:	68 90 3f 80 00       	push   $0x803f90
  8007b5:	e8 46 01 00 00       	call   800900 <cprintf>
  8007ba:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007bd:	a1 20 50 80 00       	mov    0x805020,%eax
  8007c2:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8007c8:	83 ec 08             	sub    $0x8,%esp
  8007cb:	50                   	push   %eax
  8007cc:	68 e8 3f 80 00       	push   $0x803fe8
  8007d1:	e8 2a 01 00 00       	call   800900 <cprintf>
  8007d6:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8007d9:	83 ec 0c             	sub    $0xc,%esp
  8007dc:	68 1c 3f 80 00       	push   $0x803f1c
  8007e1:	e8 1a 01 00 00       	call   800900 <cprintf>
  8007e6:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8007e9:	e8 88 1d 00 00       	call   802576 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8007ee:	e8 1f 00 00 00       	call   800812 <exit>
}
  8007f3:	90                   	nop
  8007f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007f7:	5b                   	pop    %ebx
  8007f8:	5e                   	pop    %esi
  8007f9:	5f                   	pop    %edi
  8007fa:	5d                   	pop    %ebp
  8007fb:	c3                   	ret    

008007fc <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8007fc:	55                   	push   %ebp
  8007fd:	89 e5                	mov    %esp,%ebp
  8007ff:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800802:	83 ec 0c             	sub    $0xc,%esp
  800805:	6a 00                	push   $0x0
  800807:	e8 95 1f 00 00       	call   8027a1 <sys_destroy_env>
  80080c:	83 c4 10             	add    $0x10,%esp
}
  80080f:	90                   	nop
  800810:	c9                   	leave  
  800811:	c3                   	ret    

00800812 <exit>:

void
exit(void)
{
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800818:	e8 ea 1f 00 00       	call   802807 <sys_exit_env>
}
  80081d:	90                   	nop
  80081e:	c9                   	leave  
  80081f:	c3                   	ret    

00800820 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800820:	55                   	push   %ebp
  800821:	89 e5                	mov    %esp,%ebp
  800823:	53                   	push   %ebx
  800824:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800827:	8b 45 0c             	mov    0xc(%ebp),%eax
  80082a:	8b 00                	mov    (%eax),%eax
  80082c:	8d 48 01             	lea    0x1(%eax),%ecx
  80082f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800832:	89 0a                	mov    %ecx,(%edx)
  800834:	8b 55 08             	mov    0x8(%ebp),%edx
  800837:	88 d1                	mov    %dl,%cl
  800839:	8b 55 0c             	mov    0xc(%ebp),%edx
  80083c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800840:	8b 45 0c             	mov    0xc(%ebp),%eax
  800843:	8b 00                	mov    (%eax),%eax
  800845:	3d ff 00 00 00       	cmp    $0xff,%eax
  80084a:	75 30                	jne    80087c <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80084c:	8b 15 18 d1 81 00    	mov    0x81d118,%edx
  800852:	a0 44 50 80 00       	mov    0x805044,%al
  800857:	0f b6 c0             	movzbl %al,%eax
  80085a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80085d:	8b 09                	mov    (%ecx),%ecx
  80085f:	89 cb                	mov    %ecx,%ebx
  800861:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800864:	83 c1 08             	add    $0x8,%ecx
  800867:	52                   	push   %edx
  800868:	50                   	push   %eax
  800869:	53                   	push   %ebx
  80086a:	51                   	push   %ecx
  80086b:	e8 a8 1c 00 00       	call   802518 <sys_cputs>
  800870:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800873:	8b 45 0c             	mov    0xc(%ebp),%eax
  800876:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80087c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80087f:	8b 40 04             	mov    0x4(%eax),%eax
  800882:	8d 50 01             	lea    0x1(%eax),%edx
  800885:	8b 45 0c             	mov    0xc(%ebp),%eax
  800888:	89 50 04             	mov    %edx,0x4(%eax)
}
  80088b:	90                   	nop
  80088c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80088f:	c9                   	leave  
  800890:	c3                   	ret    

00800891 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800891:	55                   	push   %ebp
  800892:	89 e5                	mov    %esp,%ebp
  800894:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80089a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8008a1:	00 00 00 
	b.cnt = 0;
  8008a4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8008ab:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8008ae:	ff 75 0c             	pushl  0xc(%ebp)
  8008b1:	ff 75 08             	pushl  0x8(%ebp)
  8008b4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008ba:	50                   	push   %eax
  8008bb:	68 20 08 80 00       	push   $0x800820
  8008c0:	e8 5a 02 00 00       	call   800b1f <vprintfmt>
  8008c5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8008c8:	8b 15 18 d1 81 00    	mov    0x81d118,%edx
  8008ce:	a0 44 50 80 00       	mov    0x805044,%al
  8008d3:	0f b6 c0             	movzbl %al,%eax
  8008d6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8008dc:	52                   	push   %edx
  8008dd:	50                   	push   %eax
  8008de:	51                   	push   %ecx
  8008df:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008e5:	83 c0 08             	add    $0x8,%eax
  8008e8:	50                   	push   %eax
  8008e9:	e8 2a 1c 00 00       	call   802518 <sys_cputs>
  8008ee:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8008f1:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  8008f8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8008fe:	c9                   	leave  
  8008ff:	c3                   	ret    

00800900 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800906:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  80090d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800910:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	83 ec 08             	sub    $0x8,%esp
  800919:	ff 75 f4             	pushl  -0xc(%ebp)
  80091c:	50                   	push   %eax
  80091d:	e8 6f ff ff ff       	call   800891 <vcprintf>
  800922:	83 c4 10             	add    $0x10,%esp
  800925:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800928:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80092b:	c9                   	leave  
  80092c:	c3                   	ret    

0080092d <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
  800930:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800933:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	c1 e0 08             	shl    $0x8,%eax
  800940:	a3 18 d1 81 00       	mov    %eax,0x81d118
	va_start(ap, fmt);
  800945:	8d 45 0c             	lea    0xc(%ebp),%eax
  800948:	83 c0 04             	add    $0x4,%eax
  80094b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80094e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	ff 75 f4             	pushl  -0xc(%ebp)
  800957:	50                   	push   %eax
  800958:	e8 34 ff ff ff       	call   800891 <vcprintf>
  80095d:	83 c4 10             	add    $0x10,%esp
  800960:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800963:	c7 05 18 d1 81 00 00 	movl   $0x700,0x81d118
  80096a:	07 00 00 

	return cnt;
  80096d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800970:	c9                   	leave  
  800971:	c3                   	ret    

00800972 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
  800975:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800978:	e8 df 1b 00 00       	call   80255c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80097d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800980:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	83 ec 08             	sub    $0x8,%esp
  800989:	ff 75 f4             	pushl  -0xc(%ebp)
  80098c:	50                   	push   %eax
  80098d:	e8 ff fe ff ff       	call   800891 <vcprintf>
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800998:	e8 d9 1b 00 00       	call   802576 <sys_unlock_cons>
	return cnt;
  80099d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009a0:	c9                   	leave  
  8009a1:	c3                   	ret    

008009a2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	53                   	push   %ebx
  8009a6:	83 ec 14             	sub    $0x14,%esp
  8009a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009af:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009b5:	8b 45 18             	mov    0x18(%ebp),%eax
  8009b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8009bd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009c0:	77 55                	ja     800a17 <printnum+0x75>
  8009c2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009c5:	72 05                	jb     8009cc <printnum+0x2a>
  8009c7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009ca:	77 4b                	ja     800a17 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009cc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009cf:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8009d2:	8b 45 18             	mov    0x18(%ebp),%eax
  8009d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009da:	52                   	push   %edx
  8009db:	50                   	push   %eax
  8009dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8009df:	ff 75 f0             	pushl  -0x10(%ebp)
  8009e2:	e8 11 31 00 00       	call   803af8 <__udivdi3>
  8009e7:	83 c4 10             	add    $0x10,%esp
  8009ea:	83 ec 04             	sub    $0x4,%esp
  8009ed:	ff 75 20             	pushl  0x20(%ebp)
  8009f0:	53                   	push   %ebx
  8009f1:	ff 75 18             	pushl  0x18(%ebp)
  8009f4:	52                   	push   %edx
  8009f5:	50                   	push   %eax
  8009f6:	ff 75 0c             	pushl  0xc(%ebp)
  8009f9:	ff 75 08             	pushl  0x8(%ebp)
  8009fc:	e8 a1 ff ff ff       	call   8009a2 <printnum>
  800a01:	83 c4 20             	add    $0x20,%esp
  800a04:	eb 1a                	jmp    800a20 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	ff 75 0c             	pushl  0xc(%ebp)
  800a0c:	ff 75 20             	pushl  0x20(%ebp)
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	ff d0                	call   *%eax
  800a14:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a17:	ff 4d 1c             	decl   0x1c(%ebp)
  800a1a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a1e:	7f e6                	jg     800a06 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a20:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a2e:	53                   	push   %ebx
  800a2f:	51                   	push   %ecx
  800a30:	52                   	push   %edx
  800a31:	50                   	push   %eax
  800a32:	e8 d1 31 00 00       	call   803c08 <__umoddi3>
  800a37:	83 c4 10             	add    $0x10,%esp
  800a3a:	05 74 42 80 00       	add    $0x804274,%eax
  800a3f:	8a 00                	mov    (%eax),%al
  800a41:	0f be c0             	movsbl %al,%eax
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	50                   	push   %eax
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	ff d0                	call   *%eax
  800a50:	83 c4 10             	add    $0x10,%esp
}
  800a53:	90                   	nop
  800a54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a57:	c9                   	leave  
  800a58:	c3                   	ret    

00800a59 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a5c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a60:	7e 1c                	jle    800a7e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	8b 00                	mov    (%eax),%eax
  800a67:	8d 50 08             	lea    0x8(%eax),%edx
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	89 10                	mov    %edx,(%eax)
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	8b 00                	mov    (%eax),%eax
  800a74:	83 e8 08             	sub    $0x8,%eax
  800a77:	8b 50 04             	mov    0x4(%eax),%edx
  800a7a:	8b 00                	mov    (%eax),%eax
  800a7c:	eb 40                	jmp    800abe <getuint+0x65>
	else if (lflag)
  800a7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a82:	74 1e                	je     800aa2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	8b 00                	mov    (%eax),%eax
  800a89:	8d 50 04             	lea    0x4(%eax),%edx
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	89 10                	mov    %edx,(%eax)
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	8b 00                	mov    (%eax),%eax
  800a96:	83 e8 04             	sub    $0x4,%eax
  800a99:	8b 00                	mov    (%eax),%eax
  800a9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa0:	eb 1c                	jmp    800abe <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	8b 00                	mov    (%eax),%eax
  800aa7:	8d 50 04             	lea    0x4(%eax),%edx
  800aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800aad:	89 10                	mov    %edx,(%eax)
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	8b 00                	mov    (%eax),%eax
  800ab4:	83 e8 04             	sub    $0x4,%eax
  800ab7:	8b 00                	mov    (%eax),%eax
  800ab9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800abe:	5d                   	pop    %ebp
  800abf:	c3                   	ret    

00800ac0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ac3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ac7:	7e 1c                	jle    800ae5 <getint+0x25>
		return va_arg(*ap, long long);
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	8b 00                	mov    (%eax),%eax
  800ace:	8d 50 08             	lea    0x8(%eax),%edx
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	89 10                	mov    %edx,(%eax)
  800ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad9:	8b 00                	mov    (%eax),%eax
  800adb:	83 e8 08             	sub    $0x8,%eax
  800ade:	8b 50 04             	mov    0x4(%eax),%edx
  800ae1:	8b 00                	mov    (%eax),%eax
  800ae3:	eb 38                	jmp    800b1d <getint+0x5d>
	else if (lflag)
  800ae5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ae9:	74 1a                	je     800b05 <getint+0x45>
		return va_arg(*ap, long);
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	8b 00                	mov    (%eax),%eax
  800af0:	8d 50 04             	lea    0x4(%eax),%edx
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	89 10                	mov    %edx,(%eax)
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8b 00                	mov    (%eax),%eax
  800afd:	83 e8 04             	sub    $0x4,%eax
  800b00:	8b 00                	mov    (%eax),%eax
  800b02:	99                   	cltd   
  800b03:	eb 18                	jmp    800b1d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
  800b08:	8b 00                	mov    (%eax),%eax
  800b0a:	8d 50 04             	lea    0x4(%eax),%edx
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	89 10                	mov    %edx,(%eax)
  800b12:	8b 45 08             	mov    0x8(%ebp),%eax
  800b15:	8b 00                	mov    (%eax),%eax
  800b17:	83 e8 04             	sub    $0x4,%eax
  800b1a:	8b 00                	mov    (%eax),%eax
  800b1c:	99                   	cltd   
}
  800b1d:	5d                   	pop    %ebp
  800b1e:	c3                   	ret    

00800b1f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
  800b22:	56                   	push   %esi
  800b23:	53                   	push   %ebx
  800b24:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b27:	eb 17                	jmp    800b40 <vprintfmt+0x21>
			if (ch == '\0')
  800b29:	85 db                	test   %ebx,%ebx
  800b2b:	0f 84 c1 03 00 00    	je     800ef2 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	ff 75 0c             	pushl  0xc(%ebp)
  800b37:	53                   	push   %ebx
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	ff d0                	call   *%eax
  800b3d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b40:	8b 45 10             	mov    0x10(%ebp),%eax
  800b43:	8d 50 01             	lea    0x1(%eax),%edx
  800b46:	89 55 10             	mov    %edx,0x10(%ebp)
  800b49:	8a 00                	mov    (%eax),%al
  800b4b:	0f b6 d8             	movzbl %al,%ebx
  800b4e:	83 fb 25             	cmp    $0x25,%ebx
  800b51:	75 d6                	jne    800b29 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b53:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b57:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b5e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b65:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b6c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b73:	8b 45 10             	mov    0x10(%ebp),%eax
  800b76:	8d 50 01             	lea    0x1(%eax),%edx
  800b79:	89 55 10             	mov    %edx,0x10(%ebp)
  800b7c:	8a 00                	mov    (%eax),%al
  800b7e:	0f b6 d8             	movzbl %al,%ebx
  800b81:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b84:	83 f8 5b             	cmp    $0x5b,%eax
  800b87:	0f 87 3d 03 00 00    	ja     800eca <vprintfmt+0x3ab>
  800b8d:	8b 04 85 98 42 80 00 	mov    0x804298(,%eax,4),%eax
  800b94:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800b96:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800b9a:	eb d7                	jmp    800b73 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b9c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ba0:	eb d1                	jmp    800b73 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ba2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ba9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bac:	89 d0                	mov    %edx,%eax
  800bae:	c1 e0 02             	shl    $0x2,%eax
  800bb1:	01 d0                	add    %edx,%eax
  800bb3:	01 c0                	add    %eax,%eax
  800bb5:	01 d8                	add    %ebx,%eax
  800bb7:	83 e8 30             	sub    $0x30,%eax
  800bba:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc0:	8a 00                	mov    (%eax),%al
  800bc2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bc5:	83 fb 2f             	cmp    $0x2f,%ebx
  800bc8:	7e 3e                	jle    800c08 <vprintfmt+0xe9>
  800bca:	83 fb 39             	cmp    $0x39,%ebx
  800bcd:	7f 39                	jg     800c08 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bcf:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bd2:	eb d5                	jmp    800ba9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800bd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd7:	83 c0 04             	add    $0x4,%eax
  800bda:	89 45 14             	mov    %eax,0x14(%ebp)
  800bdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800be0:	83 e8 04             	sub    $0x4,%eax
  800be3:	8b 00                	mov    (%eax),%eax
  800be5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800be8:	eb 1f                	jmp    800c09 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800bea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bee:	79 83                	jns    800b73 <vprintfmt+0x54>
				width = 0;
  800bf0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800bf7:	e9 77 ff ff ff       	jmp    800b73 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800bfc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c03:	e9 6b ff ff ff       	jmp    800b73 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c08:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c09:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c0d:	0f 89 60 ff ff ff    	jns    800b73 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c19:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c20:	e9 4e ff ff ff       	jmp    800b73 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c25:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c28:	e9 46 ff ff ff       	jmp    800b73 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c30:	83 c0 04             	add    $0x4,%eax
  800c33:	89 45 14             	mov    %eax,0x14(%ebp)
  800c36:	8b 45 14             	mov    0x14(%ebp),%eax
  800c39:	83 e8 04             	sub    $0x4,%eax
  800c3c:	8b 00                	mov    (%eax),%eax
  800c3e:	83 ec 08             	sub    $0x8,%esp
  800c41:	ff 75 0c             	pushl  0xc(%ebp)
  800c44:	50                   	push   %eax
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	ff d0                	call   *%eax
  800c4a:	83 c4 10             	add    $0x10,%esp
			break;
  800c4d:	e9 9b 02 00 00       	jmp    800eed <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c52:	8b 45 14             	mov    0x14(%ebp),%eax
  800c55:	83 c0 04             	add    $0x4,%eax
  800c58:	89 45 14             	mov    %eax,0x14(%ebp)
  800c5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5e:	83 e8 04             	sub    $0x4,%eax
  800c61:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c63:	85 db                	test   %ebx,%ebx
  800c65:	79 02                	jns    800c69 <vprintfmt+0x14a>
				err = -err;
  800c67:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c69:	83 fb 64             	cmp    $0x64,%ebx
  800c6c:	7f 0b                	jg     800c79 <vprintfmt+0x15a>
  800c6e:	8b 34 9d e0 40 80 00 	mov    0x8040e0(,%ebx,4),%esi
  800c75:	85 f6                	test   %esi,%esi
  800c77:	75 19                	jne    800c92 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c79:	53                   	push   %ebx
  800c7a:	68 85 42 80 00       	push   $0x804285
  800c7f:	ff 75 0c             	pushl  0xc(%ebp)
  800c82:	ff 75 08             	pushl  0x8(%ebp)
  800c85:	e8 70 02 00 00       	call   800efa <printfmt>
  800c8a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c8d:	e9 5b 02 00 00       	jmp    800eed <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c92:	56                   	push   %esi
  800c93:	68 8e 42 80 00       	push   $0x80428e
  800c98:	ff 75 0c             	pushl  0xc(%ebp)
  800c9b:	ff 75 08             	pushl  0x8(%ebp)
  800c9e:	e8 57 02 00 00       	call   800efa <printfmt>
  800ca3:	83 c4 10             	add    $0x10,%esp
			break;
  800ca6:	e9 42 02 00 00       	jmp    800eed <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cab:	8b 45 14             	mov    0x14(%ebp),%eax
  800cae:	83 c0 04             	add    $0x4,%eax
  800cb1:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb7:	83 e8 04             	sub    $0x4,%eax
  800cba:	8b 30                	mov    (%eax),%esi
  800cbc:	85 f6                	test   %esi,%esi
  800cbe:	75 05                	jne    800cc5 <vprintfmt+0x1a6>
				p = "(null)";
  800cc0:	be 91 42 80 00       	mov    $0x804291,%esi
			if (width > 0 && padc != '-')
  800cc5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cc9:	7e 6d                	jle    800d38 <vprintfmt+0x219>
  800ccb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ccf:	74 67                	je     800d38 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cd4:	83 ec 08             	sub    $0x8,%esp
  800cd7:	50                   	push   %eax
  800cd8:	56                   	push   %esi
  800cd9:	e8 1e 03 00 00       	call   800ffc <strnlen>
  800cde:	83 c4 10             	add    $0x10,%esp
  800ce1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ce4:	eb 16                	jmp    800cfc <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ce6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800cea:	83 ec 08             	sub    $0x8,%esp
  800ced:	ff 75 0c             	pushl  0xc(%ebp)
  800cf0:	50                   	push   %eax
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	ff d0                	call   *%eax
  800cf6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cf9:	ff 4d e4             	decl   -0x1c(%ebp)
  800cfc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d00:	7f e4                	jg     800ce6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d02:	eb 34                	jmp    800d38 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d04:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d08:	74 1c                	je     800d26 <vprintfmt+0x207>
  800d0a:	83 fb 1f             	cmp    $0x1f,%ebx
  800d0d:	7e 05                	jle    800d14 <vprintfmt+0x1f5>
  800d0f:	83 fb 7e             	cmp    $0x7e,%ebx
  800d12:	7e 12                	jle    800d26 <vprintfmt+0x207>
					putch('?', putdat);
  800d14:	83 ec 08             	sub    $0x8,%esp
  800d17:	ff 75 0c             	pushl  0xc(%ebp)
  800d1a:	6a 3f                	push   $0x3f
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	ff d0                	call   *%eax
  800d21:	83 c4 10             	add    $0x10,%esp
  800d24:	eb 0f                	jmp    800d35 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d26:	83 ec 08             	sub    $0x8,%esp
  800d29:	ff 75 0c             	pushl  0xc(%ebp)
  800d2c:	53                   	push   %ebx
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d30:	ff d0                	call   *%eax
  800d32:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d35:	ff 4d e4             	decl   -0x1c(%ebp)
  800d38:	89 f0                	mov    %esi,%eax
  800d3a:	8d 70 01             	lea    0x1(%eax),%esi
  800d3d:	8a 00                	mov    (%eax),%al
  800d3f:	0f be d8             	movsbl %al,%ebx
  800d42:	85 db                	test   %ebx,%ebx
  800d44:	74 24                	je     800d6a <vprintfmt+0x24b>
  800d46:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d4a:	78 b8                	js     800d04 <vprintfmt+0x1e5>
  800d4c:	ff 4d e0             	decl   -0x20(%ebp)
  800d4f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d53:	79 af                	jns    800d04 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d55:	eb 13                	jmp    800d6a <vprintfmt+0x24b>
				putch(' ', putdat);
  800d57:	83 ec 08             	sub    $0x8,%esp
  800d5a:	ff 75 0c             	pushl  0xc(%ebp)
  800d5d:	6a 20                	push   $0x20
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	ff d0                	call   *%eax
  800d64:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d67:	ff 4d e4             	decl   -0x1c(%ebp)
  800d6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d6e:	7f e7                	jg     800d57 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d70:	e9 78 01 00 00       	jmp    800eed <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d75:	83 ec 08             	sub    $0x8,%esp
  800d78:	ff 75 e8             	pushl  -0x18(%ebp)
  800d7b:	8d 45 14             	lea    0x14(%ebp),%eax
  800d7e:	50                   	push   %eax
  800d7f:	e8 3c fd ff ff       	call   800ac0 <getint>
  800d84:	83 c4 10             	add    $0x10,%esp
  800d87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d8a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d93:	85 d2                	test   %edx,%edx
  800d95:	79 23                	jns    800dba <vprintfmt+0x29b>
				putch('-', putdat);
  800d97:	83 ec 08             	sub    $0x8,%esp
  800d9a:	ff 75 0c             	pushl  0xc(%ebp)
  800d9d:	6a 2d                	push   $0x2d
  800d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800da2:	ff d0                	call   *%eax
  800da4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800daa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dad:	f7 d8                	neg    %eax
  800daf:	83 d2 00             	adc    $0x0,%edx
  800db2:	f7 da                	neg    %edx
  800db4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800db7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800dba:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800dc1:	e9 bc 00 00 00       	jmp    800e82 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800dc6:	83 ec 08             	sub    $0x8,%esp
  800dc9:	ff 75 e8             	pushl  -0x18(%ebp)
  800dcc:	8d 45 14             	lea    0x14(%ebp),%eax
  800dcf:	50                   	push   %eax
  800dd0:	e8 84 fc ff ff       	call   800a59 <getuint>
  800dd5:	83 c4 10             	add    $0x10,%esp
  800dd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ddb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800dde:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800de5:	e9 98 00 00 00       	jmp    800e82 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800dea:	83 ec 08             	sub    $0x8,%esp
  800ded:	ff 75 0c             	pushl  0xc(%ebp)
  800df0:	6a 58                	push   $0x58
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	ff d0                	call   *%eax
  800df7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800dfa:	83 ec 08             	sub    $0x8,%esp
  800dfd:	ff 75 0c             	pushl  0xc(%ebp)
  800e00:	6a 58                	push   $0x58
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	ff d0                	call   *%eax
  800e07:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e0a:	83 ec 08             	sub    $0x8,%esp
  800e0d:	ff 75 0c             	pushl  0xc(%ebp)
  800e10:	6a 58                	push   $0x58
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	ff d0                	call   *%eax
  800e17:	83 c4 10             	add    $0x10,%esp
			break;
  800e1a:	e9 ce 00 00 00       	jmp    800eed <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800e1f:	83 ec 08             	sub    $0x8,%esp
  800e22:	ff 75 0c             	pushl  0xc(%ebp)
  800e25:	6a 30                	push   $0x30
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	ff d0                	call   *%eax
  800e2c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e2f:	83 ec 08             	sub    $0x8,%esp
  800e32:	ff 75 0c             	pushl  0xc(%ebp)
  800e35:	6a 78                	push   $0x78
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3a:	ff d0                	call   *%eax
  800e3c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e42:	83 c0 04             	add    $0x4,%eax
  800e45:	89 45 14             	mov    %eax,0x14(%ebp)
  800e48:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4b:	83 e8 04             	sub    $0x4,%eax
  800e4e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e5a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e61:	eb 1f                	jmp    800e82 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e63:	83 ec 08             	sub    $0x8,%esp
  800e66:	ff 75 e8             	pushl  -0x18(%ebp)
  800e69:	8d 45 14             	lea    0x14(%ebp),%eax
  800e6c:	50                   	push   %eax
  800e6d:	e8 e7 fb ff ff       	call   800a59 <getuint>
  800e72:	83 c4 10             	add    $0x10,%esp
  800e75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e78:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e7b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e82:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e89:	83 ec 04             	sub    $0x4,%esp
  800e8c:	52                   	push   %edx
  800e8d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e90:	50                   	push   %eax
  800e91:	ff 75 f4             	pushl  -0xc(%ebp)
  800e94:	ff 75 f0             	pushl  -0x10(%ebp)
  800e97:	ff 75 0c             	pushl  0xc(%ebp)
  800e9a:	ff 75 08             	pushl  0x8(%ebp)
  800e9d:	e8 00 fb ff ff       	call   8009a2 <printnum>
  800ea2:	83 c4 20             	add    $0x20,%esp
			break;
  800ea5:	eb 46                	jmp    800eed <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ea7:	83 ec 08             	sub    $0x8,%esp
  800eaa:	ff 75 0c             	pushl  0xc(%ebp)
  800ead:	53                   	push   %ebx
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	ff d0                	call   *%eax
  800eb3:	83 c4 10             	add    $0x10,%esp
			break;
  800eb6:	eb 35                	jmp    800eed <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800eb8:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800ebf:	eb 2c                	jmp    800eed <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ec1:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800ec8:	eb 23                	jmp    800eed <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800eca:	83 ec 08             	sub    $0x8,%esp
  800ecd:	ff 75 0c             	pushl  0xc(%ebp)
  800ed0:	6a 25                	push   $0x25
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	ff d0                	call   *%eax
  800ed7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800eda:	ff 4d 10             	decl   0x10(%ebp)
  800edd:	eb 03                	jmp    800ee2 <vprintfmt+0x3c3>
  800edf:	ff 4d 10             	decl   0x10(%ebp)
  800ee2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee5:	48                   	dec    %eax
  800ee6:	8a 00                	mov    (%eax),%al
  800ee8:	3c 25                	cmp    $0x25,%al
  800eea:	75 f3                	jne    800edf <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800eec:	90                   	nop
		}
	}
  800eed:	e9 35 fc ff ff       	jmp    800b27 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ef2:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ef3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ef6:	5b                   	pop    %ebx
  800ef7:	5e                   	pop    %esi
  800ef8:	5d                   	pop    %ebp
  800ef9:	c3                   	ret    

00800efa <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f00:	8d 45 10             	lea    0x10(%ebp),%eax
  800f03:	83 c0 04             	add    $0x4,%eax
  800f06:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f09:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f0f:	50                   	push   %eax
  800f10:	ff 75 0c             	pushl  0xc(%ebp)
  800f13:	ff 75 08             	pushl  0x8(%ebp)
  800f16:	e8 04 fc ff ff       	call   800b1f <vprintfmt>
  800f1b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f1e:	90                   	nop
  800f1f:	c9                   	leave  
  800f20:	c3                   	ret    

00800f21 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f27:	8b 40 08             	mov    0x8(%eax),%eax
  800f2a:	8d 50 01             	lea    0x1(%eax),%edx
  800f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f30:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f36:	8b 10                	mov    (%eax),%edx
  800f38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3b:	8b 40 04             	mov    0x4(%eax),%eax
  800f3e:	39 c2                	cmp    %eax,%edx
  800f40:	73 12                	jae    800f54 <sprintputch+0x33>
		*b->buf++ = ch;
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	8b 00                	mov    (%eax),%eax
  800f47:	8d 48 01             	lea    0x1(%eax),%ecx
  800f4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f4d:	89 0a                	mov    %ecx,(%edx)
  800f4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f52:	88 10                	mov    %dl,(%eax)
}
  800f54:	90                   	nop
  800f55:	5d                   	pop    %ebp
  800f56:	c3                   	ret    

00800f57 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f57:	55                   	push   %ebp
  800f58:	89 e5                	mov    %esp,%ebp
  800f5a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f60:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f66:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	01 d0                	add    %edx,%eax
  800f6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f7c:	74 06                	je     800f84 <vsnprintf+0x2d>
  800f7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f82:	7f 07                	jg     800f8b <vsnprintf+0x34>
		return -E_INVAL;
  800f84:	b8 03 00 00 00       	mov    $0x3,%eax
  800f89:	eb 20                	jmp    800fab <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f8b:	ff 75 14             	pushl  0x14(%ebp)
  800f8e:	ff 75 10             	pushl  0x10(%ebp)
  800f91:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f94:	50                   	push   %eax
  800f95:	68 21 0f 80 00       	push   $0x800f21
  800f9a:	e8 80 fb ff ff       	call   800b1f <vprintfmt>
  800f9f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fa5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fab:	c9                   	leave  
  800fac:	c3                   	ret    

00800fad <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fb3:	8d 45 10             	lea    0x10(%ebp),%eax
  800fb6:	83 c0 04             	add    $0x4,%eax
  800fb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fbc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbf:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc2:	50                   	push   %eax
  800fc3:	ff 75 0c             	pushl  0xc(%ebp)
  800fc6:	ff 75 08             	pushl  0x8(%ebp)
  800fc9:	e8 89 ff ff ff       	call   800f57 <vsnprintf>
  800fce:	83 c4 10             	add    $0x10,%esp
  800fd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800fd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fd7:	c9                   	leave  
  800fd8:	c3                   	ret    

00800fd9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800fdf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fe6:	eb 06                	jmp    800fee <strlen+0x15>
		n++;
  800fe8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800feb:	ff 45 08             	incl   0x8(%ebp)
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	8a 00                	mov    (%eax),%al
  800ff3:	84 c0                	test   %al,%al
  800ff5:	75 f1                	jne    800fe8 <strlen+0xf>
		n++;
	return n;
  800ff7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ffa:	c9                   	leave  
  800ffb:	c3                   	ret    

00800ffc <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ffc:	55                   	push   %ebp
  800ffd:	89 e5                	mov    %esp,%ebp
  800fff:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801002:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801009:	eb 09                	jmp    801014 <strnlen+0x18>
		n++;
  80100b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80100e:	ff 45 08             	incl   0x8(%ebp)
  801011:	ff 4d 0c             	decl   0xc(%ebp)
  801014:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801018:	74 09                	je     801023 <strnlen+0x27>
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	84 c0                	test   %al,%al
  801021:	75 e8                	jne    80100b <strnlen+0xf>
		n++;
	return n;
  801023:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801034:	90                   	nop
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	8d 50 01             	lea    0x1(%eax),%edx
  80103b:	89 55 08             	mov    %edx,0x8(%ebp)
  80103e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801041:	8d 4a 01             	lea    0x1(%edx),%ecx
  801044:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801047:	8a 12                	mov    (%edx),%dl
  801049:	88 10                	mov    %dl,(%eax)
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	84 c0                	test   %al,%al
  80104f:	75 e4                	jne    801035 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801051:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801054:	c9                   	leave  
  801055:	c3                   	ret    

00801056 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801062:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801069:	eb 1f                	jmp    80108a <strncpy+0x34>
		*dst++ = *src;
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8d 50 01             	lea    0x1(%eax),%edx
  801071:	89 55 08             	mov    %edx,0x8(%ebp)
  801074:	8b 55 0c             	mov    0xc(%ebp),%edx
  801077:	8a 12                	mov    (%edx),%dl
  801079:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80107b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107e:	8a 00                	mov    (%eax),%al
  801080:	84 c0                	test   %al,%al
  801082:	74 03                	je     801087 <strncpy+0x31>
			src++;
  801084:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801087:	ff 45 fc             	incl   -0x4(%ebp)
  80108a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80108d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801090:	72 d9                	jb     80106b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801092:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801095:	c9                   	leave  
  801096:	c3                   	ret    

00801097 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
  80109a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a7:	74 30                	je     8010d9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010a9:	eb 16                	jmp    8010c1 <strlcpy+0x2a>
			*dst++ = *src++;
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8d 50 01             	lea    0x1(%eax),%edx
  8010b1:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010bd:	8a 12                	mov    (%edx),%dl
  8010bf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010c1:	ff 4d 10             	decl   0x10(%ebp)
  8010c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010c8:	74 09                	je     8010d3 <strlcpy+0x3c>
  8010ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	84 c0                	test   %al,%al
  8010d1:	75 d8                	jne    8010ab <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010df:	29 c2                	sub    %eax,%edx
  8010e1:	89 d0                	mov    %edx,%eax
}
  8010e3:	c9                   	leave  
  8010e4:	c3                   	ret    

008010e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010e5:	55                   	push   %ebp
  8010e6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8010e8:	eb 06                	jmp    8010f0 <strcmp+0xb>
		p++, q++;
  8010ea:	ff 45 08             	incl   0x8(%ebp)
  8010ed:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	8a 00                	mov    (%eax),%al
  8010f5:	84 c0                	test   %al,%al
  8010f7:	74 0e                	je     801107 <strcmp+0x22>
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	8a 10                	mov    (%eax),%dl
  8010fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801101:	8a 00                	mov    (%eax),%al
  801103:	38 c2                	cmp    %al,%dl
  801105:	74 e3                	je     8010ea <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	8a 00                	mov    (%eax),%al
  80110c:	0f b6 d0             	movzbl %al,%edx
  80110f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801112:	8a 00                	mov    (%eax),%al
  801114:	0f b6 c0             	movzbl %al,%eax
  801117:	29 c2                	sub    %eax,%edx
  801119:	89 d0                	mov    %edx,%eax
}
  80111b:	5d                   	pop    %ebp
  80111c:	c3                   	ret    

0080111d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80111d:	55                   	push   %ebp
  80111e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801120:	eb 09                	jmp    80112b <strncmp+0xe>
		n--, p++, q++;
  801122:	ff 4d 10             	decl   0x10(%ebp)
  801125:	ff 45 08             	incl   0x8(%ebp)
  801128:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80112b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80112f:	74 17                	je     801148 <strncmp+0x2b>
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	8a 00                	mov    (%eax),%al
  801136:	84 c0                	test   %al,%al
  801138:	74 0e                	je     801148 <strncmp+0x2b>
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	8a 10                	mov    (%eax),%dl
  80113f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	38 c2                	cmp    %al,%dl
  801146:	74 da                	je     801122 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801148:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80114c:	75 07                	jne    801155 <strncmp+0x38>
		return 0;
  80114e:	b8 00 00 00 00       	mov    $0x0,%eax
  801153:	eb 14                	jmp    801169 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	8a 00                	mov    (%eax),%al
  80115a:	0f b6 d0             	movzbl %al,%edx
  80115d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	0f b6 c0             	movzbl %al,%eax
  801165:	29 c2                	sub    %eax,%edx
  801167:	89 d0                	mov    %edx,%eax
}
  801169:	5d                   	pop    %ebp
  80116a:	c3                   	ret    

0080116b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80116b:	55                   	push   %ebp
  80116c:	89 e5                	mov    %esp,%ebp
  80116e:	83 ec 04             	sub    $0x4,%esp
  801171:	8b 45 0c             	mov    0xc(%ebp),%eax
  801174:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801177:	eb 12                	jmp    80118b <strchr+0x20>
		if (*s == c)
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801181:	75 05                	jne    801188 <strchr+0x1d>
			return (char *) s;
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	eb 11                	jmp    801199 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801188:	ff 45 08             	incl   0x8(%ebp)
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	8a 00                	mov    (%eax),%al
  801190:	84 c0                	test   %al,%al
  801192:	75 e5                	jne    801179 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801194:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801199:	c9                   	leave  
  80119a:	c3                   	ret    

0080119b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
  80119e:	83 ec 04             	sub    $0x4,%esp
  8011a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011a7:	eb 0d                	jmp    8011b6 <strfind+0x1b>
		if (*s == c)
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011b1:	74 0e                	je     8011c1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011b3:	ff 45 08             	incl   0x8(%ebp)
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b9:	8a 00                	mov    (%eax),%al
  8011bb:	84 c0                	test   %al,%al
  8011bd:	75 ea                	jne    8011a9 <strfind+0xe>
  8011bf:	eb 01                	jmp    8011c2 <strfind+0x27>
		if (*s == c)
			break;
  8011c1:	90                   	nop
	return (char *) s;
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011c5:	c9                   	leave  
  8011c6:	c3                   	ret    

008011c7 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8011d3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011d7:	76 63                	jbe    80123c <memset+0x75>
		uint64 data_block = c;
  8011d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011dc:	99                   	cltd   
  8011dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8011e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011e9:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8011ed:	c1 e0 08             	shl    $0x8,%eax
  8011f0:	09 45 f0             	or     %eax,-0x10(%ebp)
  8011f3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8011f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011fc:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801200:	c1 e0 10             	shl    $0x10,%eax
  801203:	09 45 f0             	or     %eax,-0x10(%ebp)
  801206:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801209:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80120c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80120f:	89 c2                	mov    %eax,%edx
  801211:	b8 00 00 00 00       	mov    $0x0,%eax
  801216:	09 45 f0             	or     %eax,-0x10(%ebp)
  801219:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80121c:	eb 18                	jmp    801236 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80121e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801221:	8d 41 08             	lea    0x8(%ecx),%eax
  801224:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801227:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80122a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122d:	89 01                	mov    %eax,(%ecx)
  80122f:	89 51 04             	mov    %edx,0x4(%ecx)
  801232:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801236:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80123a:	77 e2                	ja     80121e <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80123c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801240:	74 23                	je     801265 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801242:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801245:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801248:	eb 0e                	jmp    801258 <memset+0x91>
			*p8++ = (uint8)c;
  80124a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124d:	8d 50 01             	lea    0x1(%eax),%edx
  801250:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801253:	8b 55 0c             	mov    0xc(%ebp),%edx
  801256:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801258:	8b 45 10             	mov    0x10(%ebp),%eax
  80125b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80125e:	89 55 10             	mov    %edx,0x10(%ebp)
  801261:	85 c0                	test   %eax,%eax
  801263:	75 e5                	jne    80124a <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801265:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801268:	c9                   	leave  
  801269:	c3                   	ret    

0080126a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80126a:	55                   	push   %ebp
  80126b:	89 e5                	mov    %esp,%ebp
  80126d:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801270:	8b 45 0c             	mov    0xc(%ebp),%eax
  801273:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801276:	8b 45 08             	mov    0x8(%ebp),%eax
  801279:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80127c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801280:	76 24                	jbe    8012a6 <memcpy+0x3c>
		while(n >= 8){
  801282:	eb 1c                	jmp    8012a0 <memcpy+0x36>
			*d64 = *s64;
  801284:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801287:	8b 50 04             	mov    0x4(%eax),%edx
  80128a:	8b 00                	mov    (%eax),%eax
  80128c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80128f:	89 01                	mov    %eax,(%ecx)
  801291:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801294:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801298:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80129c:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8012a0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012a4:	77 de                	ja     801284 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8012a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012aa:	74 31                	je     8012dd <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8012ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012af:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8012b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8012b8:	eb 16                	jmp    8012d0 <memcpy+0x66>
			*d8++ = *s8++;
  8012ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012bd:	8d 50 01             	lea    0x1(%eax),%edx
  8012c0:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8012c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012c9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8012cc:	8a 12                	mov    (%edx),%dl
  8012ce:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8012d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	75 dd                	jne    8012ba <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8012dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012e0:	c9                   	leave  
  8012e1:	c3                   	ret    

008012e2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
  8012e5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012fa:	73 50                	jae    80134c <memmove+0x6a>
  8012fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801302:	01 d0                	add    %edx,%eax
  801304:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801307:	76 43                	jbe    80134c <memmove+0x6a>
		s += n;
  801309:	8b 45 10             	mov    0x10(%ebp),%eax
  80130c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80130f:	8b 45 10             	mov    0x10(%ebp),%eax
  801312:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801315:	eb 10                	jmp    801327 <memmove+0x45>
			*--d = *--s;
  801317:	ff 4d f8             	decl   -0x8(%ebp)
  80131a:	ff 4d fc             	decl   -0x4(%ebp)
  80131d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801320:	8a 10                	mov    (%eax),%dl
  801322:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801325:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801327:	8b 45 10             	mov    0x10(%ebp),%eax
  80132a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80132d:	89 55 10             	mov    %edx,0x10(%ebp)
  801330:	85 c0                	test   %eax,%eax
  801332:	75 e3                	jne    801317 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801334:	eb 23                	jmp    801359 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801336:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801339:	8d 50 01             	lea    0x1(%eax),%edx
  80133c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80133f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801342:	8d 4a 01             	lea    0x1(%edx),%ecx
  801345:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801348:	8a 12                	mov    (%edx),%dl
  80134a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80134c:	8b 45 10             	mov    0x10(%ebp),%eax
  80134f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801352:	89 55 10             	mov    %edx,0x10(%ebp)
  801355:	85 c0                	test   %eax,%eax
  801357:	75 dd                	jne    801336 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    

0080135e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
  801361:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801364:	8b 45 08             	mov    0x8(%ebp),%eax
  801367:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80136a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801370:	eb 2a                	jmp    80139c <memcmp+0x3e>
		if (*s1 != *s2)
  801372:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801375:	8a 10                	mov    (%eax),%dl
  801377:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80137a:	8a 00                	mov    (%eax),%al
  80137c:	38 c2                	cmp    %al,%dl
  80137e:	74 16                	je     801396 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801380:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801383:	8a 00                	mov    (%eax),%al
  801385:	0f b6 d0             	movzbl %al,%edx
  801388:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80138b:	8a 00                	mov    (%eax),%al
  80138d:	0f b6 c0             	movzbl %al,%eax
  801390:	29 c2                	sub    %eax,%edx
  801392:	89 d0                	mov    %edx,%eax
  801394:	eb 18                	jmp    8013ae <memcmp+0x50>
		s1++, s2++;
  801396:	ff 45 fc             	incl   -0x4(%ebp)
  801399:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80139c:	8b 45 10             	mov    0x10(%ebp),%eax
  80139f:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8013a5:	85 c0                	test   %eax,%eax
  8013a7:	75 c9                	jne    801372 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ae:	c9                   	leave  
  8013af:	c3                   	ret    

008013b0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
  8013b3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bc:	01 d0                	add    %edx,%eax
  8013be:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013c1:	eb 15                	jmp    8013d8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	8a 00                	mov    (%eax),%al
  8013c8:	0f b6 d0             	movzbl %al,%edx
  8013cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ce:	0f b6 c0             	movzbl %al,%eax
  8013d1:	39 c2                	cmp    %eax,%edx
  8013d3:	74 0d                	je     8013e2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013d5:	ff 45 08             	incl   0x8(%ebp)
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013de:	72 e3                	jb     8013c3 <memfind+0x13>
  8013e0:	eb 01                	jmp    8013e3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013e2:	90                   	nop
	return (void *) s;
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013e6:	c9                   	leave  
  8013e7:	c3                   	ret    

008013e8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
  8013eb:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013f5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013fc:	eb 03                	jmp    801401 <strtol+0x19>
		s++;
  8013fe:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	8a 00                	mov    (%eax),%al
  801406:	3c 20                	cmp    $0x20,%al
  801408:	74 f4                	je     8013fe <strtol+0x16>
  80140a:	8b 45 08             	mov    0x8(%ebp),%eax
  80140d:	8a 00                	mov    (%eax),%al
  80140f:	3c 09                	cmp    $0x9,%al
  801411:	74 eb                	je     8013fe <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	8a 00                	mov    (%eax),%al
  801418:	3c 2b                	cmp    $0x2b,%al
  80141a:	75 05                	jne    801421 <strtol+0x39>
		s++;
  80141c:	ff 45 08             	incl   0x8(%ebp)
  80141f:	eb 13                	jmp    801434 <strtol+0x4c>
	else if (*s == '-')
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	8a 00                	mov    (%eax),%al
  801426:	3c 2d                	cmp    $0x2d,%al
  801428:	75 0a                	jne    801434 <strtol+0x4c>
		s++, neg = 1;
  80142a:	ff 45 08             	incl   0x8(%ebp)
  80142d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801434:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801438:	74 06                	je     801440 <strtol+0x58>
  80143a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80143e:	75 20                	jne    801460 <strtol+0x78>
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	3c 30                	cmp    $0x30,%al
  801447:	75 17                	jne    801460 <strtol+0x78>
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	40                   	inc    %eax
  80144d:	8a 00                	mov    (%eax),%al
  80144f:	3c 78                	cmp    $0x78,%al
  801451:	75 0d                	jne    801460 <strtol+0x78>
		s += 2, base = 16;
  801453:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801457:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80145e:	eb 28                	jmp    801488 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801460:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801464:	75 15                	jne    80147b <strtol+0x93>
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	8a 00                	mov    (%eax),%al
  80146b:	3c 30                	cmp    $0x30,%al
  80146d:	75 0c                	jne    80147b <strtol+0x93>
		s++, base = 8;
  80146f:	ff 45 08             	incl   0x8(%ebp)
  801472:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801479:	eb 0d                	jmp    801488 <strtol+0xa0>
	else if (base == 0)
  80147b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80147f:	75 07                	jne    801488 <strtol+0xa0>
		base = 10;
  801481:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	8a 00                	mov    (%eax),%al
  80148d:	3c 2f                	cmp    $0x2f,%al
  80148f:	7e 19                	jle    8014aa <strtol+0xc2>
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
  801494:	8a 00                	mov    (%eax),%al
  801496:	3c 39                	cmp    $0x39,%al
  801498:	7f 10                	jg     8014aa <strtol+0xc2>
			dig = *s - '0';
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	8a 00                	mov    (%eax),%al
  80149f:	0f be c0             	movsbl %al,%eax
  8014a2:	83 e8 30             	sub    $0x30,%eax
  8014a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014a8:	eb 42                	jmp    8014ec <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	3c 60                	cmp    $0x60,%al
  8014b1:	7e 19                	jle    8014cc <strtol+0xe4>
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	8a 00                	mov    (%eax),%al
  8014b8:	3c 7a                	cmp    $0x7a,%al
  8014ba:	7f 10                	jg     8014cc <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	8a 00                	mov    (%eax),%al
  8014c1:	0f be c0             	movsbl %al,%eax
  8014c4:	83 e8 57             	sub    $0x57,%eax
  8014c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014ca:	eb 20                	jmp    8014ec <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	8a 00                	mov    (%eax),%al
  8014d1:	3c 40                	cmp    $0x40,%al
  8014d3:	7e 39                	jle    80150e <strtol+0x126>
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d8:	8a 00                	mov    (%eax),%al
  8014da:	3c 5a                	cmp    $0x5a,%al
  8014dc:	7f 30                	jg     80150e <strtol+0x126>
			dig = *s - 'A' + 10;
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	8a 00                	mov    (%eax),%al
  8014e3:	0f be c0             	movsbl %al,%eax
  8014e6:	83 e8 37             	sub    $0x37,%eax
  8014e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ef:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014f2:	7d 19                	jge    80150d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014f4:	ff 45 08             	incl   0x8(%ebp)
  8014f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014fa:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014fe:	89 c2                	mov    %eax,%edx
  801500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801503:	01 d0                	add    %edx,%eax
  801505:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801508:	e9 7b ff ff ff       	jmp    801488 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80150d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80150e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801512:	74 08                	je     80151c <strtol+0x134>
		*endptr = (char *) s;
  801514:	8b 45 0c             	mov    0xc(%ebp),%eax
  801517:	8b 55 08             	mov    0x8(%ebp),%edx
  80151a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80151c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801520:	74 07                	je     801529 <strtol+0x141>
  801522:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801525:	f7 d8                	neg    %eax
  801527:	eb 03                	jmp    80152c <strtol+0x144>
  801529:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80152c:	c9                   	leave  
  80152d:	c3                   	ret    

0080152e <ltostr>:

void
ltostr(long value, char *str)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801534:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80153b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801542:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801546:	79 13                	jns    80155b <ltostr+0x2d>
	{
		neg = 1;
  801548:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80154f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801552:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801555:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801558:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801563:	99                   	cltd   
  801564:	f7 f9                	idiv   %ecx
  801566:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801569:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156c:	8d 50 01             	lea    0x1(%eax),%edx
  80156f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801572:	89 c2                	mov    %eax,%edx
  801574:	8b 45 0c             	mov    0xc(%ebp),%eax
  801577:	01 d0                	add    %edx,%eax
  801579:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80157c:	83 c2 30             	add    $0x30,%edx
  80157f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801581:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801584:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801589:	f7 e9                	imul   %ecx
  80158b:	c1 fa 02             	sar    $0x2,%edx
  80158e:	89 c8                	mov    %ecx,%eax
  801590:	c1 f8 1f             	sar    $0x1f,%eax
  801593:	29 c2                	sub    %eax,%edx
  801595:	89 d0                	mov    %edx,%eax
  801597:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80159a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80159e:	75 bb                	jne    80155b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015aa:	48                   	dec    %eax
  8015ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015b2:	74 3d                	je     8015f1 <ltostr+0xc3>
		start = 1 ;
  8015b4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015bb:	eb 34                	jmp    8015f1 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8015bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c3:	01 d0                	add    %edx,%eax
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d0:	01 c2                	add    %eax,%edx
  8015d2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d8:	01 c8                	add    %ecx,%eax
  8015da:	8a 00                	mov    (%eax),%al
  8015dc:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e4:	01 c2                	add    %eax,%edx
  8015e6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015e9:	88 02                	mov    %al,(%edx)
		start++ ;
  8015eb:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015ee:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015f7:	7c c4                	jl     8015bd <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015f9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ff:	01 d0                	add    %edx,%eax
  801601:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801604:	90                   	nop
  801605:	c9                   	leave  
  801606:	c3                   	ret    

00801607 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
  80160a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80160d:	ff 75 08             	pushl  0x8(%ebp)
  801610:	e8 c4 f9 ff ff       	call   800fd9 <strlen>
  801615:	83 c4 04             	add    $0x4,%esp
  801618:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80161b:	ff 75 0c             	pushl  0xc(%ebp)
  80161e:	e8 b6 f9 ff ff       	call   800fd9 <strlen>
  801623:	83 c4 04             	add    $0x4,%esp
  801626:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801629:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801630:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801637:	eb 17                	jmp    801650 <strcconcat+0x49>
		final[s] = str1[s] ;
  801639:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80163c:	8b 45 10             	mov    0x10(%ebp),%eax
  80163f:	01 c2                	add    %eax,%edx
  801641:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801644:	8b 45 08             	mov    0x8(%ebp),%eax
  801647:	01 c8                	add    %ecx,%eax
  801649:	8a 00                	mov    (%eax),%al
  80164b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80164d:	ff 45 fc             	incl   -0x4(%ebp)
  801650:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801653:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801656:	7c e1                	jl     801639 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801658:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80165f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801666:	eb 1f                	jmp    801687 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801668:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80166b:	8d 50 01             	lea    0x1(%eax),%edx
  80166e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801671:	89 c2                	mov    %eax,%edx
  801673:	8b 45 10             	mov    0x10(%ebp),%eax
  801676:	01 c2                	add    %eax,%edx
  801678:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80167b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167e:	01 c8                	add    %ecx,%eax
  801680:	8a 00                	mov    (%eax),%al
  801682:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801684:	ff 45 f8             	incl   -0x8(%ebp)
  801687:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80168a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80168d:	7c d9                	jl     801668 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80168f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801692:	8b 45 10             	mov    0x10(%ebp),%eax
  801695:	01 d0                	add    %edx,%eax
  801697:	c6 00 00             	movb   $0x0,(%eax)
}
  80169a:	90                   	nop
  80169b:	c9                   	leave  
  80169c:	c3                   	ret    

0080169d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ac:	8b 00                	mov    (%eax),%eax
  8016ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b8:	01 d0                	add    %edx,%eax
  8016ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016c0:	eb 0c                	jmp    8016ce <strsplit+0x31>
			*string++ = 0;
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	8d 50 01             	lea    0x1(%eax),%edx
  8016c8:	89 55 08             	mov    %edx,0x8(%ebp)
  8016cb:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	8a 00                	mov    (%eax),%al
  8016d3:	84 c0                	test   %al,%al
  8016d5:	74 18                	je     8016ef <strsplit+0x52>
  8016d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016da:	8a 00                	mov    (%eax),%al
  8016dc:	0f be c0             	movsbl %al,%eax
  8016df:	50                   	push   %eax
  8016e0:	ff 75 0c             	pushl  0xc(%ebp)
  8016e3:	e8 83 fa ff ff       	call   80116b <strchr>
  8016e8:	83 c4 08             	add    $0x8,%esp
  8016eb:	85 c0                	test   %eax,%eax
  8016ed:	75 d3                	jne    8016c2 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8a 00                	mov    (%eax),%al
  8016f4:	84 c0                	test   %al,%al
  8016f6:	74 5a                	je     801752 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8016fb:	8b 00                	mov    (%eax),%eax
  8016fd:	83 f8 0f             	cmp    $0xf,%eax
  801700:	75 07                	jne    801709 <strsplit+0x6c>
		{
			return 0;
  801702:	b8 00 00 00 00       	mov    $0x0,%eax
  801707:	eb 66                	jmp    80176f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801709:	8b 45 14             	mov    0x14(%ebp),%eax
  80170c:	8b 00                	mov    (%eax),%eax
  80170e:	8d 48 01             	lea    0x1(%eax),%ecx
  801711:	8b 55 14             	mov    0x14(%ebp),%edx
  801714:	89 0a                	mov    %ecx,(%edx)
  801716:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80171d:	8b 45 10             	mov    0x10(%ebp),%eax
  801720:	01 c2                	add    %eax,%edx
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801727:	eb 03                	jmp    80172c <strsplit+0x8f>
			string++;
  801729:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	84 c0                	test   %al,%al
  801733:	74 8b                	je     8016c0 <strsplit+0x23>
  801735:	8b 45 08             	mov    0x8(%ebp),%eax
  801738:	8a 00                	mov    (%eax),%al
  80173a:	0f be c0             	movsbl %al,%eax
  80173d:	50                   	push   %eax
  80173e:	ff 75 0c             	pushl  0xc(%ebp)
  801741:	e8 25 fa ff ff       	call   80116b <strchr>
  801746:	83 c4 08             	add    $0x8,%esp
  801749:	85 c0                	test   %eax,%eax
  80174b:	74 dc                	je     801729 <strsplit+0x8c>
			string++;
	}
  80174d:	e9 6e ff ff ff       	jmp    8016c0 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801752:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801753:	8b 45 14             	mov    0x14(%ebp),%eax
  801756:	8b 00                	mov    (%eax),%eax
  801758:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80175f:	8b 45 10             	mov    0x10(%ebp),%eax
  801762:	01 d0                	add    %edx,%eax
  801764:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80176a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
  801774:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801777:	8b 45 08             	mov    0x8(%ebp),%eax
  80177a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80177d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801784:	eb 4a                	jmp    8017d0 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801786:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801789:	8b 45 08             	mov    0x8(%ebp),%eax
  80178c:	01 c2                	add    %eax,%edx
  80178e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801791:	8b 45 0c             	mov    0xc(%ebp),%eax
  801794:	01 c8                	add    %ecx,%eax
  801796:	8a 00                	mov    (%eax),%al
  801798:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80179a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80179d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a0:	01 d0                	add    %edx,%eax
  8017a2:	8a 00                	mov    (%eax),%al
  8017a4:	3c 40                	cmp    $0x40,%al
  8017a6:	7e 25                	jle    8017cd <str2lower+0x5c>
  8017a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ae:	01 d0                	add    %edx,%eax
  8017b0:	8a 00                	mov    (%eax),%al
  8017b2:	3c 5a                	cmp    $0x5a,%al
  8017b4:	7f 17                	jg     8017cd <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8017b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bc:	01 d0                	add    %edx,%eax
  8017be:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c4:	01 ca                	add    %ecx,%edx
  8017c6:	8a 12                	mov    (%edx),%dl
  8017c8:	83 c2 20             	add    $0x20,%edx
  8017cb:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8017cd:	ff 45 fc             	incl   -0x4(%ebp)
  8017d0:	ff 75 0c             	pushl  0xc(%ebp)
  8017d3:	e8 01 f8 ff ff       	call   800fd9 <strlen>
  8017d8:	83 c4 04             	add    $0x4,%esp
  8017db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8017de:	7f a6                	jg     801786 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8017e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017e3:	c9                   	leave  
  8017e4:	c3                   	ret    

008017e5 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
  8017e8:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  8017eb:	83 ec 0c             	sub    $0xc,%esp
  8017ee:	6a 10                	push   $0x10
  8017f0:	e8 b2 15 00 00       	call   802da7 <alloc_block>
  8017f5:	83 c4 10             	add    $0x10,%esp
  8017f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  8017fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017ff:	75 14                	jne    801815 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  801801:	83 ec 04             	sub    $0x4,%esp
  801804:	68 08 44 80 00       	push   $0x804408
  801809:	6a 14                	push   $0x14
  80180b:	68 31 44 80 00       	push   $0x804431
  801810:	e8 d5 20 00 00       	call   8038ea <_panic>

	node->start = start;
  801815:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801818:	8b 55 08             	mov    0x8(%ebp),%edx
  80181b:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  80181d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801820:	8b 55 0c             	mov    0xc(%ebp),%edx
  801823:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  801826:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  80182d:	a1 24 50 80 00       	mov    0x805024,%eax
  801832:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801835:	eb 18                	jmp    80184f <insert_page_alloc+0x6a>
		if (start < it->start)
  801837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183a:	8b 00                	mov    (%eax),%eax
  80183c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80183f:	77 37                	ja     801878 <insert_page_alloc+0x93>
			break;
		prev = it;
  801841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801844:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  801847:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80184c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80184f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801853:	74 08                	je     80185d <insert_page_alloc+0x78>
  801855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801858:	8b 40 08             	mov    0x8(%eax),%eax
  80185b:	eb 05                	jmp    801862 <insert_page_alloc+0x7d>
  80185d:	b8 00 00 00 00       	mov    $0x0,%eax
  801862:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801867:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80186c:	85 c0                	test   %eax,%eax
  80186e:	75 c7                	jne    801837 <insert_page_alloc+0x52>
  801870:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801874:	75 c1                	jne    801837 <insert_page_alloc+0x52>
  801876:	eb 01                	jmp    801879 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  801878:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  801879:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80187d:	75 64                	jne    8018e3 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  80187f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801883:	75 14                	jne    801899 <insert_page_alloc+0xb4>
  801885:	83 ec 04             	sub    $0x4,%esp
  801888:	68 40 44 80 00       	push   $0x804440
  80188d:	6a 21                	push   $0x21
  80188f:	68 31 44 80 00       	push   $0x804431
  801894:	e8 51 20 00 00       	call   8038ea <_panic>
  801899:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80189f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018a2:	89 50 08             	mov    %edx,0x8(%eax)
  8018a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018a8:	8b 40 08             	mov    0x8(%eax),%eax
  8018ab:	85 c0                	test   %eax,%eax
  8018ad:	74 0d                	je     8018bc <insert_page_alloc+0xd7>
  8018af:	a1 24 50 80 00       	mov    0x805024,%eax
  8018b4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018b7:	89 50 0c             	mov    %edx,0xc(%eax)
  8018ba:	eb 08                	jmp    8018c4 <insert_page_alloc+0xdf>
  8018bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018bf:	a3 28 50 80 00       	mov    %eax,0x805028
  8018c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018c7:	a3 24 50 80 00       	mov    %eax,0x805024
  8018cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018cf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8018d6:	a1 30 50 80 00       	mov    0x805030,%eax
  8018db:	40                   	inc    %eax
  8018dc:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  8018e1:	eb 71                	jmp    801954 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  8018e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8018e7:	74 06                	je     8018ef <insert_page_alloc+0x10a>
  8018e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018ed:	75 14                	jne    801903 <insert_page_alloc+0x11e>
  8018ef:	83 ec 04             	sub    $0x4,%esp
  8018f2:	68 64 44 80 00       	push   $0x804464
  8018f7:	6a 23                	push   $0x23
  8018f9:	68 31 44 80 00       	push   $0x804431
  8018fe:	e8 e7 1f 00 00       	call   8038ea <_panic>
  801903:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801906:	8b 50 08             	mov    0x8(%eax),%edx
  801909:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80190c:	89 50 08             	mov    %edx,0x8(%eax)
  80190f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801912:	8b 40 08             	mov    0x8(%eax),%eax
  801915:	85 c0                	test   %eax,%eax
  801917:	74 0c                	je     801925 <insert_page_alloc+0x140>
  801919:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191c:	8b 40 08             	mov    0x8(%eax),%eax
  80191f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801922:	89 50 0c             	mov    %edx,0xc(%eax)
  801925:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801928:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80192b:	89 50 08             	mov    %edx,0x8(%eax)
  80192e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801931:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801934:	89 50 0c             	mov    %edx,0xc(%eax)
  801937:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80193a:	8b 40 08             	mov    0x8(%eax),%eax
  80193d:	85 c0                	test   %eax,%eax
  80193f:	75 08                	jne    801949 <insert_page_alloc+0x164>
  801941:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801944:	a3 28 50 80 00       	mov    %eax,0x805028
  801949:	a1 30 50 80 00       	mov    0x805030,%eax
  80194e:	40                   	inc    %eax
  80194f:	a3 30 50 80 00       	mov    %eax,0x805030
}
  801954:	90                   	nop
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
  80195a:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  80195d:	a1 24 50 80 00       	mov    0x805024,%eax
  801962:	85 c0                	test   %eax,%eax
  801964:	75 0c                	jne    801972 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  801966:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80196b:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  801970:	eb 67                	jmp    8019d9 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  801972:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801977:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80197a:	a1 24 50 80 00       	mov    0x805024,%eax
  80197f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801982:	eb 26                	jmp    8019aa <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  801984:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801987:	8b 10                	mov    (%eax),%edx
  801989:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80198c:	8b 40 04             	mov    0x4(%eax),%eax
  80198f:	01 d0                	add    %edx,%eax
  801991:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  801994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801997:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80199a:	76 06                	jbe    8019a2 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  80199c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199f:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8019a2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8019a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8019aa:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8019ae:	74 08                	je     8019b8 <recompute_page_alloc_break+0x61>
  8019b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019b3:	8b 40 08             	mov    0x8(%eax),%eax
  8019b6:	eb 05                	jmp    8019bd <recompute_page_alloc_break+0x66>
  8019b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8019bd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8019c2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8019c7:	85 c0                	test   %eax,%eax
  8019c9:	75 b9                	jne    801984 <recompute_page_alloc_break+0x2d>
  8019cb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8019cf:	75 b3                	jne    801984 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  8019d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019d4:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  8019e1:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8019e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8019eb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019ee:	01 d0                	add    %edx,%eax
  8019f0:	48                   	dec    %eax
  8019f1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8019f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019fc:	f7 75 d8             	divl   -0x28(%ebp)
  8019ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a02:	29 d0                	sub    %edx,%eax
  801a04:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  801a07:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801a0b:	75 0a                	jne    801a17 <alloc_pages_custom_fit+0x3c>
		return NULL;
  801a0d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a12:	e9 7e 01 00 00       	jmp    801b95 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  801a17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  801a1e:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801a22:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801a29:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  801a30:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801a35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801a38:	a1 24 50 80 00       	mov    0x805024,%eax
  801a3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801a40:	eb 69                	jmp    801aab <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  801a42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a45:	8b 00                	mov    (%eax),%eax
  801a47:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801a4a:	76 47                	jbe    801a93 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  801a4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a4f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  801a52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a55:	8b 00                	mov    (%eax),%eax
  801a57:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801a5a:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  801a5d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a60:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801a63:	72 2e                	jb     801a93 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801a65:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801a69:	75 14                	jne    801a7f <alloc_pages_custom_fit+0xa4>
  801a6b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a6e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801a71:	75 0c                	jne    801a7f <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  801a73:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801a76:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  801a79:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801a7d:	eb 14                	jmp    801a93 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  801a7f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a82:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a85:	76 0c                	jbe    801a93 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  801a87:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801a8a:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  801a8d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a90:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  801a93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a96:	8b 10                	mov    (%eax),%edx
  801a98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a9b:	8b 40 04             	mov    0x4(%eax),%eax
  801a9e:	01 d0                	add    %edx,%eax
  801aa0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801aa3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801aa8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801aab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801aaf:	74 08                	je     801ab9 <alloc_pages_custom_fit+0xde>
  801ab1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ab4:	8b 40 08             	mov    0x8(%eax),%eax
  801ab7:	eb 05                	jmp    801abe <alloc_pages_custom_fit+0xe3>
  801ab9:	b8 00 00 00 00       	mov    $0x0,%eax
  801abe:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801ac3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801ac8:	85 c0                	test   %eax,%eax
  801aca:	0f 85 72 ff ff ff    	jne    801a42 <alloc_pages_custom_fit+0x67>
  801ad0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ad4:	0f 85 68 ff ff ff    	jne    801a42 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  801ada:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801adf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801ae2:	76 47                	jbe    801b2b <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801ae4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ae7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  801aea:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801aef:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801af2:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801af5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801af8:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801afb:	72 2e                	jb     801b2b <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  801afd:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801b01:	75 14                	jne    801b17 <alloc_pages_custom_fit+0x13c>
  801b03:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b06:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801b09:	75 0c                	jne    801b17 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  801b0b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801b0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  801b11:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801b15:	eb 14                	jmp    801b2b <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  801b17:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b1a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801b1d:	76 0c                	jbe    801b2b <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  801b1f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801b22:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801b25:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b28:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  801b2b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  801b32:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801b36:	74 08                	je     801b40 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  801b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b3b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b3e:	eb 40                	jmp    801b80 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  801b40:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b44:	74 08                	je     801b4e <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  801b46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b49:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b4c:	eb 32                	jmp    801b80 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  801b4e:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801b53:	2b 45 d0             	sub    -0x30(%ebp),%eax
  801b56:	89 c2                	mov    %eax,%edx
  801b58:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801b5d:	39 c2                	cmp    %eax,%edx
  801b5f:	73 07                	jae    801b68 <alloc_pages_custom_fit+0x18d>
			return NULL;
  801b61:	b8 00 00 00 00       	mov    $0x0,%eax
  801b66:	eb 2d                	jmp    801b95 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  801b68:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801b6d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  801b70:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801b76:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b79:	01 d0                	add    %edx,%eax
  801b7b:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  801b80:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b83:	83 ec 08             	sub    $0x8,%esp
  801b86:	ff 75 d0             	pushl  -0x30(%ebp)
  801b89:	50                   	push   %eax
  801b8a:	e8 56 fc ff ff       	call   8017e5 <insert_page_alloc>
  801b8f:	83 c4 10             	add    $0x10,%esp

	return result;
  801b92:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
  801b9a:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  801b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801ba3:	a1 24 50 80 00       	mov    0x805024,%eax
  801ba8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801bab:	eb 1a                	jmp    801bc7 <find_allocated_size+0x30>
		if (it->start == va)
  801bad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bb0:	8b 00                	mov    (%eax),%eax
  801bb2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801bb5:	75 08                	jne    801bbf <find_allocated_size+0x28>
			return it->size;
  801bb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bba:	8b 40 04             	mov    0x4(%eax),%eax
  801bbd:	eb 34                	jmp    801bf3 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801bbf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801bc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801bc7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801bcb:	74 08                	je     801bd5 <find_allocated_size+0x3e>
  801bcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bd0:	8b 40 08             	mov    0x8(%eax),%eax
  801bd3:	eb 05                	jmp    801bda <find_allocated_size+0x43>
  801bd5:	b8 00 00 00 00       	mov    $0x0,%eax
  801bda:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801bdf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801be4:	85 c0                	test   %eax,%eax
  801be6:	75 c5                	jne    801bad <find_allocated_size+0x16>
  801be8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801bec:	75 bf                	jne    801bad <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  801bee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
  801bf8:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  801bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfe:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801c01:	a1 24 50 80 00       	mov    0x805024,%eax
  801c06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c09:	e9 e1 01 00 00       	jmp    801def <free_pages+0x1fa>
		if (it->start == va) {
  801c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c11:	8b 00                	mov    (%eax),%eax
  801c13:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801c16:	0f 85 cb 01 00 00    	jne    801de7 <free_pages+0x1f2>

			uint32 start = it->start;
  801c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c1f:	8b 00                	mov    (%eax),%eax
  801c21:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c27:	8b 40 04             	mov    0x4(%eax),%eax
  801c2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801c2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c30:	f7 d0                	not    %eax
  801c32:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801c35:	73 1d                	jae    801c54 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801c37:	83 ec 0c             	sub    $0xc,%esp
  801c3a:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c3d:	ff 75 e8             	pushl  -0x18(%ebp)
  801c40:	68 98 44 80 00       	push   $0x804498
  801c45:	68 a5 00 00 00       	push   $0xa5
  801c4a:	68 31 44 80 00       	push   $0x804431
  801c4f:	e8 96 1c 00 00       	call   8038ea <_panic>
			}

			uint32 start_end = start + size;
  801c54:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c5a:	01 d0                	add    %edx,%eax
  801c5c:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801c5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c62:	85 c0                	test   %eax,%eax
  801c64:	79 19                	jns    801c7f <free_pages+0x8a>
  801c66:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801c6d:	77 10                	ja     801c7f <free_pages+0x8a>
  801c6f:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801c76:	77 07                	ja     801c7f <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  801c78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c7b:	85 c0                	test   %eax,%eax
  801c7d:	78 2c                	js     801cab <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  801c7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c82:	83 ec 0c             	sub    $0xc,%esp
  801c85:	68 00 00 00 a0       	push   $0xa0000000
  801c8a:	ff 75 e0             	pushl  -0x20(%ebp)
  801c8d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c90:	ff 75 e8             	pushl  -0x18(%ebp)
  801c93:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c96:	50                   	push   %eax
  801c97:	68 dc 44 80 00       	push   $0x8044dc
  801c9c:	68 ad 00 00 00       	push   $0xad
  801ca1:	68 31 44 80 00       	push   $0x804431
  801ca6:	e8 3f 1c 00 00       	call   8038ea <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801cab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cb1:	e9 88 00 00 00       	jmp    801d3e <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  801cb6:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  801cbd:	76 17                	jbe    801cd6 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  801cbf:	ff 75 f0             	pushl  -0x10(%ebp)
  801cc2:	68 40 45 80 00       	push   $0x804540
  801cc7:	68 b4 00 00 00       	push   $0xb4
  801ccc:	68 31 44 80 00       	push   $0x804431
  801cd1:	e8 14 1c 00 00       	call   8038ea <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  801cd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd9:	05 00 10 00 00       	add    $0x1000,%eax
  801cde:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  801ce1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce4:	85 c0                	test   %eax,%eax
  801ce6:	79 2e                	jns    801d16 <free_pages+0x121>
  801ce8:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801cef:	77 25                	ja     801d16 <free_pages+0x121>
  801cf1:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801cf8:	77 1c                	ja     801d16 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  801cfa:	83 ec 08             	sub    $0x8,%esp
  801cfd:	68 00 10 00 00       	push   $0x1000
  801d02:	ff 75 f0             	pushl  -0x10(%ebp)
  801d05:	e8 38 0d 00 00       	call   802a42 <sys_free_user_mem>
  801d0a:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801d0d:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801d14:	eb 28                	jmp    801d3e <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  801d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d19:	68 00 00 00 a0       	push   $0xa0000000
  801d1e:	ff 75 dc             	pushl  -0x24(%ebp)
  801d21:	68 00 10 00 00       	push   $0x1000
  801d26:	ff 75 f0             	pushl  -0x10(%ebp)
  801d29:	50                   	push   %eax
  801d2a:	68 80 45 80 00       	push   $0x804580
  801d2f:	68 bd 00 00 00       	push   $0xbd
  801d34:	68 31 44 80 00       	push   $0x804431
  801d39:	e8 ac 1b 00 00       	call   8038ea <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d41:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801d44:	0f 82 6c ff ff ff    	jb     801cb6 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  801d4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d4e:	75 17                	jne    801d67 <free_pages+0x172>
  801d50:	83 ec 04             	sub    $0x4,%esp
  801d53:	68 e2 45 80 00       	push   $0x8045e2
  801d58:	68 c1 00 00 00       	push   $0xc1
  801d5d:	68 31 44 80 00       	push   $0x804431
  801d62:	e8 83 1b 00 00       	call   8038ea <_panic>
  801d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6a:	8b 40 08             	mov    0x8(%eax),%eax
  801d6d:	85 c0                	test   %eax,%eax
  801d6f:	74 11                	je     801d82 <free_pages+0x18d>
  801d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d74:	8b 40 08             	mov    0x8(%eax),%eax
  801d77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d7a:	8b 52 0c             	mov    0xc(%edx),%edx
  801d7d:	89 50 0c             	mov    %edx,0xc(%eax)
  801d80:	eb 0b                	jmp    801d8d <free_pages+0x198>
  801d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d85:	8b 40 0c             	mov    0xc(%eax),%eax
  801d88:	a3 28 50 80 00       	mov    %eax,0x805028
  801d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d90:	8b 40 0c             	mov    0xc(%eax),%eax
  801d93:	85 c0                	test   %eax,%eax
  801d95:	74 11                	je     801da8 <free_pages+0x1b3>
  801d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9a:	8b 40 0c             	mov    0xc(%eax),%eax
  801d9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801da0:	8b 52 08             	mov    0x8(%edx),%edx
  801da3:	89 50 08             	mov    %edx,0x8(%eax)
  801da6:	eb 0b                	jmp    801db3 <free_pages+0x1be>
  801da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dab:	8b 40 08             	mov    0x8(%eax),%eax
  801dae:	a3 24 50 80 00       	mov    %eax,0x805024
  801db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801dc7:	a1 30 50 80 00       	mov    0x805030,%eax
  801dcc:	48                   	dec    %eax
  801dcd:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  801dd2:	83 ec 0c             	sub    $0xc,%esp
  801dd5:	ff 75 f4             	pushl  -0xc(%ebp)
  801dd8:	e8 24 15 00 00       	call   803301 <free_block>
  801ddd:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  801de0:	e8 72 fb ff ff       	call   801957 <recompute_page_alloc_break>

			return;
  801de5:	eb 37                	jmp    801e1e <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801de7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801dec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801def:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801df3:	74 08                	je     801dfd <free_pages+0x208>
  801df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df8:	8b 40 08             	mov    0x8(%eax),%eax
  801dfb:	eb 05                	jmp    801e02 <free_pages+0x20d>
  801dfd:	b8 00 00 00 00       	mov    $0x0,%eax
  801e02:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801e07:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801e0c:	85 c0                	test   %eax,%eax
  801e0e:	0f 85 fa fd ff ff    	jne    801c0e <free_pages+0x19>
  801e14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e18:	0f 85 f0 fd ff ff    	jne    801c0e <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  801e23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e28:	5d                   	pop    %ebp
  801e29:	c3                   	ret    

00801e2a <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
  801e2d:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801e30:	a1 08 50 80 00       	mov    0x805008,%eax
  801e35:	85 c0                	test   %eax,%eax
  801e37:	74 60                	je     801e99 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801e39:	83 ec 08             	sub    $0x8,%esp
  801e3c:	68 00 00 00 82       	push   $0x82000000
  801e41:	68 00 00 00 80       	push   $0x80000000
  801e46:	e8 0d 0d 00 00       	call   802b58 <initialize_dynamic_allocator>
  801e4b:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801e4e:	e8 f3 0a 00 00       	call   802946 <sys_get_uheap_strategy>
  801e53:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801e58:	a1 40 50 80 00       	mov    0x805040,%eax
  801e5d:	05 00 10 00 00       	add    $0x1000,%eax
  801e62:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  801e67:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801e6c:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  801e71:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  801e78:	00 00 00 
  801e7b:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  801e82:	00 00 00 
  801e85:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  801e8c:	00 00 00 

		__firstTimeFlag = 0;
  801e8f:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801e96:	00 00 00 
	}
}
  801e99:	90                   	nop
  801e9a:	c9                   	leave  
  801e9b:	c3                   	ret    

00801e9c <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
  801e9f:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801eb0:	83 ec 08             	sub    $0x8,%esp
  801eb3:	68 06 04 00 00       	push   $0x406
  801eb8:	50                   	push   %eax
  801eb9:	e8 d2 06 00 00       	call   802590 <__sys_allocate_page>
  801ebe:	83 c4 10             	add    $0x10,%esp
  801ec1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801ec4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ec8:	79 17                	jns    801ee1 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  801eca:	83 ec 04             	sub    $0x4,%esp
  801ecd:	68 00 46 80 00       	push   $0x804600
  801ed2:	68 ea 00 00 00       	push   $0xea
  801ed7:	68 31 44 80 00       	push   $0x804431
  801edc:	e8 09 1a 00 00       	call   8038ea <_panic>
	return 0;
  801ee1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801eee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801efc:	83 ec 0c             	sub    $0xc,%esp
  801eff:	50                   	push   %eax
  801f00:	e8 d2 06 00 00       	call   8025d7 <__sys_unmap_frame>
  801f05:	83 c4 10             	add    $0x10,%esp
  801f08:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801f0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f0f:	79 17                	jns    801f28 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  801f11:	83 ec 04             	sub    $0x4,%esp
  801f14:	68 3c 46 80 00       	push   $0x80463c
  801f19:	68 f5 00 00 00       	push   $0xf5
  801f1e:	68 31 44 80 00       	push   $0x804431
  801f23:	e8 c2 19 00 00       	call   8038ea <_panic>
}
  801f28:	90                   	nop
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
  801f2e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801f31:	e8 f4 fe ff ff       	call   801e2a <uheap_init>
	if (size == 0) return NULL ;
  801f36:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f3a:	75 0a                	jne    801f46 <malloc+0x1b>
  801f3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f41:	e9 67 01 00 00       	jmp    8020ad <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  801f46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801f4d:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801f54:	77 16                	ja     801f6c <malloc+0x41>
		result = alloc_block(size);
  801f56:	83 ec 0c             	sub    $0xc,%esp
  801f59:	ff 75 08             	pushl  0x8(%ebp)
  801f5c:	e8 46 0e 00 00       	call   802da7 <alloc_block>
  801f61:	83 c4 10             	add    $0x10,%esp
  801f64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f67:	e9 3e 01 00 00       	jmp    8020aa <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  801f6c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f73:	8b 55 08             	mov    0x8(%ebp),%edx
  801f76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f79:	01 d0                	add    %edx,%eax
  801f7b:	48                   	dec    %eax
  801f7c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f82:	ba 00 00 00 00       	mov    $0x0,%edx
  801f87:	f7 75 f0             	divl   -0x10(%ebp)
  801f8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f8d:	29 d0                	sub    %edx,%eax
  801f8f:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  801f92:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801f97:	85 c0                	test   %eax,%eax
  801f99:	75 0a                	jne    801fa5 <malloc+0x7a>
			return NULL;
  801f9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa0:	e9 08 01 00 00       	jmp    8020ad <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  801fa5:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801faa:	85 c0                	test   %eax,%eax
  801fac:	74 0f                	je     801fbd <malloc+0x92>
  801fae:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801fb4:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801fb9:	39 c2                	cmp    %eax,%edx
  801fbb:	73 0a                	jae    801fc7 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  801fbd:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801fc2:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801fc7:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801fcc:	83 f8 05             	cmp    $0x5,%eax
  801fcf:	75 11                	jne    801fe2 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  801fd1:	83 ec 0c             	sub    $0xc,%esp
  801fd4:	ff 75 e8             	pushl  -0x18(%ebp)
  801fd7:	e8 ff f9 ff ff       	call   8019db <alloc_pages_custom_fit>
  801fdc:	83 c4 10             	add    $0x10,%esp
  801fdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  801fe2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe6:	0f 84 be 00 00 00    	je     8020aa <malloc+0x17f>
			uint32 result_va = (uint32)result;
  801fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  801ff2:	83 ec 0c             	sub    $0xc,%esp
  801ff5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff8:	e8 9a fb ff ff       	call   801b97 <find_allocated_size>
  801ffd:	83 c4 10             	add    $0x10,%esp
  802000:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  802003:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802007:	75 17                	jne    802020 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  802009:	ff 75 f4             	pushl  -0xc(%ebp)
  80200c:	68 7c 46 80 00       	push   $0x80467c
  802011:	68 24 01 00 00       	push   $0x124
  802016:	68 31 44 80 00       	push   $0x804431
  80201b:	e8 ca 18 00 00       	call   8038ea <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  802020:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802023:	f7 d0                	not    %eax
  802025:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802028:	73 1d                	jae    802047 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  80202a:	83 ec 0c             	sub    $0xc,%esp
  80202d:	ff 75 e0             	pushl  -0x20(%ebp)
  802030:	ff 75 e4             	pushl  -0x1c(%ebp)
  802033:	68 c4 46 80 00       	push   $0x8046c4
  802038:	68 29 01 00 00       	push   $0x129
  80203d:	68 31 44 80 00       	push   $0x804431
  802042:	e8 a3 18 00 00       	call   8038ea <_panic>
			}

			uint32 result_end = result_va + actual_size;
  802047:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80204a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80204d:	01 d0                	add    %edx,%eax
  80204f:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  802052:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802055:	85 c0                	test   %eax,%eax
  802057:	79 2c                	jns    802085 <malloc+0x15a>
  802059:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  802060:	77 23                	ja     802085 <malloc+0x15a>
  802062:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802069:	77 1a                	ja     802085 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  80206b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80206e:	85 c0                	test   %eax,%eax
  802070:	79 13                	jns    802085 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  802072:	83 ec 08             	sub    $0x8,%esp
  802075:	ff 75 e0             	pushl  -0x20(%ebp)
  802078:	ff 75 e4             	pushl  -0x1c(%ebp)
  80207b:	e8 de 09 00 00       	call   802a5e <sys_allocate_user_mem>
  802080:	83 c4 10             	add    $0x10,%esp
  802083:	eb 25                	jmp    8020aa <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  802085:	68 00 00 00 a0       	push   $0xa0000000
  80208a:	ff 75 dc             	pushl  -0x24(%ebp)
  80208d:	ff 75 e0             	pushl  -0x20(%ebp)
  802090:	ff 75 e4             	pushl  -0x1c(%ebp)
  802093:	ff 75 f4             	pushl  -0xc(%ebp)
  802096:	68 00 47 80 00       	push   $0x804700
  80209b:	68 33 01 00 00       	push   $0x133
  8020a0:	68 31 44 80 00       	push   $0x804431
  8020a5:	e8 40 18 00 00       	call   8038ea <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  8020aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  8020ad:	c9                   	leave  
  8020ae:	c3                   	ret    

008020af <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
  8020b2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  8020b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020b9:	0f 84 26 01 00 00    	je     8021e5 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  8020bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  8020c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c8:	85 c0                	test   %eax,%eax
  8020ca:	79 1c                	jns    8020e8 <free+0x39>
  8020cc:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  8020d3:	77 13                	ja     8020e8 <free+0x39>
		free_block(virtual_address);
  8020d5:	83 ec 0c             	sub    $0xc,%esp
  8020d8:	ff 75 08             	pushl  0x8(%ebp)
  8020db:	e8 21 12 00 00       	call   803301 <free_block>
  8020e0:	83 c4 10             	add    $0x10,%esp
		return;
  8020e3:	e9 01 01 00 00       	jmp    8021e9 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  8020e8:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8020ed:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  8020f0:	0f 82 d8 00 00 00    	jb     8021ce <free+0x11f>
  8020f6:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  8020fd:	0f 87 cb 00 00 00    	ja     8021ce <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  802103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802106:	25 ff 0f 00 00       	and    $0xfff,%eax
  80210b:	85 c0                	test   %eax,%eax
  80210d:	74 17                	je     802126 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  80210f:	ff 75 08             	pushl  0x8(%ebp)
  802112:	68 70 47 80 00       	push   $0x804770
  802117:	68 57 01 00 00       	push   $0x157
  80211c:	68 31 44 80 00       	push   $0x804431
  802121:	e8 c4 17 00 00       	call   8038ea <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  802126:	83 ec 0c             	sub    $0xc,%esp
  802129:	ff 75 08             	pushl  0x8(%ebp)
  80212c:	e8 66 fa ff ff       	call   801b97 <find_allocated_size>
  802131:	83 c4 10             	add    $0x10,%esp
  802134:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  802137:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80213b:	0f 84 a7 00 00 00    	je     8021e8 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  802141:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802144:	f7 d0                	not    %eax
  802146:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802149:	73 1d                	jae    802168 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  80214b:	83 ec 0c             	sub    $0xc,%esp
  80214e:	ff 75 f0             	pushl  -0x10(%ebp)
  802151:	ff 75 f4             	pushl  -0xc(%ebp)
  802154:	68 98 47 80 00       	push   $0x804798
  802159:	68 61 01 00 00       	push   $0x161
  80215e:	68 31 44 80 00       	push   $0x804431
  802163:	e8 82 17 00 00       	call   8038ea <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  802168:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80216b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216e:	01 d0                	add    %edx,%eax
  802170:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  802173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802176:	85 c0                	test   %eax,%eax
  802178:	79 19                	jns    802193 <free+0xe4>
  80217a:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  802181:	77 10                	ja     802193 <free+0xe4>
  802183:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  80218a:	77 07                	ja     802193 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  80218c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80218f:	85 c0                	test   %eax,%eax
  802191:	78 2b                	js     8021be <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  802193:	83 ec 0c             	sub    $0xc,%esp
  802196:	68 00 00 00 a0       	push   $0xa0000000
  80219b:	ff 75 ec             	pushl  -0x14(%ebp)
  80219e:	ff 75 f0             	pushl  -0x10(%ebp)
  8021a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8021a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8021a7:	ff 75 08             	pushl  0x8(%ebp)
  8021aa:	68 d4 47 80 00       	push   $0x8047d4
  8021af:	68 69 01 00 00       	push   $0x169
  8021b4:	68 31 44 80 00       	push   $0x804431
  8021b9:	e8 2c 17 00 00       	call   8038ea <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  8021be:	83 ec 0c             	sub    $0xc,%esp
  8021c1:	ff 75 08             	pushl  0x8(%ebp)
  8021c4:	e8 2c fa ff ff       	call   801bf5 <free_pages>
  8021c9:	83 c4 10             	add    $0x10,%esp
		return;
  8021cc:	eb 1b                	jmp    8021e9 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  8021ce:	ff 75 08             	pushl  0x8(%ebp)
  8021d1:	68 30 48 80 00       	push   $0x804830
  8021d6:	68 70 01 00 00       	push   $0x170
  8021db:	68 31 44 80 00       	push   $0x804431
  8021e0:	e8 05 17 00 00       	call   8038ea <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  8021e5:	90                   	nop
  8021e6:	eb 01                	jmp    8021e9 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  8021e8:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  8021e9:	c9                   	leave  
  8021ea:	c3                   	ret    

008021eb <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	83 ec 38             	sub    $0x38,%esp
  8021f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f4:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8021f7:	e8 2e fc ff ff       	call   801e2a <uheap_init>
	if (size == 0) return NULL ;
  8021fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802200:	75 0a                	jne    80220c <smalloc+0x21>
  802202:	b8 00 00 00 00       	mov    $0x0,%eax
  802207:	e9 3d 01 00 00       	jmp    802349 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  80220c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  802212:	8b 45 0c             	mov    0xc(%ebp),%eax
  802215:	25 ff 0f 00 00       	and    $0xfff,%eax
  80221a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  80221d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802221:	74 0e                	je     802231 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  802223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802226:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802229:	05 00 10 00 00       	add    $0x1000,%eax
  80222e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  802231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802234:	c1 e8 0c             	shr    $0xc,%eax
  802237:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  80223a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80223f:	85 c0                	test   %eax,%eax
  802241:	75 0a                	jne    80224d <smalloc+0x62>
		return NULL;
  802243:	b8 00 00 00 00       	mov    $0x0,%eax
  802248:	e9 fc 00 00 00       	jmp    802349 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  80224d:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802252:	85 c0                	test   %eax,%eax
  802254:	74 0f                	je     802265 <smalloc+0x7a>
  802256:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80225c:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802261:	39 c2                	cmp    %eax,%edx
  802263:	73 0a                	jae    80226f <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  802265:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80226a:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  80226f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802274:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802279:	29 c2                	sub    %eax,%edx
  80227b:	89 d0                	mov    %edx,%eax
  80227d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802280:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802286:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80228b:	29 c2                	sub    %eax,%edx
  80228d:	89 d0                	mov    %edx,%eax
  80228f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  802292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802295:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802298:	77 13                	ja     8022ad <smalloc+0xc2>
  80229a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80229d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8022a0:	77 0b                	ja     8022ad <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  8022a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022a5:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  8022a8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8022ab:	73 0a                	jae    8022b7 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  8022ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b2:	e9 92 00 00 00       	jmp    802349 <smalloc+0x15e>
	}

	void *va = NULL;
  8022b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  8022be:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8022c3:	83 f8 05             	cmp    $0x5,%eax
  8022c6:	75 11                	jne    8022d9 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  8022c8:	83 ec 0c             	sub    $0xc,%esp
  8022cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8022ce:	e8 08 f7 ff ff       	call   8019db <alloc_pages_custom_fit>
  8022d3:	83 c4 10             	add    $0x10,%esp
  8022d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  8022d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022dd:	75 27                	jne    802306 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8022df:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  8022e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8022e9:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8022ec:	89 c2                	mov    %eax,%edx
  8022ee:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8022f3:	39 c2                	cmp    %eax,%edx
  8022f5:	73 07                	jae    8022fe <smalloc+0x113>
			return NULL;}
  8022f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fc:	eb 4b                	jmp    802349 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  8022fe:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802303:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  802306:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80230a:	ff 75 f0             	pushl  -0x10(%ebp)
  80230d:	50                   	push   %eax
  80230e:	ff 75 0c             	pushl  0xc(%ebp)
  802311:	ff 75 08             	pushl  0x8(%ebp)
  802314:	e8 cb 03 00 00       	call   8026e4 <sys_create_shared_object>
  802319:	83 c4 10             	add    $0x10,%esp
  80231c:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  80231f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802323:	79 07                	jns    80232c <smalloc+0x141>
		return NULL;
  802325:	b8 00 00 00 00       	mov    $0x0,%eax
  80232a:	eb 1d                	jmp    802349 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  80232c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802331:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802334:	75 10                	jne    802346 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  802336:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233f:	01 d0                	add    %edx,%eax
  802341:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  802346:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  802349:	c9                   	leave  
  80234a:	c3                   	ret    

0080234b <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
  80234e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802351:	e8 d4 fa ff ff       	call   801e2a <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802356:	83 ec 08             	sub    $0x8,%esp
  802359:	ff 75 0c             	pushl  0xc(%ebp)
  80235c:	ff 75 08             	pushl  0x8(%ebp)
  80235f:	e8 aa 03 00 00       	call   80270e <sys_size_of_shared_object>
  802364:	83 c4 10             	add    $0x10,%esp
  802367:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  80236a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80236e:	7f 0a                	jg     80237a <sget+0x2f>
		return NULL;
  802370:	b8 00 00 00 00       	mov    $0x0,%eax
  802375:	e9 32 01 00 00       	jmp    8024ac <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  80237a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80237d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  802380:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802383:	25 ff 0f 00 00       	and    $0xfff,%eax
  802388:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  80238b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80238f:	74 0e                	je     80239f <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  802391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802394:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802397:	05 00 10 00 00       	add    $0x1000,%eax
  80239c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  80239f:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8023a4:	85 c0                	test   %eax,%eax
  8023a6:	75 0a                	jne    8023b2 <sget+0x67>
		return NULL;
  8023a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ad:	e9 fa 00 00 00       	jmp    8024ac <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8023b2:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8023b7:	85 c0                	test   %eax,%eax
  8023b9:	74 0f                	je     8023ca <sget+0x7f>
  8023bb:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8023c1:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8023c6:	39 c2                	cmp    %eax,%edx
  8023c8:	73 0a                	jae    8023d4 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  8023ca:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8023cf:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8023d4:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8023d9:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8023de:	29 c2                	sub    %eax,%edx
  8023e0:	89 d0                	mov    %edx,%eax
  8023e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8023e5:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8023eb:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8023f0:	29 c2                	sub    %eax,%edx
  8023f2:	89 d0                	mov    %edx,%eax
  8023f4:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8023f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fa:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8023fd:	77 13                	ja     802412 <sget+0xc7>
  8023ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802402:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802405:	77 0b                	ja     802412 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  802407:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80240a:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  80240d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802410:	73 0a                	jae    80241c <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  802412:	b8 00 00 00 00       	mov    $0x0,%eax
  802417:	e9 90 00 00 00       	jmp    8024ac <sget+0x161>

	void *va = NULL;
  80241c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  802423:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802428:	83 f8 05             	cmp    $0x5,%eax
  80242b:	75 11                	jne    80243e <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  80242d:	83 ec 0c             	sub    $0xc,%esp
  802430:	ff 75 f4             	pushl  -0xc(%ebp)
  802433:	e8 a3 f5 ff ff       	call   8019db <alloc_pages_custom_fit>
  802438:	83 c4 10             	add    $0x10,%esp
  80243b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  80243e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802442:	75 27                	jne    80246b <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802444:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  80244b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80244e:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802451:	89 c2                	mov    %eax,%edx
  802453:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802458:	39 c2                	cmp    %eax,%edx
  80245a:	73 07                	jae    802463 <sget+0x118>
			return NULL;
  80245c:	b8 00 00 00 00       	mov    $0x0,%eax
  802461:	eb 49                	jmp    8024ac <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  802463:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802468:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  80246b:	83 ec 04             	sub    $0x4,%esp
  80246e:	ff 75 f0             	pushl  -0x10(%ebp)
  802471:	ff 75 0c             	pushl  0xc(%ebp)
  802474:	ff 75 08             	pushl  0x8(%ebp)
  802477:	e8 af 02 00 00       	call   80272b <sys_get_shared_object>
  80247c:	83 c4 10             	add    $0x10,%esp
  80247f:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  802482:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802486:	79 07                	jns    80248f <sget+0x144>
		return NULL;
  802488:	b8 00 00 00 00       	mov    $0x0,%eax
  80248d:	eb 1d                	jmp    8024ac <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  80248f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802494:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802497:	75 10                	jne    8024a9 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  802499:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80249f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a2:	01 d0                	add    %edx,%eax
  8024a4:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  8024a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  8024ac:	c9                   	leave  
  8024ad:	c3                   	ret    

008024ae <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8024ae:	55                   	push   %ebp
  8024af:	89 e5                	mov    %esp,%ebp
  8024b1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8024b4:	e8 71 f9 ff ff       	call   801e2a <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8024b9:	83 ec 04             	sub    $0x4,%esp
  8024bc:	68 54 48 80 00       	push   $0x804854
  8024c1:	68 19 02 00 00       	push   $0x219
  8024c6:	68 31 44 80 00       	push   $0x804431
  8024cb:	e8 1a 14 00 00       	call   8038ea <_panic>

008024d0 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8024d0:	55                   	push   %ebp
  8024d1:	89 e5                	mov    %esp,%ebp
  8024d3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8024d6:	83 ec 04             	sub    $0x4,%esp
  8024d9:	68 7c 48 80 00       	push   $0x80487c
  8024de:	68 2b 02 00 00       	push   $0x22b
  8024e3:	68 31 44 80 00       	push   $0x804431
  8024e8:	e8 fd 13 00 00       	call   8038ea <_panic>

008024ed <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8024ed:	55                   	push   %ebp
  8024ee:	89 e5                	mov    %esp,%ebp
  8024f0:	57                   	push   %edi
  8024f1:	56                   	push   %esi
  8024f2:	53                   	push   %ebx
  8024f3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8024f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024ff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802502:	8b 7d 18             	mov    0x18(%ebp),%edi
  802505:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802508:	cd 30                	int    $0x30
  80250a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80250d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802510:	83 c4 10             	add    $0x10,%esp
  802513:	5b                   	pop    %ebx
  802514:	5e                   	pop    %esi
  802515:	5f                   	pop    %edi
  802516:	5d                   	pop    %ebp
  802517:	c3                   	ret    

00802518 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802518:	55                   	push   %ebp
  802519:	89 e5                	mov    %esp,%ebp
  80251b:	83 ec 04             	sub    $0x4,%esp
  80251e:	8b 45 10             	mov    0x10(%ebp),%eax
  802521:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802524:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802527:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80252b:	8b 45 08             	mov    0x8(%ebp),%eax
  80252e:	6a 00                	push   $0x0
  802530:	51                   	push   %ecx
  802531:	52                   	push   %edx
  802532:	ff 75 0c             	pushl  0xc(%ebp)
  802535:	50                   	push   %eax
  802536:	6a 00                	push   $0x0
  802538:	e8 b0 ff ff ff       	call   8024ed <syscall>
  80253d:	83 c4 18             	add    $0x18,%esp
}
  802540:	90                   	nop
  802541:	c9                   	leave  
  802542:	c3                   	ret    

00802543 <sys_cgetc>:

int
sys_cgetc(void)
{
  802543:	55                   	push   %ebp
  802544:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802546:	6a 00                	push   $0x0
  802548:	6a 00                	push   $0x0
  80254a:	6a 00                	push   $0x0
  80254c:	6a 00                	push   $0x0
  80254e:	6a 00                	push   $0x0
  802550:	6a 02                	push   $0x2
  802552:	e8 96 ff ff ff       	call   8024ed <syscall>
  802557:	83 c4 18             	add    $0x18,%esp
}
  80255a:	c9                   	leave  
  80255b:	c3                   	ret    

0080255c <sys_lock_cons>:

void sys_lock_cons(void)
{
  80255c:	55                   	push   %ebp
  80255d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	6a 00                	push   $0x0
  802565:	6a 00                	push   $0x0
  802567:	6a 00                	push   $0x0
  802569:	6a 03                	push   $0x3
  80256b:	e8 7d ff ff ff       	call   8024ed <syscall>
  802570:	83 c4 18             	add    $0x18,%esp
}
  802573:	90                   	nop
  802574:	c9                   	leave  
  802575:	c3                   	ret    

00802576 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802576:	55                   	push   %ebp
  802577:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802579:	6a 00                	push   $0x0
  80257b:	6a 00                	push   $0x0
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	6a 00                	push   $0x0
  802583:	6a 04                	push   $0x4
  802585:	e8 63 ff ff ff       	call   8024ed <syscall>
  80258a:	83 c4 18             	add    $0x18,%esp
}
  80258d:	90                   	nop
  80258e:	c9                   	leave  
  80258f:	c3                   	ret    

00802590 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802590:	55                   	push   %ebp
  802591:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802593:	8b 55 0c             	mov    0xc(%ebp),%edx
  802596:	8b 45 08             	mov    0x8(%ebp),%eax
  802599:	6a 00                	push   $0x0
  80259b:	6a 00                	push   $0x0
  80259d:	6a 00                	push   $0x0
  80259f:	52                   	push   %edx
  8025a0:	50                   	push   %eax
  8025a1:	6a 08                	push   $0x8
  8025a3:	e8 45 ff ff ff       	call   8024ed <syscall>
  8025a8:	83 c4 18             	add    $0x18,%esp
}
  8025ab:	c9                   	leave  
  8025ac:	c3                   	ret    

008025ad <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8025ad:	55                   	push   %ebp
  8025ae:	89 e5                	mov    %esp,%ebp
  8025b0:	56                   	push   %esi
  8025b1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8025b2:	8b 75 18             	mov    0x18(%ebp),%esi
  8025b5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025be:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c1:	56                   	push   %esi
  8025c2:	53                   	push   %ebx
  8025c3:	51                   	push   %ecx
  8025c4:	52                   	push   %edx
  8025c5:	50                   	push   %eax
  8025c6:	6a 09                	push   $0x9
  8025c8:	e8 20 ff ff ff       	call   8024ed <syscall>
  8025cd:	83 c4 18             	add    $0x18,%esp
}
  8025d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025d3:	5b                   	pop    %ebx
  8025d4:	5e                   	pop    %esi
  8025d5:	5d                   	pop    %ebp
  8025d6:	c3                   	ret    

008025d7 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8025d7:	55                   	push   %ebp
  8025d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 00                	push   $0x0
  8025e0:	6a 00                	push   $0x0
  8025e2:	ff 75 08             	pushl  0x8(%ebp)
  8025e5:	6a 0a                	push   $0xa
  8025e7:	e8 01 ff ff ff       	call   8024ed <syscall>
  8025ec:	83 c4 18             	add    $0x18,%esp
}
  8025ef:	c9                   	leave  
  8025f0:	c3                   	ret    

008025f1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8025f1:	55                   	push   %ebp
  8025f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 00                	push   $0x0
  8025fa:	ff 75 0c             	pushl  0xc(%ebp)
  8025fd:	ff 75 08             	pushl  0x8(%ebp)
  802600:	6a 0b                	push   $0xb
  802602:	e8 e6 fe ff ff       	call   8024ed <syscall>
  802607:	83 c4 18             	add    $0x18,%esp
}
  80260a:	c9                   	leave  
  80260b:	c3                   	ret    

0080260c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80260c:	55                   	push   %ebp
  80260d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80260f:	6a 00                	push   $0x0
  802611:	6a 00                	push   $0x0
  802613:	6a 00                	push   $0x0
  802615:	6a 00                	push   $0x0
  802617:	6a 00                	push   $0x0
  802619:	6a 0c                	push   $0xc
  80261b:	e8 cd fe ff ff       	call   8024ed <syscall>
  802620:	83 c4 18             	add    $0x18,%esp
}
  802623:	c9                   	leave  
  802624:	c3                   	ret    

00802625 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802625:	55                   	push   %ebp
  802626:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802628:	6a 00                	push   $0x0
  80262a:	6a 00                	push   $0x0
  80262c:	6a 00                	push   $0x0
  80262e:	6a 00                	push   $0x0
  802630:	6a 00                	push   $0x0
  802632:	6a 0d                	push   $0xd
  802634:	e8 b4 fe ff ff       	call   8024ed <syscall>
  802639:	83 c4 18             	add    $0x18,%esp
}
  80263c:	c9                   	leave  
  80263d:	c3                   	ret    

0080263e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80263e:	55                   	push   %ebp
  80263f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802641:	6a 00                	push   $0x0
  802643:	6a 00                	push   $0x0
  802645:	6a 00                	push   $0x0
  802647:	6a 00                	push   $0x0
  802649:	6a 00                	push   $0x0
  80264b:	6a 0e                	push   $0xe
  80264d:	e8 9b fe ff ff       	call   8024ed <syscall>
  802652:	83 c4 18             	add    $0x18,%esp
}
  802655:	c9                   	leave  
  802656:	c3                   	ret    

00802657 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802657:	55                   	push   %ebp
  802658:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80265a:	6a 00                	push   $0x0
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	6a 00                	push   $0x0
  802664:	6a 0f                	push   $0xf
  802666:	e8 82 fe ff ff       	call   8024ed <syscall>
  80266b:	83 c4 18             	add    $0x18,%esp
}
  80266e:	c9                   	leave  
  80266f:	c3                   	ret    

00802670 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802670:	55                   	push   %ebp
  802671:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802673:	6a 00                	push   $0x0
  802675:	6a 00                	push   $0x0
  802677:	6a 00                	push   $0x0
  802679:	6a 00                	push   $0x0
  80267b:	ff 75 08             	pushl  0x8(%ebp)
  80267e:	6a 10                	push   $0x10
  802680:	e8 68 fe ff ff       	call   8024ed <syscall>
  802685:	83 c4 18             	add    $0x18,%esp
}
  802688:	c9                   	leave  
  802689:	c3                   	ret    

0080268a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80268a:	55                   	push   %ebp
  80268b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80268d:	6a 00                	push   $0x0
  80268f:	6a 00                	push   $0x0
  802691:	6a 00                	push   $0x0
  802693:	6a 00                	push   $0x0
  802695:	6a 00                	push   $0x0
  802697:	6a 11                	push   $0x11
  802699:	e8 4f fe ff ff       	call   8024ed <syscall>
  80269e:	83 c4 18             	add    $0x18,%esp
}
  8026a1:	90                   	nop
  8026a2:	c9                   	leave  
  8026a3:	c3                   	ret    

008026a4 <sys_cputc>:

void
sys_cputc(const char c)
{
  8026a4:	55                   	push   %ebp
  8026a5:	89 e5                	mov    %esp,%ebp
  8026a7:	83 ec 04             	sub    $0x4,%esp
  8026aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ad:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8026b0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026b4:	6a 00                	push   $0x0
  8026b6:	6a 00                	push   $0x0
  8026b8:	6a 00                	push   $0x0
  8026ba:	6a 00                	push   $0x0
  8026bc:	50                   	push   %eax
  8026bd:	6a 01                	push   $0x1
  8026bf:	e8 29 fe ff ff       	call   8024ed <syscall>
  8026c4:	83 c4 18             	add    $0x18,%esp
}
  8026c7:	90                   	nop
  8026c8:	c9                   	leave  
  8026c9:	c3                   	ret    

008026ca <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8026ca:	55                   	push   %ebp
  8026cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8026cd:	6a 00                	push   $0x0
  8026cf:	6a 00                	push   $0x0
  8026d1:	6a 00                	push   $0x0
  8026d3:	6a 00                	push   $0x0
  8026d5:	6a 00                	push   $0x0
  8026d7:	6a 14                	push   $0x14
  8026d9:	e8 0f fe ff ff       	call   8024ed <syscall>
  8026de:	83 c4 18             	add    $0x18,%esp
}
  8026e1:	90                   	nop
  8026e2:	c9                   	leave  
  8026e3:	c3                   	ret    

008026e4 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8026e4:	55                   	push   %ebp
  8026e5:	89 e5                	mov    %esp,%ebp
  8026e7:	83 ec 04             	sub    $0x4,%esp
  8026ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8026ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8026f0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8026f3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8026f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fa:	6a 00                	push   $0x0
  8026fc:	51                   	push   %ecx
  8026fd:	52                   	push   %edx
  8026fe:	ff 75 0c             	pushl  0xc(%ebp)
  802701:	50                   	push   %eax
  802702:	6a 15                	push   $0x15
  802704:	e8 e4 fd ff ff       	call   8024ed <syscall>
  802709:	83 c4 18             	add    $0x18,%esp
}
  80270c:	c9                   	leave  
  80270d:	c3                   	ret    

0080270e <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80270e:	55                   	push   %ebp
  80270f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802711:	8b 55 0c             	mov    0xc(%ebp),%edx
  802714:	8b 45 08             	mov    0x8(%ebp),%eax
  802717:	6a 00                	push   $0x0
  802719:	6a 00                	push   $0x0
  80271b:	6a 00                	push   $0x0
  80271d:	52                   	push   %edx
  80271e:	50                   	push   %eax
  80271f:	6a 16                	push   $0x16
  802721:	e8 c7 fd ff ff       	call   8024ed <syscall>
  802726:	83 c4 18             	add    $0x18,%esp
}
  802729:	c9                   	leave  
  80272a:	c3                   	ret    

0080272b <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80272b:	55                   	push   %ebp
  80272c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80272e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802731:	8b 55 0c             	mov    0xc(%ebp),%edx
  802734:	8b 45 08             	mov    0x8(%ebp),%eax
  802737:	6a 00                	push   $0x0
  802739:	6a 00                	push   $0x0
  80273b:	51                   	push   %ecx
  80273c:	52                   	push   %edx
  80273d:	50                   	push   %eax
  80273e:	6a 17                	push   $0x17
  802740:	e8 a8 fd ff ff       	call   8024ed <syscall>
  802745:	83 c4 18             	add    $0x18,%esp
}
  802748:	c9                   	leave  
  802749:	c3                   	ret    

0080274a <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80274a:	55                   	push   %ebp
  80274b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80274d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802750:	8b 45 08             	mov    0x8(%ebp),%eax
  802753:	6a 00                	push   $0x0
  802755:	6a 00                	push   $0x0
  802757:	6a 00                	push   $0x0
  802759:	52                   	push   %edx
  80275a:	50                   	push   %eax
  80275b:	6a 18                	push   $0x18
  80275d:	e8 8b fd ff ff       	call   8024ed <syscall>
  802762:	83 c4 18             	add    $0x18,%esp
}
  802765:	c9                   	leave  
  802766:	c3                   	ret    

00802767 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802767:	55                   	push   %ebp
  802768:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80276a:	8b 45 08             	mov    0x8(%ebp),%eax
  80276d:	6a 00                	push   $0x0
  80276f:	ff 75 14             	pushl  0x14(%ebp)
  802772:	ff 75 10             	pushl  0x10(%ebp)
  802775:	ff 75 0c             	pushl  0xc(%ebp)
  802778:	50                   	push   %eax
  802779:	6a 19                	push   $0x19
  80277b:	e8 6d fd ff ff       	call   8024ed <syscall>
  802780:	83 c4 18             	add    $0x18,%esp
}
  802783:	c9                   	leave  
  802784:	c3                   	ret    

00802785 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802785:	55                   	push   %ebp
  802786:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802788:	8b 45 08             	mov    0x8(%ebp),%eax
  80278b:	6a 00                	push   $0x0
  80278d:	6a 00                	push   $0x0
  80278f:	6a 00                	push   $0x0
  802791:	6a 00                	push   $0x0
  802793:	50                   	push   %eax
  802794:	6a 1a                	push   $0x1a
  802796:	e8 52 fd ff ff       	call   8024ed <syscall>
  80279b:	83 c4 18             	add    $0x18,%esp
}
  80279e:	90                   	nop
  80279f:	c9                   	leave  
  8027a0:	c3                   	ret    

008027a1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8027a1:	55                   	push   %ebp
  8027a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8027a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a7:	6a 00                	push   $0x0
  8027a9:	6a 00                	push   $0x0
  8027ab:	6a 00                	push   $0x0
  8027ad:	6a 00                	push   $0x0
  8027af:	50                   	push   %eax
  8027b0:	6a 1b                	push   $0x1b
  8027b2:	e8 36 fd ff ff       	call   8024ed <syscall>
  8027b7:	83 c4 18             	add    $0x18,%esp
}
  8027ba:	c9                   	leave  
  8027bb:	c3                   	ret    

008027bc <sys_getenvid>:

int32 sys_getenvid(void)
{
  8027bc:	55                   	push   %ebp
  8027bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8027bf:	6a 00                	push   $0x0
  8027c1:	6a 00                	push   $0x0
  8027c3:	6a 00                	push   $0x0
  8027c5:	6a 00                	push   $0x0
  8027c7:	6a 00                	push   $0x0
  8027c9:	6a 05                	push   $0x5
  8027cb:	e8 1d fd ff ff       	call   8024ed <syscall>
  8027d0:	83 c4 18             	add    $0x18,%esp
}
  8027d3:	c9                   	leave  
  8027d4:	c3                   	ret    

008027d5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8027d5:	55                   	push   %ebp
  8027d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8027d8:	6a 00                	push   $0x0
  8027da:	6a 00                	push   $0x0
  8027dc:	6a 00                	push   $0x0
  8027de:	6a 00                	push   $0x0
  8027e0:	6a 00                	push   $0x0
  8027e2:	6a 06                	push   $0x6
  8027e4:	e8 04 fd ff ff       	call   8024ed <syscall>
  8027e9:	83 c4 18             	add    $0x18,%esp
}
  8027ec:	c9                   	leave  
  8027ed:	c3                   	ret    

008027ee <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8027ee:	55                   	push   %ebp
  8027ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8027f1:	6a 00                	push   $0x0
  8027f3:	6a 00                	push   $0x0
  8027f5:	6a 00                	push   $0x0
  8027f7:	6a 00                	push   $0x0
  8027f9:	6a 00                	push   $0x0
  8027fb:	6a 07                	push   $0x7
  8027fd:	e8 eb fc ff ff       	call   8024ed <syscall>
  802802:	83 c4 18             	add    $0x18,%esp
}
  802805:	c9                   	leave  
  802806:	c3                   	ret    

00802807 <sys_exit_env>:


void sys_exit_env(void)
{
  802807:	55                   	push   %ebp
  802808:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80280a:	6a 00                	push   $0x0
  80280c:	6a 00                	push   $0x0
  80280e:	6a 00                	push   $0x0
  802810:	6a 00                	push   $0x0
  802812:	6a 00                	push   $0x0
  802814:	6a 1c                	push   $0x1c
  802816:	e8 d2 fc ff ff       	call   8024ed <syscall>
  80281b:	83 c4 18             	add    $0x18,%esp
}
  80281e:	90                   	nop
  80281f:	c9                   	leave  
  802820:	c3                   	ret    

00802821 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802821:	55                   	push   %ebp
  802822:	89 e5                	mov    %esp,%ebp
  802824:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802827:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80282a:	8d 50 04             	lea    0x4(%eax),%edx
  80282d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802830:	6a 00                	push   $0x0
  802832:	6a 00                	push   $0x0
  802834:	6a 00                	push   $0x0
  802836:	52                   	push   %edx
  802837:	50                   	push   %eax
  802838:	6a 1d                	push   $0x1d
  80283a:	e8 ae fc ff ff       	call   8024ed <syscall>
  80283f:	83 c4 18             	add    $0x18,%esp
	return result;
  802842:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802845:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802848:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80284b:	89 01                	mov    %eax,(%ecx)
  80284d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802850:	8b 45 08             	mov    0x8(%ebp),%eax
  802853:	c9                   	leave  
  802854:	c2 04 00             	ret    $0x4

00802857 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802857:	55                   	push   %ebp
  802858:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80285a:	6a 00                	push   $0x0
  80285c:	6a 00                	push   $0x0
  80285e:	ff 75 10             	pushl  0x10(%ebp)
  802861:	ff 75 0c             	pushl  0xc(%ebp)
  802864:	ff 75 08             	pushl  0x8(%ebp)
  802867:	6a 13                	push   $0x13
  802869:	e8 7f fc ff ff       	call   8024ed <syscall>
  80286e:	83 c4 18             	add    $0x18,%esp
	return ;
  802871:	90                   	nop
}
  802872:	c9                   	leave  
  802873:	c3                   	ret    

00802874 <sys_rcr2>:
uint32 sys_rcr2()
{
  802874:	55                   	push   %ebp
  802875:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802877:	6a 00                	push   $0x0
  802879:	6a 00                	push   $0x0
  80287b:	6a 00                	push   $0x0
  80287d:	6a 00                	push   $0x0
  80287f:	6a 00                	push   $0x0
  802881:	6a 1e                	push   $0x1e
  802883:	e8 65 fc ff ff       	call   8024ed <syscall>
  802888:	83 c4 18             	add    $0x18,%esp
}
  80288b:	c9                   	leave  
  80288c:	c3                   	ret    

0080288d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80288d:	55                   	push   %ebp
  80288e:	89 e5                	mov    %esp,%ebp
  802890:	83 ec 04             	sub    $0x4,%esp
  802893:	8b 45 08             	mov    0x8(%ebp),%eax
  802896:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802899:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80289d:	6a 00                	push   $0x0
  80289f:	6a 00                	push   $0x0
  8028a1:	6a 00                	push   $0x0
  8028a3:	6a 00                	push   $0x0
  8028a5:	50                   	push   %eax
  8028a6:	6a 1f                	push   $0x1f
  8028a8:	e8 40 fc ff ff       	call   8024ed <syscall>
  8028ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8028b0:	90                   	nop
}
  8028b1:	c9                   	leave  
  8028b2:	c3                   	ret    

008028b3 <rsttst>:
void rsttst()
{
  8028b3:	55                   	push   %ebp
  8028b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8028b6:	6a 00                	push   $0x0
  8028b8:	6a 00                	push   $0x0
  8028ba:	6a 00                	push   $0x0
  8028bc:	6a 00                	push   $0x0
  8028be:	6a 00                	push   $0x0
  8028c0:	6a 21                	push   $0x21
  8028c2:	e8 26 fc ff ff       	call   8024ed <syscall>
  8028c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8028ca:	90                   	nop
}
  8028cb:	c9                   	leave  
  8028cc:	c3                   	ret    

008028cd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8028cd:	55                   	push   %ebp
  8028ce:	89 e5                	mov    %esp,%ebp
  8028d0:	83 ec 04             	sub    $0x4,%esp
  8028d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8028d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8028d9:	8b 55 18             	mov    0x18(%ebp),%edx
  8028dc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8028e0:	52                   	push   %edx
  8028e1:	50                   	push   %eax
  8028e2:	ff 75 10             	pushl  0x10(%ebp)
  8028e5:	ff 75 0c             	pushl  0xc(%ebp)
  8028e8:	ff 75 08             	pushl  0x8(%ebp)
  8028eb:	6a 20                	push   $0x20
  8028ed:	e8 fb fb ff ff       	call   8024ed <syscall>
  8028f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8028f5:	90                   	nop
}
  8028f6:	c9                   	leave  
  8028f7:	c3                   	ret    

008028f8 <chktst>:
void chktst(uint32 n)
{
  8028f8:	55                   	push   %ebp
  8028f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8028fb:	6a 00                	push   $0x0
  8028fd:	6a 00                	push   $0x0
  8028ff:	6a 00                	push   $0x0
  802901:	6a 00                	push   $0x0
  802903:	ff 75 08             	pushl  0x8(%ebp)
  802906:	6a 22                	push   $0x22
  802908:	e8 e0 fb ff ff       	call   8024ed <syscall>
  80290d:	83 c4 18             	add    $0x18,%esp
	return ;
  802910:	90                   	nop
}
  802911:	c9                   	leave  
  802912:	c3                   	ret    

00802913 <inctst>:

void inctst()
{
  802913:	55                   	push   %ebp
  802914:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802916:	6a 00                	push   $0x0
  802918:	6a 00                	push   $0x0
  80291a:	6a 00                	push   $0x0
  80291c:	6a 00                	push   $0x0
  80291e:	6a 00                	push   $0x0
  802920:	6a 23                	push   $0x23
  802922:	e8 c6 fb ff ff       	call   8024ed <syscall>
  802927:	83 c4 18             	add    $0x18,%esp
	return ;
  80292a:	90                   	nop
}
  80292b:	c9                   	leave  
  80292c:	c3                   	ret    

0080292d <gettst>:
uint32 gettst()
{
  80292d:	55                   	push   %ebp
  80292e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802930:	6a 00                	push   $0x0
  802932:	6a 00                	push   $0x0
  802934:	6a 00                	push   $0x0
  802936:	6a 00                	push   $0x0
  802938:	6a 00                	push   $0x0
  80293a:	6a 24                	push   $0x24
  80293c:	e8 ac fb ff ff       	call   8024ed <syscall>
  802941:	83 c4 18             	add    $0x18,%esp
}
  802944:	c9                   	leave  
  802945:	c3                   	ret    

00802946 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802946:	55                   	push   %ebp
  802947:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802949:	6a 00                	push   $0x0
  80294b:	6a 00                	push   $0x0
  80294d:	6a 00                	push   $0x0
  80294f:	6a 00                	push   $0x0
  802951:	6a 00                	push   $0x0
  802953:	6a 25                	push   $0x25
  802955:	e8 93 fb ff ff       	call   8024ed <syscall>
  80295a:	83 c4 18             	add    $0x18,%esp
  80295d:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802962:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  802967:	c9                   	leave  
  802968:	c3                   	ret    

00802969 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802969:	55                   	push   %ebp
  80296a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80296c:	8b 45 08             	mov    0x8(%ebp),%eax
  80296f:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802974:	6a 00                	push   $0x0
  802976:	6a 00                	push   $0x0
  802978:	6a 00                	push   $0x0
  80297a:	6a 00                	push   $0x0
  80297c:	ff 75 08             	pushl  0x8(%ebp)
  80297f:	6a 26                	push   $0x26
  802981:	e8 67 fb ff ff       	call   8024ed <syscall>
  802986:	83 c4 18             	add    $0x18,%esp
	return ;
  802989:	90                   	nop
}
  80298a:	c9                   	leave  
  80298b:	c3                   	ret    

0080298c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80298c:	55                   	push   %ebp
  80298d:	89 e5                	mov    %esp,%ebp
  80298f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802990:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802993:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802996:	8b 55 0c             	mov    0xc(%ebp),%edx
  802999:	8b 45 08             	mov    0x8(%ebp),%eax
  80299c:	6a 00                	push   $0x0
  80299e:	53                   	push   %ebx
  80299f:	51                   	push   %ecx
  8029a0:	52                   	push   %edx
  8029a1:	50                   	push   %eax
  8029a2:	6a 27                	push   $0x27
  8029a4:	e8 44 fb ff ff       	call   8024ed <syscall>
  8029a9:	83 c4 18             	add    $0x18,%esp
}
  8029ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029af:	c9                   	leave  
  8029b0:	c3                   	ret    

008029b1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8029b1:	55                   	push   %ebp
  8029b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8029b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ba:	6a 00                	push   $0x0
  8029bc:	6a 00                	push   $0x0
  8029be:	6a 00                	push   $0x0
  8029c0:	52                   	push   %edx
  8029c1:	50                   	push   %eax
  8029c2:	6a 28                	push   $0x28
  8029c4:	e8 24 fb ff ff       	call   8024ed <syscall>
  8029c9:	83 c4 18             	add    $0x18,%esp
}
  8029cc:	c9                   	leave  
  8029cd:	c3                   	ret    

008029ce <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8029ce:	55                   	push   %ebp
  8029cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8029d1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8029d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029da:	6a 00                	push   $0x0
  8029dc:	51                   	push   %ecx
  8029dd:	ff 75 10             	pushl  0x10(%ebp)
  8029e0:	52                   	push   %edx
  8029e1:	50                   	push   %eax
  8029e2:	6a 29                	push   $0x29
  8029e4:	e8 04 fb ff ff       	call   8024ed <syscall>
  8029e9:	83 c4 18             	add    $0x18,%esp
}
  8029ec:	c9                   	leave  
  8029ed:	c3                   	ret    

008029ee <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8029ee:	55                   	push   %ebp
  8029ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8029f1:	6a 00                	push   $0x0
  8029f3:	6a 00                	push   $0x0
  8029f5:	ff 75 10             	pushl  0x10(%ebp)
  8029f8:	ff 75 0c             	pushl  0xc(%ebp)
  8029fb:	ff 75 08             	pushl  0x8(%ebp)
  8029fe:	6a 12                	push   $0x12
  802a00:	e8 e8 fa ff ff       	call   8024ed <syscall>
  802a05:	83 c4 18             	add    $0x18,%esp
	return ;
  802a08:	90                   	nop
}
  802a09:	c9                   	leave  
  802a0a:	c3                   	ret    

00802a0b <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802a0b:	55                   	push   %ebp
  802a0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802a0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a11:	8b 45 08             	mov    0x8(%ebp),%eax
  802a14:	6a 00                	push   $0x0
  802a16:	6a 00                	push   $0x0
  802a18:	6a 00                	push   $0x0
  802a1a:	52                   	push   %edx
  802a1b:	50                   	push   %eax
  802a1c:	6a 2a                	push   $0x2a
  802a1e:	e8 ca fa ff ff       	call   8024ed <syscall>
  802a23:	83 c4 18             	add    $0x18,%esp
	return;
  802a26:	90                   	nop
}
  802a27:	c9                   	leave  
  802a28:	c3                   	ret    

00802a29 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802a29:	55                   	push   %ebp
  802a2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802a2c:	6a 00                	push   $0x0
  802a2e:	6a 00                	push   $0x0
  802a30:	6a 00                	push   $0x0
  802a32:	6a 00                	push   $0x0
  802a34:	6a 00                	push   $0x0
  802a36:	6a 2b                	push   $0x2b
  802a38:	e8 b0 fa ff ff       	call   8024ed <syscall>
  802a3d:	83 c4 18             	add    $0x18,%esp
}
  802a40:	c9                   	leave  
  802a41:	c3                   	ret    

00802a42 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802a42:	55                   	push   %ebp
  802a43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802a45:	6a 00                	push   $0x0
  802a47:	6a 00                	push   $0x0
  802a49:	6a 00                	push   $0x0
  802a4b:	ff 75 0c             	pushl  0xc(%ebp)
  802a4e:	ff 75 08             	pushl  0x8(%ebp)
  802a51:	6a 2d                	push   $0x2d
  802a53:	e8 95 fa ff ff       	call   8024ed <syscall>
  802a58:	83 c4 18             	add    $0x18,%esp
	return;
  802a5b:	90                   	nop
}
  802a5c:	c9                   	leave  
  802a5d:	c3                   	ret    

00802a5e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802a5e:	55                   	push   %ebp
  802a5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802a61:	6a 00                	push   $0x0
  802a63:	6a 00                	push   $0x0
  802a65:	6a 00                	push   $0x0
  802a67:	ff 75 0c             	pushl  0xc(%ebp)
  802a6a:	ff 75 08             	pushl  0x8(%ebp)
  802a6d:	6a 2c                	push   $0x2c
  802a6f:	e8 79 fa ff ff       	call   8024ed <syscall>
  802a74:	83 c4 18             	add    $0x18,%esp
	return ;
  802a77:	90                   	nop
}
  802a78:	c9                   	leave  
  802a79:	c3                   	ret    

00802a7a <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802a7a:	55                   	push   %ebp
  802a7b:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802a7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a80:	8b 45 08             	mov    0x8(%ebp),%eax
  802a83:	6a 00                	push   $0x0
  802a85:	6a 00                	push   $0x0
  802a87:	6a 00                	push   $0x0
  802a89:	52                   	push   %edx
  802a8a:	50                   	push   %eax
  802a8b:	6a 2e                	push   $0x2e
  802a8d:	e8 5b fa ff ff       	call   8024ed <syscall>
  802a92:	83 c4 18             	add    $0x18,%esp
	return ;
  802a95:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  802a96:	c9                   	leave  
  802a97:	c3                   	ret    

00802a98 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802a98:	55                   	push   %ebp
  802a99:	89 e5                	mov    %esp,%ebp
  802a9b:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802a9e:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  802aa5:	72 09                	jb     802ab0 <to_page_va+0x18>
  802aa7:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  802aae:	72 14                	jb     802ac4 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802ab0:	83 ec 04             	sub    $0x4,%esp
  802ab3:	68 a0 48 80 00       	push   $0x8048a0
  802ab8:	6a 15                	push   $0x15
  802aba:	68 cb 48 80 00       	push   $0x8048cb
  802abf:	e8 26 0e 00 00       	call   8038ea <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac7:	ba 60 50 80 00       	mov    $0x805060,%edx
  802acc:	29 d0                	sub    %edx,%eax
  802ace:	c1 f8 02             	sar    $0x2,%eax
  802ad1:	89 c2                	mov    %eax,%edx
  802ad3:	89 d0                	mov    %edx,%eax
  802ad5:	c1 e0 02             	shl    $0x2,%eax
  802ad8:	01 d0                	add    %edx,%eax
  802ada:	c1 e0 02             	shl    $0x2,%eax
  802add:	01 d0                	add    %edx,%eax
  802adf:	c1 e0 02             	shl    $0x2,%eax
  802ae2:	01 d0                	add    %edx,%eax
  802ae4:	89 c1                	mov    %eax,%ecx
  802ae6:	c1 e1 08             	shl    $0x8,%ecx
  802ae9:	01 c8                	add    %ecx,%eax
  802aeb:	89 c1                	mov    %eax,%ecx
  802aed:	c1 e1 10             	shl    $0x10,%ecx
  802af0:	01 c8                	add    %ecx,%eax
  802af2:	01 c0                	add    %eax,%eax
  802af4:	01 d0                	add    %edx,%eax
  802af6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afc:	c1 e0 0c             	shl    $0xc,%eax
  802aff:	89 c2                	mov    %eax,%edx
  802b01:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802b06:	01 d0                	add    %edx,%eax
}
  802b08:	c9                   	leave  
  802b09:	c3                   	ret    

00802b0a <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802b0a:	55                   	push   %ebp
  802b0b:	89 e5                	mov    %esp,%ebp
  802b0d:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802b10:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802b15:	8b 55 08             	mov    0x8(%ebp),%edx
  802b18:	29 c2                	sub    %eax,%edx
  802b1a:	89 d0                	mov    %edx,%eax
  802b1c:	c1 e8 0c             	shr    $0xc,%eax
  802b1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802b22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b26:	78 09                	js     802b31 <to_page_info+0x27>
  802b28:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802b2f:	7e 14                	jle    802b45 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802b31:	83 ec 04             	sub    $0x4,%esp
  802b34:	68 e4 48 80 00       	push   $0x8048e4
  802b39:	6a 22                	push   $0x22
  802b3b:	68 cb 48 80 00       	push   $0x8048cb
  802b40:	e8 a5 0d 00 00       	call   8038ea <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802b45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b48:	89 d0                	mov    %edx,%eax
  802b4a:	01 c0                	add    %eax,%eax
  802b4c:	01 d0                	add    %edx,%eax
  802b4e:	c1 e0 02             	shl    $0x2,%eax
  802b51:	05 60 50 80 00       	add    $0x805060,%eax
}
  802b56:	c9                   	leave  
  802b57:	c3                   	ret    

00802b58 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802b58:	55                   	push   %ebp
  802b59:	89 e5                	mov    %esp,%ebp
  802b5b:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b61:	05 00 00 00 02       	add    $0x2000000,%eax
  802b66:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802b69:	73 16                	jae    802b81 <initialize_dynamic_allocator+0x29>
  802b6b:	68 08 49 80 00       	push   $0x804908
  802b70:	68 2e 49 80 00       	push   $0x80492e
  802b75:	6a 34                	push   $0x34
  802b77:	68 cb 48 80 00       	push   $0x8048cb
  802b7c:	e8 69 0d 00 00       	call   8038ea <_panic>
		is_initialized = 1;
  802b81:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  802b88:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  802b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8e:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  802b93:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b96:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  802b9b:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  802ba2:	00 00 00 
  802ba5:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802bac:	00 00 00 
  802baf:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  802bb6:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  802bb9:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  802bc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802bc7:	eb 36                	jmp    802bff <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  802bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcc:	c1 e0 04             	shl    $0x4,%eax
  802bcf:	05 80 d0 81 00       	add    $0x81d080,%eax
  802bd4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdd:	c1 e0 04             	shl    $0x4,%eax
  802be0:	05 84 d0 81 00       	add    $0x81d084,%eax
  802be5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bee:	c1 e0 04             	shl    $0x4,%eax
  802bf1:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802bf6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  802bfc:	ff 45 f4             	incl   -0xc(%ebp)
  802bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c02:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802c05:	72 c2                	jb     802bc9 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  802c07:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802c0d:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802c12:	29 c2                	sub    %eax,%edx
  802c14:	89 d0                	mov    %edx,%eax
  802c16:	c1 e8 0c             	shr    $0xc,%eax
  802c19:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802c1c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802c23:	e9 c8 00 00 00       	jmp    802cf0 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802c28:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c2b:	89 d0                	mov    %edx,%eax
  802c2d:	01 c0                	add    %eax,%eax
  802c2f:	01 d0                	add    %edx,%eax
  802c31:	c1 e0 02             	shl    $0x2,%eax
  802c34:	05 68 50 80 00       	add    $0x805068,%eax
  802c39:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802c3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c41:	89 d0                	mov    %edx,%eax
  802c43:	01 c0                	add    %eax,%eax
  802c45:	01 d0                	add    %edx,%eax
  802c47:	c1 e0 02             	shl    $0x2,%eax
  802c4a:	05 6a 50 80 00       	add    $0x80506a,%eax
  802c4f:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802c54:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802c5a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802c5d:	89 c8                	mov    %ecx,%eax
  802c5f:	01 c0                	add    %eax,%eax
  802c61:	01 c8                	add    %ecx,%eax
  802c63:	c1 e0 02             	shl    $0x2,%eax
  802c66:	05 64 50 80 00       	add    $0x805064,%eax
  802c6b:	89 10                	mov    %edx,(%eax)
  802c6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c70:	89 d0                	mov    %edx,%eax
  802c72:	01 c0                	add    %eax,%eax
  802c74:	01 d0                	add    %edx,%eax
  802c76:	c1 e0 02             	shl    $0x2,%eax
  802c79:	05 64 50 80 00       	add    $0x805064,%eax
  802c7e:	8b 00                	mov    (%eax),%eax
  802c80:	85 c0                	test   %eax,%eax
  802c82:	74 1b                	je     802c9f <initialize_dynamic_allocator+0x147>
  802c84:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802c8a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802c8d:	89 c8                	mov    %ecx,%eax
  802c8f:	01 c0                	add    %eax,%eax
  802c91:	01 c8                	add    %ecx,%eax
  802c93:	c1 e0 02             	shl    $0x2,%eax
  802c96:	05 60 50 80 00       	add    $0x805060,%eax
  802c9b:	89 02                	mov    %eax,(%edx)
  802c9d:	eb 16                	jmp    802cb5 <initialize_dynamic_allocator+0x15d>
  802c9f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ca2:	89 d0                	mov    %edx,%eax
  802ca4:	01 c0                	add    %eax,%eax
  802ca6:	01 d0                	add    %edx,%eax
  802ca8:	c1 e0 02             	shl    $0x2,%eax
  802cab:	05 60 50 80 00       	add    $0x805060,%eax
  802cb0:	a3 48 50 80 00       	mov    %eax,0x805048
  802cb5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cb8:	89 d0                	mov    %edx,%eax
  802cba:	01 c0                	add    %eax,%eax
  802cbc:	01 d0                	add    %edx,%eax
  802cbe:	c1 e0 02             	shl    $0x2,%eax
  802cc1:	05 60 50 80 00       	add    $0x805060,%eax
  802cc6:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802ccb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cce:	89 d0                	mov    %edx,%eax
  802cd0:	01 c0                	add    %eax,%eax
  802cd2:	01 d0                	add    %edx,%eax
  802cd4:	c1 e0 02             	shl    $0x2,%eax
  802cd7:	05 60 50 80 00       	add    $0x805060,%eax
  802cdc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ce2:	a1 54 50 80 00       	mov    0x805054,%eax
  802ce7:	40                   	inc    %eax
  802ce8:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  802ced:	ff 45 f0             	incl   -0x10(%ebp)
  802cf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802cf6:	0f 82 2c ff ff ff    	jb     802c28 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802cfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802d02:	eb 2f                	jmp    802d33 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  802d04:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d07:	89 d0                	mov    %edx,%eax
  802d09:	01 c0                	add    %eax,%eax
  802d0b:	01 d0                	add    %edx,%eax
  802d0d:	c1 e0 02             	shl    $0x2,%eax
  802d10:	05 68 50 80 00       	add    $0x805068,%eax
  802d15:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  802d1a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d1d:	89 d0                	mov    %edx,%eax
  802d1f:	01 c0                	add    %eax,%eax
  802d21:	01 d0                	add    %edx,%eax
  802d23:	c1 e0 02             	shl    $0x2,%eax
  802d26:	05 6a 50 80 00       	add    $0x80506a,%eax
  802d2b:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802d30:	ff 45 ec             	incl   -0x14(%ebp)
  802d33:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  802d3a:	76 c8                	jbe    802d04 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802d3c:	90                   	nop
  802d3d:	c9                   	leave  
  802d3e:	c3                   	ret    

00802d3f <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802d3f:	55                   	push   %ebp
  802d40:	89 e5                	mov    %esp,%ebp
  802d42:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  802d45:	8b 55 08             	mov    0x8(%ebp),%edx
  802d48:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802d4d:	29 c2                	sub    %eax,%edx
  802d4f:	89 d0                	mov    %edx,%eax
  802d51:	c1 e8 0c             	shr    $0xc,%eax
  802d54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  802d57:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802d5a:	89 d0                	mov    %edx,%eax
  802d5c:	01 c0                	add    %eax,%eax
  802d5e:	01 d0                	add    %edx,%eax
  802d60:	c1 e0 02             	shl    $0x2,%eax
  802d63:	05 68 50 80 00       	add    $0x805068,%eax
  802d68:	8b 00                	mov    (%eax),%eax
  802d6a:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802d6d:	c9                   	leave  
  802d6e:	c3                   	ret    

00802d6f <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802d6f:	55                   	push   %ebp
  802d70:	89 e5                	mov    %esp,%ebp
  802d72:	83 ec 14             	sub    $0x14,%esp
  802d75:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  802d78:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  802d7c:	77 07                	ja     802d85 <nearest_pow2_ceil.1513+0x16>
  802d7e:	b8 01 00 00 00       	mov    $0x1,%eax
  802d83:	eb 20                	jmp    802da5 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  802d85:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  802d8c:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  802d8f:	eb 08                	jmp    802d99 <nearest_pow2_ceil.1513+0x2a>
  802d91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d94:	01 c0                	add    %eax,%eax
  802d96:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802d99:	d1 6d 08             	shrl   0x8(%ebp)
  802d9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802da0:	75 ef                	jne    802d91 <nearest_pow2_ceil.1513+0x22>
        return power;
  802da2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802da5:	c9                   	leave  
  802da6:	c3                   	ret    

00802da7 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802da7:	55                   	push   %ebp
  802da8:	89 e5                	mov    %esp,%ebp
  802daa:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802dad:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802db4:	76 16                	jbe    802dcc <alloc_block+0x25>
  802db6:	68 44 49 80 00       	push   $0x804944
  802dbb:	68 2e 49 80 00       	push   $0x80492e
  802dc0:	6a 72                	push   $0x72
  802dc2:	68 cb 48 80 00       	push   $0x8048cb
  802dc7:	e8 1e 0b 00 00       	call   8038ea <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  802dcc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dd0:	75 0a                	jne    802ddc <alloc_block+0x35>
  802dd2:	b8 00 00 00 00       	mov    $0x0,%eax
  802dd7:	e9 bd 04 00 00       	jmp    803299 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  802ddc:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  802de3:	8b 45 08             	mov    0x8(%ebp),%eax
  802de6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802de9:	73 06                	jae    802df1 <alloc_block+0x4a>
        size = min_block_size;
  802deb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dee:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  802df1:	83 ec 0c             	sub    $0xc,%esp
  802df4:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802df7:	ff 75 08             	pushl  0x8(%ebp)
  802dfa:	89 c1                	mov    %eax,%ecx
  802dfc:	e8 6e ff ff ff       	call   802d6f <nearest_pow2_ceil.1513>
  802e01:	83 c4 10             	add    $0x10,%esp
  802e04:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  802e07:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e0a:	83 ec 0c             	sub    $0xc,%esp
  802e0d:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802e10:	52                   	push   %edx
  802e11:	89 c1                	mov    %eax,%ecx
  802e13:	e8 83 04 00 00       	call   80329b <log2_ceil.1520>
  802e18:	83 c4 10             	add    $0x10,%esp
  802e1b:	83 e8 03             	sub    $0x3,%eax
  802e1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  802e21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e24:	c1 e0 04             	shl    $0x4,%eax
  802e27:	05 80 d0 81 00       	add    $0x81d080,%eax
  802e2c:	8b 00                	mov    (%eax),%eax
  802e2e:	85 c0                	test   %eax,%eax
  802e30:	0f 84 d8 00 00 00    	je     802f0e <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802e36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e39:	c1 e0 04             	shl    $0x4,%eax
  802e3c:	05 80 d0 81 00       	add    $0x81d080,%eax
  802e41:	8b 00                	mov    (%eax),%eax
  802e43:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802e46:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e4a:	75 17                	jne    802e63 <alloc_block+0xbc>
  802e4c:	83 ec 04             	sub    $0x4,%esp
  802e4f:	68 65 49 80 00       	push   $0x804965
  802e54:	68 98 00 00 00       	push   $0x98
  802e59:	68 cb 48 80 00       	push   $0x8048cb
  802e5e:	e8 87 0a 00 00       	call   8038ea <_panic>
  802e63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e66:	8b 00                	mov    (%eax),%eax
  802e68:	85 c0                	test   %eax,%eax
  802e6a:	74 10                	je     802e7c <alloc_block+0xd5>
  802e6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e6f:	8b 00                	mov    (%eax),%eax
  802e71:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e74:	8b 52 04             	mov    0x4(%edx),%edx
  802e77:	89 50 04             	mov    %edx,0x4(%eax)
  802e7a:	eb 14                	jmp    802e90 <alloc_block+0xe9>
  802e7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e7f:	8b 40 04             	mov    0x4(%eax),%eax
  802e82:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e85:	c1 e2 04             	shl    $0x4,%edx
  802e88:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802e8e:	89 02                	mov    %eax,(%edx)
  802e90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e93:	8b 40 04             	mov    0x4(%eax),%eax
  802e96:	85 c0                	test   %eax,%eax
  802e98:	74 0f                	je     802ea9 <alloc_block+0x102>
  802e9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e9d:	8b 40 04             	mov    0x4(%eax),%eax
  802ea0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ea3:	8b 12                	mov    (%edx),%edx
  802ea5:	89 10                	mov    %edx,(%eax)
  802ea7:	eb 13                	jmp    802ebc <alloc_block+0x115>
  802ea9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eac:	8b 00                	mov    (%eax),%eax
  802eae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802eb1:	c1 e2 04             	shl    $0x4,%edx
  802eb4:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802eba:	89 02                	mov    %eax,(%edx)
  802ebc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ebf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ec5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ec8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ecf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ed2:	c1 e0 04             	shl    $0x4,%eax
  802ed5:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802eda:	8b 00                	mov    (%eax),%eax
  802edc:	8d 50 ff             	lea    -0x1(%eax),%edx
  802edf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ee2:	c1 e0 04             	shl    $0x4,%eax
  802ee5:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802eea:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802eec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eef:	83 ec 0c             	sub    $0xc,%esp
  802ef2:	50                   	push   %eax
  802ef3:	e8 12 fc ff ff       	call   802b0a <to_page_info>
  802ef8:	83 c4 10             	add    $0x10,%esp
  802efb:	89 c2                	mov    %eax,%edx
  802efd:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802f01:	48                   	dec    %eax
  802f02:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  802f06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f09:	e9 8b 03 00 00       	jmp    803299 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  802f0e:	a1 48 50 80 00       	mov    0x805048,%eax
  802f13:	85 c0                	test   %eax,%eax
  802f15:	0f 84 64 02 00 00    	je     80317f <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  802f1b:	a1 48 50 80 00       	mov    0x805048,%eax
  802f20:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  802f23:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f27:	75 17                	jne    802f40 <alloc_block+0x199>
  802f29:	83 ec 04             	sub    $0x4,%esp
  802f2c:	68 65 49 80 00       	push   $0x804965
  802f31:	68 a0 00 00 00       	push   $0xa0
  802f36:	68 cb 48 80 00       	push   $0x8048cb
  802f3b:	e8 aa 09 00 00       	call   8038ea <_panic>
  802f40:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f43:	8b 00                	mov    (%eax),%eax
  802f45:	85 c0                	test   %eax,%eax
  802f47:	74 10                	je     802f59 <alloc_block+0x1b2>
  802f49:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f4c:	8b 00                	mov    (%eax),%eax
  802f4e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f51:	8b 52 04             	mov    0x4(%edx),%edx
  802f54:	89 50 04             	mov    %edx,0x4(%eax)
  802f57:	eb 0b                	jmp    802f64 <alloc_block+0x1bd>
  802f59:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f5c:	8b 40 04             	mov    0x4(%eax),%eax
  802f5f:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802f64:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f67:	8b 40 04             	mov    0x4(%eax),%eax
  802f6a:	85 c0                	test   %eax,%eax
  802f6c:	74 0f                	je     802f7d <alloc_block+0x1d6>
  802f6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f71:	8b 40 04             	mov    0x4(%eax),%eax
  802f74:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f77:	8b 12                	mov    (%edx),%edx
  802f79:	89 10                	mov    %edx,(%eax)
  802f7b:	eb 0a                	jmp    802f87 <alloc_block+0x1e0>
  802f7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f80:	8b 00                	mov    (%eax),%eax
  802f82:	a3 48 50 80 00       	mov    %eax,0x805048
  802f87:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f8a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f90:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f93:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9a:	a1 54 50 80 00       	mov    0x805054,%eax
  802f9f:	48                   	dec    %eax
  802fa0:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  802fa5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fab:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  802faf:	b8 00 10 00 00       	mov    $0x1000,%eax
  802fb4:	99                   	cltd   
  802fb5:	f7 7d e8             	idivl  -0x18(%ebp)
  802fb8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fbb:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  802fbf:	83 ec 0c             	sub    $0xc,%esp
  802fc2:	ff 75 dc             	pushl  -0x24(%ebp)
  802fc5:	e8 ce fa ff ff       	call   802a98 <to_page_va>
  802fca:	83 c4 10             	add    $0x10,%esp
  802fcd:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  802fd0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802fd3:	83 ec 0c             	sub    $0xc,%esp
  802fd6:	50                   	push   %eax
  802fd7:	e8 c0 ee ff ff       	call   801e9c <get_page>
  802fdc:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802fdf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802fe6:	e9 aa 00 00 00       	jmp    803095 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  802feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fee:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  802ff2:	89 c2                	mov    %eax,%edx
  802ff4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ff7:	01 d0                	add    %edx,%eax
  802ff9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  802ffc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803000:	75 17                	jne    803019 <alloc_block+0x272>
  803002:	83 ec 04             	sub    $0x4,%esp
  803005:	68 84 49 80 00       	push   $0x804984
  80300a:	68 aa 00 00 00       	push   $0xaa
  80300f:	68 cb 48 80 00       	push   $0x8048cb
  803014:	e8 d1 08 00 00       	call   8038ea <_panic>
  803019:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80301c:	c1 e0 04             	shl    $0x4,%eax
  80301f:	05 84 d0 81 00       	add    $0x81d084,%eax
  803024:	8b 10                	mov    (%eax),%edx
  803026:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803029:	89 50 04             	mov    %edx,0x4(%eax)
  80302c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80302f:	8b 40 04             	mov    0x4(%eax),%eax
  803032:	85 c0                	test   %eax,%eax
  803034:	74 14                	je     80304a <alloc_block+0x2a3>
  803036:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803039:	c1 e0 04             	shl    $0x4,%eax
  80303c:	05 84 d0 81 00       	add    $0x81d084,%eax
  803041:	8b 00                	mov    (%eax),%eax
  803043:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803046:	89 10                	mov    %edx,(%eax)
  803048:	eb 11                	jmp    80305b <alloc_block+0x2b4>
  80304a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80304d:	c1 e0 04             	shl    $0x4,%eax
  803050:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803056:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803059:	89 02                	mov    %eax,(%edx)
  80305b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80305e:	c1 e0 04             	shl    $0x4,%eax
  803061:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803067:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80306a:	89 02                	mov    %eax,(%edx)
  80306c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80306f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803075:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803078:	c1 e0 04             	shl    $0x4,%eax
  80307b:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803080:	8b 00                	mov    (%eax),%eax
  803082:	8d 50 01             	lea    0x1(%eax),%edx
  803085:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803088:	c1 e0 04             	shl    $0x4,%eax
  80308b:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803090:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  803092:	ff 45 f4             	incl   -0xc(%ebp)
  803095:	b8 00 10 00 00       	mov    $0x1000,%eax
  80309a:	99                   	cltd   
  80309b:	f7 7d e8             	idivl  -0x18(%ebp)
  80309e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8030a1:	0f 8f 44 ff ff ff    	jg     802feb <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  8030a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030aa:	c1 e0 04             	shl    $0x4,%eax
  8030ad:	05 80 d0 81 00       	add    $0x81d080,%eax
  8030b2:	8b 00                	mov    (%eax),%eax
  8030b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  8030b7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8030bb:	75 17                	jne    8030d4 <alloc_block+0x32d>
  8030bd:	83 ec 04             	sub    $0x4,%esp
  8030c0:	68 65 49 80 00       	push   $0x804965
  8030c5:	68 ae 00 00 00       	push   $0xae
  8030ca:	68 cb 48 80 00       	push   $0x8048cb
  8030cf:	e8 16 08 00 00       	call   8038ea <_panic>
  8030d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8030d7:	8b 00                	mov    (%eax),%eax
  8030d9:	85 c0                	test   %eax,%eax
  8030db:	74 10                	je     8030ed <alloc_block+0x346>
  8030dd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8030e0:	8b 00                	mov    (%eax),%eax
  8030e2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8030e5:	8b 52 04             	mov    0x4(%edx),%edx
  8030e8:	89 50 04             	mov    %edx,0x4(%eax)
  8030eb:	eb 14                	jmp    803101 <alloc_block+0x35a>
  8030ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8030f0:	8b 40 04             	mov    0x4(%eax),%eax
  8030f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030f6:	c1 e2 04             	shl    $0x4,%edx
  8030f9:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8030ff:	89 02                	mov    %eax,(%edx)
  803101:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803104:	8b 40 04             	mov    0x4(%eax),%eax
  803107:	85 c0                	test   %eax,%eax
  803109:	74 0f                	je     80311a <alloc_block+0x373>
  80310b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80310e:	8b 40 04             	mov    0x4(%eax),%eax
  803111:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803114:	8b 12                	mov    (%edx),%edx
  803116:	89 10                	mov    %edx,(%eax)
  803118:	eb 13                	jmp    80312d <alloc_block+0x386>
  80311a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80311d:	8b 00                	mov    (%eax),%eax
  80311f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803122:	c1 e2 04             	shl    $0x4,%edx
  803125:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  80312b:	89 02                	mov    %eax,(%edx)
  80312d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803130:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803136:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803139:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803140:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803143:	c1 e0 04             	shl    $0x4,%eax
  803146:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80314b:	8b 00                	mov    (%eax),%eax
  80314d:	8d 50 ff             	lea    -0x1(%eax),%edx
  803150:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803153:	c1 e0 04             	shl    $0x4,%eax
  803156:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80315b:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  80315d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803160:	83 ec 0c             	sub    $0xc,%esp
  803163:	50                   	push   %eax
  803164:	e8 a1 f9 ff ff       	call   802b0a <to_page_info>
  803169:	83 c4 10             	add    $0x10,%esp
  80316c:	89 c2                	mov    %eax,%edx
  80316e:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803172:	48                   	dec    %eax
  803173:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  803177:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80317a:	e9 1a 01 00 00       	jmp    803299 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  80317f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803182:	40                   	inc    %eax
  803183:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803186:	e9 ed 00 00 00       	jmp    803278 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  80318b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318e:	c1 e0 04             	shl    $0x4,%eax
  803191:	05 80 d0 81 00       	add    $0x81d080,%eax
  803196:	8b 00                	mov    (%eax),%eax
  803198:	85 c0                	test   %eax,%eax
  80319a:	0f 84 d5 00 00 00    	je     803275 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  8031a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a3:	c1 e0 04             	shl    $0x4,%eax
  8031a6:	05 80 d0 81 00       	add    $0x81d080,%eax
  8031ab:	8b 00                	mov    (%eax),%eax
  8031ad:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  8031b0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8031b4:	75 17                	jne    8031cd <alloc_block+0x426>
  8031b6:	83 ec 04             	sub    $0x4,%esp
  8031b9:	68 65 49 80 00       	push   $0x804965
  8031be:	68 b8 00 00 00       	push   $0xb8
  8031c3:	68 cb 48 80 00       	push   $0x8048cb
  8031c8:	e8 1d 07 00 00       	call   8038ea <_panic>
  8031cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031d0:	8b 00                	mov    (%eax),%eax
  8031d2:	85 c0                	test   %eax,%eax
  8031d4:	74 10                	je     8031e6 <alloc_block+0x43f>
  8031d6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031d9:	8b 00                	mov    (%eax),%eax
  8031db:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8031de:	8b 52 04             	mov    0x4(%edx),%edx
  8031e1:	89 50 04             	mov    %edx,0x4(%eax)
  8031e4:	eb 14                	jmp    8031fa <alloc_block+0x453>
  8031e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031e9:	8b 40 04             	mov    0x4(%eax),%eax
  8031ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031ef:	c1 e2 04             	shl    $0x4,%edx
  8031f2:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8031f8:	89 02                	mov    %eax,(%edx)
  8031fa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031fd:	8b 40 04             	mov    0x4(%eax),%eax
  803200:	85 c0                	test   %eax,%eax
  803202:	74 0f                	je     803213 <alloc_block+0x46c>
  803204:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803207:	8b 40 04             	mov    0x4(%eax),%eax
  80320a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80320d:	8b 12                	mov    (%edx),%edx
  80320f:	89 10                	mov    %edx,(%eax)
  803211:	eb 13                	jmp    803226 <alloc_block+0x47f>
  803213:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803216:	8b 00                	mov    (%eax),%eax
  803218:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80321b:	c1 e2 04             	shl    $0x4,%edx
  80321e:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803224:	89 02                	mov    %eax,(%edx)
  803226:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803229:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80322f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803232:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803239:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323c:	c1 e0 04             	shl    $0x4,%eax
  80323f:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803244:	8b 00                	mov    (%eax),%eax
  803246:	8d 50 ff             	lea    -0x1(%eax),%edx
  803249:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324c:	c1 e0 04             	shl    $0x4,%eax
  80324f:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803254:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  803256:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803259:	83 ec 0c             	sub    $0xc,%esp
  80325c:	50                   	push   %eax
  80325d:	e8 a8 f8 ff ff       	call   802b0a <to_page_info>
  803262:	83 c4 10             	add    $0x10,%esp
  803265:	89 c2                	mov    %eax,%edx
  803267:	66 8b 42 0a          	mov    0xa(%edx),%ax
  80326b:	48                   	dec    %eax
  80326c:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  803270:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803273:	eb 24                	jmp    803299 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  803275:	ff 45 f0             	incl   -0x10(%ebp)
  803278:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  80327c:	0f 8e 09 ff ff ff    	jle    80318b <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  803282:	83 ec 04             	sub    $0x4,%esp
  803285:	68 a7 49 80 00       	push   $0x8049a7
  80328a:	68 bf 00 00 00       	push   $0xbf
  80328f:	68 cb 48 80 00       	push   $0x8048cb
  803294:	e8 51 06 00 00       	call   8038ea <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803299:	c9                   	leave  
  80329a:	c3                   	ret    

0080329b <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  80329b:	55                   	push   %ebp
  80329c:	89 e5                	mov    %esp,%ebp
  80329e:	83 ec 14             	sub    $0x14,%esp
  8032a1:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  8032a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032a8:	75 07                	jne    8032b1 <log2_ceil.1520+0x16>
  8032aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8032af:	eb 1b                	jmp    8032cc <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  8032b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  8032b8:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  8032bb:	eb 06                	jmp    8032c3 <log2_ceil.1520+0x28>
            x >>= 1;
  8032bd:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  8032c0:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  8032c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032c7:	75 f4                	jne    8032bd <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  8032c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  8032cc:	c9                   	leave  
  8032cd:	c3                   	ret    

008032ce <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  8032ce:	55                   	push   %ebp
  8032cf:	89 e5                	mov    %esp,%ebp
  8032d1:	83 ec 14             	sub    $0x14,%esp
  8032d4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  8032d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032db:	75 07                	jne    8032e4 <log2_ceil.1547+0x16>
  8032dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e2:	eb 1b                	jmp    8032ff <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  8032e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  8032eb:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  8032ee:	eb 06                	jmp    8032f6 <log2_ceil.1547+0x28>
			x >>= 1;
  8032f0:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  8032f3:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  8032f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032fa:	75 f4                	jne    8032f0 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  8032fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  8032ff:	c9                   	leave  
  803300:	c3                   	ret    

00803301 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803301:	55                   	push   %ebp
  803302:	89 e5                	mov    %esp,%ebp
  803304:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803307:	8b 55 08             	mov    0x8(%ebp),%edx
  80330a:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80330f:	39 c2                	cmp    %eax,%edx
  803311:	72 0c                	jb     80331f <free_block+0x1e>
  803313:	8b 55 08             	mov    0x8(%ebp),%edx
  803316:	a1 40 50 80 00       	mov    0x805040,%eax
  80331b:	39 c2                	cmp    %eax,%edx
  80331d:	72 19                	jb     803338 <free_block+0x37>
  80331f:	68 ac 49 80 00       	push   $0x8049ac
  803324:	68 2e 49 80 00       	push   $0x80492e
  803329:	68 d0 00 00 00       	push   $0xd0
  80332e:	68 cb 48 80 00       	push   $0x8048cb
  803333:	e8 b2 05 00 00       	call   8038ea <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803338:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80333c:	0f 84 42 03 00 00    	je     803684 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  803342:	8b 55 08             	mov    0x8(%ebp),%edx
  803345:	a1 64 d0 81 00       	mov    0x81d064,%eax
  80334a:	39 c2                	cmp    %eax,%edx
  80334c:	72 0c                	jb     80335a <free_block+0x59>
  80334e:	8b 55 08             	mov    0x8(%ebp),%edx
  803351:	a1 40 50 80 00       	mov    0x805040,%eax
  803356:	39 c2                	cmp    %eax,%edx
  803358:	72 17                	jb     803371 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  80335a:	83 ec 04             	sub    $0x4,%esp
  80335d:	68 e4 49 80 00       	push   $0x8049e4
  803362:	68 e6 00 00 00       	push   $0xe6
  803367:	68 cb 48 80 00       	push   $0x8048cb
  80336c:	e8 79 05 00 00       	call   8038ea <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  803371:	8b 55 08             	mov    0x8(%ebp),%edx
  803374:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803379:	29 c2                	sub    %eax,%edx
  80337b:	89 d0                	mov    %edx,%eax
  80337d:	83 e0 07             	and    $0x7,%eax
  803380:	85 c0                	test   %eax,%eax
  803382:	74 17                	je     80339b <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  803384:	83 ec 04             	sub    $0x4,%esp
  803387:	68 18 4a 80 00       	push   $0x804a18
  80338c:	68 ea 00 00 00       	push   $0xea
  803391:	68 cb 48 80 00       	push   $0x8048cb
  803396:	e8 4f 05 00 00       	call   8038ea <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  80339b:	8b 45 08             	mov    0x8(%ebp),%eax
  80339e:	83 ec 0c             	sub    $0xc,%esp
  8033a1:	50                   	push   %eax
  8033a2:	e8 63 f7 ff ff       	call   802b0a <to_page_info>
  8033a7:	83 c4 10             	add    $0x10,%esp
  8033aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  8033ad:	83 ec 0c             	sub    $0xc,%esp
  8033b0:	ff 75 08             	pushl  0x8(%ebp)
  8033b3:	e8 87 f9 ff ff       	call   802d3f <get_block_size>
  8033b8:	83 c4 10             	add    $0x10,%esp
  8033bb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  8033be:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033c2:	75 17                	jne    8033db <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  8033c4:	83 ec 04             	sub    $0x4,%esp
  8033c7:	68 44 4a 80 00       	push   $0x804a44
  8033cc:	68 f1 00 00 00       	push   $0xf1
  8033d1:	68 cb 48 80 00       	push   $0x8048cb
  8033d6:	e8 0f 05 00 00       	call   8038ea <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  8033db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033de:	83 ec 0c             	sub    $0xc,%esp
  8033e1:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8033e4:	52                   	push   %edx
  8033e5:	89 c1                	mov    %eax,%ecx
  8033e7:	e8 e2 fe ff ff       	call   8032ce <log2_ceil.1547>
  8033ec:	83 c4 10             	add    $0x10,%esp
  8033ef:	83 e8 03             	sub    $0x3,%eax
  8033f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  8033f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  8033fb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8033ff:	75 17                	jne    803418 <free_block+0x117>
  803401:	83 ec 04             	sub    $0x4,%esp
  803404:	68 90 4a 80 00       	push   $0x804a90
  803409:	68 f6 00 00 00       	push   $0xf6
  80340e:	68 cb 48 80 00       	push   $0x8048cb
  803413:	e8 d2 04 00 00       	call   8038ea <_panic>
  803418:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80341b:	c1 e0 04             	shl    $0x4,%eax
  80341e:	05 80 d0 81 00       	add    $0x81d080,%eax
  803423:	8b 10                	mov    (%eax),%edx
  803425:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803428:	89 10                	mov    %edx,(%eax)
  80342a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80342d:	8b 00                	mov    (%eax),%eax
  80342f:	85 c0                	test   %eax,%eax
  803431:	74 15                	je     803448 <free_block+0x147>
  803433:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803436:	c1 e0 04             	shl    $0x4,%eax
  803439:	05 80 d0 81 00       	add    $0x81d080,%eax
  80343e:	8b 00                	mov    (%eax),%eax
  803440:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803443:	89 50 04             	mov    %edx,0x4(%eax)
  803446:	eb 11                	jmp    803459 <free_block+0x158>
  803448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80344b:	c1 e0 04             	shl    $0x4,%eax
  80344e:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803454:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803457:	89 02                	mov    %eax,(%edx)
  803459:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80345c:	c1 e0 04             	shl    $0x4,%eax
  80345f:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803465:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803468:	89 02                	mov    %eax,(%edx)
  80346a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80346d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803474:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803477:	c1 e0 04             	shl    $0x4,%eax
  80347a:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80347f:	8b 00                	mov    (%eax),%eax
  803481:	8d 50 01             	lea    0x1(%eax),%edx
  803484:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803487:	c1 e0 04             	shl    $0x4,%eax
  80348a:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80348f:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  803491:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803494:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803498:	40                   	inc    %eax
  803499:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80349c:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  8034a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8034a3:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8034a8:	29 c2                	sub    %eax,%edx
  8034aa:	89 d0                	mov    %edx,%eax
  8034ac:	c1 e8 0c             	shr    $0xc,%eax
  8034af:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  8034b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034b5:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8034b9:	0f b7 c8             	movzwl %ax,%ecx
  8034bc:	b8 00 10 00 00       	mov    $0x1000,%eax
  8034c1:	99                   	cltd   
  8034c2:	f7 7d e8             	idivl  -0x18(%ebp)
  8034c5:	39 c1                	cmp    %eax,%ecx
  8034c7:	0f 85 b8 01 00 00    	jne    803685 <free_block+0x384>
    	uint32 blocks_removed = 0;
  8034cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  8034d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d7:	c1 e0 04             	shl    $0x4,%eax
  8034da:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034df:	8b 00                	mov    (%eax),%eax
  8034e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8034e4:	e9 d5 00 00 00       	jmp    8035be <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  8034e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ec:	8b 00                	mov    (%eax),%eax
  8034ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  8034f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034f4:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8034f9:	29 c2                	sub    %eax,%edx
  8034fb:	89 d0                	mov    %edx,%eax
  8034fd:	c1 e8 0c             	shr    $0xc,%eax
  803500:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  803503:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803506:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803509:	0f 85 a9 00 00 00    	jne    8035b8 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  80350f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803513:	75 17                	jne    80352c <free_block+0x22b>
  803515:	83 ec 04             	sub    $0x4,%esp
  803518:	68 65 49 80 00       	push   $0x804965
  80351d:	68 04 01 00 00       	push   $0x104
  803522:	68 cb 48 80 00       	push   $0x8048cb
  803527:	e8 be 03 00 00       	call   8038ea <_panic>
  80352c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80352f:	8b 00                	mov    (%eax),%eax
  803531:	85 c0                	test   %eax,%eax
  803533:	74 10                	je     803545 <free_block+0x244>
  803535:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803538:	8b 00                	mov    (%eax),%eax
  80353a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80353d:	8b 52 04             	mov    0x4(%edx),%edx
  803540:	89 50 04             	mov    %edx,0x4(%eax)
  803543:	eb 14                	jmp    803559 <free_block+0x258>
  803545:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803548:	8b 40 04             	mov    0x4(%eax),%eax
  80354b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80354e:	c1 e2 04             	shl    $0x4,%edx
  803551:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803557:	89 02                	mov    %eax,(%edx)
  803559:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80355c:	8b 40 04             	mov    0x4(%eax),%eax
  80355f:	85 c0                	test   %eax,%eax
  803561:	74 0f                	je     803572 <free_block+0x271>
  803563:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803566:	8b 40 04             	mov    0x4(%eax),%eax
  803569:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80356c:	8b 12                	mov    (%edx),%edx
  80356e:	89 10                	mov    %edx,(%eax)
  803570:	eb 13                	jmp    803585 <free_block+0x284>
  803572:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803575:	8b 00                	mov    (%eax),%eax
  803577:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80357a:	c1 e2 04             	shl    $0x4,%edx
  80357d:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803583:	89 02                	mov    %eax,(%edx)
  803585:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803588:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80358e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803591:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803598:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80359b:	c1 e0 04             	shl    $0x4,%eax
  80359e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8035a3:	8b 00                	mov    (%eax),%eax
  8035a5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8035a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ab:	c1 e0 04             	shl    $0x4,%eax
  8035ae:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8035b3:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  8035b5:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  8035b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8035be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035c2:	0f 85 21 ff ff ff    	jne    8034e9 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  8035c8:	b8 00 10 00 00       	mov    $0x1000,%eax
  8035cd:	99                   	cltd   
  8035ce:	f7 7d e8             	idivl  -0x18(%ebp)
  8035d1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8035d4:	74 17                	je     8035ed <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  8035d6:	83 ec 04             	sub    $0x4,%esp
  8035d9:	68 b4 4a 80 00       	push   $0x804ab4
  8035de:	68 0c 01 00 00       	push   $0x10c
  8035e3:	68 cb 48 80 00       	push   $0x8048cb
  8035e8:	e8 fd 02 00 00       	call   8038ea <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  8035ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035f0:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  8035f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035f9:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  8035ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803603:	75 17                	jne    80361c <free_block+0x31b>
  803605:	83 ec 04             	sub    $0x4,%esp
  803608:	68 84 49 80 00       	push   $0x804984
  80360d:	68 11 01 00 00       	push   $0x111
  803612:	68 cb 48 80 00       	push   $0x8048cb
  803617:	e8 ce 02 00 00       	call   8038ea <_panic>
  80361c:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803622:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803625:	89 50 04             	mov    %edx,0x4(%eax)
  803628:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80362b:	8b 40 04             	mov    0x4(%eax),%eax
  80362e:	85 c0                	test   %eax,%eax
  803630:	74 0c                	je     80363e <free_block+0x33d>
  803632:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803637:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80363a:	89 10                	mov    %edx,(%eax)
  80363c:	eb 08                	jmp    803646 <free_block+0x345>
  80363e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803641:	a3 48 50 80 00       	mov    %eax,0x805048
  803646:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803649:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80364e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803651:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803657:	a1 54 50 80 00       	mov    0x805054,%eax
  80365c:	40                   	inc    %eax
  80365d:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  803662:	83 ec 0c             	sub    $0xc,%esp
  803665:	ff 75 ec             	pushl  -0x14(%ebp)
  803668:	e8 2b f4 ff ff       	call   802a98 <to_page_va>
  80366d:	83 c4 10             	add    $0x10,%esp
  803670:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  803673:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803676:	83 ec 0c             	sub    $0xc,%esp
  803679:	50                   	push   %eax
  80367a:	e8 69 e8 ff ff       	call   801ee8 <return_page>
  80367f:	83 c4 10             	add    $0x10,%esp
  803682:	eb 01                	jmp    803685 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803684:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803685:	c9                   	leave  
  803686:	c3                   	ret    

00803687 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803687:	55                   	push   %ebp
  803688:	89 e5                	mov    %esp,%ebp
  80368a:	83 ec 14             	sub    $0x14,%esp
  80368d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  803690:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803694:	77 07                	ja     80369d <nearest_pow2_ceil.1572+0x16>
      return 1;
  803696:	b8 01 00 00 00       	mov    $0x1,%eax
  80369b:	eb 20                	jmp    8036bd <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  80369d:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  8036a4:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  8036a7:	eb 08                	jmp    8036b1 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  8036a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8036ac:	01 c0                	add    %eax,%eax
  8036ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  8036b1:	d1 6d 08             	shrl   0x8(%ebp)
  8036b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036b8:	75 ef                	jne    8036a9 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  8036ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  8036bd:	c9                   	leave  
  8036be:	c3                   	ret    

008036bf <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  8036bf:	55                   	push   %ebp
  8036c0:	89 e5                	mov    %esp,%ebp
  8036c2:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  8036c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036c9:	75 13                	jne    8036de <realloc_block+0x1f>
    return alloc_block(new_size);
  8036cb:	83 ec 0c             	sub    $0xc,%esp
  8036ce:	ff 75 0c             	pushl  0xc(%ebp)
  8036d1:	e8 d1 f6 ff ff       	call   802da7 <alloc_block>
  8036d6:	83 c4 10             	add    $0x10,%esp
  8036d9:	e9 d9 00 00 00       	jmp    8037b7 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  8036de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036e2:	75 18                	jne    8036fc <realloc_block+0x3d>
    free_block(va);
  8036e4:	83 ec 0c             	sub    $0xc,%esp
  8036e7:	ff 75 08             	pushl  0x8(%ebp)
  8036ea:	e8 12 fc ff ff       	call   803301 <free_block>
  8036ef:	83 c4 10             	add    $0x10,%esp
    return NULL;
  8036f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8036f7:	e9 bb 00 00 00       	jmp    8037b7 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  8036fc:	83 ec 0c             	sub    $0xc,%esp
  8036ff:	ff 75 08             	pushl  0x8(%ebp)
  803702:	e8 38 f6 ff ff       	call   802d3f <get_block_size>
  803707:	83 c4 10             	add    $0x10,%esp
  80370a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  80370d:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  803714:	8b 45 0c             	mov    0xc(%ebp),%eax
  803717:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80371a:	73 06                	jae    803722 <realloc_block+0x63>
    new_size = min_block_size;
  80371c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80371f:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  803722:	83 ec 0c             	sub    $0xc,%esp
  803725:	8d 45 d8             	lea    -0x28(%ebp),%eax
  803728:	ff 75 0c             	pushl  0xc(%ebp)
  80372b:	89 c1                	mov    %eax,%ecx
  80372d:	e8 55 ff ff ff       	call   803687 <nearest_pow2_ceil.1572>
  803732:	83 c4 10             	add    $0x10,%esp
  803735:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  803738:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80373b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80373e:	75 05                	jne    803745 <realloc_block+0x86>
    return va;
  803740:	8b 45 08             	mov    0x8(%ebp),%eax
  803743:	eb 72                	jmp    8037b7 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  803745:	83 ec 0c             	sub    $0xc,%esp
  803748:	ff 75 0c             	pushl  0xc(%ebp)
  80374b:	e8 57 f6 ff ff       	call   802da7 <alloc_block>
  803750:	83 c4 10             	add    $0x10,%esp
  803753:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  803756:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80375a:	75 07                	jne    803763 <realloc_block+0xa4>
    return NULL;
  80375c:	b8 00 00 00 00       	mov    $0x0,%eax
  803761:	eb 54                	jmp    8037b7 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  803763:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803766:	8b 45 0c             	mov    0xc(%ebp),%eax
  803769:	39 d0                	cmp    %edx,%eax
  80376b:	76 02                	jbe    80376f <realloc_block+0xb0>
  80376d:	89 d0                	mov    %edx,%eax
  80376f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  803772:	8b 45 08             	mov    0x8(%ebp),%eax
  803775:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  803778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80377b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  80377e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803785:	eb 17                	jmp    80379e <realloc_block+0xdf>
    dst[i] = src[i];
  803787:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80378a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378d:	01 c2                	add    %eax,%edx
  80378f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  803792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803795:	01 c8                	add    %ecx,%eax
  803797:	8a 00                	mov    (%eax),%al
  803799:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  80379b:	ff 45 f4             	incl   -0xc(%ebp)
  80379e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8037a4:	72 e1                	jb     803787 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  8037a6:	83 ec 0c             	sub    $0xc,%esp
  8037a9:	ff 75 08             	pushl  0x8(%ebp)
  8037ac:	e8 50 fb ff ff       	call   803301 <free_block>
  8037b1:	83 c4 10             	add    $0x10,%esp

  return new_va;
  8037b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8037b7:	c9                   	leave  
  8037b8:	c3                   	ret    

008037b9 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8037b9:	55                   	push   %ebp
  8037ba:	89 e5                	mov    %esp,%ebp
  8037bc:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  8037bf:	83 ec 04             	sub    $0x4,%esp
  8037c2:	68 e8 4a 80 00       	push   $0x804ae8
  8037c7:	6a 07                	push   $0x7
  8037c9:	68 17 4b 80 00       	push   $0x804b17
  8037ce:	e8 17 01 00 00       	call   8038ea <_panic>

008037d3 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8037d3:	55                   	push   %ebp
  8037d4:	89 e5                	mov    %esp,%ebp
  8037d6:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  8037d9:	83 ec 04             	sub    $0x4,%esp
  8037dc:	68 28 4b 80 00       	push   $0x804b28
  8037e1:	6a 0b                	push   $0xb
  8037e3:	68 17 4b 80 00       	push   $0x804b17
  8037e8:	e8 fd 00 00 00       	call   8038ea <_panic>

008037ed <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  8037ed:	55                   	push   %ebp
  8037ee:	89 e5                	mov    %esp,%ebp
  8037f0:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  8037f3:	83 ec 04             	sub    $0x4,%esp
  8037f6:	68 54 4b 80 00       	push   $0x804b54
  8037fb:	6a 10                	push   $0x10
  8037fd:	68 17 4b 80 00       	push   $0x804b17
  803802:	e8 e3 00 00 00       	call   8038ea <_panic>

00803807 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  803807:	55                   	push   %ebp
  803808:	89 e5                	mov    %esp,%ebp
  80380a:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  80380d:	83 ec 04             	sub    $0x4,%esp
  803810:	68 84 4b 80 00       	push   $0x804b84
  803815:	6a 15                	push   $0x15
  803817:	68 17 4b 80 00       	push   $0x804b17
  80381c:	e8 c9 00 00 00       	call   8038ea <_panic>

00803821 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  803821:	55                   	push   %ebp
  803822:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803824:	8b 45 08             	mov    0x8(%ebp),%eax
  803827:	8b 40 10             	mov    0x10(%eax),%eax
}
  80382a:	5d                   	pop    %ebp
  80382b:	c3                   	ret    

0080382c <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80382c:	55                   	push   %ebp
  80382d:	89 e5                	mov    %esp,%ebp
  80382f:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803832:	8b 55 08             	mov    0x8(%ebp),%edx
  803835:	89 d0                	mov    %edx,%eax
  803837:	c1 e0 02             	shl    $0x2,%eax
  80383a:	01 d0                	add    %edx,%eax
  80383c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803843:	01 d0                	add    %edx,%eax
  803845:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80384c:	01 d0                	add    %edx,%eax
  80384e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803855:	01 d0                	add    %edx,%eax
  803857:	c1 e0 04             	shl    $0x4,%eax
  80385a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  80385d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  803864:	0f 31                	rdtsc  
  803866:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803869:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  80386c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80386f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803872:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803875:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  803878:	eb 46                	jmp    8038c0 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  80387a:	0f 31                	rdtsc  
  80387c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80387f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  803882:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803885:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803888:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80388b:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80388e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803891:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803894:	29 c2                	sub    %eax,%edx
  803896:	89 d0                	mov    %edx,%eax
  803898:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80389b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80389e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a1:	89 d1                	mov    %edx,%ecx
  8038a3:	29 c1                	sub    %eax,%ecx
  8038a5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8038a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038ab:	39 c2                	cmp    %eax,%edx
  8038ad:	0f 97 c0             	seta   %al
  8038b0:	0f b6 c0             	movzbl %al,%eax
  8038b3:	29 c1                	sub    %eax,%ecx
  8038b5:	89 c8                	mov    %ecx,%eax
  8038b7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8038ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8038bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8038c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8038c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8038c6:	72 b2                	jb     80387a <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8038c8:	90                   	nop
  8038c9:	c9                   	leave  
  8038ca:	c3                   	ret    

008038cb <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8038cb:	55                   	push   %ebp
  8038cc:	89 e5                	mov    %esp,%ebp
  8038ce:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8038d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8038d8:	eb 03                	jmp    8038dd <busy_wait+0x12>
  8038da:	ff 45 fc             	incl   -0x4(%ebp)
  8038dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8038e0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038e3:	72 f5                	jb     8038da <busy_wait+0xf>
	return i;
  8038e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8038e8:	c9                   	leave  
  8038e9:	c3                   	ret    

008038ea <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8038ea:	55                   	push   %ebp
  8038eb:	89 e5                	mov    %esp,%ebp
  8038ed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8038f0:	8d 45 10             	lea    0x10(%ebp),%eax
  8038f3:	83 c0 04             	add    $0x4,%eax
  8038f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8038f9:	a1 1c d1 81 00       	mov    0x81d11c,%eax
  8038fe:	85 c0                	test   %eax,%eax
  803900:	74 16                	je     803918 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803902:	a1 1c d1 81 00       	mov    0x81d11c,%eax
  803907:	83 ec 08             	sub    $0x8,%esp
  80390a:	50                   	push   %eax
  80390b:	68 b4 4b 80 00       	push   $0x804bb4
  803910:	e8 eb cf ff ff       	call   800900 <cprintf>
  803915:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  803918:	a1 04 50 80 00       	mov    0x805004,%eax
  80391d:	83 ec 0c             	sub    $0xc,%esp
  803920:	ff 75 0c             	pushl  0xc(%ebp)
  803923:	ff 75 08             	pushl  0x8(%ebp)
  803926:	50                   	push   %eax
  803927:	68 bc 4b 80 00       	push   $0x804bbc
  80392c:	6a 74                	push   $0x74
  80392e:	e8 fa cf ff ff       	call   80092d <cprintf_colored>
  803933:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  803936:	8b 45 10             	mov    0x10(%ebp),%eax
  803939:	83 ec 08             	sub    $0x8,%esp
  80393c:	ff 75 f4             	pushl  -0xc(%ebp)
  80393f:	50                   	push   %eax
  803940:	e8 4c cf ff ff       	call   800891 <vcprintf>
  803945:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803948:	83 ec 08             	sub    $0x8,%esp
  80394b:	6a 00                	push   $0x0
  80394d:	68 e4 4b 80 00       	push   $0x804be4
  803952:	e8 3a cf ff ff       	call   800891 <vcprintf>
  803957:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80395a:	e8 b3 ce ff ff       	call   800812 <exit>

	// should not return here
	while (1) ;
  80395f:	eb fe                	jmp    80395f <_panic+0x75>

00803961 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803961:	55                   	push   %ebp
  803962:	89 e5                	mov    %esp,%ebp
  803964:	53                   	push   %ebx
  803965:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803968:	a1 20 50 80 00       	mov    0x805020,%eax
  80396d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803973:	8b 45 0c             	mov    0xc(%ebp),%eax
  803976:	39 c2                	cmp    %eax,%edx
  803978:	74 14                	je     80398e <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80397a:	83 ec 04             	sub    $0x4,%esp
  80397d:	68 e8 4b 80 00       	push   $0x804be8
  803982:	6a 26                	push   $0x26
  803984:	68 34 4c 80 00       	push   $0x804c34
  803989:	e8 5c ff ff ff       	call   8038ea <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80398e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803995:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80399c:	e9 d9 00 00 00       	jmp    803a7a <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8039a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8039ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ae:	01 d0                	add    %edx,%eax
  8039b0:	8b 00                	mov    (%eax),%eax
  8039b2:	85 c0                	test   %eax,%eax
  8039b4:	75 08                	jne    8039be <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8039b6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8039b9:	e9 b9 00 00 00       	jmp    803a77 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8039be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8039c5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8039cc:	eb 79                	jmp    803a47 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8039ce:	a1 20 50 80 00       	mov    0x805020,%eax
  8039d3:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8039d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039dc:	89 d0                	mov    %edx,%eax
  8039de:	01 c0                	add    %eax,%eax
  8039e0:	01 d0                	add    %edx,%eax
  8039e2:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8039e9:	01 d8                	add    %ebx,%eax
  8039eb:	01 d0                	add    %edx,%eax
  8039ed:	01 c8                	add    %ecx,%eax
  8039ef:	8a 40 04             	mov    0x4(%eax),%al
  8039f2:	84 c0                	test   %al,%al
  8039f4:	75 4e                	jne    803a44 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8039f6:	a1 20 50 80 00       	mov    0x805020,%eax
  8039fb:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  803a01:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a04:	89 d0                	mov    %edx,%eax
  803a06:	01 c0                	add    %eax,%eax
  803a08:	01 d0                	add    %edx,%eax
  803a0a:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  803a11:	01 d8                	add    %ebx,%eax
  803a13:	01 d0                	add    %edx,%eax
  803a15:	01 c8                	add    %ecx,%eax
  803a17:	8b 00                	mov    (%eax),%eax
  803a19:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803a1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a1f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803a24:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a29:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803a30:	8b 45 08             	mov    0x8(%ebp),%eax
  803a33:	01 c8                	add    %ecx,%eax
  803a35:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a37:	39 c2                	cmp    %eax,%edx
  803a39:	75 09                	jne    803a44 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  803a3b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803a42:	eb 19                	jmp    803a5d <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a44:	ff 45 e8             	incl   -0x18(%ebp)
  803a47:	a1 20 50 80 00       	mov    0x805020,%eax
  803a4c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803a52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a55:	39 c2                	cmp    %eax,%edx
  803a57:	0f 87 71 ff ff ff    	ja     8039ce <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803a5d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803a61:	75 14                	jne    803a77 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  803a63:	83 ec 04             	sub    $0x4,%esp
  803a66:	68 40 4c 80 00       	push   $0x804c40
  803a6b:	6a 3a                	push   $0x3a
  803a6d:	68 34 4c 80 00       	push   $0x804c34
  803a72:	e8 73 fe ff ff       	call   8038ea <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803a77:	ff 45 f0             	incl   -0x10(%ebp)
  803a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a7d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803a80:	0f 8c 1b ff ff ff    	jl     8039a1 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803a86:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a8d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803a94:	eb 2e                	jmp    803ac4 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803a96:	a1 20 50 80 00       	mov    0x805020,%eax
  803a9b:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  803aa1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803aa4:	89 d0                	mov    %edx,%eax
  803aa6:	01 c0                	add    %eax,%eax
  803aa8:	01 d0                	add    %edx,%eax
  803aaa:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  803ab1:	01 d8                	add    %ebx,%eax
  803ab3:	01 d0                	add    %edx,%eax
  803ab5:	01 c8                	add    %ecx,%eax
  803ab7:	8a 40 04             	mov    0x4(%eax),%al
  803aba:	3c 01                	cmp    $0x1,%al
  803abc:	75 03                	jne    803ac1 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  803abe:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ac1:	ff 45 e0             	incl   -0x20(%ebp)
  803ac4:	a1 20 50 80 00       	mov    0x805020,%eax
  803ac9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803acf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ad2:	39 c2                	cmp    %eax,%edx
  803ad4:	77 c0                	ja     803a96 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803adc:	74 14                	je     803af2 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  803ade:	83 ec 04             	sub    $0x4,%esp
  803ae1:	68 94 4c 80 00       	push   $0x804c94
  803ae6:	6a 44                	push   $0x44
  803ae8:	68 34 4c 80 00       	push   $0x804c34
  803aed:	e8 f8 fd ff ff       	call   8038ea <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803af2:	90                   	nop
  803af3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803af6:	c9                   	leave  
  803af7:	c3                   	ret    

00803af8 <__udivdi3>:
  803af8:	55                   	push   %ebp
  803af9:	57                   	push   %edi
  803afa:	56                   	push   %esi
  803afb:	53                   	push   %ebx
  803afc:	83 ec 1c             	sub    $0x1c,%esp
  803aff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b03:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b07:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b0b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b0f:	89 ca                	mov    %ecx,%edx
  803b11:	89 f8                	mov    %edi,%eax
  803b13:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b17:	85 f6                	test   %esi,%esi
  803b19:	75 2d                	jne    803b48 <__udivdi3+0x50>
  803b1b:	39 cf                	cmp    %ecx,%edi
  803b1d:	77 65                	ja     803b84 <__udivdi3+0x8c>
  803b1f:	89 fd                	mov    %edi,%ebp
  803b21:	85 ff                	test   %edi,%edi
  803b23:	75 0b                	jne    803b30 <__udivdi3+0x38>
  803b25:	b8 01 00 00 00       	mov    $0x1,%eax
  803b2a:	31 d2                	xor    %edx,%edx
  803b2c:	f7 f7                	div    %edi
  803b2e:	89 c5                	mov    %eax,%ebp
  803b30:	31 d2                	xor    %edx,%edx
  803b32:	89 c8                	mov    %ecx,%eax
  803b34:	f7 f5                	div    %ebp
  803b36:	89 c1                	mov    %eax,%ecx
  803b38:	89 d8                	mov    %ebx,%eax
  803b3a:	f7 f5                	div    %ebp
  803b3c:	89 cf                	mov    %ecx,%edi
  803b3e:	89 fa                	mov    %edi,%edx
  803b40:	83 c4 1c             	add    $0x1c,%esp
  803b43:	5b                   	pop    %ebx
  803b44:	5e                   	pop    %esi
  803b45:	5f                   	pop    %edi
  803b46:	5d                   	pop    %ebp
  803b47:	c3                   	ret    
  803b48:	39 ce                	cmp    %ecx,%esi
  803b4a:	77 28                	ja     803b74 <__udivdi3+0x7c>
  803b4c:	0f bd fe             	bsr    %esi,%edi
  803b4f:	83 f7 1f             	xor    $0x1f,%edi
  803b52:	75 40                	jne    803b94 <__udivdi3+0x9c>
  803b54:	39 ce                	cmp    %ecx,%esi
  803b56:	72 0a                	jb     803b62 <__udivdi3+0x6a>
  803b58:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b5c:	0f 87 9e 00 00 00    	ja     803c00 <__udivdi3+0x108>
  803b62:	b8 01 00 00 00       	mov    $0x1,%eax
  803b67:	89 fa                	mov    %edi,%edx
  803b69:	83 c4 1c             	add    $0x1c,%esp
  803b6c:	5b                   	pop    %ebx
  803b6d:	5e                   	pop    %esi
  803b6e:	5f                   	pop    %edi
  803b6f:	5d                   	pop    %ebp
  803b70:	c3                   	ret    
  803b71:	8d 76 00             	lea    0x0(%esi),%esi
  803b74:	31 ff                	xor    %edi,%edi
  803b76:	31 c0                	xor    %eax,%eax
  803b78:	89 fa                	mov    %edi,%edx
  803b7a:	83 c4 1c             	add    $0x1c,%esp
  803b7d:	5b                   	pop    %ebx
  803b7e:	5e                   	pop    %esi
  803b7f:	5f                   	pop    %edi
  803b80:	5d                   	pop    %ebp
  803b81:	c3                   	ret    
  803b82:	66 90                	xchg   %ax,%ax
  803b84:	89 d8                	mov    %ebx,%eax
  803b86:	f7 f7                	div    %edi
  803b88:	31 ff                	xor    %edi,%edi
  803b8a:	89 fa                	mov    %edi,%edx
  803b8c:	83 c4 1c             	add    $0x1c,%esp
  803b8f:	5b                   	pop    %ebx
  803b90:	5e                   	pop    %esi
  803b91:	5f                   	pop    %edi
  803b92:	5d                   	pop    %ebp
  803b93:	c3                   	ret    
  803b94:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b99:	89 eb                	mov    %ebp,%ebx
  803b9b:	29 fb                	sub    %edi,%ebx
  803b9d:	89 f9                	mov    %edi,%ecx
  803b9f:	d3 e6                	shl    %cl,%esi
  803ba1:	89 c5                	mov    %eax,%ebp
  803ba3:	88 d9                	mov    %bl,%cl
  803ba5:	d3 ed                	shr    %cl,%ebp
  803ba7:	89 e9                	mov    %ebp,%ecx
  803ba9:	09 f1                	or     %esi,%ecx
  803bab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803baf:	89 f9                	mov    %edi,%ecx
  803bb1:	d3 e0                	shl    %cl,%eax
  803bb3:	89 c5                	mov    %eax,%ebp
  803bb5:	89 d6                	mov    %edx,%esi
  803bb7:	88 d9                	mov    %bl,%cl
  803bb9:	d3 ee                	shr    %cl,%esi
  803bbb:	89 f9                	mov    %edi,%ecx
  803bbd:	d3 e2                	shl    %cl,%edx
  803bbf:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bc3:	88 d9                	mov    %bl,%cl
  803bc5:	d3 e8                	shr    %cl,%eax
  803bc7:	09 c2                	or     %eax,%edx
  803bc9:	89 d0                	mov    %edx,%eax
  803bcb:	89 f2                	mov    %esi,%edx
  803bcd:	f7 74 24 0c          	divl   0xc(%esp)
  803bd1:	89 d6                	mov    %edx,%esi
  803bd3:	89 c3                	mov    %eax,%ebx
  803bd5:	f7 e5                	mul    %ebp
  803bd7:	39 d6                	cmp    %edx,%esi
  803bd9:	72 19                	jb     803bf4 <__udivdi3+0xfc>
  803bdb:	74 0b                	je     803be8 <__udivdi3+0xf0>
  803bdd:	89 d8                	mov    %ebx,%eax
  803bdf:	31 ff                	xor    %edi,%edi
  803be1:	e9 58 ff ff ff       	jmp    803b3e <__udivdi3+0x46>
  803be6:	66 90                	xchg   %ax,%ax
  803be8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803bec:	89 f9                	mov    %edi,%ecx
  803bee:	d3 e2                	shl    %cl,%edx
  803bf0:	39 c2                	cmp    %eax,%edx
  803bf2:	73 e9                	jae    803bdd <__udivdi3+0xe5>
  803bf4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bf7:	31 ff                	xor    %edi,%edi
  803bf9:	e9 40 ff ff ff       	jmp    803b3e <__udivdi3+0x46>
  803bfe:	66 90                	xchg   %ax,%ax
  803c00:	31 c0                	xor    %eax,%eax
  803c02:	e9 37 ff ff ff       	jmp    803b3e <__udivdi3+0x46>
  803c07:	90                   	nop

00803c08 <__umoddi3>:
  803c08:	55                   	push   %ebp
  803c09:	57                   	push   %edi
  803c0a:	56                   	push   %esi
  803c0b:	53                   	push   %ebx
  803c0c:	83 ec 1c             	sub    $0x1c,%esp
  803c0f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c13:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c1b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c23:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c27:	89 f3                	mov    %esi,%ebx
  803c29:	89 fa                	mov    %edi,%edx
  803c2b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c2f:	89 34 24             	mov    %esi,(%esp)
  803c32:	85 c0                	test   %eax,%eax
  803c34:	75 1a                	jne    803c50 <__umoddi3+0x48>
  803c36:	39 f7                	cmp    %esi,%edi
  803c38:	0f 86 a2 00 00 00    	jbe    803ce0 <__umoddi3+0xd8>
  803c3e:	89 c8                	mov    %ecx,%eax
  803c40:	89 f2                	mov    %esi,%edx
  803c42:	f7 f7                	div    %edi
  803c44:	89 d0                	mov    %edx,%eax
  803c46:	31 d2                	xor    %edx,%edx
  803c48:	83 c4 1c             	add    $0x1c,%esp
  803c4b:	5b                   	pop    %ebx
  803c4c:	5e                   	pop    %esi
  803c4d:	5f                   	pop    %edi
  803c4e:	5d                   	pop    %ebp
  803c4f:	c3                   	ret    
  803c50:	39 f0                	cmp    %esi,%eax
  803c52:	0f 87 ac 00 00 00    	ja     803d04 <__umoddi3+0xfc>
  803c58:	0f bd e8             	bsr    %eax,%ebp
  803c5b:	83 f5 1f             	xor    $0x1f,%ebp
  803c5e:	0f 84 ac 00 00 00    	je     803d10 <__umoddi3+0x108>
  803c64:	bf 20 00 00 00       	mov    $0x20,%edi
  803c69:	29 ef                	sub    %ebp,%edi
  803c6b:	89 fe                	mov    %edi,%esi
  803c6d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c71:	89 e9                	mov    %ebp,%ecx
  803c73:	d3 e0                	shl    %cl,%eax
  803c75:	89 d7                	mov    %edx,%edi
  803c77:	89 f1                	mov    %esi,%ecx
  803c79:	d3 ef                	shr    %cl,%edi
  803c7b:	09 c7                	or     %eax,%edi
  803c7d:	89 e9                	mov    %ebp,%ecx
  803c7f:	d3 e2                	shl    %cl,%edx
  803c81:	89 14 24             	mov    %edx,(%esp)
  803c84:	89 d8                	mov    %ebx,%eax
  803c86:	d3 e0                	shl    %cl,%eax
  803c88:	89 c2                	mov    %eax,%edx
  803c8a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c8e:	d3 e0                	shl    %cl,%eax
  803c90:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c94:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c98:	89 f1                	mov    %esi,%ecx
  803c9a:	d3 e8                	shr    %cl,%eax
  803c9c:	09 d0                	or     %edx,%eax
  803c9e:	d3 eb                	shr    %cl,%ebx
  803ca0:	89 da                	mov    %ebx,%edx
  803ca2:	f7 f7                	div    %edi
  803ca4:	89 d3                	mov    %edx,%ebx
  803ca6:	f7 24 24             	mull   (%esp)
  803ca9:	89 c6                	mov    %eax,%esi
  803cab:	89 d1                	mov    %edx,%ecx
  803cad:	39 d3                	cmp    %edx,%ebx
  803caf:	0f 82 87 00 00 00    	jb     803d3c <__umoddi3+0x134>
  803cb5:	0f 84 91 00 00 00    	je     803d4c <__umoddi3+0x144>
  803cbb:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cbf:	29 f2                	sub    %esi,%edx
  803cc1:	19 cb                	sbb    %ecx,%ebx
  803cc3:	89 d8                	mov    %ebx,%eax
  803cc5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803cc9:	d3 e0                	shl    %cl,%eax
  803ccb:	89 e9                	mov    %ebp,%ecx
  803ccd:	d3 ea                	shr    %cl,%edx
  803ccf:	09 d0                	or     %edx,%eax
  803cd1:	89 e9                	mov    %ebp,%ecx
  803cd3:	d3 eb                	shr    %cl,%ebx
  803cd5:	89 da                	mov    %ebx,%edx
  803cd7:	83 c4 1c             	add    $0x1c,%esp
  803cda:	5b                   	pop    %ebx
  803cdb:	5e                   	pop    %esi
  803cdc:	5f                   	pop    %edi
  803cdd:	5d                   	pop    %ebp
  803cde:	c3                   	ret    
  803cdf:	90                   	nop
  803ce0:	89 fd                	mov    %edi,%ebp
  803ce2:	85 ff                	test   %edi,%edi
  803ce4:	75 0b                	jne    803cf1 <__umoddi3+0xe9>
  803ce6:	b8 01 00 00 00       	mov    $0x1,%eax
  803ceb:	31 d2                	xor    %edx,%edx
  803ced:	f7 f7                	div    %edi
  803cef:	89 c5                	mov    %eax,%ebp
  803cf1:	89 f0                	mov    %esi,%eax
  803cf3:	31 d2                	xor    %edx,%edx
  803cf5:	f7 f5                	div    %ebp
  803cf7:	89 c8                	mov    %ecx,%eax
  803cf9:	f7 f5                	div    %ebp
  803cfb:	89 d0                	mov    %edx,%eax
  803cfd:	e9 44 ff ff ff       	jmp    803c46 <__umoddi3+0x3e>
  803d02:	66 90                	xchg   %ax,%ax
  803d04:	89 c8                	mov    %ecx,%eax
  803d06:	89 f2                	mov    %esi,%edx
  803d08:	83 c4 1c             	add    $0x1c,%esp
  803d0b:	5b                   	pop    %ebx
  803d0c:	5e                   	pop    %esi
  803d0d:	5f                   	pop    %edi
  803d0e:	5d                   	pop    %ebp
  803d0f:	c3                   	ret    
  803d10:	3b 04 24             	cmp    (%esp),%eax
  803d13:	72 06                	jb     803d1b <__umoddi3+0x113>
  803d15:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d19:	77 0f                	ja     803d2a <__umoddi3+0x122>
  803d1b:	89 f2                	mov    %esi,%edx
  803d1d:	29 f9                	sub    %edi,%ecx
  803d1f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d23:	89 14 24             	mov    %edx,(%esp)
  803d26:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d2a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d2e:	8b 14 24             	mov    (%esp),%edx
  803d31:	83 c4 1c             	add    $0x1c,%esp
  803d34:	5b                   	pop    %ebx
  803d35:	5e                   	pop    %esi
  803d36:	5f                   	pop    %edi
  803d37:	5d                   	pop    %ebp
  803d38:	c3                   	ret    
  803d39:	8d 76 00             	lea    0x0(%esi),%esi
  803d3c:	2b 04 24             	sub    (%esp),%eax
  803d3f:	19 fa                	sbb    %edi,%edx
  803d41:	89 d1                	mov    %edx,%ecx
  803d43:	89 c6                	mov    %eax,%esi
  803d45:	e9 71 ff ff ff       	jmp    803cbb <__umoddi3+0xb3>
  803d4a:	66 90                	xchg   %ax,%ax
  803d4c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d50:	72 ea                	jb     803d3c <__umoddi3+0x134>
  803d52:	89 d9                	mov    %ebx,%ecx
  803d54:	e9 62 ff ff ff       	jmp    803cbb <__umoddi3+0xb3>
