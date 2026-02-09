
obj/user/tst_air:     file format elf32-i386


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
  800031:	e8 91 0f 00 00       	call   800fc7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <user/air.h>
int find(int* arr, int size, int val);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 9c 03 00 00    	sub    $0x39c,%esp
	int envID = sys_getenvid();
  800044:	e8 e0 34 00 00       	call   803529 <sys_getenvid>
  800049:	89 45 a0             	mov    %eax,-0x60(%ebp)

	int numOfClerks = 3;
  80004c:	c7 45 9c 03 00 00 00 	movl   $0x3,-0x64(%ebp)
	int agentCapacity = 20;
  800053:	c7 45 e4 14 00 00 00 	movl   $0x14,-0x1c(%ebp)
	int numOfCustomers = 30;
  80005a:	c7 45 e0 1e 00 00 00 	movl   $0x1e,-0x20(%ebp)
	int flight1NumOfCustomers = numOfCustomers/3;
  800061:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800064:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800069:	f7 e9                	imul   %ecx
  80006b:	c1 f9 1f             	sar    $0x1f,%ecx
  80006e:	89 d0                	mov    %edx,%eax
  800070:	29 c8                	sub    %ecx,%eax
  800072:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int flight2NumOfCustomers = numOfCustomers/3;
  800075:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800078:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80007d:	f7 e9                	imul   %ecx
  80007f:	c1 f9 1f             	sar    $0x1f,%ecx
  800082:	89 d0                	mov    %edx,%eax
  800084:	29 c8                	sub    %ecx,%eax
  800086:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int flight3NumOfCustomers = numOfCustomers - (flight1NumOfCustomers + flight2NumOfCustomers);
  800089:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80008c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80008f:	01 c2                	add    %eax,%edx
  800091:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800094:	29 d0                	sub    %edx,%eax
  800096:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int flight1NumOfTickets = 15;
  800099:	c7 45 d0 0f 00 00 00 	movl   $0xf,-0x30(%ebp)
	int flight2NumOfTickets = 8;
  8000a0:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%ebp)
	// *************************************************************************************************
	/// Reading Inputs *********************************************************************************
	// *************************************************************************************************
	char Line[255] ;
	char Chose;
	sys_lock_cons();
  8000a7:	e8 1d 32 00 00       	call   8032c9 <sys_lock_cons>
	{
		cprintf("\n");
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 c0 48 80 00       	push   $0x8048c0
  8000b4:	e8 ac 13 00 00       	call   801465 <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8000bc:	83 ec 0c             	sub    $0xc,%esp
  8000bf:	68 c4 48 80 00       	push   $0x8048c4
  8000c4:	e8 9c 13 00 00       	call   801465 <cprintf>
  8000c9:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! AIR PLANE RESERVATION !!!!\n");
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	68 e8 48 80 00       	push   $0x8048e8
  8000d4:	e8 8c 13 00 00       	call   801465 <cprintf>
  8000d9:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	68 c4 48 80 00       	push   $0x8048c4
  8000e4:	e8 7c 13 00 00       	call   801465 <cprintf>
  8000e9:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  8000ec:	83 ec 0c             	sub    $0xc,%esp
  8000ef:	68 c0 48 80 00       	push   $0x8048c0
  8000f4:	e8 6c 13 00 00       	call   801465 <cprintf>
  8000f9:	83 c4 10             	add    $0x10,%esp
		cprintf("%~Default #customers = %d (equally divided over the 3 flights).\n"
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  800102:	ff 75 cc             	pushl  -0x34(%ebp)
  800105:	ff 75 d0             	pushl  -0x30(%ebp)
  800108:	ff 75 e0             	pushl  -0x20(%ebp)
  80010b:	68 0c 49 80 00       	push   $0x80490c
  800110:	e8 50 13 00 00       	call   801465 <cprintf>
  800115:	83 c4 20             	add    $0x20,%esp
				"Flight1 Tickets = %d, Flight2 Tickets = %d\n"
				"Agent Capacity = %d\n", numOfCustomers, flight1NumOfTickets, flight2NumOfTickets, agentCapacity) ;
		Chose = 0 ;
  800118:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
		while (Chose != 'y' && Chose != 'n' && Chose != 'Y' && Chose != 'N')
  80011c:	eb 42                	jmp    800160 <_main+0x128>
		{
			cprintf("%~Do you want to change these values(y/n)? ") ;
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 8c 49 80 00       	push   $0x80498c
  800126:	e8 3a 13 00 00       	call   801465 <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012e:	e8 77 0e 00 00       	call   800faa <getchar>
  800133:	88 45 cb             	mov    %al,-0x35(%ebp)
			cputchar(Chose);
  800136:	0f be 45 cb          	movsbl -0x35(%ebp),%eax
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	50                   	push   %eax
  80013e:	e8 48 0e 00 00       	call   800f8b <cputchar>
  800143:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800146:	83 ec 0c             	sub    $0xc,%esp
  800149:	6a 0a                	push   $0xa
  80014b:	e8 3b 0e 00 00       	call   800f8b <cputchar>
  800150:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	6a 0a                	push   $0xa
  800158:	e8 2e 0e 00 00       	call   800f8b <cputchar>
  80015d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
		cprintf("%~Default #customers = %d (equally divided over the 3 flights).\n"
				"Flight1 Tickets = %d, Flight2 Tickets = %d\n"
				"Agent Capacity = %d\n", numOfCustomers, flight1NumOfTickets, flight2NumOfTickets, agentCapacity) ;
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n' && Chose != 'Y' && Chose != 'N')
  800160:	80 7d cb 79          	cmpb   $0x79,-0x35(%ebp)
  800164:	74 12                	je     800178 <_main+0x140>
  800166:	80 7d cb 6e          	cmpb   $0x6e,-0x35(%ebp)
  80016a:	74 0c                	je     800178 <_main+0x140>
  80016c:	80 7d cb 59          	cmpb   $0x59,-0x35(%ebp)
  800170:	74 06                	je     800178 <_main+0x140>
  800172:	80 7d cb 4e          	cmpb   $0x4e,-0x35(%ebp)
  800176:	75 a6                	jne    80011e <_main+0xe6>
			Chose = getchar() ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
		if (Chose == 'y' || Chose == 'Y')
  800178:	80 7d cb 79          	cmpb   $0x79,-0x35(%ebp)
  80017c:	74 0a                	je     800188 <_main+0x150>
  80017e:	80 7d cb 59          	cmpb   $0x59,-0x35(%ebp)
  800182:	0f 85 ea 00 00 00    	jne    800272 <_main+0x23a>
		{
			readline("Enter the capacity of the agent: ", Line);
  800188:	83 ec 08             	sub    $0x8,%esp
  80018b:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  800191:	50                   	push   %eax
  800192:	68 b8 49 80 00       	push   $0x8049b8
  800197:	e8 a2 19 00 00       	call   801b3e <readline>
  80019c:	83 c4 10             	add    $0x10,%esp
			agentCapacity = strtol(Line, NULL, 10) ;
  80019f:	83 ec 04             	sub    $0x4,%esp
  8001a2:	6a 0a                	push   $0xa
  8001a4:	6a 00                	push   $0x0
  8001a6:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  8001ac:	50                   	push   %eax
  8001ad:	e8 a3 1f 00 00       	call   802155 <strtol>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			readline("Enter the total number of customers: ", Line);
  8001b8:	83 ec 08             	sub    $0x8,%esp
  8001bb:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  8001c1:	50                   	push   %eax
  8001c2:	68 dc 49 80 00       	push   $0x8049dc
  8001c7:	e8 72 19 00 00       	call   801b3e <readline>
  8001cc:	83 c4 10             	add    $0x10,%esp
			numOfCustomers = strtol(Line, NULL, 10) ;
  8001cf:	83 ec 04             	sub    $0x4,%esp
  8001d2:	6a 0a                	push   $0xa
  8001d4:	6a 00                	push   $0x0
  8001d6:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  8001dc:	50                   	push   %eax
  8001dd:	e8 73 1f 00 00       	call   802155 <strtol>
  8001e2:	83 c4 10             	add    $0x10,%esp
  8001e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			flight1NumOfCustomers = flight2NumOfCustomers = numOfCustomers / 3;
  8001e8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8001eb:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8001f0:	f7 e9                	imul   %ecx
  8001f2:	c1 f9 1f             	sar    $0x1f,%ecx
  8001f5:	89 d0                	mov    %edx,%eax
  8001f7:	29 c8                	sub    %ecx,%eax
  8001f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
			flight3NumOfCustomers = numOfCustomers - (flight1NumOfCustomers + flight2NumOfCustomers);
  800202:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800205:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800208:	01 c2                	add    %eax,%edx
  80020a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80020d:	29 d0                	sub    %edx,%eax
  80020f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			readline("Enter # tickets of flight#1: ", Line);
  800212:	83 ec 08             	sub    $0x8,%esp
  800215:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  80021b:	50                   	push   %eax
  80021c:	68 02 4a 80 00       	push   $0x804a02
  800221:	e8 18 19 00 00       	call   801b3e <readline>
  800226:	83 c4 10             	add    $0x10,%esp
			flight1NumOfTickets = strtol(Line, NULL, 10) ;
  800229:	83 ec 04             	sub    $0x4,%esp
  80022c:	6a 0a                	push   $0xa
  80022e:	6a 00                	push   $0x0
  800230:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  800236:	50                   	push   %eax
  800237:	e8 19 1f 00 00       	call   802155 <strtol>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 d0             	mov    %eax,-0x30(%ebp)
			readline("Enter # tickets of flight#2: ", Line);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	68 20 4a 80 00       	push   $0x804a20
  800251:	e8 e8 18 00 00       	call   801b3e <readline>
  800256:	83 c4 10             	add    $0x10,%esp
			flight2NumOfTickets = strtol(Line, NULL, 10) ;
  800259:	83 ec 04             	sub    $0x4,%esp
  80025c:	6a 0a                	push   $0xa
  80025e:	6a 00                	push   $0x0
  800260:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  800266:	50                   	push   %eax
  800267:	e8 e9 1e 00 00       	call   802155 <strtol>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 cc             	mov    %eax,-0x34(%ebp)
		}
	}
	sys_unlock_cons();
  800272:	e8 6c 30 00 00       	call   8032e3 <sys_unlock_cons>

	// *************************************************************************************************
	/// Shared Variables Region ************************************************************************
	// *************************************************************************************************
	char _isOpened[] = "isOpened";
  800277:	8d 85 50 fe ff ff    	lea    -0x1b0(%ebp),%eax
  80027d:	bb 36 4e 80 00       	mov    $0x804e36,%ebx
  800282:	ba 09 00 00 00       	mov    $0x9,%edx
  800287:	89 c7                	mov    %eax,%edi
  800289:	89 de                	mov    %ebx,%esi
  80028b:	89 d1                	mov    %edx,%ecx
  80028d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _agentCapacity[] = "agentCapacity";
  80028f:	8d 85 42 fe ff ff    	lea    -0x1be(%ebp),%eax
  800295:	bb 3f 4e 80 00       	mov    $0x804e3f,%ebx
  80029a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80029f:	89 c7                	mov    %eax,%edi
  8002a1:	89 de                	mov    %ebx,%esi
  8002a3:	89 d1                	mov    %edx,%ecx
  8002a5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _customers[] = "customers";
  8002a7:	8d 85 38 fe ff ff    	lea    -0x1c8(%ebp),%eax
  8002ad:	bb 4d 4e 80 00       	mov    $0x804e4d,%ebx
  8002b2:	ba 0a 00 00 00       	mov    $0xa,%edx
  8002b7:	89 c7                	mov    %eax,%edi
  8002b9:	89 de                	mov    %ebx,%esi
  8002bb:	89 d1                	mov    %edx,%ecx
  8002bd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  8002bf:	8d 85 2c fe ff ff    	lea    -0x1d4(%ebp),%eax
  8002c5:	bb 57 4e 80 00       	mov    $0x804e57,%ebx
  8002ca:	ba 03 00 00 00       	mov    $0x3,%edx
  8002cf:	89 c7                	mov    %eax,%edi
  8002d1:	89 de                	mov    %ebx,%esi
  8002d3:	89 d1                	mov    %edx,%ecx
  8002d5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Customers[] = "flight1Customers";
  8002d7:	8d 85 1b fe ff ff    	lea    -0x1e5(%ebp),%eax
  8002dd:	bb 63 4e 80 00       	mov    $0x804e63,%ebx
  8002e2:	ba 11 00 00 00       	mov    $0x11,%edx
  8002e7:	89 c7                	mov    %eax,%edi
  8002e9:	89 de                	mov    %ebx,%esi
  8002eb:	89 d1                	mov    %edx,%ecx
  8002ed:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Customers[] = "flight2Customers";
  8002ef:	8d 85 0a fe ff ff    	lea    -0x1f6(%ebp),%eax
  8002f5:	bb 74 4e 80 00       	mov    $0x804e74,%ebx
  8002fa:	ba 11 00 00 00       	mov    $0x11,%edx
  8002ff:	89 c7                	mov    %eax,%edi
  800301:	89 de                	mov    %ebx,%esi
  800303:	89 d1                	mov    %edx,%ecx
  800305:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight3Customers[] = "flight3Customers";
  800307:	8d 85 f9 fd ff ff    	lea    -0x207(%ebp),%eax
  80030d:	bb 85 4e 80 00       	mov    $0x804e85,%ebx
  800312:	ba 11 00 00 00       	mov    $0x11,%edx
  800317:	89 c7                	mov    %eax,%edi
  800319:	89 de                	mov    %ebx,%esi
  80031b:	89 d1                	mov    %edx,%ecx
  80031d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  80031f:	8d 85 ea fd ff ff    	lea    -0x216(%ebp),%eax
  800325:	bb 96 4e 80 00       	mov    $0x804e96,%ebx
  80032a:	ba 0f 00 00 00       	mov    $0xf,%edx
  80032f:	89 c7                	mov    %eax,%edi
  800331:	89 de                	mov    %ebx,%esi
  800333:	89 d1                	mov    %edx,%ecx
  800335:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  800337:	8d 85 db fd ff ff    	lea    -0x225(%ebp),%eax
  80033d:	bb a5 4e 80 00       	mov    $0x804ea5,%ebx
  800342:	ba 0f 00 00 00       	mov    $0xf,%edx
  800347:	89 c7                	mov    %eax,%edi
  800349:	89 de                	mov    %ebx,%esi
  80034b:	89 d1                	mov    %edx,%ecx
  80034d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  80034f:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
  800355:	bb b4 4e 80 00       	mov    $0x804eb4,%ebx
  80035a:	ba 15 00 00 00       	mov    $0x15,%edx
  80035f:	89 c7                	mov    %eax,%edi
  800361:	89 de                	mov    %ebx,%esi
  800363:	89 d1                	mov    %edx,%ecx
  800365:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  800367:	8d 85 b1 fd ff ff    	lea    -0x24f(%ebp),%eax
  80036d:	bb c9 4e 80 00       	mov    $0x804ec9,%ebx
  800372:	ba 15 00 00 00       	mov    $0x15,%edx
  800377:	89 c7                	mov    %eax,%edi
  800379:	89 de                	mov    %ebx,%esi
  80037b:	89 d1                	mov    %edx,%ecx
  80037d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  80037f:	8d 85 a0 fd ff ff    	lea    -0x260(%ebp),%eax
  800385:	bb de 4e 80 00       	mov    $0x804ede,%ebx
  80038a:	ba 11 00 00 00       	mov    $0x11,%edx
  80038f:	89 c7                	mov    %eax,%edi
  800391:	89 de                	mov    %ebx,%esi
  800393:	89 d1                	mov    %edx,%ecx
  800395:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  800397:	8d 85 8f fd ff ff    	lea    -0x271(%ebp),%eax
  80039d:	bb ef 4e 80 00       	mov    $0x804eef,%ebx
  8003a2:	ba 11 00 00 00       	mov    $0x11,%edx
  8003a7:	89 c7                	mov    %eax,%edi
  8003a9:	89 de                	mov    %ebx,%esi
  8003ab:	89 d1                	mov    %edx,%ecx
  8003ad:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8003af:	8d 85 7e fd ff ff    	lea    -0x282(%ebp),%eax
  8003b5:	bb 00 4f 80 00       	mov    $0x804f00,%ebx
  8003ba:	ba 11 00 00 00       	mov    $0x11,%edx
  8003bf:	89 c7                	mov    %eax,%edi
  8003c1:	89 de                	mov    %ebx,%esi
  8003c3:	89 d1                	mov    %edx,%ecx
  8003c5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  8003c7:	8d 85 75 fd ff ff    	lea    -0x28b(%ebp),%eax
  8003cd:	bb 11 4f 80 00       	mov    $0x804f11,%ebx
  8003d2:	ba 09 00 00 00       	mov    $0x9,%edx
  8003d7:	89 c7                	mov    %eax,%edi
  8003d9:	89 de                	mov    %ebx,%esi
  8003db:	89 d1                	mov    %edx,%ecx
  8003dd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  8003df:	8d 85 6b fd ff ff    	lea    -0x295(%ebp),%eax
  8003e5:	bb 1a 4f 80 00       	mov    $0x804f1a,%ebx
  8003ea:	ba 0a 00 00 00       	mov    $0xa,%edx
  8003ef:	89 c7                	mov    %eax,%edi
  8003f1:	89 de                	mov    %ebx,%esi
  8003f3:	89 d1                	mov    %edx,%ecx
  8003f5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  8003f7:	8d 85 60 fd ff ff    	lea    -0x2a0(%ebp),%eax
  8003fd:	bb 24 4f 80 00       	mov    $0x804f24,%ebx
  800402:	ba 0b 00 00 00       	mov    $0xb,%edx
  800407:	89 c7                	mov    %eax,%edi
  800409:	89 de                	mov    %ebx,%esi
  80040b:	89 d1                	mov    %edx,%ecx
  80040d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80040f:	8d 85 54 fd ff ff    	lea    -0x2ac(%ebp),%eax
  800415:	bb 2f 4f 80 00       	mov    $0x804f2f,%ebx
  80041a:	ba 03 00 00 00       	mov    $0x3,%edx
  80041f:	89 c7                	mov    %eax,%edi
  800421:	89 de                	mov    %ebx,%esi
  800423:	89 d1                	mov    %edx,%ecx
  800425:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800427:	8d 85 4a fd ff ff    	lea    -0x2b6(%ebp),%eax
  80042d:	bb 3b 4f 80 00       	mov    $0x804f3b,%ebx
  800432:	ba 0a 00 00 00       	mov    $0xa,%edx
  800437:	89 c7                	mov    %eax,%edi
  800439:	89 de                	mov    %ebx,%esi
  80043b:	89 d1                	mov    %edx,%ecx
  80043d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80043f:	8d 85 40 fd ff ff    	lea    -0x2c0(%ebp),%eax
  800445:	bb 45 4f 80 00       	mov    $0x804f45,%ebx
  80044a:	ba 0a 00 00 00       	mov    $0xa,%edx
  80044f:	89 c7                	mov    %eax,%edi
  800451:	89 de                	mov    %ebx,%esi
  800453:	89 d1                	mov    %edx,%ecx
  800455:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  800457:	c7 85 3a fd ff ff 63 	movl   $0x72656c63,-0x2c6(%ebp)
  80045e:	6c 65 72 
  800461:	66 c7 85 3e fd ff ff 	movw   $0x6b,-0x2c2(%ebp)
  800468:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  80046a:	8d 85 2c fd ff ff    	lea    -0x2d4(%ebp),%eax
  800470:	bb 4f 4f 80 00       	mov    $0x804f4f,%ebx
  800475:	ba 0e 00 00 00       	mov    $0xe,%edx
  80047a:	89 c7                	mov    %eax,%edi
  80047c:	89 de                	mov    %ebx,%esi
  80047e:	89 d1                	mov    %edx,%ecx
  800480:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800482:	8d 85 1d fd ff ff    	lea    -0x2e3(%ebp),%eax
  800488:	bb 5d 4f 80 00       	mov    $0x804f5d,%ebx
  80048d:	ba 0f 00 00 00       	mov    $0xf,%edx
  800492:	89 c7                	mov    %eax,%edi
  800494:	89 de                	mov    %ebx,%esi
  800496:	89 d1                	mov    %edx,%ecx
  800498:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _clerkTerminated[] = "clerkTerminated";
  80049a:	8d 85 0d fd ff ff    	lea    -0x2f3(%ebp),%eax
  8004a0:	bb 6c 4f 80 00       	mov    $0x804f6c,%ebx
  8004a5:	ba 04 00 00 00       	mov    $0x4,%edx
  8004aa:	89 c7                	mov    %eax,%edi
  8004ac:	89 de                	mov    %ebx,%esi
  8004ae:	89 d1                	mov    %edx,%ecx
  8004b0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8004b2:	8d 85 06 fd ff ff    	lea    -0x2fa(%ebp),%eax
  8004b8:	bb 7c 4f 80 00       	mov    $0x804f7c,%ebx
  8004bd:	ba 07 00 00 00       	mov    $0x7,%edx
  8004c2:	89 c7                	mov    %eax,%edi
  8004c4:	89 de                	mov    %ebx,%esi
  8004c6:	89 d1                	mov    %edx,%ecx
  8004c8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  8004ca:	8d 85 ff fc ff ff    	lea    -0x301(%ebp),%eax
  8004d0:	bb 83 4f 80 00       	mov    $0x804f83,%ebx
  8004d5:	ba 07 00 00 00       	mov    $0x7,%edx
  8004da:	89 c7                	mov    %eax,%edi
  8004dc:	89 de                	mov    %ebx,%esi
  8004de:	89 d1                	mov    %edx,%ecx
  8004e0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * custs;
	custs = smalloc(_customers, sizeof(struct Customer)*(numOfCustomers+1), 1);
  8004e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e5:	40                   	inc    %eax
  8004e6:	c1 e0 03             	shl    $0x3,%eax
  8004e9:	83 ec 04             	sub    $0x4,%esp
  8004ec:	6a 01                	push   $0x1
  8004ee:	50                   	push   %eax
  8004ef:	8d 85 38 fe ff ff    	lea    -0x1c8(%ebp),%eax
  8004f5:	50                   	push   %eax
  8004f6:	e8 5d 2a 00 00       	call   802f58 <smalloc>
  8004fb:	83 c4 10             	add    $0x10,%esp
  8004fe:	89 45 98             	mov    %eax,-0x68(%ebp)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);

	int* flight1Customers = smalloc(_flight1Customers, sizeof(int), 1); *flight1Customers = flight1NumOfCustomers;
  800501:	83 ec 04             	sub    $0x4,%esp
  800504:	6a 01                	push   $0x1
  800506:	6a 04                	push   $0x4
  800508:	8d 85 1b fe ff ff    	lea    -0x1e5(%ebp),%eax
  80050e:	50                   	push   %eax
  80050f:	e8 44 2a 00 00       	call   802f58 <smalloc>
  800514:	83 c4 10             	add    $0x10,%esp
  800517:	89 45 94             	mov    %eax,-0x6c(%ebp)
  80051a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80051d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800520:	89 10                	mov    %edx,(%eax)
	int* flight2Customers = smalloc(_flight2Customers, sizeof(int), 1); *flight2Customers = flight2NumOfCustomers;
  800522:	83 ec 04             	sub    $0x4,%esp
  800525:	6a 01                	push   $0x1
  800527:	6a 04                	push   $0x4
  800529:	8d 85 0a fe ff ff    	lea    -0x1f6(%ebp),%eax
  80052f:	50                   	push   %eax
  800530:	e8 23 2a 00 00       	call   802f58 <smalloc>
  800535:	83 c4 10             	add    $0x10,%esp
  800538:	89 45 90             	mov    %eax,-0x70(%ebp)
  80053b:	8b 45 90             	mov    -0x70(%ebp),%eax
  80053e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800541:	89 10                	mov    %edx,(%eax)
	int* flight3Customers = smalloc(_flight3Customers, sizeof(int), 1); *flight3Customers = flight3NumOfCustomers;
  800543:	83 ec 04             	sub    $0x4,%esp
  800546:	6a 01                	push   $0x1
  800548:	6a 04                	push   $0x4
  80054a:	8d 85 f9 fd ff ff    	lea    -0x207(%ebp),%eax
  800550:	50                   	push   %eax
  800551:	e8 02 2a 00 00       	call   802f58 <smalloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 8c             	mov    %eax,-0x74(%ebp)
  80055c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80055f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800562:	89 10                	mov    %edx,(%eax)

	int* isOpened = smalloc(_isOpened, sizeof(int), 0);
  800564:	83 ec 04             	sub    $0x4,%esp
  800567:	6a 00                	push   $0x0
  800569:	6a 04                	push   $0x4
  80056b:	8d 85 50 fe ff ff    	lea    -0x1b0(%ebp),%eax
  800571:	50                   	push   %eax
  800572:	e8 e1 29 00 00       	call   802f58 <smalloc>
  800577:	83 c4 10             	add    $0x10,%esp
  80057a:	89 45 88             	mov    %eax,-0x78(%ebp)
	*isOpened = 1;
  80057d:	8b 45 88             	mov    -0x78(%ebp),%eax
  800580:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	int* custCounter = smalloc(_custCounter, sizeof(int), 1);
  800586:	83 ec 04             	sub    $0x4,%esp
  800589:	6a 01                	push   $0x1
  80058b:	6a 04                	push   $0x4
  80058d:	8d 85 2c fe ff ff    	lea    -0x1d4(%ebp),%eax
  800593:	50                   	push   %eax
  800594:	e8 bf 29 00 00       	call   802f58 <smalloc>
  800599:	83 c4 10             	add    $0x10,%esp
  80059c:	89 45 84             	mov    %eax,-0x7c(%ebp)
	*custCounter = 0;
  80059f:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8005a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1Counter = smalloc(_flight1Counter, sizeof(int), 1);
  8005a8:	83 ec 04             	sub    $0x4,%esp
  8005ab:	6a 01                	push   $0x1
  8005ad:	6a 04                	push   $0x4
  8005af:	8d 85 ea fd ff ff    	lea    -0x216(%ebp),%eax
  8005b5:	50                   	push   %eax
  8005b6:	e8 9d 29 00 00       	call   802f58 <smalloc>
  8005bb:	83 c4 10             	add    $0x10,%esp
  8005be:	89 45 80             	mov    %eax,-0x80(%ebp)
	*flight1Counter = flight1NumOfTickets;
  8005c1:	8b 45 80             	mov    -0x80(%ebp),%eax
  8005c4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005c7:	89 10                	mov    %edx,(%eax)

	int* flight2Counter = smalloc(_flight2Counter, sizeof(int), 1);
  8005c9:	83 ec 04             	sub    $0x4,%esp
  8005cc:	6a 01                	push   $0x1
  8005ce:	6a 04                	push   $0x4
  8005d0:	8d 85 db fd ff ff    	lea    -0x225(%ebp),%eax
  8005d6:	50                   	push   %eax
  8005d7:	e8 7c 29 00 00       	call   802f58 <smalloc>
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
	*flight2Counter = flight2NumOfTickets;
  8005e5:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005eb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8005ee:	89 10                	mov    %edx,(%eax)

	int* flight1BookedCounter = smalloc(_flightBooked1Counter, sizeof(int), 1);
  8005f0:	83 ec 04             	sub    $0x4,%esp
  8005f3:	6a 01                	push   $0x1
  8005f5:	6a 04                	push   $0x4
  8005f7:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
  8005fd:	50                   	push   %eax
  8005fe:	e8 55 29 00 00       	call   802f58 <smalloc>
  800603:	83 c4 10             	add    $0x10,%esp
  800606:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
	*flight1BookedCounter = 0;
  80060c:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800612:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight2BookedCounter = smalloc(_flightBooked2Counter, sizeof(int), 1);
  800618:	83 ec 04             	sub    $0x4,%esp
  80061b:	6a 01                	push   $0x1
  80061d:	6a 04                	push   $0x4
  80061f:	8d 85 b1 fd ff ff    	lea    -0x24f(%ebp),%eax
  800625:	50                   	push   %eax
  800626:	e8 2d 29 00 00       	call   802f58 <smalloc>
  80062b:	83 c4 10             	add    $0x10,%esp
  80062e:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	*flight2BookedCounter = 0;
  800634:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80063a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1BookedArr = smalloc(_flightBooked1Arr, sizeof(int)*flight1NumOfTickets, 1);
  800640:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800643:	c1 e0 02             	shl    $0x2,%eax
  800646:	83 ec 04             	sub    $0x4,%esp
  800649:	6a 01                	push   $0x1
  80064b:	50                   	push   %eax
  80064c:	8d 85 a0 fd ff ff    	lea    -0x260(%ebp),%eax
  800652:	50                   	push   %eax
  800653:	e8 00 29 00 00       	call   802f58 <smalloc>
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	int* flight2BookedArr = smalloc(_flightBooked2Arr, sizeof(int)*flight2NumOfTickets, 1);
  800661:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800664:	c1 e0 02             	shl    $0x2,%eax
  800667:	83 ec 04             	sub    $0x4,%esp
  80066a:	6a 01                	push   $0x1
  80066c:	50                   	push   %eax
  80066d:	8d 85 8f fd ff ff    	lea    -0x271(%ebp),%eax
  800673:	50                   	push   %eax
  800674:	e8 df 28 00 00       	call   802f58 <smalloc>
  800679:	83 c4 10             	add    $0x10,%esp
  80067c:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)

	int* cust_ready_queue = smalloc(_cust_ready_queue, sizeof(int)*(numOfCustomers+1), 1);
  800682:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800685:	40                   	inc    %eax
  800686:	c1 e0 02             	shl    $0x2,%eax
  800689:	83 ec 04             	sub    $0x4,%esp
  80068c:	6a 01                	push   $0x1
  80068e:	50                   	push   %eax
  80068f:	8d 85 7e fd ff ff    	lea    -0x282(%ebp),%eax
  800695:	50                   	push   %eax
  800696:	e8 bd 28 00 00       	call   802f58 <smalloc>
  80069b:	83 c4 10             	add    $0x10,%esp
  80069e:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

	int* queue_in = smalloc(_queue_in, sizeof(int), 1);
  8006a4:	83 ec 04             	sub    $0x4,%esp
  8006a7:	6a 01                	push   $0x1
  8006a9:	6a 04                	push   $0x4
  8006ab:	8d 85 75 fd ff ff    	lea    -0x28b(%ebp),%eax
  8006b1:	50                   	push   %eax
  8006b2:	e8 a1 28 00 00       	call   802f58 <smalloc>
  8006b7:	83 c4 10             	add    $0x10,%esp
  8006ba:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
	*queue_in = 0;
  8006c0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8006c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* queue_out = smalloc(_queue_out, sizeof(int), 1);
  8006cc:	83 ec 04             	sub    $0x4,%esp
  8006cf:	6a 01                	push   $0x1
  8006d1:	6a 04                	push   $0x4
  8006d3:	8d 85 6b fd ff ff    	lea    -0x295(%ebp),%eax
  8006d9:	50                   	push   %eax
  8006da:	e8 79 28 00 00       	call   802f58 <smalloc>
  8006df:	83 c4 10             	add    $0x10,%esp
  8006e2:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
	*queue_out = 0;
  8006e8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8006ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	// *************************************************************************************************
	/// Semaphores Region ******************************************************************************
	// *************************************************************************************************
	struct semaphore capacity = create_semaphore(_agentCapacity, agentCapacity);
  8006f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006f7:	8d 85 f8 fc ff ff    	lea    -0x308(%ebp),%eax
  8006fd:	83 ec 04             	sub    $0x4,%esp
  800700:	52                   	push   %edx
  800701:	8d 95 42 fe ff ff    	lea    -0x1be(%ebp),%edx
  800707:	52                   	push   %edx
  800708:	50                   	push   %eax
  800709:	e8 18 3e 00 00       	call   804526 <create_semaphore>
  80070e:	83 c4 0c             	add    $0xc,%esp

	struct semaphore flight1CS = create_semaphore(_flight1CS, 1);
  800711:	8d 85 f4 fc ff ff    	lea    -0x30c(%ebp),%eax
  800717:	83 ec 04             	sub    $0x4,%esp
  80071a:	6a 01                	push   $0x1
  80071c:	8d 95 4a fd ff ff    	lea    -0x2b6(%ebp),%edx
  800722:	52                   	push   %edx
  800723:	50                   	push   %eax
  800724:	e8 fd 3d 00 00       	call   804526 <create_semaphore>
  800729:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = create_semaphore(_flight2CS, 1);
  80072c:	8d 85 f0 fc ff ff    	lea    -0x310(%ebp),%eax
  800732:	83 ec 04             	sub    $0x4,%esp
  800735:	6a 01                	push   $0x1
  800737:	8d 95 40 fd ff ff    	lea    -0x2c0(%ebp),%edx
  80073d:	52                   	push   %edx
  80073e:	50                   	push   %eax
  80073f:	e8 e2 3d 00 00       	call   804526 <create_semaphore>
  800744:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custCounterCS = create_semaphore(_custCounterCS, 1);
  800747:	8d 85 ec fc ff ff    	lea    -0x314(%ebp),%eax
  80074d:	83 ec 04             	sub    $0x4,%esp
  800750:	6a 01                	push   $0x1
  800752:	8d 95 2c fd ff ff    	lea    -0x2d4(%ebp),%edx
  800758:	52                   	push   %edx
  800759:	50                   	push   %eax
  80075a:	e8 c7 3d 00 00       	call   804526 <create_semaphore>
  80075f:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = create_semaphore(_custQueueCS, 1);
  800762:	8d 85 e8 fc ff ff    	lea    -0x318(%ebp),%eax
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	6a 01                	push   $0x1
  80076d:	8d 95 54 fd ff ff    	lea    -0x2ac(%ebp),%edx
  800773:	52                   	push   %edx
  800774:	50                   	push   %eax
  800775:	e8 ac 3d 00 00       	call   804526 <create_semaphore>
  80077a:	83 c4 0c             	add    $0xc,%esp

	struct semaphore clerk = create_semaphore(_clerk, 3);
  80077d:	8d 85 e4 fc ff ff    	lea    -0x31c(%ebp),%eax
  800783:	83 ec 04             	sub    $0x4,%esp
  800786:	6a 03                	push   $0x3
  800788:	8d 95 3a fd ff ff    	lea    -0x2c6(%ebp),%edx
  80078e:	52                   	push   %edx
  80078f:	50                   	push   %eax
  800790:	e8 91 3d 00 00       	call   804526 <create_semaphore>
  800795:	83 c4 0c             	add    $0xc,%esp

	struct semaphore cust_ready = create_semaphore(_cust_ready, 0);
  800798:	8d 85 e0 fc ff ff    	lea    -0x320(%ebp),%eax
  80079e:	83 ec 04             	sub    $0x4,%esp
  8007a1:	6a 00                	push   $0x0
  8007a3:	8d 95 60 fd ff ff    	lea    -0x2a0(%ebp),%edx
  8007a9:	52                   	push   %edx
  8007aa:	50                   	push   %eax
  8007ab:	e8 76 3d 00 00       	call   804526 <create_semaphore>
  8007b0:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custTerminated = create_semaphore(_custTerminated, 0);
  8007b3:	8d 85 dc fc ff ff    	lea    -0x324(%ebp),%eax
  8007b9:	83 ec 04             	sub    $0x4,%esp
  8007bc:	6a 00                	push   $0x0
  8007be:	8d 95 1d fd ff ff    	lea    -0x2e3(%ebp),%edx
  8007c4:	52                   	push   %edx
  8007c5:	50                   	push   %eax
  8007c6:	e8 5b 3d 00 00       	call   804526 <create_semaphore>
  8007cb:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerkTerminated = create_semaphore(_clerkTerminated, 0);
  8007ce:	8d 85 d8 fc ff ff    	lea    -0x328(%ebp),%eax
  8007d4:	83 ec 04             	sub    $0x4,%esp
  8007d7:	6a 00                	push   $0x0
  8007d9:	8d 95 0d fd ff ff    	lea    -0x2f3(%ebp),%edx
  8007df:	52                   	push   %edx
  8007e0:	50                   	push   %eax
  8007e1:	e8 40 3d 00 00       	call   804526 <create_semaphore>
  8007e6:	83 c4 0c             	add    $0xc,%esp

	struct semaphore* cust_finished = smalloc("cust_finished_array", numOfCustomers*sizeof(struct semaphore), 1);
  8007e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ec:	c1 e0 02             	shl    $0x2,%eax
  8007ef:	83 ec 04             	sub    $0x4,%esp
  8007f2:	6a 01                	push   $0x1
  8007f4:	50                   	push   %eax
  8007f5:	68 3e 4a 80 00       	push   $0x804a3e
  8007fa:	e8 59 27 00 00       	call   802f58 <smalloc>
  8007ff:	83 c4 10             	add    $0x10,%esp
  800802:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)

	int s=0;
  800808:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
	for(s=0; s<numOfCustomers; ++s)
  80080f:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
  800816:	e9 9a 00 00 00       	jmp    8008b5 <_main+0x87d>
	{
		char prefix[30]="cust_finished";
  80081b:	8d 85 ae fc ff ff    	lea    -0x352(%ebp),%eax
  800821:	bb 8a 4f 80 00       	mov    $0x804f8a,%ebx
  800826:	ba 0e 00 00 00       	mov    $0xe,%edx
  80082b:	89 c7                	mov    %eax,%edi
  80082d:	89 de                	mov    %ebx,%esi
  80082f:	89 d1                	mov    %edx,%ecx
  800831:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800833:	8d 95 bc fc ff ff    	lea    -0x344(%ebp),%edx
  800839:	b9 04 00 00 00       	mov    $0x4,%ecx
  80083e:	b8 00 00 00 00       	mov    $0x0,%eax
  800843:	89 d7                	mov    %edx,%edi
  800845:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(s, id);
  800847:	83 ec 08             	sub    $0x8,%esp
  80084a:	8d 85 a9 fc ff ff    	lea    -0x357(%ebp),%eax
  800850:	50                   	push   %eax
  800851:	ff 75 c4             	pushl  -0x3c(%ebp)
  800854:	e8 42 1a 00 00       	call   80229b <ltostr>
  800859:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  80085c:	83 ec 04             	sub    $0x4,%esp
  80085f:	8d 85 77 fc ff ff    	lea    -0x389(%ebp),%eax
  800865:	50                   	push   %eax
  800866:	8d 85 a9 fc ff ff    	lea    -0x357(%ebp),%eax
  80086c:	50                   	push   %eax
  80086d:	8d 85 ae fc ff ff    	lea    -0x352(%ebp),%eax
  800873:	50                   	push   %eax
  800874:	e8 fb 1a 00 00       	call   802374 <strcconcat>
  800879:	83 c4 10             	add    $0x10,%esp
		//sys_createSemaphore(sname, 0);
		cust_finished[s] = create_semaphore(sname, 0);
  80087c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80087f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800886:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  80088c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  80088f:	8d 85 64 fc ff ff    	lea    -0x39c(%ebp),%eax
  800895:	83 ec 04             	sub    $0x4,%esp
  800898:	6a 00                	push   $0x0
  80089a:	8d 95 77 fc ff ff    	lea    -0x389(%ebp),%edx
  8008a0:	52                   	push   %edx
  8008a1:	50                   	push   %eax
  8008a2:	e8 7f 3c 00 00       	call   804526 <create_semaphore>
  8008a7:	83 c4 0c             	add    $0xc,%esp
  8008aa:	8b 85 64 fc ff ff    	mov    -0x39c(%ebp),%eax
  8008b0:	89 03                	mov    %eax,(%ebx)
	struct semaphore clerkTerminated = create_semaphore(_clerkTerminated, 0);

	struct semaphore* cust_finished = smalloc("cust_finished_array", numOfCustomers*sizeof(struct semaphore), 1);

	int s=0;
	for(s=0; s<numOfCustomers; ++s)
  8008b2:	ff 45 c4             	incl   -0x3c(%ebp)
  8008b5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8008b8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8008bb:	0f 8c 5a ff ff ff    	jl     80081b <_main+0x7e3>
	// start all clerks and customers ******************************************************************
	// *************************************************************************************************

	//clerks
	uint32 envId;
	for (int k = 0; k < numOfClerks; ++k)
  8008c1:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  8008c8:	eb 50                	jmp    80091a <_main+0x8e2>
	{
		envId = sys_create_env(_taircl, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8008ca:	a1 20 60 80 00       	mov    0x806020,%eax
  8008cf:	8b 90 70 06 00 00    	mov    0x670(%eax),%edx
  8008d5:	a1 20 60 80 00       	mov    0x806020,%eax
  8008da:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  8008e0:	89 c1                	mov    %eax,%ecx
  8008e2:	a1 20 60 80 00       	mov    0x806020,%eax
  8008e7:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8008ed:	52                   	push   %edx
  8008ee:	51                   	push   %ecx
  8008ef:	50                   	push   %eax
  8008f0:	8d 85 06 fd ff ff    	lea    -0x2fa(%ebp),%eax
  8008f6:	50                   	push   %eax
  8008f7:	e8 d8 2b 00 00       	call   8034d4 <sys_create_env>
  8008fc:	83 c4 10             	add    $0x10,%esp
  8008ff:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		sys_run_env(envId);
  800905:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80090b:	83 ec 0c             	sub    $0xc,%esp
  80090e:	50                   	push   %eax
  80090f:	e8 de 2b 00 00       	call   8034f2 <sys_run_env>
  800914:	83 c4 10             	add    $0x10,%esp
	// start all clerks and customers ******************************************************************
	// *************************************************************************************************

	//clerks
	uint32 envId;
	for (int k = 0; k < numOfClerks; ++k)
  800917:	ff 45 c0             	incl   -0x40(%ebp)
  80091a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80091d:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  800920:	7c a8                	jl     8008ca <_main+0x892>
		sys_run_env(envId);
	}

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800922:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
  800929:	eb 70                	jmp    80099b <_main+0x963>
	{
		envId = sys_create_env(_taircu, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80092b:	a1 20 60 80 00       	mov    0x806020,%eax
  800930:	8b 90 70 06 00 00    	mov    0x670(%eax),%edx
  800936:	a1 20 60 80 00       	mov    0x806020,%eax
  80093b:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  800941:	89 c1                	mov    %eax,%ecx
  800943:	a1 20 60 80 00       	mov    0x806020,%eax
  800948:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80094e:	52                   	push   %edx
  80094f:	51                   	push   %ecx
  800950:	50                   	push   %eax
  800951:	8d 85 ff fc ff ff    	lea    -0x301(%ebp),%eax
  800957:	50                   	push   %eax
  800958:	e8 77 2b 00 00       	call   8034d4 <sys_create_env>
  80095d:	83 c4 10             	add    $0x10,%esp
  800960:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  800966:	83 bd 58 ff ff ff ef 	cmpl   $0xffffffef,-0xa8(%ebp)
  80096d:	75 17                	jne    800986 <_main+0x94e>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  80096f:	83 ec 04             	sub    $0x4,%esp
  800972:	68 54 4a 80 00       	push   $0x804a54
  800977:	68 b5 00 00 00       	push   $0xb5
  80097c:	68 9a 4a 80 00       	push   $0x804a9a
  800981:	e8 f1 07 00 00       	call   801177 <_panic>

		sys_run_env(envId);
  800986:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80098c:	83 ec 0c             	sub    $0xc,%esp
  80098f:	50                   	push   %eax
  800990:	e8 5d 2b 00 00       	call   8034f2 <sys_run_env>
  800995:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envId);
	}

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800998:	ff 45 bc             	incl   -0x44(%ebp)
  80099b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80099e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8009a1:	7c 88                	jl     80092b <_main+0x8f3>

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  8009a3:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
  8009aa:	eb 14                	jmp    8009c0 <_main+0x988>
	{
		wait_semaphore(custTerminated);
  8009ac:	83 ec 0c             	sub    $0xc,%esp
  8009af:	ff b5 dc fc ff ff    	pushl  -0x324(%ebp)
  8009b5:	e8 a0 3b 00 00       	call   80455a <wait_semaphore>
  8009ba:	83 c4 10             	add    $0x10,%esp

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  8009bd:	ff 45 bc             	incl   -0x44(%ebp)
  8009c0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8009c3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8009c6:	7c e4                	jl     8009ac <_main+0x974>
	{
		wait_semaphore(custTerminated);
	}

	env_sleep(1500);
  8009c8:	83 ec 0c             	sub    $0xc,%esp
  8009cb:	68 dc 05 00 00       	push   $0x5dc
  8009d0:	e8 c4 3b 00 00       	call   804599 <env_sleep>
  8009d5:	83 c4 10             	add    $0x10,%esp
	int b;

	sys_lock_cons();
  8009d8:	e8 ec 28 00 00       	call   8032c9 <sys_lock_cons>
	{
	//print out the results
	for(b=0; b< (*flight1BookedCounter);++b)
  8009dd:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
  8009e4:	eb 4b                	jmp    800a31 <_main+0x9f9>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
  8009e6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8009e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009f0:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8009f6:	01 d0                	add    %edx,%eax
  8009f8:	8b 00                	mov    (%eax),%eax
  8009fa:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800a01:	8b 45 98             	mov    -0x68(%ebp),%eax
  800a04:	01 d0                	add    %edx,%eax
  800a06:	8b 10                	mov    (%eax),%edx
  800a08:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800a0b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a12:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800a18:	01 c8                	add    %ecx,%eax
  800a1a:	8b 00                	mov    (%eax),%eax
  800a1c:	83 ec 04             	sub    $0x4,%esp
  800a1f:	52                   	push   %edx
  800a20:	50                   	push   %eax
  800a21:	68 ac 4a 80 00       	push   $0x804aac
  800a26:	e8 3a 0a 00 00       	call   801465 <cprintf>
  800a2b:	83 c4 10             	add    $0x10,%esp
	int b;

	sys_lock_cons();
	{
	//print out the results
	for(b=0; b< (*flight1BookedCounter);++b)
  800a2e:	ff 45 b8             	incl   -0x48(%ebp)
  800a31:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800a37:	8b 00                	mov    (%eax),%eax
  800a39:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800a3c:	7f a8                	jg     8009e6 <_main+0x9ae>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  800a3e:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
  800a45:	eb 4b                	jmp    800a92 <_main+0xa5a>
	{
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
  800a47:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800a4a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a51:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a57:	01 d0                	add    %edx,%eax
  800a59:	8b 00                	mov    (%eax),%eax
  800a5b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800a62:	8b 45 98             	mov    -0x68(%ebp),%eax
  800a65:	01 d0                	add    %edx,%eax
  800a67:	8b 10                	mov    (%eax),%edx
  800a69:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800a6c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a73:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a79:	01 c8                	add    %ecx,%eax
  800a7b:	8b 00                	mov    (%eax),%eax
  800a7d:	83 ec 04             	sub    $0x4,%esp
  800a80:	52                   	push   %edx
  800a81:	50                   	push   %eax
  800a82:	68 dc 4a 80 00       	push   $0x804adc
  800a87:	e8 d9 09 00 00       	call   801465 <cprintf>
  800a8c:	83 c4 10             	add    $0x10,%esp
	for(b=0; b< (*flight1BookedCounter);++b)
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  800a8f:	ff 45 b8             	incl   -0x48(%ebp)
  800a92:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800a98:	8b 00                	mov    (%eax),%eax
  800a9a:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800a9d:	7f a8                	jg     800a47 <_main+0xa0f>
	{
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
	}
	}
	sys_unlock_cons();
  800a9f:	e8 3f 28 00 00       	call   8032e3 <sys_unlock_cons>

	int numOfBookings = 0;
  800aa4:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
	int numOfFCusts[3] = {0};
  800aab:	8d 95 cc fc ff ff    	lea    -0x334(%ebp),%edx
  800ab1:	b9 03 00 00 00       	mov    $0x3,%ecx
  800ab6:	b8 00 00 00 00       	mov    $0x0,%eax
  800abb:	89 d7                	mov    %edx,%edi
  800abd:	f3 ab                	rep stos %eax,%es:(%edi)

	for(b=0; b< numOfCustomers;++b)
  800abf:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
  800ac6:	eb 3d                	jmp    800b05 <_main+0xacd>
	{
		if (custs[b].booked)
  800ac8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800acb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800ad2:	8b 45 98             	mov    -0x68(%ebp),%eax
  800ad5:	01 d0                	add    %edx,%eax
  800ad7:	8b 40 04             	mov    0x4(%eax),%eax
  800ada:	85 c0                	test   %eax,%eax
  800adc:	74 24                	je     800b02 <_main+0xaca>
		{
			numOfBookings++;
  800ade:	ff 45 b4             	incl   -0x4c(%ebp)
			numOfFCusts[custs[b].flightType - 1]++ ;
  800ae1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800ae4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800aeb:	8b 45 98             	mov    -0x68(%ebp),%eax
  800aee:	01 d0                	add    %edx,%eax
  800af0:	8b 00                	mov    (%eax),%eax
  800af2:	48                   	dec    %eax
  800af3:	8b 94 85 cc fc ff ff 	mov    -0x334(%ebp,%eax,4),%edx
  800afa:	42                   	inc    %edx
  800afb:	89 94 85 cc fc ff ff 	mov    %edx,-0x334(%ebp,%eax,4)
	sys_unlock_cons();

	int numOfBookings = 0;
	int numOfFCusts[3] = {0};

	for(b=0; b< numOfCustomers;++b)
  800b02:	ff 45 b8             	incl   -0x48(%ebp)
  800b05:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800b08:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800b0b:	7c bb                	jl     800ac8 <_main+0xa90>
			numOfBookings++;
			numOfFCusts[custs[b].flightType - 1]++ ;
		}
	}

	sys_lock_cons();
  800b0d:	e8 b7 27 00 00       	call   8032c9 <sys_lock_cons>
	{
	cprintf("%~[*] FINAL RESULTS:\n");
  800b12:	83 ec 0c             	sub    $0xc,%esp
  800b15:	68 0c 4b 80 00       	push   $0x804b0c
  800b1a:	e8 46 09 00 00       	call   801465 <cprintf>
  800b1f:	83 c4 10             	add    $0x10,%esp
	cprintf("%~\tTotal number of customers = %d (Flight1# = %d, Flight2# = %d, Flight3# = %d)\n", numOfCustomers, flight1NumOfCustomers,flight2NumOfCustomers,flight3NumOfCustomers);
  800b22:	83 ec 0c             	sub    $0xc,%esp
  800b25:	ff 75 d4             	pushl  -0x2c(%ebp)
  800b28:	ff 75 d8             	pushl  -0x28(%ebp)
  800b2b:	ff 75 dc             	pushl  -0x24(%ebp)
  800b2e:	ff 75 e0             	pushl  -0x20(%ebp)
  800b31:	68 24 4b 80 00       	push   $0x804b24
  800b36:	e8 2a 09 00 00       	call   801465 <cprintf>
  800b3b:	83 c4 20             	add    $0x20,%esp
	cprintf("%~\tTotal number of customers who receive tickets = %d (Flight1# = %d, Flight2# = %d, Flight3# = %d)\n", numOfBookings, numOfFCusts[0],numOfFCusts[1],numOfFCusts[2]);
  800b3e:	8b 8d d4 fc ff ff    	mov    -0x32c(%ebp),%ecx
  800b44:	8b 95 d0 fc ff ff    	mov    -0x330(%ebp),%edx
  800b4a:	8b 85 cc fc ff ff    	mov    -0x334(%ebp),%eax
  800b50:	83 ec 0c             	sub    $0xc,%esp
  800b53:	51                   	push   %ecx
  800b54:	52                   	push   %edx
  800b55:	50                   	push   %eax
  800b56:	ff 75 b4             	pushl  -0x4c(%ebp)
  800b59:	68 78 4b 80 00       	push   $0x804b78
  800b5e:	e8 02 09 00 00       	call   801465 <cprintf>
  800b63:	83 c4 20             	add    $0x20,%esp
	}
	sys_unlock_cons();
  800b66:	e8 78 27 00 00       	call   8032e3 <sys_unlock_cons>
	//check out the final results and semaphores
	{
		for(int c = 0; c < numOfCustomers; ++c)
  800b6b:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  800b72:	e9 13 01 00 00       	jmp    800c8a <_main+0xc52>
		{
			if (custs[c].booked)
  800b77:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800b7a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800b81:	8b 45 98             	mov    -0x68(%ebp),%eax
  800b84:	01 d0                	add    %edx,%eax
  800b86:	8b 40 04             	mov    0x4(%eax),%eax
  800b89:	85 c0                	test   %eax,%eax
  800b8b:	0f 84 f6 00 00 00    	je     800c87 <_main+0xc4f>
			{
				if(custs[c].flightType ==1 && find(flight1BookedArr, flight1NumOfTickets, c) != 1)
  800b91:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800b94:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800b9b:	8b 45 98             	mov    -0x68(%ebp),%eax
  800b9e:	01 d0                	add    %edx,%eax
  800ba0:	8b 00                	mov    (%eax),%eax
  800ba2:	83 f8 01             	cmp    $0x1,%eax
  800ba5:	75 33                	jne    800bda <_main+0xba2>
  800ba7:	83 ec 04             	sub    $0x4,%esp
  800baa:	ff 75 b0             	pushl  -0x50(%ebp)
  800bad:	ff 75 d0             	pushl  -0x30(%ebp)
  800bb0:	ff b5 70 ff ff ff    	pushl  -0x90(%ebp)
  800bb6:	e8 8b 03 00 00       	call   800f46 <find>
  800bbb:	83 c4 10             	add    $0x10,%esp
  800bbe:	83 f8 01             	cmp    $0x1,%eax
  800bc1:	74 17                	je     800bda <_main+0xba2>
				{
					panic("Error, wrong booking for user %d\n", c);
  800bc3:	ff 75 b0             	pushl  -0x50(%ebp)
  800bc6:	68 e0 4b 80 00       	push   $0x804be0
  800bcb:	68 ed 00 00 00       	push   $0xed
  800bd0:	68 9a 4a 80 00       	push   $0x804a9a
  800bd5:	e8 9d 05 00 00       	call   801177 <_panic>
				}
				if(custs[c].flightType ==2 && find(flight2BookedArr, flight2NumOfTickets, c) != 1)
  800bda:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800bdd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800be4:	8b 45 98             	mov    -0x68(%ebp),%eax
  800be7:	01 d0                	add    %edx,%eax
  800be9:	8b 00                	mov    (%eax),%eax
  800beb:	83 f8 02             	cmp    $0x2,%eax
  800bee:	75 33                	jne    800c23 <_main+0xbeb>
  800bf0:	83 ec 04             	sub    $0x4,%esp
  800bf3:	ff 75 b0             	pushl  -0x50(%ebp)
  800bf6:	ff 75 cc             	pushl  -0x34(%ebp)
  800bf9:	ff b5 6c ff ff ff    	pushl  -0x94(%ebp)
  800bff:	e8 42 03 00 00       	call   800f46 <find>
  800c04:	83 c4 10             	add    $0x10,%esp
  800c07:	83 f8 01             	cmp    $0x1,%eax
  800c0a:	74 17                	je     800c23 <_main+0xbeb>
				{
					panic("Error, wrong booking for user %d\n", c);
  800c0c:	ff 75 b0             	pushl  -0x50(%ebp)
  800c0f:	68 e0 4b 80 00       	push   $0x804be0
  800c14:	68 f1 00 00 00       	push   $0xf1
  800c19:	68 9a 4a 80 00       	push   $0x804a9a
  800c1e:	e8 54 05 00 00       	call   801177 <_panic>
				}
				if(custs[c].flightType ==3 && ((find(flight1BookedArr, flight1NumOfTickets, c) + find(flight2BookedArr, flight2NumOfTickets, c)) != 2))
  800c23:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800c26:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800c2d:	8b 45 98             	mov    -0x68(%ebp),%eax
  800c30:	01 d0                	add    %edx,%eax
  800c32:	8b 00                	mov    (%eax),%eax
  800c34:	83 f8 03             	cmp    $0x3,%eax
  800c37:	75 4e                	jne    800c87 <_main+0xc4f>
  800c39:	83 ec 04             	sub    $0x4,%esp
  800c3c:	ff 75 b0             	pushl  -0x50(%ebp)
  800c3f:	ff 75 d0             	pushl  -0x30(%ebp)
  800c42:	ff b5 70 ff ff ff    	pushl  -0x90(%ebp)
  800c48:	e8 f9 02 00 00       	call   800f46 <find>
  800c4d:	83 c4 10             	add    $0x10,%esp
  800c50:	89 c3                	mov    %eax,%ebx
  800c52:	83 ec 04             	sub    $0x4,%esp
  800c55:	ff 75 b0             	pushl  -0x50(%ebp)
  800c58:	ff 75 cc             	pushl  -0x34(%ebp)
  800c5b:	ff b5 6c ff ff ff    	pushl  -0x94(%ebp)
  800c61:	e8 e0 02 00 00       	call   800f46 <find>
  800c66:	83 c4 10             	add    $0x10,%esp
  800c69:	01 d8                	add    %ebx,%eax
  800c6b:	83 f8 02             	cmp    $0x2,%eax
  800c6e:	74 17                	je     800c87 <_main+0xc4f>
				{
					panic("Error, wrong booking for user %d\n", c);
  800c70:	ff 75 b0             	pushl  -0x50(%ebp)
  800c73:	68 e0 4b 80 00       	push   $0x804be0
  800c78:	68 f5 00 00 00       	push   $0xf5
  800c7d:	68 9a 4a 80 00       	push   $0x804a9a
  800c82:	e8 f0 04 00 00       	call   801177 <_panic>
	cprintf("%~\tTotal number of customers who receive tickets = %d (Flight1# = %d, Flight2# = %d, Flight3# = %d)\n", numOfBookings, numOfFCusts[0],numOfFCusts[1],numOfFCusts[2]);
	}
	sys_unlock_cons();
	//check out the final results and semaphores
	{
		for(int c = 0; c < numOfCustomers; ++c)
  800c87:	ff 45 b0             	incl   -0x50(%ebp)
  800c8a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800c8d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800c90:	0f 8c e1 fe ff ff    	jl     800b77 <_main+0xb3f>
					panic("Error, wrong booking for user %d\n", c);
				}
			}
		}

		assert(semaphore_count(capacity) == agentCapacity);
  800c96:	83 ec 0c             	sub    $0xc,%esp
  800c99:	ff b5 f8 fc ff ff    	pushl  -0x308(%ebp)
  800c9f:	e8 ea 38 00 00       	call   80458e <semaphore_count>
  800ca4:	83 c4 10             	add    $0x10,%esp
  800ca7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800caa:	74 19                	je     800cc5 <_main+0xc8d>
  800cac:	68 04 4c 80 00       	push   $0x804c04
  800cb1:	68 2f 4c 80 00       	push   $0x804c2f
  800cb6:	68 fa 00 00 00       	push   $0xfa
  800cbb:	68 9a 4a 80 00       	push   $0x804a9a
  800cc0:	e8 b2 04 00 00       	call   801177 <_panic>

		assert(semaphore_count(flight1CS) == 1);
  800cc5:	83 ec 0c             	sub    $0xc,%esp
  800cc8:	ff b5 f4 fc ff ff    	pushl  -0x30c(%ebp)
  800cce:	e8 bb 38 00 00       	call   80458e <semaphore_count>
  800cd3:	83 c4 10             	add    $0x10,%esp
  800cd6:	83 f8 01             	cmp    $0x1,%eax
  800cd9:	74 19                	je     800cf4 <_main+0xcbc>
  800cdb:	68 44 4c 80 00       	push   $0x804c44
  800ce0:	68 2f 4c 80 00       	push   $0x804c2f
  800ce5:	68 fc 00 00 00       	push   $0xfc
  800cea:	68 9a 4a 80 00       	push   $0x804a9a
  800cef:	e8 83 04 00 00       	call   801177 <_panic>
		assert(semaphore_count(flight2CS) == 1);
  800cf4:	83 ec 0c             	sub    $0xc,%esp
  800cf7:	ff b5 f0 fc ff ff    	pushl  -0x310(%ebp)
  800cfd:	e8 8c 38 00 00       	call   80458e <semaphore_count>
  800d02:	83 c4 10             	add    $0x10,%esp
  800d05:	83 f8 01             	cmp    $0x1,%eax
  800d08:	74 19                	je     800d23 <_main+0xceb>
  800d0a:	68 64 4c 80 00       	push   $0x804c64
  800d0f:	68 2f 4c 80 00       	push   $0x804c2f
  800d14:	68 fd 00 00 00       	push   $0xfd
  800d19:	68 9a 4a 80 00       	push   $0x804a9a
  800d1e:	e8 54 04 00 00       	call   801177 <_panic>

		assert(semaphore_count(custCounterCS) ==  1);
  800d23:	83 ec 0c             	sub    $0xc,%esp
  800d26:	ff b5 ec fc ff ff    	pushl  -0x314(%ebp)
  800d2c:	e8 5d 38 00 00       	call   80458e <semaphore_count>
  800d31:	83 c4 10             	add    $0x10,%esp
  800d34:	83 f8 01             	cmp    $0x1,%eax
  800d37:	74 19                	je     800d52 <_main+0xd1a>
  800d39:	68 84 4c 80 00       	push   $0x804c84
  800d3e:	68 2f 4c 80 00       	push   $0x804c2f
  800d43:	68 ff 00 00 00       	push   $0xff
  800d48:	68 9a 4a 80 00       	push   $0x804a9a
  800d4d:	e8 25 04 00 00       	call   801177 <_panic>
		assert(semaphore_count(custQueueCS)  ==  1);
  800d52:	83 ec 0c             	sub    $0xc,%esp
  800d55:	ff b5 e8 fc ff ff    	pushl  -0x318(%ebp)
  800d5b:	e8 2e 38 00 00       	call   80458e <semaphore_count>
  800d60:	83 c4 10             	add    $0x10,%esp
  800d63:	83 f8 01             	cmp    $0x1,%eax
  800d66:	74 19                	je     800d81 <_main+0xd49>
  800d68:	68 a8 4c 80 00       	push   $0x804ca8
  800d6d:	68 2f 4c 80 00       	push   $0x804c2f
  800d72:	68 00 01 00 00       	push   $0x100
  800d77:	68 9a 4a 80 00       	push   $0x804a9a
  800d7c:	e8 f6 03 00 00       	call   801177 <_panic>

		assert(semaphore_count(clerk)  == 3);
  800d81:	83 ec 0c             	sub    $0xc,%esp
  800d84:	ff b5 e4 fc ff ff    	pushl  -0x31c(%ebp)
  800d8a:	e8 ff 37 00 00       	call   80458e <semaphore_count>
  800d8f:	83 c4 10             	add    $0x10,%esp
  800d92:	83 f8 03             	cmp    $0x3,%eax
  800d95:	74 19                	je     800db0 <_main+0xd78>
  800d97:	68 ca 4c 80 00       	push   $0x804cca
  800d9c:	68 2f 4c 80 00       	push   $0x804c2f
  800da1:	68 02 01 00 00       	push   $0x102
  800da6:	68 9a 4a 80 00       	push   $0x804a9a
  800dab:	e8 c7 03 00 00       	call   801177 <_panic>

		assert(semaphore_count(cust_ready) == -3);
  800db0:	83 ec 0c             	sub    $0xc,%esp
  800db3:	ff b5 e0 fc ff ff    	pushl  -0x320(%ebp)
  800db9:	e8 d0 37 00 00       	call   80458e <semaphore_count>
  800dbe:	83 c4 10             	add    $0x10,%esp
  800dc1:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800dc4:	74 19                	je     800ddf <_main+0xda7>
  800dc6:	68 e8 4c 80 00       	push   $0x804ce8
  800dcb:	68 2f 4c 80 00       	push   $0x804c2f
  800dd0:	68 04 01 00 00       	push   $0x104
  800dd5:	68 9a 4a 80 00       	push   $0x804a9a
  800dda:	e8 98 03 00 00       	call   801177 <_panic>

		assert(semaphore_count(custTerminated) ==  0);
  800ddf:	83 ec 0c             	sub    $0xc,%esp
  800de2:	ff b5 dc fc ff ff    	pushl  -0x324(%ebp)
  800de8:	e8 a1 37 00 00       	call   80458e <semaphore_count>
  800ded:	83 c4 10             	add    $0x10,%esp
  800df0:	85 c0                	test   %eax,%eax
  800df2:	74 19                	je     800e0d <_main+0xdd5>
  800df4:	68 0c 4d 80 00       	push   $0x804d0c
  800df9:	68 2f 4c 80 00       	push   $0x804c2f
  800dfe:	68 06 01 00 00       	push   $0x106
  800e03:	68 9a 4a 80 00       	push   $0x804a9a
  800e08:	e8 6a 03 00 00       	call   801177 <_panic>

		int s=0;
  800e0d:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		for(s=0; s<numOfCustomers; ++s)
  800e14:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
  800e1b:	eb 3f                	jmp    800e5c <_main+0xe24>
		{
			assert(semaphore_count(cust_finished[s]) ==  0);
  800e1d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800e20:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e27:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800e2d:	01 d0                	add    %edx,%eax
  800e2f:	83 ec 0c             	sub    $0xc,%esp
  800e32:	ff 30                	pushl  (%eax)
  800e34:	e8 55 37 00 00       	call   80458e <semaphore_count>
  800e39:	83 c4 10             	add    $0x10,%esp
  800e3c:	85 c0                	test   %eax,%eax
  800e3e:	74 19                	je     800e59 <_main+0xe21>
  800e40:	68 34 4d 80 00       	push   $0x804d34
  800e45:	68 2f 4c 80 00       	push   $0x804c2f
  800e4a:	68 0b 01 00 00       	push   $0x10b
  800e4f:	68 9a 4a 80 00       	push   $0x804a9a
  800e54:	e8 1e 03 00 00       	call   801177 <_panic>
		assert(semaphore_count(cust_ready) == -3);

		assert(semaphore_count(custTerminated) ==  0);

		int s=0;
		for(s=0; s<numOfCustomers; ++s)
  800e59:	ff 45 ac             	incl   -0x54(%ebp)
  800e5c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800e5f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800e62:	7c b9                	jl     800e1d <_main+0xde5>
		{
			assert(semaphore_count(cust_finished[s]) ==  0);
		}

		atomic_cprintf("%~\nAll reservations are successfully done... have a nice flight :)\n");
  800e64:	83 ec 0c             	sub    $0xc,%esp
  800e67:	68 5c 4d 80 00       	push   $0x804d5c
  800e6c:	e8 66 06 00 00       	call   8014d7 <atomic_cprintf>
  800e71:	83 c4 10             	add    $0x10,%esp

		//waste some time then close the agency
		env_sleep(5000) ;
  800e74:	83 ec 0c             	sub    $0xc,%esp
  800e77:	68 88 13 00 00       	push   $0x1388
  800e7c:	e8 18 37 00 00       	call   804599 <env_sleep>
  800e81:	83 c4 10             	add    $0x10,%esp
		*isOpened = 0;
  800e84:	8b 45 88             	mov    -0x78(%ebp),%eax
  800e87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		atomic_cprintf("\n%~The agency is closing now...\n");
  800e8d:	83 ec 0c             	sub    $0xc,%esp
  800e90:	68 a0 4d 80 00       	push   $0x804da0
  800e95:	e8 3d 06 00 00       	call   8014d7 <atomic_cprintf>
  800e9a:	83 c4 10             	add    $0x10,%esp

		//Signal all clerks to continue and recheck the isOpened flag
		cust_ready_queue[numOfCustomers] = -1; //to indicate, for the clerk, there's no more customers
  800e9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ea0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ea7:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800ead:	01 d0                	add    %edx,%eax
  800eaf:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
		for (int k = 0; k < numOfClerks; ++k)
  800eb5:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
  800ebc:	eb 14                	jmp    800ed2 <_main+0xe9a>
		{
			signal_semaphore(cust_ready);
  800ebe:	83 ec 0c             	sub    $0xc,%esp
  800ec1:	ff b5 e0 fc ff ff    	pushl  -0x320(%ebp)
  800ec7:	e8 a8 36 00 00       	call   804574 <signal_semaphore>
  800ecc:	83 c4 10             	add    $0x10,%esp
		*isOpened = 0;
		atomic_cprintf("\n%~The agency is closing now...\n");

		//Signal all clerks to continue and recheck the isOpened flag
		cust_ready_queue[numOfCustomers] = -1; //to indicate, for the clerk, there's no more customers
		for (int k = 0; k < numOfClerks; ++k)
  800ecf:	ff 45 a8             	incl   -0x58(%ebp)
  800ed2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800ed5:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  800ed8:	7c e4                	jl     800ebe <_main+0xe86>
		{
			signal_semaphore(cust_ready);
		}

		//Wait all clerks to finished
		for (int k = 0; k < numOfClerks; ++k)
  800eda:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
  800ee1:	eb 14                	jmp    800ef7 <_main+0xebf>
		{
			wait_semaphore(clerkTerminated);
  800ee3:	83 ec 0c             	sub    $0xc,%esp
  800ee6:	ff b5 d8 fc ff ff    	pushl  -0x328(%ebp)
  800eec:	e8 69 36 00 00       	call   80455a <wait_semaphore>
  800ef1:	83 c4 10             	add    $0x10,%esp
		{
			signal_semaphore(cust_ready);
		}

		//Wait all clerks to finished
		for (int k = 0; k < numOfClerks; ++k)
  800ef4:	ff 45 a4             	incl   -0x5c(%ebp)
  800ef7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800efa:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  800efd:	7c e4                	jl     800ee3 <_main+0xeab>
		{
			wait_semaphore(clerkTerminated);
		}

		assert(semaphore_count(clerkTerminated) ==  0);
  800eff:	83 ec 0c             	sub    $0xc,%esp
  800f02:	ff b5 d8 fc ff ff    	pushl  -0x328(%ebp)
  800f08:	e8 81 36 00 00       	call   80458e <semaphore_count>
  800f0d:	83 c4 10             	add    $0x10,%esp
  800f10:	85 c0                	test   %eax,%eax
  800f12:	74 19                	je     800f2d <_main+0xef5>
  800f14:	68 c4 4d 80 00       	push   $0x804dc4
  800f19:	68 2f 4c 80 00       	push   $0x804c2f
  800f1e:	68 22 01 00 00       	push   $0x122
  800f23:	68 9a 4a 80 00       	push   $0x804a9a
  800f28:	e8 4a 02 00 00       	call   801177 <_panic>

		atomic_cprintf("%~\nCongratulations... Airplane Reservation App is Finished Successfully\n\n");
  800f2d:	83 ec 0c             	sub    $0xc,%esp
  800f30:	68 ec 4d 80 00       	push   $0x804dec
  800f35:	e8 9d 05 00 00       	call   8014d7 <atomic_cprintf>
  800f3a:	83 c4 10             	add    $0x10,%esp
	}

}
  800f3d:	90                   	nop
  800f3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f41:	5b                   	pop    %ebx
  800f42:	5e                   	pop    %esi
  800f43:	5f                   	pop    %edi
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    

00800f46 <find>:


int find(int* arr, int size, int val)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	83 ec 10             	sub    $0x10,%esp

	int result = 0;
  800f4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

	int i;
	for(i=0; i<size;++i )
  800f53:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f5a:	eb 22                	jmp    800f7e <find+0x38>
	{
		if(arr[i] == val)
  800f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	01 d0                	add    %edx,%eax
  800f6b:	8b 00                	mov    (%eax),%eax
  800f6d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f70:	75 09                	jne    800f7b <find+0x35>
		{
			result = 1;
  800f72:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
			break;
  800f79:	eb 0b                	jmp    800f86 <find+0x40>
{

	int result = 0;

	int i;
	for(i=0; i<size;++i )
  800f7b:	ff 45 f8             	incl   -0x8(%ebp)
  800f7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f81:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800f84:	7c d6                	jl     800f5c <find+0x16>
			result = 1;
			break;
		}
	}

	return result;
  800f86:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f89:	c9                   	leave  
  800f8a:	c3                   	ret    

00800f8b <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800f97:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800f9b:	83 ec 0c             	sub    $0xc,%esp
  800f9e:	50                   	push   %eax
  800f9f:	e8 6d 24 00 00       	call   803411 <sys_cputc>
  800fa4:	83 c4 10             	add    $0x10,%esp
}
  800fa7:	90                   	nop
  800fa8:	c9                   	leave  
  800fa9:	c3                   	ret    

00800faa <getchar>:


int
getchar(void)
{
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  800fb0:	e8 fb 22 00 00       	call   8032b0 <sys_cgetc>
  800fb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fbb:	c9                   	leave  
  800fbc:	c3                   	ret    

00800fbd <iscons>:

int iscons(int fdnum)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800fc0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fc5:	5d                   	pop    %ebp
  800fc6:	c3                   	ret    

00800fc7 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800fc7:	55                   	push   %ebp
  800fc8:	89 e5                	mov    %esp,%ebp
  800fca:	57                   	push   %edi
  800fcb:	56                   	push   %esi
  800fcc:	53                   	push   %ebx
  800fcd:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800fd0:	e8 6d 25 00 00       	call   803542 <sys_getenvindex>
  800fd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800fd8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800fdb:	89 d0                	mov    %edx,%eax
  800fdd:	01 c0                	add    %eax,%eax
  800fdf:	01 d0                	add    %edx,%eax
  800fe1:	c1 e0 02             	shl    $0x2,%eax
  800fe4:	01 d0                	add    %edx,%eax
  800fe6:	c1 e0 02             	shl    $0x2,%eax
  800fe9:	01 d0                	add    %edx,%eax
  800feb:	c1 e0 03             	shl    $0x3,%eax
  800fee:	01 d0                	add    %edx,%eax
  800ff0:	c1 e0 02             	shl    $0x2,%eax
  800ff3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ff8:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800ffd:	a1 20 60 80 00       	mov    0x806020,%eax
  801002:	8a 40 20             	mov    0x20(%eax),%al
  801005:	84 c0                	test   %al,%al
  801007:	74 0d                	je     801016 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  801009:	a1 20 60 80 00       	mov    0x806020,%eax
  80100e:	83 c0 20             	add    $0x20,%eax
  801011:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801016:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80101a:	7e 0a                	jle    801026 <libmain+0x5f>
		binaryname = argv[0];
  80101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101f:	8b 00                	mov    (%eax),%eax
  801021:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  801026:	83 ec 08             	sub    $0x8,%esp
  801029:	ff 75 0c             	pushl  0xc(%ebp)
  80102c:	ff 75 08             	pushl  0x8(%ebp)
  80102f:	e8 04 f0 ff ff       	call   800038 <_main>
  801034:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  801037:	a1 00 60 80 00       	mov    0x806000,%eax
  80103c:	85 c0                	test   %eax,%eax
  80103e:	0f 84 01 01 00 00    	je     801145 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  801044:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80104a:	bb a0 50 80 00       	mov    $0x8050a0,%ebx
  80104f:	ba 0e 00 00 00       	mov    $0xe,%edx
  801054:	89 c7                	mov    %eax,%edi
  801056:	89 de                	mov    %ebx,%esi
  801058:	89 d1                	mov    %edx,%ecx
  80105a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80105c:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80105f:	b9 56 00 00 00       	mov    $0x56,%ecx
  801064:	b0 00                	mov    $0x0,%al
  801066:	89 d7                	mov    %edx,%edi
  801068:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80106a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  801071:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801074:	83 ec 08             	sub    $0x8,%esp
  801077:	50                   	push   %eax
  801078:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80107e:	50                   	push   %eax
  80107f:	e8 f4 26 00 00       	call   803778 <sys_utilities>
  801084:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  801087:	e8 3d 22 00 00       	call   8032c9 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80108c:	83 ec 0c             	sub    $0xc,%esp
  80108f:	68 c0 4f 80 00       	push   $0x804fc0
  801094:	e8 cc 03 00 00       	call   801465 <cprintf>
  801099:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80109c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80109f:	85 c0                	test   %eax,%eax
  8010a1:	74 18                	je     8010bb <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8010a3:	e8 ee 26 00 00       	call   803796 <sys_get_optimal_num_faults>
  8010a8:	83 ec 08             	sub    $0x8,%esp
  8010ab:	50                   	push   %eax
  8010ac:	68 e8 4f 80 00       	push   $0x804fe8
  8010b1:	e8 af 03 00 00       	call   801465 <cprintf>
  8010b6:	83 c4 10             	add    $0x10,%esp
  8010b9:	eb 59                	jmp    801114 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8010bb:	a1 20 60 80 00       	mov    0x806020,%eax
  8010c0:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8010c6:	a1 20 60 80 00       	mov    0x806020,%eax
  8010cb:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8010d1:	83 ec 04             	sub    $0x4,%esp
  8010d4:	52                   	push   %edx
  8010d5:	50                   	push   %eax
  8010d6:	68 0c 50 80 00       	push   $0x80500c
  8010db:	e8 85 03 00 00       	call   801465 <cprintf>
  8010e0:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8010e3:	a1 20 60 80 00       	mov    0x806020,%eax
  8010e8:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  8010ee:	a1 20 60 80 00       	mov    0x806020,%eax
  8010f3:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  8010f9:	a1 20 60 80 00       	mov    0x806020,%eax
  8010fe:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  801104:	51                   	push   %ecx
  801105:	52                   	push   %edx
  801106:	50                   	push   %eax
  801107:	68 34 50 80 00       	push   $0x805034
  80110c:	e8 54 03 00 00       	call   801465 <cprintf>
  801111:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801114:	a1 20 60 80 00       	mov    0x806020,%eax
  801119:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  80111f:	83 ec 08             	sub    $0x8,%esp
  801122:	50                   	push   %eax
  801123:	68 8c 50 80 00       	push   $0x80508c
  801128:	e8 38 03 00 00       	call   801465 <cprintf>
  80112d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  801130:	83 ec 0c             	sub    $0xc,%esp
  801133:	68 c0 4f 80 00       	push   $0x804fc0
  801138:	e8 28 03 00 00       	call   801465 <cprintf>
  80113d:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  801140:	e8 9e 21 00 00       	call   8032e3 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  801145:	e8 1f 00 00 00       	call   801169 <exit>
}
  80114a:	90                   	nop
  80114b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80114e:	5b                   	pop    %ebx
  80114f:	5e                   	pop    %esi
  801150:	5f                   	pop    %edi
  801151:	5d                   	pop    %ebp
  801152:	c3                   	ret    

00801153 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801159:	83 ec 0c             	sub    $0xc,%esp
  80115c:	6a 00                	push   $0x0
  80115e:	e8 ab 23 00 00       	call   80350e <sys_destroy_env>
  801163:	83 c4 10             	add    $0x10,%esp
}
  801166:	90                   	nop
  801167:	c9                   	leave  
  801168:	c3                   	ret    

00801169 <exit>:

void
exit(void)
{
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
  80116c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80116f:	e8 00 24 00 00       	call   803574 <sys_exit_env>
}
  801174:	90                   	nop
  801175:	c9                   	leave  
  801176:	c3                   	ret    

00801177 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
  80117a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80117d:	8d 45 10             	lea    0x10(%ebp),%eax
  801180:	83 c0 04             	add    $0x4,%eax
  801183:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801186:	a1 18 e1 81 00       	mov    0x81e118,%eax
  80118b:	85 c0                	test   %eax,%eax
  80118d:	74 16                	je     8011a5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80118f:	a1 18 e1 81 00       	mov    0x81e118,%eax
  801194:	83 ec 08             	sub    $0x8,%esp
  801197:	50                   	push   %eax
  801198:	68 04 51 80 00       	push   $0x805104
  80119d:	e8 c3 02 00 00       	call   801465 <cprintf>
  8011a2:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8011a5:	a1 04 60 80 00       	mov    0x806004,%eax
  8011aa:	83 ec 0c             	sub    $0xc,%esp
  8011ad:	ff 75 0c             	pushl  0xc(%ebp)
  8011b0:	ff 75 08             	pushl  0x8(%ebp)
  8011b3:	50                   	push   %eax
  8011b4:	68 0c 51 80 00       	push   $0x80510c
  8011b9:	6a 74                	push   $0x74
  8011bb:	e8 d2 02 00 00       	call   801492 <cprintf_colored>
  8011c0:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8011c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c6:	83 ec 08             	sub    $0x8,%esp
  8011c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8011cc:	50                   	push   %eax
  8011cd:	e8 24 02 00 00       	call   8013f6 <vcprintf>
  8011d2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8011d5:	83 ec 08             	sub    $0x8,%esp
  8011d8:	6a 00                	push   $0x0
  8011da:	68 34 51 80 00       	push   $0x805134
  8011df:	e8 12 02 00 00       	call   8013f6 <vcprintf>
  8011e4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8011e7:	e8 7d ff ff ff       	call   801169 <exit>

	// should not return here
	while (1) ;
  8011ec:	eb fe                	jmp    8011ec <_panic+0x75>

008011ee <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	53                   	push   %ebx
  8011f2:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8011f5:	a1 20 60 80 00       	mov    0x806020,%eax
  8011fa:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801200:	8b 45 0c             	mov    0xc(%ebp),%eax
  801203:	39 c2                	cmp    %eax,%edx
  801205:	74 14                	je     80121b <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801207:	83 ec 04             	sub    $0x4,%esp
  80120a:	68 38 51 80 00       	push   $0x805138
  80120f:	6a 26                	push   $0x26
  801211:	68 84 51 80 00       	push   $0x805184
  801216:	e8 5c ff ff ff       	call   801177 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80121b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801222:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801229:	e9 d9 00 00 00       	jmp    801307 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  80122e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801231:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	01 d0                	add    %edx,%eax
  80123d:	8b 00                	mov    (%eax),%eax
  80123f:	85 c0                	test   %eax,%eax
  801241:	75 08                	jne    80124b <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  801243:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801246:	e9 b9 00 00 00       	jmp    801304 <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  80124b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801252:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801259:	eb 79                	jmp    8012d4 <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80125b:	a1 20 60 80 00       	mov    0x806020,%eax
  801260:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  801266:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801269:	89 d0                	mov    %edx,%eax
  80126b:	01 c0                	add    %eax,%eax
  80126d:	01 d0                	add    %edx,%eax
  80126f:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  801276:	01 d8                	add    %ebx,%eax
  801278:	01 d0                	add    %edx,%eax
  80127a:	01 c8                	add    %ecx,%eax
  80127c:	8a 40 04             	mov    0x4(%eax),%al
  80127f:	84 c0                	test   %al,%al
  801281:	75 4e                	jne    8012d1 <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801283:	a1 20 60 80 00       	mov    0x806020,%eax
  801288:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80128e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801291:	89 d0                	mov    %edx,%eax
  801293:	01 c0                	add    %eax,%eax
  801295:	01 d0                	add    %edx,%eax
  801297:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80129e:	01 d8                	add    %ebx,%eax
  8012a0:	01 d0                	add    %edx,%eax
  8012a2:	01 c8                	add    %ecx,%eax
  8012a4:	8b 00                	mov    (%eax),%eax
  8012a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8012a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012b1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8012b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	01 c8                	add    %ecx,%eax
  8012c2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8012c4:	39 c2                	cmp    %eax,%edx
  8012c6:	75 09                	jne    8012d1 <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  8012c8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8012cf:	eb 19                	jmp    8012ea <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8012d1:	ff 45 e8             	incl   -0x18(%ebp)
  8012d4:	a1 20 60 80 00       	mov    0x806020,%eax
  8012d9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8012df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012e2:	39 c2                	cmp    %eax,%edx
  8012e4:	0f 87 71 ff ff ff    	ja     80125b <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8012ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012ee:	75 14                	jne    801304 <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  8012f0:	83 ec 04             	sub    $0x4,%esp
  8012f3:	68 90 51 80 00       	push   $0x805190
  8012f8:	6a 3a                	push   $0x3a
  8012fa:	68 84 51 80 00       	push   $0x805184
  8012ff:	e8 73 fe ff ff       	call   801177 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801304:	ff 45 f0             	incl   -0x10(%ebp)
  801307:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80130a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80130d:	0f 8c 1b ff ff ff    	jl     80122e <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801313:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80131a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801321:	eb 2e                	jmp    801351 <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801323:	a1 20 60 80 00       	mov    0x806020,%eax
  801328:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  80132e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801331:	89 d0                	mov    %edx,%eax
  801333:	01 c0                	add    %eax,%eax
  801335:	01 d0                	add    %edx,%eax
  801337:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  80133e:	01 d8                	add    %ebx,%eax
  801340:	01 d0                	add    %edx,%eax
  801342:	01 c8                	add    %ecx,%eax
  801344:	8a 40 04             	mov    0x4(%eax),%al
  801347:	3c 01                	cmp    $0x1,%al
  801349:	75 03                	jne    80134e <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  80134b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80134e:	ff 45 e0             	incl   -0x20(%ebp)
  801351:	a1 20 60 80 00       	mov    0x806020,%eax
  801356:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80135c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80135f:	39 c2                	cmp    %eax,%edx
  801361:	77 c0                	ja     801323 <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801366:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801369:	74 14                	je     80137f <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  80136b:	83 ec 04             	sub    $0x4,%esp
  80136e:	68 e4 51 80 00       	push   $0x8051e4
  801373:	6a 44                	push   $0x44
  801375:	68 84 51 80 00       	push   $0x805184
  80137a:	e8 f8 fd ff ff       	call   801177 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80137f:	90                   	nop
  801380:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801383:	c9                   	leave  
  801384:	c3                   	ret    

00801385 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801385:	55                   	push   %ebp
  801386:	89 e5                	mov    %esp,%ebp
  801388:	53                   	push   %ebx
  801389:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80138c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138f:	8b 00                	mov    (%eax),%eax
  801391:	8d 48 01             	lea    0x1(%eax),%ecx
  801394:	8b 55 0c             	mov    0xc(%ebp),%edx
  801397:	89 0a                	mov    %ecx,(%edx)
  801399:	8b 55 08             	mov    0x8(%ebp),%edx
  80139c:	88 d1                	mov    %dl,%cl
  80139e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8013a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a8:	8b 00                	mov    (%eax),%eax
  8013aa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8013af:	75 30                	jne    8013e1 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8013b1:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  8013b7:	a0 44 60 80 00       	mov    0x806044,%al
  8013bc:	0f b6 c0             	movzbl %al,%eax
  8013bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013c2:	8b 09                	mov    (%ecx),%ecx
  8013c4:	89 cb                	mov    %ecx,%ebx
  8013c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013c9:	83 c1 08             	add    $0x8,%ecx
  8013cc:	52                   	push   %edx
  8013cd:	50                   	push   %eax
  8013ce:	53                   	push   %ebx
  8013cf:	51                   	push   %ecx
  8013d0:	e8 b0 1e 00 00       	call   803285 <sys_cputs>
  8013d5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8013d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8013e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e4:	8b 40 04             	mov    0x4(%eax),%eax
  8013e7:	8d 50 01             	lea    0x1(%eax),%edx
  8013ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ed:	89 50 04             	mov    %edx,0x4(%eax)
}
  8013f0:	90                   	nop
  8013f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013f4:	c9                   	leave  
  8013f5:	c3                   	ret    

008013f6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
  8013f9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8013ff:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801406:	00 00 00 
	b.cnt = 0;
  801409:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801410:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801413:	ff 75 0c             	pushl  0xc(%ebp)
  801416:	ff 75 08             	pushl  0x8(%ebp)
  801419:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80141f:	50                   	push   %eax
  801420:	68 85 13 80 00       	push   $0x801385
  801425:	e8 5a 02 00 00       	call   801684 <vprintfmt>
  80142a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80142d:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  801433:	a0 44 60 80 00       	mov    0x806044,%al
  801438:	0f b6 c0             	movzbl %al,%eax
  80143b:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801441:	52                   	push   %edx
  801442:	50                   	push   %eax
  801443:	51                   	push   %ecx
  801444:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80144a:	83 c0 08             	add    $0x8,%eax
  80144d:	50                   	push   %eax
  80144e:	e8 32 1e 00 00       	call   803285 <sys_cputs>
  801453:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801456:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
	return b.cnt;
  80145d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801463:	c9                   	leave  
  801464:	c3                   	ret    

00801465 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801465:	55                   	push   %ebp
  801466:	89 e5                	mov    %esp,%ebp
  801468:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80146b:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	va_start(ap, fmt);
  801472:	8d 45 0c             	lea    0xc(%ebp),%eax
  801475:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	83 ec 08             	sub    $0x8,%esp
  80147e:	ff 75 f4             	pushl  -0xc(%ebp)
  801481:	50                   	push   %eax
  801482:	e8 6f ff ff ff       	call   8013f6 <vcprintf>
  801487:	83 c4 10             	add    $0x10,%esp
  80148a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80148d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801490:	c9                   	leave  
  801491:	c3                   	ret    

00801492 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
  801495:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801498:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	c1 e0 08             	shl    $0x8,%eax
  8014a5:	a3 1c e1 81 00       	mov    %eax,0x81e11c
	va_start(ap, fmt);
  8014aa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8014ad:	83 c0 04             	add    $0x4,%eax
  8014b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8014b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b6:	83 ec 08             	sub    $0x8,%esp
  8014b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8014bc:	50                   	push   %eax
  8014bd:	e8 34 ff ff ff       	call   8013f6 <vcprintf>
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8014c8:	c7 05 1c e1 81 00 00 	movl   $0x700,0x81e11c
  8014cf:	07 00 00 

	return cnt;
  8014d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014d5:	c9                   	leave  
  8014d6:	c3                   	ret    

008014d7 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
  8014da:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8014dd:	e8 e7 1d 00 00       	call   8032c9 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8014e2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8014e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8014e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014eb:	83 ec 08             	sub    $0x8,%esp
  8014ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8014f1:	50                   	push   %eax
  8014f2:	e8 ff fe ff ff       	call   8013f6 <vcprintf>
  8014f7:	83 c4 10             	add    $0x10,%esp
  8014fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8014fd:	e8 e1 1d 00 00       	call   8032e3 <sys_unlock_cons>
	return cnt;
  801502:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801505:	c9                   	leave  
  801506:	c3                   	ret    

00801507 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
  80150a:	53                   	push   %ebx
  80150b:	83 ec 14             	sub    $0x14,%esp
  80150e:	8b 45 10             	mov    0x10(%ebp),%eax
  801511:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801514:	8b 45 14             	mov    0x14(%ebp),%eax
  801517:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80151a:	8b 45 18             	mov    0x18(%ebp),%eax
  80151d:	ba 00 00 00 00       	mov    $0x0,%edx
  801522:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801525:	77 55                	ja     80157c <printnum+0x75>
  801527:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80152a:	72 05                	jb     801531 <printnum+0x2a>
  80152c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80152f:	77 4b                	ja     80157c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801531:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801534:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801537:	8b 45 18             	mov    0x18(%ebp),%eax
  80153a:	ba 00 00 00 00       	mov    $0x0,%edx
  80153f:	52                   	push   %edx
  801540:	50                   	push   %eax
  801541:	ff 75 f4             	pushl  -0xc(%ebp)
  801544:	ff 75 f0             	pushl  -0x10(%ebp)
  801547:	e8 0c 31 00 00       	call   804658 <__udivdi3>
  80154c:	83 c4 10             	add    $0x10,%esp
  80154f:	83 ec 04             	sub    $0x4,%esp
  801552:	ff 75 20             	pushl  0x20(%ebp)
  801555:	53                   	push   %ebx
  801556:	ff 75 18             	pushl  0x18(%ebp)
  801559:	52                   	push   %edx
  80155a:	50                   	push   %eax
  80155b:	ff 75 0c             	pushl  0xc(%ebp)
  80155e:	ff 75 08             	pushl  0x8(%ebp)
  801561:	e8 a1 ff ff ff       	call   801507 <printnum>
  801566:	83 c4 20             	add    $0x20,%esp
  801569:	eb 1a                	jmp    801585 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80156b:	83 ec 08             	sub    $0x8,%esp
  80156e:	ff 75 0c             	pushl  0xc(%ebp)
  801571:	ff 75 20             	pushl  0x20(%ebp)
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	ff d0                	call   *%eax
  801579:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80157c:	ff 4d 1c             	decl   0x1c(%ebp)
  80157f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801583:	7f e6                	jg     80156b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801585:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801588:	bb 00 00 00 00       	mov    $0x0,%ebx
  80158d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801590:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801593:	53                   	push   %ebx
  801594:	51                   	push   %ecx
  801595:	52                   	push   %edx
  801596:	50                   	push   %eax
  801597:	e8 cc 31 00 00       	call   804768 <__umoddi3>
  80159c:	83 c4 10             	add    $0x10,%esp
  80159f:	05 54 54 80 00       	add    $0x805454,%eax
  8015a4:	8a 00                	mov    (%eax),%al
  8015a6:	0f be c0             	movsbl %al,%eax
  8015a9:	83 ec 08             	sub    $0x8,%esp
  8015ac:	ff 75 0c             	pushl  0xc(%ebp)
  8015af:	50                   	push   %eax
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	ff d0                	call   *%eax
  8015b5:	83 c4 10             	add    $0x10,%esp
}
  8015b8:	90                   	nop
  8015b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8015c1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8015c5:	7e 1c                	jle    8015e3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8015c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ca:	8b 00                	mov    (%eax),%eax
  8015cc:	8d 50 08             	lea    0x8(%eax),%edx
  8015cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d2:	89 10                	mov    %edx,(%eax)
  8015d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d7:	8b 00                	mov    (%eax),%eax
  8015d9:	83 e8 08             	sub    $0x8,%eax
  8015dc:	8b 50 04             	mov    0x4(%eax),%edx
  8015df:	8b 00                	mov    (%eax),%eax
  8015e1:	eb 40                	jmp    801623 <getuint+0x65>
	else if (lflag)
  8015e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015e7:	74 1e                	je     801607 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	8b 00                	mov    (%eax),%eax
  8015ee:	8d 50 04             	lea    0x4(%eax),%edx
  8015f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f4:	89 10                	mov    %edx,(%eax)
  8015f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f9:	8b 00                	mov    (%eax),%eax
  8015fb:	83 e8 04             	sub    $0x4,%eax
  8015fe:	8b 00                	mov    (%eax),%eax
  801600:	ba 00 00 00 00       	mov    $0x0,%edx
  801605:	eb 1c                	jmp    801623 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	8b 00                	mov    (%eax),%eax
  80160c:	8d 50 04             	lea    0x4(%eax),%edx
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
  801612:	89 10                	mov    %edx,(%eax)
  801614:	8b 45 08             	mov    0x8(%ebp),%eax
  801617:	8b 00                	mov    (%eax),%eax
  801619:	83 e8 04             	sub    $0x4,%eax
  80161c:	8b 00                	mov    (%eax),%eax
  80161e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801623:	5d                   	pop    %ebp
  801624:	c3                   	ret    

00801625 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801628:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80162c:	7e 1c                	jle    80164a <getint+0x25>
		return va_arg(*ap, long long);
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
  801631:	8b 00                	mov    (%eax),%eax
  801633:	8d 50 08             	lea    0x8(%eax),%edx
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	89 10                	mov    %edx,(%eax)
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	8b 00                	mov    (%eax),%eax
  801640:	83 e8 08             	sub    $0x8,%eax
  801643:	8b 50 04             	mov    0x4(%eax),%edx
  801646:	8b 00                	mov    (%eax),%eax
  801648:	eb 38                	jmp    801682 <getint+0x5d>
	else if (lflag)
  80164a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80164e:	74 1a                	je     80166a <getint+0x45>
		return va_arg(*ap, long);
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	8b 00                	mov    (%eax),%eax
  801655:	8d 50 04             	lea    0x4(%eax),%edx
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	89 10                	mov    %edx,(%eax)
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	8b 00                	mov    (%eax),%eax
  801662:	83 e8 04             	sub    $0x4,%eax
  801665:	8b 00                	mov    (%eax),%eax
  801667:	99                   	cltd   
  801668:	eb 18                	jmp    801682 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	8b 00                	mov    (%eax),%eax
  80166f:	8d 50 04             	lea    0x4(%eax),%edx
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	89 10                	mov    %edx,(%eax)
  801677:	8b 45 08             	mov    0x8(%ebp),%eax
  80167a:	8b 00                	mov    (%eax),%eax
  80167c:	83 e8 04             	sub    $0x4,%eax
  80167f:	8b 00                	mov    (%eax),%eax
  801681:	99                   	cltd   
}
  801682:	5d                   	pop    %ebp
  801683:	c3                   	ret    

00801684 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	56                   	push   %esi
  801688:	53                   	push   %ebx
  801689:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80168c:	eb 17                	jmp    8016a5 <vprintfmt+0x21>
			if (ch == '\0')
  80168e:	85 db                	test   %ebx,%ebx
  801690:	0f 84 c1 03 00 00    	je     801a57 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801696:	83 ec 08             	sub    $0x8,%esp
  801699:	ff 75 0c             	pushl  0xc(%ebp)
  80169c:	53                   	push   %ebx
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	ff d0                	call   *%eax
  8016a2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8016a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a8:	8d 50 01             	lea    0x1(%eax),%edx
  8016ab:	89 55 10             	mov    %edx,0x10(%ebp)
  8016ae:	8a 00                	mov    (%eax),%al
  8016b0:	0f b6 d8             	movzbl %al,%ebx
  8016b3:	83 fb 25             	cmp    $0x25,%ebx
  8016b6:	75 d6                	jne    80168e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8016b8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8016bc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8016c3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8016ca:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8016d1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8016d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016db:	8d 50 01             	lea    0x1(%eax),%edx
  8016de:	89 55 10             	mov    %edx,0x10(%ebp)
  8016e1:	8a 00                	mov    (%eax),%al
  8016e3:	0f b6 d8             	movzbl %al,%ebx
  8016e6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8016e9:	83 f8 5b             	cmp    $0x5b,%eax
  8016ec:	0f 87 3d 03 00 00    	ja     801a2f <vprintfmt+0x3ab>
  8016f2:	8b 04 85 78 54 80 00 	mov    0x805478(,%eax,4),%eax
  8016f9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8016fb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8016ff:	eb d7                	jmp    8016d8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801701:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801705:	eb d1                	jmp    8016d8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801707:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80170e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801711:	89 d0                	mov    %edx,%eax
  801713:	c1 e0 02             	shl    $0x2,%eax
  801716:	01 d0                	add    %edx,%eax
  801718:	01 c0                	add    %eax,%eax
  80171a:	01 d8                	add    %ebx,%eax
  80171c:	83 e8 30             	sub    $0x30,%eax
  80171f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801722:	8b 45 10             	mov    0x10(%ebp),%eax
  801725:	8a 00                	mov    (%eax),%al
  801727:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80172a:	83 fb 2f             	cmp    $0x2f,%ebx
  80172d:	7e 3e                	jle    80176d <vprintfmt+0xe9>
  80172f:	83 fb 39             	cmp    $0x39,%ebx
  801732:	7f 39                	jg     80176d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801734:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801737:	eb d5                	jmp    80170e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801739:	8b 45 14             	mov    0x14(%ebp),%eax
  80173c:	83 c0 04             	add    $0x4,%eax
  80173f:	89 45 14             	mov    %eax,0x14(%ebp)
  801742:	8b 45 14             	mov    0x14(%ebp),%eax
  801745:	83 e8 04             	sub    $0x4,%eax
  801748:	8b 00                	mov    (%eax),%eax
  80174a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80174d:	eb 1f                	jmp    80176e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80174f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801753:	79 83                	jns    8016d8 <vprintfmt+0x54>
				width = 0;
  801755:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80175c:	e9 77 ff ff ff       	jmp    8016d8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801761:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801768:	e9 6b ff ff ff       	jmp    8016d8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80176d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80176e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801772:	0f 89 60 ff ff ff    	jns    8016d8 <vprintfmt+0x54>
				width = precision, precision = -1;
  801778:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80177b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80177e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801785:	e9 4e ff ff ff       	jmp    8016d8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80178a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80178d:	e9 46 ff ff ff       	jmp    8016d8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801792:	8b 45 14             	mov    0x14(%ebp),%eax
  801795:	83 c0 04             	add    $0x4,%eax
  801798:	89 45 14             	mov    %eax,0x14(%ebp)
  80179b:	8b 45 14             	mov    0x14(%ebp),%eax
  80179e:	83 e8 04             	sub    $0x4,%eax
  8017a1:	8b 00                	mov    (%eax),%eax
  8017a3:	83 ec 08             	sub    $0x8,%esp
  8017a6:	ff 75 0c             	pushl  0xc(%ebp)
  8017a9:	50                   	push   %eax
  8017aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ad:	ff d0                	call   *%eax
  8017af:	83 c4 10             	add    $0x10,%esp
			break;
  8017b2:	e9 9b 02 00 00       	jmp    801a52 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8017b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ba:	83 c0 04             	add    $0x4,%eax
  8017bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8017c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c3:	83 e8 04             	sub    $0x4,%eax
  8017c6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8017c8:	85 db                	test   %ebx,%ebx
  8017ca:	79 02                	jns    8017ce <vprintfmt+0x14a>
				err = -err;
  8017cc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8017ce:	83 fb 64             	cmp    $0x64,%ebx
  8017d1:	7f 0b                	jg     8017de <vprintfmt+0x15a>
  8017d3:	8b 34 9d c0 52 80 00 	mov    0x8052c0(,%ebx,4),%esi
  8017da:	85 f6                	test   %esi,%esi
  8017dc:	75 19                	jne    8017f7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8017de:	53                   	push   %ebx
  8017df:	68 65 54 80 00       	push   $0x805465
  8017e4:	ff 75 0c             	pushl  0xc(%ebp)
  8017e7:	ff 75 08             	pushl  0x8(%ebp)
  8017ea:	e8 70 02 00 00       	call   801a5f <printfmt>
  8017ef:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8017f2:	e9 5b 02 00 00       	jmp    801a52 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8017f7:	56                   	push   %esi
  8017f8:	68 6e 54 80 00       	push   $0x80546e
  8017fd:	ff 75 0c             	pushl  0xc(%ebp)
  801800:	ff 75 08             	pushl  0x8(%ebp)
  801803:	e8 57 02 00 00       	call   801a5f <printfmt>
  801808:	83 c4 10             	add    $0x10,%esp
			break;
  80180b:	e9 42 02 00 00       	jmp    801a52 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801810:	8b 45 14             	mov    0x14(%ebp),%eax
  801813:	83 c0 04             	add    $0x4,%eax
  801816:	89 45 14             	mov    %eax,0x14(%ebp)
  801819:	8b 45 14             	mov    0x14(%ebp),%eax
  80181c:	83 e8 04             	sub    $0x4,%eax
  80181f:	8b 30                	mov    (%eax),%esi
  801821:	85 f6                	test   %esi,%esi
  801823:	75 05                	jne    80182a <vprintfmt+0x1a6>
				p = "(null)";
  801825:	be 71 54 80 00       	mov    $0x805471,%esi
			if (width > 0 && padc != '-')
  80182a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80182e:	7e 6d                	jle    80189d <vprintfmt+0x219>
  801830:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801834:	74 67                	je     80189d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801836:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801839:	83 ec 08             	sub    $0x8,%esp
  80183c:	50                   	push   %eax
  80183d:	56                   	push   %esi
  80183e:	e8 26 05 00 00       	call   801d69 <strnlen>
  801843:	83 c4 10             	add    $0x10,%esp
  801846:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801849:	eb 16                	jmp    801861 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80184b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80184f:	83 ec 08             	sub    $0x8,%esp
  801852:	ff 75 0c             	pushl  0xc(%ebp)
  801855:	50                   	push   %eax
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	ff d0                	call   *%eax
  80185b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80185e:	ff 4d e4             	decl   -0x1c(%ebp)
  801861:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801865:	7f e4                	jg     80184b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801867:	eb 34                	jmp    80189d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801869:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80186d:	74 1c                	je     80188b <vprintfmt+0x207>
  80186f:	83 fb 1f             	cmp    $0x1f,%ebx
  801872:	7e 05                	jle    801879 <vprintfmt+0x1f5>
  801874:	83 fb 7e             	cmp    $0x7e,%ebx
  801877:	7e 12                	jle    80188b <vprintfmt+0x207>
					putch('?', putdat);
  801879:	83 ec 08             	sub    $0x8,%esp
  80187c:	ff 75 0c             	pushl  0xc(%ebp)
  80187f:	6a 3f                	push   $0x3f
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	ff d0                	call   *%eax
  801886:	83 c4 10             	add    $0x10,%esp
  801889:	eb 0f                	jmp    80189a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80188b:	83 ec 08             	sub    $0x8,%esp
  80188e:	ff 75 0c             	pushl  0xc(%ebp)
  801891:	53                   	push   %ebx
  801892:	8b 45 08             	mov    0x8(%ebp),%eax
  801895:	ff d0                	call   *%eax
  801897:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80189a:	ff 4d e4             	decl   -0x1c(%ebp)
  80189d:	89 f0                	mov    %esi,%eax
  80189f:	8d 70 01             	lea    0x1(%eax),%esi
  8018a2:	8a 00                	mov    (%eax),%al
  8018a4:	0f be d8             	movsbl %al,%ebx
  8018a7:	85 db                	test   %ebx,%ebx
  8018a9:	74 24                	je     8018cf <vprintfmt+0x24b>
  8018ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018af:	78 b8                	js     801869 <vprintfmt+0x1e5>
  8018b1:	ff 4d e0             	decl   -0x20(%ebp)
  8018b4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018b8:	79 af                	jns    801869 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8018ba:	eb 13                	jmp    8018cf <vprintfmt+0x24b>
				putch(' ', putdat);
  8018bc:	83 ec 08             	sub    $0x8,%esp
  8018bf:	ff 75 0c             	pushl  0xc(%ebp)
  8018c2:	6a 20                	push   $0x20
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	ff d0                	call   *%eax
  8018c9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8018cc:	ff 4d e4             	decl   -0x1c(%ebp)
  8018cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018d3:	7f e7                	jg     8018bc <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8018d5:	e9 78 01 00 00       	jmp    801a52 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8018da:	83 ec 08             	sub    $0x8,%esp
  8018dd:	ff 75 e8             	pushl  -0x18(%ebp)
  8018e0:	8d 45 14             	lea    0x14(%ebp),%eax
  8018e3:	50                   	push   %eax
  8018e4:	e8 3c fd ff ff       	call   801625 <getint>
  8018e9:	83 c4 10             	add    $0x10,%esp
  8018ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8018f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018f8:	85 d2                	test   %edx,%edx
  8018fa:	79 23                	jns    80191f <vprintfmt+0x29b>
				putch('-', putdat);
  8018fc:	83 ec 08             	sub    $0x8,%esp
  8018ff:	ff 75 0c             	pushl  0xc(%ebp)
  801902:	6a 2d                	push   $0x2d
  801904:	8b 45 08             	mov    0x8(%ebp),%eax
  801907:	ff d0                	call   *%eax
  801909:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80190c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80190f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801912:	f7 d8                	neg    %eax
  801914:	83 d2 00             	adc    $0x0,%edx
  801917:	f7 da                	neg    %edx
  801919:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80191c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80191f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801926:	e9 bc 00 00 00       	jmp    8019e7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80192b:	83 ec 08             	sub    $0x8,%esp
  80192e:	ff 75 e8             	pushl  -0x18(%ebp)
  801931:	8d 45 14             	lea    0x14(%ebp),%eax
  801934:	50                   	push   %eax
  801935:	e8 84 fc ff ff       	call   8015be <getuint>
  80193a:	83 c4 10             	add    $0x10,%esp
  80193d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801940:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801943:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80194a:	e9 98 00 00 00       	jmp    8019e7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80194f:	83 ec 08             	sub    $0x8,%esp
  801952:	ff 75 0c             	pushl  0xc(%ebp)
  801955:	6a 58                	push   $0x58
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	ff d0                	call   *%eax
  80195c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80195f:	83 ec 08             	sub    $0x8,%esp
  801962:	ff 75 0c             	pushl  0xc(%ebp)
  801965:	6a 58                	push   $0x58
  801967:	8b 45 08             	mov    0x8(%ebp),%eax
  80196a:	ff d0                	call   *%eax
  80196c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80196f:	83 ec 08             	sub    $0x8,%esp
  801972:	ff 75 0c             	pushl  0xc(%ebp)
  801975:	6a 58                	push   $0x58
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
  80197a:	ff d0                	call   *%eax
  80197c:	83 c4 10             	add    $0x10,%esp
			break;
  80197f:	e9 ce 00 00 00       	jmp    801a52 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801984:	83 ec 08             	sub    $0x8,%esp
  801987:	ff 75 0c             	pushl  0xc(%ebp)
  80198a:	6a 30                	push   $0x30
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	ff d0                	call   *%eax
  801991:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801994:	83 ec 08             	sub    $0x8,%esp
  801997:	ff 75 0c             	pushl  0xc(%ebp)
  80199a:	6a 78                	push   $0x78
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	ff d0                	call   *%eax
  8019a1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8019a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a7:	83 c0 04             	add    $0x4,%eax
  8019aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8019ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b0:	83 e8 04             	sub    $0x4,%eax
  8019b3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8019b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8019bf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8019c6:	eb 1f                	jmp    8019e7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8019c8:	83 ec 08             	sub    $0x8,%esp
  8019cb:	ff 75 e8             	pushl  -0x18(%ebp)
  8019ce:	8d 45 14             	lea    0x14(%ebp),%eax
  8019d1:	50                   	push   %eax
  8019d2:	e8 e7 fb ff ff       	call   8015be <getuint>
  8019d7:	83 c4 10             	add    $0x10,%esp
  8019da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019dd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8019e0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8019e7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8019eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ee:	83 ec 04             	sub    $0x4,%esp
  8019f1:	52                   	push   %edx
  8019f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019f5:	50                   	push   %eax
  8019f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8019f9:	ff 75 f0             	pushl  -0x10(%ebp)
  8019fc:	ff 75 0c             	pushl  0xc(%ebp)
  8019ff:	ff 75 08             	pushl  0x8(%ebp)
  801a02:	e8 00 fb ff ff       	call   801507 <printnum>
  801a07:	83 c4 20             	add    $0x20,%esp
			break;
  801a0a:	eb 46                	jmp    801a52 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801a0c:	83 ec 08             	sub    $0x8,%esp
  801a0f:	ff 75 0c             	pushl  0xc(%ebp)
  801a12:	53                   	push   %ebx
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	ff d0                	call   *%eax
  801a18:	83 c4 10             	add    $0x10,%esp
			break;
  801a1b:	eb 35                	jmp    801a52 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801a1d:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
			break;
  801a24:	eb 2c                	jmp    801a52 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801a26:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
			break;
  801a2d:	eb 23                	jmp    801a52 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801a2f:	83 ec 08             	sub    $0x8,%esp
  801a32:	ff 75 0c             	pushl  0xc(%ebp)
  801a35:	6a 25                	push   $0x25
  801a37:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3a:	ff d0                	call   *%eax
  801a3c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801a3f:	ff 4d 10             	decl   0x10(%ebp)
  801a42:	eb 03                	jmp    801a47 <vprintfmt+0x3c3>
  801a44:	ff 4d 10             	decl   0x10(%ebp)
  801a47:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4a:	48                   	dec    %eax
  801a4b:	8a 00                	mov    (%eax),%al
  801a4d:	3c 25                	cmp    $0x25,%al
  801a4f:	75 f3                	jne    801a44 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801a51:	90                   	nop
		}
	}
  801a52:	e9 35 fc ff ff       	jmp    80168c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801a57:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801a58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a5b:	5b                   	pop    %ebx
  801a5c:	5e                   	pop    %esi
  801a5d:	5d                   	pop    %ebp
  801a5e:	c3                   	ret    

00801a5f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801a65:	8d 45 10             	lea    0x10(%ebp),%eax
  801a68:	83 c0 04             	add    $0x4,%eax
  801a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801a6e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a71:	ff 75 f4             	pushl  -0xc(%ebp)
  801a74:	50                   	push   %eax
  801a75:	ff 75 0c             	pushl  0xc(%ebp)
  801a78:	ff 75 08             	pushl  0x8(%ebp)
  801a7b:	e8 04 fc ff ff       	call   801684 <vprintfmt>
  801a80:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801a83:	90                   	nop
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801a89:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a8c:	8b 40 08             	mov    0x8(%eax),%eax
  801a8f:	8d 50 01             	lea    0x1(%eax),%edx
  801a92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a95:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801a98:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a9b:	8b 10                	mov    (%eax),%edx
  801a9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa0:	8b 40 04             	mov    0x4(%eax),%eax
  801aa3:	39 c2                	cmp    %eax,%edx
  801aa5:	73 12                	jae    801ab9 <sprintputch+0x33>
		*b->buf++ = ch;
  801aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aaa:	8b 00                	mov    (%eax),%eax
  801aac:	8d 48 01             	lea    0x1(%eax),%ecx
  801aaf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab2:	89 0a                	mov    %ecx,(%edx)
  801ab4:	8b 55 08             	mov    0x8(%ebp),%edx
  801ab7:	88 10                	mov    %dl,(%eax)
}
  801ab9:	90                   	nop
  801aba:	5d                   	pop    %ebp
  801abb:	c3                   	ret    

