
obj/user/arrayOperations_stats:     file format elf32-i386


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
  800031:	e8 b3 07 00 00       	call   8007e9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <Swap>:
//Functions Declarations
void Swap(int *Elements, int First, int Second);
void PrintElements(int *Elements, int NumOfElements);

void Swap(int *Elements, int First, int Second)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80003e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800041:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800048:	8b 45 08             	mov    0x8(%ebp),%eax
  80004b:	01 d0                	add    %edx,%eax
  80004d:	8b 00                	mov    (%eax),%eax
  80004f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800052:	8b 45 0c             	mov    0xc(%ebp),%eax
  800055:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80005c:	8b 45 08             	mov    0x8(%ebp),%eax
  80005f:	01 c2                	add    %eax,%edx
  800061:	8b 45 10             	mov    0x10(%ebp),%eax
  800064:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80006b:	8b 45 08             	mov    0x8(%ebp),%eax
  80006e:	01 c8                	add    %ecx,%eax
  800070:	8b 00                	mov    (%eax),%eax
  800072:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800074:	8b 45 10             	mov    0x10(%ebp),%eax
  800077:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80007e:	8b 45 08             	mov    0x8(%ebp),%eax
  800081:	01 c2                	add    %eax,%edx
  800083:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800086:	89 02                	mov    %eax,(%edx)
}
  800088:	90                   	nop
  800089:	c9                   	leave  
  80008a:	c3                   	ret    

0080008b <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80008b:	55                   	push   %ebp
  80008c:	89 e5                	mov    %esp,%ebp
  80008e:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800091:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800098:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80009f:	eb 42                	jmp    8000e3 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  8000a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a4:	99                   	cltd   
  8000a5:	f7 7d f0             	idivl  -0x10(%ebp)
  8000a8:	89 d0                	mov    %edx,%eax
  8000aa:	85 c0                	test   %eax,%eax
  8000ac:	75 10                	jne    8000be <PrintElements+0x33>
			cprintf("\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 20 3f 80 00       	push   $0x803f20
  8000b6:	e8 be 09 00 00       	call   800a79 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8000be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8000cb:	01 d0                	add    %edx,%eax
  8000cd:	8b 00                	mov    (%eax),%eax
  8000cf:	83 ec 08             	sub    $0x8,%esp
  8000d2:	50                   	push   %eax
  8000d3:	68 22 3f 80 00       	push   $0x803f22
  8000d8:	e8 9c 09 00 00       	call   800a79 <cprintf>
  8000dd:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8000e0:	ff 45 f4             	incl   -0xc(%ebp)
  8000e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000e6:	48                   	dec    %eax
  8000e7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000ea:	7f b5                	jg     8000a1 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8000ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8000f9:	01 d0                	add    %edx,%eax
  8000fb:	8b 00                	mov    (%eax),%eax
  8000fd:	83 ec 08             	sub    $0x8,%esp
  800100:	50                   	push   %eax
  800101:	68 27 3f 80 00       	push   $0x803f27
  800106:	e8 6e 09 00 00       	call   800a79 <cprintf>
  80010b:	83 c4 10             	add    $0x10,%esp

}
  80010e:	90                   	nop
  80010f:	c9                   	leave  
  800110:	c3                   	ret    

00800111 <_main>:
void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var, int *min, int *max, int *med);
int KthElement(int *Elements, int NumOfElements, int k);
int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex);

void _main(void)
{
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	57                   	push   %edi
  800115:	56                   	push   %esi
  800116:	53                   	push   %ebx
  800117:	81 ec dc 01 00 00    	sub    $0x1dc,%esp
	int32 envID = sys_getenvid();
  80011d:	e8 13 28 00 00       	call   802935 <sys_getenvid>
  800122:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800125:	e8 3d 28 00 00       	call   802967 <sys_getparentenvid>
  80012a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
#endif

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
#if USE_KERN_SEMAPHORE
	char waitCmd1[64] = "__KSem@0@Wait";
  80012d:	8d 85 78 ff ff ff    	lea    -0x88(%ebp),%eax
  800133:	bb e0 3f 80 00       	mov    $0x803fe0,%ebx
  800138:	ba 0e 00 00 00       	mov    $0xe,%edx
  80013d:	89 c7                	mov    %eax,%edi
  80013f:	89 de                	mov    %ebx,%esi
  800141:	89 d1                	mov    %edx,%ecx
  800143:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800145:	8d 55 86             	lea    -0x7a(%ebp),%edx
  800148:	b9 32 00 00 00       	mov    $0x32,%ecx
  80014d:	b0 00                	mov    $0x0,%al
  80014f:	89 d7                	mov    %edx,%edi
  800151:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd1, 0);
  800153:	83 ec 08             	sub    $0x8,%esp
  800156:	6a 00                	push   $0x0
  800158:	8d 85 78 ff ff ff    	lea    -0x88(%ebp),%eax
  80015e:	50                   	push   %eax
  80015f:	e8 20 2a 00 00       	call   802b84 <sys_utilities>
  800164:	83 c4 10             	add    $0x10,%esp
	wait_semaphore(ready);
#endif

	/*[3] GET SHARED VARs*/
	//Get the cons_mutex ownerID
	int* consMutexOwnerID = sget(parentenvID, "cons_mutex ownerID") ;
  800167:	83 ec 08             	sub    $0x8,%esp
  80016a:	68 2b 3f 80 00       	push   $0x803f2b
  80016f:	ff 75 dc             	pushl  -0x24(%ebp)
  800172:	e8 4d 23 00 00       	call   8024c4 <sget>
  800177:	83 c4 10             	add    $0x10,%esp
  80017a:	89 45 d8             	mov    %eax,-0x28(%ebp)
#else
	struct semaphore cons_mutex = get_semaphore(*consMutexOwnerID, "Console Mutex");
#endif

	//Get the shared array & its size
	int *numOfElements = NULL;
  80017d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	int *sharedArray = NULL;
  800184:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  80018b:	83 ec 08             	sub    $0x8,%esp
  80018e:	68 3e 3f 80 00       	push   $0x803f3e
  800193:	ff 75 dc             	pushl  -0x24(%ebp)
  800196:	e8 29 23 00 00       	call   8024c4 <sget>
  80019b:	83 c4 10             	add    $0x10,%esp
  80019e:	89 45 d0             	mov    %eax,-0x30(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	68 42 3f 80 00       	push   $0x803f42
  8001a9:	ff 75 dc             	pushl  -0x24(%ebp)
  8001ac:	e8 13 23 00 00       	call   8024c4 <sget>
  8001b1:	83 c4 10             	add    $0x10,%esp
  8001b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int max ;
	int med ;

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
  8001b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001ba:	8b 00                	mov    (%eax),%eax
  8001bc:	c1 e0 02             	shl    $0x2,%eax
  8001bf:	83 ec 04             	sub    $0x4,%esp
  8001c2:	6a 00                	push   $0x0
  8001c4:	50                   	push   %eax
  8001c5:	68 4a 3f 80 00       	push   $0x803f4a
  8001ca:	e8 95 21 00 00       	call   802364 <smalloc>
  8001cf:	83 c4 10             	add    $0x10,%esp
  8001d2:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8001d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001dc:	eb 25                	jmp    800203 <_main+0xf2>
	{
		tmpArray[i] = sharedArray[i];
  8001de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001e8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001eb:	01 c2                	add    %eax,%edx
  8001ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001f0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001fa:	01 c8                	add    %ecx,%eax
  8001fc:	8b 00                	mov    (%eax),%eax
  8001fe:	89 02                	mov    %eax,(%edx)

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  800200:	ff 45 e4             	incl   -0x1c(%ebp)
  800203:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800206:	8b 00                	mov    (%eax),%eax
  800208:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80020b:	7f d1                	jg     8001de <_main+0xcd>
	{
		tmpArray[i] = sharedArray[i];
	}

	ArrayStats(tmpArray ,*numOfElements, &mean, &var, &min, &max, &med);
  80020d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800210:	8b 00                	mov    (%eax),%eax
  800212:	83 ec 04             	sub    $0x4,%esp
  800215:	8d 95 5c ff ff ff    	lea    -0xa4(%ebp),%edx
  80021b:	52                   	push   %edx
  80021c:	8d 95 60 ff ff ff    	lea    -0xa0(%ebp),%edx
  800222:	52                   	push   %edx
  800223:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
  800229:	52                   	push   %edx
  80022a:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  800230:	52                   	push   %edx
  800231:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  800237:	52                   	push   %edx
  800238:	50                   	push   %eax
  800239:	ff 75 cc             	pushl  -0x34(%ebp)
  80023c:	e8 c2 03 00 00       	call   800603 <ArrayStats>
  800241:	83 c4 20             	add    $0x20,%esp

#if USE_KERN_SEMAPHORE
	char waitCmd2[64] = "__KSem@2@Wait";
  800244:	8d 85 1c ff ff ff    	lea    -0xe4(%ebp),%eax
  80024a:	bb 20 40 80 00       	mov    $0x804020,%ebx
  80024f:	ba 0e 00 00 00       	mov    $0xe,%edx
  800254:	89 c7                	mov    %eax,%edi
  800256:	89 de                	mov    %ebx,%esi
  800258:	89 d1                	mov    %edx,%ecx
  80025a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80025c:	8d 95 2a ff ff ff    	lea    -0xd6(%ebp),%edx
  800262:	b9 32 00 00 00       	mov    $0x32,%ecx
  800267:	b0 00                	mov    $0x0,%al
  800269:	89 d7                	mov    %edx,%edi
  80026b:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd2, 0);
  80026d:	83 ec 08             	sub    $0x8,%esp
  800270:	6a 00                	push   $0x0
  800272:	8d 85 1c ff ff ff    	lea    -0xe4(%ebp),%eax
  800278:	50                   	push   %eax
  800279:	e8 06 29 00 00       	call   802b84 <sys_utilities>
  80027e:	83 c4 10             	add    $0x10,%esp
#else
	wait_semaphore(cons_mutex);
#endif
	{
		cprintf("Stats Calculations are Finished!!!!\n") ;
  800281:	83 ec 0c             	sub    $0xc,%esp
  800284:	68 54 3f 80 00       	push   $0x803f54
  800289:	e8 eb 07 00 00       	call   800a79 <cprintf>
  80028e:	83 c4 10             	add    $0x10,%esp
		cprintf("will share the results & notify the master now...\n");
  800291:	83 ec 0c             	sub    $0xc,%esp
  800294:	68 7c 3f 80 00       	push   $0x803f7c
  800299:	e8 db 07 00 00       	call   800a79 <cprintf>
  80029e:	83 c4 10             	add    $0x10,%esp
	}
#if USE_KERN_SEMAPHORE
	char signalCmd1[64] = "__KSem@2@Signal";
  8002a1:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  8002a7:	bb 60 40 80 00       	mov    $0x804060,%ebx
  8002ac:	ba 04 00 00 00       	mov    $0x4,%edx
  8002b1:	89 c7                	mov    %eax,%edi
  8002b3:	89 de                	mov    %ebx,%esi
  8002b5:	89 d1                	mov    %edx,%ecx
  8002b7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8002b9:	8d 95 ec fe ff ff    	lea    -0x114(%ebp),%edx
  8002bf:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8002c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c9:	89 d7                	mov    %edx,%edi
  8002cb:	f3 ab                	rep stos %eax,%es:(%edi)
	sys_utilities(signalCmd1, 0);
  8002cd:	83 ec 08             	sub    $0x8,%esp
  8002d0:	6a 00                	push   $0x0
  8002d2:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  8002d8:	50                   	push   %eax
  8002d9:	e8 a6 28 00 00       	call   802b84 <sys_utilities>
  8002de:	83 c4 10             	add    $0x10,%esp
#endif

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int64 *shMean, *shVar;
	int *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int64), 0) ; *shMean = mean;
  8002e1:	83 ec 04             	sub    $0x4,%esp
  8002e4:	6a 00                	push   $0x0
  8002e6:	6a 08                	push   $0x8
  8002e8:	68 af 3f 80 00       	push   $0x803faf
  8002ed:	e8 72 20 00 00       	call   802364 <smalloc>
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8002f8:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8002fe:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  800304:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800307:	89 01                	mov    %eax,(%ecx)
  800309:	89 51 04             	mov    %edx,0x4(%ecx)
	shVar = smalloc("var", sizeof(int64), 0) ; *shVar = var;
  80030c:	83 ec 04             	sub    $0x4,%esp
  80030f:	6a 00                	push   $0x0
  800311:	6a 08                	push   $0x8
  800313:	68 b4 3f 80 00       	push   $0x803fb4
  800318:	e8 47 20 00 00       	call   802364 <smalloc>
  80031d:	83 c4 10             	add    $0x10,%esp
  800320:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800323:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800329:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  80032f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800332:	89 01                	mov    %eax,(%ecx)
  800334:	89 51 04             	mov    %edx,0x4(%ecx)
	shMin = smalloc("min", sizeof(int), 0) ; *shMin = min;
  800337:	83 ec 04             	sub    $0x4,%esp
  80033a:	6a 00                	push   $0x0
  80033c:	6a 04                	push   $0x4
  80033e:	68 b8 3f 80 00       	push   $0x803fb8
  800343:	e8 1c 20 00 00       	call   802364 <smalloc>
  800348:	83 c4 10             	add    $0x10,%esp
  80034b:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80034e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  800354:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800357:	89 10                	mov    %edx,(%eax)
	shMax = smalloc("max", sizeof(int), 0) ; *shMax = max;
  800359:	83 ec 04             	sub    $0x4,%esp
  80035c:	6a 00                	push   $0x0
  80035e:	6a 04                	push   $0x4
  800360:	68 bc 3f 80 00       	push   $0x803fbc
  800365:	e8 fa 1f 00 00       	call   802364 <smalloc>
  80036a:	83 c4 10             	add    $0x10,%esp
  80036d:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800370:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800376:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800379:	89 10                	mov    %edx,(%eax)
	shMed = smalloc("med", sizeof(int), 0) ; *shMed = med;
  80037b:	83 ec 04             	sub    $0x4,%esp
  80037e:	6a 00                	push   $0x0
  800380:	6a 04                	push   $0x4
  800382:	68 c0 3f 80 00       	push   $0x803fc0
  800387:	e8 d8 1f 00 00       	call   802364 <smalloc>
  80038c:	83 c4 10             	add    $0x10,%esp
  80038f:	89 45 b8             	mov    %eax,-0x48(%ebp)
  800392:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  800398:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80039b:	89 10                	mov    %edx,(%eax)

#if USE_KERN_SEMAPHORE
	char waitCmd3[64] = "__KSem@2@Wait";
  80039d:	8d 85 9c fe ff ff    	lea    -0x164(%ebp),%eax
  8003a3:	bb 20 40 80 00       	mov    $0x804020,%ebx
  8003a8:	ba 0e 00 00 00       	mov    $0xe,%edx
  8003ad:	89 c7                	mov    %eax,%edi
  8003af:	89 de                	mov    %ebx,%esi
  8003b1:	89 d1                	mov    %edx,%ecx
  8003b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8003b5:	8d 95 aa fe ff ff    	lea    -0x156(%ebp),%edx
  8003bb:	b9 32 00 00 00       	mov    $0x32,%ecx
  8003c0:	b0 00                	mov    $0x0,%al
  8003c2:	89 d7                	mov    %edx,%edi
  8003c4:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd3, 0);
  8003c6:	83 ec 08             	sub    $0x8,%esp
  8003c9:	6a 00                	push   $0x0
  8003cb:	8d 85 9c fe ff ff    	lea    -0x164(%ebp),%eax
  8003d1:	50                   	push   %eax
  8003d2:	e8 ad 27 00 00       	call   802b84 <sys_utilities>
  8003d7:	83 c4 10             	add    $0x10,%esp
#else
	wait_semaphore(cons_mutex);
#endif
	{
		cprintf("Stats app says GOOD BYE :)\n") ;
  8003da:	83 ec 0c             	sub    $0xc,%esp
  8003dd:	68 c4 3f 80 00       	push   $0x803fc4
  8003e2:	e8 92 06 00 00       	call   800a79 <cprintf>
  8003e7:	83 c4 10             	add    $0x10,%esp
	}
#if USE_KERN_SEMAPHORE
	char signalCmd3[64] = "__KSem@2@Signal";
  8003ea:	8d 85 5c fe ff ff    	lea    -0x1a4(%ebp),%eax
  8003f0:	bb 60 40 80 00       	mov    $0x804060,%ebx
  8003f5:	ba 04 00 00 00       	mov    $0x4,%edx
  8003fa:	89 c7                	mov    %eax,%edi
  8003fc:	89 de                	mov    %ebx,%esi
  8003fe:	89 d1                	mov    %edx,%ecx
  800400:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800402:	8d 95 6c fe ff ff    	lea    -0x194(%ebp),%edx
  800408:	b9 0c 00 00 00       	mov    $0xc,%ecx
  80040d:	b8 00 00 00 00       	mov    $0x0,%eax
  800412:	89 d7                	mov    %edx,%edi
  800414:	f3 ab                	rep stos %eax,%es:(%edi)
	sys_utilities(signalCmd3, 0);
  800416:	83 ec 08             	sub    $0x8,%esp
  800419:	6a 00                	push   $0x0
  80041b:	8d 85 5c fe ff ff    	lea    -0x1a4(%ebp),%eax
  800421:	50                   	push   %eax
  800422:	e8 5d 27 00 00       	call   802b84 <sys_utilities>
  800427:	83 c4 10             	add    $0x10,%esp
#else
	signal_semaphore(cons_mutex);
#endif

#if USE_KERN_SEMAPHORE
	char signalCmd2[64] = "__KSem@1@Signal";
  80042a:	8d 85 1c fe ff ff    	lea    -0x1e4(%ebp),%eax
  800430:	bb a0 40 80 00       	mov    $0x8040a0,%ebx
  800435:	ba 04 00 00 00       	mov    $0x4,%edx
  80043a:	89 c7                	mov    %eax,%edi
  80043c:	89 de                	mov    %ebx,%esi
  80043e:	89 d1                	mov    %edx,%ecx
  800440:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800442:	8d 95 2c fe ff ff    	lea    -0x1d4(%ebp),%edx
  800448:	b9 0c 00 00 00       	mov    $0xc,%ecx
  80044d:	b8 00 00 00 00       	mov    $0x0,%eax
  800452:	89 d7                	mov    %edx,%edi
  800454:	f3 ab                	rep stos %eax,%es:(%edi)
	sys_utilities(signalCmd2, 0);
  800456:	83 ec 08             	sub    $0x8,%esp
  800459:	6a 00                	push   $0x0
  80045b:	8d 85 1c fe ff ff    	lea    -0x1e4(%ebp),%eax
  800461:	50                   	push   %eax
  800462:	e8 1d 27 00 00       	call   802b84 <sys_utilities>
  800467:	83 c4 10             	add    $0x10,%esp
#else
	signal_semaphore(finished);
#endif
}
  80046a:	90                   	nop
  80046b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80046e:	5b                   	pop    %ebx
  80046f:	5e                   	pop    %esi
  800470:	5f                   	pop    %edi
  800471:	5d                   	pop    %ebp
  800472:	c3                   	ret    

00800473 <KthElement>:



///Kth Element
int KthElement(int *Elements, int NumOfElements, int k)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 08             	sub    $0x8,%esp
	return QSort(Elements, NumOfElements, 0, NumOfElements-1, k-1) ;
  800479:	8b 45 10             	mov    0x10(%ebp),%eax
  80047c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80047f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800482:	48                   	dec    %eax
  800483:	83 ec 0c             	sub    $0xc,%esp
  800486:	52                   	push   %edx
  800487:	50                   	push   %eax
  800488:	6a 00                	push   $0x0
  80048a:	ff 75 0c             	pushl  0xc(%ebp)
  80048d:	ff 75 08             	pushl  0x8(%ebp)
  800490:	e8 05 00 00 00       	call   80049a <QSort>
  800495:	83 c4 20             	add    $0x20,%esp
}
  800498:	c9                   	leave  
  800499:	c3                   	ret    

0080049a <QSort>:


int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex)
{
  80049a:	55                   	push   %ebp
  80049b:	89 e5                	mov    %esp,%ebp
  80049d:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return Elements[finalIndex];
  8004a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a3:	3b 45 14             	cmp    0x14(%ebp),%eax
  8004a6:	7c 16                	jl     8004be <QSort+0x24>
  8004a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	01 d0                	add    %edx,%eax
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	e9 43 01 00 00       	jmp    800601 <QSort+0x167>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8004be:	0f 31                	rdtsc  
  8004c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004c3:	89 55 e0             	mov    %edx,-0x20(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8004c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004cf:	89 55 e8             	mov    %edx,-0x18(%ebp)

	int pvtIndex = RANDU(startIndex, finalIndex) ;
  8004d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004d5:	8b 55 14             	mov    0x14(%ebp),%edx
  8004d8:	2b 55 10             	sub    0x10(%ebp),%edx
  8004db:	89 d1                	mov    %edx,%ecx
  8004dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e2:	f7 f1                	div    %ecx
  8004e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e7:	01 d0                	add    %edx,%eax
  8004e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  8004ec:	ff 75 ec             	pushl  -0x14(%ebp)
  8004ef:	ff 75 10             	pushl  0x10(%ebp)
  8004f2:	ff 75 08             	pushl  0x8(%ebp)
  8004f5:	e8 3e fb ff ff       	call   800038 <Swap>
  8004fa:	83 c4 0c             	add    $0xc,%esp

	int i = startIndex+1, j = finalIndex;
  8004fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800500:	40                   	inc    %eax
  800501:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800504:	8b 45 14             	mov    0x14(%ebp),%eax
  800507:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  80050a:	eb 7d                	jmp    800589 <QSort+0xef>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  80050c:	ff 45 f4             	incl   -0xc(%ebp)
  80050f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800512:	3b 45 14             	cmp    0x14(%ebp),%eax
  800515:	7f 2b                	jg     800542 <QSort+0xa8>
  800517:	8b 45 10             	mov    0x10(%ebp),%eax
  80051a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800521:	8b 45 08             	mov    0x8(%ebp),%eax
  800524:	01 d0                	add    %edx,%eax
  800526:	8b 10                	mov    (%eax),%edx
  800528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80052b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800532:	8b 45 08             	mov    0x8(%ebp),%eax
  800535:	01 c8                	add    %ecx,%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	39 c2                	cmp    %eax,%edx
  80053b:	7d cf                	jge    80050c <QSort+0x72>
		while (j > startIndex && Elements[startIndex] < Elements[j]) j--;
  80053d:	eb 03                	jmp    800542 <QSort+0xa8>
  80053f:	ff 4d f0             	decl   -0x10(%ebp)
  800542:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800545:	3b 45 10             	cmp    0x10(%ebp),%eax
  800548:	7e 26                	jle    800570 <QSort+0xd6>
  80054a:	8b 45 10             	mov    0x10(%ebp),%eax
  80054d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800554:	8b 45 08             	mov    0x8(%ebp),%eax
  800557:	01 d0                	add    %edx,%eax
  800559:	8b 10                	mov    (%eax),%edx
  80055b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80055e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800565:	8b 45 08             	mov    0x8(%ebp),%eax
  800568:	01 c8                	add    %ecx,%eax
  80056a:	8b 00                	mov    (%eax),%eax
  80056c:	39 c2                	cmp    %eax,%edx
  80056e:	7c cf                	jl     80053f <QSort+0xa5>

		if (i <= j)
  800570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800573:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800576:	7f 11                	jg     800589 <QSort+0xef>
		{
			Swap(Elements, i, j);
  800578:	ff 75 f0             	pushl  -0x10(%ebp)
  80057b:	ff 75 f4             	pushl  -0xc(%ebp)
  80057e:	ff 75 08             	pushl  0x8(%ebp)
  800581:	e8 b2 fa ff ff       	call   800038 <Swap>
  800586:	83 c4 0c             	add    $0xc,%esp
	int pvtIndex = RANDU(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80058c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80058f:	0f 8e 7a ff ff ff    	jle    80050f <QSort+0x75>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800595:	ff 75 f0             	pushl  -0x10(%ebp)
  800598:	ff 75 10             	pushl  0x10(%ebp)
  80059b:	ff 75 08             	pushl  0x8(%ebp)
  80059e:	e8 95 fa ff ff       	call   800038 <Swap>
  8005a3:	83 c4 0c             	add    $0xc,%esp

	if (kIndex == j)
  8005a6:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005ac:	75 13                	jne    8005c1 <QSort+0x127>
		return Elements[kIndex] ;
  8005ae:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bb:	01 d0                	add    %edx,%eax
  8005bd:	8b 00                	mov    (%eax),%eax
  8005bf:	eb 40                	jmp    800601 <QSort+0x167>
	else if (kIndex < j)
  8005c1:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005c7:	7d 1e                	jge    8005e7 <QSort+0x14d>
		return QSort(Elements, NumOfElements, startIndex, j - 1, kIndex);
  8005c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005cc:	48                   	dec    %eax
  8005cd:	83 ec 0c             	sub    $0xc,%esp
  8005d0:	ff 75 18             	pushl  0x18(%ebp)
  8005d3:	50                   	push   %eax
  8005d4:	ff 75 10             	pushl  0x10(%ebp)
  8005d7:	ff 75 0c             	pushl  0xc(%ebp)
  8005da:	ff 75 08             	pushl  0x8(%ebp)
  8005dd:	e8 b8 fe ff ff       	call   80049a <QSort>
  8005e2:	83 c4 20             	add    $0x20,%esp
  8005e5:	eb 1a                	jmp    800601 <QSort+0x167>
	else
		return QSort(Elements, NumOfElements, i, finalIndex, kIndex);
  8005e7:	83 ec 0c             	sub    $0xc,%esp
  8005ea:	ff 75 18             	pushl  0x18(%ebp)
  8005ed:	ff 75 14             	pushl  0x14(%ebp)
  8005f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f3:	ff 75 0c             	pushl  0xc(%ebp)
  8005f6:	ff 75 08             	pushl  0x8(%ebp)
  8005f9:	e8 9c fe ff ff       	call   80049a <QSort>
  8005fe:	83 c4 20             	add    $0x20,%esp
}
  800601:	c9                   	leave  
  800602:	c3                   	ret    

00800603 <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var, int *min, int *max, int *med)
{
  800603:	55                   	push   %ebp
  800604:	89 e5                	mov    %esp,%ebp
  800606:	57                   	push   %edi
  800607:	56                   	push   %esi
  800608:	53                   	push   %ebx
  800609:	83 ec 2c             	sub    $0x2c,%esp
	int i ;
	*mean =0 ;
  80060c:	8b 45 10             	mov    0x10(%ebp),%eax
  80060f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800615:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	*min = 0x7FFFFFFF ;
  80061c:	8b 45 18             	mov    0x18(%ebp),%eax
  80061f:	c7 00 ff ff ff 7f    	movl   $0x7fffffff,(%eax)
	*max = 0x80000000 ;
  800625:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800628:	c7 00 00 00 00 80    	movl   $0x80000000,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  80062e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800635:	e9 89 00 00 00       	jmp    8006c3 <ArrayStats+0xc0>
	{
		(*mean) += Elements[i];
  80063a:	8b 45 10             	mov    0x10(%ebp),%eax
  80063d:	8b 08                	mov    (%eax),%ecx
  80063f:	8b 58 04             	mov    0x4(%eax),%ebx
  800642:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800645:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80064c:	8b 45 08             	mov    0x8(%ebp),%eax
  80064f:	01 d0                	add    %edx,%eax
  800651:	8b 00                	mov    (%eax),%eax
  800653:	99                   	cltd   
  800654:	01 c8                	add    %ecx,%eax
  800656:	11 da                	adc    %ebx,%edx
  800658:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80065b:	89 01                	mov    %eax,(%ecx)
  80065d:	89 51 04             	mov    %edx,0x4(%ecx)
		if (Elements[i] < (*min))
  800660:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800663:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80066a:	8b 45 08             	mov    0x8(%ebp),%eax
  80066d:	01 d0                	add    %edx,%eax
  80066f:	8b 10                	mov    (%eax),%edx
  800671:	8b 45 18             	mov    0x18(%ebp),%eax
  800674:	8b 00                	mov    (%eax),%eax
  800676:	39 c2                	cmp    %eax,%edx
  800678:	7d 16                	jge    800690 <ArrayStats+0x8d>
		{
			(*min) = Elements[i];
  80067a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80067d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800684:	8b 45 08             	mov    0x8(%ebp),%eax
  800687:	01 d0                	add    %edx,%eax
  800689:	8b 10                	mov    (%eax),%edx
  80068b:	8b 45 18             	mov    0x18(%ebp),%eax
  80068e:	89 10                	mov    %edx,(%eax)
		}
		if (Elements[i] > (*max))
  800690:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800693:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	01 d0                	add    %edx,%eax
  80069f:	8b 10                	mov    (%eax),%edx
  8006a1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	39 c2                	cmp    %eax,%edx
  8006a8:	7e 16                	jle    8006c0 <ArrayStats+0xbd>
		{
			(*max) = Elements[i];
  8006aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b7:	01 d0                	add    %edx,%eax
  8006b9:	8b 10                	mov    (%eax),%edx
  8006bb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006be:	89 10                	mov    %edx,(%eax)
{
	int i ;
	*mean =0 ;
	*min = 0x7FFFFFFF ;
	*max = 0x80000000 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006c0:	ff 45 e4             	incl   -0x1c(%ebp)
  8006c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006c9:	0f 8c 6b ff ff ff    	jl     80063a <ArrayStats+0x37>
		{
			(*max) = Elements[i];
		}
	}

	(*med) = KthElement(Elements, NumOfElements, (NumOfElements+1)/2);
  8006cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d2:	40                   	inc    %eax
  8006d3:	89 c2                	mov    %eax,%edx
  8006d5:	c1 ea 1f             	shr    $0x1f,%edx
  8006d8:	01 d0                	add    %edx,%eax
  8006da:	d1 f8                	sar    %eax
  8006dc:	83 ec 04             	sub    $0x4,%esp
  8006df:	50                   	push   %eax
  8006e0:	ff 75 0c             	pushl  0xc(%ebp)
  8006e3:	ff 75 08             	pushl  0x8(%ebp)
  8006e6:	e8 88 fd ff ff       	call   800473 <KthElement>
  8006eb:	83 c4 10             	add    $0x10,%esp
  8006ee:	89 c2                	mov    %eax,%edx
  8006f0:	8b 45 20             	mov    0x20(%ebp),%eax
  8006f3:	89 10                	mov    %edx,(%eax)

	(*mean) /= NumOfElements;
  8006f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8006f8:	8b 50 04             	mov    0x4(%eax),%edx
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800700:	89 cb                	mov    %ecx,%ebx
  800702:	c1 fb 1f             	sar    $0x1f,%ebx
  800705:	53                   	push   %ebx
  800706:	51                   	push   %ecx
  800707:	52                   	push   %edx
  800708:	50                   	push   %eax
  800709:	e8 32 34 00 00       	call   803b40 <__divdi3>
  80070e:	83 c4 10             	add    $0x10,%esp
  800711:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800714:	89 01                	mov    %eax,(%ecx)
  800716:	89 51 04             	mov    %edx,0x4(%ecx)
	(*var) = 0;
  800719:	8b 45 14             	mov    0x14(%ebp),%eax
  80071c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800722:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800729:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800730:	eb 7e                	jmp    8007b0 <ArrayStats+0x1ad>
	{
		(*var) += (int64)((Elements[i] - (*mean))*(Elements[i] - (*mean)));
  800732:	8b 45 14             	mov    0x14(%ebp),%eax
  800735:	8b 50 04             	mov    0x4(%eax),%edx
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80073d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800740:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800743:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	01 d0                	add    %edx,%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	89 c1                	mov    %eax,%ecx
  800753:	89 c3                	mov    %eax,%ebx
  800755:	c1 fb 1f             	sar    $0x1f,%ebx
  800758:	8b 45 10             	mov    0x10(%ebp),%eax
  80075b:	8b 50 04             	mov    0x4(%eax),%edx
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	29 c1                	sub    %eax,%ecx
  800762:	19 d3                	sbb    %edx,%ebx
  800764:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800767:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	01 d0                	add    %edx,%eax
  800773:	8b 00                	mov    (%eax),%eax
  800775:	89 c6                	mov    %eax,%esi
  800777:	89 c7                	mov    %eax,%edi
  800779:	c1 ff 1f             	sar    $0x1f,%edi
  80077c:	8b 45 10             	mov    0x10(%ebp),%eax
  80077f:	8b 50 04             	mov    0x4(%eax),%edx
  800782:	8b 00                	mov    (%eax),%eax
  800784:	29 c6                	sub    %eax,%esi
  800786:	19 d7                	sbb    %edx,%edi
  800788:	89 f0                	mov    %esi,%eax
  80078a:	89 fa                	mov    %edi,%edx
  80078c:	89 df                	mov    %ebx,%edi
  80078e:	0f af f8             	imul   %eax,%edi
  800791:	89 d6                	mov    %edx,%esi
  800793:	0f af f1             	imul   %ecx,%esi
  800796:	01 fe                	add    %edi,%esi
  800798:	f7 e1                	mul    %ecx
  80079a:	8d 0c 16             	lea    (%esi,%edx,1),%ecx
  80079d:	89 ca                	mov    %ecx,%edx
  80079f:	03 45 d0             	add    -0x30(%ebp),%eax
  8007a2:	13 55 d4             	adc    -0x2c(%ebp),%edx
  8007a5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8007a8:	89 01                	mov    %eax,(%ecx)
  8007aa:	89 51 04             	mov    %edx,0x4(%ecx)

	(*med) = KthElement(Elements, NumOfElements, (NumOfElements+1)/2);

	(*mean) /= NumOfElements;
	(*var) = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  8007ad:	ff 45 e4             	incl   -0x1c(%ebp)
  8007b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007b3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8007b6:	0f 8c 76 ff ff ff    	jl     800732 <ArrayStats+0x12f>
	{
		(*var) += (int64)((Elements[i] - (*mean))*(Elements[i] - (*mean)));
	}
	(*var) /= NumOfElements;
  8007bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bf:	8b 50 04             	mov    0x4(%eax),%edx
  8007c2:	8b 00                	mov    (%eax),%eax
  8007c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007c7:	89 cb                	mov    %ecx,%ebx
  8007c9:	c1 fb 1f             	sar    $0x1f,%ebx
  8007cc:	53                   	push   %ebx
  8007cd:	51                   	push   %ecx
  8007ce:	52                   	push   %edx
  8007cf:	50                   	push   %eax
  8007d0:	e8 6b 33 00 00       	call   803b40 <__divdi3>
  8007d5:	83 c4 10             	add    $0x10,%esp
  8007d8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8007db:	89 01                	mov    %eax,(%ecx)
  8007dd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8007e0:	90                   	nop
  8007e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007e4:	5b                   	pop    %ebx
  8007e5:	5e                   	pop    %esi
  8007e6:	5f                   	pop    %edi
  8007e7:	5d                   	pop    %ebp
  8007e8:	c3                   	ret    

008007e9 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8007e9:	55                   	push   %ebp
  8007ea:	89 e5                	mov    %esp,%ebp
  8007ec:	57                   	push   %edi
  8007ed:	56                   	push   %esi
  8007ee:	53                   	push   %ebx
  8007ef:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8007f2:	e8 57 21 00 00       	call   80294e <sys_getenvindex>
  8007f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8007fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007fd:	89 d0                	mov    %edx,%eax
  8007ff:	01 c0                	add    %eax,%eax
  800801:	01 d0                	add    %edx,%eax
  800803:	c1 e0 02             	shl    $0x2,%eax
  800806:	01 d0                	add    %edx,%eax
  800808:	c1 e0 02             	shl    $0x2,%eax
  80080b:	01 d0                	add    %edx,%eax
  80080d:	c1 e0 03             	shl    $0x3,%eax
  800810:	01 d0                	add    %edx,%eax
  800812:	c1 e0 02             	shl    $0x2,%eax
  800815:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80081a:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80081f:	a1 20 50 80 00       	mov    0x805020,%eax
  800824:	8a 40 20             	mov    0x20(%eax),%al
  800827:	84 c0                	test   %al,%al
  800829:	74 0d                	je     800838 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80082b:	a1 20 50 80 00       	mov    0x805020,%eax
  800830:	83 c0 20             	add    $0x20,%eax
  800833:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800838:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80083c:	7e 0a                	jle    800848 <libmain+0x5f>
		binaryname = argv[0];
  80083e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800841:	8b 00                	mov    (%eax),%eax
  800843:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800848:	83 ec 08             	sub    $0x8,%esp
  80084b:	ff 75 0c             	pushl  0xc(%ebp)
  80084e:	ff 75 08             	pushl  0x8(%ebp)
  800851:	e8 bb f8 ff ff       	call   800111 <_main>
  800856:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800859:	a1 00 50 80 00       	mov    0x805000,%eax
  80085e:	85 c0                	test   %eax,%eax
  800860:	0f 84 01 01 00 00    	je     800967 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800866:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80086c:	bb d8 41 80 00       	mov    $0x8041d8,%ebx
  800871:	ba 0e 00 00 00       	mov    $0xe,%edx
  800876:	89 c7                	mov    %eax,%edi
  800878:	89 de                	mov    %ebx,%esi
  80087a:	89 d1                	mov    %edx,%ecx
  80087c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80087e:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800881:	b9 56 00 00 00       	mov    $0x56,%ecx
  800886:	b0 00                	mov    $0x0,%al
  800888:	89 d7                	mov    %edx,%edi
  80088a:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80088c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800893:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800896:	83 ec 08             	sub    $0x8,%esp
  800899:	50                   	push   %eax
  80089a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8008a0:	50                   	push   %eax
  8008a1:	e8 de 22 00 00       	call   802b84 <sys_utilities>
  8008a6:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8008a9:	e8 27 1e 00 00       	call   8026d5 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8008ae:	83 ec 0c             	sub    $0xc,%esp
  8008b1:	68 f8 40 80 00       	push   $0x8040f8
  8008b6:	e8 be 01 00 00       	call   800a79 <cprintf>
  8008bb:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8008be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c1:	85 c0                	test   %eax,%eax
  8008c3:	74 18                	je     8008dd <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8008c5:	e8 d8 22 00 00       	call   802ba2 <sys_get_optimal_num_faults>
  8008ca:	83 ec 08             	sub    $0x8,%esp
  8008cd:	50                   	push   %eax
  8008ce:	68 20 41 80 00       	push   $0x804120
  8008d3:	e8 a1 01 00 00       	call   800a79 <cprintf>
  8008d8:	83 c4 10             	add    $0x10,%esp
  8008db:	eb 59                	jmp    800936 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8008dd:	a1 20 50 80 00       	mov    0x805020,%eax
  8008e2:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  8008e8:	a1 20 50 80 00       	mov    0x805020,%eax
  8008ed:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  8008f3:	83 ec 04             	sub    $0x4,%esp
  8008f6:	52                   	push   %edx
  8008f7:	50                   	push   %eax
  8008f8:	68 44 41 80 00       	push   $0x804144
  8008fd:	e8 77 01 00 00       	call   800a79 <cprintf>
  800902:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800905:	a1 20 50 80 00       	mov    0x805020,%eax
  80090a:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800910:	a1 20 50 80 00       	mov    0x805020,%eax
  800915:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  80091b:	a1 20 50 80 00       	mov    0x805020,%eax
  800920:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800926:	51                   	push   %ecx
  800927:	52                   	push   %edx
  800928:	50                   	push   %eax
  800929:	68 6c 41 80 00       	push   $0x80416c
  80092e:	e8 46 01 00 00       	call   800a79 <cprintf>
  800933:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800936:	a1 20 50 80 00       	mov    0x805020,%eax
  80093b:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800941:	83 ec 08             	sub    $0x8,%esp
  800944:	50                   	push   %eax
  800945:	68 c4 41 80 00       	push   $0x8041c4
  80094a:	e8 2a 01 00 00       	call   800a79 <cprintf>
  80094f:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800952:	83 ec 0c             	sub    $0xc,%esp
  800955:	68 f8 40 80 00       	push   $0x8040f8
  80095a:	e8 1a 01 00 00       	call   800a79 <cprintf>
  80095f:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800962:	e8 88 1d 00 00       	call   8026ef <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800967:	e8 1f 00 00 00       	call   80098b <exit>
}
  80096c:	90                   	nop
  80096d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800970:	5b                   	pop    %ebx
  800971:	5e                   	pop    %esi
  800972:	5f                   	pop    %edi
  800973:	5d                   	pop    %ebp
  800974:	c3                   	ret    

00800975 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800975:	55                   	push   %ebp
  800976:	89 e5                	mov    %esp,%ebp
  800978:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80097b:	83 ec 0c             	sub    $0xc,%esp
  80097e:	6a 00                	push   $0x0
  800980:	e8 95 1f 00 00       	call   80291a <sys_destroy_env>
  800985:	83 c4 10             	add    $0x10,%esp
}
  800988:	90                   	nop
  800989:	c9                   	leave  
  80098a:	c3                   	ret    

0080098b <exit>:

void
exit(void)
{
  80098b:	55                   	push   %ebp
  80098c:	89 e5                	mov    %esp,%ebp
  80098e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800991:	e8 ea 1f 00 00       	call   802980 <sys_exit_env>
}
  800996:	90                   	nop
  800997:	c9                   	leave  
  800998:	c3                   	ret    

00800999 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	53                   	push   %ebx
  80099d:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8009a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a3:	8b 00                	mov    (%eax),%eax
  8009a5:	8d 48 01             	lea    0x1(%eax),%ecx
  8009a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ab:	89 0a                	mov    %ecx,(%edx)
  8009ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8009b0:	88 d1                	mov    %dl,%cl
  8009b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009bc:	8b 00                	mov    (%eax),%eax
  8009be:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009c3:	75 30                	jne    8009f5 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8009c5:	8b 15 18 d1 81 00    	mov    0x81d118,%edx
  8009cb:	a0 44 50 80 00       	mov    0x805044,%al
  8009d0:	0f b6 c0             	movzbl %al,%eax
  8009d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009d6:	8b 09                	mov    (%ecx),%ecx
  8009d8:	89 cb                	mov    %ecx,%ebx
  8009da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009dd:	83 c1 08             	add    $0x8,%ecx
  8009e0:	52                   	push   %edx
  8009e1:	50                   	push   %eax
  8009e2:	53                   	push   %ebx
  8009e3:	51                   	push   %ecx
  8009e4:	e8 a8 1c 00 00       	call   802691 <sys_cputs>
  8009e9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f8:	8b 40 04             	mov    0x4(%eax),%eax
  8009fb:	8d 50 01             	lea    0x1(%eax),%edx
  8009fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a01:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a04:	90                   	nop
  800a05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a08:	c9                   	leave  
  800a09:	c3                   	ret    

00800a0a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a13:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a1a:	00 00 00 
	b.cnt = 0;
  800a1d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a24:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a27:	ff 75 0c             	pushl  0xc(%ebp)
  800a2a:	ff 75 08             	pushl  0x8(%ebp)
  800a2d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a33:	50                   	push   %eax
  800a34:	68 99 09 80 00       	push   $0x800999
  800a39:	e8 5a 02 00 00       	call   800c98 <vprintfmt>
  800a3e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800a41:	8b 15 18 d1 81 00    	mov    0x81d118,%edx
  800a47:	a0 44 50 80 00       	mov    0x805044,%al
  800a4c:	0f b6 c0             	movzbl %al,%eax
  800a4f:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800a55:	52                   	push   %edx
  800a56:	50                   	push   %eax
  800a57:	51                   	push   %ecx
  800a58:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a5e:	83 c0 08             	add    $0x8,%eax
  800a61:	50                   	push   %eax
  800a62:	e8 2a 1c 00 00       	call   802691 <sys_cputs>
  800a67:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a6a:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  800a71:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a77:	c9                   	leave  
  800a78:	c3                   	ret    

00800a79 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a79:	55                   	push   %ebp
  800a7a:	89 e5                	mov    %esp,%ebp
  800a7c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a7f:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  800a86:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a89:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	83 ec 08             	sub    $0x8,%esp
  800a92:	ff 75 f4             	pushl  -0xc(%ebp)
  800a95:	50                   	push   %eax
  800a96:	e8 6f ff ff ff       	call   800a0a <vcprintf>
  800a9b:	83 c4 10             	add    $0x10,%esp
  800a9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aa4:	c9                   	leave  
  800aa5:	c3                   	ret    

00800aa6 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800aa6:	55                   	push   %ebp
  800aa7:	89 e5                	mov    %esp,%ebp
  800aa9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800aac:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	c1 e0 08             	shl    $0x8,%eax
  800ab9:	a3 18 d1 81 00       	mov    %eax,0x81d118
	va_start(ap, fmt);
  800abe:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ac1:	83 c0 04             	add    $0x4,%eax
  800ac4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ac7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aca:	83 ec 08             	sub    $0x8,%esp
  800acd:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad0:	50                   	push   %eax
  800ad1:	e8 34 ff ff ff       	call   800a0a <vcprintf>
  800ad6:	83 c4 10             	add    $0x10,%esp
  800ad9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800adc:	c7 05 18 d1 81 00 00 	movl   $0x700,0x81d118
  800ae3:	07 00 00 

	return cnt;
  800ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ae9:	c9                   	leave  
  800aea:	c3                   	ret    

00800aeb <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800aeb:	55                   	push   %ebp
  800aec:	89 e5                	mov    %esp,%ebp
  800aee:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800af1:	e8 df 1b 00 00       	call   8026d5 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800af6:	8d 45 0c             	lea    0xc(%ebp),%eax
  800af9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 f4             	pushl  -0xc(%ebp)
  800b05:	50                   	push   %eax
  800b06:	e8 ff fe ff ff       	call   800a0a <vcprintf>
  800b0b:	83 c4 10             	add    $0x10,%esp
  800b0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b11:	e8 d9 1b 00 00       	call   8026ef <sys_unlock_cons>
	return cnt;
  800b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b19:	c9                   	leave  
  800b1a:	c3                   	ret    

00800b1b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
  800b1e:	53                   	push   %ebx
  800b1f:	83 ec 14             	sub    $0x14,%esp
  800b22:	8b 45 10             	mov    0x10(%ebp),%eax
  800b25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b28:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b2e:	8b 45 18             	mov    0x18(%ebp),%eax
  800b31:	ba 00 00 00 00       	mov    $0x0,%edx
  800b36:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b39:	77 55                	ja     800b90 <printnum+0x75>
  800b3b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b3e:	72 05                	jb     800b45 <printnum+0x2a>
  800b40:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b43:	77 4b                	ja     800b90 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b45:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b48:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b4b:	8b 45 18             	mov    0x18(%ebp),%eax
  800b4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b53:	52                   	push   %edx
  800b54:	50                   	push   %eax
  800b55:	ff 75 f4             	pushl  -0xc(%ebp)
  800b58:	ff 75 f0             	pushl  -0x10(%ebp)
  800b5b:	e8 48 31 00 00       	call   803ca8 <__udivdi3>
  800b60:	83 c4 10             	add    $0x10,%esp
  800b63:	83 ec 04             	sub    $0x4,%esp
  800b66:	ff 75 20             	pushl  0x20(%ebp)
  800b69:	53                   	push   %ebx
  800b6a:	ff 75 18             	pushl  0x18(%ebp)
  800b6d:	52                   	push   %edx
  800b6e:	50                   	push   %eax
  800b6f:	ff 75 0c             	pushl  0xc(%ebp)
  800b72:	ff 75 08             	pushl  0x8(%ebp)
  800b75:	e8 a1 ff ff ff       	call   800b1b <printnum>
  800b7a:	83 c4 20             	add    $0x20,%esp
  800b7d:	eb 1a                	jmp    800b99 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b7f:	83 ec 08             	sub    $0x8,%esp
  800b82:	ff 75 0c             	pushl  0xc(%ebp)
  800b85:	ff 75 20             	pushl  0x20(%ebp)
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	ff d0                	call   *%eax
  800b8d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b90:	ff 4d 1c             	decl   0x1c(%ebp)
  800b93:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b97:	7f e6                	jg     800b7f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b99:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ba1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba7:	53                   	push   %ebx
  800ba8:	51                   	push   %ecx
  800ba9:	52                   	push   %edx
  800baa:	50                   	push   %eax
  800bab:	e8 08 32 00 00       	call   803db8 <__umoddi3>
  800bb0:	83 c4 10             	add    $0x10,%esp
  800bb3:	05 54 44 80 00       	add    $0x804454,%eax
  800bb8:	8a 00                	mov    (%eax),%al
  800bba:	0f be c0             	movsbl %al,%eax
  800bbd:	83 ec 08             	sub    $0x8,%esp
  800bc0:	ff 75 0c             	pushl  0xc(%ebp)
  800bc3:	50                   	push   %eax
  800bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc7:	ff d0                	call   *%eax
  800bc9:	83 c4 10             	add    $0x10,%esp
}
  800bcc:	90                   	nop
  800bcd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bd0:	c9                   	leave  
  800bd1:	c3                   	ret    

00800bd2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bd5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bd9:	7e 1c                	jle    800bf7 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	8b 00                	mov    (%eax),%eax
  800be0:	8d 50 08             	lea    0x8(%eax),%edx
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	89 10                	mov    %edx,(%eax)
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	8b 00                	mov    (%eax),%eax
  800bed:	83 e8 08             	sub    $0x8,%eax
  800bf0:	8b 50 04             	mov    0x4(%eax),%edx
  800bf3:	8b 00                	mov    (%eax),%eax
  800bf5:	eb 40                	jmp    800c37 <getuint+0x65>
	else if (lflag)
  800bf7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bfb:	74 1e                	je     800c1b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	8b 00                	mov    (%eax),%eax
  800c02:	8d 50 04             	lea    0x4(%eax),%edx
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	89 10                	mov    %edx,(%eax)
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	8b 00                	mov    (%eax),%eax
  800c0f:	83 e8 04             	sub    $0x4,%eax
  800c12:	8b 00                	mov    (%eax),%eax
  800c14:	ba 00 00 00 00       	mov    $0x0,%edx
  800c19:	eb 1c                	jmp    800c37 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	8b 00                	mov    (%eax),%eax
  800c20:	8d 50 04             	lea    0x4(%eax),%edx
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	89 10                	mov    %edx,(%eax)
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	8b 00                	mov    (%eax),%eax
  800c2d:	83 e8 04             	sub    $0x4,%eax
  800c30:	8b 00                	mov    (%eax),%eax
  800c32:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c37:	5d                   	pop    %ebp
  800c38:	c3                   	ret    

00800c39 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c3c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c40:	7e 1c                	jle    800c5e <getint+0x25>
		return va_arg(*ap, long long);
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	8b 00                	mov    (%eax),%eax
  800c47:	8d 50 08             	lea    0x8(%eax),%edx
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	89 10                	mov    %edx,(%eax)
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	8b 00                	mov    (%eax),%eax
  800c54:	83 e8 08             	sub    $0x8,%eax
  800c57:	8b 50 04             	mov    0x4(%eax),%edx
  800c5a:	8b 00                	mov    (%eax),%eax
  800c5c:	eb 38                	jmp    800c96 <getint+0x5d>
	else if (lflag)
  800c5e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c62:	74 1a                	je     800c7e <getint+0x45>
		return va_arg(*ap, long);
  800c64:	8b 45 08             	mov    0x8(%ebp),%eax
  800c67:	8b 00                	mov    (%eax),%eax
  800c69:	8d 50 04             	lea    0x4(%eax),%edx
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	89 10                	mov    %edx,(%eax)
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	8b 00                	mov    (%eax),%eax
  800c76:	83 e8 04             	sub    $0x4,%eax
  800c79:	8b 00                	mov    (%eax),%eax
  800c7b:	99                   	cltd   
  800c7c:	eb 18                	jmp    800c96 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8b 00                	mov    (%eax),%eax
  800c83:	8d 50 04             	lea    0x4(%eax),%edx
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	89 10                	mov    %edx,(%eax)
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	8b 00                	mov    (%eax),%eax
  800c90:	83 e8 04             	sub    $0x4,%eax
  800c93:	8b 00                	mov    (%eax),%eax
  800c95:	99                   	cltd   
}
  800c96:	5d                   	pop    %ebp
  800c97:	c3                   	ret    

00800c98 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	56                   	push   %esi
  800c9c:	53                   	push   %ebx
  800c9d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ca0:	eb 17                	jmp    800cb9 <vprintfmt+0x21>
			if (ch == '\0')
  800ca2:	85 db                	test   %ebx,%ebx
  800ca4:	0f 84 c1 03 00 00    	je     80106b <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800caa:	83 ec 08             	sub    $0x8,%esp
  800cad:	ff 75 0c             	pushl  0xc(%ebp)
  800cb0:	53                   	push   %ebx
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	ff d0                	call   *%eax
  800cb6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbc:	8d 50 01             	lea    0x1(%eax),%edx
  800cbf:	89 55 10             	mov    %edx,0x10(%ebp)
  800cc2:	8a 00                	mov    (%eax),%al
  800cc4:	0f b6 d8             	movzbl %al,%ebx
  800cc7:	83 fb 25             	cmp    $0x25,%ebx
  800cca:	75 d6                	jne    800ca2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ccc:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800cd0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800cd7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cde:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800ce5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cec:	8b 45 10             	mov    0x10(%ebp),%eax
  800cef:	8d 50 01             	lea    0x1(%eax),%edx
  800cf2:	89 55 10             	mov    %edx,0x10(%ebp)
  800cf5:	8a 00                	mov    (%eax),%al
  800cf7:	0f b6 d8             	movzbl %al,%ebx
  800cfa:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800cfd:	83 f8 5b             	cmp    $0x5b,%eax
  800d00:	0f 87 3d 03 00 00    	ja     801043 <vprintfmt+0x3ab>
  800d06:	8b 04 85 78 44 80 00 	mov    0x804478(,%eax,4),%eax
  800d0d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d0f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d13:	eb d7                	jmp    800cec <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d15:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d19:	eb d1                	jmp    800cec <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d1b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d22:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d25:	89 d0                	mov    %edx,%eax
  800d27:	c1 e0 02             	shl    $0x2,%eax
  800d2a:	01 d0                	add    %edx,%eax
  800d2c:	01 c0                	add    %eax,%eax
  800d2e:	01 d8                	add    %ebx,%eax
  800d30:	83 e8 30             	sub    $0x30,%eax
  800d33:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d36:	8b 45 10             	mov    0x10(%ebp),%eax
  800d39:	8a 00                	mov    (%eax),%al
  800d3b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d3e:	83 fb 2f             	cmp    $0x2f,%ebx
  800d41:	7e 3e                	jle    800d81 <vprintfmt+0xe9>
  800d43:	83 fb 39             	cmp    $0x39,%ebx
  800d46:	7f 39                	jg     800d81 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d48:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d4b:	eb d5                	jmp    800d22 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d50:	83 c0 04             	add    $0x4,%eax
  800d53:	89 45 14             	mov    %eax,0x14(%ebp)
  800d56:	8b 45 14             	mov    0x14(%ebp),%eax
  800d59:	83 e8 04             	sub    $0x4,%eax
  800d5c:	8b 00                	mov    (%eax),%eax
  800d5e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d61:	eb 1f                	jmp    800d82 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d63:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d67:	79 83                	jns    800cec <vprintfmt+0x54>
				width = 0;
  800d69:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d70:	e9 77 ff ff ff       	jmp    800cec <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d75:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d7c:	e9 6b ff ff ff       	jmp    800cec <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d81:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d82:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d86:	0f 89 60 ff ff ff    	jns    800cec <vprintfmt+0x54>
				width = precision, precision = -1;
  800d8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d92:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d99:	e9 4e ff ff ff       	jmp    800cec <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d9e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800da1:	e9 46 ff ff ff       	jmp    800cec <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800da6:	8b 45 14             	mov    0x14(%ebp),%eax
  800da9:	83 c0 04             	add    $0x4,%eax
  800dac:	89 45 14             	mov    %eax,0x14(%ebp)
  800daf:	8b 45 14             	mov    0x14(%ebp),%eax
  800db2:	83 e8 04             	sub    $0x4,%eax
  800db5:	8b 00                	mov    (%eax),%eax
  800db7:	83 ec 08             	sub    $0x8,%esp
  800dba:	ff 75 0c             	pushl  0xc(%ebp)
  800dbd:	50                   	push   %eax
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	ff d0                	call   *%eax
  800dc3:	83 c4 10             	add    $0x10,%esp
			break;
  800dc6:	e9 9b 02 00 00       	jmp    801066 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800dcb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dce:	83 c0 04             	add    $0x4,%eax
  800dd1:	89 45 14             	mov    %eax,0x14(%ebp)
  800dd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd7:	83 e8 04             	sub    $0x4,%eax
  800dda:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ddc:	85 db                	test   %ebx,%ebx
  800dde:	79 02                	jns    800de2 <vprintfmt+0x14a>
				err = -err;
  800de0:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800de2:	83 fb 64             	cmp    $0x64,%ebx
  800de5:	7f 0b                	jg     800df2 <vprintfmt+0x15a>
  800de7:	8b 34 9d c0 42 80 00 	mov    0x8042c0(,%ebx,4),%esi
  800dee:	85 f6                	test   %esi,%esi
  800df0:	75 19                	jne    800e0b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800df2:	53                   	push   %ebx
  800df3:	68 65 44 80 00       	push   $0x804465
  800df8:	ff 75 0c             	pushl  0xc(%ebp)
  800dfb:	ff 75 08             	pushl  0x8(%ebp)
  800dfe:	e8 70 02 00 00       	call   801073 <printfmt>
  800e03:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e06:	e9 5b 02 00 00       	jmp    801066 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e0b:	56                   	push   %esi
  800e0c:	68 6e 44 80 00       	push   $0x80446e
  800e11:	ff 75 0c             	pushl  0xc(%ebp)
  800e14:	ff 75 08             	pushl  0x8(%ebp)
  800e17:	e8 57 02 00 00       	call   801073 <printfmt>
  800e1c:	83 c4 10             	add    $0x10,%esp
			break;
  800e1f:	e9 42 02 00 00       	jmp    801066 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e24:	8b 45 14             	mov    0x14(%ebp),%eax
  800e27:	83 c0 04             	add    $0x4,%eax
  800e2a:	89 45 14             	mov    %eax,0x14(%ebp)
  800e2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e30:	83 e8 04             	sub    $0x4,%eax
  800e33:	8b 30                	mov    (%eax),%esi
  800e35:	85 f6                	test   %esi,%esi
  800e37:	75 05                	jne    800e3e <vprintfmt+0x1a6>
				p = "(null)";
  800e39:	be 71 44 80 00       	mov    $0x804471,%esi
			if (width > 0 && padc != '-')
  800e3e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e42:	7e 6d                	jle    800eb1 <vprintfmt+0x219>
  800e44:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e48:	74 67                	je     800eb1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e4d:	83 ec 08             	sub    $0x8,%esp
  800e50:	50                   	push   %eax
  800e51:	56                   	push   %esi
  800e52:	e8 1e 03 00 00       	call   801175 <strnlen>
  800e57:	83 c4 10             	add    $0x10,%esp
  800e5a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e5d:	eb 16                	jmp    800e75 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e5f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e63:	83 ec 08             	sub    $0x8,%esp
  800e66:	ff 75 0c             	pushl  0xc(%ebp)
  800e69:	50                   	push   %eax
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	ff d0                	call   *%eax
  800e6f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e72:	ff 4d e4             	decl   -0x1c(%ebp)
  800e75:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e79:	7f e4                	jg     800e5f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e7b:	eb 34                	jmp    800eb1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e7d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e81:	74 1c                	je     800e9f <vprintfmt+0x207>
  800e83:	83 fb 1f             	cmp    $0x1f,%ebx
  800e86:	7e 05                	jle    800e8d <vprintfmt+0x1f5>
  800e88:	83 fb 7e             	cmp    $0x7e,%ebx
  800e8b:	7e 12                	jle    800e9f <vprintfmt+0x207>
					putch('?', putdat);
  800e8d:	83 ec 08             	sub    $0x8,%esp
  800e90:	ff 75 0c             	pushl  0xc(%ebp)
  800e93:	6a 3f                	push   $0x3f
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	ff d0                	call   *%eax
  800e9a:	83 c4 10             	add    $0x10,%esp
  800e9d:	eb 0f                	jmp    800eae <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e9f:	83 ec 08             	sub    $0x8,%esp
  800ea2:	ff 75 0c             	pushl  0xc(%ebp)
  800ea5:	53                   	push   %ebx
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	ff d0                	call   *%eax
  800eab:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eae:	ff 4d e4             	decl   -0x1c(%ebp)
  800eb1:	89 f0                	mov    %esi,%eax
  800eb3:	8d 70 01             	lea    0x1(%eax),%esi
  800eb6:	8a 00                	mov    (%eax),%al
  800eb8:	0f be d8             	movsbl %al,%ebx
  800ebb:	85 db                	test   %ebx,%ebx
  800ebd:	74 24                	je     800ee3 <vprintfmt+0x24b>
  800ebf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ec3:	78 b8                	js     800e7d <vprintfmt+0x1e5>
  800ec5:	ff 4d e0             	decl   -0x20(%ebp)
  800ec8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ecc:	79 af                	jns    800e7d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ece:	eb 13                	jmp    800ee3 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ed0:	83 ec 08             	sub    $0x8,%esp
  800ed3:	ff 75 0c             	pushl  0xc(%ebp)
  800ed6:	6a 20                	push   $0x20
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	ff d0                	call   *%eax
  800edd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ee0:	ff 4d e4             	decl   -0x1c(%ebp)
  800ee3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ee7:	7f e7                	jg     800ed0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ee9:	e9 78 01 00 00       	jmp    801066 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800eee:	83 ec 08             	sub    $0x8,%esp
  800ef1:	ff 75 e8             	pushl  -0x18(%ebp)
  800ef4:	8d 45 14             	lea    0x14(%ebp),%eax
  800ef7:	50                   	push   %eax
  800ef8:	e8 3c fd ff ff       	call   800c39 <getint>
  800efd:	83 c4 10             	add    $0x10,%esp
  800f00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f03:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f0c:	85 d2                	test   %edx,%edx
  800f0e:	79 23                	jns    800f33 <vprintfmt+0x29b>
				putch('-', putdat);
  800f10:	83 ec 08             	sub    $0x8,%esp
  800f13:	ff 75 0c             	pushl  0xc(%ebp)
  800f16:	6a 2d                	push   $0x2d
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	ff d0                	call   *%eax
  800f1d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f26:	f7 d8                	neg    %eax
  800f28:	83 d2 00             	adc    $0x0,%edx
  800f2b:	f7 da                	neg    %edx
  800f2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f30:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f33:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f3a:	e9 bc 00 00 00       	jmp    800ffb <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f3f:	83 ec 08             	sub    $0x8,%esp
  800f42:	ff 75 e8             	pushl  -0x18(%ebp)
  800f45:	8d 45 14             	lea    0x14(%ebp),%eax
  800f48:	50                   	push   %eax
  800f49:	e8 84 fc ff ff       	call   800bd2 <getuint>
  800f4e:	83 c4 10             	add    $0x10,%esp
  800f51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f54:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f57:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f5e:	e9 98 00 00 00       	jmp    800ffb <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f63:	83 ec 08             	sub    $0x8,%esp
  800f66:	ff 75 0c             	pushl  0xc(%ebp)
  800f69:	6a 58                	push   $0x58
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	ff d0                	call   *%eax
  800f70:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f73:	83 ec 08             	sub    $0x8,%esp
  800f76:	ff 75 0c             	pushl  0xc(%ebp)
  800f79:	6a 58                	push   $0x58
  800f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7e:	ff d0                	call   *%eax
  800f80:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f83:	83 ec 08             	sub    $0x8,%esp
  800f86:	ff 75 0c             	pushl  0xc(%ebp)
  800f89:	6a 58                	push   $0x58
  800f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8e:	ff d0                	call   *%eax
  800f90:	83 c4 10             	add    $0x10,%esp
			break;
  800f93:	e9 ce 00 00 00       	jmp    801066 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800f98:	83 ec 08             	sub    $0x8,%esp
  800f9b:	ff 75 0c             	pushl  0xc(%ebp)
  800f9e:	6a 30                	push   $0x30
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	ff d0                	call   *%eax
  800fa5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fa8:	83 ec 08             	sub    $0x8,%esp
  800fab:	ff 75 0c             	pushl  0xc(%ebp)
  800fae:	6a 78                	push   $0x78
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	ff d0                	call   *%eax
  800fb5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800fb8:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbb:	83 c0 04             	add    $0x4,%eax
  800fbe:	89 45 14             	mov    %eax,0x14(%ebp)
  800fc1:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc4:	83 e8 04             	sub    $0x4,%eax
  800fc7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fcc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800fd3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800fda:	eb 1f                	jmp    800ffb <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fdc:	83 ec 08             	sub    $0x8,%esp
  800fdf:	ff 75 e8             	pushl  -0x18(%ebp)
  800fe2:	8d 45 14             	lea    0x14(%ebp),%eax
  800fe5:	50                   	push   %eax
  800fe6:	e8 e7 fb ff ff       	call   800bd2 <getuint>
  800feb:	83 c4 10             	add    $0x10,%esp
  800fee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ff1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ff4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ffb:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801002:	83 ec 04             	sub    $0x4,%esp
  801005:	52                   	push   %edx
  801006:	ff 75 e4             	pushl  -0x1c(%ebp)
  801009:	50                   	push   %eax
  80100a:	ff 75 f4             	pushl  -0xc(%ebp)
  80100d:	ff 75 f0             	pushl  -0x10(%ebp)
  801010:	ff 75 0c             	pushl  0xc(%ebp)
  801013:	ff 75 08             	pushl  0x8(%ebp)
  801016:	e8 00 fb ff ff       	call   800b1b <printnum>
  80101b:	83 c4 20             	add    $0x20,%esp
			break;
  80101e:	eb 46                	jmp    801066 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801020:	83 ec 08             	sub    $0x8,%esp
  801023:	ff 75 0c             	pushl  0xc(%ebp)
  801026:	53                   	push   %ebx
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	ff d0                	call   *%eax
  80102c:	83 c4 10             	add    $0x10,%esp
			break;
  80102f:	eb 35                	jmp    801066 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801031:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  801038:	eb 2c                	jmp    801066 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80103a:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  801041:	eb 23                	jmp    801066 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801043:	83 ec 08             	sub    $0x8,%esp
  801046:	ff 75 0c             	pushl  0xc(%ebp)
  801049:	6a 25                	push   $0x25
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	ff d0                	call   *%eax
  801050:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801053:	ff 4d 10             	decl   0x10(%ebp)
  801056:	eb 03                	jmp    80105b <vprintfmt+0x3c3>
  801058:	ff 4d 10             	decl   0x10(%ebp)
  80105b:	8b 45 10             	mov    0x10(%ebp),%eax
  80105e:	48                   	dec    %eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	3c 25                	cmp    $0x25,%al
  801063:	75 f3                	jne    801058 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801065:	90                   	nop
		}
	}
  801066:	e9 35 fc ff ff       	jmp    800ca0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80106b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80106c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80106f:	5b                   	pop    %ebx
  801070:	5e                   	pop    %esi
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    