00801abc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ac8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801acb:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ace:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad1:	01 d0                	add    %edx,%eax
  801ad3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ad6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801add:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ae1:	74 06                	je     801ae9 <vsnprintf+0x2d>
  801ae3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ae7:	7f 07                	jg     801af0 <vsnprintf+0x34>
		return -E_INVAL;
  801ae9:	b8 03 00 00 00       	mov    $0x3,%eax
  801aee:	eb 20                	jmp    801b10 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801af0:	ff 75 14             	pushl  0x14(%ebp)
  801af3:	ff 75 10             	pushl  0x10(%ebp)
  801af6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801af9:	50                   	push   %eax
  801afa:	68 86 1a 80 00       	push   $0x801a86
  801aff:	e8 80 fb ff ff       	call   801684 <vprintfmt>
  801b04:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801b07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b0a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
  801b15:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b18:	8d 45 10             	lea    0x10(%ebp),%eax
  801b1b:	83 c0 04             	add    $0x4,%eax
  801b1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801b21:	8b 45 10             	mov    0x10(%ebp),%eax
  801b24:	ff 75 f4             	pushl  -0xc(%ebp)
  801b27:	50                   	push   %eax
  801b28:	ff 75 0c             	pushl  0xc(%ebp)
  801b2b:	ff 75 08             	pushl  0x8(%ebp)
  801b2e:	e8 89 ff ff ff       	call   801abc <vsnprintf>
  801b33:	83 c4 10             	add    $0x10,%esp
  801b36:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801b44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b48:	74 13                	je     801b5d <readline+0x1f>
		cprintf("%s", prompt);
  801b4a:	83 ec 08             	sub    $0x8,%esp
  801b4d:	ff 75 08             	pushl  0x8(%ebp)
  801b50:	68 e8 55 80 00       	push   $0x8055e8
  801b55:	e8 0b f9 ff ff       	call   801465 <cprintf>
  801b5a:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801b5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801b64:	83 ec 0c             	sub    $0xc,%esp
  801b67:	6a 00                	push   $0x0
  801b69:	e8 4f f4 ff ff       	call   800fbd <iscons>
  801b6e:	83 c4 10             	add    $0x10,%esp
  801b71:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801b74:	e8 31 f4 ff ff       	call   800faa <getchar>
  801b79:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801b7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b80:	79 22                	jns    801ba4 <readline+0x66>
			if (c != -E_EOF)
  801b82:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801b86:	0f 84 ad 00 00 00    	je     801c39 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801b8c:	83 ec 08             	sub    $0x8,%esp
  801b8f:	ff 75 ec             	pushl  -0x14(%ebp)
  801b92:	68 eb 55 80 00       	push   $0x8055eb
  801b97:	e8 c9 f8 ff ff       	call   801465 <cprintf>
  801b9c:	83 c4 10             	add    $0x10,%esp
			break;
  801b9f:	e9 95 00 00 00       	jmp    801c39 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801ba4:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801ba8:	7e 34                	jle    801bde <readline+0xa0>
  801baa:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801bb1:	7f 2b                	jg     801bde <readline+0xa0>
			if (echoing)
  801bb3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bb7:	74 0e                	je     801bc7 <readline+0x89>
				cputchar(c);
  801bb9:	83 ec 0c             	sub    $0xc,%esp
  801bbc:	ff 75 ec             	pushl  -0x14(%ebp)
  801bbf:	e8 c7 f3 ff ff       	call   800f8b <cputchar>
  801bc4:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bca:	8d 50 01             	lea    0x1(%eax),%edx
  801bcd:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801bd0:	89 c2                	mov    %eax,%edx
  801bd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd5:	01 d0                	add    %edx,%eax
  801bd7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801bda:	88 10                	mov    %dl,(%eax)
  801bdc:	eb 56                	jmp    801c34 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801bde:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801be2:	75 1f                	jne    801c03 <readline+0xc5>
  801be4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801be8:	7e 19                	jle    801c03 <readline+0xc5>
			if (echoing)
  801bea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bee:	74 0e                	je     801bfe <readline+0xc0>
				cputchar(c);
  801bf0:	83 ec 0c             	sub    $0xc,%esp
  801bf3:	ff 75 ec             	pushl  -0x14(%ebp)
  801bf6:	e8 90 f3 ff ff       	call   800f8b <cputchar>
  801bfb:	83 c4 10             	add    $0x10,%esp

			i--;
  801bfe:	ff 4d f4             	decl   -0xc(%ebp)
  801c01:	eb 31                	jmp    801c34 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801c03:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801c07:	74 0a                	je     801c13 <readline+0xd5>
  801c09:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801c0d:	0f 85 61 ff ff ff    	jne    801b74 <readline+0x36>
			if (echoing)
  801c13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c17:	74 0e                	je     801c27 <readline+0xe9>
				cputchar(c);
  801c19:	83 ec 0c             	sub    $0xc,%esp
  801c1c:	ff 75 ec             	pushl  -0x14(%ebp)
  801c1f:	e8 67 f3 ff ff       	call   800f8b <cputchar>
  801c24:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801c27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2d:	01 d0                	add    %edx,%eax
  801c2f:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801c32:	eb 06                	jmp    801c3a <readline+0xfc>
		}
	}
  801c34:	e9 3b ff ff ff       	jmp    801b74 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801c39:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801c3a:	90                   	nop
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
  801c40:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801c43:	e8 81 16 00 00       	call   8032c9 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801c48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c4c:	74 13                	je     801c61 <atomic_readline+0x24>
			cprintf("%s", prompt);
  801c4e:	83 ec 08             	sub    $0x8,%esp
  801c51:	ff 75 08             	pushl  0x8(%ebp)
  801c54:	68 e8 55 80 00       	push   $0x8055e8
  801c59:	e8 07 f8 ff ff       	call   801465 <cprintf>
  801c5e:	83 c4 10             	add    $0x10,%esp

		i = 0;
  801c61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  801c68:	83 ec 0c             	sub    $0xc,%esp
  801c6b:	6a 00                	push   $0x0
  801c6d:	e8 4b f3 ff ff       	call   800fbd <iscons>
  801c72:	83 c4 10             	add    $0x10,%esp
  801c75:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801c78:	e8 2d f3 ff ff       	call   800faa <getchar>
  801c7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  801c80:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c84:	79 22                	jns    801ca8 <atomic_readline+0x6b>
				if (c != -E_EOF)
  801c86:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801c8a:	0f 84 ad 00 00 00    	je     801d3d <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801c90:	83 ec 08             	sub    $0x8,%esp
  801c93:	ff 75 ec             	pushl  -0x14(%ebp)
  801c96:	68 eb 55 80 00       	push   $0x8055eb
  801c9b:	e8 c5 f7 ff ff       	call   801465 <cprintf>
  801ca0:	83 c4 10             	add    $0x10,%esp
				break;
  801ca3:	e9 95 00 00 00       	jmp    801d3d <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801ca8:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801cac:	7e 34                	jle    801ce2 <atomic_readline+0xa5>
  801cae:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801cb5:	7f 2b                	jg     801ce2 <atomic_readline+0xa5>
				if (echoing)
  801cb7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cbb:	74 0e                	je     801ccb <atomic_readline+0x8e>
					cputchar(c);
  801cbd:	83 ec 0c             	sub    $0xc,%esp
  801cc0:	ff 75 ec             	pushl  -0x14(%ebp)
  801cc3:	e8 c3 f2 ff ff       	call   800f8b <cputchar>
  801cc8:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cce:	8d 50 01             	lea    0x1(%eax),%edx
  801cd1:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801cd4:	89 c2                	mov    %eax,%edx
  801cd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd9:	01 d0                	add    %edx,%eax
  801cdb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cde:	88 10                	mov    %dl,(%eax)
  801ce0:	eb 56                	jmp    801d38 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801ce2:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801ce6:	75 1f                	jne    801d07 <atomic_readline+0xca>
  801ce8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cec:	7e 19                	jle    801d07 <atomic_readline+0xca>
				if (echoing)
  801cee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cf2:	74 0e                	je     801d02 <atomic_readline+0xc5>
					cputchar(c);
  801cf4:	83 ec 0c             	sub    $0xc,%esp
  801cf7:	ff 75 ec             	pushl  -0x14(%ebp)
  801cfa:	e8 8c f2 ff ff       	call   800f8b <cputchar>
  801cff:	83 c4 10             	add    $0x10,%esp
				i--;
  801d02:	ff 4d f4             	decl   -0xc(%ebp)
  801d05:	eb 31                	jmp    801d38 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801d07:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801d0b:	74 0a                	je     801d17 <atomic_readline+0xda>
  801d0d:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801d11:	0f 85 61 ff ff ff    	jne    801c78 <atomic_readline+0x3b>
				if (echoing)
  801d17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d1b:	74 0e                	je     801d2b <atomic_readline+0xee>
					cputchar(c);
  801d1d:	83 ec 0c             	sub    $0xc,%esp
  801d20:	ff 75 ec             	pushl  -0x14(%ebp)
  801d23:	e8 63 f2 ff ff       	call   800f8b <cputchar>
  801d28:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801d2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d31:	01 d0                	add    %edx,%eax
  801d33:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801d36:	eb 06                	jmp    801d3e <atomic_readline+0x101>
			}
		}
  801d38:	e9 3b ff ff ff       	jmp    801c78 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801d3d:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801d3e:	e8 a0 15 00 00       	call   8032e3 <sys_unlock_cons>
}
  801d43:	90                   	nop
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
  801d49:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801d4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d53:	eb 06                	jmp    801d5b <strlen+0x15>
		n++;
  801d55:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801d58:	ff 45 08             	incl   0x8(%ebp)
  801d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5e:	8a 00                	mov    (%eax),%al
  801d60:	84 c0                	test   %al,%al
  801d62:	75 f1                	jne    801d55 <strlen+0xf>
		n++;
	return n;
  801d64:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
  801d6c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d76:	eb 09                	jmp    801d81 <strnlen+0x18>
		n++;
  801d78:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d7b:	ff 45 08             	incl   0x8(%ebp)
  801d7e:	ff 4d 0c             	decl   0xc(%ebp)
  801d81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d85:	74 09                	je     801d90 <strnlen+0x27>
  801d87:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8a:	8a 00                	mov    (%eax),%al
  801d8c:	84 c0                	test   %al,%al
  801d8e:	75 e8                	jne    801d78 <strnlen+0xf>
		n++;
	return n;
  801d90:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801da1:	90                   	nop
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	8d 50 01             	lea    0x1(%eax),%edx
  801da8:	89 55 08             	mov    %edx,0x8(%ebp)
  801dab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dae:	8d 4a 01             	lea    0x1(%edx),%ecx
  801db1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801db4:	8a 12                	mov    (%edx),%dl
  801db6:	88 10                	mov    %dl,(%eax)
  801db8:	8a 00                	mov    (%eax),%al
  801dba:	84 c0                	test   %al,%al
  801dbc:	75 e4                	jne    801da2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801dbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801dcf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801dd6:	eb 1f                	jmp    801df7 <strncpy+0x34>
		*dst++ = *src;
  801dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddb:	8d 50 01             	lea    0x1(%eax),%edx
  801dde:	89 55 08             	mov    %edx,0x8(%ebp)
  801de1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de4:	8a 12                	mov    (%edx),%dl
  801de6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801de8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801deb:	8a 00                	mov    (%eax),%al
  801ded:	84 c0                	test   %al,%al
  801def:	74 03                	je     801df4 <strncpy+0x31>
			src++;
  801df1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801df4:	ff 45 fc             	incl   -0x4(%ebp)
  801df7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dfa:	3b 45 10             	cmp    0x10(%ebp),%eax
  801dfd:	72 d9                	jb     801dd8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801dff:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
  801e07:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801e10:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e14:	74 30                	je     801e46 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801e16:	eb 16                	jmp    801e2e <strlcpy+0x2a>
			*dst++ = *src++;
  801e18:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1b:	8d 50 01             	lea    0x1(%eax),%edx
  801e1e:	89 55 08             	mov    %edx,0x8(%ebp)
  801e21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e24:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e27:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801e2a:	8a 12                	mov    (%edx),%dl
  801e2c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801e2e:	ff 4d 10             	decl   0x10(%ebp)
  801e31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e35:	74 09                	je     801e40 <strlcpy+0x3c>
  801e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e3a:	8a 00                	mov    (%eax),%al
  801e3c:	84 c0                	test   %al,%al
  801e3e:	75 d8                	jne    801e18 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801e40:	8b 45 08             	mov    0x8(%ebp),%eax
  801e43:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801e46:	8b 55 08             	mov    0x8(%ebp),%edx
  801e49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e4c:	29 c2                	sub    %eax,%edx
  801e4e:	89 d0                	mov    %edx,%eax
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801e55:	eb 06                	jmp    801e5d <strcmp+0xb>
		p++, q++;
  801e57:	ff 45 08             	incl   0x8(%ebp)
  801e5a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	8a 00                	mov    (%eax),%al
  801e62:	84 c0                	test   %al,%al
  801e64:	74 0e                	je     801e74 <strcmp+0x22>
  801e66:	8b 45 08             	mov    0x8(%ebp),%eax
  801e69:	8a 10                	mov    (%eax),%dl
  801e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e6e:	8a 00                	mov    (%eax),%al
  801e70:	38 c2                	cmp    %al,%dl
  801e72:	74 e3                	je     801e57 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801e74:	8b 45 08             	mov    0x8(%ebp),%eax
  801e77:	8a 00                	mov    (%eax),%al
  801e79:	0f b6 d0             	movzbl %al,%edx
  801e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e7f:	8a 00                	mov    (%eax),%al
  801e81:	0f b6 c0             	movzbl %al,%eax
  801e84:	29 c2                	sub    %eax,%edx
  801e86:	89 d0                	mov    %edx,%eax
}
  801e88:	5d                   	pop    %ebp
  801e89:	c3                   	ret    