00801073 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801079:	8d 45 10             	lea    0x10(%ebp),%eax
  80107c:	83 c0 04             	add    $0x4,%eax
  80107f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801082:	8b 45 10             	mov    0x10(%ebp),%eax
  801085:	ff 75 f4             	pushl  -0xc(%ebp)
  801088:	50                   	push   %eax
  801089:	ff 75 0c             	pushl  0xc(%ebp)
  80108c:	ff 75 08             	pushl  0x8(%ebp)
  80108f:	e8 04 fc ff ff       	call   800c98 <vprintfmt>
  801094:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801097:	90                   	nop
  801098:	c9                   	leave  
  801099:	c3                   	ret    

0080109a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80109d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a0:	8b 40 08             	mov    0x8(%eax),%eax
  8010a3:	8d 50 01             	lea    0x1(%eax),%edx
  8010a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010af:	8b 10                	mov    (%eax),%edx
  8010b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b4:	8b 40 04             	mov    0x4(%eax),%eax
  8010b7:	39 c2                	cmp    %eax,%edx
  8010b9:	73 12                	jae    8010cd <sprintputch+0x33>
		*b->buf++ = ch;
  8010bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010be:	8b 00                	mov    (%eax),%eax
  8010c0:	8d 48 01             	lea    0x1(%eax),%ecx
  8010c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c6:	89 0a                	mov    %ecx,(%edx)
  8010c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010cb:	88 10                	mov    %dl,(%eax)
}
  8010cd:	90                   	nop
  8010ce:	5d                   	pop    %ebp
  8010cf:	c3                   	ret    

008010d0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	01 d0                	add    %edx,%eax
  8010e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010f5:	74 06                	je     8010fd <vsnprintf+0x2d>
  8010f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010fb:	7f 07                	jg     801104 <vsnprintf+0x34>
		return -E_INVAL;
  8010fd:	b8 03 00 00 00       	mov    $0x3,%eax
  801102:	eb 20                	jmp    801124 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801104:	ff 75 14             	pushl  0x14(%ebp)
  801107:	ff 75 10             	pushl  0x10(%ebp)
  80110a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80110d:	50                   	push   %eax
  80110e:	68 9a 10 80 00       	push   $0x80109a
  801113:	e8 80 fb ff ff       	call   800c98 <vprintfmt>
  801118:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80111b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80111e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801121:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801124:	c9                   	leave  
  801125:	c3                   	ret    

00801126 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801126:	55                   	push   %ebp
  801127:	89 e5                	mov    %esp,%ebp
  801129:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80112c:	8d 45 10             	lea    0x10(%ebp),%eax
  80112f:	83 c0 04             	add    $0x4,%eax
  801132:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801135:	8b 45 10             	mov    0x10(%ebp),%eax
  801138:	ff 75 f4             	pushl  -0xc(%ebp)
  80113b:	50                   	push   %eax
  80113c:	ff 75 0c             	pushl  0xc(%ebp)
  80113f:	ff 75 08             	pushl  0x8(%ebp)
  801142:	e8 89 ff ff ff       	call   8010d0 <vsnprintf>
  801147:	83 c4 10             	add    $0x10,%esp
  80114a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80114d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801150:	c9                   	leave  
  801151:	c3                   	ret    

00801152 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801158:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80115f:	eb 06                	jmp    801167 <strlen+0x15>
		n++;
  801161:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801164:	ff 45 08             	incl   0x8(%ebp)
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
  80116a:	8a 00                	mov    (%eax),%al
  80116c:	84 c0                	test   %al,%al
  80116e:	75 f1                	jne    801161 <strlen+0xf>
		n++;
	return n;
  801170:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801173:	c9                   	leave  
  801174:	c3                   	ret    

00801175 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801175:	55                   	push   %ebp
  801176:	89 e5                	mov    %esp,%ebp
  801178:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80117b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801182:	eb 09                	jmp    80118d <strnlen+0x18>
		n++;
  801184:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801187:	ff 45 08             	incl   0x8(%ebp)
  80118a:	ff 4d 0c             	decl   0xc(%ebp)
  80118d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801191:	74 09                	je     80119c <strnlen+0x27>
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	8a 00                	mov    (%eax),%al
  801198:	84 c0                	test   %al,%al
  80119a:	75 e8                	jne    801184 <strnlen+0xf>
		n++;
	return n;
  80119c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80119f:	c9                   	leave  
  8011a0:	c3                   	ret    

008011a1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011a1:	55                   	push   %ebp
  8011a2:	89 e5                	mov    %esp,%ebp
  8011a4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8011a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8011ad:	90                   	nop
  8011ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b1:	8d 50 01             	lea    0x1(%eax),%edx
  8011b4:	89 55 08             	mov    %edx,0x8(%ebp)
  8011b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ba:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011bd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011c0:	8a 12                	mov    (%edx),%dl
  8011c2:	88 10                	mov    %dl,(%eax)
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	84 c0                	test   %al,%al
  8011c8:	75 e4                	jne    8011ae <strcpy+0xd>
		/* do nothing */;
	return ret;
  8011ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011cd:	c9                   	leave  
  8011ce:	c3                   	ret    

008011cf <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8011db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011e2:	eb 1f                	jmp    801203 <strncpy+0x34>
		*dst++ = *src;
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ea:	89 55 08             	mov    %edx,0x8(%ebp)
  8011ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f0:	8a 12                	mov    (%edx),%dl
  8011f2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	84 c0                	test   %al,%al
  8011fb:	74 03                	je     801200 <strncpy+0x31>
			src++;
  8011fd:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801200:	ff 45 fc             	incl   -0x4(%ebp)
  801203:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801206:	3b 45 10             	cmp    0x10(%ebp),%eax
  801209:	72 d9                	jb     8011e4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80120b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80120e:	c9                   	leave  
  80120f:	c3                   	ret    

00801210 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
  801213:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80121c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801220:	74 30                	je     801252 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801222:	eb 16                	jmp    80123a <strlcpy+0x2a>
			*dst++ = *src++;
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	8d 50 01             	lea    0x1(%eax),%edx
  80122a:	89 55 08             	mov    %edx,0x8(%ebp)
  80122d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801230:	8d 4a 01             	lea    0x1(%edx),%ecx
  801233:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801236:	8a 12                	mov    (%edx),%dl
  801238:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80123a:	ff 4d 10             	decl   0x10(%ebp)
  80123d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801241:	74 09                	je     80124c <strlcpy+0x3c>
  801243:	8b 45 0c             	mov    0xc(%ebp),%eax
  801246:	8a 00                	mov    (%eax),%al
  801248:	84 c0                	test   %al,%al
  80124a:	75 d8                	jne    801224 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801252:	8b 55 08             	mov    0x8(%ebp),%edx
  801255:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801258:	29 c2                	sub    %eax,%edx
  80125a:	89 d0                	mov    %edx,%eax
}
  80125c:	c9                   	leave  
  80125d:	c3                   	ret    

0080125e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80125e:	55                   	push   %ebp
  80125f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801261:	eb 06                	jmp    801269 <strcmp+0xb>
		p++, q++;
  801263:	ff 45 08             	incl   0x8(%ebp)
  801266:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	8a 00                	mov    (%eax),%al
  80126e:	84 c0                	test   %al,%al
  801270:	74 0e                	je     801280 <strcmp+0x22>
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 10                	mov    (%eax),%dl
  801277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127a:	8a 00                	mov    (%eax),%al
  80127c:	38 c2                	cmp    %al,%dl
  80127e:	74 e3                	je     801263 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
  801283:	8a 00                	mov    (%eax),%al
  801285:	0f b6 d0             	movzbl %al,%edx
  801288:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128b:	8a 00                	mov    (%eax),%al
  80128d:	0f b6 c0             	movzbl %al,%eax
  801290:	29 c2                	sub    %eax,%edx
  801292:	89 d0                	mov    %edx,%eax
}
  801294:	5d                   	pop    %ebp
  801295:	c3                   	ret    

00801296 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801299:	eb 09                	jmp    8012a4 <strncmp+0xe>
		n--, p++, q++;
  80129b:	ff 4d 10             	decl   0x10(%ebp)
  80129e:	ff 45 08             	incl   0x8(%ebp)
  8012a1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8012a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a8:	74 17                	je     8012c1 <strncmp+0x2b>
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	8a 00                	mov    (%eax),%al
  8012af:	84 c0                	test   %al,%al
  8012b1:	74 0e                	je     8012c1 <strncmp+0x2b>
  8012b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b6:	8a 10                	mov    (%eax),%dl
  8012b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	38 c2                	cmp    %al,%dl
  8012bf:	74 da                	je     80129b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8012c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c5:	75 07                	jne    8012ce <strncmp+0x38>
		return 0;
  8012c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012cc:	eb 14                	jmp    8012e2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d1:	8a 00                	mov    (%eax),%al
  8012d3:	0f b6 d0             	movzbl %al,%edx
  8012d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d9:	8a 00                	mov    (%eax),%al
  8012db:	0f b6 c0             	movzbl %al,%eax
  8012de:	29 c2                	sub    %eax,%edx
  8012e0:	89 d0                	mov    %edx,%eax
}
  8012e2:	5d                   	pop    %ebp
  8012e3:	c3                   	ret    

008012e4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
  8012e7:	83 ec 04             	sub    $0x4,%esp
  8012ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012f0:	eb 12                	jmp    801304 <strchr+0x20>
		if (*s == c)
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	8a 00                	mov    (%eax),%al
  8012f7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012fa:	75 05                	jne    801301 <strchr+0x1d>
			return (char *) s;
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	eb 11                	jmp    801312 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801301:	ff 45 08             	incl   0x8(%ebp)
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	8a 00                	mov    (%eax),%al
  801309:	84 c0                	test   %al,%al
  80130b:	75 e5                	jne    8012f2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80130d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801312:	c9                   	leave  
  801313:	c3                   	ret    

00801314 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801314:	55                   	push   %ebp
  801315:	89 e5                	mov    %esp,%ebp
  801317:	83 ec 04             	sub    $0x4,%esp
  80131a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801320:	eb 0d                	jmp    80132f <strfind+0x1b>
		if (*s == c)
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	8a 00                	mov    (%eax),%al
  801327:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80132a:	74 0e                	je     80133a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80132c:	ff 45 08             	incl   0x8(%ebp)
  80132f:	8b 45 08             	mov    0x8(%ebp),%eax
  801332:	8a 00                	mov    (%eax),%al
  801334:	84 c0                	test   %al,%al
  801336:	75 ea                	jne    801322 <strfind+0xe>
  801338:	eb 01                	jmp    80133b <strfind+0x27>
		if (*s == c)
			break;
  80133a:	90                   	nop
	return (char *) s;
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80133e:	c9                   	leave  
  80133f:	c3                   	ret    

00801340 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
  801343:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80134c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801350:	76 63                	jbe    8013b5 <memset+0x75>
		uint64 data_block = c;
  801352:	8b 45 0c             	mov    0xc(%ebp),%eax
  801355:	99                   	cltd   
  801356:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801359:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80135c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801362:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801366:	c1 e0 08             	shl    $0x8,%eax
  801369:	09 45 f0             	or     %eax,-0x10(%ebp)
  80136c:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80136f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801372:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801375:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801379:	c1 e0 10             	shl    $0x10,%eax
  80137c:	09 45 f0             	or     %eax,-0x10(%ebp)
  80137f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801382:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801385:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801388:	89 c2                	mov    %eax,%edx
  80138a:	b8 00 00 00 00       	mov    $0x0,%eax
  80138f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801392:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801395:	eb 18                	jmp    8013af <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801397:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80139a:	8d 41 08             	lea    0x8(%ecx),%eax
  80139d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8013a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a6:	89 01                	mov    %eax,(%ecx)
  8013a8:	89 51 04             	mov    %edx,0x4(%ecx)
  8013ab:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8013af:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8013b3:	77 e2                	ja     801397 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8013b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b9:	74 23                	je     8013de <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8013bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013be:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8013c1:	eb 0e                	jmp    8013d1 <memset+0x91>
			*p8++ = (uint8)c;
  8013c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c6:	8d 50 01             	lea    0x1(%eax),%edx
  8013c9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013cf:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8013d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013d7:	89 55 10             	mov    %edx,0x10(%ebp)
  8013da:	85 c0                	test   %eax,%eax
  8013dc:	75 e5                	jne    8013c3 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8013de:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013e1:	c9                   	leave  
  8013e2:	c3                   	ret    