00801e8a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801e8d:	eb 09                	jmp    801e98 <strncmp+0xe>
		n--, p++, q++;
  801e8f:	ff 4d 10             	decl   0x10(%ebp)
  801e92:	ff 45 08             	incl   0x8(%ebp)
  801e95:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801e98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e9c:	74 17                	je     801eb5 <strncmp+0x2b>
  801e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea1:	8a 00                	mov    (%eax),%al
  801ea3:	84 c0                	test   %al,%al
  801ea5:	74 0e                	je     801eb5 <strncmp+0x2b>
  801ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaa:	8a 10                	mov    (%eax),%dl
  801eac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eaf:	8a 00                	mov    (%eax),%al
  801eb1:	38 c2                	cmp    %al,%dl
  801eb3:	74 da                	je     801e8f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801eb5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801eb9:	75 07                	jne    801ec2 <strncmp+0x38>
		return 0;
  801ebb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec0:	eb 14                	jmp    801ed6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec5:	8a 00                	mov    (%eax),%al
  801ec7:	0f b6 d0             	movzbl %al,%edx
  801eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ecd:	8a 00                	mov    (%eax),%al
  801ecf:	0f b6 c0             	movzbl %al,%eax
  801ed2:	29 c2                	sub    %eax,%edx
  801ed4:	89 d0                	mov    %edx,%eax
}
  801ed6:	5d                   	pop    %ebp
  801ed7:	c3                   	ret    

00801ed8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
  801edb:	83 ec 04             	sub    $0x4,%esp
  801ede:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801ee4:	eb 12                	jmp    801ef8 <strchr+0x20>
		if (*s == c)
  801ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee9:	8a 00                	mov    (%eax),%al
  801eeb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801eee:	75 05                	jne    801ef5 <strchr+0x1d>
			return (char *) s;
  801ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef3:	eb 11                	jmp    801f06 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801ef5:	ff 45 08             	incl   0x8(%ebp)
  801ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  801efb:	8a 00                	mov    (%eax),%al
  801efd:	84 c0                	test   %al,%al
  801eff:	75 e5                	jne    801ee6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801f01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
  801f0b:	83 ec 04             	sub    $0x4,%esp
  801f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f11:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801f14:	eb 0d                	jmp    801f23 <strfind+0x1b>
		if (*s == c)
  801f16:	8b 45 08             	mov    0x8(%ebp),%eax
  801f19:	8a 00                	mov    (%eax),%al
  801f1b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801f1e:	74 0e                	je     801f2e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801f20:	ff 45 08             	incl   0x8(%ebp)
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	8a 00                	mov    (%eax),%al
  801f28:	84 c0                	test   %al,%al
  801f2a:	75 ea                	jne    801f16 <strfind+0xe>
  801f2c:	eb 01                	jmp    801f2f <strfind+0x27>
		if (*s == c)
			break;
  801f2e:	90                   	nop
	return (char *) s;
  801f2f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f32:	c9                   	leave  
  801f33:	c3                   	ret    

00801f34 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
  801f37:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801f40:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801f44:	76 63                	jbe    801fa9 <memset+0x75>
		uint64 data_block = c;
  801f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f49:	99                   	cltd   
  801f4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f4d:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f56:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801f5a:	c1 e0 08             	shl    $0x8,%eax
  801f5d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801f60:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f69:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801f6d:	c1 e0 10             	shl    $0x10,%eax
  801f70:	09 45 f0             	or     %eax,-0x10(%ebp)
  801f73:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801f76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f7c:	89 c2                	mov    %eax,%edx
  801f7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f83:	09 45 f0             	or     %eax,-0x10(%ebp)
  801f86:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801f89:	eb 18                	jmp    801fa3 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801f8b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801f8e:	8d 41 08             	lea    0x8(%ecx),%eax
  801f91:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f9a:	89 01                	mov    %eax,(%ecx)
  801f9c:	89 51 04             	mov    %edx,0x4(%ecx)
  801f9f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801fa3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801fa7:	77 e2                	ja     801f8b <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801fa9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fad:	74 23                	je     801fd2 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801faf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fb2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801fb5:	eb 0e                	jmp    801fc5 <memset+0x91>
			*p8++ = (uint8)c;
  801fb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fba:	8d 50 01             	lea    0x1(%eax),%edx
  801fbd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801fc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc3:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801fc5:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc8:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fcb:	89 55 10             	mov    %edx,0x10(%ebp)
  801fce:	85 c0                	test   %eax,%eax
  801fd0:	75 e5                	jne    801fb7 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801fd2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801fe9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801fed:	76 24                	jbe    802013 <memcpy+0x3c>
		while(n >= 8){
  801fef:	eb 1c                	jmp    80200d <memcpy+0x36>
			*d64 = *s64;
  801ff1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ff4:	8b 50 04             	mov    0x4(%eax),%edx
  801ff7:	8b 00                	mov    (%eax),%eax
  801ff9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801ffc:	89 01                	mov    %eax,(%ecx)
  801ffe:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  802001:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  802005:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  802009:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80200d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802011:	77 de                	ja     801ff1 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  802013:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802017:	74 31                	je     80204a <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  802019:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80201c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80201f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802022:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  802025:	eb 16                	jmp    80203d <memcpy+0x66>
			*d8++ = *s8++;
  802027:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80202a:	8d 50 01             	lea    0x1(%eax),%edx
  80202d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802030:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802033:	8d 4a 01             	lea    0x1(%edx),%ecx
  802036:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802039:	8a 12                	mov    (%edx),%dl
  80203b:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80203d:	8b 45 10             	mov    0x10(%ebp),%eax
  802040:	8d 50 ff             	lea    -0x1(%eax),%edx
  802043:	89 55 10             	mov    %edx,0x10(%ebp)
  802046:	85 c0                	test   %eax,%eax
  802048:	75 dd                	jne    802027 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80204d:	c9                   	leave  
  80204e:	c3                   	ret    

0080204f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
  802052:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802055:	8b 45 0c             	mov    0xc(%ebp),%eax
  802058:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80205b:	8b 45 08             	mov    0x8(%ebp),%eax
  80205e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802061:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802064:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802067:	73 50                	jae    8020b9 <memmove+0x6a>
  802069:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80206c:	8b 45 10             	mov    0x10(%ebp),%eax
  80206f:	01 d0                	add    %edx,%eax
  802071:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802074:	76 43                	jbe    8020b9 <memmove+0x6a>
		s += n;
  802076:	8b 45 10             	mov    0x10(%ebp),%eax
  802079:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80207c:	8b 45 10             	mov    0x10(%ebp),%eax
  80207f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802082:	eb 10                	jmp    802094 <memmove+0x45>
			*--d = *--s;
  802084:	ff 4d f8             	decl   -0x8(%ebp)
  802087:	ff 4d fc             	decl   -0x4(%ebp)
  80208a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80208d:	8a 10                	mov    (%eax),%dl
  80208f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802092:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  802094:	8b 45 10             	mov    0x10(%ebp),%eax
  802097:	8d 50 ff             	lea    -0x1(%eax),%edx
  80209a:	89 55 10             	mov    %edx,0x10(%ebp)
  80209d:	85 c0                	test   %eax,%eax
  80209f:	75 e3                	jne    802084 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8020a1:	eb 23                	jmp    8020c6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8020a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020a6:	8d 50 01             	lea    0x1(%eax),%edx
  8020a9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8020ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020af:	8d 4a 01             	lea    0x1(%edx),%ecx
  8020b2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8020b5:	8a 12                	mov    (%edx),%dl
  8020b7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8020b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8020bc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8020bf:	89 55 10             	mov    %edx,0x10(%ebp)
  8020c2:	85 c0                	test   %eax,%eax
  8020c4:	75 dd                	jne    8020a3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8020c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8020d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8020d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020da:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8020dd:	eb 2a                	jmp    802109 <memcmp+0x3e>
		if (*s1 != *s2)
  8020df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020e2:	8a 10                	mov    (%eax),%dl
  8020e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020e7:	8a 00                	mov    (%eax),%al
  8020e9:	38 c2                	cmp    %al,%dl
  8020eb:	74 16                	je     802103 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8020ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020f0:	8a 00                	mov    (%eax),%al
  8020f2:	0f b6 d0             	movzbl %al,%edx
  8020f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020f8:	8a 00                	mov    (%eax),%al
  8020fa:	0f b6 c0             	movzbl %al,%eax
  8020fd:	29 c2                	sub    %eax,%edx
  8020ff:	89 d0                	mov    %edx,%eax
  802101:	eb 18                	jmp    80211b <memcmp+0x50>
		s1++, s2++;
  802103:	ff 45 fc             	incl   -0x4(%ebp)
  802106:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802109:	8b 45 10             	mov    0x10(%ebp),%eax
  80210c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80210f:	89 55 10             	mov    %edx,0x10(%ebp)
  802112:	85 c0                	test   %eax,%eax
  802114:	75 c9                	jne    8020df <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802116:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80211b:	c9                   	leave  
  80211c:	c3                   	ret    

0080211d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
  802120:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802123:	8b 55 08             	mov    0x8(%ebp),%edx
  802126:	8b 45 10             	mov    0x10(%ebp),%eax
  802129:	01 d0                	add    %edx,%eax
  80212b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80212e:	eb 15                	jmp    802145 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
  802133:	8a 00                	mov    (%eax),%al
  802135:	0f b6 d0             	movzbl %al,%edx
  802138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213b:	0f b6 c0             	movzbl %al,%eax
  80213e:	39 c2                	cmp    %eax,%edx
  802140:	74 0d                	je     80214f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802142:	ff 45 08             	incl   0x8(%ebp)
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80214b:	72 e3                	jb     802130 <memfind+0x13>
  80214d:	eb 01                	jmp    802150 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80214f:	90                   	nop
	return (void *) s;
  802150:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
  802158:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80215b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802162:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802169:	eb 03                	jmp    80216e <strtol+0x19>
		s++;
  80216b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80216e:	8b 45 08             	mov    0x8(%ebp),%eax
  802171:	8a 00                	mov    (%eax),%al
  802173:	3c 20                	cmp    $0x20,%al
  802175:	74 f4                	je     80216b <strtol+0x16>
  802177:	8b 45 08             	mov    0x8(%ebp),%eax
  80217a:	8a 00                	mov    (%eax),%al
  80217c:	3c 09                	cmp    $0x9,%al
  80217e:	74 eb                	je     80216b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802180:	8b 45 08             	mov    0x8(%ebp),%eax
  802183:	8a 00                	mov    (%eax),%al
  802185:	3c 2b                	cmp    $0x2b,%al
  802187:	75 05                	jne    80218e <strtol+0x39>
		s++;
  802189:	ff 45 08             	incl   0x8(%ebp)
  80218c:	eb 13                	jmp    8021a1 <strtol+0x4c>
	else if (*s == '-')
  80218e:	8b 45 08             	mov    0x8(%ebp),%eax
  802191:	8a 00                	mov    (%eax),%al
  802193:	3c 2d                	cmp    $0x2d,%al
  802195:	75 0a                	jne    8021a1 <strtol+0x4c>
		s++, neg = 1;
  802197:	ff 45 08             	incl   0x8(%ebp)
  80219a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8021a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021a5:	74 06                	je     8021ad <strtol+0x58>
  8021a7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8021ab:	75 20                	jne    8021cd <strtol+0x78>
  8021ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b0:	8a 00                	mov    (%eax),%al
  8021b2:	3c 30                	cmp    $0x30,%al
  8021b4:	75 17                	jne    8021cd <strtol+0x78>
  8021b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b9:	40                   	inc    %eax
  8021ba:	8a 00                	mov    (%eax),%al
  8021bc:	3c 78                	cmp    $0x78,%al
  8021be:	75 0d                	jne    8021cd <strtol+0x78>
		s += 2, base = 16;
  8021c0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8021c4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8021cb:	eb 28                	jmp    8021f5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8021cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021d1:	75 15                	jne    8021e8 <strtol+0x93>
  8021d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d6:	8a 00                	mov    (%eax),%al
  8021d8:	3c 30                	cmp    $0x30,%al
  8021da:	75 0c                	jne    8021e8 <strtol+0x93>
		s++, base = 8;
  8021dc:	ff 45 08             	incl   0x8(%ebp)
  8021df:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8021e6:	eb 0d                	jmp    8021f5 <strtol+0xa0>
	else if (base == 0)
  8021e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021ec:	75 07                	jne    8021f5 <strtol+0xa0>
		base = 10;
  8021ee:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8021f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f8:	8a 00                	mov    (%eax),%al
  8021fa:	3c 2f                	cmp    $0x2f,%al
  8021fc:	7e 19                	jle    802217 <strtol+0xc2>
  8021fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802201:	8a 00                	mov    (%eax),%al
  802203:	3c 39                	cmp    $0x39,%al
  802205:	7f 10                	jg     802217 <strtol+0xc2>
			dig = *s - '0';
  802207:	8b 45 08             	mov    0x8(%ebp),%eax
  80220a:	8a 00                	mov    (%eax),%al
  80220c:	0f be c0             	movsbl %al,%eax
  80220f:	83 e8 30             	sub    $0x30,%eax
  802212:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802215:	eb 42                	jmp    802259 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802217:	8b 45 08             	mov    0x8(%ebp),%eax
  80221a:	8a 00                	mov    (%eax),%al
  80221c:	3c 60                	cmp    $0x60,%al
  80221e:	7e 19                	jle    802239 <strtol+0xe4>
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	8a 00                	mov    (%eax),%al
  802225:	3c 7a                	cmp    $0x7a,%al
  802227:	7f 10                	jg     802239 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802229:	8b 45 08             	mov    0x8(%ebp),%eax
  80222c:	8a 00                	mov    (%eax),%al
  80222e:	0f be c0             	movsbl %al,%eax
  802231:	83 e8 57             	sub    $0x57,%eax
  802234:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802237:	eb 20                	jmp    802259 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	8a 00                	mov    (%eax),%al
  80223e:	3c 40                	cmp    $0x40,%al
  802240:	7e 39                	jle    80227b <strtol+0x126>
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	8a 00                	mov    (%eax),%al
  802247:	3c 5a                	cmp    $0x5a,%al
  802249:	7f 30                	jg     80227b <strtol+0x126>
			dig = *s - 'A' + 10;
  80224b:	8b 45 08             	mov    0x8(%ebp),%eax
  80224e:	8a 00                	mov    (%eax),%al
  802250:	0f be c0             	movsbl %al,%eax
  802253:	83 e8 37             	sub    $0x37,%eax
  802256:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80225f:	7d 19                	jge    80227a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802261:	ff 45 08             	incl   0x8(%ebp)
  802264:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802267:	0f af 45 10          	imul   0x10(%ebp),%eax
  80226b:	89 c2                	mov    %eax,%edx
  80226d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802270:	01 d0                	add    %edx,%eax
  802272:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802275:	e9 7b ff ff ff       	jmp    8021f5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80227a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80227b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80227f:	74 08                	je     802289 <strtol+0x134>
		*endptr = (char *) s;
  802281:	8b 45 0c             	mov    0xc(%ebp),%eax
  802284:	8b 55 08             	mov    0x8(%ebp),%edx
  802287:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802289:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80228d:	74 07                	je     802296 <strtol+0x141>
  80228f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802292:	f7 d8                	neg    %eax
  802294:	eb 03                	jmp    802299 <strtol+0x144>
  802296:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802299:	c9                   	leave  
  80229a:	c3                   	ret    

0080229b <ltostr>:

void
ltostr(long value, char *str)
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
  80229e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8022a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8022a8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8022af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022b3:	79 13                	jns    8022c8 <ltostr+0x2d>
	{
		neg = 1;
  8022b5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8022bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022bf:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8022c2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8022c5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8022c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8022d0:	99                   	cltd   
  8022d1:	f7 f9                	idiv   %ecx
  8022d3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8022d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022d9:	8d 50 01             	lea    0x1(%eax),%edx
  8022dc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8022df:	89 c2                	mov    %eax,%edx
  8022e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e4:	01 d0                	add    %edx,%eax
  8022e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022e9:	83 c2 30             	add    $0x30,%edx
  8022ec:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8022ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022f1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8022f6:	f7 e9                	imul   %ecx
  8022f8:	c1 fa 02             	sar    $0x2,%edx
  8022fb:	89 c8                	mov    %ecx,%eax
  8022fd:	c1 f8 1f             	sar    $0x1f,%eax
  802300:	29 c2                	sub    %eax,%edx
  802302:	89 d0                	mov    %edx,%eax
  802304:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  802307:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80230b:	75 bb                	jne    8022c8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80230d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802314:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802317:	48                   	dec    %eax
  802318:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80231b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80231f:	74 3d                	je     80235e <ltostr+0xc3>
		start = 1 ;
  802321:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802328:	eb 34                	jmp    80235e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80232a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802330:	01 d0                	add    %edx,%eax
  802332:	8a 00                	mov    (%eax),%al
  802334:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802337:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80233a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80233d:	01 c2                	add    %eax,%edx
  80233f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802342:	8b 45 0c             	mov    0xc(%ebp),%eax
  802345:	01 c8                	add    %ecx,%eax
  802347:	8a 00                	mov    (%eax),%al
  802349:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80234b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80234e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802351:	01 c2                	add    %eax,%edx
  802353:	8a 45 eb             	mov    -0x15(%ebp),%al
  802356:	88 02                	mov    %al,(%edx)
		start++ ;
  802358:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80235b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802361:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802364:	7c c4                	jl     80232a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802366:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80236c:	01 d0                	add    %edx,%eax
  80236e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802371:	90                   	nop
  802372:	c9                   	leave  
  802373:	c3                   	ret    

00802374 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802374:	55                   	push   %ebp
  802375:	89 e5                	mov    %esp,%ebp
  802377:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80237a:	ff 75 08             	pushl  0x8(%ebp)
  80237d:	e8 c4 f9 ff ff       	call   801d46 <strlen>
  802382:	83 c4 04             	add    $0x4,%esp
  802385:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802388:	ff 75 0c             	pushl  0xc(%ebp)
  80238b:	e8 b6 f9 ff ff       	call   801d46 <strlen>
  802390:	83 c4 04             	add    $0x4,%esp
  802393:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802396:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80239d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8023a4:	eb 17                	jmp    8023bd <strcconcat+0x49>
		final[s] = str1[s] ;
  8023a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ac:	01 c2                	add    %eax,%edx
  8023ae:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	01 c8                	add    %ecx,%eax
  8023b6:	8a 00                	mov    (%eax),%al
  8023b8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8023ba:	ff 45 fc             	incl   -0x4(%ebp)
  8023bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023c0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8023c3:	7c e1                	jl     8023a6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8023c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8023cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8023d3:	eb 1f                	jmp    8023f4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8023d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023d8:	8d 50 01             	lea    0x1(%eax),%edx
  8023db:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8023de:	89 c2                	mov    %eax,%edx
  8023e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8023e3:	01 c2                	add    %eax,%edx
  8023e5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8023e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023eb:	01 c8                	add    %ecx,%eax
  8023ed:	8a 00                	mov    (%eax),%al
  8023ef:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8023f1:	ff 45 f8             	incl   -0x8(%ebp)
  8023f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8023fa:	7c d9                	jl     8023d5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8023fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023ff:	8b 45 10             	mov    0x10(%ebp),%eax
  802402:	01 d0                	add    %edx,%eax
  802404:	c6 00 00             	movb   $0x0,(%eax)
}
  802407:	90                   	nop
  802408:	c9                   	leave  
  802409:	c3                   	ret    

0080240a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80240a:	55                   	push   %ebp
  80240b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80240d:	8b 45 14             	mov    0x14(%ebp),%eax
  802410:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802416:	8b 45 14             	mov    0x14(%ebp),%eax
  802419:	8b 00                	mov    (%eax),%eax
  80241b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802422:	8b 45 10             	mov    0x10(%ebp),%eax
  802425:	01 d0                	add    %edx,%eax
  802427:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80242d:	eb 0c                	jmp    80243b <strsplit+0x31>
			*string++ = 0;
  80242f:	8b 45 08             	mov    0x8(%ebp),%eax
  802432:	8d 50 01             	lea    0x1(%eax),%edx
  802435:	89 55 08             	mov    %edx,0x8(%ebp)
  802438:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80243b:	8b 45 08             	mov    0x8(%ebp),%eax
  80243e:	8a 00                	mov    (%eax),%al
  802440:	84 c0                	test   %al,%al
  802442:	74 18                	je     80245c <strsplit+0x52>
  802444:	8b 45 08             	mov    0x8(%ebp),%eax
  802447:	8a 00                	mov    (%eax),%al
  802449:	0f be c0             	movsbl %al,%eax
  80244c:	50                   	push   %eax
  80244d:	ff 75 0c             	pushl  0xc(%ebp)
  802450:	e8 83 fa ff ff       	call   801ed8 <strchr>
  802455:	83 c4 08             	add    $0x8,%esp
  802458:	85 c0                	test   %eax,%eax
  80245a:	75 d3                	jne    80242f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80245c:	8b 45 08             	mov    0x8(%ebp),%eax
  80245f:	8a 00                	mov    (%eax),%al
  802461:	84 c0                	test   %al,%al
  802463:	74 5a                	je     8024bf <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802465:	8b 45 14             	mov    0x14(%ebp),%eax
  802468:	8b 00                	mov    (%eax),%eax
  80246a:	83 f8 0f             	cmp    $0xf,%eax
  80246d:	75 07                	jne    802476 <strsplit+0x6c>
		{
			return 0;
  80246f:	b8 00 00 00 00       	mov    $0x0,%eax
  802474:	eb 66                	jmp    8024dc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802476:	8b 45 14             	mov    0x14(%ebp),%eax
  802479:	8b 00                	mov    (%eax),%eax
  80247b:	8d 48 01             	lea    0x1(%eax),%ecx
  80247e:	8b 55 14             	mov    0x14(%ebp),%edx
  802481:	89 0a                	mov    %ecx,(%edx)
  802483:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80248a:	8b 45 10             	mov    0x10(%ebp),%eax
  80248d:	01 c2                	add    %eax,%edx
  80248f:	8b 45 08             	mov    0x8(%ebp),%eax
  802492:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802494:	eb 03                	jmp    802499 <strsplit+0x8f>
			string++;
  802496:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802499:	8b 45 08             	mov    0x8(%ebp),%eax
  80249c:	8a 00                	mov    (%eax),%al
  80249e:	84 c0                	test   %al,%al
  8024a0:	74 8b                	je     80242d <strsplit+0x23>
  8024a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a5:	8a 00                	mov    (%eax),%al
  8024a7:	0f be c0             	movsbl %al,%eax
  8024aa:	50                   	push   %eax
  8024ab:	ff 75 0c             	pushl  0xc(%ebp)
  8024ae:	e8 25 fa ff ff       	call   801ed8 <strchr>
  8024b3:	83 c4 08             	add    $0x8,%esp
  8024b6:	85 c0                	test   %eax,%eax
  8024b8:	74 dc                	je     802496 <strsplit+0x8c>
			string++;
	}
  8024ba:	e9 6e ff ff ff       	jmp    80242d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8024bf:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8024c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8024c3:	8b 00                	mov    (%eax),%eax
  8024c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8024cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8024cf:	01 d0                	add    %edx,%eax
  8024d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8024d7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8024dc:	c9                   	leave  
  8024dd:	c3                   	ret    

008024de <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8024de:	55                   	push   %ebp
  8024df:	89 e5                	mov    %esp,%ebp
  8024e1:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8024e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8024ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8024f1:	eb 4a                	jmp    80253d <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8024f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f9:	01 c2                	add    %eax,%edx
  8024fb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8024fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802501:	01 c8                	add    %ecx,%eax
  802503:	8a 00                	mov    (%eax),%al
  802505:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  802507:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80250a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80250d:	01 d0                	add    %edx,%eax
  80250f:	8a 00                	mov    (%eax),%al
  802511:	3c 40                	cmp    $0x40,%al
  802513:	7e 25                	jle    80253a <str2lower+0x5c>
  802515:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802518:	8b 45 0c             	mov    0xc(%ebp),%eax
  80251b:	01 d0                	add    %edx,%eax
  80251d:	8a 00                	mov    (%eax),%al
  80251f:	3c 5a                	cmp    $0x5a,%al
  802521:	7f 17                	jg     80253a <str2lower+0x5c>
		{
			dst[i] += 32 ;
  802523:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802526:	8b 45 08             	mov    0x8(%ebp),%eax
  802529:	01 d0                	add    %edx,%eax
  80252b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80252e:	8b 55 08             	mov    0x8(%ebp),%edx
  802531:	01 ca                	add    %ecx,%edx
  802533:	8a 12                	mov    (%edx),%dl
  802535:	83 c2 20             	add    $0x20,%edx
  802538:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80253a:	ff 45 fc             	incl   -0x4(%ebp)
  80253d:	ff 75 0c             	pushl  0xc(%ebp)
  802540:	e8 01 f8 ff ff       	call   801d46 <strlen>
  802545:	83 c4 04             	add    $0x4,%esp
  802548:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80254b:	7f a6                	jg     8024f3 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80254d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802550:	c9                   	leave  
  802551:	c3                   	ret    

00802552 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  802552:	55                   	push   %ebp
  802553:	89 e5                	mov    %esp,%ebp
  802555:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  802558:	83 ec 0c             	sub    $0xc,%esp
  80255b:	6a 10                	push   $0x10
  80255d:	e8 b2 15 00 00       	call   803b14 <alloc_block>
  802562:	83 c4 10             	add    $0x10,%esp
  802565:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  802568:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80256c:	75 14                	jne    802582 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  80256e:	83 ec 04             	sub    $0x4,%esp
  802571:	68 fc 55 80 00       	push   $0x8055fc
  802576:	6a 14                	push   $0x14
  802578:	68 25 56 80 00       	push   $0x805625
  80257d:	e8 f5 eb ff ff       	call   801177 <_panic>

	node->start = start;
  802582:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802585:	8b 55 08             	mov    0x8(%ebp),%edx
  802588:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  80258a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80258d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802590:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  802593:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  80259a:	a1 24 60 80 00       	mov    0x806024,%eax
  80259f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a2:	eb 18                	jmp    8025bc <insert_page_alloc+0x6a>
		if (start < it->start)
  8025a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a7:	8b 00                	mov    (%eax),%eax
  8025a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025ac:	77 37                	ja     8025e5 <insert_page_alloc+0x93>
			break;
		prev = it;
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  8025b4:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8025b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c0:	74 08                	je     8025ca <insert_page_alloc+0x78>
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	8b 40 08             	mov    0x8(%eax),%eax
  8025c8:	eb 05                	jmp    8025cf <insert_page_alloc+0x7d>
  8025ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cf:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8025d4:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8025d9:	85 c0                	test   %eax,%eax
  8025db:	75 c7                	jne    8025a4 <insert_page_alloc+0x52>
  8025dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e1:	75 c1                	jne    8025a4 <insert_page_alloc+0x52>
  8025e3:	eb 01                	jmp    8025e6 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  8025e5:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  8025e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025ea:	75 64                	jne    802650 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  8025ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025f0:	75 14                	jne    802606 <insert_page_alloc+0xb4>
  8025f2:	83 ec 04             	sub    $0x4,%esp
  8025f5:	68 34 56 80 00       	push   $0x805634
  8025fa:	6a 21                	push   $0x21
  8025fc:	68 25 56 80 00       	push   $0x805625
  802601:	e8 71 eb ff ff       	call   801177 <_panic>
  802606:	8b 15 24 60 80 00    	mov    0x806024,%edx
  80260c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80260f:	89 50 08             	mov    %edx,0x8(%eax)
  802612:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802615:	8b 40 08             	mov    0x8(%eax),%eax
  802618:	85 c0                	test   %eax,%eax
  80261a:	74 0d                	je     802629 <insert_page_alloc+0xd7>
  80261c:	a1 24 60 80 00       	mov    0x806024,%eax
  802621:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802624:	89 50 0c             	mov    %edx,0xc(%eax)
  802627:	eb 08                	jmp    802631 <insert_page_alloc+0xdf>
  802629:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262c:	a3 28 60 80 00       	mov    %eax,0x806028
  802631:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802634:	a3 24 60 80 00       	mov    %eax,0x806024
  802639:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802643:	a1 30 60 80 00       	mov    0x806030,%eax
  802648:	40                   	inc    %eax
  802649:	a3 30 60 80 00       	mov    %eax,0x806030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  80264e:	eb 71                	jmp    8026c1 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  802650:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802654:	74 06                	je     80265c <insert_page_alloc+0x10a>
  802656:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80265a:	75 14                	jne    802670 <insert_page_alloc+0x11e>
  80265c:	83 ec 04             	sub    $0x4,%esp
  80265f:	68 58 56 80 00       	push   $0x805658
  802664:	6a 23                	push   $0x23
  802666:	68 25 56 80 00       	push   $0x805625
  80266b:	e8 07 eb ff ff       	call   801177 <_panic>
  802670:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802673:	8b 50 08             	mov    0x8(%eax),%edx
  802676:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802679:	89 50 08             	mov    %edx,0x8(%eax)
  80267c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267f:	8b 40 08             	mov    0x8(%eax),%eax
  802682:	85 c0                	test   %eax,%eax
  802684:	74 0c                	je     802692 <insert_page_alloc+0x140>
  802686:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802689:	8b 40 08             	mov    0x8(%eax),%eax
  80268c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80268f:	89 50 0c             	mov    %edx,0xc(%eax)
  802692:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802695:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802698:	89 50 08             	mov    %edx,0x8(%eax)
  80269b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80269e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026a1:	89 50 0c             	mov    %edx,0xc(%eax)
  8026a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a7:	8b 40 08             	mov    0x8(%eax),%eax
  8026aa:	85 c0                	test   %eax,%eax
  8026ac:	75 08                	jne    8026b6 <insert_page_alloc+0x164>
  8026ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b1:	a3 28 60 80 00       	mov    %eax,0x806028
  8026b6:	a1 30 60 80 00       	mov    0x806030,%eax
  8026bb:	40                   	inc    %eax
  8026bc:	a3 30 60 80 00       	mov    %eax,0x806030
}
  8026c1:	90                   	nop
  8026c2:	c9                   	leave  
  8026c3:	c3                   	ret    

008026c4 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  8026c4:	55                   	push   %ebp
  8026c5:	89 e5                	mov    %esp,%ebp
  8026c7:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  8026ca:	a1 24 60 80 00       	mov    0x806024,%eax
  8026cf:	85 c0                	test   %eax,%eax
  8026d1:	75 0c                	jne    8026df <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  8026d3:	a1 10 e1 81 00       	mov    0x81e110,%eax
  8026d8:	a3 68 e0 81 00       	mov    %eax,0x81e068
		return;
  8026dd:	eb 67                	jmp    802746 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  8026df:	a1 10 e1 81 00       	mov    0x81e110,%eax
  8026e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8026e7:	a1 24 60 80 00       	mov    0x806024,%eax
  8026ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8026ef:	eb 26                	jmp    802717 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  8026f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026f4:	8b 10                	mov    (%eax),%edx
  8026f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026f9:	8b 40 04             	mov    0x4(%eax),%eax
  8026fc:	01 d0                	add    %edx,%eax
  8026fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  802701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802704:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802707:	76 06                	jbe    80270f <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80270f:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802714:	89 45 f8             	mov    %eax,-0x8(%ebp)
  802717:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80271b:	74 08                	je     802725 <recompute_page_alloc_break+0x61>
  80271d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802720:	8b 40 08             	mov    0x8(%eax),%eax
  802723:	eb 05                	jmp    80272a <recompute_page_alloc_break+0x66>
  802725:	b8 00 00 00 00       	mov    $0x0,%eax
  80272a:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80272f:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802734:	85 c0                	test   %eax,%eax
  802736:	75 b9                	jne    8026f1 <recompute_page_alloc_break+0x2d>
  802738:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80273c:	75 b3                	jne    8026f1 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  80273e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802741:	a3 68 e0 81 00       	mov    %eax,0x81e068
}
  802746:	c9                   	leave  
  802747:	c3                   	ret    