008013e3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8013e3:	55                   	push   %ebp
  8013e4:	89 e5                	mov    %esp,%ebp
  8013e6:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8013e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8013f5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8013f9:	76 24                	jbe    80141f <memcpy+0x3c>
		while(n >= 8){
  8013fb:	eb 1c                	jmp    801419 <memcpy+0x36>
			*d64 = *s64;
  8013fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801400:	8b 50 04             	mov    0x4(%eax),%edx
  801403:	8b 00                	mov    (%eax),%eax
  801405:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801408:	89 01                	mov    %eax,(%ecx)
  80140a:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80140d:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801411:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801415:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801419:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80141d:	77 de                	ja     8013fd <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80141f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801423:	74 31                	je     801456 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801425:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801428:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80142b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80142e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801431:	eb 16                	jmp    801449 <memcpy+0x66>
			*d8++ = *s8++;
  801433:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801436:	8d 50 01             	lea    0x1(%eax),%edx
  801439:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80143c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80143f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801442:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801445:	8a 12                	mov    (%edx),%dl
  801447:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801449:	8b 45 10             	mov    0x10(%ebp),%eax
  80144c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80144f:	89 55 10             	mov    %edx,0x10(%ebp)
  801452:	85 c0                	test   %eax,%eax
  801454:	75 dd                	jne    801433 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801459:	c9                   	leave  
  80145a:	c3                   	ret    

0080145b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
  80145e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801461:	8b 45 0c             	mov    0xc(%ebp),%eax
  801464:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
  80146a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80146d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801470:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801473:	73 50                	jae    8014c5 <memmove+0x6a>
  801475:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801478:	8b 45 10             	mov    0x10(%ebp),%eax
  80147b:	01 d0                	add    %edx,%eax
  80147d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801480:	76 43                	jbe    8014c5 <memmove+0x6a>
		s += n;
  801482:	8b 45 10             	mov    0x10(%ebp),%eax
  801485:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801488:	8b 45 10             	mov    0x10(%ebp),%eax
  80148b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80148e:	eb 10                	jmp    8014a0 <memmove+0x45>
			*--d = *--s;
  801490:	ff 4d f8             	decl   -0x8(%ebp)
  801493:	ff 4d fc             	decl   -0x4(%ebp)
  801496:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801499:	8a 10                	mov    (%eax),%dl
  80149b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80149e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8014a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014a6:	89 55 10             	mov    %edx,0x10(%ebp)
  8014a9:	85 c0                	test   %eax,%eax
  8014ab:	75 e3                	jne    801490 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8014ad:	eb 23                	jmp    8014d2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8014af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b2:	8d 50 01             	lea    0x1(%eax),%edx
  8014b5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014bb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014be:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014c1:	8a 12                	mov    (%edx),%dl
  8014c3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8014c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014cb:	89 55 10             	mov    %edx,0x10(%ebp)
  8014ce:	85 c0                	test   %eax,%eax
  8014d0:	75 dd                	jne    8014af <memmove+0x54>
			*d++ = *s++;

	return dst;
  8014d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014d5:	c9                   	leave  
  8014d6:	c3                   	ret    

008014d7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
  8014da:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8014dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8014e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8014e9:	eb 2a                	jmp    801515 <memcmp+0x3e>
		if (*s1 != *s2)
  8014eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014ee:	8a 10                	mov    (%eax),%dl
  8014f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f3:	8a 00                	mov    (%eax),%al
  8014f5:	38 c2                	cmp    %al,%dl
  8014f7:	74 16                	je     80150f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8014f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014fc:	8a 00                	mov    (%eax),%al
  8014fe:	0f b6 d0             	movzbl %al,%edx
  801501:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801504:	8a 00                	mov    (%eax),%al
  801506:	0f b6 c0             	movzbl %al,%eax
  801509:	29 c2                	sub    %eax,%edx
  80150b:	89 d0                	mov    %edx,%eax
  80150d:	eb 18                	jmp    801527 <memcmp+0x50>
		s1++, s2++;
  80150f:	ff 45 fc             	incl   -0x4(%ebp)
  801512:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801515:	8b 45 10             	mov    0x10(%ebp),%eax
  801518:	8d 50 ff             	lea    -0x1(%eax),%edx
  80151b:	89 55 10             	mov    %edx,0x10(%ebp)
  80151e:	85 c0                	test   %eax,%eax
  801520:	75 c9                	jne    8014eb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801522:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801527:	c9                   	leave  
  801528:	c3                   	ret    

00801529 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801529:	55                   	push   %ebp
  80152a:	89 e5                	mov    %esp,%ebp
  80152c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80152f:	8b 55 08             	mov    0x8(%ebp),%edx
  801532:	8b 45 10             	mov    0x10(%ebp),%eax
  801535:	01 d0                	add    %edx,%eax
  801537:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80153a:	eb 15                	jmp    801551 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80153c:	8b 45 08             	mov    0x8(%ebp),%eax
  80153f:	8a 00                	mov    (%eax),%al
  801541:	0f b6 d0             	movzbl %al,%edx
  801544:	8b 45 0c             	mov    0xc(%ebp),%eax
  801547:	0f b6 c0             	movzbl %al,%eax
  80154a:	39 c2                	cmp    %eax,%edx
  80154c:	74 0d                	je     80155b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80154e:	ff 45 08             	incl   0x8(%ebp)
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801557:	72 e3                	jb     80153c <memfind+0x13>
  801559:	eb 01                	jmp    80155c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80155b:	90                   	nop
	return (void *) s;
  80155c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801567:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80156e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801575:	eb 03                	jmp    80157a <strtol+0x19>
		s++;
  801577:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80157a:	8b 45 08             	mov    0x8(%ebp),%eax
  80157d:	8a 00                	mov    (%eax),%al
  80157f:	3c 20                	cmp    $0x20,%al
  801581:	74 f4                	je     801577 <strtol+0x16>
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	8a 00                	mov    (%eax),%al
  801588:	3c 09                	cmp    $0x9,%al
  80158a:	74 eb                	je     801577 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	8a 00                	mov    (%eax),%al
  801591:	3c 2b                	cmp    $0x2b,%al
  801593:	75 05                	jne    80159a <strtol+0x39>
		s++;
  801595:	ff 45 08             	incl   0x8(%ebp)
  801598:	eb 13                	jmp    8015ad <strtol+0x4c>
	else if (*s == '-')
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	8a 00                	mov    (%eax),%al
  80159f:	3c 2d                	cmp    $0x2d,%al
  8015a1:	75 0a                	jne    8015ad <strtol+0x4c>
		s++, neg = 1;
  8015a3:	ff 45 08             	incl   0x8(%ebp)
  8015a6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015b1:	74 06                	je     8015b9 <strtol+0x58>
  8015b3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8015b7:	75 20                	jne    8015d9 <strtol+0x78>
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bc:	8a 00                	mov    (%eax),%al
  8015be:	3c 30                	cmp    $0x30,%al
  8015c0:	75 17                	jne    8015d9 <strtol+0x78>
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	40                   	inc    %eax
  8015c6:	8a 00                	mov    (%eax),%al
  8015c8:	3c 78                	cmp    $0x78,%al
  8015ca:	75 0d                	jne    8015d9 <strtol+0x78>
		s += 2, base = 16;
  8015cc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8015d0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8015d7:	eb 28                	jmp    801601 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8015d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015dd:	75 15                	jne    8015f4 <strtol+0x93>
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	8a 00                	mov    (%eax),%al
  8015e4:	3c 30                	cmp    $0x30,%al
  8015e6:	75 0c                	jne    8015f4 <strtol+0x93>
		s++, base = 8;
  8015e8:	ff 45 08             	incl   0x8(%ebp)
  8015eb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8015f2:	eb 0d                	jmp    801601 <strtol+0xa0>
	else if (base == 0)
  8015f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015f8:	75 07                	jne    801601 <strtol+0xa0>
		base = 10;
  8015fa:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801601:	8b 45 08             	mov    0x8(%ebp),%eax
  801604:	8a 00                	mov    (%eax),%al
  801606:	3c 2f                	cmp    $0x2f,%al
  801608:	7e 19                	jle    801623 <strtol+0xc2>
  80160a:	8b 45 08             	mov    0x8(%ebp),%eax
  80160d:	8a 00                	mov    (%eax),%al
  80160f:	3c 39                	cmp    $0x39,%al
  801611:	7f 10                	jg     801623 <strtol+0xc2>
			dig = *s - '0';
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	8a 00                	mov    (%eax),%al
  801618:	0f be c0             	movsbl %al,%eax
  80161b:	83 e8 30             	sub    $0x30,%eax
  80161e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801621:	eb 42                	jmp    801665 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	8a 00                	mov    (%eax),%al
  801628:	3c 60                	cmp    $0x60,%al
  80162a:	7e 19                	jle    801645 <strtol+0xe4>
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
  80162f:	8a 00                	mov    (%eax),%al
  801631:	3c 7a                	cmp    $0x7a,%al
  801633:	7f 10                	jg     801645 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	8a 00                	mov    (%eax),%al
  80163a:	0f be c0             	movsbl %al,%eax
  80163d:	83 e8 57             	sub    $0x57,%eax
  801640:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801643:	eb 20                	jmp    801665 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801645:	8b 45 08             	mov    0x8(%ebp),%eax
  801648:	8a 00                	mov    (%eax),%al
  80164a:	3c 40                	cmp    $0x40,%al
  80164c:	7e 39                	jle    801687 <strtol+0x126>
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	8a 00                	mov    (%eax),%al
  801653:	3c 5a                	cmp    $0x5a,%al
  801655:	7f 30                	jg     801687 <strtol+0x126>
			dig = *s - 'A' + 10;
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	8a 00                	mov    (%eax),%al
  80165c:	0f be c0             	movsbl %al,%eax
  80165f:	83 e8 37             	sub    $0x37,%eax
  801662:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801668:	3b 45 10             	cmp    0x10(%ebp),%eax
  80166b:	7d 19                	jge    801686 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80166d:	ff 45 08             	incl   0x8(%ebp)
  801670:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801673:	0f af 45 10          	imul   0x10(%ebp),%eax
  801677:	89 c2                	mov    %eax,%edx
  801679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167c:	01 d0                	add    %edx,%eax
  80167e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801681:	e9 7b ff ff ff       	jmp    801601 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801686:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801687:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80168b:	74 08                	je     801695 <strtol+0x134>
		*endptr = (char *) s;
  80168d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801690:	8b 55 08             	mov    0x8(%ebp),%edx
  801693:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801695:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801699:	74 07                	je     8016a2 <strtol+0x141>
  80169b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169e:	f7 d8                	neg    %eax
  8016a0:	eb 03                	jmp    8016a5 <strtol+0x144>
  8016a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    

008016a7 <ltostr>:

void
ltostr(long value, char *str)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8016ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8016b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8016bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016bf:	79 13                	jns    8016d4 <ltostr+0x2d>
	{
		neg = 1;
  8016c1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8016c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016cb:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8016ce:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8016d1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8016dc:	99                   	cltd   
  8016dd:	f7 f9                	idiv   %ecx
  8016df:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8016e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016e5:	8d 50 01             	lea    0x1(%eax),%edx
  8016e8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016eb:	89 c2                	mov    %eax,%edx
  8016ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f0:	01 d0                	add    %edx,%eax
  8016f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016f5:	83 c2 30             	add    $0x30,%edx
  8016f8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8016fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016fd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801702:	f7 e9                	imul   %ecx
  801704:	c1 fa 02             	sar    $0x2,%edx
  801707:	89 c8                	mov    %ecx,%eax
  801709:	c1 f8 1f             	sar    $0x1f,%eax
  80170c:	29 c2                	sub    %eax,%edx
  80170e:	89 d0                	mov    %edx,%eax
  801710:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801713:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801717:	75 bb                	jne    8016d4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801719:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801720:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801723:	48                   	dec    %eax
  801724:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801727:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80172b:	74 3d                	je     80176a <ltostr+0xc3>
		start = 1 ;
  80172d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801734:	eb 34                	jmp    80176a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801736:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801739:	8b 45 0c             	mov    0xc(%ebp),%eax
  80173c:	01 d0                	add    %edx,%eax
  80173e:	8a 00                	mov    (%eax),%al
  801740:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801743:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801746:	8b 45 0c             	mov    0xc(%ebp),%eax
  801749:	01 c2                	add    %eax,%edx
  80174b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80174e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801751:	01 c8                	add    %ecx,%eax
  801753:	8a 00                	mov    (%eax),%al
  801755:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801757:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80175a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175d:	01 c2                	add    %eax,%edx
  80175f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801762:	88 02                	mov    %al,(%edx)
		start++ ;
  801764:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801767:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80176a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80176d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801770:	7c c4                	jl     801736 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801772:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801775:	8b 45 0c             	mov    0xc(%ebp),%eax
  801778:	01 d0                	add    %edx,%eax
  80177a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80177d:	90                   	nop
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801786:	ff 75 08             	pushl  0x8(%ebp)
  801789:	e8 c4 f9 ff ff       	call   801152 <strlen>
  80178e:	83 c4 04             	add    $0x4,%esp
  801791:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801794:	ff 75 0c             	pushl  0xc(%ebp)
  801797:	e8 b6 f9 ff ff       	call   801152 <strlen>
  80179c:	83 c4 04             	add    $0x4,%esp
  80179f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8017a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8017a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017b0:	eb 17                	jmp    8017c9 <strcconcat+0x49>
		final[s] = str1[s] ;
  8017b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b8:	01 c2                	add    %eax,%edx
  8017ba:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	01 c8                	add    %ecx,%eax
  8017c2:	8a 00                	mov    (%eax),%al
  8017c4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8017c6:	ff 45 fc             	incl   -0x4(%ebp)
  8017c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8017cf:	7c e1                	jl     8017b2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8017d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8017d8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8017df:	eb 1f                	jmp    801800 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8017e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e4:	8d 50 01             	lea    0x1(%eax),%edx
  8017e7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017ea:	89 c2                	mov    %eax,%edx
  8017ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ef:	01 c2                	add    %eax,%edx
  8017f1:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8017f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f7:	01 c8                	add    %ecx,%eax
  8017f9:	8a 00                	mov    (%eax),%al
  8017fb:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8017fd:	ff 45 f8             	incl   -0x8(%ebp)
  801800:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801803:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801806:	7c d9                	jl     8017e1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801808:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80180b:	8b 45 10             	mov    0x10(%ebp),%eax
  80180e:	01 d0                	add    %edx,%eax
  801810:	c6 00 00             	movb   $0x0,(%eax)
}
  801813:	90                   	nop
  801814:	c9                   	leave  
  801815:	c3                   	ret    

00801816 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801819:	8b 45 14             	mov    0x14(%ebp),%eax
  80181c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801822:	8b 45 14             	mov    0x14(%ebp),%eax
  801825:	8b 00                	mov    (%eax),%eax
  801827:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80182e:	8b 45 10             	mov    0x10(%ebp),%eax
  801831:	01 d0                	add    %edx,%eax
  801833:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801839:	eb 0c                	jmp    801847 <strsplit+0x31>
			*string++ = 0;
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	8d 50 01             	lea    0x1(%eax),%edx
  801841:	89 55 08             	mov    %edx,0x8(%ebp)
  801844:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	8a 00                	mov    (%eax),%al
  80184c:	84 c0                	test   %al,%al
  80184e:	74 18                	je     801868 <strsplit+0x52>
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	8a 00                	mov    (%eax),%al
  801855:	0f be c0             	movsbl %al,%eax
  801858:	50                   	push   %eax
  801859:	ff 75 0c             	pushl  0xc(%ebp)
  80185c:	e8 83 fa ff ff       	call   8012e4 <strchr>
  801861:	83 c4 08             	add    $0x8,%esp
  801864:	85 c0                	test   %eax,%eax
  801866:	75 d3                	jne    80183b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
  80186b:	8a 00                	mov    (%eax),%al
  80186d:	84 c0                	test   %al,%al
  80186f:	74 5a                	je     8018cb <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801871:	8b 45 14             	mov    0x14(%ebp),%eax
  801874:	8b 00                	mov    (%eax),%eax
  801876:	83 f8 0f             	cmp    $0xf,%eax
  801879:	75 07                	jne    801882 <strsplit+0x6c>
		{
			return 0;
  80187b:	b8 00 00 00 00       	mov    $0x0,%eax
  801880:	eb 66                	jmp    8018e8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801882:	8b 45 14             	mov    0x14(%ebp),%eax
  801885:	8b 00                	mov    (%eax),%eax
  801887:	8d 48 01             	lea    0x1(%eax),%ecx
  80188a:	8b 55 14             	mov    0x14(%ebp),%edx
  80188d:	89 0a                	mov    %ecx,(%edx)
  80188f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801896:	8b 45 10             	mov    0x10(%ebp),%eax
  801899:	01 c2                	add    %eax,%edx
  80189b:	8b 45 08             	mov    0x8(%ebp),%eax
  80189e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018a0:	eb 03                	jmp    8018a5 <strsplit+0x8f>
			string++;
  8018a2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	8a 00                	mov    (%eax),%al
  8018aa:	84 c0                	test   %al,%al
  8018ac:	74 8b                	je     801839 <strsplit+0x23>
  8018ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b1:	8a 00                	mov    (%eax),%al
  8018b3:	0f be c0             	movsbl %al,%eax
  8018b6:	50                   	push   %eax
  8018b7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ba:	e8 25 fa ff ff       	call   8012e4 <strchr>
  8018bf:	83 c4 08             	add    $0x8,%esp
  8018c2:	85 c0                	test   %eax,%eax
  8018c4:	74 dc                	je     8018a2 <strsplit+0x8c>
			string++;
	}
  8018c6:	e9 6e ff ff ff       	jmp    801839 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8018cb:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8018cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8018cf:	8b 00                	mov    (%eax),%eax
  8018d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018db:	01 d0                	add    %edx,%eax
  8018dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8018e3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
  8018ed:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8018f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018fd:	eb 4a                	jmp    801949 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8018ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801902:	8b 45 08             	mov    0x8(%ebp),%eax
  801905:	01 c2                	add    %eax,%edx
  801907:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80190a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190d:	01 c8                	add    %ecx,%eax
  80190f:	8a 00                	mov    (%eax),%al
  801911:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801913:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801916:	8b 45 0c             	mov    0xc(%ebp),%eax
  801919:	01 d0                	add    %edx,%eax
  80191b:	8a 00                	mov    (%eax),%al
  80191d:	3c 40                	cmp    $0x40,%al
  80191f:	7e 25                	jle    801946 <str2lower+0x5c>
  801921:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801924:	8b 45 0c             	mov    0xc(%ebp),%eax
  801927:	01 d0                	add    %edx,%eax
  801929:	8a 00                	mov    (%eax),%al
  80192b:	3c 5a                	cmp    $0x5a,%al
  80192d:	7f 17                	jg     801946 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80192f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	01 d0                	add    %edx,%eax
  801937:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80193a:	8b 55 08             	mov    0x8(%ebp),%edx
  80193d:	01 ca                	add    %ecx,%edx
  80193f:	8a 12                	mov    (%edx),%dl
  801941:	83 c2 20             	add    $0x20,%edx
  801944:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801946:	ff 45 fc             	incl   -0x4(%ebp)
  801949:	ff 75 0c             	pushl  0xc(%ebp)
  80194c:	e8 01 f8 ff ff       	call   801152 <strlen>
  801951:	83 c4 04             	add    $0x4,%esp
  801954:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801957:	7f a6                	jg     8018ff <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801959:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
  801961:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  801964:	83 ec 0c             	sub    $0xc,%esp
  801967:	6a 10                	push   $0x10
  801969:	e8 b2 15 00 00       	call   802f20 <alloc_block>
  80196e:	83 c4 10             	add    $0x10,%esp
  801971:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  801974:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801978:	75 14                	jne    80198e <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  80197a:	83 ec 04             	sub    $0x4,%esp
  80197d:	68 e8 45 80 00       	push   $0x8045e8
  801982:	6a 14                	push   $0x14
  801984:	68 11 46 80 00       	push   $0x804611
  801989:	e8 a4 1f 00 00       	call   803932 <_panic>

	node->start = start;
  80198e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801991:	8b 55 08             	mov    0x8(%ebp),%edx
  801994:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  801996:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801999:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199c:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  80199f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  8019a6:	a1 24 50 80 00       	mov    0x805024,%eax
  8019ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019ae:	eb 18                	jmp    8019c8 <insert_page_alloc+0x6a>
		if (start < it->start)
  8019b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b3:	8b 00                	mov    (%eax),%eax
  8019b5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8019b8:	77 37                	ja     8019f1 <insert_page_alloc+0x93>
			break;
		prev = it;
  8019ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019bd:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  8019c0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8019c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019cc:	74 08                	je     8019d6 <insert_page_alloc+0x78>
  8019ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d1:	8b 40 08             	mov    0x8(%eax),%eax
  8019d4:	eb 05                	jmp    8019db <insert_page_alloc+0x7d>
  8019d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019db:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8019e0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8019e5:	85 c0                	test   %eax,%eax
  8019e7:	75 c7                	jne    8019b0 <insert_page_alloc+0x52>
  8019e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019ed:	75 c1                	jne    8019b0 <insert_page_alloc+0x52>
  8019ef:	eb 01                	jmp    8019f2 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  8019f1:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  8019f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019f6:	75 64                	jne    801a5c <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  8019f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019fc:	75 14                	jne    801a12 <insert_page_alloc+0xb4>
  8019fe:	83 ec 04             	sub    $0x4,%esp
  801a01:	68 20 46 80 00       	push   $0x804620
  801a06:	6a 21                	push   $0x21
  801a08:	68 11 46 80 00       	push   $0x804611
  801a0d:	e8 20 1f 00 00       	call   803932 <_panic>
  801a12:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801a18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a1b:	89 50 08             	mov    %edx,0x8(%eax)
  801a1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a21:	8b 40 08             	mov    0x8(%eax),%eax
  801a24:	85 c0                	test   %eax,%eax
  801a26:	74 0d                	je     801a35 <insert_page_alloc+0xd7>
  801a28:	a1 24 50 80 00       	mov    0x805024,%eax
  801a2d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a30:	89 50 0c             	mov    %edx,0xc(%eax)
  801a33:	eb 08                	jmp    801a3d <insert_page_alloc+0xdf>
  801a35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a38:	a3 28 50 80 00       	mov    %eax,0x805028
  801a3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a40:	a3 24 50 80 00       	mov    %eax,0x805024
  801a45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a48:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801a4f:	a1 30 50 80 00       	mov    0x805030,%eax
  801a54:	40                   	inc    %eax
  801a55:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  801a5a:	eb 71                	jmp    801acd <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  801a5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a60:	74 06                	je     801a68 <insert_page_alloc+0x10a>
  801a62:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a66:	75 14                	jne    801a7c <insert_page_alloc+0x11e>
  801a68:	83 ec 04             	sub    $0x4,%esp
  801a6b:	68 44 46 80 00       	push   $0x804644
  801a70:	6a 23                	push   $0x23
  801a72:	68 11 46 80 00       	push   $0x804611
  801a77:	e8 b6 1e 00 00       	call   803932 <_panic>
  801a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7f:	8b 50 08             	mov    0x8(%eax),%edx
  801a82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a85:	89 50 08             	mov    %edx,0x8(%eax)
  801a88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a8b:	8b 40 08             	mov    0x8(%eax),%eax
  801a8e:	85 c0                	test   %eax,%eax
  801a90:	74 0c                	je     801a9e <insert_page_alloc+0x140>
  801a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a95:	8b 40 08             	mov    0x8(%eax),%eax
  801a98:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a9b:	89 50 0c             	mov    %edx,0xc(%eax)
  801a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801aa4:	89 50 08             	mov    %edx,0x8(%eax)
  801aa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aaa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aad:	89 50 0c             	mov    %edx,0xc(%eax)
  801ab0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ab3:	8b 40 08             	mov    0x8(%eax),%eax
  801ab6:	85 c0                	test   %eax,%eax
  801ab8:	75 08                	jne    801ac2 <insert_page_alloc+0x164>
  801aba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801abd:	a3 28 50 80 00       	mov    %eax,0x805028
  801ac2:	a1 30 50 80 00       	mov    0x805030,%eax
  801ac7:	40                   	inc    %eax
  801ac8:	a3 30 50 80 00       	mov    %eax,0x805030
}
  801acd:	90                   	nop
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
  801ad3:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  801ad6:	a1 24 50 80 00       	mov    0x805024,%eax
  801adb:	85 c0                	test   %eax,%eax
  801add:	75 0c                	jne    801aeb <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  801adf:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801ae4:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  801ae9:	eb 67                	jmp    801b52 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  801aeb:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801af0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801af3:	a1 24 50 80 00       	mov    0x805024,%eax
  801af8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801afb:	eb 26                	jmp    801b23 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  801afd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b00:	8b 10                	mov    (%eax),%edx
  801b02:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b05:	8b 40 04             	mov    0x4(%eax),%eax
  801b08:	01 d0                	add    %edx,%eax
  801b0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  801b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b10:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b13:	76 06                	jbe    801b1b <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  801b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b18:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801b1b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801b20:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801b23:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801b27:	74 08                	je     801b31 <recompute_page_alloc_break+0x61>
  801b29:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b2c:	8b 40 08             	mov    0x8(%eax),%eax
  801b2f:	eb 05                	jmp    801b36 <recompute_page_alloc_break+0x66>
  801b31:	b8 00 00 00 00       	mov    $0x0,%eax
  801b36:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801b3b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801b40:	85 c0                	test   %eax,%eax
  801b42:	75 b9                	jne    801afd <recompute_page_alloc_break+0x2d>
  801b44:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801b48:	75 b3                	jne    801afd <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  801b4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b4d:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  801b5a:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801b61:	8b 55 08             	mov    0x8(%ebp),%edx
  801b64:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b67:	01 d0                	add    %edx,%eax
  801b69:	48                   	dec    %eax
  801b6a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801b6d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b70:	ba 00 00 00 00       	mov    $0x0,%edx
  801b75:	f7 75 d8             	divl   -0x28(%ebp)
  801b78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b7b:	29 d0                	sub    %edx,%eax
  801b7d:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  801b80:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801b84:	75 0a                	jne    801b90 <alloc_pages_custom_fit+0x3c>
		return NULL;
  801b86:	b8 00 00 00 00       	mov    $0x0,%eax
  801b8b:	e9 7e 01 00 00       	jmp    801d0e <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  801b90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  801b97:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801b9b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801ba2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  801ba9:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801bae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801bb1:	a1 24 50 80 00       	mov    0x805024,%eax
  801bb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801bb9:	eb 69                	jmp    801c24 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  801bbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bbe:	8b 00                	mov    (%eax),%eax
  801bc0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801bc3:	76 47                	jbe    801c0c <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  801bc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bc8:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  801bcb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bce:	8b 00                	mov    (%eax),%eax
  801bd0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801bd3:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  801bd6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801bd9:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801bdc:	72 2e                	jb     801c0c <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801bde:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801be2:	75 14                	jne    801bf8 <alloc_pages_custom_fit+0xa4>
  801be4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801be7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801bea:	75 0c                	jne    801bf8 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  801bec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801bef:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  801bf2:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801bf6:	eb 14                	jmp    801c0c <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  801bf8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801bfb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801bfe:	76 0c                	jbe    801c0c <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  801c00:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801c03:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  801c06:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c09:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  801c0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c0f:	8b 10                	mov    (%eax),%edx
  801c11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c14:	8b 40 04             	mov    0x4(%eax),%eax
  801c17:	01 d0                	add    %edx,%eax
  801c19:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801c1c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801c21:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801c24:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c28:	74 08                	je     801c32 <alloc_pages_custom_fit+0xde>
  801c2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c2d:	8b 40 08             	mov    0x8(%eax),%eax
  801c30:	eb 05                	jmp    801c37 <alloc_pages_custom_fit+0xe3>
  801c32:	b8 00 00 00 00       	mov    $0x0,%eax
  801c37:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801c3c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801c41:	85 c0                	test   %eax,%eax
  801c43:	0f 85 72 ff ff ff    	jne    801bbb <alloc_pages_custom_fit+0x67>
  801c49:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c4d:	0f 85 68 ff ff ff    	jne    801bbb <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  801c53:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801c58:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801c5b:	76 47                	jbe    801ca4 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  801c5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c60:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  801c63:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801c68:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801c6b:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  801c6e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c71:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801c74:	72 2e                	jb     801ca4 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  801c76:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801c7a:	75 14                	jne    801c90 <alloc_pages_custom_fit+0x13c>
  801c7c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c7f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801c82:	75 0c                	jne    801c90 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  801c84:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801c87:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  801c8a:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801c8e:	eb 14                	jmp    801ca4 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  801c90:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c93:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801c96:	76 0c                	jbe    801ca4 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  801c98:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801c9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801c9e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801ca1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  801ca4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  801cab:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801caf:	74 08                	je     801cb9 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  801cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801cb7:	eb 40                	jmp    801cf9 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  801cb9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801cbd:	74 08                	je     801cc7 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  801cbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cc2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801cc5:	eb 32                	jmp    801cf9 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  801cc7:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801ccc:	2b 45 d0             	sub    -0x30(%ebp),%eax
  801ccf:	89 c2                	mov    %eax,%edx
  801cd1:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801cd6:	39 c2                	cmp    %eax,%edx
  801cd8:	73 07                	jae    801ce1 <alloc_pages_custom_fit+0x18d>
			return NULL;
  801cda:	b8 00 00 00 00       	mov    $0x0,%eax
  801cdf:	eb 2d                	jmp    801d0e <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  801ce1:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801ce6:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  801ce9:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801cef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801cf2:	01 d0                	add    %edx,%eax
  801cf4:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  801cf9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cfc:	83 ec 08             	sub    $0x8,%esp
  801cff:	ff 75 d0             	pushl  -0x30(%ebp)
  801d02:	50                   	push   %eax
  801d03:	e8 56 fc ff ff       	call   80195e <insert_page_alloc>
  801d08:	83 c4 10             	add    $0x10,%esp

	return result;
  801d0b:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
  801d13:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  801d16:	8b 45 08             	mov    0x8(%ebp),%eax
  801d19:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801d1c:	a1 24 50 80 00       	mov    0x805024,%eax
  801d21:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801d24:	eb 1a                	jmp    801d40 <find_allocated_size+0x30>
		if (it->start == va)
  801d26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d29:	8b 00                	mov    (%eax),%eax
  801d2b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801d2e:	75 08                	jne    801d38 <find_allocated_size+0x28>
			return it->size;
  801d30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d33:	8b 40 04             	mov    0x4(%eax),%eax
  801d36:	eb 34                	jmp    801d6c <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801d38:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801d3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801d40:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d44:	74 08                	je     801d4e <find_allocated_size+0x3e>
  801d46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d49:	8b 40 08             	mov    0x8(%eax),%eax
  801d4c:	eb 05                	jmp    801d53 <find_allocated_size+0x43>
  801d4e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d53:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801d58:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801d5d:	85 c0                	test   %eax,%eax
  801d5f:	75 c5                	jne    801d26 <find_allocated_size+0x16>
  801d61:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d65:	75 bf                	jne    801d26 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  801d67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
  801d71:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801d7a:	a1 24 50 80 00       	mov    0x805024,%eax
  801d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d82:	e9 e1 01 00 00       	jmp    801f68 <free_pages+0x1fa>
		if (it->start == va) {
  801d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8a:	8b 00                	mov    (%eax),%eax
  801d8c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801d8f:	0f 85 cb 01 00 00    	jne    801f60 <free_pages+0x1f2>

			uint32 start = it->start;
  801d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d98:	8b 00                	mov    (%eax),%eax
  801d9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da0:	8b 40 04             	mov    0x4(%eax),%eax
  801da3:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801da6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801da9:	f7 d0                	not    %eax
  801dab:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801dae:	73 1d                	jae    801dcd <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801db0:	83 ec 0c             	sub    $0xc,%esp
  801db3:	ff 75 e4             	pushl  -0x1c(%ebp)
  801db6:	ff 75 e8             	pushl  -0x18(%ebp)
  801db9:	68 78 46 80 00       	push   $0x804678
  801dbe:	68 a5 00 00 00       	push   $0xa5
  801dc3:	68 11 46 80 00       	push   $0x804611
  801dc8:	e8 65 1b 00 00       	call   803932 <_panic>
			}

			uint32 start_end = start + size;
  801dcd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801dd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dd3:	01 d0                	add    %edx,%eax
  801dd5:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801dd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ddb:	85 c0                	test   %eax,%eax
  801ddd:	79 19                	jns    801df8 <free_pages+0x8a>
  801ddf:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801de6:	77 10                	ja     801df8 <free_pages+0x8a>
  801de8:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801def:	77 07                	ja     801df8 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  801df1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801df4:	85 c0                	test   %eax,%eax
  801df6:	78 2c                	js     801e24 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  801df8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dfb:	83 ec 0c             	sub    $0xc,%esp
  801dfe:	68 00 00 00 a0       	push   $0xa0000000
  801e03:	ff 75 e0             	pushl  -0x20(%ebp)
  801e06:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e09:	ff 75 e8             	pushl  -0x18(%ebp)
  801e0c:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e0f:	50                   	push   %eax
  801e10:	68 bc 46 80 00       	push   $0x8046bc
  801e15:	68 ad 00 00 00       	push   $0xad
  801e1a:	68 11 46 80 00       	push   $0x804611
  801e1f:	e8 0e 1b 00 00       	call   803932 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801e24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e2a:	e9 88 00 00 00       	jmp    801eb7 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  801e2f:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  801e36:	76 17                	jbe    801e4f <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  801e38:	ff 75 f0             	pushl  -0x10(%ebp)
  801e3b:	68 20 47 80 00       	push   $0x804720
  801e40:	68 b4 00 00 00       	push   $0xb4
  801e45:	68 11 46 80 00       	push   $0x804611
  801e4a:	e8 e3 1a 00 00       	call   803932 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  801e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e52:	05 00 10 00 00       	add    $0x1000,%eax
  801e57:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  801e5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e5d:	85 c0                	test   %eax,%eax
  801e5f:	79 2e                	jns    801e8f <free_pages+0x121>
  801e61:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801e68:	77 25                	ja     801e8f <free_pages+0x121>
  801e6a:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801e71:	77 1c                	ja     801e8f <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  801e73:	83 ec 08             	sub    $0x8,%esp
  801e76:	68 00 10 00 00       	push   $0x1000
  801e7b:	ff 75 f0             	pushl  -0x10(%ebp)
  801e7e:	e8 38 0d 00 00       	call   802bbb <sys_free_user_mem>
  801e83:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801e86:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801e8d:	eb 28                	jmp    801eb7 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  801e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e92:	68 00 00 00 a0       	push   $0xa0000000
  801e97:	ff 75 dc             	pushl  -0x24(%ebp)
  801e9a:	68 00 10 00 00       	push   $0x1000
  801e9f:	ff 75 f0             	pushl  -0x10(%ebp)
  801ea2:	50                   	push   %eax
  801ea3:	68 60 47 80 00       	push   $0x804760
  801ea8:	68 bd 00 00 00       	push   $0xbd
  801ead:	68 11 46 80 00       	push   $0x804611
  801eb2:	e8 7b 1a 00 00       	call   803932 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eba:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801ebd:	0f 82 6c ff ff ff    	jb     801e2f <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  801ec3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ec7:	75 17                	jne    801ee0 <free_pages+0x172>
  801ec9:	83 ec 04             	sub    $0x4,%esp
  801ecc:	68 c2 47 80 00       	push   $0x8047c2
  801ed1:	68 c1 00 00 00       	push   $0xc1
  801ed6:	68 11 46 80 00       	push   $0x804611
  801edb:	e8 52 1a 00 00       	call   803932 <_panic>
  801ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee3:	8b 40 08             	mov    0x8(%eax),%eax
  801ee6:	85 c0                	test   %eax,%eax
  801ee8:	74 11                	je     801efb <free_pages+0x18d>
  801eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eed:	8b 40 08             	mov    0x8(%eax),%eax
  801ef0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef3:	8b 52 0c             	mov    0xc(%edx),%edx
  801ef6:	89 50 0c             	mov    %edx,0xc(%eax)
  801ef9:	eb 0b                	jmp    801f06 <free_pages+0x198>
  801efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efe:	8b 40 0c             	mov    0xc(%eax),%eax
  801f01:	a3 28 50 80 00       	mov    %eax,0x805028
  801f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f09:	8b 40 0c             	mov    0xc(%eax),%eax
  801f0c:	85 c0                	test   %eax,%eax
  801f0e:	74 11                	je     801f21 <free_pages+0x1b3>
  801f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f13:	8b 40 0c             	mov    0xc(%eax),%eax
  801f16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f19:	8b 52 08             	mov    0x8(%edx),%edx
  801f1c:	89 50 08             	mov    %edx,0x8(%eax)
  801f1f:	eb 0b                	jmp    801f2c <free_pages+0x1be>
  801f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f24:	8b 40 08             	mov    0x8(%eax),%eax
  801f27:	a3 24 50 80 00       	mov    %eax,0x805024
  801f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f39:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801f40:	a1 30 50 80 00       	mov    0x805030,%eax
  801f45:	48                   	dec    %eax
  801f46:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  801f4b:	83 ec 0c             	sub    $0xc,%esp
  801f4e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f51:	e8 24 15 00 00       	call   80347a <free_block>
  801f56:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  801f59:	e8 72 fb ff ff       	call   801ad0 <recompute_page_alloc_break>

			return;
  801f5e:	eb 37                	jmp    801f97 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801f60:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f6c:	74 08                	je     801f76 <free_pages+0x208>
  801f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f71:	8b 40 08             	mov    0x8(%eax),%eax
  801f74:	eb 05                	jmp    801f7b <free_pages+0x20d>
  801f76:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801f80:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801f85:	85 c0                	test   %eax,%eax
  801f87:	0f 85 fa fd ff ff    	jne    801d87 <free_pages+0x19>
  801f8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f91:	0f 85 f0 fd ff ff    	jne    801d87 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  801f9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa1:	5d                   	pop    %ebp
  801fa2:	c3                   	ret    

00801fa3 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801fa9:	a1 08 50 80 00       	mov    0x805008,%eax
  801fae:	85 c0                	test   %eax,%eax
  801fb0:	74 60                	je     802012 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801fb2:	83 ec 08             	sub    $0x8,%esp
  801fb5:	68 00 00 00 82       	push   $0x82000000
  801fba:	68 00 00 00 80       	push   $0x80000000
  801fbf:	e8 0d 0d 00 00       	call   802cd1 <initialize_dynamic_allocator>
  801fc4:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801fc7:	e8 f3 0a 00 00       	call   802abf <sys_get_uheap_strategy>
  801fcc:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801fd1:	a1 40 50 80 00       	mov    0x805040,%eax
  801fd6:	05 00 10 00 00       	add    $0x1000,%eax
  801fdb:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  801fe0:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801fe5:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  801fea:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  801ff1:	00 00 00 
  801ff4:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  801ffb:	00 00 00 
  801ffe:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  802005:	00 00 00 

		__firstTimeFlag = 0;
  802008:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  80200f:	00 00 00 
	}
}
  802012:	90                   	nop
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
  802018:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80201b:	8b 45 08             	mov    0x8(%ebp),%eax
  80201e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802021:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802024:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802029:	83 ec 08             	sub    $0x8,%esp
  80202c:	68 06 04 00 00       	push   $0x406
  802031:	50                   	push   %eax
  802032:	e8 d2 06 00 00       	call   802709 <__sys_allocate_page>
  802037:	83 c4 10             	add    $0x10,%esp
  80203a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80203d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802041:	79 17                	jns    80205a <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  802043:	83 ec 04             	sub    $0x4,%esp
  802046:	68 e0 47 80 00       	push   $0x8047e0
  80204b:	68 ea 00 00 00       	push   $0xea
  802050:	68 11 46 80 00       	push   $0x804611
  802055:	e8 d8 18 00 00       	call   803932 <_panic>
	return 0;
  80205a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80205f:	c9                   	leave  
  802060:	c3                   	ret    

00802061 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802061:	55                   	push   %ebp
  802062:	89 e5                	mov    %esp,%ebp
  802064:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802067:	8b 45 08             	mov    0x8(%ebp),%eax
  80206a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80206d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802070:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802075:	83 ec 0c             	sub    $0xc,%esp
  802078:	50                   	push   %eax
  802079:	e8 d2 06 00 00       	call   802750 <__sys_unmap_frame>
  80207e:	83 c4 10             	add    $0x10,%esp
  802081:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802084:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802088:	79 17                	jns    8020a1 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  80208a:	83 ec 04             	sub    $0x4,%esp
  80208d:	68 1c 48 80 00       	push   $0x80481c
  802092:	68 f5 00 00 00       	push   $0xf5
  802097:	68 11 46 80 00       	push   $0x804611
  80209c:	e8 91 18 00 00       	call   803932 <_panic>
}
  8020a1:	90                   	nop
  8020a2:	c9                   	leave  
  8020a3:	c3                   	ret    