00802748 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  802748:	55                   	push   %ebp
  802749:	89 e5                	mov    %esp,%ebp
  80274b:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  80274e:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802755:	8b 55 08             	mov    0x8(%ebp),%edx
  802758:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80275b:	01 d0                	add    %edx,%eax
  80275d:	48                   	dec    %eax
  80275e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802761:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802764:	ba 00 00 00 00       	mov    $0x0,%edx
  802769:	f7 75 d8             	divl   -0x28(%ebp)
  80276c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80276f:	29 d0                	sub    %edx,%eax
  802771:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  802774:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802778:	75 0a                	jne    802784 <alloc_pages_custom_fit+0x3c>
		return NULL;
  80277a:	b8 00 00 00 00       	mov    $0x0,%eax
  80277f:	e9 7e 01 00 00       	jmp    802902 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  802784:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  80278b:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  80278f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  802796:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  80279d:	a1 10 e1 81 00       	mov    0x81e110,%eax
  8027a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  8027a5:	a1 24 60 80 00       	mov    0x806024,%eax
  8027aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8027ad:	eb 69                	jmp    802818 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  8027af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b2:	8b 00                	mov    (%eax),%eax
  8027b4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8027b7:	76 47                	jbe    802800 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  8027b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027bc:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  8027bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027c2:	8b 00                	mov    (%eax),%eax
  8027c4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8027c7:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  8027ca:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8027cd:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8027d0:	72 2e                	jb     802800 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  8027d2:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8027d6:	75 14                	jne    8027ec <alloc_pages_custom_fit+0xa4>
  8027d8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8027db:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8027de:	75 0c                	jne    8027ec <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  8027e0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  8027e6:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  8027ea:	eb 14                	jmp    802800 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  8027ec:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8027ef:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8027f2:	76 0c                	jbe    802800 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  8027f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  8027fa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8027fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  802800:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802803:	8b 10                	mov    (%eax),%edx
  802805:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802808:	8b 40 04             	mov    0x4(%eax),%eax
  80280b:	01 d0                	add    %edx,%eax
  80280d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  802810:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802815:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802818:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80281c:	74 08                	je     802826 <alloc_pages_custom_fit+0xde>
  80281e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802821:	8b 40 08             	mov    0x8(%eax),%eax
  802824:	eb 05                	jmp    80282b <alloc_pages_custom_fit+0xe3>
  802826:	b8 00 00 00 00       	mov    $0x0,%eax
  80282b:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802830:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802835:	85 c0                	test   %eax,%eax
  802837:	0f 85 72 ff ff ff    	jne    8027af <alloc_pages_custom_fit+0x67>
  80283d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802841:	0f 85 68 ff ff ff    	jne    8027af <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  802847:	a1 68 e0 81 00       	mov    0x81e068,%eax
  80284c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80284f:	76 47                	jbe    802898 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  802851:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802854:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  802857:	a1 68 e0 81 00       	mov    0x81e068,%eax
  80285c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80285f:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  802862:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802865:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802868:	72 2e                	jb     802898 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  80286a:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  80286e:	75 14                	jne    802884 <alloc_pages_custom_fit+0x13c>
  802870:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802873:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802876:	75 0c                	jne    802884 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  802878:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80287b:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  80287e:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  802882:	eb 14                	jmp    802898 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  802884:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802887:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80288a:	76 0c                	jbe    802898 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  80288c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80288f:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  802892:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802895:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  802898:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  80289f:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8028a3:	74 08                	je     8028ad <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  8028a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8028ab:	eb 40                	jmp    8028ed <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  8028ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028b1:	74 08                	je     8028bb <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  8028b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8028b9:	eb 32                	jmp    8028ed <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  8028bb:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8028c0:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8028c3:	89 c2                	mov    %eax,%edx
  8028c5:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8028ca:	39 c2                	cmp    %eax,%edx
  8028cc:	73 07                	jae    8028d5 <alloc_pages_custom_fit+0x18d>
			return NULL;
  8028ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d3:	eb 2d                	jmp    802902 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  8028d5:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8028da:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  8028dd:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  8028e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028e6:	01 d0                	add    %edx,%eax
  8028e8:	a3 68 e0 81 00       	mov    %eax,0x81e068
	}


	insert_page_alloc((uint32)result, required_size);
  8028ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028f0:	83 ec 08             	sub    $0x8,%esp
  8028f3:	ff 75 d0             	pushl  -0x30(%ebp)
  8028f6:	50                   	push   %eax
  8028f7:	e8 56 fc ff ff       	call   802552 <insert_page_alloc>
  8028fc:	83 c4 10             	add    $0x10,%esp

	return result;
  8028ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  802902:	c9                   	leave  
  802903:	c3                   	ret    

00802904 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  802904:	55                   	push   %ebp
  802905:	89 e5                	mov    %esp,%ebp
  802907:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  80290a:	8b 45 08             	mov    0x8(%ebp),%eax
  80290d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802910:	a1 24 60 80 00       	mov    0x806024,%eax
  802915:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802918:	eb 1a                	jmp    802934 <find_allocated_size+0x30>
		if (it->start == va)
  80291a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80291d:	8b 00                	mov    (%eax),%eax
  80291f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802922:	75 08                	jne    80292c <find_allocated_size+0x28>
			return it->size;
  802924:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802927:	8b 40 04             	mov    0x4(%eax),%eax
  80292a:	eb 34                	jmp    802960 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80292c:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802931:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802934:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802938:	74 08                	je     802942 <find_allocated_size+0x3e>
  80293a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80293d:	8b 40 08             	mov    0x8(%eax),%eax
  802940:	eb 05                	jmp    802947 <find_allocated_size+0x43>
  802942:	b8 00 00 00 00       	mov    $0x0,%eax
  802947:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80294c:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802951:	85 c0                	test   %eax,%eax
  802953:	75 c5                	jne    80291a <find_allocated_size+0x16>
  802955:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802959:	75 bf                	jne    80291a <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  80295b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802960:	c9                   	leave  
  802961:	c3                   	ret    

00802962 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  802962:	55                   	push   %ebp
  802963:	89 e5                	mov    %esp,%ebp
  802965:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  802968:	8b 45 08             	mov    0x8(%ebp),%eax
  80296b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  80296e:	a1 24 60 80 00       	mov    0x806024,%eax
  802973:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802976:	e9 e1 01 00 00       	jmp    802b5c <free_pages+0x1fa>
		if (it->start == va) {
  80297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297e:	8b 00                	mov    (%eax),%eax
  802980:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802983:	0f 85 cb 01 00 00    	jne    802b54 <free_pages+0x1f2>

			uint32 start = it->start;
  802989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298c:	8b 00                	mov    (%eax),%eax
  80298e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  802991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802994:	8b 40 04             	mov    0x4(%eax),%eax
  802997:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  80299a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80299d:	f7 d0                	not    %eax
  80299f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8029a2:	73 1d                	jae    8029c1 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  8029a4:	83 ec 0c             	sub    $0xc,%esp
  8029a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8029aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8029ad:	68 8c 56 80 00       	push   $0x80568c
  8029b2:	68 a5 00 00 00       	push   $0xa5
  8029b7:	68 25 56 80 00       	push   $0x805625
  8029bc:	e8 b6 e7 ff ff       	call   801177 <_panic>
			}

			uint32 start_end = start + size;
  8029c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029c7:	01 d0                	add    %edx,%eax
  8029c9:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  8029cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029cf:	85 c0                	test   %eax,%eax
  8029d1:	79 19                	jns    8029ec <free_pages+0x8a>
  8029d3:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8029da:	77 10                	ja     8029ec <free_pages+0x8a>
  8029dc:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  8029e3:	77 07                	ja     8029ec <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  8029e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029e8:	85 c0                	test   %eax,%eax
  8029ea:	78 2c                	js     802a18 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  8029ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ef:	83 ec 0c             	sub    $0xc,%esp
  8029f2:	68 00 00 00 a0       	push   $0xa0000000
  8029f7:	ff 75 e0             	pushl  -0x20(%ebp)
  8029fa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8029fd:	ff 75 e8             	pushl  -0x18(%ebp)
  802a00:	ff 75 e4             	pushl  -0x1c(%ebp)
  802a03:	50                   	push   %eax
  802a04:	68 d0 56 80 00       	push   $0x8056d0
  802a09:	68 ad 00 00 00       	push   $0xad
  802a0e:	68 25 56 80 00       	push   $0x805625
  802a13:	e8 5f e7 ff ff       	call   801177 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802a18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802a1e:	e9 88 00 00 00       	jmp    802aab <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  802a23:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  802a2a:	76 17                	jbe    802a43 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  802a2c:	ff 75 f0             	pushl  -0x10(%ebp)
  802a2f:	68 34 57 80 00       	push   $0x805734
  802a34:	68 b4 00 00 00       	push   $0xb4
  802a39:	68 25 56 80 00       	push   $0x805625
  802a3e:	e8 34 e7 ff ff       	call   801177 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  802a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a46:	05 00 10 00 00       	add    $0x1000,%eax
  802a4b:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  802a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a51:	85 c0                	test   %eax,%eax
  802a53:	79 2e                	jns    802a83 <free_pages+0x121>
  802a55:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  802a5c:	77 25                	ja     802a83 <free_pages+0x121>
  802a5e:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802a65:	77 1c                	ja     802a83 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  802a67:	83 ec 08             	sub    $0x8,%esp
  802a6a:	68 00 10 00 00       	push   $0x1000
  802a6f:	ff 75 f0             	pushl  -0x10(%ebp)
  802a72:	e8 38 0d 00 00       	call   8037af <sys_free_user_mem>
  802a77:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802a7a:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  802a81:	eb 28                	jmp    802aab <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  802a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a86:	68 00 00 00 a0       	push   $0xa0000000
  802a8b:	ff 75 dc             	pushl  -0x24(%ebp)
  802a8e:	68 00 10 00 00       	push   $0x1000
  802a93:	ff 75 f0             	pushl  -0x10(%ebp)
  802a96:	50                   	push   %eax
  802a97:	68 74 57 80 00       	push   $0x805774
  802a9c:	68 bd 00 00 00       	push   $0xbd
  802aa1:	68 25 56 80 00       	push   $0x805625
  802aa6:	e8 cc e6 ff ff       	call   801177 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aae:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802ab1:	0f 82 6c ff ff ff    	jb     802a23 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  802ab7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802abb:	75 17                	jne    802ad4 <free_pages+0x172>
  802abd:	83 ec 04             	sub    $0x4,%esp
  802ac0:	68 d6 57 80 00       	push   $0x8057d6
  802ac5:	68 c1 00 00 00       	push   $0xc1
  802aca:	68 25 56 80 00       	push   $0x805625
  802acf:	e8 a3 e6 ff ff       	call   801177 <_panic>
  802ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad7:	8b 40 08             	mov    0x8(%eax),%eax
  802ada:	85 c0                	test   %eax,%eax
  802adc:	74 11                	je     802aef <free_pages+0x18d>
  802ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae1:	8b 40 08             	mov    0x8(%eax),%eax
  802ae4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ae7:	8b 52 0c             	mov    0xc(%edx),%edx
  802aea:	89 50 0c             	mov    %edx,0xc(%eax)
  802aed:	eb 0b                	jmp    802afa <free_pages+0x198>
  802aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af2:	8b 40 0c             	mov    0xc(%eax),%eax
  802af5:	a3 28 60 80 00       	mov    %eax,0x806028
  802afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afd:	8b 40 0c             	mov    0xc(%eax),%eax
  802b00:	85 c0                	test   %eax,%eax
  802b02:	74 11                	je     802b15 <free_pages+0x1b3>
  802b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b07:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b0d:	8b 52 08             	mov    0x8(%edx),%edx
  802b10:	89 50 08             	mov    %edx,0x8(%eax)
  802b13:	eb 0b                	jmp    802b20 <free_pages+0x1be>
  802b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b18:	8b 40 08             	mov    0x8(%eax),%eax
  802b1b:	a3 24 60 80 00       	mov    %eax,0x806024
  802b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b23:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802b34:	a1 30 60 80 00       	mov    0x806030,%eax
  802b39:	48                   	dec    %eax
  802b3a:	a3 30 60 80 00       	mov    %eax,0x806030
			free_block(it);
  802b3f:	83 ec 0c             	sub    $0xc,%esp
  802b42:	ff 75 f4             	pushl  -0xc(%ebp)
  802b45:	e8 24 15 00 00       	call   80406e <free_block>
  802b4a:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  802b4d:	e8 72 fb ff ff       	call   8026c4 <recompute_page_alloc_break>

			return;
  802b52:	eb 37                	jmp    802b8b <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802b54:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802b59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b60:	74 08                	je     802b6a <free_pages+0x208>
  802b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b65:	8b 40 08             	mov    0x8(%eax),%eax
  802b68:	eb 05                	jmp    802b6f <free_pages+0x20d>
  802b6a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b6f:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802b74:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802b79:	85 c0                	test   %eax,%eax
  802b7b:	0f 85 fa fd ff ff    	jne    80297b <free_pages+0x19>
  802b81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b85:	0f 85 f0 fd ff ff    	jne    80297b <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  802b8b:	c9                   	leave  
  802b8c:	c3                   	ret    

00802b8d <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  802b8d:	55                   	push   %ebp
  802b8e:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  802b90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b95:	5d                   	pop    %ebp
  802b96:	c3                   	ret    

00802b97 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802b97:	55                   	push   %ebp
  802b98:	89 e5                	mov    %esp,%ebp
  802b9a:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802b9d:	a1 08 60 80 00       	mov    0x806008,%eax
  802ba2:	85 c0                	test   %eax,%eax
  802ba4:	74 60                	je     802c06 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802ba6:	83 ec 08             	sub    $0x8,%esp
  802ba9:	68 00 00 00 82       	push   $0x82000000
  802bae:	68 00 00 00 80       	push   $0x80000000
  802bb3:	e8 0d 0d 00 00       	call   8038c5 <initialize_dynamic_allocator>
  802bb8:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802bbb:	e8 f3 0a 00 00       	call   8036b3 <sys_get_uheap_strategy>
  802bc0:	a3 60 e0 81 00       	mov    %eax,0x81e060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802bc5:	a1 40 60 80 00       	mov    0x806040,%eax
  802bca:	05 00 10 00 00       	add    $0x1000,%eax
  802bcf:	a3 10 e1 81 00       	mov    %eax,0x81e110
		uheapPageAllocBreak = uheapPageAllocStart;
  802bd4:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802bd9:	a3 68 e0 81 00       	mov    %eax,0x81e068

		LIST_INIT(&page_alloc_list);
  802bde:	c7 05 24 60 80 00 00 	movl   $0x0,0x806024
  802be5:	00 00 00 
  802be8:	c7 05 28 60 80 00 00 	movl   $0x0,0x806028
  802bef:	00 00 00 
  802bf2:	c7 05 30 60 80 00 00 	movl   $0x0,0x806030
  802bf9:	00 00 00 

		__firstTimeFlag = 0;
  802bfc:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  802c03:	00 00 00 
	}
}
  802c06:	90                   	nop
  802c07:	c9                   	leave  
  802c08:	c3                   	ret    

00802c09 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  802c09:	55                   	push   %ebp
  802c0a:	89 e5                	mov    %esp,%ebp
  802c0c:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  802c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802c1d:	83 ec 08             	sub    $0x8,%esp
  802c20:	68 06 04 00 00       	push   $0x406
  802c25:	50                   	push   %eax
  802c26:	e8 d2 06 00 00       	call   8032fd <__sys_allocate_page>
  802c2b:	83 c4 10             	add    $0x10,%esp
  802c2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802c31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c35:	79 17                	jns    802c4e <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  802c37:	83 ec 04             	sub    $0x4,%esp
  802c3a:	68 f4 57 80 00       	push   $0x8057f4
  802c3f:	68 ea 00 00 00       	push   $0xea
  802c44:	68 25 56 80 00       	push   $0x805625
  802c49:	e8 29 e5 ff ff       	call   801177 <_panic>
	return 0;
  802c4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c53:	c9                   	leave  
  802c54:	c3                   	ret    

00802c55 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802c55:	55                   	push   %ebp
  802c56:	89 e5                	mov    %esp,%ebp
  802c58:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802c69:	83 ec 0c             	sub    $0xc,%esp
  802c6c:	50                   	push   %eax
  802c6d:	e8 d2 06 00 00       	call   803344 <__sys_unmap_frame>
  802c72:	83 c4 10             	add    $0x10,%esp
  802c75:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802c78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c7c:	79 17                	jns    802c95 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  802c7e:	83 ec 04             	sub    $0x4,%esp
  802c81:	68 30 58 80 00       	push   $0x805830
  802c86:	68 f5 00 00 00       	push   $0xf5
  802c8b:	68 25 56 80 00       	push   $0x805625
  802c90:	e8 e2 e4 ff ff       	call   801177 <_panic>
}
  802c95:	90                   	nop
  802c96:	c9                   	leave  
  802c97:	c3                   	ret    

00802c98 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802c98:	55                   	push   %ebp
  802c99:	89 e5                	mov    %esp,%ebp
  802c9b:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802c9e:	e8 f4 fe ff ff       	call   802b97 <uheap_init>
	if (size == 0) return NULL ;
  802ca3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ca7:	75 0a                	jne    802cb3 <malloc+0x1b>
  802ca9:	b8 00 00 00 00       	mov    $0x0,%eax
  802cae:	e9 67 01 00 00       	jmp    802e1a <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  802cb3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  802cba:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802cc1:	77 16                	ja     802cd9 <malloc+0x41>
		result = alloc_block(size);
  802cc3:	83 ec 0c             	sub    $0xc,%esp
  802cc6:	ff 75 08             	pushl  0x8(%ebp)
  802cc9:	e8 46 0e 00 00       	call   803b14 <alloc_block>
  802cce:	83 c4 10             	add    $0x10,%esp
  802cd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cd4:	e9 3e 01 00 00       	jmp    802e17 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  802cd9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802ce0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce6:	01 d0                	add    %edx,%eax
  802ce8:	48                   	dec    %eax
  802ce9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802cec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cef:	ba 00 00 00 00       	mov    $0x0,%edx
  802cf4:	f7 75 f0             	divl   -0x10(%ebp)
  802cf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfa:	29 d0                	sub    %edx,%eax
  802cfc:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  802cff:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802d04:	85 c0                	test   %eax,%eax
  802d06:	75 0a                	jne    802d12 <malloc+0x7a>
			return NULL;
  802d08:	b8 00 00 00 00       	mov    $0x0,%eax
  802d0d:	e9 08 01 00 00       	jmp    802e1a <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  802d12:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802d17:	85 c0                	test   %eax,%eax
  802d19:	74 0f                	je     802d2a <malloc+0x92>
  802d1b:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802d21:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802d26:	39 c2                	cmp    %eax,%edx
  802d28:	73 0a                	jae    802d34 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  802d2a:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802d2f:	a3 68 e0 81 00       	mov    %eax,0x81e068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  802d34:	a1 60 e0 81 00       	mov    0x81e060,%eax
  802d39:	83 f8 05             	cmp    $0x5,%eax
  802d3c:	75 11                	jne    802d4f <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  802d3e:	83 ec 0c             	sub    $0xc,%esp
  802d41:	ff 75 e8             	pushl  -0x18(%ebp)
  802d44:	e8 ff f9 ff ff       	call   802748 <alloc_pages_custom_fit>
  802d49:	83 c4 10             	add    $0x10,%esp
  802d4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  802d4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d53:	0f 84 be 00 00 00    	je     802e17 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  802d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  802d5f:	83 ec 0c             	sub    $0xc,%esp
  802d62:	ff 75 f4             	pushl  -0xc(%ebp)
  802d65:	e8 9a fb ff ff       	call   802904 <find_allocated_size>
  802d6a:	83 c4 10             	add    $0x10,%esp
  802d6d:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  802d70:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d74:	75 17                	jne    802d8d <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  802d76:	ff 75 f4             	pushl  -0xc(%ebp)
  802d79:	68 70 58 80 00       	push   $0x805870
  802d7e:	68 24 01 00 00       	push   $0x124
  802d83:	68 25 56 80 00       	push   $0x805625
  802d88:	e8 ea e3 ff ff       	call   801177 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  802d8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d90:	f7 d0                	not    %eax
  802d92:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d95:	73 1d                	jae    802db4 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  802d97:	83 ec 0c             	sub    $0xc,%esp
  802d9a:	ff 75 e0             	pushl  -0x20(%ebp)
  802d9d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802da0:	68 b8 58 80 00       	push   $0x8058b8
  802da5:	68 29 01 00 00       	push   $0x129
  802daa:	68 25 56 80 00       	push   $0x805625
  802daf:	e8 c3 e3 ff ff       	call   801177 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  802db4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802db7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dba:	01 d0                	add    %edx,%eax
  802dbc:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  802dbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc2:	85 c0                	test   %eax,%eax
  802dc4:	79 2c                	jns    802df2 <malloc+0x15a>
  802dc6:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  802dcd:	77 23                	ja     802df2 <malloc+0x15a>
  802dcf:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802dd6:	77 1a                	ja     802df2 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  802dd8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ddb:	85 c0                	test   %eax,%eax
  802ddd:	79 13                	jns    802df2 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  802ddf:	83 ec 08             	sub    $0x8,%esp
  802de2:	ff 75 e0             	pushl  -0x20(%ebp)
  802de5:	ff 75 e4             	pushl  -0x1c(%ebp)
  802de8:	e8 de 09 00 00       	call   8037cb <sys_allocate_user_mem>
  802ded:	83 c4 10             	add    $0x10,%esp
  802df0:	eb 25                	jmp    802e17 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  802df2:	68 00 00 00 a0       	push   $0xa0000000
  802df7:	ff 75 dc             	pushl  -0x24(%ebp)
  802dfa:	ff 75 e0             	pushl  -0x20(%ebp)
  802dfd:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e00:	ff 75 f4             	pushl  -0xc(%ebp)
  802e03:	68 f4 58 80 00       	push   $0x8058f4
  802e08:	68 33 01 00 00       	push   $0x133
  802e0d:	68 25 56 80 00       	push   $0x805625
  802e12:	e8 60 e3 ff ff       	call   801177 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  802e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  802e1a:	c9                   	leave  
  802e1b:	c3                   	ret    

00802e1c <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802e1c:	55                   	push   %ebp
  802e1d:	89 e5                	mov    %esp,%ebp
  802e1f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  802e22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e26:	0f 84 26 01 00 00    	je     802f52 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  802e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  802e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e35:	85 c0                	test   %eax,%eax
  802e37:	79 1c                	jns    802e55 <free+0x39>
  802e39:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  802e40:	77 13                	ja     802e55 <free+0x39>
		free_block(virtual_address);
  802e42:	83 ec 0c             	sub    $0xc,%esp
  802e45:	ff 75 08             	pushl  0x8(%ebp)
  802e48:	e8 21 12 00 00       	call   80406e <free_block>
  802e4d:	83 c4 10             	add    $0x10,%esp
		return;
  802e50:	e9 01 01 00 00       	jmp    802f56 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  802e55:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802e5a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  802e5d:	0f 82 d8 00 00 00    	jb     802f3b <free+0x11f>
  802e63:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  802e6a:	0f 87 cb 00 00 00    	ja     802f3b <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  802e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e73:	25 ff 0f 00 00       	and    $0xfff,%eax
  802e78:	85 c0                	test   %eax,%eax
  802e7a:	74 17                	je     802e93 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  802e7c:	ff 75 08             	pushl  0x8(%ebp)
  802e7f:	68 64 59 80 00       	push   $0x805964
  802e84:	68 57 01 00 00       	push   $0x157
  802e89:	68 25 56 80 00       	push   $0x805625
  802e8e:	e8 e4 e2 ff ff       	call   801177 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  802e93:	83 ec 0c             	sub    $0xc,%esp
  802e96:	ff 75 08             	pushl  0x8(%ebp)
  802e99:	e8 66 fa ff ff       	call   802904 <find_allocated_size>
  802e9e:	83 c4 10             	add    $0x10,%esp
  802ea1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  802ea4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ea8:	0f 84 a7 00 00 00    	je     802f55 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  802eae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb1:	f7 d0                	not    %eax
  802eb3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802eb6:	73 1d                	jae    802ed5 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  802eb8:	83 ec 0c             	sub    $0xc,%esp
  802ebb:	ff 75 f0             	pushl  -0x10(%ebp)
  802ebe:	ff 75 f4             	pushl  -0xc(%ebp)
  802ec1:	68 8c 59 80 00       	push   $0x80598c
  802ec6:	68 61 01 00 00       	push   $0x161
  802ecb:	68 25 56 80 00       	push   $0x805625
  802ed0:	e8 a2 e2 ff ff       	call   801177 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  802ed5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edb:	01 d0                	add    %edx,%eax
  802edd:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  802ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee3:	85 c0                	test   %eax,%eax
  802ee5:	79 19                	jns    802f00 <free+0xe4>
  802ee7:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  802eee:	77 10                	ja     802f00 <free+0xe4>
  802ef0:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  802ef7:	77 07                	ja     802f00 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  802ef9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efc:	85 c0                	test   %eax,%eax
  802efe:	78 2b                	js     802f2b <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  802f00:	83 ec 0c             	sub    $0xc,%esp
  802f03:	68 00 00 00 a0       	push   $0xa0000000
  802f08:	ff 75 ec             	pushl  -0x14(%ebp)
  802f0b:	ff 75 f0             	pushl  -0x10(%ebp)
  802f0e:	ff 75 f4             	pushl  -0xc(%ebp)
  802f11:	ff 75 f0             	pushl  -0x10(%ebp)
  802f14:	ff 75 08             	pushl  0x8(%ebp)
  802f17:	68 c8 59 80 00       	push   $0x8059c8
  802f1c:	68 69 01 00 00       	push   $0x169
  802f21:	68 25 56 80 00       	push   $0x805625
  802f26:	e8 4c e2 ff ff       	call   801177 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  802f2b:	83 ec 0c             	sub    $0xc,%esp
  802f2e:	ff 75 08             	pushl  0x8(%ebp)
  802f31:	e8 2c fa ff ff       	call   802962 <free_pages>
  802f36:	83 c4 10             	add    $0x10,%esp
		return;
  802f39:	eb 1b                	jmp    802f56 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  802f3b:	ff 75 08             	pushl  0x8(%ebp)
  802f3e:	68 24 5a 80 00       	push   $0x805a24
  802f43:	68 70 01 00 00       	push   $0x170
  802f48:	68 25 56 80 00       	push   $0x805625
  802f4d:	e8 25 e2 ff ff       	call   801177 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  802f52:	90                   	nop
  802f53:	eb 01                	jmp    802f56 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  802f55:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  802f56:	c9                   	leave  
  802f57:	c3                   	ret    

00802f58 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802f58:	55                   	push   %ebp
  802f59:	89 e5                	mov    %esp,%ebp
  802f5b:	83 ec 38             	sub    $0x38,%esp
  802f5e:	8b 45 10             	mov    0x10(%ebp),%eax
  802f61:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802f64:	e8 2e fc ff ff       	call   802b97 <uheap_init>
	if (size == 0) return NULL ;
  802f69:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f6d:	75 0a                	jne    802f79 <smalloc+0x21>
  802f6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f74:	e9 3d 01 00 00       	jmp    8030b6 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  802f79:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  802f7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f82:	25 ff 0f 00 00       	and    $0xfff,%eax
  802f87:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  802f8a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f8e:	74 0e                	je     802f9e <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  802f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f93:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802f96:	05 00 10 00 00       	add    $0x1000,%eax
  802f9b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  802f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa1:	c1 e8 0c             	shr    $0xc,%eax
  802fa4:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  802fa7:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802fac:	85 c0                	test   %eax,%eax
  802fae:	75 0a                	jne    802fba <smalloc+0x62>
		return NULL;
  802fb0:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb5:	e9 fc 00 00 00       	jmp    8030b6 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  802fba:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802fbf:	85 c0                	test   %eax,%eax
  802fc1:	74 0f                	je     802fd2 <smalloc+0x7a>
  802fc3:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802fc9:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802fce:	39 c2                	cmp    %eax,%edx
  802fd0:	73 0a                	jae    802fdc <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  802fd2:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802fd7:	a3 68 e0 81 00       	mov    %eax,0x81e068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802fdc:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802fe1:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802fe6:	29 c2                	sub    %eax,%edx
  802fe8:	89 d0                	mov    %edx,%eax
  802fea:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802fed:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802ff3:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802ff8:	29 c2                	sub    %eax,%edx
  802ffa:	89 d0                	mov    %edx,%eax
  802ffc:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  802fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803002:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803005:	77 13                	ja     80301a <smalloc+0xc2>
  803007:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80300a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80300d:	77 0b                	ja     80301a <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  80300f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803012:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  803015:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803018:	73 0a                	jae    803024 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  80301a:	b8 00 00 00 00       	mov    $0x0,%eax
  80301f:	e9 92 00 00 00       	jmp    8030b6 <smalloc+0x15e>
	}

	void *va = NULL;
  803024:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  80302b:	a1 60 e0 81 00       	mov    0x81e060,%eax
  803030:	83 f8 05             	cmp    $0x5,%eax
  803033:	75 11                	jne    803046 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  803035:	83 ec 0c             	sub    $0xc,%esp
  803038:	ff 75 f4             	pushl  -0xc(%ebp)
  80303b:	e8 08 f7 ff ff       	call   802748 <alloc_pages_custom_fit>
  803040:	83 c4 10             	add    $0x10,%esp
  803043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  803046:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80304a:	75 27                	jne    803073 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  80304c:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  803053:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803056:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803059:	89 c2                	mov    %eax,%edx
  80305b:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803060:	39 c2                	cmp    %eax,%edx
  803062:	73 07                	jae    80306b <smalloc+0x113>
			return NULL;}
  803064:	b8 00 00 00 00       	mov    $0x0,%eax
  803069:	eb 4b                	jmp    8030b6 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  80306b:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803070:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  803073:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  803077:	ff 75 f0             	pushl  -0x10(%ebp)
  80307a:	50                   	push   %eax
  80307b:	ff 75 0c             	pushl  0xc(%ebp)
  80307e:	ff 75 08             	pushl  0x8(%ebp)
  803081:	e8 cb 03 00 00       	call   803451 <sys_create_shared_object>
  803086:	83 c4 10             	add    $0x10,%esp
  803089:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  80308c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803090:	79 07                	jns    803099 <smalloc+0x141>
		return NULL;
  803092:	b8 00 00 00 00       	mov    $0x0,%eax
  803097:	eb 1d                	jmp    8030b6 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  803099:	a1 68 e0 81 00       	mov    0x81e068,%eax
  80309e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8030a1:	75 10                	jne    8030b3 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  8030a3:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  8030a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ac:	01 d0                	add    %edx,%eax
  8030ae:	a3 68 e0 81 00       	mov    %eax,0x81e068
	}

	return va;
  8030b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  8030b6:	c9                   	leave  
  8030b7:	c3                   	ret    

008030b8 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8030b8:	55                   	push   %ebp
  8030b9:	89 e5                	mov    %esp,%ebp
  8030bb:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8030be:	e8 d4 fa ff ff       	call   802b97 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8030c3:	83 ec 08             	sub    $0x8,%esp
  8030c6:	ff 75 0c             	pushl  0xc(%ebp)
  8030c9:	ff 75 08             	pushl  0x8(%ebp)
  8030cc:	e8 aa 03 00 00       	call   80347b <sys_size_of_shared_object>
  8030d1:	83 c4 10             	add    $0x10,%esp
  8030d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  8030d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030db:	7f 0a                	jg     8030e7 <sget+0x2f>
		return NULL;
  8030dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8030e2:	e9 32 01 00 00       	jmp    803219 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  8030e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  8030ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f0:	25 ff 0f 00 00       	and    $0xfff,%eax
  8030f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  8030f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030fc:	74 0e                	je     80310c <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  8030fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803101:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803104:	05 00 10 00 00       	add    $0x1000,%eax
  803109:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  80310c:	a1 10 e1 81 00       	mov    0x81e110,%eax
  803111:	85 c0                	test   %eax,%eax
  803113:	75 0a                	jne    80311f <sget+0x67>
		return NULL;
  803115:	b8 00 00 00 00       	mov    $0x0,%eax
  80311a:	e9 fa 00 00 00       	jmp    803219 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  80311f:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803124:	85 c0                	test   %eax,%eax
  803126:	74 0f                	je     803137 <sget+0x7f>
  803128:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  80312e:	a1 10 e1 81 00       	mov    0x81e110,%eax
  803133:	39 c2                	cmp    %eax,%edx
  803135:	73 0a                	jae    803141 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  803137:	a1 10 e1 81 00       	mov    0x81e110,%eax
  80313c:	a3 68 e0 81 00       	mov    %eax,0x81e068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  803141:	a1 10 e1 81 00       	mov    0x81e110,%eax
  803146:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80314b:	29 c2                	sub    %eax,%edx
  80314d:	89 d0                	mov    %edx,%eax
  80314f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  803152:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803158:	a1 10 e1 81 00       	mov    0x81e110,%eax
  80315d:	29 c2                	sub    %eax,%edx
  80315f:	89 d0                	mov    %edx,%eax
  803161:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  803164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803167:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80316a:	77 13                	ja     80317f <sget+0xc7>
  80316c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80316f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803172:	77 0b                	ja     80317f <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  803174:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803177:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  80317a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80317d:	73 0a                	jae    803189 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  80317f:	b8 00 00 00 00       	mov    $0x0,%eax
  803184:	e9 90 00 00 00       	jmp    803219 <sget+0x161>

	void *va = NULL;
  803189:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  803190:	a1 60 e0 81 00       	mov    0x81e060,%eax
  803195:	83 f8 05             	cmp    $0x5,%eax
  803198:	75 11                	jne    8031ab <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  80319a:	83 ec 0c             	sub    $0xc,%esp
  80319d:	ff 75 f4             	pushl  -0xc(%ebp)
  8031a0:	e8 a3 f5 ff ff       	call   802748 <alloc_pages_custom_fit>
  8031a5:	83 c4 10             	add    $0x10,%esp
  8031a8:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  8031ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031af:	75 27                	jne    8031d8 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8031b1:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  8031b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031bb:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8031be:	89 c2                	mov    %eax,%edx
  8031c0:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8031c5:	39 c2                	cmp    %eax,%edx
  8031c7:	73 07                	jae    8031d0 <sget+0x118>
			return NULL;
  8031c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ce:	eb 49                	jmp    803219 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  8031d0:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8031d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  8031d8:	83 ec 04             	sub    $0x4,%esp
  8031db:	ff 75 f0             	pushl  -0x10(%ebp)
  8031de:	ff 75 0c             	pushl  0xc(%ebp)
  8031e1:	ff 75 08             	pushl  0x8(%ebp)
  8031e4:	e8 af 02 00 00       	call   803498 <sys_get_shared_object>
  8031e9:	83 c4 10             	add    $0x10,%esp
  8031ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  8031ef:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8031f3:	79 07                	jns    8031fc <sget+0x144>
		return NULL;
  8031f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8031fa:	eb 1d                	jmp    803219 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  8031fc:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803201:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  803204:	75 10                	jne    803216 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  803206:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  80320c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320f:	01 d0                	add    %edx,%eax
  803211:	a3 68 e0 81 00       	mov    %eax,0x81e068

	return va;
  803216:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  803219:	c9                   	leave  
  80321a:	c3                   	ret    

0080321b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80321b:	55                   	push   %ebp
  80321c:	89 e5                	mov    %esp,%ebp
  80321e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803221:	e8 71 f9 ff ff       	call   802b97 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  803226:	83 ec 04             	sub    $0x4,%esp
  803229:	68 48 5a 80 00       	push   $0x805a48
  80322e:	68 19 02 00 00       	push   $0x219
  803233:	68 25 56 80 00       	push   $0x805625
  803238:	e8 3a df ff ff       	call   801177 <_panic>

0080323d <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80323d:	55                   	push   %ebp
  80323e:	89 e5                	mov    %esp,%ebp
  803240:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  803243:	83 ec 04             	sub    $0x4,%esp
  803246:	68 70 5a 80 00       	push   $0x805a70
  80324b:	68 2b 02 00 00       	push   $0x22b
  803250:	68 25 56 80 00       	push   $0x805625
  803255:	e8 1d df ff ff       	call   801177 <_panic>

0080325a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80325a:	55                   	push   %ebp
  80325b:	89 e5                	mov    %esp,%ebp
  80325d:	57                   	push   %edi
  80325e:	56                   	push   %esi
  80325f:	53                   	push   %ebx
  803260:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  803263:	8b 45 08             	mov    0x8(%ebp),%eax
  803266:	8b 55 0c             	mov    0xc(%ebp),%edx
  803269:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80326c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80326f:	8b 7d 18             	mov    0x18(%ebp),%edi
  803272:	8b 75 1c             	mov    0x1c(%ebp),%esi
  803275:	cd 30                	int    $0x30
  803277:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80327a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80327d:	83 c4 10             	add    $0x10,%esp
  803280:	5b                   	pop    %ebx
  803281:	5e                   	pop    %esi
  803282:	5f                   	pop    %edi
  803283:	5d                   	pop    %ebp
  803284:	c3                   	ret    

00803285 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  803285:	55                   	push   %ebp
  803286:	89 e5                	mov    %esp,%ebp
  803288:	83 ec 04             	sub    $0x4,%esp
  80328b:	8b 45 10             	mov    0x10(%ebp),%eax
  80328e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803291:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803294:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803298:	8b 45 08             	mov    0x8(%ebp),%eax
  80329b:	6a 00                	push   $0x0
  80329d:	51                   	push   %ecx
  80329e:	52                   	push   %edx
  80329f:	ff 75 0c             	pushl  0xc(%ebp)
  8032a2:	50                   	push   %eax
  8032a3:	6a 00                	push   $0x0
  8032a5:	e8 b0 ff ff ff       	call   80325a <syscall>
  8032aa:	83 c4 18             	add    $0x18,%esp
}
  8032ad:	90                   	nop
  8032ae:	c9                   	leave  
  8032af:	c3                   	ret    

008032b0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8032b0:	55                   	push   %ebp
  8032b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8032b3:	6a 00                	push   $0x0
  8032b5:	6a 00                	push   $0x0
  8032b7:	6a 00                	push   $0x0
  8032b9:	6a 00                	push   $0x0
  8032bb:	6a 00                	push   $0x0
  8032bd:	6a 02                	push   $0x2
  8032bf:	e8 96 ff ff ff       	call   80325a <syscall>
  8032c4:	83 c4 18             	add    $0x18,%esp
}
  8032c7:	c9                   	leave  
  8032c8:	c3                   	ret    

008032c9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8032c9:	55                   	push   %ebp
  8032ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8032cc:	6a 00                	push   $0x0
  8032ce:	6a 00                	push   $0x0
  8032d0:	6a 00                	push   $0x0
  8032d2:	6a 00                	push   $0x0
  8032d4:	6a 00                	push   $0x0
  8032d6:	6a 03                	push   $0x3
  8032d8:	e8 7d ff ff ff       	call   80325a <syscall>
  8032dd:	83 c4 18             	add    $0x18,%esp
}
  8032e0:	90                   	nop
  8032e1:	c9                   	leave  
  8032e2:	c3                   	ret    

008032e3 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8032e3:	55                   	push   %ebp
  8032e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8032e6:	6a 00                	push   $0x0
  8032e8:	6a 00                	push   $0x0
  8032ea:	6a 00                	push   $0x0
  8032ec:	6a 00                	push   $0x0
  8032ee:	6a 00                	push   $0x0
  8032f0:	6a 04                	push   $0x4
  8032f2:	e8 63 ff ff ff       	call   80325a <syscall>
  8032f7:	83 c4 18             	add    $0x18,%esp
}
  8032fa:	90                   	nop
  8032fb:	c9                   	leave  
  8032fc:	c3                   	ret    

008032fd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8032fd:	55                   	push   %ebp
  8032fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  803300:	8b 55 0c             	mov    0xc(%ebp),%edx
  803303:	8b 45 08             	mov    0x8(%ebp),%eax
  803306:	6a 00                	push   $0x0
  803308:	6a 00                	push   $0x0
  80330a:	6a 00                	push   $0x0
  80330c:	52                   	push   %edx
  80330d:	50                   	push   %eax
  80330e:	6a 08                	push   $0x8
  803310:	e8 45 ff ff ff       	call   80325a <syscall>
  803315:	83 c4 18             	add    $0x18,%esp
}
  803318:	c9                   	leave  
  803319:	c3                   	ret    

0080331a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80331a:	55                   	push   %ebp
  80331b:	89 e5                	mov    %esp,%ebp
  80331d:	56                   	push   %esi
  80331e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80331f:	8b 75 18             	mov    0x18(%ebp),%esi
  803322:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803325:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803328:	8b 55 0c             	mov    0xc(%ebp),%edx
  80332b:	8b 45 08             	mov    0x8(%ebp),%eax
  80332e:	56                   	push   %esi
  80332f:	53                   	push   %ebx
  803330:	51                   	push   %ecx
  803331:	52                   	push   %edx
  803332:	50                   	push   %eax
  803333:	6a 09                	push   $0x9
  803335:	e8 20 ff ff ff       	call   80325a <syscall>
  80333a:	83 c4 18             	add    $0x18,%esp
}
  80333d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803340:	5b                   	pop    %ebx
  803341:	5e                   	pop    %esi
  803342:	5d                   	pop    %ebp
  803343:	c3                   	ret    

00803344 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  803344:	55                   	push   %ebp
  803345:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803347:	6a 00                	push   $0x0
  803349:	6a 00                	push   $0x0
  80334b:	6a 00                	push   $0x0
  80334d:	6a 00                	push   $0x0
  80334f:	ff 75 08             	pushl  0x8(%ebp)
  803352:	6a 0a                	push   $0xa
  803354:	e8 01 ff ff ff       	call   80325a <syscall>
  803359:	83 c4 18             	add    $0x18,%esp
}
  80335c:	c9                   	leave  
  80335d:	c3                   	ret    

0080335e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80335e:	55                   	push   %ebp
  80335f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  803361:	6a 00                	push   $0x0
  803363:	6a 00                	push   $0x0
  803365:	6a 00                	push   $0x0
  803367:	ff 75 0c             	pushl  0xc(%ebp)
  80336a:	ff 75 08             	pushl  0x8(%ebp)
  80336d:	6a 0b                	push   $0xb
  80336f:	e8 e6 fe ff ff       	call   80325a <syscall>
  803374:	83 c4 18             	add    $0x18,%esp
}
  803377:	c9                   	leave  
  803378:	c3                   	ret    

00803379 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  803379:	55                   	push   %ebp
  80337a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80337c:	6a 00                	push   $0x0
  80337e:	6a 00                	push   $0x0
  803380:	6a 00                	push   $0x0
  803382:	6a 00                	push   $0x0
  803384:	6a 00                	push   $0x0
  803386:	6a 0c                	push   $0xc
  803388:	e8 cd fe ff ff       	call   80325a <syscall>
  80338d:	83 c4 18             	add    $0x18,%esp
}
  803390:	c9                   	leave  
  803391:	c3                   	ret    

00803392 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803392:	55                   	push   %ebp
  803393:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803395:	6a 00                	push   $0x0
  803397:	6a 00                	push   $0x0
  803399:	6a 00                	push   $0x0
  80339b:	6a 00                	push   $0x0
  80339d:	6a 00                	push   $0x0
  80339f:	6a 0d                	push   $0xd
  8033a1:	e8 b4 fe ff ff       	call   80325a <syscall>
  8033a6:	83 c4 18             	add    $0x18,%esp
}
  8033a9:	c9                   	leave  
  8033aa:	c3                   	ret    

008033ab <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8033ab:	55                   	push   %ebp
  8033ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8033ae:	6a 00                	push   $0x0
  8033b0:	6a 00                	push   $0x0
  8033b2:	6a 00                	push   $0x0
  8033b4:	6a 00                	push   $0x0
  8033b6:	6a 00                	push   $0x0
  8033b8:	6a 0e                	push   $0xe
  8033ba:	e8 9b fe ff ff       	call   80325a <syscall>
  8033bf:	83 c4 18             	add    $0x18,%esp
}
  8033c2:	c9                   	leave  
  8033c3:	c3                   	ret    

008033c4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8033c4:	55                   	push   %ebp
  8033c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8033c7:	6a 00                	push   $0x0
  8033c9:	6a 00                	push   $0x0
  8033cb:	6a 00                	push   $0x0
  8033cd:	6a 00                	push   $0x0
  8033cf:	6a 00                	push   $0x0
  8033d1:	6a 0f                	push   $0xf
  8033d3:	e8 82 fe ff ff       	call   80325a <syscall>
  8033d8:	83 c4 18             	add    $0x18,%esp
}
  8033db:	c9                   	leave  
  8033dc:	c3                   	ret    

008033dd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8033dd:	55                   	push   %ebp
  8033de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8033e0:	6a 00                	push   $0x0
  8033e2:	6a 00                	push   $0x0
  8033e4:	6a 00                	push   $0x0
  8033e6:	6a 00                	push   $0x0
  8033e8:	ff 75 08             	pushl  0x8(%ebp)
  8033eb:	6a 10                	push   $0x10
  8033ed:	e8 68 fe ff ff       	call   80325a <syscall>
  8033f2:	83 c4 18             	add    $0x18,%esp
}
  8033f5:	c9                   	leave  
  8033f6:	c3                   	ret    

008033f7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8033f7:	55                   	push   %ebp
  8033f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8033fa:	6a 00                	push   $0x0
  8033fc:	6a 00                	push   $0x0
  8033fe:	6a 00                	push   $0x0
  803400:	6a 00                	push   $0x0
  803402:	6a 00                	push   $0x0
  803404:	6a 11                	push   $0x11
  803406:	e8 4f fe ff ff       	call   80325a <syscall>
  80340b:	83 c4 18             	add    $0x18,%esp
}
  80340e:	90                   	nop
  80340f:	c9                   	leave  
  803410:	c3                   	ret    

00803411 <sys_cputc>:

void
sys_cputc(const char c)
{
  803411:	55                   	push   %ebp
  803412:	89 e5                	mov    %esp,%ebp
  803414:	83 ec 04             	sub    $0x4,%esp
  803417:	8b 45 08             	mov    0x8(%ebp),%eax
  80341a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80341d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803421:	6a 00                	push   $0x0
  803423:	6a 00                	push   $0x0
  803425:	6a 00                	push   $0x0
  803427:	6a 00                	push   $0x0
  803429:	50                   	push   %eax
  80342a:	6a 01                	push   $0x1
  80342c:	e8 29 fe ff ff       	call   80325a <syscall>
  803431:	83 c4 18             	add    $0x18,%esp
}
  803434:	90                   	nop
  803435:	c9                   	leave  
  803436:	c3                   	ret    

00803437 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803437:	55                   	push   %ebp
  803438:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80343a:	6a 00                	push   $0x0
  80343c:	6a 00                	push   $0x0
  80343e:	6a 00                	push   $0x0
  803440:	6a 00                	push   $0x0
  803442:	6a 00                	push   $0x0
  803444:	6a 14                	push   $0x14
  803446:	e8 0f fe ff ff       	call   80325a <syscall>
  80344b:	83 c4 18             	add    $0x18,%esp
}
  80344e:	90                   	nop
  80344f:	c9                   	leave  
  803450:	c3                   	ret    

00803451 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803451:	55                   	push   %ebp
  803452:	89 e5                	mov    %esp,%ebp
  803454:	83 ec 04             	sub    $0x4,%esp
  803457:	8b 45 10             	mov    0x10(%ebp),%eax
  80345a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80345d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803460:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803464:	8b 45 08             	mov    0x8(%ebp),%eax
  803467:	6a 00                	push   $0x0
  803469:	51                   	push   %ecx
  80346a:	52                   	push   %edx
  80346b:	ff 75 0c             	pushl  0xc(%ebp)
  80346e:	50                   	push   %eax
  80346f:	6a 15                	push   $0x15
  803471:	e8 e4 fd ff ff       	call   80325a <syscall>
  803476:	83 c4 18             	add    $0x18,%esp
}
  803479:	c9                   	leave  
  80347a:	c3                   	ret    

0080347b <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80347b:	55                   	push   %ebp
  80347c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80347e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803481:	8b 45 08             	mov    0x8(%ebp),%eax
  803484:	6a 00                	push   $0x0
  803486:	6a 00                	push   $0x0
  803488:	6a 00                	push   $0x0
  80348a:	52                   	push   %edx
  80348b:	50                   	push   %eax
  80348c:	6a 16                	push   $0x16
  80348e:	e8 c7 fd ff ff       	call   80325a <syscall>
  803493:	83 c4 18             	add    $0x18,%esp
}
  803496:	c9                   	leave  
  803497:	c3                   	ret    

00803498 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803498:	55                   	push   %ebp
  803499:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80349b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80349e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a4:	6a 00                	push   $0x0
  8034a6:	6a 00                	push   $0x0
  8034a8:	51                   	push   %ecx
  8034a9:	52                   	push   %edx
  8034aa:	50                   	push   %eax
  8034ab:	6a 17                	push   $0x17
  8034ad:	e8 a8 fd ff ff       	call   80325a <syscall>
  8034b2:	83 c4 18             	add    $0x18,%esp
}
  8034b5:	c9                   	leave  
  8034b6:	c3                   	ret    

008034b7 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8034b7:	55                   	push   %ebp
  8034b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8034ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c0:	6a 00                	push   $0x0
  8034c2:	6a 00                	push   $0x0
  8034c4:	6a 00                	push   $0x0
  8034c6:	52                   	push   %edx
  8034c7:	50                   	push   %eax
  8034c8:	6a 18                	push   $0x18
  8034ca:	e8 8b fd ff ff       	call   80325a <syscall>
  8034cf:	83 c4 18             	add    $0x18,%esp
}
  8034d2:	c9                   	leave  
  8034d3:	c3                   	ret    

008034d4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8034d4:	55                   	push   %ebp
  8034d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8034d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034da:	6a 00                	push   $0x0
  8034dc:	ff 75 14             	pushl  0x14(%ebp)
  8034df:	ff 75 10             	pushl  0x10(%ebp)
  8034e2:	ff 75 0c             	pushl  0xc(%ebp)
  8034e5:	50                   	push   %eax
  8034e6:	6a 19                	push   $0x19
  8034e8:	e8 6d fd ff ff       	call   80325a <syscall>
  8034ed:	83 c4 18             	add    $0x18,%esp
}
  8034f0:	c9                   	leave  
  8034f1:	c3                   	ret    

008034f2 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8034f2:	55                   	push   %ebp
  8034f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8034f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f8:	6a 00                	push   $0x0
  8034fa:	6a 00                	push   $0x0
  8034fc:	6a 00                	push   $0x0
  8034fe:	6a 00                	push   $0x0
  803500:	50                   	push   %eax
  803501:	6a 1a                	push   $0x1a
  803503:	e8 52 fd ff ff       	call   80325a <syscall>
  803508:	83 c4 18             	add    $0x18,%esp
}
  80350b:	90                   	nop
  80350c:	c9                   	leave  
  80350d:	c3                   	ret    

0080350e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80350e:	55                   	push   %ebp
  80350f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803511:	8b 45 08             	mov    0x8(%ebp),%eax
  803514:	6a 00                	push   $0x0
  803516:	6a 00                	push   $0x0
  803518:	6a 00                	push   $0x0
  80351a:	6a 00                	push   $0x0
  80351c:	50                   	push   %eax
  80351d:	6a 1b                	push   $0x1b
  80351f:	e8 36 fd ff ff       	call   80325a <syscall>
  803524:	83 c4 18             	add    $0x18,%esp
}
  803527:	c9                   	leave  
  803528:	c3                   	ret    

00803529 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803529:	55                   	push   %ebp
  80352a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80352c:	6a 00                	push   $0x0
  80352e:	6a 00                	push   $0x0
  803530:	6a 00                	push   $0x0
  803532:	6a 00                	push   $0x0
  803534:	6a 00                	push   $0x0
  803536:	6a 05                	push   $0x5
  803538:	e8 1d fd ff ff       	call   80325a <syscall>
  80353d:	83 c4 18             	add    $0x18,%esp
}
  803540:	c9                   	leave  
  803541:	c3                   	ret    

00803542 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803542:	55                   	push   %ebp
  803543:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803545:	6a 00                	push   $0x0
  803547:	6a 00                	push   $0x0
  803549:	6a 00                	push   $0x0
  80354b:	6a 00                	push   $0x0
  80354d:	6a 00                	push   $0x0
  80354f:	6a 06                	push   $0x6
  803551:	e8 04 fd ff ff       	call   80325a <syscall>
  803556:	83 c4 18             	add    $0x18,%esp
}
  803559:	c9                   	leave  
  80355a:	c3                   	ret    

0080355b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80355b:	55                   	push   %ebp
  80355c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80355e:	6a 00                	push   $0x0
  803560:	6a 00                	push   $0x0
  803562:	6a 00                	push   $0x0
  803564:	6a 00                	push   $0x0
  803566:	6a 00                	push   $0x0
  803568:	6a 07                	push   $0x7
  80356a:	e8 eb fc ff ff       	call   80325a <syscall>
  80356f:	83 c4 18             	add    $0x18,%esp
}
  803572:	c9                   	leave  
  803573:	c3                   	ret    

00803574 <sys_exit_env>:


void sys_exit_env(void)
{
  803574:	55                   	push   %ebp
  803575:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803577:	6a 00                	push   $0x0
  803579:	6a 00                	push   $0x0
  80357b:	6a 00                	push   $0x0
  80357d:	6a 00                	push   $0x0
  80357f:	6a 00                	push   $0x0
  803581:	6a 1c                	push   $0x1c
  803583:	e8 d2 fc ff ff       	call   80325a <syscall>
  803588:	83 c4 18             	add    $0x18,%esp
}
  80358b:	90                   	nop
  80358c:	c9                   	leave  
  80358d:	c3                   	ret    

0080358e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80358e:	55                   	push   %ebp
  80358f:	89 e5                	mov    %esp,%ebp
  803591:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803594:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803597:	8d 50 04             	lea    0x4(%eax),%edx
  80359a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80359d:	6a 00                	push   $0x0
  80359f:	6a 00                	push   $0x0
  8035a1:	6a 00                	push   $0x0
  8035a3:	52                   	push   %edx
  8035a4:	50                   	push   %eax
  8035a5:	6a 1d                	push   $0x1d
  8035a7:	e8 ae fc ff ff       	call   80325a <syscall>
  8035ac:	83 c4 18             	add    $0x18,%esp
	return result;
  8035af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8035b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8035b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8035b8:	89 01                	mov    %eax,(%ecx)
  8035ba:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8035bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c0:	c9                   	leave  
  8035c1:	c2 04 00             	ret    $0x4

008035c4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8035c4:	55                   	push   %ebp
  8035c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8035c7:	6a 00                	push   $0x0
  8035c9:	6a 00                	push   $0x0
  8035cb:	ff 75 10             	pushl  0x10(%ebp)
  8035ce:	ff 75 0c             	pushl  0xc(%ebp)
  8035d1:	ff 75 08             	pushl  0x8(%ebp)
  8035d4:	6a 13                	push   $0x13
  8035d6:	e8 7f fc ff ff       	call   80325a <syscall>
  8035db:	83 c4 18             	add    $0x18,%esp
	return ;
  8035de:	90                   	nop
}
  8035df:	c9                   	leave  
  8035e0:	c3                   	ret    

008035e1 <sys_rcr2>:
uint32 sys_rcr2()
{
  8035e1:	55                   	push   %ebp
  8035e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8035e4:	6a 00                	push   $0x0
  8035e6:	6a 00                	push   $0x0
  8035e8:	6a 00                	push   $0x0
  8035ea:	6a 00                	push   $0x0
  8035ec:	6a 00                	push   $0x0
  8035ee:	6a 1e                	push   $0x1e
  8035f0:	e8 65 fc ff ff       	call   80325a <syscall>
  8035f5:	83 c4 18             	add    $0x18,%esp
}
  8035f8:	c9                   	leave  
  8035f9:	c3                   	ret    

008035fa <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8035fa:	55                   	push   %ebp
  8035fb:	89 e5                	mov    %esp,%ebp
  8035fd:	83 ec 04             	sub    $0x4,%esp
  803600:	8b 45 08             	mov    0x8(%ebp),%eax
  803603:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803606:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80360a:	6a 00                	push   $0x0
  80360c:	6a 00                	push   $0x0
  80360e:	6a 00                	push   $0x0
  803610:	6a 00                	push   $0x0
  803612:	50                   	push   %eax
  803613:	6a 1f                	push   $0x1f
  803615:	e8 40 fc ff ff       	call   80325a <syscall>
  80361a:	83 c4 18             	add    $0x18,%esp
	return ;
  80361d:	90                   	nop
}
  80361e:	c9                   	leave  
  80361f:	c3                   	ret    

00803620 <rsttst>:
void rsttst()
{
  803620:	55                   	push   %ebp
  803621:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803623:	6a 00                	push   $0x0
  803625:	6a 00                	push   $0x0
  803627:	6a 00                	push   $0x0
  803629:	6a 00                	push   $0x0
  80362b:	6a 00                	push   $0x0
  80362d:	6a 21                	push   $0x21
  80362f:	e8 26 fc ff ff       	call   80325a <syscall>
  803634:	83 c4 18             	add    $0x18,%esp
	return ;
  803637:	90                   	nop
}
  803638:	c9                   	leave  
  803639:	c3                   	ret    

0080363a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80363a:	55                   	push   %ebp
  80363b:	89 e5                	mov    %esp,%ebp
  80363d:	83 ec 04             	sub    $0x4,%esp
  803640:	8b 45 14             	mov    0x14(%ebp),%eax
  803643:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803646:	8b 55 18             	mov    0x18(%ebp),%edx
  803649:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80364d:	52                   	push   %edx
  80364e:	50                   	push   %eax
  80364f:	ff 75 10             	pushl  0x10(%ebp)
  803652:	ff 75 0c             	pushl  0xc(%ebp)
  803655:	ff 75 08             	pushl  0x8(%ebp)
  803658:	6a 20                	push   $0x20
  80365a:	e8 fb fb ff ff       	call   80325a <syscall>
  80365f:	83 c4 18             	add    $0x18,%esp
	return ;
  803662:	90                   	nop
}
  803663:	c9                   	leave  
  803664:	c3                   	ret    

00803665 <chktst>:
void chktst(uint32 n)
{
  803665:	55                   	push   %ebp
  803666:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803668:	6a 00                	push   $0x0
  80366a:	6a 00                	push   $0x0
  80366c:	6a 00                	push   $0x0
  80366e:	6a 00                	push   $0x0
  803670:	ff 75 08             	pushl  0x8(%ebp)
  803673:	6a 22                	push   $0x22
  803675:	e8 e0 fb ff ff       	call   80325a <syscall>
  80367a:	83 c4 18             	add    $0x18,%esp
	return ;
  80367d:	90                   	nop
}
  80367e:	c9                   	leave  
  80367f:	c3                   	ret    

00803680 <inctst>:

void inctst()
{
  803680:	55                   	push   %ebp
  803681:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803683:	6a 00                	push   $0x0
  803685:	6a 00                	push   $0x0
  803687:	6a 00                	push   $0x0
  803689:	6a 00                	push   $0x0
  80368b:	6a 00                	push   $0x0
  80368d:	6a 23                	push   $0x23
  80368f:	e8 c6 fb ff ff       	call   80325a <syscall>
  803694:	83 c4 18             	add    $0x18,%esp
	return ;
  803697:	90                   	nop
}
  803698:	c9                   	leave  
  803699:	c3                   	ret    

0080369a <gettst>:
uint32 gettst()
{
  80369a:	55                   	push   %ebp
  80369b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80369d:	6a 00                	push   $0x0
  80369f:	6a 00                	push   $0x0
  8036a1:	6a 00                	push   $0x0
  8036a3:	6a 00                	push   $0x0
  8036a5:	6a 00                	push   $0x0
  8036a7:	6a 24                	push   $0x24
  8036a9:	e8 ac fb ff ff       	call   80325a <syscall>
  8036ae:	83 c4 18             	add    $0x18,%esp
}
  8036b1:	c9                   	leave  
  8036b2:	c3                   	ret    