008020a4 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
  8020a7:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8020aa:	e8 f4 fe ff ff       	call   801fa3 <uheap_init>
	if (size == 0) return NULL ;
  8020af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020b3:	75 0a                	jne    8020bf <malloc+0x1b>
  8020b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ba:	e9 67 01 00 00       	jmp    802226 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  8020bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  8020c6:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8020cd:	77 16                	ja     8020e5 <malloc+0x41>
		result = alloc_block(size);
  8020cf:	83 ec 0c             	sub    $0xc,%esp
  8020d2:	ff 75 08             	pushl  0x8(%ebp)
  8020d5:	e8 46 0e 00 00       	call   802f20 <alloc_block>
  8020da:	83 c4 10             	add    $0x10,%esp
  8020dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020e0:	e9 3e 01 00 00       	jmp    802223 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  8020e5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8020ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8020ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f2:	01 d0                	add    %edx,%eax
  8020f4:	48                   	dec    %eax
  8020f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8020f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020fb:	ba 00 00 00 00       	mov    $0x0,%edx
  802100:	f7 75 f0             	divl   -0x10(%ebp)
  802103:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802106:	29 d0                	sub    %edx,%eax
  802108:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  80210b:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802110:	85 c0                	test   %eax,%eax
  802112:	75 0a                	jne    80211e <malloc+0x7a>
			return NULL;
  802114:	b8 00 00 00 00       	mov    $0x0,%eax
  802119:	e9 08 01 00 00       	jmp    802226 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  80211e:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802123:	85 c0                	test   %eax,%eax
  802125:	74 0f                	je     802136 <malloc+0x92>
  802127:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80212d:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802132:	39 c2                	cmp    %eax,%edx
  802134:	73 0a                	jae    802140 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  802136:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80213b:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  802140:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802145:	83 f8 05             	cmp    $0x5,%eax
  802148:	75 11                	jne    80215b <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  80214a:	83 ec 0c             	sub    $0xc,%esp
  80214d:	ff 75 e8             	pushl  -0x18(%ebp)
  802150:	e8 ff f9 ff ff       	call   801b54 <alloc_pages_custom_fit>
  802155:	83 c4 10             	add    $0x10,%esp
  802158:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  80215b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80215f:	0f 84 be 00 00 00    	je     802223 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  802165:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802168:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  80216b:	83 ec 0c             	sub    $0xc,%esp
  80216e:	ff 75 f4             	pushl  -0xc(%ebp)
  802171:	e8 9a fb ff ff       	call   801d10 <find_allocated_size>
  802176:	83 c4 10             	add    $0x10,%esp
  802179:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  80217c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802180:	75 17                	jne    802199 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  802182:	ff 75 f4             	pushl  -0xc(%ebp)
  802185:	68 5c 48 80 00       	push   $0x80485c
  80218a:	68 24 01 00 00       	push   $0x124
  80218f:	68 11 46 80 00       	push   $0x804611
  802194:	e8 99 17 00 00       	call   803932 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  802199:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80219c:	f7 d0                	not    %eax
  80219e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8021a1:	73 1d                	jae    8021c0 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  8021a3:	83 ec 0c             	sub    $0xc,%esp
  8021a6:	ff 75 e0             	pushl  -0x20(%ebp)
  8021a9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8021ac:	68 a4 48 80 00       	push   $0x8048a4
  8021b1:	68 29 01 00 00       	push   $0x129
  8021b6:	68 11 46 80 00       	push   $0x804611
  8021bb:	e8 72 17 00 00       	call   803932 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  8021c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021c6:	01 d0                	add    %edx,%eax
  8021c8:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  8021cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021ce:	85 c0                	test   %eax,%eax
  8021d0:	79 2c                	jns    8021fe <malloc+0x15a>
  8021d2:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  8021d9:	77 23                	ja     8021fe <malloc+0x15a>
  8021db:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  8021e2:	77 1a                	ja     8021fe <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  8021e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8021e7:	85 c0                	test   %eax,%eax
  8021e9:	79 13                	jns    8021fe <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  8021eb:	83 ec 08             	sub    $0x8,%esp
  8021ee:	ff 75 e0             	pushl  -0x20(%ebp)
  8021f1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8021f4:	e8 de 09 00 00       	call   802bd7 <sys_allocate_user_mem>
  8021f9:	83 c4 10             	add    $0x10,%esp
  8021fc:	eb 25                	jmp    802223 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  8021fe:	68 00 00 00 a0       	push   $0xa0000000
  802203:	ff 75 dc             	pushl  -0x24(%ebp)
  802206:	ff 75 e0             	pushl  -0x20(%ebp)
  802209:	ff 75 e4             	pushl  -0x1c(%ebp)
  80220c:	ff 75 f4             	pushl  -0xc(%ebp)
  80220f:	68 e0 48 80 00       	push   $0x8048e0
  802214:	68 33 01 00 00       	push   $0x133
  802219:	68 11 46 80 00       	push   $0x804611
  80221e:	e8 0f 17 00 00       	call   803932 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  802223:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
  80222b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  80222e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802232:	0f 84 26 01 00 00    	je     80235e <free+0x136>

	uint32 addr = (uint32)virtual_address;
  802238:	8b 45 08             	mov    0x8(%ebp),%eax
  80223b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  80223e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802241:	85 c0                	test   %eax,%eax
  802243:	79 1c                	jns    802261 <free+0x39>
  802245:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  80224c:	77 13                	ja     802261 <free+0x39>
		free_block(virtual_address);
  80224e:	83 ec 0c             	sub    $0xc,%esp
  802251:	ff 75 08             	pushl  0x8(%ebp)
  802254:	e8 21 12 00 00       	call   80347a <free_block>
  802259:	83 c4 10             	add    $0x10,%esp
		return;
  80225c:	e9 01 01 00 00       	jmp    802362 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  802261:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802266:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  802269:	0f 82 d8 00 00 00    	jb     802347 <free+0x11f>
  80226f:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  802276:	0f 87 cb 00 00 00    	ja     802347 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  80227c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227f:	25 ff 0f 00 00       	and    $0xfff,%eax
  802284:	85 c0                	test   %eax,%eax
  802286:	74 17                	je     80229f <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  802288:	ff 75 08             	pushl  0x8(%ebp)
  80228b:	68 50 49 80 00       	push   $0x804950
  802290:	68 57 01 00 00       	push   $0x157
  802295:	68 11 46 80 00       	push   $0x804611
  80229a:	e8 93 16 00 00       	call   803932 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  80229f:	83 ec 0c             	sub    $0xc,%esp
  8022a2:	ff 75 08             	pushl  0x8(%ebp)
  8022a5:	e8 66 fa ff ff       	call   801d10 <find_allocated_size>
  8022aa:	83 c4 10             	add    $0x10,%esp
  8022ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  8022b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022b4:	0f 84 a7 00 00 00    	je     802361 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  8022ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022bd:	f7 d0                	not    %eax
  8022bf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8022c2:	73 1d                	jae    8022e1 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  8022c4:	83 ec 0c             	sub    $0xc,%esp
  8022c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8022ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8022cd:	68 78 49 80 00       	push   $0x804978
  8022d2:	68 61 01 00 00       	push   $0x161
  8022d7:	68 11 46 80 00       	push   $0x804611
  8022dc:	e8 51 16 00 00       	call   803932 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  8022e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e7:	01 d0                	add    %edx,%eax
  8022e9:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  8022ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ef:	85 c0                	test   %eax,%eax
  8022f1:	79 19                	jns    80230c <free+0xe4>
  8022f3:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  8022fa:	77 10                	ja     80230c <free+0xe4>
  8022fc:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  802303:	77 07                	ja     80230c <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  802305:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802308:	85 c0                	test   %eax,%eax
  80230a:	78 2b                	js     802337 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  80230c:	83 ec 0c             	sub    $0xc,%esp
  80230f:	68 00 00 00 a0       	push   $0xa0000000
  802314:	ff 75 ec             	pushl  -0x14(%ebp)
  802317:	ff 75 f0             	pushl  -0x10(%ebp)
  80231a:	ff 75 f4             	pushl  -0xc(%ebp)
  80231d:	ff 75 f0             	pushl  -0x10(%ebp)
  802320:	ff 75 08             	pushl  0x8(%ebp)
  802323:	68 b4 49 80 00       	push   $0x8049b4
  802328:	68 69 01 00 00       	push   $0x169
  80232d:	68 11 46 80 00       	push   $0x804611
  802332:	e8 fb 15 00 00       	call   803932 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  802337:	83 ec 0c             	sub    $0xc,%esp
  80233a:	ff 75 08             	pushl  0x8(%ebp)
  80233d:	e8 2c fa ff ff       	call   801d6e <free_pages>
  802342:	83 c4 10             	add    $0x10,%esp
		return;
  802345:	eb 1b                	jmp    802362 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  802347:	ff 75 08             	pushl  0x8(%ebp)
  80234a:	68 10 4a 80 00       	push   $0x804a10
  80234f:	68 70 01 00 00       	push   $0x170
  802354:	68 11 46 80 00       	push   $0x804611
  802359:	e8 d4 15 00 00       	call   803932 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  80235e:	90                   	nop
  80235f:	eb 01                	jmp    802362 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  802361:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  802362:	c9                   	leave  
  802363:	c3                   	ret    

00802364 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802364:	55                   	push   %ebp
  802365:	89 e5                	mov    %esp,%ebp
  802367:	83 ec 38             	sub    $0x38,%esp
  80236a:	8b 45 10             	mov    0x10(%ebp),%eax
  80236d:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802370:	e8 2e fc ff ff       	call   801fa3 <uheap_init>
	if (size == 0) return NULL ;
  802375:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802379:	75 0a                	jne    802385 <smalloc+0x21>
  80237b:	b8 00 00 00 00       	mov    $0x0,%eax
  802380:	e9 3d 01 00 00       	jmp    8024c2 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  802385:	8b 45 0c             	mov    0xc(%ebp),%eax
  802388:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  80238b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80238e:	25 ff 0f 00 00       	and    $0xfff,%eax
  802393:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  802396:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80239a:	74 0e                	je     8023aa <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  80239c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239f:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8023a2:	05 00 10 00 00       	add    $0x1000,%eax
  8023a7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  8023aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ad:	c1 e8 0c             	shr    $0xc,%eax
  8023b0:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  8023b3:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8023b8:	85 c0                	test   %eax,%eax
  8023ba:	75 0a                	jne    8023c6 <smalloc+0x62>
		return NULL;
  8023bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c1:	e9 fc 00 00 00       	jmp    8024c2 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8023c6:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8023cb:	85 c0                	test   %eax,%eax
  8023cd:	74 0f                	je     8023de <smalloc+0x7a>
  8023cf:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8023d5:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8023da:	39 c2                	cmp    %eax,%edx
  8023dc:	73 0a                	jae    8023e8 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  8023de:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8023e3:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8023e8:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8023ed:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8023f2:	29 c2                	sub    %eax,%edx
  8023f4:	89 d0                	mov    %edx,%eax
  8023f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8023f9:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8023ff:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802404:	29 c2                	sub    %eax,%edx
  802406:	89 d0                	mov    %edx,%eax
  802408:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  80240b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802411:	77 13                	ja     802426 <smalloc+0xc2>
  802413:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802416:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802419:	77 0b                	ja     802426 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  80241b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80241e:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  802421:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802424:	73 0a                	jae    802430 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  802426:	b8 00 00 00 00       	mov    $0x0,%eax
  80242b:	e9 92 00 00 00       	jmp    8024c2 <smalloc+0x15e>
	}

	void *va = NULL;
  802430:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  802437:	a1 60 d0 81 00       	mov    0x81d060,%eax
  80243c:	83 f8 05             	cmp    $0x5,%eax
  80243f:	75 11                	jne    802452 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  802441:	83 ec 0c             	sub    $0xc,%esp
  802444:	ff 75 f4             	pushl  -0xc(%ebp)
  802447:	e8 08 f7 ff ff       	call   801b54 <alloc_pages_custom_fit>
  80244c:	83 c4 10             	add    $0x10,%esp
  80244f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  802452:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802456:	75 27                	jne    80247f <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802458:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  80245f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802462:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802465:	89 c2                	mov    %eax,%edx
  802467:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80246c:	39 c2                	cmp    %eax,%edx
  80246e:	73 07                	jae    802477 <smalloc+0x113>
			return NULL;}
  802470:	b8 00 00 00 00       	mov    $0x0,%eax
  802475:	eb 4b                	jmp    8024c2 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  802477:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80247c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  80247f:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802483:	ff 75 f0             	pushl  -0x10(%ebp)
  802486:	50                   	push   %eax
  802487:	ff 75 0c             	pushl  0xc(%ebp)
  80248a:	ff 75 08             	pushl  0x8(%ebp)
  80248d:	e8 cb 03 00 00       	call   80285d <sys_create_shared_object>
  802492:	83 c4 10             	add    $0x10,%esp
  802495:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  802498:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80249c:	79 07                	jns    8024a5 <smalloc+0x141>
		return NULL;
  80249e:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a3:	eb 1d                	jmp    8024c2 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  8024a5:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8024aa:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  8024ad:	75 10                	jne    8024bf <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  8024af:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8024b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b8:	01 d0                	add    %edx,%eax
  8024ba:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  8024bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  8024c2:	c9                   	leave  
  8024c3:	c3                   	ret    

008024c4 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8024c4:	55                   	push   %ebp
  8024c5:	89 e5                	mov    %esp,%ebp
  8024c7:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8024ca:	e8 d4 fa ff ff       	call   801fa3 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8024cf:	83 ec 08             	sub    $0x8,%esp
  8024d2:	ff 75 0c             	pushl  0xc(%ebp)
  8024d5:	ff 75 08             	pushl  0x8(%ebp)
  8024d8:	e8 aa 03 00 00       	call   802887 <sys_size_of_shared_object>
  8024dd:	83 c4 10             	add    $0x10,%esp
  8024e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  8024e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024e7:	7f 0a                	jg     8024f3 <sget+0x2f>
		return NULL;
  8024e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ee:	e9 32 01 00 00       	jmp    802625 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  8024f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  8024f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024fc:	25 ff 0f 00 00       	and    $0xfff,%eax
  802501:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  802504:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802508:	74 0e                	je     802518 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802510:	05 00 10 00 00       	add    $0x1000,%eax
  802515:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  802518:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80251d:	85 c0                	test   %eax,%eax
  80251f:	75 0a                	jne    80252b <sget+0x67>
		return NULL;
  802521:	b8 00 00 00 00       	mov    $0x0,%eax
  802526:	e9 fa 00 00 00       	jmp    802625 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  80252b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802530:	85 c0                	test   %eax,%eax
  802532:	74 0f                	je     802543 <sget+0x7f>
  802534:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80253a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80253f:	39 c2                	cmp    %eax,%edx
  802541:	73 0a                	jae    80254d <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  802543:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802548:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  80254d:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802552:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802557:	29 c2                	sub    %eax,%edx
  802559:	89 d0                	mov    %edx,%eax
  80255b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  80255e:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802564:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802569:	29 c2                	sub    %eax,%edx
  80256b:	89 d0                	mov    %edx,%eax
  80256d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802576:	77 13                	ja     80258b <sget+0xc7>
  802578:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80257b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80257e:	77 0b                	ja     80258b <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  802580:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802583:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802586:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802589:	73 0a                	jae    802595 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  80258b:	b8 00 00 00 00       	mov    $0x0,%eax
  802590:	e9 90 00 00 00       	jmp    802625 <sget+0x161>

	void *va = NULL;
  802595:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  80259c:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8025a1:	83 f8 05             	cmp    $0x5,%eax
  8025a4:	75 11                	jne    8025b7 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  8025a6:	83 ec 0c             	sub    $0xc,%esp
  8025a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8025ac:	e8 a3 f5 ff ff       	call   801b54 <alloc_pages_custom_fit>
  8025b1:	83 c4 10             	add    $0x10,%esp
  8025b4:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  8025b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025bb:	75 27                	jne    8025e4 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8025bd:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  8025c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025c7:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8025ca:	89 c2                	mov    %eax,%edx
  8025cc:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8025d1:	39 c2                	cmp    %eax,%edx
  8025d3:	73 07                	jae    8025dc <sget+0x118>
			return NULL;
  8025d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025da:	eb 49                	jmp    802625 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  8025dc:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8025e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  8025e4:	83 ec 04             	sub    $0x4,%esp
  8025e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8025ea:	ff 75 0c             	pushl  0xc(%ebp)
  8025ed:	ff 75 08             	pushl  0x8(%ebp)
  8025f0:	e8 af 02 00 00       	call   8028a4 <sys_get_shared_object>
  8025f5:	83 c4 10             	add    $0x10,%esp
  8025f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  8025fb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8025ff:	79 07                	jns    802608 <sget+0x144>
		return NULL;
  802601:	b8 00 00 00 00       	mov    $0x0,%eax
  802606:	eb 1d                	jmp    802625 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  802608:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80260d:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802610:	75 10                	jne    802622 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  802612:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261b:	01 d0                	add    %edx,%eax
  80261d:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  802622:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  802625:	c9                   	leave  
  802626:	c3                   	ret    

00802627 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802627:	55                   	push   %ebp
  802628:	89 e5                	mov    %esp,%ebp
  80262a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80262d:	e8 71 f9 ff ff       	call   801fa3 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802632:	83 ec 04             	sub    $0x4,%esp
  802635:	68 34 4a 80 00       	push   $0x804a34
  80263a:	68 19 02 00 00       	push   $0x219
  80263f:	68 11 46 80 00       	push   $0x804611
  802644:	e8 e9 12 00 00       	call   803932 <_panic>

00802649 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802649:	55                   	push   %ebp
  80264a:	89 e5                	mov    %esp,%ebp
  80264c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80264f:	83 ec 04             	sub    $0x4,%esp
  802652:	68 5c 4a 80 00       	push   $0x804a5c
  802657:	68 2b 02 00 00       	push   $0x22b
  80265c:	68 11 46 80 00       	push   $0x804611
  802661:	e8 cc 12 00 00       	call   803932 <_panic>

00802666 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802666:	55                   	push   %ebp
  802667:	89 e5                	mov    %esp,%ebp
  802669:	57                   	push   %edi
  80266a:	56                   	push   %esi
  80266b:	53                   	push   %ebx
  80266c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80266f:	8b 45 08             	mov    0x8(%ebp),%eax
  802672:	8b 55 0c             	mov    0xc(%ebp),%edx
  802675:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802678:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80267b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80267e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802681:	cd 30                	int    $0x30
  802683:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802686:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802689:	83 c4 10             	add    $0x10,%esp
  80268c:	5b                   	pop    %ebx
  80268d:	5e                   	pop    %esi
  80268e:	5f                   	pop    %edi
  80268f:	5d                   	pop    %ebp
  802690:	c3                   	ret    

00802691 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802691:	55                   	push   %ebp
  802692:	89 e5                	mov    %esp,%ebp
  802694:	83 ec 04             	sub    $0x4,%esp
  802697:	8b 45 10             	mov    0x10(%ebp),%eax
  80269a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80269d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8026a0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8026a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a7:	6a 00                	push   $0x0
  8026a9:	51                   	push   %ecx
  8026aa:	52                   	push   %edx
  8026ab:	ff 75 0c             	pushl  0xc(%ebp)
  8026ae:	50                   	push   %eax
  8026af:	6a 00                	push   $0x0
  8026b1:	e8 b0 ff ff ff       	call   802666 <syscall>
  8026b6:	83 c4 18             	add    $0x18,%esp
}
  8026b9:	90                   	nop
  8026ba:	c9                   	leave  
  8026bb:	c3                   	ret    

008026bc <sys_cgetc>:

int
sys_cgetc(void)
{
  8026bc:	55                   	push   %ebp
  8026bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8026bf:	6a 00                	push   $0x0
  8026c1:	6a 00                	push   $0x0
  8026c3:	6a 00                	push   $0x0
  8026c5:	6a 00                	push   $0x0
  8026c7:	6a 00                	push   $0x0
  8026c9:	6a 02                	push   $0x2
  8026cb:	e8 96 ff ff ff       	call   802666 <syscall>
  8026d0:	83 c4 18             	add    $0x18,%esp
}
  8026d3:	c9                   	leave  
  8026d4:	c3                   	ret    

008026d5 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8026d5:	55                   	push   %ebp
  8026d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8026d8:	6a 00                	push   $0x0
  8026da:	6a 00                	push   $0x0
  8026dc:	6a 00                	push   $0x0
  8026de:	6a 00                	push   $0x0
  8026e0:	6a 00                	push   $0x0
  8026e2:	6a 03                	push   $0x3
  8026e4:	e8 7d ff ff ff       	call   802666 <syscall>
  8026e9:	83 c4 18             	add    $0x18,%esp
}
  8026ec:	90                   	nop
  8026ed:	c9                   	leave  
  8026ee:	c3                   	ret    

008026ef <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8026ef:	55                   	push   %ebp
  8026f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8026f2:	6a 00                	push   $0x0
  8026f4:	6a 00                	push   $0x0
  8026f6:	6a 00                	push   $0x0
  8026f8:	6a 00                	push   $0x0
  8026fa:	6a 00                	push   $0x0
  8026fc:	6a 04                	push   $0x4
  8026fe:	e8 63 ff ff ff       	call   802666 <syscall>
  802703:	83 c4 18             	add    $0x18,%esp
}
  802706:	90                   	nop
  802707:	c9                   	leave  
  802708:	c3                   	ret    

00802709 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802709:	55                   	push   %ebp
  80270a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80270c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80270f:	8b 45 08             	mov    0x8(%ebp),%eax
  802712:	6a 00                	push   $0x0
  802714:	6a 00                	push   $0x0
  802716:	6a 00                	push   $0x0
  802718:	52                   	push   %edx
  802719:	50                   	push   %eax
  80271a:	6a 08                	push   $0x8
  80271c:	e8 45 ff ff ff       	call   802666 <syscall>
  802721:	83 c4 18             	add    $0x18,%esp
}
  802724:	c9                   	leave  
  802725:	c3                   	ret    

00802726 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802726:	55                   	push   %ebp
  802727:	89 e5                	mov    %esp,%ebp
  802729:	56                   	push   %esi
  80272a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80272b:	8b 75 18             	mov    0x18(%ebp),%esi
  80272e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802731:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802734:	8b 55 0c             	mov    0xc(%ebp),%edx
  802737:	8b 45 08             	mov    0x8(%ebp),%eax
  80273a:	56                   	push   %esi
  80273b:	53                   	push   %ebx
  80273c:	51                   	push   %ecx
  80273d:	52                   	push   %edx
  80273e:	50                   	push   %eax
  80273f:	6a 09                	push   $0x9
  802741:	e8 20 ff ff ff       	call   802666 <syscall>
  802746:	83 c4 18             	add    $0x18,%esp
}
  802749:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80274c:	5b                   	pop    %ebx
  80274d:	5e                   	pop    %esi
  80274e:	5d                   	pop    %ebp
  80274f:	c3                   	ret    

00802750 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802750:	55                   	push   %ebp
  802751:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802753:	6a 00                	push   $0x0
  802755:	6a 00                	push   $0x0
  802757:	6a 00                	push   $0x0
  802759:	6a 00                	push   $0x0
  80275b:	ff 75 08             	pushl  0x8(%ebp)
  80275e:	6a 0a                	push   $0xa
  802760:	e8 01 ff ff ff       	call   802666 <syscall>
  802765:	83 c4 18             	add    $0x18,%esp
}
  802768:	c9                   	leave  
  802769:	c3                   	ret    

0080276a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80276a:	55                   	push   %ebp
  80276b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80276d:	6a 00                	push   $0x0
  80276f:	6a 00                	push   $0x0
  802771:	6a 00                	push   $0x0
  802773:	ff 75 0c             	pushl  0xc(%ebp)
  802776:	ff 75 08             	pushl  0x8(%ebp)
  802779:	6a 0b                	push   $0xb
  80277b:	e8 e6 fe ff ff       	call   802666 <syscall>
  802780:	83 c4 18             	add    $0x18,%esp
}
  802783:	c9                   	leave  
  802784:	c3                   	ret    

00802785 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802785:	55                   	push   %ebp
  802786:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802788:	6a 00                	push   $0x0
  80278a:	6a 00                	push   $0x0
  80278c:	6a 00                	push   $0x0
  80278e:	6a 00                	push   $0x0
  802790:	6a 00                	push   $0x0
  802792:	6a 0c                	push   $0xc
  802794:	e8 cd fe ff ff       	call   802666 <syscall>
  802799:	83 c4 18             	add    $0x18,%esp
}
  80279c:	c9                   	leave  
  80279d:	c3                   	ret    

0080279e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80279e:	55                   	push   %ebp
  80279f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8027a1:	6a 00                	push   $0x0
  8027a3:	6a 00                	push   $0x0
  8027a5:	6a 00                	push   $0x0
  8027a7:	6a 00                	push   $0x0
  8027a9:	6a 00                	push   $0x0
  8027ab:	6a 0d                	push   $0xd
  8027ad:	e8 b4 fe ff ff       	call   802666 <syscall>
  8027b2:	83 c4 18             	add    $0x18,%esp
}
  8027b5:	c9                   	leave  
  8027b6:	c3                   	ret    

008027b7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8027b7:	55                   	push   %ebp
  8027b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8027ba:	6a 00                	push   $0x0
  8027bc:	6a 00                	push   $0x0
  8027be:	6a 00                	push   $0x0
  8027c0:	6a 00                	push   $0x0
  8027c2:	6a 00                	push   $0x0
  8027c4:	6a 0e                	push   $0xe
  8027c6:	e8 9b fe ff ff       	call   802666 <syscall>
  8027cb:	83 c4 18             	add    $0x18,%esp
}
  8027ce:	c9                   	leave  
  8027cf:	c3                   	ret    

008027d0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8027d0:	55                   	push   %ebp
  8027d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8027d3:	6a 00                	push   $0x0
  8027d5:	6a 00                	push   $0x0
  8027d7:	6a 00                	push   $0x0
  8027d9:	6a 00                	push   $0x0
  8027db:	6a 00                	push   $0x0
  8027dd:	6a 0f                	push   $0xf
  8027df:	e8 82 fe ff ff       	call   802666 <syscall>
  8027e4:	83 c4 18             	add    $0x18,%esp
}
  8027e7:	c9                   	leave  
  8027e8:	c3                   	ret    

008027e9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8027e9:	55                   	push   %ebp
  8027ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8027ec:	6a 00                	push   $0x0
  8027ee:	6a 00                	push   $0x0
  8027f0:	6a 00                	push   $0x0
  8027f2:	6a 00                	push   $0x0
  8027f4:	ff 75 08             	pushl  0x8(%ebp)
  8027f7:	6a 10                	push   $0x10
  8027f9:	e8 68 fe ff ff       	call   802666 <syscall>
  8027fe:	83 c4 18             	add    $0x18,%esp
}
  802801:	c9                   	leave  
  802802:	c3                   	ret    

00802803 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802803:	55                   	push   %ebp
  802804:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802806:	6a 00                	push   $0x0
  802808:	6a 00                	push   $0x0
  80280a:	6a 00                	push   $0x0
  80280c:	6a 00                	push   $0x0
  80280e:	6a 00                	push   $0x0
  802810:	6a 11                	push   $0x11
  802812:	e8 4f fe ff ff       	call   802666 <syscall>
  802817:	83 c4 18             	add    $0x18,%esp
}
  80281a:	90                   	nop
  80281b:	c9                   	leave  
  80281c:	c3                   	ret    

0080281d <sys_cputc>:

void
sys_cputc(const char c)
{
  80281d:	55                   	push   %ebp
  80281e:	89 e5                	mov    %esp,%ebp
  802820:	83 ec 04             	sub    $0x4,%esp
  802823:	8b 45 08             	mov    0x8(%ebp),%eax
  802826:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802829:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80282d:	6a 00                	push   $0x0
  80282f:	6a 00                	push   $0x0
  802831:	6a 00                	push   $0x0
  802833:	6a 00                	push   $0x0
  802835:	50                   	push   %eax
  802836:	6a 01                	push   $0x1
  802838:	e8 29 fe ff ff       	call   802666 <syscall>
  80283d:	83 c4 18             	add    $0x18,%esp
}
  802840:	90                   	nop
  802841:	c9                   	leave  
  802842:	c3                   	ret    

00802843 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802843:	55                   	push   %ebp
  802844:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802846:	6a 00                	push   $0x0
  802848:	6a 00                	push   $0x0
  80284a:	6a 00                	push   $0x0
  80284c:	6a 00                	push   $0x0
  80284e:	6a 00                	push   $0x0
  802850:	6a 14                	push   $0x14
  802852:	e8 0f fe ff ff       	call   802666 <syscall>
  802857:	83 c4 18             	add    $0x18,%esp
}
  80285a:	90                   	nop
  80285b:	c9                   	leave  
  80285c:	c3                   	ret    

0080285d <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80285d:	55                   	push   %ebp
  80285e:	89 e5                	mov    %esp,%ebp
  802860:	83 ec 04             	sub    $0x4,%esp
  802863:	8b 45 10             	mov    0x10(%ebp),%eax
  802866:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802869:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80286c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802870:	8b 45 08             	mov    0x8(%ebp),%eax
  802873:	6a 00                	push   $0x0
  802875:	51                   	push   %ecx
  802876:	52                   	push   %edx
  802877:	ff 75 0c             	pushl  0xc(%ebp)
  80287a:	50                   	push   %eax
  80287b:	6a 15                	push   $0x15
  80287d:	e8 e4 fd ff ff       	call   802666 <syscall>
  802882:	83 c4 18             	add    $0x18,%esp
}
  802885:	c9                   	leave  
  802886:	c3                   	ret    

00802887 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802887:	55                   	push   %ebp
  802888:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80288a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80288d:	8b 45 08             	mov    0x8(%ebp),%eax
  802890:	6a 00                	push   $0x0
  802892:	6a 00                	push   $0x0
  802894:	6a 00                	push   $0x0
  802896:	52                   	push   %edx
  802897:	50                   	push   %eax
  802898:	6a 16                	push   $0x16
  80289a:	e8 c7 fd ff ff       	call   802666 <syscall>
  80289f:	83 c4 18             	add    $0x18,%esp
}
  8028a2:	c9                   	leave  
  8028a3:	c3                   	ret    

008028a4 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8028a4:	55                   	push   %ebp
  8028a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8028a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b0:	6a 00                	push   $0x0
  8028b2:	6a 00                	push   $0x0
  8028b4:	51                   	push   %ecx
  8028b5:	52                   	push   %edx
  8028b6:	50                   	push   %eax
  8028b7:	6a 17                	push   $0x17
  8028b9:	e8 a8 fd ff ff       	call   802666 <syscall>
  8028be:	83 c4 18             	add    $0x18,%esp
}
  8028c1:	c9                   	leave  
  8028c2:	c3                   	ret    

008028c3 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8028c3:	55                   	push   %ebp
  8028c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8028c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cc:	6a 00                	push   $0x0
  8028ce:	6a 00                	push   $0x0
  8028d0:	6a 00                	push   $0x0
  8028d2:	52                   	push   %edx
  8028d3:	50                   	push   %eax
  8028d4:	6a 18                	push   $0x18
  8028d6:	e8 8b fd ff ff       	call   802666 <syscall>
  8028db:	83 c4 18             	add    $0x18,%esp
}
  8028de:	c9                   	leave  
  8028df:	c3                   	ret    

008028e0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8028e0:	55                   	push   %ebp
  8028e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8028e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e6:	6a 00                	push   $0x0
  8028e8:	ff 75 14             	pushl  0x14(%ebp)
  8028eb:	ff 75 10             	pushl  0x10(%ebp)
  8028ee:	ff 75 0c             	pushl  0xc(%ebp)
  8028f1:	50                   	push   %eax
  8028f2:	6a 19                	push   $0x19
  8028f4:	e8 6d fd ff ff       	call   802666 <syscall>
  8028f9:	83 c4 18             	add    $0x18,%esp
}
  8028fc:	c9                   	leave  
  8028fd:	c3                   	ret    

008028fe <sys_run_env>:

void sys_run_env(int32 envId)
{
  8028fe:	55                   	push   %ebp
  8028ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802901:	8b 45 08             	mov    0x8(%ebp),%eax
  802904:	6a 00                	push   $0x0
  802906:	6a 00                	push   $0x0
  802908:	6a 00                	push   $0x0
  80290a:	6a 00                	push   $0x0
  80290c:	50                   	push   %eax
  80290d:	6a 1a                	push   $0x1a
  80290f:	e8 52 fd ff ff       	call   802666 <syscall>
  802914:	83 c4 18             	add    $0x18,%esp
}
  802917:	90                   	nop
  802918:	c9                   	leave  
  802919:	c3                   	ret    

0080291a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80291a:	55                   	push   %ebp
  80291b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80291d:	8b 45 08             	mov    0x8(%ebp),%eax
  802920:	6a 00                	push   $0x0
  802922:	6a 00                	push   $0x0
  802924:	6a 00                	push   $0x0
  802926:	6a 00                	push   $0x0
  802928:	50                   	push   %eax
  802929:	6a 1b                	push   $0x1b
  80292b:	e8 36 fd ff ff       	call   802666 <syscall>
  802930:	83 c4 18             	add    $0x18,%esp
}
  802933:	c9                   	leave  
  802934:	c3                   	ret    

00802935 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802935:	55                   	push   %ebp
  802936:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802938:	6a 00                	push   $0x0
  80293a:	6a 00                	push   $0x0
  80293c:	6a 00                	push   $0x0
  80293e:	6a 00                	push   $0x0
  802940:	6a 00                	push   $0x0
  802942:	6a 05                	push   $0x5
  802944:	e8 1d fd ff ff       	call   802666 <syscall>
  802949:	83 c4 18             	add    $0x18,%esp
}
  80294c:	c9                   	leave  
  80294d:	c3                   	ret    

0080294e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80294e:	55                   	push   %ebp
  80294f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802951:	6a 00                	push   $0x0
  802953:	6a 00                	push   $0x0
  802955:	6a 00                	push   $0x0
  802957:	6a 00                	push   $0x0
  802959:	6a 00                	push   $0x0
  80295b:	6a 06                	push   $0x6
  80295d:	e8 04 fd ff ff       	call   802666 <syscall>
  802962:	83 c4 18             	add    $0x18,%esp
}
  802965:	c9                   	leave  
  802966:	c3                   	ret    

00802967 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802967:	55                   	push   %ebp
  802968:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80296a:	6a 00                	push   $0x0
  80296c:	6a 00                	push   $0x0
  80296e:	6a 00                	push   $0x0
  802970:	6a 00                	push   $0x0
  802972:	6a 00                	push   $0x0
  802974:	6a 07                	push   $0x7
  802976:	e8 eb fc ff ff       	call   802666 <syscall>
  80297b:	83 c4 18             	add    $0x18,%esp
}
  80297e:	c9                   	leave  
  80297f:	c3                   	ret    

00802980 <sys_exit_env>:


void sys_exit_env(void)
{
  802980:	55                   	push   %ebp
  802981:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802983:	6a 00                	push   $0x0
  802985:	6a 00                	push   $0x0
  802987:	6a 00                	push   $0x0
  802989:	6a 00                	push   $0x0
  80298b:	6a 00                	push   $0x0
  80298d:	6a 1c                	push   $0x1c
  80298f:	e8 d2 fc ff ff       	call   802666 <syscall>
  802994:	83 c4 18             	add    $0x18,%esp
}
  802997:	90                   	nop
  802998:	c9                   	leave  
  802999:	c3                   	ret    

0080299a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80299a:	55                   	push   %ebp
  80299b:	89 e5                	mov    %esp,%ebp
  80299d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8029a0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8029a3:	8d 50 04             	lea    0x4(%eax),%edx
  8029a6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8029a9:	6a 00                	push   $0x0
  8029ab:	6a 00                	push   $0x0
  8029ad:	6a 00                	push   $0x0
  8029af:	52                   	push   %edx
  8029b0:	50                   	push   %eax
  8029b1:	6a 1d                	push   $0x1d
  8029b3:	e8 ae fc ff ff       	call   802666 <syscall>
  8029b8:	83 c4 18             	add    $0x18,%esp
	return result;
  8029bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8029be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8029c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8029c4:	89 01                	mov    %eax,(%ecx)
  8029c6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8029c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cc:	c9                   	leave  
  8029cd:	c2 04 00             	ret    $0x4

008029d0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8029d0:	55                   	push   %ebp
  8029d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8029d3:	6a 00                	push   $0x0
  8029d5:	6a 00                	push   $0x0
  8029d7:	ff 75 10             	pushl  0x10(%ebp)
  8029da:	ff 75 0c             	pushl  0xc(%ebp)
  8029dd:	ff 75 08             	pushl  0x8(%ebp)
  8029e0:	6a 13                	push   $0x13
  8029e2:	e8 7f fc ff ff       	call   802666 <syscall>
  8029e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8029ea:	90                   	nop
}
  8029eb:	c9                   	leave  
  8029ec:	c3                   	ret    

008029ed <sys_rcr2>:
uint32 sys_rcr2()
{
  8029ed:	55                   	push   %ebp
  8029ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8029f0:	6a 00                	push   $0x0
  8029f2:	6a 00                	push   $0x0
  8029f4:	6a 00                	push   $0x0
  8029f6:	6a 00                	push   $0x0
  8029f8:	6a 00                	push   $0x0
  8029fa:	6a 1e                	push   $0x1e
  8029fc:	e8 65 fc ff ff       	call   802666 <syscall>
  802a01:	83 c4 18             	add    $0x18,%esp
}
  802a04:	c9                   	leave  
  802a05:	c3                   	ret    

00802a06 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802a06:	55                   	push   %ebp
  802a07:	89 e5                	mov    %esp,%ebp
  802a09:	83 ec 04             	sub    $0x4,%esp
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802a12:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802a16:	6a 00                	push   $0x0
  802a18:	6a 00                	push   $0x0
  802a1a:	6a 00                	push   $0x0
  802a1c:	6a 00                	push   $0x0
  802a1e:	50                   	push   %eax
  802a1f:	6a 1f                	push   $0x1f
  802a21:	e8 40 fc ff ff       	call   802666 <syscall>
  802a26:	83 c4 18             	add    $0x18,%esp
	return ;
  802a29:	90                   	nop
}
  802a2a:	c9                   	leave  
  802a2b:	c3                   	ret    

00802a2c <rsttst>:
void rsttst()
{
  802a2c:	55                   	push   %ebp
  802a2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802a2f:	6a 00                	push   $0x0
  802a31:	6a 00                	push   $0x0
  802a33:	6a 00                	push   $0x0
  802a35:	6a 00                	push   $0x0
  802a37:	6a 00                	push   $0x0
  802a39:	6a 21                	push   $0x21
  802a3b:	e8 26 fc ff ff       	call   802666 <syscall>
  802a40:	83 c4 18             	add    $0x18,%esp
	return ;
  802a43:	90                   	nop
}
  802a44:	c9                   	leave  
  802a45:	c3                   	ret    

00802a46 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802a46:	55                   	push   %ebp
  802a47:	89 e5                	mov    %esp,%ebp
  802a49:	83 ec 04             	sub    $0x4,%esp
  802a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  802a4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802a52:	8b 55 18             	mov    0x18(%ebp),%edx
  802a55:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a59:	52                   	push   %edx
  802a5a:	50                   	push   %eax
  802a5b:	ff 75 10             	pushl  0x10(%ebp)
  802a5e:	ff 75 0c             	pushl  0xc(%ebp)
  802a61:	ff 75 08             	pushl  0x8(%ebp)
  802a64:	6a 20                	push   $0x20
  802a66:	e8 fb fb ff ff       	call   802666 <syscall>
  802a6b:	83 c4 18             	add    $0x18,%esp
	return ;
  802a6e:	90                   	nop
}
  802a6f:	c9                   	leave  
  802a70:	c3                   	ret    

00802a71 <chktst>:
void chktst(uint32 n)
{
  802a71:	55                   	push   %ebp
  802a72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802a74:	6a 00                	push   $0x0
  802a76:	6a 00                	push   $0x0
  802a78:	6a 00                	push   $0x0
  802a7a:	6a 00                	push   $0x0
  802a7c:	ff 75 08             	pushl  0x8(%ebp)
  802a7f:	6a 22                	push   $0x22
  802a81:	e8 e0 fb ff ff       	call   802666 <syscall>
  802a86:	83 c4 18             	add    $0x18,%esp
	return ;
  802a89:	90                   	nop
}
  802a8a:	c9                   	leave  
  802a8b:	c3                   	ret    

00802a8c <inctst>:

void inctst()
{
  802a8c:	55                   	push   %ebp
  802a8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802a8f:	6a 00                	push   $0x0
  802a91:	6a 00                	push   $0x0
  802a93:	6a 00                	push   $0x0
  802a95:	6a 00                	push   $0x0
  802a97:	6a 00                	push   $0x0
  802a99:	6a 23                	push   $0x23
  802a9b:	e8 c6 fb ff ff       	call   802666 <syscall>
  802aa0:	83 c4 18             	add    $0x18,%esp
	return ;
  802aa3:	90                   	nop
}
  802aa4:	c9                   	leave  
  802aa5:	c3                   	ret    

00802aa6 <gettst>:
uint32 gettst()
{
  802aa6:	55                   	push   %ebp
  802aa7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802aa9:	6a 00                	push   $0x0
  802aab:	6a 00                	push   $0x0
  802aad:	6a 00                	push   $0x0
  802aaf:	6a 00                	push   $0x0
  802ab1:	6a 00                	push   $0x0
  802ab3:	6a 24                	push   $0x24
  802ab5:	e8 ac fb ff ff       	call   802666 <syscall>
  802aba:	83 c4 18             	add    $0x18,%esp
}
  802abd:	c9                   	leave  
  802abe:	c3                   	ret    

00802abf <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802abf:	55                   	push   %ebp
  802ac0:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ac2:	6a 00                	push   $0x0
  802ac4:	6a 00                	push   $0x0
  802ac6:	6a 00                	push   $0x0
  802ac8:	6a 00                	push   $0x0
  802aca:	6a 00                	push   $0x0
  802acc:	6a 25                	push   $0x25
  802ace:	e8 93 fb ff ff       	call   802666 <syscall>
  802ad3:	83 c4 18             	add    $0x18,%esp
  802ad6:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802adb:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  802ae0:	c9                   	leave  
  802ae1:	c3                   	ret    

00802ae2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802ae2:	55                   	push   %ebp
  802ae3:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae8:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802aed:	6a 00                	push   $0x0
  802aef:	6a 00                	push   $0x0
  802af1:	6a 00                	push   $0x0
  802af3:	6a 00                	push   $0x0
  802af5:	ff 75 08             	pushl  0x8(%ebp)
  802af8:	6a 26                	push   $0x26
  802afa:	e8 67 fb ff ff       	call   802666 <syscall>
  802aff:	83 c4 18             	add    $0x18,%esp
	return ;
  802b02:	90                   	nop
}
  802b03:	c9                   	leave  
  802b04:	c3                   	ret    

00802b05 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802b05:	55                   	push   %ebp
  802b06:	89 e5                	mov    %esp,%ebp
  802b08:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802b09:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b0c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b12:	8b 45 08             	mov    0x8(%ebp),%eax
  802b15:	6a 00                	push   $0x0
  802b17:	53                   	push   %ebx
  802b18:	51                   	push   %ecx
  802b19:	52                   	push   %edx
  802b1a:	50                   	push   %eax
  802b1b:	6a 27                	push   $0x27
  802b1d:	e8 44 fb ff ff       	call   802666 <syscall>
  802b22:	83 c4 18             	add    $0x18,%esp
}
  802b25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b28:	c9                   	leave  
  802b29:	c3                   	ret    

00802b2a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802b2a:	55                   	push   %ebp
  802b2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802b2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b30:	8b 45 08             	mov    0x8(%ebp),%eax
  802b33:	6a 00                	push   $0x0
  802b35:	6a 00                	push   $0x0
  802b37:	6a 00                	push   $0x0
  802b39:	52                   	push   %edx
  802b3a:	50                   	push   %eax
  802b3b:	6a 28                	push   $0x28
  802b3d:	e8 24 fb ff ff       	call   802666 <syscall>
  802b42:	83 c4 18             	add    $0x18,%esp
}
  802b45:	c9                   	leave  
  802b46:	c3                   	ret    

00802b47 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802b47:	55                   	push   %ebp
  802b48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802b4a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802b4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b50:	8b 45 08             	mov    0x8(%ebp),%eax
  802b53:	6a 00                	push   $0x0
  802b55:	51                   	push   %ecx
  802b56:	ff 75 10             	pushl  0x10(%ebp)
  802b59:	52                   	push   %edx
  802b5a:	50                   	push   %eax
  802b5b:	6a 29                	push   $0x29
  802b5d:	e8 04 fb ff ff       	call   802666 <syscall>
  802b62:	83 c4 18             	add    $0x18,%esp
}
  802b65:	c9                   	leave  
  802b66:	c3                   	ret    

00802b67 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802b67:	55                   	push   %ebp
  802b68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802b6a:	6a 00                	push   $0x0
  802b6c:	6a 00                	push   $0x0
  802b6e:	ff 75 10             	pushl  0x10(%ebp)
  802b71:	ff 75 0c             	pushl  0xc(%ebp)
  802b74:	ff 75 08             	pushl  0x8(%ebp)
  802b77:	6a 12                	push   $0x12
  802b79:	e8 e8 fa ff ff       	call   802666 <syscall>
  802b7e:	83 c4 18             	add    $0x18,%esp
	return ;
  802b81:	90                   	nop
}
  802b82:	c9                   	leave  
  802b83:	c3                   	ret    

00802b84 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802b84:	55                   	push   %ebp
  802b85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802b87:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8d:	6a 00                	push   $0x0
  802b8f:	6a 00                	push   $0x0
  802b91:	6a 00                	push   $0x0
  802b93:	52                   	push   %edx
  802b94:	50                   	push   %eax
  802b95:	6a 2a                	push   $0x2a
  802b97:	e8 ca fa ff ff       	call   802666 <syscall>
  802b9c:	83 c4 18             	add    $0x18,%esp
	return;
  802b9f:	90                   	nop
}
  802ba0:	c9                   	leave  
  802ba1:	c3                   	ret    

00802ba2 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802ba2:	55                   	push   %ebp
  802ba3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802ba5:	6a 00                	push   $0x0
  802ba7:	6a 00                	push   $0x0
  802ba9:	6a 00                	push   $0x0
  802bab:	6a 00                	push   $0x0
  802bad:	6a 00                	push   $0x0
  802baf:	6a 2b                	push   $0x2b
  802bb1:	e8 b0 fa ff ff       	call   802666 <syscall>
  802bb6:	83 c4 18             	add    $0x18,%esp
}
  802bb9:	c9                   	leave  
  802bba:	c3                   	ret    

00802bbb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802bbb:	55                   	push   %ebp
  802bbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802bbe:	6a 00                	push   $0x0
  802bc0:	6a 00                	push   $0x0
  802bc2:	6a 00                	push   $0x0
  802bc4:	ff 75 0c             	pushl  0xc(%ebp)
  802bc7:	ff 75 08             	pushl  0x8(%ebp)
  802bca:	6a 2d                	push   $0x2d
  802bcc:	e8 95 fa ff ff       	call   802666 <syscall>
  802bd1:	83 c4 18             	add    $0x18,%esp
	return;
  802bd4:	90                   	nop
}
  802bd5:	c9                   	leave  
  802bd6:	c3                   	ret    

00802bd7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802bd7:	55                   	push   %ebp
  802bd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802bda:	6a 00                	push   $0x0
  802bdc:	6a 00                	push   $0x0
  802bde:	6a 00                	push   $0x0
  802be0:	ff 75 0c             	pushl  0xc(%ebp)
  802be3:	ff 75 08             	pushl  0x8(%ebp)
  802be6:	6a 2c                	push   $0x2c
  802be8:	e8 79 fa ff ff       	call   802666 <syscall>
  802bed:	83 c4 18             	add    $0x18,%esp
	return ;
  802bf0:	90                   	nop
}
  802bf1:	c9                   	leave  
  802bf2:	c3                   	ret    

00802bf3 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802bf3:	55                   	push   %ebp
  802bf4:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802bf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfc:	6a 00                	push   $0x0
  802bfe:	6a 00                	push   $0x0
  802c00:	6a 00                	push   $0x0
  802c02:	52                   	push   %edx
  802c03:	50                   	push   %eax
  802c04:	6a 2e                	push   $0x2e
  802c06:	e8 5b fa ff ff       	call   802666 <syscall>
  802c0b:	83 c4 18             	add    $0x18,%esp
	return ;
  802c0e:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  802c0f:	c9                   	leave  
  802c10:	c3                   	ret    

00802c11 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802c11:	55                   	push   %ebp
  802c12:	89 e5                	mov    %esp,%ebp
  802c14:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802c17:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  802c1e:	72 09                	jb     802c29 <to_page_va+0x18>
  802c20:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  802c27:	72 14                	jb     802c3d <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802c29:	83 ec 04             	sub    $0x4,%esp
  802c2c:	68 80 4a 80 00       	push   $0x804a80
  802c31:	6a 15                	push   $0x15
  802c33:	68 ab 4a 80 00       	push   $0x804aab
  802c38:	e8 f5 0c 00 00       	call   803932 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c40:	ba 60 50 80 00       	mov    $0x805060,%edx
  802c45:	29 d0                	sub    %edx,%eax
  802c47:	c1 f8 02             	sar    $0x2,%eax
  802c4a:	89 c2                	mov    %eax,%edx
  802c4c:	89 d0                	mov    %edx,%eax
  802c4e:	c1 e0 02             	shl    $0x2,%eax
  802c51:	01 d0                	add    %edx,%eax
  802c53:	c1 e0 02             	shl    $0x2,%eax
  802c56:	01 d0                	add    %edx,%eax
  802c58:	c1 e0 02             	shl    $0x2,%eax
  802c5b:	01 d0                	add    %edx,%eax
  802c5d:	89 c1                	mov    %eax,%ecx
  802c5f:	c1 e1 08             	shl    $0x8,%ecx
  802c62:	01 c8                	add    %ecx,%eax
  802c64:	89 c1                	mov    %eax,%ecx
  802c66:	c1 e1 10             	shl    $0x10,%ecx
  802c69:	01 c8                	add    %ecx,%eax
  802c6b:	01 c0                	add    %eax,%eax
  802c6d:	01 d0                	add    %edx,%eax
  802c6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c75:	c1 e0 0c             	shl    $0xc,%eax
  802c78:	89 c2                	mov    %eax,%edx
  802c7a:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802c7f:	01 d0                	add    %edx,%eax
}
  802c81:	c9                   	leave  
  802c82:	c3                   	ret    

00802c83 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802c83:	55                   	push   %ebp
  802c84:	89 e5                	mov    %esp,%ebp
  802c86:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802c89:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802c8e:	8b 55 08             	mov    0x8(%ebp),%edx
  802c91:	29 c2                	sub    %eax,%edx
  802c93:	89 d0                	mov    %edx,%eax
  802c95:	c1 e8 0c             	shr    $0xc,%eax
  802c98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802c9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c9f:	78 09                	js     802caa <to_page_info+0x27>
  802ca1:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802ca8:	7e 14                	jle    802cbe <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802caa:	83 ec 04             	sub    $0x4,%esp
  802cad:	68 c4 4a 80 00       	push   $0x804ac4
  802cb2:	6a 22                	push   $0x22
  802cb4:	68 ab 4a 80 00       	push   $0x804aab
  802cb9:	e8 74 0c 00 00       	call   803932 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802cbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc1:	89 d0                	mov    %edx,%eax
  802cc3:	01 c0                	add    %eax,%eax
  802cc5:	01 d0                	add    %edx,%eax
  802cc7:	c1 e0 02             	shl    $0x2,%eax
  802cca:	05 60 50 80 00       	add    $0x805060,%eax
}
  802ccf:	c9                   	leave  
  802cd0:	c3                   	ret    

00802cd1 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802cd1:	55                   	push   %ebp
  802cd2:	89 e5                	mov    %esp,%ebp
  802cd4:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cda:	05 00 00 00 02       	add    $0x2000000,%eax
  802cdf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ce2:	73 16                	jae    802cfa <initialize_dynamic_allocator+0x29>
  802ce4:	68 e8 4a 80 00       	push   $0x804ae8
  802ce9:	68 0e 4b 80 00       	push   $0x804b0e
  802cee:	6a 34                	push   $0x34
  802cf0:	68 ab 4a 80 00       	push   $0x804aab
  802cf5:	e8 38 0c 00 00       	call   803932 <_panic>
		is_initialized = 1;
  802cfa:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  802d01:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  802d04:	8b 45 08             	mov    0x8(%ebp),%eax
  802d07:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  802d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d0f:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  802d14:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  802d1b:	00 00 00 
  802d1e:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802d25:	00 00 00 
  802d28:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  802d2f:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  802d32:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  802d39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d40:	eb 36                	jmp    802d78 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  802d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d45:	c1 e0 04             	shl    $0x4,%eax
  802d48:	05 80 d0 81 00       	add    $0x81d080,%eax
  802d4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d56:	c1 e0 04             	shl    $0x4,%eax
  802d59:	05 84 d0 81 00       	add    $0x81d084,%eax
  802d5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d67:	c1 e0 04             	shl    $0x4,%eax
  802d6a:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802d6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  802d75:	ff 45 f4             	incl   -0xc(%ebp)
  802d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802d7e:	72 c2                	jb     802d42 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  802d80:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802d86:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802d8b:	29 c2                	sub    %eax,%edx
  802d8d:	89 d0                	mov    %edx,%eax
  802d8f:	c1 e8 0c             	shr    $0xc,%eax
  802d92:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802d95:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802d9c:	e9 c8 00 00 00       	jmp    802e69 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802da1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802da4:	89 d0                	mov    %edx,%eax
  802da6:	01 c0                	add    %eax,%eax
  802da8:	01 d0                	add    %edx,%eax
  802daa:	c1 e0 02             	shl    $0x2,%eax
  802dad:	05 68 50 80 00       	add    $0x805068,%eax
  802db2:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802db7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dba:	89 d0                	mov    %edx,%eax
  802dbc:	01 c0                	add    %eax,%eax
  802dbe:	01 d0                	add    %edx,%eax
  802dc0:	c1 e0 02             	shl    $0x2,%eax
  802dc3:	05 6a 50 80 00       	add    $0x80506a,%eax
  802dc8:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802dcd:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802dd3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802dd6:	89 c8                	mov    %ecx,%eax
  802dd8:	01 c0                	add    %eax,%eax
  802dda:	01 c8                	add    %ecx,%eax
  802ddc:	c1 e0 02             	shl    $0x2,%eax
  802ddf:	05 64 50 80 00       	add    $0x805064,%eax
  802de4:	89 10                	mov    %edx,(%eax)
  802de6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802de9:	89 d0                	mov    %edx,%eax
  802deb:	01 c0                	add    %eax,%eax
  802ded:	01 d0                	add    %edx,%eax
  802def:	c1 e0 02             	shl    $0x2,%eax
  802df2:	05 64 50 80 00       	add    $0x805064,%eax
  802df7:	8b 00                	mov    (%eax),%eax
  802df9:	85 c0                	test   %eax,%eax
  802dfb:	74 1b                	je     802e18 <initialize_dynamic_allocator+0x147>
  802dfd:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802e03:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802e06:	89 c8                	mov    %ecx,%eax
  802e08:	01 c0                	add    %eax,%eax
  802e0a:	01 c8                	add    %ecx,%eax
  802e0c:	c1 e0 02             	shl    $0x2,%eax
  802e0f:	05 60 50 80 00       	add    $0x805060,%eax
  802e14:	89 02                	mov    %eax,(%edx)
  802e16:	eb 16                	jmp    802e2e <initialize_dynamic_allocator+0x15d>
  802e18:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e1b:	89 d0                	mov    %edx,%eax
  802e1d:	01 c0                	add    %eax,%eax
  802e1f:	01 d0                	add    %edx,%eax
  802e21:	c1 e0 02             	shl    $0x2,%eax
  802e24:	05 60 50 80 00       	add    $0x805060,%eax
  802e29:	a3 48 50 80 00       	mov    %eax,0x805048
  802e2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e31:	89 d0                	mov    %edx,%eax
  802e33:	01 c0                	add    %eax,%eax
  802e35:	01 d0                	add    %edx,%eax
  802e37:	c1 e0 02             	shl    $0x2,%eax
  802e3a:	05 60 50 80 00       	add    $0x805060,%eax
  802e3f:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802e44:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e47:	89 d0                	mov    %edx,%eax
  802e49:	01 c0                	add    %eax,%eax
  802e4b:	01 d0                	add    %edx,%eax
  802e4d:	c1 e0 02             	shl    $0x2,%eax
  802e50:	05 60 50 80 00       	add    $0x805060,%eax
  802e55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e5b:	a1 54 50 80 00       	mov    0x805054,%eax
  802e60:	40                   	inc    %eax
  802e61:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  802e66:	ff 45 f0             	incl   -0x10(%ebp)
  802e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e6f:	0f 82 2c ff ff ff    	jb     802da1 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802e75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e78:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802e7b:	eb 2f                	jmp    802eac <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  802e7d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e80:	89 d0                	mov    %edx,%eax
  802e82:	01 c0                	add    %eax,%eax
  802e84:	01 d0                	add    %edx,%eax
  802e86:	c1 e0 02             	shl    $0x2,%eax
  802e89:	05 68 50 80 00       	add    $0x805068,%eax
  802e8e:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  802e93:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e96:	89 d0                	mov    %edx,%eax
  802e98:	01 c0                	add    %eax,%eax
  802e9a:	01 d0                	add    %edx,%eax
  802e9c:	c1 e0 02             	shl    $0x2,%eax
  802e9f:	05 6a 50 80 00       	add    $0x80506a,%eax
  802ea4:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802ea9:	ff 45 ec             	incl   -0x14(%ebp)
  802eac:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  802eb3:	76 c8                	jbe    802e7d <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802eb5:	90                   	nop
  802eb6:	c9                   	leave  
  802eb7:	c3                   	ret    

00802eb8 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802eb8:	55                   	push   %ebp
  802eb9:	89 e5                	mov    %esp,%ebp
  802ebb:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  802ebe:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec1:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802ec6:	29 c2                	sub    %eax,%edx
  802ec8:	89 d0                	mov    %edx,%eax
  802eca:	c1 e8 0c             	shr    $0xc,%eax
  802ecd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  802ed0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802ed3:	89 d0                	mov    %edx,%eax
  802ed5:	01 c0                	add    %eax,%eax
  802ed7:	01 d0                	add    %edx,%eax
  802ed9:	c1 e0 02             	shl    $0x2,%eax
  802edc:	05 68 50 80 00       	add    $0x805068,%eax
  802ee1:	8b 00                	mov    (%eax),%eax
  802ee3:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802ee6:	c9                   	leave  
  802ee7:	c3                   	ret    

00802ee8 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802ee8:	55                   	push   %ebp
  802ee9:	89 e5                	mov    %esp,%ebp
  802eeb:	83 ec 14             	sub    $0x14,%esp
  802eee:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  802ef1:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  802ef5:	77 07                	ja     802efe <nearest_pow2_ceil.1513+0x16>
  802ef7:	b8 01 00 00 00       	mov    $0x1,%eax
  802efc:	eb 20                	jmp    802f1e <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  802efe:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  802f05:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  802f08:	eb 08                	jmp    802f12 <nearest_pow2_ceil.1513+0x2a>
  802f0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f0d:	01 c0                	add    %eax,%eax
  802f0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802f12:	d1 6d 08             	shrl   0x8(%ebp)
  802f15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f19:	75 ef                	jne    802f0a <nearest_pow2_ceil.1513+0x22>
        return power;
  802f1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802f1e:	c9                   	leave  
  802f1f:	c3                   	ret    