008036b3 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8036b3:	55                   	push   %ebp
  8036b4:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8036b6:	6a 00                	push   $0x0
  8036b8:	6a 00                	push   $0x0
  8036ba:	6a 00                	push   $0x0
  8036bc:	6a 00                	push   $0x0
  8036be:	6a 00                	push   $0x0
  8036c0:	6a 25                	push   $0x25
  8036c2:	e8 93 fb ff ff       	call   80325a <syscall>
  8036c7:	83 c4 18             	add    $0x18,%esp
  8036ca:	a3 60 e0 81 00       	mov    %eax,0x81e060
	return uheapPlaceStrategy ;
  8036cf:	a1 60 e0 81 00       	mov    0x81e060,%eax
}
  8036d4:	c9                   	leave  
  8036d5:	c3                   	ret    

008036d6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8036d6:	55                   	push   %ebp
  8036d7:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8036d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036dc:	a3 60 e0 81 00       	mov    %eax,0x81e060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8036e1:	6a 00                	push   $0x0
  8036e3:	6a 00                	push   $0x0
  8036e5:	6a 00                	push   $0x0
  8036e7:	6a 00                	push   $0x0
  8036e9:	ff 75 08             	pushl  0x8(%ebp)
  8036ec:	6a 26                	push   $0x26
  8036ee:	e8 67 fb ff ff       	call   80325a <syscall>
  8036f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8036f6:	90                   	nop
}
  8036f7:	c9                   	leave  
  8036f8:	c3                   	ret    

008036f9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8036f9:	55                   	push   %ebp
  8036fa:	89 e5                	mov    %esp,%ebp
  8036fc:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8036fd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803700:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803703:	8b 55 0c             	mov    0xc(%ebp),%edx
  803706:	8b 45 08             	mov    0x8(%ebp),%eax
  803709:	6a 00                	push   $0x0
  80370b:	53                   	push   %ebx
  80370c:	51                   	push   %ecx
  80370d:	52                   	push   %edx
  80370e:	50                   	push   %eax
  80370f:	6a 27                	push   $0x27
  803711:	e8 44 fb ff ff       	call   80325a <syscall>
  803716:	83 c4 18             	add    $0x18,%esp
}
  803719:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80371c:	c9                   	leave  
  80371d:	c3                   	ret    

0080371e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80371e:	55                   	push   %ebp
  80371f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803721:	8b 55 0c             	mov    0xc(%ebp),%edx
  803724:	8b 45 08             	mov    0x8(%ebp),%eax
  803727:	6a 00                	push   $0x0
  803729:	6a 00                	push   $0x0
  80372b:	6a 00                	push   $0x0
  80372d:	52                   	push   %edx
  80372e:	50                   	push   %eax
  80372f:	6a 28                	push   $0x28
  803731:	e8 24 fb ff ff       	call   80325a <syscall>
  803736:	83 c4 18             	add    $0x18,%esp
}
  803739:	c9                   	leave  
  80373a:	c3                   	ret    

0080373b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80373b:	55                   	push   %ebp
  80373c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80373e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803741:	8b 55 0c             	mov    0xc(%ebp),%edx
  803744:	8b 45 08             	mov    0x8(%ebp),%eax
  803747:	6a 00                	push   $0x0
  803749:	51                   	push   %ecx
  80374a:	ff 75 10             	pushl  0x10(%ebp)
  80374d:	52                   	push   %edx
  80374e:	50                   	push   %eax
  80374f:	6a 29                	push   $0x29
  803751:	e8 04 fb ff ff       	call   80325a <syscall>
  803756:	83 c4 18             	add    $0x18,%esp
}
  803759:	c9                   	leave  
  80375a:	c3                   	ret    

0080375b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80375b:	55                   	push   %ebp
  80375c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80375e:	6a 00                	push   $0x0
  803760:	6a 00                	push   $0x0
  803762:	ff 75 10             	pushl  0x10(%ebp)
  803765:	ff 75 0c             	pushl  0xc(%ebp)
  803768:	ff 75 08             	pushl  0x8(%ebp)
  80376b:	6a 12                	push   $0x12
  80376d:	e8 e8 fa ff ff       	call   80325a <syscall>
  803772:	83 c4 18             	add    $0x18,%esp
	return ;
  803775:	90                   	nop
}
  803776:	c9                   	leave  
  803777:	c3                   	ret    

00803778 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803778:	55                   	push   %ebp
  803779:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80377b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80377e:	8b 45 08             	mov    0x8(%ebp),%eax
  803781:	6a 00                	push   $0x0
  803783:	6a 00                	push   $0x0
  803785:	6a 00                	push   $0x0
  803787:	52                   	push   %edx
  803788:	50                   	push   %eax
  803789:	6a 2a                	push   $0x2a
  80378b:	e8 ca fa ff ff       	call   80325a <syscall>
  803790:	83 c4 18             	add    $0x18,%esp
	return;
  803793:	90                   	nop
}
  803794:	c9                   	leave  
  803795:	c3                   	ret    

00803796 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803796:	55                   	push   %ebp
  803797:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803799:	6a 00                	push   $0x0
  80379b:	6a 00                	push   $0x0
  80379d:	6a 00                	push   $0x0
  80379f:	6a 00                	push   $0x0
  8037a1:	6a 00                	push   $0x0
  8037a3:	6a 2b                	push   $0x2b
  8037a5:	e8 b0 fa ff ff       	call   80325a <syscall>
  8037aa:	83 c4 18             	add    $0x18,%esp
}
  8037ad:	c9                   	leave  
  8037ae:	c3                   	ret    

008037af <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8037af:	55                   	push   %ebp
  8037b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8037b2:	6a 00                	push   $0x0
  8037b4:	6a 00                	push   $0x0
  8037b6:	6a 00                	push   $0x0
  8037b8:	ff 75 0c             	pushl  0xc(%ebp)
  8037bb:	ff 75 08             	pushl  0x8(%ebp)
  8037be:	6a 2d                	push   $0x2d
  8037c0:	e8 95 fa ff ff       	call   80325a <syscall>
  8037c5:	83 c4 18             	add    $0x18,%esp
	return;
  8037c8:	90                   	nop
}
  8037c9:	c9                   	leave  
  8037ca:	c3                   	ret    

008037cb <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8037cb:	55                   	push   %ebp
  8037cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8037ce:	6a 00                	push   $0x0
  8037d0:	6a 00                	push   $0x0
  8037d2:	6a 00                	push   $0x0
  8037d4:	ff 75 0c             	pushl  0xc(%ebp)
  8037d7:	ff 75 08             	pushl  0x8(%ebp)
  8037da:	6a 2c                	push   $0x2c
  8037dc:	e8 79 fa ff ff       	call   80325a <syscall>
  8037e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8037e4:	90                   	nop
}
  8037e5:	c9                   	leave  
  8037e6:	c3                   	ret    

008037e7 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8037e7:	55                   	push   %ebp
  8037e8:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8037ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f0:	6a 00                	push   $0x0
  8037f2:	6a 00                	push   $0x0
  8037f4:	6a 00                	push   $0x0
  8037f6:	52                   	push   %edx
  8037f7:	50                   	push   %eax
  8037f8:	6a 2e                	push   $0x2e
  8037fa:	e8 5b fa ff ff       	call   80325a <syscall>
  8037ff:	83 c4 18             	add    $0x18,%esp
	return ;
  803802:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  803803:	c9                   	leave  
  803804:	c3                   	ret    

00803805 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803805:	55                   	push   %ebp
  803806:	89 e5                	mov    %esp,%ebp
  803808:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  80380b:	81 7d 08 60 60 80 00 	cmpl   $0x806060,0x8(%ebp)
  803812:	72 09                	jb     80381d <to_page_va+0x18>
  803814:	81 7d 08 60 e0 81 00 	cmpl   $0x81e060,0x8(%ebp)
  80381b:	72 14                	jb     803831 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  80381d:	83 ec 04             	sub    $0x4,%esp
  803820:	68 94 5a 80 00       	push   $0x805a94
  803825:	6a 15                	push   $0x15
  803827:	68 bf 5a 80 00       	push   $0x805abf
  80382c:	e8 46 d9 ff ff       	call   801177 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803831:	8b 45 08             	mov    0x8(%ebp),%eax
  803834:	ba 60 60 80 00       	mov    $0x806060,%edx
  803839:	29 d0                	sub    %edx,%eax
  80383b:	c1 f8 02             	sar    $0x2,%eax
  80383e:	89 c2                	mov    %eax,%edx
  803840:	89 d0                	mov    %edx,%eax
  803842:	c1 e0 02             	shl    $0x2,%eax
  803845:	01 d0                	add    %edx,%eax
  803847:	c1 e0 02             	shl    $0x2,%eax
  80384a:	01 d0                	add    %edx,%eax
  80384c:	c1 e0 02             	shl    $0x2,%eax
  80384f:	01 d0                	add    %edx,%eax
  803851:	89 c1                	mov    %eax,%ecx
  803853:	c1 e1 08             	shl    $0x8,%ecx
  803856:	01 c8                	add    %ecx,%eax
  803858:	89 c1                	mov    %eax,%ecx
  80385a:	c1 e1 10             	shl    $0x10,%ecx
  80385d:	01 c8                	add    %ecx,%eax
  80385f:	01 c0                	add    %eax,%eax
  803861:	01 d0                	add    %edx,%eax
  803863:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803869:	c1 e0 0c             	shl    $0xc,%eax
  80386c:	89 c2                	mov    %eax,%edx
  80386e:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803873:	01 d0                	add    %edx,%eax
}
  803875:	c9                   	leave  
  803876:	c3                   	ret    

00803877 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803877:	55                   	push   %ebp
  803878:	89 e5                	mov    %esp,%ebp
  80387a:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  80387d:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803882:	8b 55 08             	mov    0x8(%ebp),%edx
  803885:	29 c2                	sub    %eax,%edx
  803887:	89 d0                	mov    %edx,%eax
  803889:	c1 e8 0c             	shr    $0xc,%eax
  80388c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  80388f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803893:	78 09                	js     80389e <to_page_info+0x27>
  803895:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80389c:	7e 14                	jle    8038b2 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  80389e:	83 ec 04             	sub    $0x4,%esp
  8038a1:	68 d8 5a 80 00       	push   $0x805ad8
  8038a6:	6a 22                	push   $0x22
  8038a8:	68 bf 5a 80 00       	push   $0x805abf
  8038ad:	e8 c5 d8 ff ff       	call   801177 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8038b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038b5:	89 d0                	mov    %edx,%eax
  8038b7:	01 c0                	add    %eax,%eax
  8038b9:	01 d0                	add    %edx,%eax
  8038bb:	c1 e0 02             	shl    $0x2,%eax
  8038be:	05 60 60 80 00       	add    $0x806060,%eax
}
  8038c3:	c9                   	leave  
  8038c4:	c3                   	ret    

008038c5 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8038c5:	55                   	push   %ebp
  8038c6:	89 e5                	mov    %esp,%ebp
  8038c8:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8038cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ce:	05 00 00 00 02       	add    $0x2000000,%eax
  8038d3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8038d6:	73 16                	jae    8038ee <initialize_dynamic_allocator+0x29>
  8038d8:	68 fc 5a 80 00       	push   $0x805afc
  8038dd:	68 22 5b 80 00       	push   $0x805b22
  8038e2:	6a 34                	push   $0x34
  8038e4:	68 bf 5a 80 00       	push   $0x805abf
  8038e9:	e8 89 d8 ff ff       	call   801177 <_panic>
		is_initialized = 1;
  8038ee:	c7 05 34 60 80 00 01 	movl   $0x1,0x806034
  8038f5:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  8038f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fb:	a3 64 e0 81 00       	mov    %eax,0x81e064
	dynAllocEnd = daEnd;
  803900:	8b 45 0c             	mov    0xc(%ebp),%eax
  803903:	a3 40 60 80 00       	mov    %eax,0x806040

	LIST_INIT(&freePagesList);
  803908:	c7 05 48 60 80 00 00 	movl   $0x0,0x806048
  80390f:	00 00 00 
  803912:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  803919:	00 00 00 
  80391c:	c7 05 54 60 80 00 00 	movl   $0x0,0x806054
  803923:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  803926:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  80392d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803934:	eb 36                	jmp    80396c <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  803936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803939:	c1 e0 04             	shl    $0x4,%eax
  80393c:	05 80 e0 81 00       	add    $0x81e080,%eax
  803941:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394a:	c1 e0 04             	shl    $0x4,%eax
  80394d:	05 84 e0 81 00       	add    $0x81e084,%eax
  803952:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80395b:	c1 e0 04             	shl    $0x4,%eax
  80395e:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803963:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  803969:	ff 45 f4             	incl   -0xc(%ebp)
  80396c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80396f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803972:	72 c2                	jb     803936 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  803974:	8b 15 40 60 80 00    	mov    0x806040,%edx
  80397a:	a1 64 e0 81 00       	mov    0x81e064,%eax
  80397f:	29 c2                	sub    %eax,%edx
  803981:	89 d0                	mov    %edx,%eax
  803983:	c1 e8 0c             	shr    $0xc,%eax
  803986:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  803989:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803990:	e9 c8 00 00 00       	jmp    803a5d <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  803995:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803998:	89 d0                	mov    %edx,%eax
  80399a:	01 c0                	add    %eax,%eax
  80399c:	01 d0                	add    %edx,%eax
  80399e:	c1 e0 02             	shl    $0x2,%eax
  8039a1:	05 68 60 80 00       	add    $0x806068,%eax
  8039a6:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  8039ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039ae:	89 d0                	mov    %edx,%eax
  8039b0:	01 c0                	add    %eax,%eax
  8039b2:	01 d0                	add    %edx,%eax
  8039b4:	c1 e0 02             	shl    $0x2,%eax
  8039b7:	05 6a 60 80 00       	add    $0x80606a,%eax
  8039bc:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  8039c1:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  8039c7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8039ca:	89 c8                	mov    %ecx,%eax
  8039cc:	01 c0                	add    %eax,%eax
  8039ce:	01 c8                	add    %ecx,%eax
  8039d0:	c1 e0 02             	shl    $0x2,%eax
  8039d3:	05 64 60 80 00       	add    $0x806064,%eax
  8039d8:	89 10                	mov    %edx,(%eax)
  8039da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039dd:	89 d0                	mov    %edx,%eax
  8039df:	01 c0                	add    %eax,%eax
  8039e1:	01 d0                	add    %edx,%eax
  8039e3:	c1 e0 02             	shl    $0x2,%eax
  8039e6:	05 64 60 80 00       	add    $0x806064,%eax
  8039eb:	8b 00                	mov    (%eax),%eax
  8039ed:	85 c0                	test   %eax,%eax
  8039ef:	74 1b                	je     803a0c <initialize_dynamic_allocator+0x147>
  8039f1:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  8039f7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8039fa:	89 c8                	mov    %ecx,%eax
  8039fc:	01 c0                	add    %eax,%eax
  8039fe:	01 c8                	add    %ecx,%eax
  803a00:	c1 e0 02             	shl    $0x2,%eax
  803a03:	05 60 60 80 00       	add    $0x806060,%eax
  803a08:	89 02                	mov    %eax,(%edx)
  803a0a:	eb 16                	jmp    803a22 <initialize_dynamic_allocator+0x15d>
  803a0c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a0f:	89 d0                	mov    %edx,%eax
  803a11:	01 c0                	add    %eax,%eax
  803a13:	01 d0                	add    %edx,%eax
  803a15:	c1 e0 02             	shl    $0x2,%eax
  803a18:	05 60 60 80 00       	add    $0x806060,%eax
  803a1d:	a3 48 60 80 00       	mov    %eax,0x806048
  803a22:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a25:	89 d0                	mov    %edx,%eax
  803a27:	01 c0                	add    %eax,%eax
  803a29:	01 d0                	add    %edx,%eax
  803a2b:	c1 e0 02             	shl    $0x2,%eax
  803a2e:	05 60 60 80 00       	add    $0x806060,%eax
  803a33:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803a38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a3b:	89 d0                	mov    %edx,%eax
  803a3d:	01 c0                	add    %eax,%eax
  803a3f:	01 d0                	add    %edx,%eax
  803a41:	c1 e0 02             	shl    $0x2,%eax
  803a44:	05 60 60 80 00       	add    $0x806060,%eax
  803a49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a4f:	a1 54 60 80 00       	mov    0x806054,%eax
  803a54:	40                   	inc    %eax
  803a55:	a3 54 60 80 00       	mov    %eax,0x806054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  803a5a:	ff 45 f0             	incl   -0x10(%ebp)
  803a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a60:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803a63:	0f 82 2c ff ff ff    	jb     803995 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803a69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803a6f:	eb 2f                	jmp    803aa0 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  803a71:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a74:	89 d0                	mov    %edx,%eax
  803a76:	01 c0                	add    %eax,%eax
  803a78:	01 d0                	add    %edx,%eax
  803a7a:	c1 e0 02             	shl    $0x2,%eax
  803a7d:	05 68 60 80 00       	add    $0x806068,%eax
  803a82:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  803a87:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a8a:	89 d0                	mov    %edx,%eax
  803a8c:	01 c0                	add    %eax,%eax
  803a8e:	01 d0                	add    %edx,%eax
  803a90:	c1 e0 02             	shl    $0x2,%eax
  803a93:	05 6a 60 80 00       	add    $0x80606a,%eax
  803a98:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803a9d:	ff 45 ec             	incl   -0x14(%ebp)
  803aa0:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  803aa7:	76 c8                	jbe    803a71 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803aa9:	90                   	nop
  803aaa:	c9                   	leave  
  803aab:	c3                   	ret    

00803aac <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803aac:	55                   	push   %ebp
  803aad:	89 e5                	mov    %esp,%ebp
  803aaf:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  803ab2:	8b 55 08             	mov    0x8(%ebp),%edx
  803ab5:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803aba:	29 c2                	sub    %eax,%edx
  803abc:	89 d0                	mov    %edx,%eax
  803abe:	c1 e8 0c             	shr    $0xc,%eax
  803ac1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  803ac4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803ac7:	89 d0                	mov    %edx,%eax
  803ac9:	01 c0                	add    %eax,%eax
  803acb:	01 d0                	add    %edx,%eax
  803acd:	c1 e0 02             	shl    $0x2,%eax
  803ad0:	05 68 60 80 00       	add    $0x806068,%eax
  803ad5:	8b 00                	mov    (%eax),%eax
  803ad7:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803ada:	c9                   	leave  
  803adb:	c3                   	ret    

00803adc <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803adc:	55                   	push   %ebp
  803add:	89 e5                	mov    %esp,%ebp
  803adf:	83 ec 14             	sub    $0x14,%esp
  803ae2:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  803ae5:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803ae9:	77 07                	ja     803af2 <nearest_pow2_ceil.1513+0x16>
  803aeb:	b8 01 00 00 00       	mov    $0x1,%eax
  803af0:	eb 20                	jmp    803b12 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  803af2:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  803af9:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  803afc:	eb 08                	jmp    803b06 <nearest_pow2_ceil.1513+0x2a>
  803afe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803b01:	01 c0                	add    %eax,%eax
  803b03:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803b06:	d1 6d 08             	shrl   0x8(%ebp)
  803b09:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b0d:	75 ef                	jne    803afe <nearest_pow2_ceil.1513+0x22>
        return power;
  803b0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803b12:	c9                   	leave  
  803b13:	c3                   	ret    

00803b14 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803b14:	55                   	push   %ebp
  803b15:	89 e5                	mov    %esp,%ebp
  803b17:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803b1a:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803b21:	76 16                	jbe    803b39 <alloc_block+0x25>
  803b23:	68 38 5b 80 00       	push   $0x805b38
  803b28:	68 22 5b 80 00       	push   $0x805b22
  803b2d:	6a 72                	push   $0x72
  803b2f:	68 bf 5a 80 00       	push   $0x805abf
  803b34:	e8 3e d6 ff ff       	call   801177 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  803b39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b3d:	75 0a                	jne    803b49 <alloc_block+0x35>
  803b3f:	b8 00 00 00 00       	mov    $0x0,%eax
  803b44:	e9 bd 04 00 00       	jmp    804006 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803b49:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  803b50:	8b 45 08             	mov    0x8(%ebp),%eax
  803b53:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803b56:	73 06                	jae    803b5e <alloc_block+0x4a>
        size = min_block_size;
  803b58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b5b:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  803b5e:	83 ec 0c             	sub    $0xc,%esp
  803b61:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803b64:	ff 75 08             	pushl  0x8(%ebp)
  803b67:	89 c1                	mov    %eax,%ecx
  803b69:	e8 6e ff ff ff       	call   803adc <nearest_pow2_ceil.1513>
  803b6e:	83 c4 10             	add    $0x10,%esp
  803b71:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  803b74:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b77:	83 ec 0c             	sub    $0xc,%esp
  803b7a:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803b7d:	52                   	push   %edx
  803b7e:	89 c1                	mov    %eax,%ecx
  803b80:	e8 83 04 00 00       	call   804008 <log2_ceil.1520>
  803b85:	83 c4 10             	add    $0x10,%esp
  803b88:	83 e8 03             	sub    $0x3,%eax
  803b8b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  803b8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b91:	c1 e0 04             	shl    $0x4,%eax
  803b94:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b99:	8b 00                	mov    (%eax),%eax
  803b9b:	85 c0                	test   %eax,%eax
  803b9d:	0f 84 d8 00 00 00    	je     803c7b <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803ba3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ba6:	c1 e0 04             	shl    $0x4,%eax
  803ba9:	05 80 e0 81 00       	add    $0x81e080,%eax
  803bae:	8b 00                	mov    (%eax),%eax
  803bb0:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803bb3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803bb7:	75 17                	jne    803bd0 <alloc_block+0xbc>
  803bb9:	83 ec 04             	sub    $0x4,%esp
  803bbc:	68 59 5b 80 00       	push   $0x805b59
  803bc1:	68 98 00 00 00       	push   $0x98
  803bc6:	68 bf 5a 80 00       	push   $0x805abf
  803bcb:	e8 a7 d5 ff ff       	call   801177 <_panic>
  803bd0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bd3:	8b 00                	mov    (%eax),%eax
  803bd5:	85 c0                	test   %eax,%eax
  803bd7:	74 10                	je     803be9 <alloc_block+0xd5>
  803bd9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bdc:	8b 00                	mov    (%eax),%eax
  803bde:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803be1:	8b 52 04             	mov    0x4(%edx),%edx
  803be4:	89 50 04             	mov    %edx,0x4(%eax)
  803be7:	eb 14                	jmp    803bfd <alloc_block+0xe9>
  803be9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bec:	8b 40 04             	mov    0x4(%eax),%eax
  803bef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bf2:	c1 e2 04             	shl    $0x4,%edx
  803bf5:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803bfb:	89 02                	mov    %eax,(%edx)
  803bfd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c00:	8b 40 04             	mov    0x4(%eax),%eax
  803c03:	85 c0                	test   %eax,%eax
  803c05:	74 0f                	je     803c16 <alloc_block+0x102>
  803c07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c0a:	8b 40 04             	mov    0x4(%eax),%eax
  803c0d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c10:	8b 12                	mov    (%edx),%edx
  803c12:	89 10                	mov    %edx,(%eax)
  803c14:	eb 13                	jmp    803c29 <alloc_block+0x115>
  803c16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c19:	8b 00                	mov    (%eax),%eax
  803c1b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c1e:	c1 e2 04             	shl    $0x4,%edx
  803c21:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803c27:	89 02                	mov    %eax,(%edx)
  803c29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c3f:	c1 e0 04             	shl    $0x4,%eax
  803c42:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803c47:	8b 00                	mov    (%eax),%eax
  803c49:	8d 50 ff             	lea    -0x1(%eax),%edx
  803c4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c4f:	c1 e0 04             	shl    $0x4,%eax
  803c52:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803c57:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803c59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c5c:	83 ec 0c             	sub    $0xc,%esp
  803c5f:	50                   	push   %eax
  803c60:	e8 12 fc ff ff       	call   803877 <to_page_info>
  803c65:	83 c4 10             	add    $0x10,%esp
  803c68:	89 c2                	mov    %eax,%edx
  803c6a:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803c6e:	48                   	dec    %eax
  803c6f:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  803c73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c76:	e9 8b 03 00 00       	jmp    804006 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  803c7b:	a1 48 60 80 00       	mov    0x806048,%eax
  803c80:	85 c0                	test   %eax,%eax
  803c82:	0f 84 64 02 00 00    	je     803eec <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  803c88:	a1 48 60 80 00       	mov    0x806048,%eax
  803c8d:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  803c90:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803c94:	75 17                	jne    803cad <alloc_block+0x199>
  803c96:	83 ec 04             	sub    $0x4,%esp
  803c99:	68 59 5b 80 00       	push   $0x805b59
  803c9e:	68 a0 00 00 00       	push   $0xa0
  803ca3:	68 bf 5a 80 00       	push   $0x805abf
  803ca8:	e8 ca d4 ff ff       	call   801177 <_panic>
  803cad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cb0:	8b 00                	mov    (%eax),%eax
  803cb2:	85 c0                	test   %eax,%eax
  803cb4:	74 10                	je     803cc6 <alloc_block+0x1b2>
  803cb6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cb9:	8b 00                	mov    (%eax),%eax
  803cbb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803cbe:	8b 52 04             	mov    0x4(%edx),%edx
  803cc1:	89 50 04             	mov    %edx,0x4(%eax)
  803cc4:	eb 0b                	jmp    803cd1 <alloc_block+0x1bd>
  803cc6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cc9:	8b 40 04             	mov    0x4(%eax),%eax
  803ccc:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803cd1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cd4:	8b 40 04             	mov    0x4(%eax),%eax
  803cd7:	85 c0                	test   %eax,%eax
  803cd9:	74 0f                	je     803cea <alloc_block+0x1d6>
  803cdb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cde:	8b 40 04             	mov    0x4(%eax),%eax
  803ce1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ce4:	8b 12                	mov    (%edx),%edx
  803ce6:	89 10                	mov    %edx,(%eax)
  803ce8:	eb 0a                	jmp    803cf4 <alloc_block+0x1e0>
  803cea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ced:	8b 00                	mov    (%eax),%eax
  803cef:	a3 48 60 80 00       	mov    %eax,0x806048
  803cf4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cf7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cfd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d07:	a1 54 60 80 00       	mov    0x806054,%eax
  803d0c:	48                   	dec    %eax
  803d0d:	a3 54 60 80 00       	mov    %eax,0x806054

        page_info_e->block_size = pow;
  803d12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d15:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d18:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  803d1c:	b8 00 10 00 00       	mov    $0x1000,%eax
  803d21:	99                   	cltd   
  803d22:	f7 7d e8             	idivl  -0x18(%ebp)
  803d25:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d28:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  803d2c:	83 ec 0c             	sub    $0xc,%esp
  803d2f:	ff 75 dc             	pushl  -0x24(%ebp)
  803d32:	e8 ce fa ff ff       	call   803805 <to_page_va>
  803d37:	83 c4 10             	add    $0x10,%esp
  803d3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  803d3d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803d40:	83 ec 0c             	sub    $0xc,%esp
  803d43:	50                   	push   %eax
  803d44:	e8 c0 ee ff ff       	call   802c09 <get_page>
  803d49:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  803d4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803d53:	e9 aa 00 00 00       	jmp    803e02 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  803d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d5b:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  803d5f:	89 c2                	mov    %eax,%edx
  803d61:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803d64:	01 d0                	add    %edx,%eax
  803d66:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  803d69:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d6d:	75 17                	jne    803d86 <alloc_block+0x272>
  803d6f:	83 ec 04             	sub    $0x4,%esp
  803d72:	68 78 5b 80 00       	push   $0x805b78
  803d77:	68 aa 00 00 00       	push   $0xaa
  803d7c:	68 bf 5a 80 00       	push   $0x805abf
  803d81:	e8 f1 d3 ff ff       	call   801177 <_panic>
  803d86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d89:	c1 e0 04             	shl    $0x4,%eax
  803d8c:	05 84 e0 81 00       	add    $0x81e084,%eax
  803d91:	8b 10                	mov    (%eax),%edx
  803d93:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d96:	89 50 04             	mov    %edx,0x4(%eax)
  803d99:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d9c:	8b 40 04             	mov    0x4(%eax),%eax
  803d9f:	85 c0                	test   %eax,%eax
  803da1:	74 14                	je     803db7 <alloc_block+0x2a3>
  803da3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803da6:	c1 e0 04             	shl    $0x4,%eax
  803da9:	05 84 e0 81 00       	add    $0x81e084,%eax
  803dae:	8b 00                	mov    (%eax),%eax
  803db0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803db3:	89 10                	mov    %edx,(%eax)
  803db5:	eb 11                	jmp    803dc8 <alloc_block+0x2b4>
  803db7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dba:	c1 e0 04             	shl    $0x4,%eax
  803dbd:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  803dc3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dc6:	89 02                	mov    %eax,(%edx)
  803dc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dcb:	c1 e0 04             	shl    $0x4,%eax
  803dce:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  803dd4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dd7:	89 02                	mov    %eax,(%edx)
  803dd9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ddc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803de2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803de5:	c1 e0 04             	shl    $0x4,%eax
  803de8:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803ded:	8b 00                	mov    (%eax),%eax
  803def:	8d 50 01             	lea    0x1(%eax),%edx
  803df2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803df5:	c1 e0 04             	shl    $0x4,%eax
  803df8:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803dfd:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  803dff:	ff 45 f4             	incl   -0xc(%ebp)
  803e02:	b8 00 10 00 00       	mov    $0x1000,%eax
  803e07:	99                   	cltd   
  803e08:	f7 7d e8             	idivl  -0x18(%ebp)
  803e0b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803e0e:	0f 8f 44 ff ff ff    	jg     803d58 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803e14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e17:	c1 e0 04             	shl    $0x4,%eax
  803e1a:	05 80 e0 81 00       	add    $0x81e080,%eax
  803e1f:	8b 00                	mov    (%eax),%eax
  803e21:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803e24:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803e28:	75 17                	jne    803e41 <alloc_block+0x32d>
  803e2a:	83 ec 04             	sub    $0x4,%esp
  803e2d:	68 59 5b 80 00       	push   $0x805b59
  803e32:	68 ae 00 00 00       	push   $0xae
  803e37:	68 bf 5a 80 00       	push   $0x805abf
  803e3c:	e8 36 d3 ff ff       	call   801177 <_panic>
  803e41:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803e44:	8b 00                	mov    (%eax),%eax
  803e46:	85 c0                	test   %eax,%eax
  803e48:	74 10                	je     803e5a <alloc_block+0x346>
  803e4a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803e4d:	8b 00                	mov    (%eax),%eax
  803e4f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803e52:	8b 52 04             	mov    0x4(%edx),%edx
  803e55:	89 50 04             	mov    %edx,0x4(%eax)
  803e58:	eb 14                	jmp    803e6e <alloc_block+0x35a>
  803e5a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803e5d:	8b 40 04             	mov    0x4(%eax),%eax
  803e60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e63:	c1 e2 04             	shl    $0x4,%edx
  803e66:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803e6c:	89 02                	mov    %eax,(%edx)
  803e6e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803e71:	8b 40 04             	mov    0x4(%eax),%eax
  803e74:	85 c0                	test   %eax,%eax
  803e76:	74 0f                	je     803e87 <alloc_block+0x373>
  803e78:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803e7b:	8b 40 04             	mov    0x4(%eax),%eax
  803e7e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803e81:	8b 12                	mov    (%edx),%edx
  803e83:	89 10                	mov    %edx,(%eax)
  803e85:	eb 13                	jmp    803e9a <alloc_block+0x386>
  803e87:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803e8a:	8b 00                	mov    (%eax),%eax
  803e8c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e8f:	c1 e2 04             	shl    $0x4,%edx
  803e92:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803e98:	89 02                	mov    %eax,(%edx)
  803e9a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803e9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ea3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ea6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ead:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eb0:	c1 e0 04             	shl    $0x4,%eax
  803eb3:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803eb8:	8b 00                	mov    (%eax),%eax
  803eba:	8d 50 ff             	lea    -0x1(%eax),%edx
  803ebd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ec0:	c1 e0 04             	shl    $0x4,%eax
  803ec3:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803ec8:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803eca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ecd:	83 ec 0c             	sub    $0xc,%esp
  803ed0:	50                   	push   %eax
  803ed1:	e8 a1 f9 ff ff       	call   803877 <to_page_info>
  803ed6:	83 c4 10             	add    $0x10,%esp
  803ed9:	89 c2                	mov    %eax,%edx
  803edb:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803edf:	48                   	dec    %eax
  803ee0:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  803ee4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ee7:	e9 1a 01 00 00       	jmp    804006 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  803eec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eef:	40                   	inc    %eax
  803ef0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803ef3:	e9 ed 00 00 00       	jmp    803fe5 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  803ef8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803efb:	c1 e0 04             	shl    $0x4,%eax
  803efe:	05 80 e0 81 00       	add    $0x81e080,%eax
  803f03:	8b 00                	mov    (%eax),%eax
  803f05:	85 c0                	test   %eax,%eax
  803f07:	0f 84 d5 00 00 00    	je     803fe2 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  803f0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f10:	c1 e0 04             	shl    $0x4,%eax
  803f13:	05 80 e0 81 00       	add    $0x81e080,%eax
  803f18:	8b 00                	mov    (%eax),%eax
  803f1a:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  803f1d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803f21:	75 17                	jne    803f3a <alloc_block+0x426>
  803f23:	83 ec 04             	sub    $0x4,%esp
  803f26:	68 59 5b 80 00       	push   $0x805b59
  803f2b:	68 b8 00 00 00       	push   $0xb8
  803f30:	68 bf 5a 80 00       	push   $0x805abf
  803f35:	e8 3d d2 ff ff       	call   801177 <_panic>
  803f3a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f3d:	8b 00                	mov    (%eax),%eax
  803f3f:	85 c0                	test   %eax,%eax
  803f41:	74 10                	je     803f53 <alloc_block+0x43f>
  803f43:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f46:	8b 00                	mov    (%eax),%eax
  803f48:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803f4b:	8b 52 04             	mov    0x4(%edx),%edx
  803f4e:	89 50 04             	mov    %edx,0x4(%eax)
  803f51:	eb 14                	jmp    803f67 <alloc_block+0x453>
  803f53:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f56:	8b 40 04             	mov    0x4(%eax),%eax
  803f59:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f5c:	c1 e2 04             	shl    $0x4,%edx
  803f5f:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803f65:	89 02                	mov    %eax,(%edx)
  803f67:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f6a:	8b 40 04             	mov    0x4(%eax),%eax
  803f6d:	85 c0                	test   %eax,%eax
  803f6f:	74 0f                	je     803f80 <alloc_block+0x46c>
  803f71:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f74:	8b 40 04             	mov    0x4(%eax),%eax
  803f77:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803f7a:	8b 12                	mov    (%edx),%edx
  803f7c:	89 10                	mov    %edx,(%eax)
  803f7e:	eb 13                	jmp    803f93 <alloc_block+0x47f>
  803f80:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f83:	8b 00                	mov    (%eax),%eax
  803f85:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f88:	c1 e2 04             	shl    $0x4,%edx
  803f8b:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803f91:	89 02                	mov    %eax,(%edx)
  803f93:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f9c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fa9:	c1 e0 04             	shl    $0x4,%eax
  803fac:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803fb1:	8b 00                	mov    (%eax),%eax
  803fb3:	8d 50 ff             	lea    -0x1(%eax),%edx
  803fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fb9:	c1 e0 04             	shl    $0x4,%eax
  803fbc:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803fc1:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  803fc3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803fc6:	83 ec 0c             	sub    $0xc,%esp
  803fc9:	50                   	push   %eax
  803fca:	e8 a8 f8 ff ff       	call   803877 <to_page_info>
  803fcf:	83 c4 10             	add    $0x10,%esp
  803fd2:	89 c2                	mov    %eax,%edx
  803fd4:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803fd8:	48                   	dec    %eax
  803fd9:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  803fdd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803fe0:	eb 24                	jmp    804006 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  803fe2:	ff 45 f0             	incl   -0x10(%ebp)
  803fe5:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  803fe9:	0f 8e 09 ff ff ff    	jle    803ef8 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  803fef:	83 ec 04             	sub    $0x4,%esp
  803ff2:	68 9b 5b 80 00       	push   $0x805b9b
  803ff7:	68 bf 00 00 00       	push   $0xbf
  803ffc:	68 bf 5a 80 00       	push   $0x805abf
  804001:	e8 71 d1 ff ff       	call   801177 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  804006:	c9                   	leave  
  804007:	c3                   	ret    