00802f20 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802f20:	55                   	push   %ebp
  802f21:	89 e5                	mov    %esp,%ebp
  802f23:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802f26:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802f2d:	76 16                	jbe    802f45 <alloc_block+0x25>
  802f2f:	68 24 4b 80 00       	push   $0x804b24
  802f34:	68 0e 4b 80 00       	push   $0x804b0e
  802f39:	6a 72                	push   $0x72
  802f3b:	68 ab 4a 80 00       	push   $0x804aab
  802f40:	e8 ed 09 00 00       	call   803932 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  802f45:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f49:	75 0a                	jne    802f55 <alloc_block+0x35>
  802f4b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f50:	e9 bd 04 00 00       	jmp    803412 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  802f55:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  802f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802f62:	73 06                	jae    802f6a <alloc_block+0x4a>
        size = min_block_size;
  802f64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f67:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  802f6a:	83 ec 0c             	sub    $0xc,%esp
  802f6d:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802f70:	ff 75 08             	pushl  0x8(%ebp)
  802f73:	89 c1                	mov    %eax,%ecx
  802f75:	e8 6e ff ff ff       	call   802ee8 <nearest_pow2_ceil.1513>
  802f7a:	83 c4 10             	add    $0x10,%esp
  802f7d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  802f80:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f83:	83 ec 0c             	sub    $0xc,%esp
  802f86:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802f89:	52                   	push   %edx
  802f8a:	89 c1                	mov    %eax,%ecx
  802f8c:	e8 83 04 00 00       	call   803414 <log2_ceil.1520>
  802f91:	83 c4 10             	add    $0x10,%esp
  802f94:	83 e8 03             	sub    $0x3,%eax
  802f97:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  802f9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f9d:	c1 e0 04             	shl    $0x4,%eax
  802fa0:	05 80 d0 81 00       	add    $0x81d080,%eax
  802fa5:	8b 00                	mov    (%eax),%eax
  802fa7:	85 c0                	test   %eax,%eax
  802fa9:	0f 84 d8 00 00 00    	je     803087 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802faf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb2:	c1 e0 04             	shl    $0x4,%eax
  802fb5:	05 80 d0 81 00       	add    $0x81d080,%eax
  802fba:	8b 00                	mov    (%eax),%eax
  802fbc:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802fbf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802fc3:	75 17                	jne    802fdc <alloc_block+0xbc>
  802fc5:	83 ec 04             	sub    $0x4,%esp
  802fc8:	68 45 4b 80 00       	push   $0x804b45
  802fcd:	68 98 00 00 00       	push   $0x98
  802fd2:	68 ab 4a 80 00       	push   $0x804aab
  802fd7:	e8 56 09 00 00       	call   803932 <_panic>
  802fdc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fdf:	8b 00                	mov    (%eax),%eax
  802fe1:	85 c0                	test   %eax,%eax
  802fe3:	74 10                	je     802ff5 <alloc_block+0xd5>
  802fe5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fe8:	8b 00                	mov    (%eax),%eax
  802fea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fed:	8b 52 04             	mov    0x4(%edx),%edx
  802ff0:	89 50 04             	mov    %edx,0x4(%eax)
  802ff3:	eb 14                	jmp    803009 <alloc_block+0xe9>
  802ff5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ff8:	8b 40 04             	mov    0x4(%eax),%eax
  802ffb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ffe:	c1 e2 04             	shl    $0x4,%edx
  803001:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803007:	89 02                	mov    %eax,(%edx)
  803009:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80300c:	8b 40 04             	mov    0x4(%eax),%eax
  80300f:	85 c0                	test   %eax,%eax
  803011:	74 0f                	je     803022 <alloc_block+0x102>
  803013:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803016:	8b 40 04             	mov    0x4(%eax),%eax
  803019:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80301c:	8b 12                	mov    (%edx),%edx
  80301e:	89 10                	mov    %edx,(%eax)
  803020:	eb 13                	jmp    803035 <alloc_block+0x115>
  803022:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803025:	8b 00                	mov    (%eax),%eax
  803027:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80302a:	c1 e2 04             	shl    $0x4,%edx
  80302d:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803033:	89 02                	mov    %eax,(%edx)
  803035:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803038:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80303e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803041:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803048:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80304b:	c1 e0 04             	shl    $0x4,%eax
  80304e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803053:	8b 00                	mov    (%eax),%eax
  803055:	8d 50 ff             	lea    -0x1(%eax),%edx
  803058:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80305b:	c1 e0 04             	shl    $0x4,%eax
  80305e:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803063:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803065:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803068:	83 ec 0c             	sub    $0xc,%esp
  80306b:	50                   	push   %eax
  80306c:	e8 12 fc ff ff       	call   802c83 <to_page_info>
  803071:	83 c4 10             	add    $0x10,%esp
  803074:	89 c2                	mov    %eax,%edx
  803076:	66 8b 42 0a          	mov    0xa(%edx),%ax
  80307a:	48                   	dec    %eax
  80307b:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  80307f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803082:	e9 8b 03 00 00       	jmp    803412 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  803087:	a1 48 50 80 00       	mov    0x805048,%eax
  80308c:	85 c0                	test   %eax,%eax
  80308e:	0f 84 64 02 00 00    	je     8032f8 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  803094:	a1 48 50 80 00       	mov    0x805048,%eax
  803099:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  80309c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030a0:	75 17                	jne    8030b9 <alloc_block+0x199>
  8030a2:	83 ec 04             	sub    $0x4,%esp
  8030a5:	68 45 4b 80 00       	push   $0x804b45
  8030aa:	68 a0 00 00 00       	push   $0xa0
  8030af:	68 ab 4a 80 00       	push   $0x804aab
  8030b4:	e8 79 08 00 00       	call   803932 <_panic>
  8030b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030bc:	8b 00                	mov    (%eax),%eax
  8030be:	85 c0                	test   %eax,%eax
  8030c0:	74 10                	je     8030d2 <alloc_block+0x1b2>
  8030c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c5:	8b 00                	mov    (%eax),%eax
  8030c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030ca:	8b 52 04             	mov    0x4(%edx),%edx
  8030cd:	89 50 04             	mov    %edx,0x4(%eax)
  8030d0:	eb 0b                	jmp    8030dd <alloc_block+0x1bd>
  8030d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030d5:	8b 40 04             	mov    0x4(%eax),%eax
  8030d8:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8030dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e0:	8b 40 04             	mov    0x4(%eax),%eax
  8030e3:	85 c0                	test   %eax,%eax
  8030e5:	74 0f                	je     8030f6 <alloc_block+0x1d6>
  8030e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ea:	8b 40 04             	mov    0x4(%eax),%eax
  8030ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030f0:	8b 12                	mov    (%edx),%edx
  8030f2:	89 10                	mov    %edx,(%eax)
  8030f4:	eb 0a                	jmp    803100 <alloc_block+0x1e0>
  8030f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f9:	8b 00                	mov    (%eax),%eax
  8030fb:	a3 48 50 80 00       	mov    %eax,0x805048
  803100:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803103:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803109:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80310c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803113:	a1 54 50 80 00       	mov    0x805054,%eax
  803118:	48                   	dec    %eax
  803119:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  80311e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803121:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803124:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  803128:	b8 00 10 00 00       	mov    $0x1000,%eax
  80312d:	99                   	cltd   
  80312e:	f7 7d e8             	idivl  -0x18(%ebp)
  803131:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803134:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  803138:	83 ec 0c             	sub    $0xc,%esp
  80313b:	ff 75 dc             	pushl  -0x24(%ebp)
  80313e:	e8 ce fa ff ff       	call   802c11 <to_page_va>
  803143:	83 c4 10             	add    $0x10,%esp
  803146:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  803149:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80314c:	83 ec 0c             	sub    $0xc,%esp
  80314f:	50                   	push   %eax
  803150:	e8 c0 ee ff ff       	call   802015 <get_page>
  803155:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  803158:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80315f:	e9 aa 00 00 00       	jmp    80320e <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  803164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803167:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  80316b:	89 c2                	mov    %eax,%edx
  80316d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803170:	01 d0                	add    %edx,%eax
  803172:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  803175:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803179:	75 17                	jne    803192 <alloc_block+0x272>
  80317b:	83 ec 04             	sub    $0x4,%esp
  80317e:	68 64 4b 80 00       	push   $0x804b64
  803183:	68 aa 00 00 00       	push   $0xaa
  803188:	68 ab 4a 80 00       	push   $0x804aab
  80318d:	e8 a0 07 00 00       	call   803932 <_panic>
  803192:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803195:	c1 e0 04             	shl    $0x4,%eax
  803198:	05 84 d0 81 00       	add    $0x81d084,%eax
  80319d:	8b 10                	mov    (%eax),%edx
  80319f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031a2:	89 50 04             	mov    %edx,0x4(%eax)
  8031a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031a8:	8b 40 04             	mov    0x4(%eax),%eax
  8031ab:	85 c0                	test   %eax,%eax
  8031ad:	74 14                	je     8031c3 <alloc_block+0x2a3>
  8031af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031b2:	c1 e0 04             	shl    $0x4,%eax
  8031b5:	05 84 d0 81 00       	add    $0x81d084,%eax
  8031ba:	8b 00                	mov    (%eax),%eax
  8031bc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8031bf:	89 10                	mov    %edx,(%eax)
  8031c1:	eb 11                	jmp    8031d4 <alloc_block+0x2b4>
  8031c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c6:	c1 e0 04             	shl    $0x4,%eax
  8031c9:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  8031cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031d2:	89 02                	mov    %eax,(%edx)
  8031d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031d7:	c1 e0 04             	shl    $0x4,%eax
  8031da:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  8031e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031e3:	89 02                	mov    %eax,(%edx)
  8031e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031f1:	c1 e0 04             	shl    $0x4,%eax
  8031f4:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8031f9:	8b 00                	mov    (%eax),%eax
  8031fb:	8d 50 01             	lea    0x1(%eax),%edx
  8031fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803201:	c1 e0 04             	shl    $0x4,%eax
  803204:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803209:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  80320b:	ff 45 f4             	incl   -0xc(%ebp)
  80320e:	b8 00 10 00 00       	mov    $0x1000,%eax
  803213:	99                   	cltd   
  803214:	f7 7d e8             	idivl  -0x18(%ebp)
  803217:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80321a:	0f 8f 44 ff ff ff    	jg     803164 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  803220:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803223:	c1 e0 04             	shl    $0x4,%eax
  803226:	05 80 d0 81 00       	add    $0x81d080,%eax
  80322b:	8b 00                	mov    (%eax),%eax
  80322d:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  803230:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803234:	75 17                	jne    80324d <alloc_block+0x32d>
  803236:	83 ec 04             	sub    $0x4,%esp
  803239:	68 45 4b 80 00       	push   $0x804b45
  80323e:	68 ae 00 00 00       	push   $0xae
  803243:	68 ab 4a 80 00       	push   $0x804aab
  803248:	e8 e5 06 00 00       	call   803932 <_panic>
  80324d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803250:	8b 00                	mov    (%eax),%eax
  803252:	85 c0                	test   %eax,%eax
  803254:	74 10                	je     803266 <alloc_block+0x346>
  803256:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803259:	8b 00                	mov    (%eax),%eax
  80325b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80325e:	8b 52 04             	mov    0x4(%edx),%edx
  803261:	89 50 04             	mov    %edx,0x4(%eax)
  803264:	eb 14                	jmp    80327a <alloc_block+0x35a>
  803266:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803269:	8b 40 04             	mov    0x4(%eax),%eax
  80326c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80326f:	c1 e2 04             	shl    $0x4,%edx
  803272:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803278:	89 02                	mov    %eax,(%edx)
  80327a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80327d:	8b 40 04             	mov    0x4(%eax),%eax
  803280:	85 c0                	test   %eax,%eax
  803282:	74 0f                	je     803293 <alloc_block+0x373>
  803284:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803287:	8b 40 04             	mov    0x4(%eax),%eax
  80328a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80328d:	8b 12                	mov    (%edx),%edx
  80328f:	89 10                	mov    %edx,(%eax)
  803291:	eb 13                	jmp    8032a6 <alloc_block+0x386>
  803293:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803296:	8b 00                	mov    (%eax),%eax
  803298:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80329b:	c1 e2 04             	shl    $0x4,%edx
  80329e:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8032a4:	89 02                	mov    %eax,(%edx)
  8032a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8032a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032af:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8032b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032bc:	c1 e0 04             	shl    $0x4,%eax
  8032bf:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8032c4:	8b 00                	mov    (%eax),%eax
  8032c6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8032c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032cc:	c1 e0 04             	shl    $0x4,%eax
  8032cf:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8032d4:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  8032d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8032d9:	83 ec 0c             	sub    $0xc,%esp
  8032dc:	50                   	push   %eax
  8032dd:	e8 a1 f9 ff ff       	call   802c83 <to_page_info>
  8032e2:	83 c4 10             	add    $0x10,%esp
  8032e5:	89 c2                	mov    %eax,%edx
  8032e7:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8032eb:	48                   	dec    %eax
  8032ec:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  8032f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8032f3:	e9 1a 01 00 00       	jmp    803412 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  8032f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032fb:	40                   	inc    %eax
  8032fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8032ff:	e9 ed 00 00 00       	jmp    8033f1 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  803304:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803307:	c1 e0 04             	shl    $0x4,%eax
  80330a:	05 80 d0 81 00       	add    $0x81d080,%eax
  80330f:	8b 00                	mov    (%eax),%eax
  803311:	85 c0                	test   %eax,%eax
  803313:	0f 84 d5 00 00 00    	je     8033ee <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  803319:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331c:	c1 e0 04             	shl    $0x4,%eax
  80331f:	05 80 d0 81 00       	add    $0x81d080,%eax
  803324:	8b 00                	mov    (%eax),%eax
  803326:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  803329:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80332d:	75 17                	jne    803346 <alloc_block+0x426>
  80332f:	83 ec 04             	sub    $0x4,%esp
  803332:	68 45 4b 80 00       	push   $0x804b45
  803337:	68 b8 00 00 00       	push   $0xb8
  80333c:	68 ab 4a 80 00       	push   $0x804aab
  803341:	e8 ec 05 00 00       	call   803932 <_panic>
  803346:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803349:	8b 00                	mov    (%eax),%eax
  80334b:	85 c0                	test   %eax,%eax
  80334d:	74 10                	je     80335f <alloc_block+0x43f>
  80334f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803352:	8b 00                	mov    (%eax),%eax
  803354:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803357:	8b 52 04             	mov    0x4(%edx),%edx
  80335a:	89 50 04             	mov    %edx,0x4(%eax)
  80335d:	eb 14                	jmp    803373 <alloc_block+0x453>
  80335f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803362:	8b 40 04             	mov    0x4(%eax),%eax
  803365:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803368:	c1 e2 04             	shl    $0x4,%edx
  80336b:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803371:	89 02                	mov    %eax,(%edx)
  803373:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803376:	8b 40 04             	mov    0x4(%eax),%eax
  803379:	85 c0                	test   %eax,%eax
  80337b:	74 0f                	je     80338c <alloc_block+0x46c>
  80337d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803380:	8b 40 04             	mov    0x4(%eax),%eax
  803383:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803386:	8b 12                	mov    (%edx),%edx
  803388:	89 10                	mov    %edx,(%eax)
  80338a:	eb 13                	jmp    80339f <alloc_block+0x47f>
  80338c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80338f:	8b 00                	mov    (%eax),%eax
  803391:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803394:	c1 e2 04             	shl    $0x4,%edx
  803397:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  80339d:	89 02                	mov    %eax,(%edx)
  80339f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033a8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b5:	c1 e0 04             	shl    $0x4,%eax
  8033b8:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8033bd:	8b 00                	mov    (%eax),%eax
  8033bf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8033c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c5:	c1 e0 04             	shl    $0x4,%eax
  8033c8:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8033cd:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  8033cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033d2:	83 ec 0c             	sub    $0xc,%esp
  8033d5:	50                   	push   %eax
  8033d6:	e8 a8 f8 ff ff       	call   802c83 <to_page_info>
  8033db:	83 c4 10             	add    $0x10,%esp
  8033de:	89 c2                	mov    %eax,%edx
  8033e0:	66 8b 42 0a          	mov    0xa(%edx),%ax
  8033e4:	48                   	dec    %eax
  8033e5:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  8033e9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033ec:	eb 24                	jmp    803412 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  8033ee:	ff 45 f0             	incl   -0x10(%ebp)
  8033f1:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8033f5:	0f 8e 09 ff ff ff    	jle    803304 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  8033fb:	83 ec 04             	sub    $0x4,%esp
  8033fe:	68 87 4b 80 00       	push   $0x804b87
  803403:	68 bf 00 00 00       	push   $0xbf
  803408:	68 ab 4a 80 00       	push   $0x804aab
  80340d:	e8 20 05 00 00       	call   803932 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803412:	c9                   	leave  
  803413:	c3                   	ret    

00803414 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  803414:	55                   	push   %ebp
  803415:	89 e5                	mov    %esp,%ebp
  803417:	83 ec 14             	sub    $0x14,%esp
  80341a:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  80341d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803421:	75 07                	jne    80342a <log2_ceil.1520+0x16>
  803423:	b8 00 00 00 00       	mov    $0x0,%eax
  803428:	eb 1b                	jmp    803445 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  80342a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  803431:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  803434:	eb 06                	jmp    80343c <log2_ceil.1520+0x28>
            x >>= 1;
  803436:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  803439:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  80343c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803440:	75 f4                	jne    803436 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  803442:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803445:	c9                   	leave  
  803446:	c3                   	ret    

00803447 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  803447:	55                   	push   %ebp
  803448:	89 e5                	mov    %esp,%ebp
  80344a:	83 ec 14             	sub    $0x14,%esp
  80344d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  803450:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803454:	75 07                	jne    80345d <log2_ceil.1547+0x16>
  803456:	b8 00 00 00 00       	mov    $0x0,%eax
  80345b:	eb 1b                	jmp    803478 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  80345d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  803464:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  803467:	eb 06                	jmp    80346f <log2_ceil.1547+0x28>
			x >>= 1;
  803469:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  80346c:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  80346f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803473:	75 f4                	jne    803469 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  803475:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  803478:	c9                   	leave  
  803479:	c3                   	ret    

0080347a <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80347a:	55                   	push   %ebp
  80347b:	89 e5                	mov    %esp,%ebp
  80347d:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803480:	8b 55 08             	mov    0x8(%ebp),%edx
  803483:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803488:	39 c2                	cmp    %eax,%edx
  80348a:	72 0c                	jb     803498 <free_block+0x1e>
  80348c:	8b 55 08             	mov    0x8(%ebp),%edx
  80348f:	a1 40 50 80 00       	mov    0x805040,%eax
  803494:	39 c2                	cmp    %eax,%edx
  803496:	72 19                	jb     8034b1 <free_block+0x37>
  803498:	68 8c 4b 80 00       	push   $0x804b8c
  80349d:	68 0e 4b 80 00       	push   $0x804b0e
  8034a2:	68 d0 00 00 00       	push   $0xd0
  8034a7:	68 ab 4a 80 00       	push   $0x804aab
  8034ac:	e8 81 04 00 00       	call   803932 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8034b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034b5:	0f 84 42 03 00 00    	je     8037fd <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  8034bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8034be:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8034c3:	39 c2                	cmp    %eax,%edx
  8034c5:	72 0c                	jb     8034d3 <free_block+0x59>
  8034c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8034ca:	a1 40 50 80 00       	mov    0x805040,%eax
  8034cf:	39 c2                	cmp    %eax,%edx
  8034d1:	72 17                	jb     8034ea <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  8034d3:	83 ec 04             	sub    $0x4,%esp
  8034d6:	68 c4 4b 80 00       	push   $0x804bc4
  8034db:	68 e6 00 00 00       	push   $0xe6
  8034e0:	68 ab 4a 80 00       	push   $0x804aab
  8034e5:	e8 48 04 00 00       	call   803932 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  8034ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8034ed:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8034f2:	29 c2                	sub    %eax,%edx
  8034f4:	89 d0                	mov    %edx,%eax
  8034f6:	83 e0 07             	and    $0x7,%eax
  8034f9:	85 c0                	test   %eax,%eax
  8034fb:	74 17                	je     803514 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  8034fd:	83 ec 04             	sub    $0x4,%esp
  803500:	68 f8 4b 80 00       	push   $0x804bf8
  803505:	68 ea 00 00 00       	push   $0xea
  80350a:	68 ab 4a 80 00       	push   $0x804aab
  80350f:	e8 1e 04 00 00       	call   803932 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  803514:	8b 45 08             	mov    0x8(%ebp),%eax
  803517:	83 ec 0c             	sub    $0xc,%esp
  80351a:	50                   	push   %eax
  80351b:	e8 63 f7 ff ff       	call   802c83 <to_page_info>
  803520:	83 c4 10             	add    $0x10,%esp
  803523:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  803526:	83 ec 0c             	sub    $0xc,%esp
  803529:	ff 75 08             	pushl  0x8(%ebp)
  80352c:	e8 87 f9 ff ff       	call   802eb8 <get_block_size>
  803531:	83 c4 10             	add    $0x10,%esp
  803534:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  803537:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80353b:	75 17                	jne    803554 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  80353d:	83 ec 04             	sub    $0x4,%esp
  803540:	68 24 4c 80 00       	push   $0x804c24
  803545:	68 f1 00 00 00       	push   $0xf1
  80354a:	68 ab 4a 80 00       	push   $0x804aab
  80354f:	e8 de 03 00 00       	call   803932 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  803554:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803557:	83 ec 0c             	sub    $0xc,%esp
  80355a:	8d 45 d0             	lea    -0x30(%ebp),%eax
  80355d:	52                   	push   %edx
  80355e:	89 c1                	mov    %eax,%ecx
  803560:	e8 e2 fe ff ff       	call   803447 <log2_ceil.1547>
  803565:	83 c4 10             	add    $0x10,%esp
  803568:	83 e8 03             	sub    $0x3,%eax
  80356b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  80356e:	8b 45 08             	mov    0x8(%ebp),%eax
  803571:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  803574:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803578:	75 17                	jne    803591 <free_block+0x117>
  80357a:	83 ec 04             	sub    $0x4,%esp
  80357d:	68 70 4c 80 00       	push   $0x804c70
  803582:	68 f6 00 00 00       	push   $0xf6
  803587:	68 ab 4a 80 00       	push   $0x804aab
  80358c:	e8 a1 03 00 00       	call   803932 <_panic>
  803591:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803594:	c1 e0 04             	shl    $0x4,%eax
  803597:	05 80 d0 81 00       	add    $0x81d080,%eax
  80359c:	8b 10                	mov    (%eax),%edx
  80359e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035a1:	89 10                	mov    %edx,(%eax)
  8035a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035a6:	8b 00                	mov    (%eax),%eax
  8035a8:	85 c0                	test   %eax,%eax
  8035aa:	74 15                	je     8035c1 <free_block+0x147>
  8035ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035af:	c1 e0 04             	shl    $0x4,%eax
  8035b2:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035b7:	8b 00                	mov    (%eax),%eax
  8035b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035bc:	89 50 04             	mov    %edx,0x4(%eax)
  8035bf:	eb 11                	jmp    8035d2 <free_block+0x158>
  8035c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c4:	c1 e0 04             	shl    $0x4,%eax
  8035c7:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  8035cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035d0:	89 02                	mov    %eax,(%edx)
  8035d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d5:	c1 e0 04             	shl    $0x4,%eax
  8035d8:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  8035de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035e1:	89 02                	mov    %eax,(%edx)
  8035e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f0:	c1 e0 04             	shl    $0x4,%eax
  8035f3:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8035f8:	8b 00                	mov    (%eax),%eax
  8035fa:	8d 50 01             	lea    0x1(%eax),%edx
  8035fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803600:	c1 e0 04             	shl    $0x4,%eax
  803603:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803608:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  80360a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80360d:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803611:	40                   	inc    %eax
  803612:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803615:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  803619:	8b 55 08             	mov    0x8(%ebp),%edx
  80361c:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803621:	29 c2                	sub    %eax,%edx
  803623:	89 d0                	mov    %edx,%eax
  803625:	c1 e8 0c             	shr    $0xc,%eax
  803628:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  80362b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80362e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803632:	0f b7 c8             	movzwl %ax,%ecx
  803635:	b8 00 10 00 00       	mov    $0x1000,%eax
  80363a:	99                   	cltd   
  80363b:	f7 7d e8             	idivl  -0x18(%ebp)
  80363e:	39 c1                	cmp    %eax,%ecx
  803640:	0f 85 b8 01 00 00    	jne    8037fe <free_block+0x384>
    	uint32 blocks_removed = 0;
  803646:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  80364d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803650:	c1 e0 04             	shl    $0x4,%eax
  803653:	05 80 d0 81 00       	add    $0x81d080,%eax
  803658:	8b 00                	mov    (%eax),%eax
  80365a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  80365d:	e9 d5 00 00 00       	jmp    803737 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  803662:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803665:	8b 00                	mov    (%eax),%eax
  803667:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  80366a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80366d:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803672:	29 c2                	sub    %eax,%edx
  803674:	89 d0                	mov    %edx,%eax
  803676:	c1 e8 0c             	shr    $0xc,%eax
  803679:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  80367c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80367f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803682:	0f 85 a9 00 00 00    	jne    803731 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  803688:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80368c:	75 17                	jne    8036a5 <free_block+0x22b>
  80368e:	83 ec 04             	sub    $0x4,%esp
  803691:	68 45 4b 80 00       	push   $0x804b45
  803696:	68 04 01 00 00       	push   $0x104
  80369b:	68 ab 4a 80 00       	push   $0x804aab
  8036a0:	e8 8d 02 00 00       	call   803932 <_panic>
  8036a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036a8:	8b 00                	mov    (%eax),%eax
  8036aa:	85 c0                	test   %eax,%eax
  8036ac:	74 10                	je     8036be <free_block+0x244>
  8036ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036b1:	8b 00                	mov    (%eax),%eax
  8036b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036b6:	8b 52 04             	mov    0x4(%edx),%edx
  8036b9:	89 50 04             	mov    %edx,0x4(%eax)
  8036bc:	eb 14                	jmp    8036d2 <free_block+0x258>
  8036be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036c1:	8b 40 04             	mov    0x4(%eax),%eax
  8036c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036c7:	c1 e2 04             	shl    $0x4,%edx
  8036ca:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  8036d0:	89 02                	mov    %eax,(%edx)
  8036d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036d5:	8b 40 04             	mov    0x4(%eax),%eax
  8036d8:	85 c0                	test   %eax,%eax
  8036da:	74 0f                	je     8036eb <free_block+0x271>
  8036dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036df:	8b 40 04             	mov    0x4(%eax),%eax
  8036e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036e5:	8b 12                	mov    (%edx),%edx
  8036e7:	89 10                	mov    %edx,(%eax)
  8036e9:	eb 13                	jmp    8036fe <free_block+0x284>
  8036eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ee:	8b 00                	mov    (%eax),%eax
  8036f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036f3:	c1 e2 04             	shl    $0x4,%edx
  8036f6:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  8036fc:	89 02                	mov    %eax,(%edx)
  8036fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803701:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803707:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80370a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803711:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803714:	c1 e0 04             	shl    $0x4,%eax
  803717:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80371c:	8b 00                	mov    (%eax),%eax
  80371e:	8d 50 ff             	lea    -0x1(%eax),%edx
  803721:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803724:	c1 e0 04             	shl    $0x4,%eax
  803727:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80372c:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  80372e:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  803731:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803734:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803737:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80373b:	0f 85 21 ff ff ff    	jne    803662 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  803741:	b8 00 10 00 00       	mov    $0x1000,%eax
  803746:	99                   	cltd   
  803747:	f7 7d e8             	idivl  -0x18(%ebp)
  80374a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80374d:	74 17                	je     803766 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  80374f:	83 ec 04             	sub    $0x4,%esp
  803752:	68 94 4c 80 00       	push   $0x804c94
  803757:	68 0c 01 00 00       	push   $0x10c
  80375c:	68 ab 4a 80 00       	push   $0x804aab
  803761:	e8 cc 01 00 00       	call   803932 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  803766:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803769:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  80376f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803772:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  803778:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80377c:	75 17                	jne    803795 <free_block+0x31b>
  80377e:	83 ec 04             	sub    $0x4,%esp
  803781:	68 64 4b 80 00       	push   $0x804b64
  803786:	68 11 01 00 00       	push   $0x111
  80378b:	68 ab 4a 80 00       	push   $0x804aab
  803790:	e8 9d 01 00 00       	call   803932 <_panic>
  803795:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  80379b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80379e:	89 50 04             	mov    %edx,0x4(%eax)
  8037a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037a4:	8b 40 04             	mov    0x4(%eax),%eax
  8037a7:	85 c0                	test   %eax,%eax
  8037a9:	74 0c                	je     8037b7 <free_block+0x33d>
  8037ab:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8037b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037b3:	89 10                	mov    %edx,(%eax)
  8037b5:	eb 08                	jmp    8037bf <free_block+0x345>
  8037b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037ba:	a3 48 50 80 00       	mov    %eax,0x805048
  8037bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037c2:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8037c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037d0:	a1 54 50 80 00       	mov    0x805054,%eax
  8037d5:	40                   	inc    %eax
  8037d6:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  8037db:	83 ec 0c             	sub    $0xc,%esp
  8037de:	ff 75 ec             	pushl  -0x14(%ebp)
  8037e1:	e8 2b f4 ff ff       	call   802c11 <to_page_va>
  8037e6:	83 c4 10             	add    $0x10,%esp
  8037e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  8037ec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8037ef:	83 ec 0c             	sub    $0xc,%esp
  8037f2:	50                   	push   %eax
  8037f3:	e8 69 e8 ff ff       	call   802061 <return_page>
  8037f8:	83 c4 10             	add    $0x10,%esp
  8037fb:	eb 01                	jmp    8037fe <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  8037fd:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  8037fe:	c9                   	leave  
  8037ff:	c3                   	ret    

00803800 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803800:	55                   	push   %ebp
  803801:	89 e5                	mov    %esp,%ebp
  803803:	83 ec 14             	sub    $0x14,%esp
  803806:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  803809:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80380d:	77 07                	ja     803816 <nearest_pow2_ceil.1572+0x16>
      return 1;
  80380f:	b8 01 00 00 00       	mov    $0x1,%eax
  803814:	eb 20                	jmp    803836 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  803816:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  80381d:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  803820:	eb 08                	jmp    80382a <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  803822:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803825:	01 c0                	add    %eax,%eax
  803827:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  80382a:	d1 6d 08             	shrl   0x8(%ebp)
  80382d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803831:	75 ef                	jne    803822 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  803833:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  803836:	c9                   	leave  
  803837:	c3                   	ret    

00803838 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  803838:	55                   	push   %ebp
  803839:	89 e5                	mov    %esp,%ebp
  80383b:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  80383e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803842:	75 13                	jne    803857 <realloc_block+0x1f>
    return alloc_block(new_size);
  803844:	83 ec 0c             	sub    $0xc,%esp
  803847:	ff 75 0c             	pushl  0xc(%ebp)
  80384a:	e8 d1 f6 ff ff       	call   802f20 <alloc_block>
  80384f:	83 c4 10             	add    $0x10,%esp
  803852:	e9 d9 00 00 00       	jmp    803930 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  803857:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80385b:	75 18                	jne    803875 <realloc_block+0x3d>
    free_block(va);
  80385d:	83 ec 0c             	sub    $0xc,%esp
  803860:	ff 75 08             	pushl  0x8(%ebp)
  803863:	e8 12 fc ff ff       	call   80347a <free_block>
  803868:	83 c4 10             	add    $0x10,%esp
    return NULL;
  80386b:	b8 00 00 00 00       	mov    $0x0,%eax
  803870:	e9 bb 00 00 00       	jmp    803930 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  803875:	83 ec 0c             	sub    $0xc,%esp
  803878:	ff 75 08             	pushl  0x8(%ebp)
  80387b:	e8 38 f6 ff ff       	call   802eb8 <get_block_size>
  803880:	83 c4 10             	add    $0x10,%esp
  803883:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  803886:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  80388d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803890:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803893:	73 06                	jae    80389b <realloc_block+0x63>
    new_size = min_block_size;
  803895:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803898:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  80389b:	83 ec 0c             	sub    $0xc,%esp
  80389e:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8038a1:	ff 75 0c             	pushl  0xc(%ebp)
  8038a4:	89 c1                	mov    %eax,%ecx
  8038a6:	e8 55 ff ff ff       	call   803800 <nearest_pow2_ceil.1572>
  8038ab:	83 c4 10             	add    $0x10,%esp
  8038ae:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  8038b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8038b7:	75 05                	jne    8038be <realloc_block+0x86>
    return va;
  8038b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bc:	eb 72                	jmp    803930 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  8038be:	83 ec 0c             	sub    $0xc,%esp
  8038c1:	ff 75 0c             	pushl  0xc(%ebp)
  8038c4:	e8 57 f6 ff ff       	call   802f20 <alloc_block>
  8038c9:	83 c4 10             	add    $0x10,%esp
  8038cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  8038cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038d3:	75 07                	jne    8038dc <realloc_block+0xa4>
    return NULL;
  8038d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8038da:	eb 54                	jmp    803930 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  8038dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038e2:	39 d0                	cmp    %edx,%eax
  8038e4:	76 02                	jbe    8038e8 <realloc_block+0xb0>
  8038e6:	89 d0                	mov    %edx,%eax
  8038e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  8038eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ee:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  8038f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  8038f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8038fe:	eb 17                	jmp    803917 <realloc_block+0xdf>
    dst[i] = src[i];
  803900:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803906:	01 c2                	add    %eax,%edx
  803908:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80390b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390e:	01 c8                	add    %ecx,%eax
  803910:	8a 00                	mov    (%eax),%al
  803912:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  803914:	ff 45 f4             	incl   -0xc(%ebp)
  803917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80391d:	72 e1                	jb     803900 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  80391f:	83 ec 0c             	sub    $0xc,%esp
  803922:	ff 75 08             	pushl  0x8(%ebp)
  803925:	e8 50 fb ff ff       	call   80347a <free_block>
  80392a:	83 c4 10             	add    $0x10,%esp

  return new_va;
  80392d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  803930:	c9                   	leave  
  803931:	c3                   	ret    

00803932 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803932:	55                   	push   %ebp
  803933:	89 e5                	mov    %esp,%ebp
  803935:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803938:	8d 45 10             	lea    0x10(%ebp),%eax
  80393b:	83 c0 04             	add    $0x4,%eax
  80393e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803941:	a1 1c d1 81 00       	mov    0x81d11c,%eax
  803946:	85 c0                	test   %eax,%eax
  803948:	74 16                	je     803960 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80394a:	a1 1c d1 81 00       	mov    0x81d11c,%eax
  80394f:	83 ec 08             	sub    $0x8,%esp
  803952:	50                   	push   %eax
  803953:	68 c8 4c 80 00       	push   $0x804cc8
  803958:	e8 1c d1 ff ff       	call   800a79 <cprintf>
  80395d:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  803960:	a1 04 50 80 00       	mov    0x805004,%eax
  803965:	83 ec 0c             	sub    $0xc,%esp
  803968:	ff 75 0c             	pushl  0xc(%ebp)
  80396b:	ff 75 08             	pushl  0x8(%ebp)
  80396e:	50                   	push   %eax
  80396f:	68 d0 4c 80 00       	push   $0x804cd0
  803974:	6a 74                	push   $0x74
  803976:	e8 2b d1 ff ff       	call   800aa6 <cprintf_colored>
  80397b:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80397e:	8b 45 10             	mov    0x10(%ebp),%eax
  803981:	83 ec 08             	sub    $0x8,%esp
  803984:	ff 75 f4             	pushl  -0xc(%ebp)
  803987:	50                   	push   %eax
  803988:	e8 7d d0 ff ff       	call   800a0a <vcprintf>
  80398d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803990:	83 ec 08             	sub    $0x8,%esp
  803993:	6a 00                	push   $0x0
  803995:	68 f8 4c 80 00       	push   $0x804cf8
  80399a:	e8 6b d0 ff ff       	call   800a0a <vcprintf>
  80399f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8039a2:	e8 e4 cf ff ff       	call   80098b <exit>

	// should not return here
	while (1) ;
  8039a7:	eb fe                	jmp    8039a7 <_panic+0x75>

008039a9 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8039a9:	55                   	push   %ebp
  8039aa:	89 e5                	mov    %esp,%ebp
  8039ac:	53                   	push   %ebx
  8039ad:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8039b0:	a1 20 50 80 00       	mov    0x805020,%eax
  8039b5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8039bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039be:	39 c2                	cmp    %eax,%edx
  8039c0:	74 14                	je     8039d6 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8039c2:	83 ec 04             	sub    $0x4,%esp
  8039c5:	68 fc 4c 80 00       	push   $0x804cfc
  8039ca:	6a 26                	push   $0x26
  8039cc:	68 48 4d 80 00       	push   $0x804d48
  8039d1:	e8 5c ff ff ff       	call   803932 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8039d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8039dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8039e4:	e9 d9 00 00 00       	jmp    803ac2 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8039e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8039f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f6:	01 d0                	add    %edx,%eax
  8039f8:	8b 00                	mov    (%eax),%eax
  8039fa:	85 c0                	test   %eax,%eax
  8039fc:	75 08                	jne    803a06 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8039fe:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803a01:	e9 b9 00 00 00       	jmp    803abf <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  803a06:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a0d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803a14:	eb 79                	jmp    803a8f <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803a16:	a1 20 50 80 00       	mov    0x805020,%eax
  803a1b:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  803a21:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a24:	89 d0                	mov    %edx,%eax
  803a26:	01 c0                	add    %eax,%eax
  803a28:	01 d0                	add    %edx,%eax
  803a2a:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  803a31:	01 d8                	add    %ebx,%eax
  803a33:	01 d0                	add    %edx,%eax
  803a35:	01 c8                	add    %ecx,%eax
  803a37:	8a 40 04             	mov    0x4(%eax),%al
  803a3a:	84 c0                	test   %al,%al
  803a3c:	75 4e                	jne    803a8c <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a3e:	a1 20 50 80 00       	mov    0x805020,%eax
  803a43:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  803a49:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a4c:	89 d0                	mov    %edx,%eax
  803a4e:	01 c0                	add    %eax,%eax
  803a50:	01 d0                	add    %edx,%eax
  803a52:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  803a59:	01 d8                	add    %ebx,%eax
  803a5b:	01 d0                	add    %edx,%eax
  803a5d:	01 c8                	add    %ecx,%eax
  803a5f:	8b 00                	mov    (%eax),%eax
  803a61:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803a64:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a67:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803a6c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a71:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803a78:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7b:	01 c8                	add    %ecx,%eax
  803a7d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a7f:	39 c2                	cmp    %eax,%edx
  803a81:	75 09                	jne    803a8c <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  803a83:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803a8a:	eb 19                	jmp    803aa5 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a8c:	ff 45 e8             	incl   -0x18(%ebp)
  803a8f:	a1 20 50 80 00       	mov    0x805020,%eax
  803a94:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803a9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a9d:	39 c2                	cmp    %eax,%edx
  803a9f:	0f 87 71 ff ff ff    	ja     803a16 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803aa5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803aa9:	75 14                	jne    803abf <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  803aab:	83 ec 04             	sub    $0x4,%esp
  803aae:	68 54 4d 80 00       	push   $0x804d54
  803ab3:	6a 3a                	push   $0x3a
  803ab5:	68 48 4d 80 00       	push   $0x804d48
  803aba:	e8 73 fe ff ff       	call   803932 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803abf:	ff 45 f0             	incl   -0x10(%ebp)
  803ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ac5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803ac8:	0f 8c 1b ff ff ff    	jl     8039e9 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803ace:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ad5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803adc:	eb 2e                	jmp    803b0c <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803ade:	a1 20 50 80 00       	mov    0x805020,%eax
  803ae3:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  803ae9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803aec:	89 d0                	mov    %edx,%eax
  803aee:	01 c0                	add    %eax,%eax
  803af0:	01 d0                	add    %edx,%eax
  803af2:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  803af9:	01 d8                	add    %ebx,%eax
  803afb:	01 d0                	add    %edx,%eax
  803afd:	01 c8                	add    %ecx,%eax
  803aff:	8a 40 04             	mov    0x4(%eax),%al
  803b02:	3c 01                	cmp    $0x1,%al
  803b04:	75 03                	jne    803b09 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  803b06:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b09:	ff 45 e0             	incl   -0x20(%ebp)
  803b0c:	a1 20 50 80 00       	mov    0x805020,%eax
  803b11:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803b17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b1a:	39 c2                	cmp    %eax,%edx
  803b1c:	77 c0                	ja     803ade <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b21:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803b24:	74 14                	je     803b3a <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  803b26:	83 ec 04             	sub    $0x4,%esp
  803b29:	68 a8 4d 80 00       	push   $0x804da8
  803b2e:	6a 44                	push   $0x44
  803b30:	68 48 4d 80 00       	push   $0x804d48
  803b35:	e8 f8 fd ff ff       	call   803932 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803b3a:	90                   	nop
  803b3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803b3e:	c9                   	leave  
  803b3f:	c3                   	ret    

00803b40 <__divdi3>:
  803b40:	55                   	push   %ebp
  803b41:	57                   	push   %edi
  803b42:	56                   	push   %esi
  803b43:	53                   	push   %ebx
  803b44:	83 ec 1c             	sub    $0x1c,%esp
  803b47:	8b 44 24 30          	mov    0x30(%esp),%eax
  803b4b:	8b 54 24 34          	mov    0x34(%esp),%edx
  803b4f:	8b 74 24 38          	mov    0x38(%esp),%esi
  803b53:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  803b57:	89 f9                	mov    %edi,%ecx
  803b59:	85 d2                	test   %edx,%edx
  803b5b:	0f 88 bb 00 00 00    	js     803c1c <__divdi3+0xdc>
  803b61:	31 ed                	xor    %ebp,%ebp
  803b63:	85 c9                	test   %ecx,%ecx
  803b65:	0f 88 99 00 00 00    	js     803c04 <__divdi3+0xc4>
  803b6b:	89 34 24             	mov    %esi,(%esp)
  803b6e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803b72:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b76:	89 d3                	mov    %edx,%ebx
  803b78:	8b 34 24             	mov    (%esp),%esi
  803b7b:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803b7f:	89 74 24 08          	mov    %esi,0x8(%esp)
  803b83:	8b 34 24             	mov    (%esp),%esi
  803b86:	89 c1                	mov    %eax,%ecx
  803b88:	85 ff                	test   %edi,%edi
  803b8a:	75 10                	jne    803b9c <__divdi3+0x5c>
  803b8c:	8b 7c 24 08          	mov    0x8(%esp),%edi
  803b90:	39 d7                	cmp    %edx,%edi
  803b92:	76 4c                	jbe    803be0 <__divdi3+0xa0>
  803b94:	f7 f7                	div    %edi
  803b96:	89 c1                	mov    %eax,%ecx
  803b98:	31 f6                	xor    %esi,%esi
  803b9a:	eb 08                	jmp    803ba4 <__divdi3+0x64>
  803b9c:	39 d7                	cmp    %edx,%edi
  803b9e:	76 1c                	jbe    803bbc <__divdi3+0x7c>
  803ba0:	31 f6                	xor    %esi,%esi
  803ba2:	31 c9                	xor    %ecx,%ecx
  803ba4:	89 c8                	mov    %ecx,%eax
  803ba6:	89 f2                	mov    %esi,%edx
  803ba8:	85 ed                	test   %ebp,%ebp
  803baa:	74 07                	je     803bb3 <__divdi3+0x73>
  803bac:	f7 d8                	neg    %eax
  803bae:	83 d2 00             	adc    $0x0,%edx
  803bb1:	f7 da                	neg    %edx
  803bb3:	83 c4 1c             	add    $0x1c,%esp
  803bb6:	5b                   	pop    %ebx
  803bb7:	5e                   	pop    %esi
  803bb8:	5f                   	pop    %edi
  803bb9:	5d                   	pop    %ebp
  803bba:	c3                   	ret    
  803bbb:	90                   	nop
  803bbc:	0f bd f7             	bsr    %edi,%esi
  803bbf:	83 f6 1f             	xor    $0x1f,%esi
  803bc2:	75 6c                	jne    803c30 <__divdi3+0xf0>
  803bc4:	39 d7                	cmp    %edx,%edi
  803bc6:	72 0e                	jb     803bd6 <__divdi3+0x96>
  803bc8:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  803bcc:	39 7c 24 08          	cmp    %edi,0x8(%esp)
  803bd0:	0f 87 ca 00 00 00    	ja     803ca0 <__divdi3+0x160>
  803bd6:	b9 01 00 00 00       	mov    $0x1,%ecx
  803bdb:	eb c7                	jmp    803ba4 <__divdi3+0x64>
  803bdd:	8d 76 00             	lea    0x0(%esi),%esi
  803be0:	85 f6                	test   %esi,%esi
  803be2:	75 0b                	jne    803bef <__divdi3+0xaf>
  803be4:	b8 01 00 00 00       	mov    $0x1,%eax
  803be9:	31 d2                	xor    %edx,%edx
  803beb:	f7 f6                	div    %esi
  803bed:	89 c6                	mov    %eax,%esi
  803bef:	31 d2                	xor    %edx,%edx
  803bf1:	89 d8                	mov    %ebx,%eax
  803bf3:	f7 f6                	div    %esi
  803bf5:	89 c7                	mov    %eax,%edi
  803bf7:	89 c8                	mov    %ecx,%eax
  803bf9:	f7 f6                	div    %esi
  803bfb:	89 c1                	mov    %eax,%ecx
  803bfd:	89 fe                	mov    %edi,%esi
  803bff:	eb a3                	jmp    803ba4 <__divdi3+0x64>
  803c01:	8d 76 00             	lea    0x0(%esi),%esi
  803c04:	f7 d5                	not    %ebp
  803c06:	f7 de                	neg    %esi
  803c08:	83 d7 00             	adc    $0x0,%edi
  803c0b:	f7 df                	neg    %edi
  803c0d:	89 34 24             	mov    %esi,(%esp)
  803c10:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803c14:	e9 59 ff ff ff       	jmp    803b72 <__divdi3+0x32>
  803c19:	8d 76 00             	lea    0x0(%esi),%esi
  803c1c:	f7 d8                	neg    %eax
  803c1e:	83 d2 00             	adc    $0x0,%edx
  803c21:	f7 da                	neg    %edx
  803c23:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
  803c28:	e9 36 ff ff ff       	jmp    803b63 <__divdi3+0x23>
  803c2d:	8d 76 00             	lea    0x0(%esi),%esi
  803c30:	b8 20 00 00 00       	mov    $0x20,%eax
  803c35:	29 f0                	sub    %esi,%eax
  803c37:	89 f1                	mov    %esi,%ecx
  803c39:	d3 e7                	shl    %cl,%edi
  803c3b:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c3f:	88 c1                	mov    %al,%cl
  803c41:	d3 ea                	shr    %cl,%edx
  803c43:	89 d1                	mov    %edx,%ecx
  803c45:	09 f9                	or     %edi,%ecx
  803c47:	89 0c 24             	mov    %ecx,(%esp)
  803c4a:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c4e:	89 f1                	mov    %esi,%ecx
  803c50:	d3 e2                	shl    %cl,%edx
  803c52:	89 54 24 08          	mov    %edx,0x8(%esp)
  803c56:	89 df                	mov    %ebx,%edi
  803c58:	88 c1                	mov    %al,%cl
  803c5a:	d3 ef                	shr    %cl,%edi
  803c5c:	89 f1                	mov    %esi,%ecx
  803c5e:	d3 e3                	shl    %cl,%ebx
  803c60:	8b 54 24 0c          	mov    0xc(%esp),%edx
  803c64:	88 c1                	mov    %al,%cl
  803c66:	d3 ea                	shr    %cl,%edx
  803c68:	09 d3                	or     %edx,%ebx
  803c6a:	89 d8                	mov    %ebx,%eax
  803c6c:	89 fa                	mov    %edi,%edx
  803c6e:	f7 34 24             	divl   (%esp)
  803c71:	89 d1                	mov    %edx,%ecx
  803c73:	89 c3                	mov    %eax,%ebx
  803c75:	f7 64 24 08          	mull   0x8(%esp)
  803c79:	39 d1                	cmp    %edx,%ecx
  803c7b:	72 17                	jb     803c94 <__divdi3+0x154>
  803c7d:	74 09                	je     803c88 <__divdi3+0x148>
  803c7f:	89 d9                	mov    %ebx,%ecx
  803c81:	31 f6                	xor    %esi,%esi
  803c83:	e9 1c ff ff ff       	jmp    803ba4 <__divdi3+0x64>
  803c88:	8b 54 24 0c          	mov    0xc(%esp),%edx
  803c8c:	89 f1                	mov    %esi,%ecx
  803c8e:	d3 e2                	shl    %cl,%edx
  803c90:	39 c2                	cmp    %eax,%edx
  803c92:	73 eb                	jae    803c7f <__divdi3+0x13f>
  803c94:	8d 4b ff             	lea    -0x1(%ebx),%ecx
  803c97:	31 f6                	xor    %esi,%esi
  803c99:	e9 06 ff ff ff       	jmp    803ba4 <__divdi3+0x64>
  803c9e:	66 90                	xchg   %ax,%ax
  803ca0:	31 c9                	xor    %ecx,%ecx
  803ca2:	e9 fd fe ff ff       	jmp    803ba4 <__divdi3+0x64>
  803ca7:	90                   	nop

00803ca8 <__udivdi3>:
  803ca8:	55                   	push   %ebp
  803ca9:	57                   	push   %edi
  803caa:	56                   	push   %esi
  803cab:	53                   	push   %ebx
  803cac:	83 ec 1c             	sub    $0x1c,%esp
  803caf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803cb3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803cb7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cbb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803cbf:	89 ca                	mov    %ecx,%edx
  803cc1:	89 f8                	mov    %edi,%eax
  803cc3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803cc7:	85 f6                	test   %esi,%esi
  803cc9:	75 2d                	jne    803cf8 <__udivdi3+0x50>
  803ccb:	39 cf                	cmp    %ecx,%edi
  803ccd:	77 65                	ja     803d34 <__udivdi3+0x8c>
  803ccf:	89 fd                	mov    %edi,%ebp
  803cd1:	85 ff                	test   %edi,%edi
  803cd3:	75 0b                	jne    803ce0 <__udivdi3+0x38>
  803cd5:	b8 01 00 00 00       	mov    $0x1,%eax
  803cda:	31 d2                	xor    %edx,%edx
  803cdc:	f7 f7                	div    %edi
  803cde:	89 c5                	mov    %eax,%ebp
  803ce0:	31 d2                	xor    %edx,%edx
  803ce2:	89 c8                	mov    %ecx,%eax
  803ce4:	f7 f5                	div    %ebp
  803ce6:	89 c1                	mov    %eax,%ecx
  803ce8:	89 d8                	mov    %ebx,%eax
  803cea:	f7 f5                	div    %ebp
  803cec:	89 cf                	mov    %ecx,%edi
  803cee:	89 fa                	mov    %edi,%edx
  803cf0:	83 c4 1c             	add    $0x1c,%esp
  803cf3:	5b                   	pop    %ebx
  803cf4:	5e                   	pop    %esi
  803cf5:	5f                   	pop    %edi
  803cf6:	5d                   	pop    %ebp
  803cf7:	c3                   	ret    
  803cf8:	39 ce                	cmp    %ecx,%esi
  803cfa:	77 28                	ja     803d24 <__udivdi3+0x7c>
  803cfc:	0f bd fe             	bsr    %esi,%edi
  803cff:	83 f7 1f             	xor    $0x1f,%edi
  803d02:	75 40                	jne    803d44 <__udivdi3+0x9c>
  803d04:	39 ce                	cmp    %ecx,%esi
  803d06:	72 0a                	jb     803d12 <__udivdi3+0x6a>
  803d08:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803d0c:	0f 87 9e 00 00 00    	ja     803db0 <__udivdi3+0x108>
  803d12:	b8 01 00 00 00       	mov    $0x1,%eax
  803d17:	89 fa                	mov    %edi,%edx
  803d19:	83 c4 1c             	add    $0x1c,%esp
  803d1c:	5b                   	pop    %ebx
  803d1d:	5e                   	pop    %esi
  803d1e:	5f                   	pop    %edi
  803d1f:	5d                   	pop    %ebp
  803d20:	c3                   	ret    
  803d21:	8d 76 00             	lea    0x0(%esi),%esi
  803d24:	31 ff                	xor    %edi,%edi
  803d26:	31 c0                	xor    %eax,%eax
  803d28:	89 fa                	mov    %edi,%edx
  803d2a:	83 c4 1c             	add    $0x1c,%esp
  803d2d:	5b                   	pop    %ebx
  803d2e:	5e                   	pop    %esi
  803d2f:	5f                   	pop    %edi
  803d30:	5d                   	pop    %ebp
  803d31:	c3                   	ret    
  803d32:	66 90                	xchg   %ax,%ax
  803d34:	89 d8                	mov    %ebx,%eax
  803d36:	f7 f7                	div    %edi
  803d38:	31 ff                	xor    %edi,%edi
  803d3a:	89 fa                	mov    %edi,%edx
  803d3c:	83 c4 1c             	add    $0x1c,%esp
  803d3f:	5b                   	pop    %ebx
  803d40:	5e                   	pop    %esi
  803d41:	5f                   	pop    %edi
  803d42:	5d                   	pop    %ebp
  803d43:	c3                   	ret    
  803d44:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d49:	89 eb                	mov    %ebp,%ebx
  803d4b:	29 fb                	sub    %edi,%ebx
  803d4d:	89 f9                	mov    %edi,%ecx
  803d4f:	d3 e6                	shl    %cl,%esi
  803d51:	89 c5                	mov    %eax,%ebp
  803d53:	88 d9                	mov    %bl,%cl
  803d55:	d3 ed                	shr    %cl,%ebp
  803d57:	89 e9                	mov    %ebp,%ecx
  803d59:	09 f1                	or     %esi,%ecx
  803d5b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d5f:	89 f9                	mov    %edi,%ecx
  803d61:	d3 e0                	shl    %cl,%eax
  803d63:	89 c5                	mov    %eax,%ebp
  803d65:	89 d6                	mov    %edx,%esi
  803d67:	88 d9                	mov    %bl,%cl
  803d69:	d3 ee                	shr    %cl,%esi
  803d6b:	89 f9                	mov    %edi,%ecx
  803d6d:	d3 e2                	shl    %cl,%edx
  803d6f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d73:	88 d9                	mov    %bl,%cl
  803d75:	d3 e8                	shr    %cl,%eax
  803d77:	09 c2                	or     %eax,%edx
  803d79:	89 d0                	mov    %edx,%eax
  803d7b:	89 f2                	mov    %esi,%edx
  803d7d:	f7 74 24 0c          	divl   0xc(%esp)
  803d81:	89 d6                	mov    %edx,%esi
  803d83:	89 c3                	mov    %eax,%ebx
  803d85:	f7 e5                	mul    %ebp
  803d87:	39 d6                	cmp    %edx,%esi
  803d89:	72 19                	jb     803da4 <__udivdi3+0xfc>
  803d8b:	74 0b                	je     803d98 <__udivdi3+0xf0>
  803d8d:	89 d8                	mov    %ebx,%eax
  803d8f:	31 ff                	xor    %edi,%edi
  803d91:	e9 58 ff ff ff       	jmp    803cee <__udivdi3+0x46>
  803d96:	66 90                	xchg   %ax,%ax
  803d98:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d9c:	89 f9                	mov    %edi,%ecx
  803d9e:	d3 e2                	shl    %cl,%edx
  803da0:	39 c2                	cmp    %eax,%edx
  803da2:	73 e9                	jae    803d8d <__udivdi3+0xe5>
  803da4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803da7:	31 ff                	xor    %edi,%edi
  803da9:	e9 40 ff ff ff       	jmp    803cee <__udivdi3+0x46>
  803dae:	66 90                	xchg   %ax,%ax
  803db0:	31 c0                	xor    %eax,%eax
  803db2:	e9 37 ff ff ff       	jmp    803cee <__udivdi3+0x46>
  803db7:	90                   	nop

00803db8 <__umoddi3>:
  803db8:	55                   	push   %ebp
  803db9:	57                   	push   %edi
  803dba:	56                   	push   %esi
  803dbb:	53                   	push   %ebx
  803dbc:	83 ec 1c             	sub    $0x1c,%esp
  803dbf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803dc3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803dc7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803dcb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803dcf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803dd3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803dd7:	89 f3                	mov    %esi,%ebx
  803dd9:	89 fa                	mov    %edi,%edx
  803ddb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ddf:	89 34 24             	mov    %esi,(%esp)
  803de2:	85 c0                	test   %eax,%eax
  803de4:	75 1a                	jne    803e00 <__umoddi3+0x48>
  803de6:	39 f7                	cmp    %esi,%edi
  803de8:	0f 86 a2 00 00 00    	jbe    803e90 <__umoddi3+0xd8>
  803dee:	89 c8                	mov    %ecx,%eax
  803df0:	89 f2                	mov    %esi,%edx
  803df2:	f7 f7                	div    %edi
  803df4:	89 d0                	mov    %edx,%eax
  803df6:	31 d2                	xor    %edx,%edx
  803df8:	83 c4 1c             	add    $0x1c,%esp
  803dfb:	5b                   	pop    %ebx
  803dfc:	5e                   	pop    %esi
  803dfd:	5f                   	pop    %edi
  803dfe:	5d                   	pop    %ebp
  803dff:	c3                   	ret    
  803e00:	39 f0                	cmp    %esi,%eax
  803e02:	0f 87 ac 00 00 00    	ja     803eb4 <__umoddi3+0xfc>
  803e08:	0f bd e8             	bsr    %eax,%ebp
  803e0b:	83 f5 1f             	xor    $0x1f,%ebp
  803e0e:	0f 84 ac 00 00 00    	je     803ec0 <__umoddi3+0x108>
  803e14:	bf 20 00 00 00       	mov    $0x20,%edi
  803e19:	29 ef                	sub    %ebp,%edi
  803e1b:	89 fe                	mov    %edi,%esi
  803e1d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e21:	89 e9                	mov    %ebp,%ecx
  803e23:	d3 e0                	shl    %cl,%eax
  803e25:	89 d7                	mov    %edx,%edi
  803e27:	89 f1                	mov    %esi,%ecx
  803e29:	d3 ef                	shr    %cl,%edi
  803e2b:	09 c7                	or     %eax,%edi
  803e2d:	89 e9                	mov    %ebp,%ecx
  803e2f:	d3 e2                	shl    %cl,%edx
  803e31:	89 14 24             	mov    %edx,(%esp)
  803e34:	89 d8                	mov    %ebx,%eax
  803e36:	d3 e0                	shl    %cl,%eax
  803e38:	89 c2                	mov    %eax,%edx
  803e3a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e3e:	d3 e0                	shl    %cl,%eax
  803e40:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e44:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e48:	89 f1                	mov    %esi,%ecx
  803e4a:	d3 e8                	shr    %cl,%eax
  803e4c:	09 d0                	or     %edx,%eax
  803e4e:	d3 eb                	shr    %cl,%ebx
  803e50:	89 da                	mov    %ebx,%edx
  803e52:	f7 f7                	div    %edi
  803e54:	89 d3                	mov    %edx,%ebx
  803e56:	f7 24 24             	mull   (%esp)
  803e59:	89 c6                	mov    %eax,%esi
  803e5b:	89 d1                	mov    %edx,%ecx
  803e5d:	39 d3                	cmp    %edx,%ebx
  803e5f:	0f 82 87 00 00 00    	jb     803eec <__umoddi3+0x134>
  803e65:	0f 84 91 00 00 00    	je     803efc <__umoddi3+0x144>
  803e6b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e6f:	29 f2                	sub    %esi,%edx
  803e71:	19 cb                	sbb    %ecx,%ebx
  803e73:	89 d8                	mov    %ebx,%eax
  803e75:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e79:	d3 e0                	shl    %cl,%eax
  803e7b:	89 e9                	mov    %ebp,%ecx
  803e7d:	d3 ea                	shr    %cl,%edx
  803e7f:	09 d0                	or     %edx,%eax
  803e81:	89 e9                	mov    %ebp,%ecx
  803e83:	d3 eb                	shr    %cl,%ebx
  803e85:	89 da                	mov    %ebx,%edx
  803e87:	83 c4 1c             	add    $0x1c,%esp
  803e8a:	5b                   	pop    %ebx
  803e8b:	5e                   	pop    %esi
  803e8c:	5f                   	pop    %edi
  803e8d:	5d                   	pop    %ebp
  803e8e:	c3                   	ret    
  803e8f:	90                   	nop
  803e90:	89 fd                	mov    %edi,%ebp
  803e92:	85 ff                	test   %edi,%edi
  803e94:	75 0b                	jne    803ea1 <__umoddi3+0xe9>
  803e96:	b8 01 00 00 00       	mov    $0x1,%eax
  803e9b:	31 d2                	xor    %edx,%edx
  803e9d:	f7 f7                	div    %edi
  803e9f:	89 c5                	mov    %eax,%ebp
  803ea1:	89 f0                	mov    %esi,%eax
  803ea3:	31 d2                	xor    %edx,%edx
  803ea5:	f7 f5                	div    %ebp
  803ea7:	89 c8                	mov    %ecx,%eax
  803ea9:	f7 f5                	div    %ebp
  803eab:	89 d0                	mov    %edx,%eax
  803ead:	e9 44 ff ff ff       	jmp    803df6 <__umoddi3+0x3e>
  803eb2:	66 90                	xchg   %ax,%ax
  803eb4:	89 c8                	mov    %ecx,%eax
  803eb6:	89 f2                	mov    %esi,%edx
  803eb8:	83 c4 1c             	add    $0x1c,%esp
  803ebb:	5b                   	pop    %ebx
  803ebc:	5e                   	pop    %esi
  803ebd:	5f                   	pop    %edi
  803ebe:	5d                   	pop    %ebp
  803ebf:	c3                   	ret    
  803ec0:	3b 04 24             	cmp    (%esp),%eax
  803ec3:	72 06                	jb     803ecb <__umoddi3+0x113>
  803ec5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ec9:	77 0f                	ja     803eda <__umoddi3+0x122>
  803ecb:	89 f2                	mov    %esi,%edx
  803ecd:	29 f9                	sub    %edi,%ecx
  803ecf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ed3:	89 14 24             	mov    %edx,(%esp)
  803ed6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803eda:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ede:	8b 14 24             	mov    (%esp),%edx
  803ee1:	83 c4 1c             	add    $0x1c,%esp
  803ee4:	5b                   	pop    %ebx
  803ee5:	5e                   	pop    %esi
  803ee6:	5f                   	pop    %edi
  803ee7:	5d                   	pop    %ebp
  803ee8:	c3                   	ret    
  803ee9:	8d 76 00             	lea    0x0(%esi),%esi
  803eec:	2b 04 24             	sub    (%esp),%eax
  803eef:	19 fa                	sbb    %edi,%edx
  803ef1:	89 d1                	mov    %edx,%ecx
  803ef3:	89 c6                	mov    %eax,%esi
  803ef5:	e9 71 ff ff ff       	jmp    803e6b <__umoddi3+0xb3>
  803efa:	66 90                	xchg   %ax,%ax
  803efc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f00:	72 ea                	jb     803eec <__umoddi3+0x134>
  803f02:	89 d9                	mov    %ebx,%ecx
  803f04:	e9 62 ff ff ff       	jmp    803e6b <__umoddi3+0xb3>