00804008 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  804008:	55                   	push   %ebp
  804009:	89 e5                	mov    %esp,%ebp
  80400b:	83 ec 14             	sub    $0x14,%esp
  80400e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  804011:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804015:	75 07                	jne    80401e <log2_ceil.1520+0x16>
  804017:	b8 00 00 00 00       	mov    $0x0,%eax
  80401c:	eb 1b                	jmp    804039 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  80401e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  804025:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  804028:	eb 06                	jmp    804030 <log2_ceil.1520+0x28>
            x >>= 1;
  80402a:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  80402d:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  804030:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804034:	75 f4                	jne    80402a <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  804036:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  804039:	c9                   	leave  
  80403a:	c3                   	ret    

0080403b <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  80403b:	55                   	push   %ebp
  80403c:	89 e5                	mov    %esp,%ebp
  80403e:	83 ec 14             	sub    $0x14,%esp
  804041:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  804044:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804048:	75 07                	jne    804051 <log2_ceil.1547+0x16>
  80404a:	b8 00 00 00 00       	mov    $0x0,%eax
  80404f:	eb 1b                	jmp    80406c <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  804051:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  804058:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  80405b:	eb 06                	jmp    804063 <log2_ceil.1547+0x28>
			x >>= 1;
  80405d:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  804060:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  804063:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804067:	75 f4                	jne    80405d <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  804069:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  80406c:	c9                   	leave  
  80406d:	c3                   	ret    

0080406e <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80406e:	55                   	push   %ebp
  80406f:	89 e5                	mov    %esp,%ebp
  804071:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  804074:	8b 55 08             	mov    0x8(%ebp),%edx
  804077:	a1 64 e0 81 00       	mov    0x81e064,%eax
  80407c:	39 c2                	cmp    %eax,%edx
  80407e:	72 0c                	jb     80408c <free_block+0x1e>
  804080:	8b 55 08             	mov    0x8(%ebp),%edx
  804083:	a1 40 60 80 00       	mov    0x806040,%eax
  804088:	39 c2                	cmp    %eax,%edx
  80408a:	72 19                	jb     8040a5 <free_block+0x37>
  80408c:	68 a0 5b 80 00       	push   $0x805ba0
  804091:	68 22 5b 80 00       	push   $0x805b22
  804096:	68 d0 00 00 00       	push   $0xd0
  80409b:	68 bf 5a 80 00       	push   $0x805abf
  8040a0:	e8 d2 d0 ff ff       	call   801177 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8040a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8040a9:	0f 84 42 03 00 00    	je     8043f1 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  8040af:	8b 55 08             	mov    0x8(%ebp),%edx
  8040b2:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8040b7:	39 c2                	cmp    %eax,%edx
  8040b9:	72 0c                	jb     8040c7 <free_block+0x59>
  8040bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8040be:	a1 40 60 80 00       	mov    0x806040,%eax
  8040c3:	39 c2                	cmp    %eax,%edx
  8040c5:	72 17                	jb     8040de <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  8040c7:	83 ec 04             	sub    $0x4,%esp
  8040ca:	68 d8 5b 80 00       	push   $0x805bd8
  8040cf:	68 e6 00 00 00       	push   $0xe6
  8040d4:	68 bf 5a 80 00       	push   $0x805abf
  8040d9:	e8 99 d0 ff ff       	call   801177 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  8040de:	8b 55 08             	mov    0x8(%ebp),%edx
  8040e1:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8040e6:	29 c2                	sub    %eax,%edx
  8040e8:	89 d0                	mov    %edx,%eax
  8040ea:	83 e0 07             	and    $0x7,%eax
  8040ed:	85 c0                	test   %eax,%eax
  8040ef:	74 17                	je     804108 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  8040f1:	83 ec 04             	sub    $0x4,%esp
  8040f4:	68 0c 5c 80 00       	push   $0x805c0c
  8040f9:	68 ea 00 00 00       	push   $0xea
  8040fe:	68 bf 5a 80 00       	push   $0x805abf
  804103:	e8 6f d0 ff ff       	call   801177 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  804108:	8b 45 08             	mov    0x8(%ebp),%eax
  80410b:	83 ec 0c             	sub    $0xc,%esp
  80410e:	50                   	push   %eax
  80410f:	e8 63 f7 ff ff       	call   803877 <to_page_info>
  804114:	83 c4 10             	add    $0x10,%esp
  804117:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  80411a:	83 ec 0c             	sub    $0xc,%esp
  80411d:	ff 75 08             	pushl  0x8(%ebp)
  804120:	e8 87 f9 ff ff       	call   803aac <get_block_size>
  804125:	83 c4 10             	add    $0x10,%esp
  804128:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  80412b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80412f:	75 17                	jne    804148 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  804131:	83 ec 04             	sub    $0x4,%esp
  804134:	68 38 5c 80 00       	push   $0x805c38
  804139:	68 f1 00 00 00       	push   $0xf1
  80413e:	68 bf 5a 80 00       	push   $0x805abf
  804143:	e8 2f d0 ff ff       	call   801177 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  804148:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80414b:	83 ec 0c             	sub    $0xc,%esp
  80414e:	8d 45 d0             	lea    -0x30(%ebp),%eax
  804151:	52                   	push   %edx
  804152:	89 c1                	mov    %eax,%ecx
  804154:	e8 e2 fe ff ff       	call   80403b <log2_ceil.1547>
  804159:	83 c4 10             	add    $0x10,%esp
  80415c:	83 e8 03             	sub    $0x3,%eax
  80415f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  804162:	8b 45 08             	mov    0x8(%ebp),%eax
  804165:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  804168:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80416c:	75 17                	jne    804185 <free_block+0x117>
  80416e:	83 ec 04             	sub    $0x4,%esp
  804171:	68 84 5c 80 00       	push   $0x805c84
  804176:	68 f6 00 00 00       	push   $0xf6
  80417b:	68 bf 5a 80 00       	push   $0x805abf
  804180:	e8 f2 cf ff ff       	call   801177 <_panic>
  804185:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804188:	c1 e0 04             	shl    $0x4,%eax
  80418b:	05 80 e0 81 00       	add    $0x81e080,%eax
  804190:	8b 10                	mov    (%eax),%edx
  804192:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804195:	89 10                	mov    %edx,(%eax)
  804197:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80419a:	8b 00                	mov    (%eax),%eax
  80419c:	85 c0                	test   %eax,%eax
  80419e:	74 15                	je     8041b5 <free_block+0x147>
  8041a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041a3:	c1 e0 04             	shl    $0x4,%eax
  8041a6:	05 80 e0 81 00       	add    $0x81e080,%eax
  8041ab:	8b 00                	mov    (%eax),%eax
  8041ad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8041b0:	89 50 04             	mov    %edx,0x4(%eax)
  8041b3:	eb 11                	jmp    8041c6 <free_block+0x158>
  8041b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041b8:	c1 e0 04             	shl    $0x4,%eax
  8041bb:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  8041c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8041c4:	89 02                	mov    %eax,(%edx)
  8041c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041c9:	c1 e0 04             	shl    $0x4,%eax
  8041cc:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  8041d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8041d5:	89 02                	mov    %eax,(%edx)
  8041d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8041da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041e4:	c1 e0 04             	shl    $0x4,%eax
  8041e7:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8041ec:	8b 00                	mov    (%eax),%eax
  8041ee:	8d 50 01             	lea    0x1(%eax),%edx
  8041f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041f4:	c1 e0 04             	shl    $0x4,%eax
  8041f7:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8041fc:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  8041fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804201:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804205:	40                   	inc    %eax
  804206:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804209:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  80420d:	8b 55 08             	mov    0x8(%ebp),%edx
  804210:	a1 64 e0 81 00       	mov    0x81e064,%eax
  804215:	29 c2                	sub    %eax,%edx
  804217:	89 d0                	mov    %edx,%eax
  804219:	c1 e8 0c             	shr    $0xc,%eax
  80421c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  80421f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804222:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804226:	0f b7 c8             	movzwl %ax,%ecx
  804229:	b8 00 10 00 00       	mov    $0x1000,%eax
  80422e:	99                   	cltd   
  80422f:	f7 7d e8             	idivl  -0x18(%ebp)
  804232:	39 c1                	cmp    %eax,%ecx
  804234:	0f 85 b8 01 00 00    	jne    8043f2 <free_block+0x384>
    	uint32 blocks_removed = 0;
  80423a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  804241:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804244:	c1 e0 04             	shl    $0x4,%eax
  804247:	05 80 e0 81 00       	add    $0x81e080,%eax
  80424c:	8b 00                	mov    (%eax),%eax
  80424e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  804251:	e9 d5 00 00 00       	jmp    80432b <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  804256:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804259:	8b 00                	mov    (%eax),%eax
  80425b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  80425e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804261:	a1 64 e0 81 00       	mov    0x81e064,%eax
  804266:	29 c2                	sub    %eax,%edx
  804268:	89 d0                	mov    %edx,%eax
  80426a:	c1 e8 0c             	shr    $0xc,%eax
  80426d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  804270:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804273:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  804276:	0f 85 a9 00 00 00    	jne    804325 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  80427c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804280:	75 17                	jne    804299 <free_block+0x22b>
  804282:	83 ec 04             	sub    $0x4,%esp
  804285:	68 59 5b 80 00       	push   $0x805b59
  80428a:	68 04 01 00 00       	push   $0x104
  80428f:	68 bf 5a 80 00       	push   $0x805abf
  804294:	e8 de ce ff ff       	call   801177 <_panic>
  804299:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80429c:	8b 00                	mov    (%eax),%eax
  80429e:	85 c0                	test   %eax,%eax
  8042a0:	74 10                	je     8042b2 <free_block+0x244>
  8042a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042a5:	8b 00                	mov    (%eax),%eax
  8042a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8042aa:	8b 52 04             	mov    0x4(%edx),%edx
  8042ad:	89 50 04             	mov    %edx,0x4(%eax)
  8042b0:	eb 14                	jmp    8042c6 <free_block+0x258>
  8042b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042b5:	8b 40 04             	mov    0x4(%eax),%eax
  8042b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8042bb:	c1 e2 04             	shl    $0x4,%edx
  8042be:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  8042c4:	89 02                	mov    %eax,(%edx)
  8042c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042c9:	8b 40 04             	mov    0x4(%eax),%eax
  8042cc:	85 c0                	test   %eax,%eax
  8042ce:	74 0f                	je     8042df <free_block+0x271>
  8042d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042d3:	8b 40 04             	mov    0x4(%eax),%eax
  8042d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8042d9:	8b 12                	mov    (%edx),%edx
  8042db:	89 10                	mov    %edx,(%eax)
  8042dd:	eb 13                	jmp    8042f2 <free_block+0x284>
  8042df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042e2:	8b 00                	mov    (%eax),%eax
  8042e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8042e7:	c1 e2 04             	shl    $0x4,%edx
  8042ea:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  8042f0:	89 02                	mov    %eax,(%edx)
  8042f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8042fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804305:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804308:	c1 e0 04             	shl    $0x4,%eax
  80430b:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804310:	8b 00                	mov    (%eax),%eax
  804312:	8d 50 ff             	lea    -0x1(%eax),%edx
  804315:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804318:	c1 e0 04             	shl    $0x4,%eax
  80431b:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804320:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  804322:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  804325:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804328:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  80432b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80432f:	0f 85 21 ff ff ff    	jne    804256 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  804335:	b8 00 10 00 00       	mov    $0x1000,%eax
  80433a:	99                   	cltd   
  80433b:	f7 7d e8             	idivl  -0x18(%ebp)
  80433e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  804341:	74 17                	je     80435a <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  804343:	83 ec 04             	sub    $0x4,%esp
  804346:	68 a8 5c 80 00       	push   $0x805ca8
  80434b:	68 0c 01 00 00       	push   $0x10c
  804350:	68 bf 5a 80 00       	push   $0x805abf
  804355:	e8 1d ce ff ff       	call   801177 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  80435a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80435d:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  804363:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804366:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  80436c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804370:	75 17                	jne    804389 <free_block+0x31b>
  804372:	83 ec 04             	sub    $0x4,%esp
  804375:	68 78 5b 80 00       	push   $0x805b78
  80437a:	68 11 01 00 00       	push   $0x111
  80437f:	68 bf 5a 80 00       	push   $0x805abf
  804384:	e8 ee cd ff ff       	call   801177 <_panic>
  804389:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  80438f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804392:	89 50 04             	mov    %edx,0x4(%eax)
  804395:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804398:	8b 40 04             	mov    0x4(%eax),%eax
  80439b:	85 c0                	test   %eax,%eax
  80439d:	74 0c                	je     8043ab <free_block+0x33d>
  80439f:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8043a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8043a7:	89 10                	mov    %edx,(%eax)
  8043a9:	eb 08                	jmp    8043b3 <free_block+0x345>
  8043ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043ae:	a3 48 60 80 00       	mov    %eax,0x806048
  8043b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043b6:	a3 4c 60 80 00       	mov    %eax,0x80604c
  8043bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8043c4:	a1 54 60 80 00       	mov    0x806054,%eax
  8043c9:	40                   	inc    %eax
  8043ca:	a3 54 60 80 00       	mov    %eax,0x806054

        uint32 pp = to_page_va(page_info_e);
  8043cf:	83 ec 0c             	sub    $0xc,%esp
  8043d2:	ff 75 ec             	pushl  -0x14(%ebp)
  8043d5:	e8 2b f4 ff ff       	call   803805 <to_page_va>
  8043da:	83 c4 10             	add    $0x10,%esp
  8043dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  8043e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8043e3:	83 ec 0c             	sub    $0xc,%esp
  8043e6:	50                   	push   %eax
  8043e7:	e8 69 e8 ff ff       	call   802c55 <return_page>
  8043ec:	83 c4 10             	add    $0x10,%esp
  8043ef:	eb 01                	jmp    8043f2 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8043f1:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8043f2:	c9                   	leave  
  8043f3:	c3                   	ret    

008043f4 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  8043f4:	55                   	push   %ebp
  8043f5:	89 e5                	mov    %esp,%ebp
  8043f7:	83 ec 14             	sub    $0x14,%esp
  8043fa:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  8043fd:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  804401:	77 07                	ja     80440a <nearest_pow2_ceil.1572+0x16>
      return 1;
  804403:	b8 01 00 00 00       	mov    $0x1,%eax
  804408:	eb 20                	jmp    80442a <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  80440a:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  804411:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  804414:	eb 08                	jmp    80441e <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  804416:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804419:	01 c0                	add    %eax,%eax
  80441b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  80441e:	d1 6d 08             	shrl   0x8(%ebp)
  804421:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804425:	75 ef                	jne    804416 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  804427:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  80442a:	c9                   	leave  
  80442b:	c3                   	ret    

0080442c <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  80442c:	55                   	push   %ebp
  80442d:	89 e5                	mov    %esp,%ebp
  80442f:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  804432:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804436:	75 13                	jne    80444b <realloc_block+0x1f>
    return alloc_block(new_size);
  804438:	83 ec 0c             	sub    $0xc,%esp
  80443b:	ff 75 0c             	pushl  0xc(%ebp)
  80443e:	e8 d1 f6 ff ff       	call   803b14 <alloc_block>
  804443:	83 c4 10             	add    $0x10,%esp
  804446:	e9 d9 00 00 00       	jmp    804524 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  80444b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80444f:	75 18                	jne    804469 <realloc_block+0x3d>
    free_block(va);
  804451:	83 ec 0c             	sub    $0xc,%esp
  804454:	ff 75 08             	pushl  0x8(%ebp)
  804457:	e8 12 fc ff ff       	call   80406e <free_block>
  80445c:	83 c4 10             	add    $0x10,%esp
    return NULL;
  80445f:	b8 00 00 00 00       	mov    $0x0,%eax
  804464:	e9 bb 00 00 00       	jmp    804524 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  804469:	83 ec 0c             	sub    $0xc,%esp
  80446c:	ff 75 08             	pushl  0x8(%ebp)
  80446f:	e8 38 f6 ff ff       	call   803aac <get_block_size>
  804474:	83 c4 10             	add    $0x10,%esp
  804477:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  80447a:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  804481:	8b 45 0c             	mov    0xc(%ebp),%eax
  804484:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  804487:	73 06                	jae    80448f <realloc_block+0x63>
    new_size = min_block_size;
  804489:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80448c:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  80448f:	83 ec 0c             	sub    $0xc,%esp
  804492:	8d 45 d8             	lea    -0x28(%ebp),%eax
  804495:	ff 75 0c             	pushl  0xc(%ebp)
  804498:	89 c1                	mov    %eax,%ecx
  80449a:	e8 55 ff ff ff       	call   8043f4 <nearest_pow2_ceil.1572>
  80449f:	83 c4 10             	add    $0x10,%esp
  8044a2:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  8044a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044a8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8044ab:	75 05                	jne    8044b2 <realloc_block+0x86>
    return va;
  8044ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8044b0:	eb 72                	jmp    804524 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  8044b2:	83 ec 0c             	sub    $0xc,%esp
  8044b5:	ff 75 0c             	pushl  0xc(%ebp)
  8044b8:	e8 57 f6 ff ff       	call   803b14 <alloc_block>
  8044bd:	83 c4 10             	add    $0x10,%esp
  8044c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  8044c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8044c7:	75 07                	jne    8044d0 <realloc_block+0xa4>
    return NULL;
  8044c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8044ce:	eb 54                	jmp    804524 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  8044d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8044d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8044d6:	39 d0                	cmp    %edx,%eax
  8044d8:	76 02                	jbe    8044dc <realloc_block+0xb0>
  8044da:	89 d0                	mov    %edx,%eax
  8044dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  8044df:	8b 45 08             	mov    0x8(%ebp),%eax
  8044e2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  8044e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8044e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  8044eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8044f2:	eb 17                	jmp    80450b <realloc_block+0xdf>
    dst[i] = src[i];
  8044f4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8044f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044fa:	01 c2                	add    %eax,%edx
  8044fc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8044ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804502:	01 c8                	add    %ecx,%eax
  804504:	8a 00                	mov    (%eax),%al
  804506:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  804508:	ff 45 f4             	incl   -0xc(%ebp)
  80450b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80450e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804511:	72 e1                	jb     8044f4 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  804513:	83 ec 0c             	sub    $0xc,%esp
  804516:	ff 75 08             	pushl  0x8(%ebp)
  804519:	e8 50 fb ff ff       	call   80406e <free_block>
  80451e:	83 c4 10             	add    $0x10,%esp

  return new_va;
  804521:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  804524:	c9                   	leave  
  804525:	c3                   	ret    

00804526 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  804526:	55                   	push   %ebp
  804527:	89 e5                	mov    %esp,%ebp
  804529:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  80452c:	83 ec 04             	sub    $0x4,%esp
  80452f:	68 dc 5c 80 00       	push   $0x805cdc
  804534:	6a 07                	push   $0x7
  804536:	68 0b 5d 80 00       	push   $0x805d0b
  80453b:	e8 37 cc ff ff       	call   801177 <_panic>

00804540 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  804540:	55                   	push   %ebp
  804541:	89 e5                	mov    %esp,%ebp
  804543:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  804546:	83 ec 04             	sub    $0x4,%esp
  804549:	68 1c 5d 80 00       	push   $0x805d1c
  80454e:	6a 0b                	push   $0xb
  804550:	68 0b 5d 80 00       	push   $0x805d0b
  804555:	e8 1d cc ff ff       	call   801177 <_panic>

0080455a <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  80455a:	55                   	push   %ebp
  80455b:	89 e5                	mov    %esp,%ebp
  80455d:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  804560:	83 ec 04             	sub    $0x4,%esp
  804563:	68 48 5d 80 00       	push   $0x805d48
  804568:	6a 10                	push   $0x10
  80456a:	68 0b 5d 80 00       	push   $0x805d0b
  80456f:	e8 03 cc ff ff       	call   801177 <_panic>

00804574 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  804574:	55                   	push   %ebp
  804575:	89 e5                	mov    %esp,%ebp
  804577:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  80457a:	83 ec 04             	sub    $0x4,%esp
  80457d:	68 78 5d 80 00       	push   $0x805d78
  804582:	6a 15                	push   $0x15
  804584:	68 0b 5d 80 00       	push   $0x805d0b
  804589:	e8 e9 cb ff ff       	call   801177 <_panic>

0080458e <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  80458e:	55                   	push   %ebp
  80458f:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  804591:	8b 45 08             	mov    0x8(%ebp),%eax
  804594:	8b 40 10             	mov    0x10(%eax),%eax
}
  804597:	5d                   	pop    %ebp
  804598:	c3                   	ret    

00804599 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  804599:	55                   	push   %ebp
  80459a:	89 e5                	mov    %esp,%ebp
  80459c:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80459f:	8b 55 08             	mov    0x8(%ebp),%edx
  8045a2:	89 d0                	mov    %edx,%eax
  8045a4:	c1 e0 02             	shl    $0x2,%eax
  8045a7:	01 d0                	add    %edx,%eax
  8045a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8045b0:	01 d0                	add    %edx,%eax
  8045b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8045b9:	01 d0                	add    %edx,%eax
  8045bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8045c2:	01 d0                	add    %edx,%eax
  8045c4:	c1 e0 04             	shl    $0x4,%eax
  8045c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  8045ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8045d1:	0f 31                	rdtsc  
  8045d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8045d6:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8045d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8045dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8045df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8045e2:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8045e5:	eb 46                	jmp    80462d <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8045e7:	0f 31                	rdtsc  
  8045e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8045ec:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8045ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8045f2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8045f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8045f8:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8045fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8045fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804601:	29 c2                	sub    %eax,%edx
  804603:	89 d0                	mov    %edx,%eax
  804605:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  804608:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80460b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80460e:	89 d1                	mov    %edx,%ecx
  804610:	29 c1                	sub    %eax,%ecx
  804612:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804615:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804618:	39 c2                	cmp    %eax,%edx
  80461a:	0f 97 c0             	seta   %al
  80461d:	0f b6 c0             	movzbl %al,%eax
  804620:	29 c1                	sub    %eax,%ecx
  804622:	89 c8                	mov    %ecx,%eax
  804624:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  804627:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80462a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  80462d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804630:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  804633:	72 b2                	jb     8045e7 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  804635:	90                   	nop
  804636:	c9                   	leave  
  804637:	c3                   	ret    

00804638 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  804638:	55                   	push   %ebp
  804639:	89 e5                	mov    %esp,%ebp
  80463b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80463e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  804645:	eb 03                	jmp    80464a <busy_wait+0x12>
  804647:	ff 45 fc             	incl   -0x4(%ebp)
  80464a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80464d:	3b 45 08             	cmp    0x8(%ebp),%eax
  804650:	72 f5                	jb     804647 <busy_wait+0xf>
	return i;
  804652:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  804655:	c9                   	leave  
  804656:	c3                   	ret    
  804657:	90                   	nop

00804658 <__udivdi3>:
  804658:	55                   	push   %ebp
  804659:	57                   	push   %edi
  80465a:	56                   	push   %esi
  80465b:	53                   	push   %ebx
  80465c:	83 ec 1c             	sub    $0x1c,%esp
  80465f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804663:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804667:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80466b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80466f:	89 ca                	mov    %ecx,%edx
  804671:	89 f8                	mov    %edi,%eax
  804673:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804677:	85 f6                	test   %esi,%esi
  804679:	75 2d                	jne    8046a8 <__udivdi3+0x50>
  80467b:	39 cf                	cmp    %ecx,%edi
  80467d:	77 65                	ja     8046e4 <__udivdi3+0x8c>
  80467f:	89 fd                	mov    %edi,%ebp
  804681:	85 ff                	test   %edi,%edi
  804683:	75 0b                	jne    804690 <__udivdi3+0x38>
  804685:	b8 01 00 00 00       	mov    $0x1,%eax
  80468a:	31 d2                	xor    %edx,%edx
  80468c:	f7 f7                	div    %edi
  80468e:	89 c5                	mov    %eax,%ebp
  804690:	31 d2                	xor    %edx,%edx
  804692:	89 c8                	mov    %ecx,%eax
  804694:	f7 f5                	div    %ebp
  804696:	89 c1                	mov    %eax,%ecx
  804698:	89 d8                	mov    %ebx,%eax
  80469a:	f7 f5                	div    %ebp
  80469c:	89 cf                	mov    %ecx,%edi
  80469e:	89 fa                	mov    %edi,%edx
  8046a0:	83 c4 1c             	add    $0x1c,%esp
  8046a3:	5b                   	pop    %ebx
  8046a4:	5e                   	pop    %esi
  8046a5:	5f                   	pop    %edi
  8046a6:	5d                   	pop    %ebp
  8046a7:	c3                   	ret    
  8046a8:	39 ce                	cmp    %ecx,%esi
  8046aa:	77 28                	ja     8046d4 <__udivdi3+0x7c>
  8046ac:	0f bd fe             	bsr    %esi,%edi
  8046af:	83 f7 1f             	xor    $0x1f,%edi
  8046b2:	75 40                	jne    8046f4 <__udivdi3+0x9c>
  8046b4:	39 ce                	cmp    %ecx,%esi
  8046b6:	72 0a                	jb     8046c2 <__udivdi3+0x6a>
  8046b8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8046bc:	0f 87 9e 00 00 00    	ja     804760 <__udivdi3+0x108>
  8046c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8046c7:	89 fa                	mov    %edi,%edx
  8046c9:	83 c4 1c             	add    $0x1c,%esp
  8046cc:	5b                   	pop    %ebx
  8046cd:	5e                   	pop    %esi
  8046ce:	5f                   	pop    %edi
  8046cf:	5d                   	pop    %ebp
  8046d0:	c3                   	ret    
  8046d1:	8d 76 00             	lea    0x0(%esi),%esi
  8046d4:	31 ff                	xor    %edi,%edi
  8046d6:	31 c0                	xor    %eax,%eax
  8046d8:	89 fa                	mov    %edi,%edx
  8046da:	83 c4 1c             	add    $0x1c,%esp
  8046dd:	5b                   	pop    %ebx
  8046de:	5e                   	pop    %esi
  8046df:	5f                   	pop    %edi
  8046e0:	5d                   	pop    %ebp
  8046e1:	c3                   	ret    
  8046e2:	66 90                	xchg   %ax,%ax
  8046e4:	89 d8                	mov    %ebx,%eax
  8046e6:	f7 f7                	div    %edi
  8046e8:	31 ff                	xor    %edi,%edi
  8046ea:	89 fa                	mov    %edi,%edx
  8046ec:	83 c4 1c             	add    $0x1c,%esp
  8046ef:	5b                   	pop    %ebx
  8046f0:	5e                   	pop    %esi
  8046f1:	5f                   	pop    %edi
  8046f2:	5d                   	pop    %ebp
  8046f3:	c3                   	ret    
  8046f4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8046f9:	89 eb                	mov    %ebp,%ebx
  8046fb:	29 fb                	sub    %edi,%ebx
  8046fd:	89 f9                	mov    %edi,%ecx
  8046ff:	d3 e6                	shl    %cl,%esi
  804701:	89 c5                	mov    %eax,%ebp
  804703:	88 d9                	mov    %bl,%cl
  804705:	d3 ed                	shr    %cl,%ebp
  804707:	89 e9                	mov    %ebp,%ecx
  804709:	09 f1                	or     %esi,%ecx
  80470b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80470f:	89 f9                	mov    %edi,%ecx
  804711:	d3 e0                	shl    %cl,%eax
  804713:	89 c5                	mov    %eax,%ebp
  804715:	89 d6                	mov    %edx,%esi
  804717:	88 d9                	mov    %bl,%cl
  804719:	d3 ee                	shr    %cl,%esi
  80471b:	89 f9                	mov    %edi,%ecx
  80471d:	d3 e2                	shl    %cl,%edx
  80471f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804723:	88 d9                	mov    %bl,%cl
  804725:	d3 e8                	shr    %cl,%eax
  804727:	09 c2                	or     %eax,%edx
  804729:	89 d0                	mov    %edx,%eax
  80472b:	89 f2                	mov    %esi,%edx
  80472d:	f7 74 24 0c          	divl   0xc(%esp)
  804731:	89 d6                	mov    %edx,%esi
  804733:	89 c3                	mov    %eax,%ebx
  804735:	f7 e5                	mul    %ebp
  804737:	39 d6                	cmp    %edx,%esi
  804739:	72 19                	jb     804754 <__udivdi3+0xfc>
  80473b:	74 0b                	je     804748 <__udivdi3+0xf0>
  80473d:	89 d8                	mov    %ebx,%eax
  80473f:	31 ff                	xor    %edi,%edi
  804741:	e9 58 ff ff ff       	jmp    80469e <__udivdi3+0x46>
  804746:	66 90                	xchg   %ax,%ax
  804748:	8b 54 24 08          	mov    0x8(%esp),%edx
  80474c:	89 f9                	mov    %edi,%ecx
  80474e:	d3 e2                	shl    %cl,%edx
  804750:	39 c2                	cmp    %eax,%edx
  804752:	73 e9                	jae    80473d <__udivdi3+0xe5>
  804754:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804757:	31 ff                	xor    %edi,%edi
  804759:	e9 40 ff ff ff       	jmp    80469e <__udivdi3+0x46>
  80475e:	66 90                	xchg   %ax,%ax
  804760:	31 c0                	xor    %eax,%eax
  804762:	e9 37 ff ff ff       	jmp    80469e <__udivdi3+0x46>
  804767:	90                   	nop

00804768 <__umoddi3>:
  804768:	55                   	push   %ebp
  804769:	57                   	push   %edi
  80476a:	56                   	push   %esi
  80476b:	53                   	push   %ebx
  80476c:	83 ec 1c             	sub    $0x1c,%esp
  80476f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804773:	8b 74 24 34          	mov    0x34(%esp),%esi
  804777:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80477b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80477f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804783:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804787:	89 f3                	mov    %esi,%ebx
  804789:	89 fa                	mov    %edi,%edx
  80478b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80478f:	89 34 24             	mov    %esi,(%esp)
  804792:	85 c0                	test   %eax,%eax
  804794:	75 1a                	jne    8047b0 <__umoddi3+0x48>
  804796:	39 f7                	cmp    %esi,%edi
  804798:	0f 86 a2 00 00 00    	jbe    804840 <__umoddi3+0xd8>
  80479e:	89 c8                	mov    %ecx,%eax
  8047a0:	89 f2                	mov    %esi,%edx
  8047a2:	f7 f7                	div    %edi
  8047a4:	89 d0                	mov    %edx,%eax
  8047a6:	31 d2                	xor    %edx,%edx
  8047a8:	83 c4 1c             	add    $0x1c,%esp
  8047ab:	5b                   	pop    %ebx
  8047ac:	5e                   	pop    %esi
  8047ad:	5f                   	pop    %edi
  8047ae:	5d                   	pop    %ebp
  8047af:	c3                   	ret    
  8047b0:	39 f0                	cmp    %esi,%eax
  8047b2:	0f 87 ac 00 00 00    	ja     804864 <__umoddi3+0xfc>
  8047b8:	0f bd e8             	bsr    %eax,%ebp
  8047bb:	83 f5 1f             	xor    $0x1f,%ebp
  8047be:	0f 84 ac 00 00 00    	je     804870 <__umoddi3+0x108>
  8047c4:	bf 20 00 00 00       	mov    $0x20,%edi
  8047c9:	29 ef                	sub    %ebp,%edi
  8047cb:	89 fe                	mov    %edi,%esi
  8047cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8047d1:	89 e9                	mov    %ebp,%ecx
  8047d3:	d3 e0                	shl    %cl,%eax
  8047d5:	89 d7                	mov    %edx,%edi
  8047d7:	89 f1                	mov    %esi,%ecx
  8047d9:	d3 ef                	shr    %cl,%edi
  8047db:	09 c7                	or     %eax,%edi
  8047dd:	89 e9                	mov    %ebp,%ecx
  8047df:	d3 e2                	shl    %cl,%edx
  8047e1:	89 14 24             	mov    %edx,(%esp)
  8047e4:	89 d8                	mov    %ebx,%eax
  8047e6:	d3 e0                	shl    %cl,%eax
  8047e8:	89 c2                	mov    %eax,%edx
  8047ea:	8b 44 24 08          	mov    0x8(%esp),%eax
  8047ee:	d3 e0                	shl    %cl,%eax
  8047f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8047f4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8047f8:	89 f1                	mov    %esi,%ecx
  8047fa:	d3 e8                	shr    %cl,%eax
  8047fc:	09 d0                	or     %edx,%eax
  8047fe:	d3 eb                	shr    %cl,%ebx
  804800:	89 da                	mov    %ebx,%edx
  804802:	f7 f7                	div    %edi
  804804:	89 d3                	mov    %edx,%ebx
  804806:	f7 24 24             	mull   (%esp)
  804809:	89 c6                	mov    %eax,%esi
  80480b:	89 d1                	mov    %edx,%ecx
  80480d:	39 d3                	cmp    %edx,%ebx
  80480f:	0f 82 87 00 00 00    	jb     80489c <__umoddi3+0x134>
  804815:	0f 84 91 00 00 00    	je     8048ac <__umoddi3+0x144>
  80481b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80481f:	29 f2                	sub    %esi,%edx
  804821:	19 cb                	sbb    %ecx,%ebx
  804823:	89 d8                	mov    %ebx,%eax
  804825:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804829:	d3 e0                	shl    %cl,%eax
  80482b:	89 e9                	mov    %ebp,%ecx
  80482d:	d3 ea                	shr    %cl,%edx
  80482f:	09 d0                	or     %edx,%eax
  804831:	89 e9                	mov    %ebp,%ecx
  804833:	d3 eb                	shr    %cl,%ebx
  804835:	89 da                	mov    %ebx,%edx
  804837:	83 c4 1c             	add    $0x1c,%esp
  80483a:	5b                   	pop    %ebx
  80483b:	5e                   	pop    %esi
  80483c:	5f                   	pop    %edi
  80483d:	5d                   	pop    %ebp
  80483e:	c3                   	ret    
  80483f:	90                   	nop
  804840:	89 fd                	mov    %edi,%ebp
  804842:	85 ff                	test   %edi,%edi
  804844:	75 0b                	jne    804851 <__umoddi3+0xe9>
  804846:	b8 01 00 00 00       	mov    $0x1,%eax
  80484b:	31 d2                	xor    %edx,%edx
  80484d:	f7 f7                	div    %edi
  80484f:	89 c5                	mov    %eax,%ebp
  804851:	89 f0                	mov    %esi,%eax
  804853:	31 d2                	xor    %edx,%edx
  804855:	f7 f5                	div    %ebp
  804857:	89 c8                	mov    %ecx,%eax
  804859:	f7 f5                	div    %ebp
  80485b:	89 d0                	mov    %edx,%eax
  80485d:	e9 44 ff ff ff       	jmp    8047a6 <__umoddi3+0x3e>
  804862:	66 90                	xchg   %ax,%ax
  804864:	89 c8                	mov    %ecx,%eax
  804866:	89 f2                	mov    %esi,%edx
  804868:	83 c4 1c             	add    $0x1c,%esp
  80486b:	5b                   	pop    %ebx
  80486c:	5e                   	pop    %esi
  80486d:	5f                   	pop    %edi
  80486e:	5d                   	pop    %ebp
  80486f:	c3                   	ret    
  804870:	3b 04 24             	cmp    (%esp),%eax
  804873:	72 06                	jb     80487b <__umoddi3+0x113>
  804875:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804879:	77 0f                	ja     80488a <__umoddi3+0x122>
  80487b:	89 f2                	mov    %esi,%edx
  80487d:	29 f9                	sub    %edi,%ecx
  80487f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804883:	89 14 24             	mov    %edx,(%esp)
  804886:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80488a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80488e:	8b 14 24             	mov    (%esp),%edx
  804891:	83 c4 1c             	add    $0x1c,%esp
  804894:	5b                   	pop    %ebx
  804895:	5e                   	pop    %esi
  804896:	5f                   	pop    %edi
  804897:	5d                   	pop    %ebp
  804898:	c3                   	ret    
  804899:	8d 76 00             	lea    0x0(%esi),%esi
  80489c:	2b 04 24             	sub    (%esp),%eax
  80489f:	19 fa                	sbb    %edi,%edx
  8048a1:	89 d1                	mov    %edx,%ecx
  8048a3:	89 c6                	mov    %eax,%esi
  8048a5:	e9 71 ff ff ff       	jmp    80481b <__umoddi3+0xb3>
  8048aa:	66 90                	xchg   %ax,%ax
  8048ac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8048b0:	72 ea                	jb     80489c <__umoddi3+0x134>
  8048b2:	89 d9                	mov    %ebx,%ecx
  8048b4:	e9 62 ff ff ff       	jmp    80481b <__umoddi3+0xb3>
