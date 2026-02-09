
obj/user/arrayOperations_Master:     file format elf32-i386


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
  800031:	e8 3c 0b 00 00       	call   800b72 <libmain>
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
  8000b1:	68 a0 44 80 00       	push   $0x8044a0
  8000b6:	e8 55 0f 00 00       	call   801010 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8000be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8000cb:	01 d0                	add    %edx,%eax
  8000cd:	8b 00                	mov    (%eax),%eax
  8000cf:	83 ec 08             	sub    $0x8,%esp
  8000d2:	50                   	push   %eax
  8000d3:	68 a2 44 80 00       	push   $0x8044a2
  8000d8:	e8 33 0f 00 00       	call   801010 <cprintf>
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
  800101:	68 a7 44 80 00       	push   $0x8044a7
  800106:	e8 05 0f 00 00       	call   801010 <cprintf>
  80010b:	83 c4 10             	add    $0x10,%esp

}
  80010e:	90                   	nop
  80010f:	c9                   	leave  
  800110:	c3                   	ret    

00800111 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);
void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var);

void
_main(void)
{
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	57                   	push   %edi
  800115:	56                   	push   %esi
  800116:	53                   	push   %ebx
  800117:	81 ec bc 02 00 00    	sub    $0x2bc,%esp
	/*[1] CREATE SEMAPHORES*/
#if USE_KERN_SEMAPHORE
	//Initialize the kernel semaphores
	int semVal ;
	char initCmd1[64] = "__KSem@0@Init";
  80011d:	8d 85 44 ff ff ff    	lea    -0xbc(%ebp),%eax
  800123:	bb 1e 47 80 00       	mov    $0x80471e,%ebx
  800128:	ba 0e 00 00 00       	mov    $0xe,%edx
  80012d:	89 c7                	mov    %eax,%edi
  80012f:	89 de                	mov    %ebx,%esi
  800131:	89 d1                	mov    %edx,%ecx
  800133:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800135:	8d 95 52 ff ff ff    	lea    -0xae(%ebp),%edx
  80013b:	b9 32 00 00 00       	mov    $0x32,%ecx
  800140:	b0 00                	mov    $0x0,%al
  800142:	89 d7                	mov    %edx,%edi
  800144:	f3 aa                	rep stos %al,%es:(%edi)
	char initCmd2[64] = "__KSem@1@Init";
  800146:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
  80014c:	bb 5e 47 80 00       	mov    $0x80475e,%ebx
  800151:	ba 0e 00 00 00       	mov    $0xe,%edx
  800156:	89 c7                	mov    %eax,%edi
  800158:	89 de                	mov    %ebx,%esi
  80015a:	89 d1                	mov    %edx,%ecx
  80015c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80015e:	8d 95 12 ff ff ff    	lea    -0xee(%ebp),%edx
  800164:	b9 32 00 00 00       	mov    $0x32,%ecx
  800169:	b0 00                	mov    $0x0,%al
  80016b:	89 d7                	mov    %edx,%edi
  80016d:	f3 aa                	rep stos %al,%es:(%edi)
	char initCmd3[64] = "__KSem@2@Init";
  80016f:	8d 85 c4 fe ff ff    	lea    -0x13c(%ebp),%eax
  800175:	bb 9e 47 80 00       	mov    $0x80479e,%ebx
  80017a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80017f:	89 c7                	mov    %eax,%edi
  800181:	89 de                	mov    %ebx,%esi
  800183:	89 d1                	mov    %edx,%ecx
  800185:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800187:	8d 95 d2 fe ff ff    	lea    -0x12e(%ebp),%edx
  80018d:	b9 32 00 00 00       	mov    $0x32,%ecx
  800192:	b0 00                	mov    $0x0,%al
  800194:	89 d7                	mov    %edx,%edi
  800196:	f3 aa                	rep stos %al,%es:(%edi)
	semVal = 0; sys_utilities(initCmd1, (uint32)(&semVal));
  800198:	c7 45 84 00 00 00 00 	movl   $0x0,-0x7c(%ebp)
  80019f:	8d 45 84             	lea    -0x7c(%ebp),%eax
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	50                   	push   %eax
  8001a6:	8d 85 44 ff ff ff    	lea    -0xbc(%ebp),%eax
  8001ac:	50                   	push   %eax
  8001ad:	e8 71 31 00 00       	call   803323 <sys_utilities>
  8001b2:	83 c4 10             	add    $0x10,%esp
	semVal = 0; sys_utilities(initCmd2, (uint32)(&semVal));
  8001b5:	c7 45 84 00 00 00 00 	movl   $0x0,-0x7c(%ebp)
  8001bc:	8d 45 84             	lea    -0x7c(%ebp),%eax
  8001bf:	83 ec 08             	sub    $0x8,%esp
  8001c2:	50                   	push   %eax
  8001c3:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
  8001c9:	50                   	push   %eax
  8001ca:	e8 54 31 00 00       	call   803323 <sys_utilities>
  8001cf:	83 c4 10             	add    $0x10,%esp
	semVal = 1; sys_utilities(initCmd3, (uint32)(&semVal));
  8001d2:	c7 45 84 01 00 00 00 	movl   $0x1,-0x7c(%ebp)
  8001d9:	8d 45 84             	lea    -0x7c(%ebp),%eax
  8001dc:	83 ec 08             	sub    $0x8,%esp
  8001df:	50                   	push   %eax
  8001e0:	8d 85 c4 fe ff ff    	lea    -0x13c(%ebp),%eax
  8001e6:	50                   	push   %eax
  8001e7:	e8 37 31 00 00       	call   803323 <sys_utilities>
  8001ec:	83 c4 10             	add    $0x10,%esp
	struct semaphore ready = create_semaphore("Ready", 0);
	struct semaphore finished = create_semaphore("Finished", 0);
	struct semaphore cons_mutex = create_semaphore("Console Mutex", 1);
#endif
	/*[2] RUN THE SLAVES PROGRAMS*/
	int numOfSlaveProgs = 3 ;
  8001ef:	c7 45 dc 03 00 00 00 	movl   $0x3,-0x24(%ebp)

	int32 envIdQuickSort = sys_create_env("slave_qs", (myEnv->page_WS_max_size),(myEnv->SecondListSize) ,(myEnv->percentage_of_WS_pages_to_be_removed));
  8001f6:	a1 20 60 80 00       	mov    0x806020,%eax
  8001fb:	8b 90 70 06 00 00    	mov    0x670(%eax),%edx
  800201:	a1 20 60 80 00       	mov    0x806020,%eax
  800206:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  80020c:	89 c1                	mov    %eax,%ecx
  80020e:	a1 20 60 80 00       	mov    0x806020,%eax
  800213:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800219:	52                   	push   %edx
  80021a:	51                   	push   %ecx
  80021b:	50                   	push   %eax
  80021c:	68 ab 44 80 00       	push   $0x8044ab
  800221:	e8 59 2e 00 00       	call   80307f <sys_create_env>
  800226:	83 c4 10             	add    $0x10,%esp
  800229:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdMergeSort = sys_create_env("slave_ms", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80022c:	a1 20 60 80 00       	mov    0x806020,%eax
  800231:	8b 90 70 06 00 00    	mov    0x670(%eax),%edx
  800237:	a1 20 60 80 00       	mov    0x806020,%eax
  80023c:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  800242:	89 c1                	mov    %eax,%ecx
  800244:	a1 20 60 80 00       	mov    0x806020,%eax
  800249:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80024f:	52                   	push   %edx
  800250:	51                   	push   %ecx
  800251:	50                   	push   %eax
  800252:	68 b4 44 80 00       	push   $0x8044b4
  800257:	e8 23 2e 00 00       	call   80307f <sys_create_env>
  80025c:	83 c4 10             	add    $0x10,%esp
  80025f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int32 envIdStats = sys_create_env("slave_stats", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800262:	a1 20 60 80 00       	mov    0x806020,%eax
  800267:	8b 90 70 06 00 00    	mov    0x670(%eax),%edx
  80026d:	a1 20 60 80 00       	mov    0x806020,%eax
  800272:	8b 80 68 06 00 00    	mov    0x668(%eax),%eax
  800278:	89 c1                	mov    %eax,%ecx
  80027a:	a1 20 60 80 00       	mov    0x806020,%eax
  80027f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800285:	52                   	push   %edx
  800286:	51                   	push   %ecx
  800287:	50                   	push   %eax
  800288:	68 bd 44 80 00       	push   $0x8044bd
  80028d:	e8 ed 2d 00 00       	call   80307f <sys_create_env>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (envIdQuickSort == E_ENV_CREATION_ERROR || envIdMergeSort == E_ENV_CREATION_ERROR || envIdStats == E_ENV_CREATION_ERROR)
  800298:	83 7d d8 ef          	cmpl   $0xffffffef,-0x28(%ebp)
  80029c:	74 0c                	je     8002aa <_main+0x199>
  80029e:	83 7d d4 ef          	cmpl   $0xffffffef,-0x2c(%ebp)
  8002a2:	74 06                	je     8002aa <_main+0x199>
  8002a4:	83 7d d0 ef          	cmpl   $0xffffffef,-0x30(%ebp)
  8002a8:	75 14                	jne    8002be <_main+0x1ad>
		panic("NO AVAILABLE ENVs...");
  8002aa:	83 ec 04             	sub    $0x4,%esp
  8002ad:	68 c9 44 80 00       	push   $0x8044c9
  8002b2:	6a 25                	push   $0x25
  8002b4:	68 de 44 80 00       	push   $0x8044de
  8002b9:	e8 64 0a 00 00       	call   800d22 <_panic>

	sys_run_env(envIdQuickSort);
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c4:	e8 d4 2d 00 00       	call   80309d <sys_run_env>
  8002c9:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdMergeSort);
  8002cc:	83 ec 0c             	sub    $0xc,%esp
  8002cf:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002d2:	e8 c6 2d 00 00       	call   80309d <sys_run_env>
  8002d7:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdStats);
  8002da:	83 ec 0c             	sub    $0xc,%esp
  8002dd:	ff 75 d0             	pushl  -0x30(%ebp)
  8002e0:	e8 b8 2d 00 00       	call   80309d <sys_run_env>
  8002e5:	83 c4 10             	add    $0x10,%esp

	/*[3] CREATE SHARED VARIABLES*/
	//Share the cons_mutex owner ID
	int *mutexOwnerID = smalloc("cons_mutex ownerID", sizeof(int) , 0) ;
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	6a 00                	push   $0x0
  8002ed:	6a 04                	push   $0x4
  8002ef:	68 fc 44 80 00       	push   $0x8044fc
  8002f4:	e8 0a 28 00 00       	call   802b03 <smalloc>
  8002f9:	83 c4 10             	add    $0x10,%esp
  8002fc:	89 45 cc             	mov    %eax,-0x34(%ebp)
	*mutexOwnerID = myEnv->env_id ;
  8002ff:	a1 20 60 80 00       	mov    0x806020,%eax
  800304:	8b 50 10             	mov    0x10(%eax),%edx
  800307:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80030a:	89 10                	mov    %edx,(%eax)

	int ret;
	char Chose;
	char Line[30];
	int NumOfElements;
	int *Elements = NULL;
  80030c:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
	//lock the console
#if USE_KERN_SEMAPHORE
	char waitCmd1[64] = "__KSem@2@Wait";
  800313:	8d 85 66 fe ff ff    	lea    -0x19a(%ebp),%eax
  800319:	bb de 47 80 00       	mov    $0x8047de,%ebx
  80031e:	ba 0e 00 00 00       	mov    $0xe,%edx
  800323:	89 c7                	mov    %eax,%edi
  800325:	89 de                	mov    %ebx,%esi
  800327:	89 d1                	mov    %edx,%ecx
  800329:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80032b:	8d 95 74 fe ff ff    	lea    -0x18c(%ebp),%edx
  800331:	b9 32 00 00 00       	mov    $0x32,%ecx
  800336:	b0 00                	mov    $0x0,%al
  800338:	89 d7                	mov    %edx,%edi
  80033a:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd1, 0);
  80033c:	83 ec 08             	sub    $0x8,%esp
  80033f:	6a 00                	push   $0x0
  800341:	8d 85 66 fe ff ff    	lea    -0x19a(%ebp),%eax
  800347:	50                   	push   %eax
  800348:	e8 d6 2f 00 00       	call   803323 <sys_utilities>
  80034d:	83 c4 10             	add    $0x10,%esp
#else
	wait_semaphore(cons_mutex);
#endif
	{
		cprintf("\n");
  800350:	83 ec 0c             	sub    $0xc,%esp
  800353:	68 a0 44 80 00       	push   $0x8044a0
  800358:	e8 b3 0c 00 00       	call   801010 <cprintf>
  80035d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800360:	83 ec 0c             	sub    $0xc,%esp
  800363:	68 0f 45 80 00       	push   $0x80450f
  800368:	e8 a3 0c 00 00       	call   801010 <cprintf>
  80036d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   ARRAY OOERATIONS   !!!\n");
  800370:	83 ec 0c             	sub    $0xc,%esp
  800373:	68 2d 45 80 00       	push   $0x80452d
  800378:	e8 93 0c 00 00       	call   801010 <cprintf>
  80037d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800380:	83 ec 0c             	sub    $0xc,%esp
  800383:	68 0f 45 80 00       	push   $0x80450f
  800388:	e8 83 0c 00 00       	call   801010 <cprintf>
  80038d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800390:	83 ec 0c             	sub    $0xc,%esp
  800393:	68 a0 44 80 00       	push   $0x8044a0
  800398:	e8 73 0c 00 00       	call   801010 <cprintf>
  80039d:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  8003a0:	83 ec 08             	sub    $0x8,%esp
  8003a3:	8d 85 a6 fe ff ff    	lea    -0x15a(%ebp),%eax
  8003a9:	50                   	push   %eax
  8003aa:	68 4c 45 80 00       	push   $0x80454c
  8003af:	e8 35 13 00 00       	call   8016e9 <readline>
  8003b4:	83 c4 10             	add    $0x10,%esp

		//Create the shared array & its size
		int *arrSize = smalloc("arrSize", sizeof(int) , 0) ;
  8003b7:	83 ec 04             	sub    $0x4,%esp
  8003ba:	6a 00                	push   $0x0
  8003bc:	6a 04                	push   $0x4
  8003be:	68 6b 45 80 00       	push   $0x80456b
  8003c3:	e8 3b 27 00 00       	call   802b03 <smalloc>
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		*arrSize = strtol(Line, NULL, 10) ;
  8003ce:	83 ec 04             	sub    $0x4,%esp
  8003d1:	6a 0a                	push   $0xa
  8003d3:	6a 00                	push   $0x0
  8003d5:	8d 85 a6 fe ff ff    	lea    -0x15a(%ebp),%eax
  8003db:	50                   	push   %eax
  8003dc:	e8 1f 19 00 00       	call   801d00 <strtol>
  8003e1:	83 c4 10             	add    $0x10,%esp
  8003e4:	89 c2                	mov    %eax,%edx
  8003e6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003e9:	89 10                	mov    %edx,(%eax)
		NumOfElements = *arrSize;
  8003eb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003ee:	8b 00                	mov    (%eax),%eax
  8003f0:	89 45 c0             	mov    %eax,-0x40(%ebp)
		Elements = smalloc("arr", sizeof(int) * NumOfElements , 0) ;
  8003f3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8003f6:	c1 e0 02             	shl    $0x2,%eax
  8003f9:	83 ec 04             	sub    $0x4,%esp
  8003fc:	6a 00                	push   $0x0
  8003fe:	50                   	push   %eax
  8003ff:	68 73 45 80 00       	push   $0x804573
  800404:	e8 fa 26 00 00       	call   802b03 <smalloc>
  800409:	83 c4 10             	add    $0x10,%esp
  80040c:	89 45 c8             	mov    %eax,-0x38(%ebp)

		cprintf("Chose the initialization method:\n") ;
  80040f:	83 ec 0c             	sub    $0xc,%esp
  800412:	68 78 45 80 00       	push   $0x804578
  800417:	e8 f4 0b 00 00       	call   801010 <cprintf>
  80041c:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  80041f:	83 ec 0c             	sub    $0xc,%esp
  800422:	68 9a 45 80 00       	push   $0x80459a
  800427:	e8 e4 0b 00 00       	call   801010 <cprintf>
  80042c:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  80042f:	83 ec 0c             	sub    $0xc,%esp
  800432:	68 a8 45 80 00       	push   $0x8045a8
  800437:	e8 d4 0b 00 00       	call   801010 <cprintf>
  80043c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80043f:	83 ec 0c             	sub    $0xc,%esp
  800442:	68 b7 45 80 00       	push   $0x8045b7
  800447:	e8 c4 0b 00 00       	call   801010 <cprintf>
  80044c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80044f:	83 ec 0c             	sub    $0xc,%esp
  800452:	68 c7 45 80 00       	push   $0x8045c7
  800457:	e8 b4 0b 00 00       	call   801010 <cprintf>
  80045c:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80045f:	e8 f1 06 00 00       	call   800b55 <getchar>
  800464:	88 45 bf             	mov    %al,-0x41(%ebp)
			cputchar(Chose);
  800467:	0f be 45 bf          	movsbl -0x41(%ebp),%eax
  80046b:	83 ec 0c             	sub    $0xc,%esp
  80046e:	50                   	push   %eax
  80046f:	e8 c2 06 00 00       	call   800b36 <cputchar>
  800474:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800477:	83 ec 0c             	sub    $0xc,%esp
  80047a:	6a 0a                	push   $0xa
  80047c:	e8 b5 06 00 00       	call   800b36 <cputchar>
  800481:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800484:	80 7d bf 61          	cmpb   $0x61,-0x41(%ebp)
  800488:	74 0c                	je     800496 <_main+0x385>
  80048a:	80 7d bf 62          	cmpb   $0x62,-0x41(%ebp)
  80048e:	74 06                	je     800496 <_main+0x385>
  800490:	80 7d bf 63          	cmpb   $0x63,-0x41(%ebp)
  800494:	75 b9                	jne    80044f <_main+0x33e>

	}
#if USE_KERN_SEMAPHORE
	char signalCmd1[64] = "__KSem@2@Signal";
  800496:	8d 85 26 fe ff ff    	lea    -0x1da(%ebp),%eax
  80049c:	bb 1e 48 80 00       	mov    $0x80481e,%ebx
  8004a1:	ba 04 00 00 00       	mov    $0x4,%edx
  8004a6:	89 c7                	mov    %eax,%edi
  8004a8:	89 de                	mov    %ebx,%esi
  8004aa:	89 d1                	mov    %edx,%ecx
  8004ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8004ae:	8d 95 36 fe ff ff    	lea    -0x1ca(%ebp),%edx
  8004b4:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8004b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004be:	89 d7                	mov    %edx,%edi
  8004c0:	f3 ab                	rep stos %eax,%es:(%edi)
	sys_utilities(signalCmd1, 0);
  8004c2:	83 ec 08             	sub    $0x8,%esp
  8004c5:	6a 00                	push   $0x0
  8004c7:	8d 85 26 fe ff ff    	lea    -0x1da(%ebp),%eax
  8004cd:	50                   	push   %eax
  8004ce:	e8 50 2e 00 00       	call   803323 <sys_utilities>
  8004d3:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(cons_mutex);
#endif
	//unlock the console

	int  i ;
	switch (Chose)
  8004d6:	0f be 45 bf          	movsbl -0x41(%ebp),%eax
  8004da:	83 f8 62             	cmp    $0x62,%eax
  8004dd:	74 1d                	je     8004fc <_main+0x3eb>
  8004df:	83 f8 63             	cmp    $0x63,%eax
  8004e2:	74 2b                	je     80050f <_main+0x3fe>
  8004e4:	83 f8 61             	cmp    $0x61,%eax
  8004e7:	75 39                	jne    800522 <_main+0x411>
	{
	case 'a':
		InitializeAscending(Elements, NumOfElements);
  8004e9:	83 ec 08             	sub    $0x8,%esp
  8004ec:	ff 75 c0             	pushl  -0x40(%ebp)
  8004ef:	ff 75 c8             	pushl  -0x38(%ebp)
  8004f2:	e8 46 04 00 00       	call   80093d <InitializeAscending>
  8004f7:	83 c4 10             	add    $0x10,%esp
		break ;
  8004fa:	eb 37                	jmp    800533 <_main+0x422>
	case 'b':
		InitializeDescending(Elements, NumOfElements);
  8004fc:	83 ec 08             	sub    $0x8,%esp
  8004ff:	ff 75 c0             	pushl  -0x40(%ebp)
  800502:	ff 75 c8             	pushl  -0x38(%ebp)
  800505:	e8 64 04 00 00       	call   80096e <InitializeDescending>
  80050a:	83 c4 10             	add    $0x10,%esp
		break ;
  80050d:	eb 24                	jmp    800533 <_main+0x422>
	case 'c':
		InitializeSemiRandom(Elements, NumOfElements);
  80050f:	83 ec 08             	sub    $0x8,%esp
  800512:	ff 75 c0             	pushl  -0x40(%ebp)
  800515:	ff 75 c8             	pushl  -0x38(%ebp)
  800518:	e8 86 04 00 00       	call   8009a3 <InitializeSemiRandom>
  80051d:	83 c4 10             	add    $0x10,%esp
		break ;
  800520:	eb 11                	jmp    800533 <_main+0x422>
	default:
		InitializeSemiRandom(Elements, NumOfElements);
  800522:	83 ec 08             	sub    $0x8,%esp
  800525:	ff 75 c0             	pushl  -0x40(%ebp)
  800528:	ff 75 c8             	pushl  -0x38(%ebp)
  80052b:	e8 73 04 00 00       	call   8009a3 <InitializeSemiRandom>
  800530:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] SIGNAL READY TO THE SLAVES*/
	for (int i = 0; i < numOfSlaveProgs; ++i)
  800533:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80053a:	eb 43                	jmp    80057f <_main+0x46e>
	{
#if USE_KERN_SEMAPHORE
	char signalCmd2[64] = "__KSem@0@Signal";
  80053c:	8d 85 50 fd ff ff    	lea    -0x2b0(%ebp),%eax
  800542:	bb 5e 48 80 00       	mov    $0x80485e,%ebx
  800547:	ba 04 00 00 00       	mov    $0x4,%edx
  80054c:	89 c7                	mov    %eax,%edi
  80054e:	89 de                	mov    %ebx,%esi
  800550:	89 d1                	mov    %edx,%ecx
  800552:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800554:	8d 95 60 fd ff ff    	lea    -0x2a0(%ebp),%edx
  80055a:	b9 0c 00 00 00       	mov    $0xc,%ecx
  80055f:	b8 00 00 00 00       	mov    $0x0,%eax
  800564:	89 d7                	mov    %edx,%edi
  800566:	f3 ab                	rep stos %eax,%es:(%edi)
	sys_utilities(signalCmd2, 0);
  800568:	83 ec 08             	sub    $0x8,%esp
  80056b:	6a 00                	push   $0x0
  80056d:	8d 85 50 fd ff ff    	lea    -0x2b0(%ebp),%eax
  800573:	50                   	push   %eax
  800574:	e8 aa 2d 00 00       	call   803323 <sys_utilities>
  800579:	83 c4 10             	add    $0x10,%esp
	default:
		InitializeSemiRandom(Elements, NumOfElements);
	}

	/*[4] SIGNAL READY TO THE SLAVES*/
	for (int i = 0; i < numOfSlaveProgs; ++i)
  80057c:	ff 45 e4             	incl   -0x1c(%ebp)
  80057f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800582:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800585:	7c b5                	jl     80053c <_main+0x42b>
	signal_semaphore(ready);
#endif
	}

	/*[5] WAIT TILL ALL SLAVES FINISHED*/
	for (int i = 0; i < numOfSlaveProgs; ++i)
  800587:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80058e:	eb 40                	jmp    8005d0 <_main+0x4bf>
	{
#if USE_KERN_SEMAPHORE
	char waitCmd2[64] = "__KSem@1@Wait";
  800590:	8d 85 50 fd ff ff    	lea    -0x2b0(%ebp),%eax
  800596:	bb 9e 48 80 00       	mov    $0x80489e,%ebx
  80059b:	ba 0e 00 00 00       	mov    $0xe,%edx
  8005a0:	89 c7                	mov    %eax,%edi
  8005a2:	89 de                	mov    %ebx,%esi
  8005a4:	89 d1                	mov    %edx,%ecx
  8005a6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8005a8:	8d 95 5e fd ff ff    	lea    -0x2a2(%ebp),%edx
  8005ae:	b9 32 00 00 00       	mov    $0x32,%ecx
  8005b3:	b0 00                	mov    $0x0,%al
  8005b5:	89 d7                	mov    %edx,%edi
  8005b7:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd2, 0);
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	6a 00                	push   $0x0
  8005be:	8d 85 50 fd ff ff    	lea    -0x2b0(%ebp),%eax
  8005c4:	50                   	push   %eax
  8005c5:	e8 59 2d 00 00       	call   803323 <sys_utilities>
  8005ca:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(ready);
#endif
	}

	/*[5] WAIT TILL ALL SLAVES FINISHED*/
	for (int i = 0; i < numOfSlaveProgs; ++i)
  8005cd:	ff 45 e0             	incl   -0x20(%ebp)
  8005d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005d6:	7c b8                	jl     800590 <_main+0x47f>
	wait_semaphore(finished);
#endif
	}

	/*[6] GET THEIR RESULTS*/
	int *quicksortedArr = NULL;
  8005d8:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
	int *mergesortedArr = NULL;
  8005df:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
	int64 *mean = NULL;
  8005e6:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
	int64 *var = NULL;
  8005ed:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
	int *min = NULL;
  8005f4:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	int *max = NULL;
  8005fb:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
	int *med = NULL;
  800602:	c7 45 a0 00 00 00 00 	movl   $0x0,-0x60(%ebp)
	quicksortedArr = sget(envIdQuickSort, "quicksortedArr") ;
  800609:	83 ec 08             	sub    $0x8,%esp
  80060c:	68 d0 45 80 00       	push   $0x8045d0
  800611:	ff 75 d8             	pushl  -0x28(%ebp)
  800614:	e8 4a 26 00 00       	call   802c63 <sget>
  800619:	83 c4 10             	add    $0x10,%esp
  80061c:	89 45 b8             	mov    %eax,-0x48(%ebp)
	mergesortedArr = sget(envIdMergeSort, "mergesortedArr") ;
  80061f:	83 ec 08             	sub    $0x8,%esp
  800622:	68 df 45 80 00       	push   $0x8045df
  800627:	ff 75 d4             	pushl  -0x2c(%ebp)
  80062a:	e8 34 26 00 00       	call   802c63 <sget>
  80062f:	83 c4 10             	add    $0x10,%esp
  800632:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	mean = sget(envIdStats, "mean") ;
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	68 ee 45 80 00       	push   $0x8045ee
  80063d:	ff 75 d0             	pushl  -0x30(%ebp)
  800640:	e8 1e 26 00 00       	call   802c63 <sget>
  800645:	83 c4 10             	add    $0x10,%esp
  800648:	89 45 b0             	mov    %eax,-0x50(%ebp)
	var = sget(envIdStats,"var") ;
  80064b:	83 ec 08             	sub    $0x8,%esp
  80064e:	68 f3 45 80 00       	push   $0x8045f3
  800653:	ff 75 d0             	pushl  -0x30(%ebp)
  800656:	e8 08 26 00 00       	call   802c63 <sget>
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	89 45 ac             	mov    %eax,-0x54(%ebp)
	min = sget(envIdStats,"min") ;
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	68 f7 45 80 00       	push   $0x8045f7
  800669:	ff 75 d0             	pushl  -0x30(%ebp)
  80066c:	e8 f2 25 00 00       	call   802c63 <sget>
  800671:	83 c4 10             	add    $0x10,%esp
  800674:	89 45 a8             	mov    %eax,-0x58(%ebp)
	max = sget(envIdStats,"max") ;
  800677:	83 ec 08             	sub    $0x8,%esp
  80067a:	68 fb 45 80 00       	push   $0x8045fb
  80067f:	ff 75 d0             	pushl  -0x30(%ebp)
  800682:	e8 dc 25 00 00       	call   802c63 <sget>
  800687:	83 c4 10             	add    $0x10,%esp
  80068a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	med = sget(envIdStats,"med") ;
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	68 ff 45 80 00       	push   $0x8045ff
  800695:	ff 75 d0             	pushl  -0x30(%ebp)
  800698:	e8 c6 25 00 00       	call   802c63 <sget>
  80069d:	83 c4 10             	add    $0x10,%esp
  8006a0:	89 45 a0             	mov    %eax,-0x60(%ebp)

	/*[7] VALIDATE THE RESULTS*/
	uint32 sorted = CheckSorted(quicksortedArr, NumOfElements);
  8006a3:	83 ec 08             	sub    $0x8,%esp
  8006a6:	ff 75 c0             	pushl  -0x40(%ebp)
  8006a9:	ff 75 b8             	pushl  -0x48(%ebp)
  8006ac:	e8 35 02 00 00       	call   8008e6 <CheckSorted>
  8006b1:	83 c4 10             	add    $0x10,%esp
  8006b4:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if(sorted == 0) panic("The array is NOT quick-sorted correctly") ;
  8006b7:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  8006bb:	75 17                	jne    8006d4 <_main+0x5c3>
  8006bd:	83 ec 04             	sub    $0x4,%esp
  8006c0:	68 04 46 80 00       	push   $0x804604
  8006c5:	68 98 00 00 00       	push   $0x98
  8006ca:	68 de 44 80 00       	push   $0x8044de
  8006cf:	e8 4e 06 00 00       	call   800d22 <_panic>
	sorted = CheckSorted(mergesortedArr, NumOfElements);
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	ff 75 c0             	pushl  -0x40(%ebp)
  8006da:	ff 75 b4             	pushl  -0x4c(%ebp)
  8006dd:	e8 04 02 00 00       	call   8008e6 <CheckSorted>
  8006e2:	83 c4 10             	add    $0x10,%esp
  8006e5:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if(sorted == 0) panic("The array is NOT merge-sorted correctly") ;
  8006e8:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  8006ec:	75 17                	jne    800705 <_main+0x5f4>
  8006ee:	83 ec 04             	sub    $0x4,%esp
  8006f1:	68 2c 46 80 00       	push   $0x80462c
  8006f6:	68 9a 00 00 00       	push   $0x9a
  8006fb:	68 de 44 80 00       	push   $0x8044de
  800700:	e8 1d 06 00 00       	call   800d22 <_panic>
	int64 correctMean, correctVar ;
	ArrayStats(Elements, NumOfElements, &correctMean , &correctVar);
  800705:	8d 85 10 fe ff ff    	lea    -0x1f0(%ebp),%eax
  80070b:	50                   	push   %eax
  80070c:	8d 85 18 fe ff ff    	lea    -0x1e8(%ebp),%eax
  800712:	50                   	push   %eax
  800713:	ff 75 c0             	pushl  -0x40(%ebp)
  800716:	ff 75 c8             	pushl  -0x38(%ebp)
  800719:	e8 d1 02 00 00       	call   8009ef <ArrayStats>
  80071e:	83 c4 10             	add    $0x10,%esp
	int correctMin = quicksortedArr[0];
  800721:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	89 45 98             	mov    %eax,-0x68(%ebp)
	int last = NumOfElements-1;
  800729:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80072c:	48                   	dec    %eax
  80072d:	89 45 94             	mov    %eax,-0x6c(%ebp)
//	int middle = (NumOfElements-1)/2;
//	if (NumOfElements % 2 != 0)
//		middle--;
	int middle = (NumOfElements+1)/2 - 1; /*-1 to make it ZERO-Based*/
  800730:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800733:	40                   	inc    %eax
  800734:	89 c2                	mov    %eax,%edx
  800736:	c1 ea 1f             	shr    $0x1f,%edx
  800739:	01 d0                	add    %edx,%eax
  80073b:	d1 f8                	sar    %eax
  80073d:	48                   	dec    %eax
  80073e:	89 45 90             	mov    %eax,-0x70(%ebp)

	int correctMax = quicksortedArr[last];
  800741:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800744:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80074b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80074e:	01 d0                	add    %edx,%eax
  800750:	8b 00                	mov    (%eax),%eax
  800752:	89 45 8c             	mov    %eax,-0x74(%ebp)
	int correctMed = quicksortedArr[middle];
  800755:	8b 45 90             	mov    -0x70(%ebp),%eax
  800758:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80075f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800762:	01 d0                	add    %edx,%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	89 45 88             	mov    %eax,-0x78(%ebp)
#if USE_KERN_SEMAPHORE
	char waitCmd3[64] = "__KSem@2@Wait";
  800769:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
  80076f:	bb de 47 80 00       	mov    $0x8047de,%ebx
  800774:	ba 0e 00 00 00       	mov    $0xe,%edx
  800779:	89 c7                	mov    %eax,%edi
  80077b:	89 de                	mov    %ebx,%esi
  80077d:	89 d1                	mov    %edx,%ecx
  80077f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800781:	8d 95 de fd ff ff    	lea    -0x222(%ebp),%edx
  800787:	b9 32 00 00 00       	mov    $0x32,%ecx
  80078c:	b0 00                	mov    $0x0,%al
  80078e:	89 d7                	mov    %edx,%edi
  800790:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd3, 0);
  800792:	83 ec 08             	sub    $0x8,%esp
  800795:	6a 00                	push   $0x0
  800797:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
  80079d:	50                   	push   %eax
  80079e:	e8 80 2b 00 00       	call   803323 <sys_utilities>
  8007a3:	83 c4 10             	add    $0x10,%esp
#else
	wait_semaphore(cons_mutex);
#endif
	{
		//cprintf("Array is correctly sorted\n");
		cprintf("mean = %lld, var = %lld, min = %d, max = %d, med = %d\n", *mean, *var, *min, *max, *med);
  8007a6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8007a9:	8b 00                	mov    (%eax),%eax
  8007ab:	89 85 44 fd ff ff    	mov    %eax,-0x2bc(%ebp)
  8007b1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8007b4:	8b 38                	mov    (%eax),%edi
  8007b6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8007b9:	8b 30                	mov    (%eax),%esi
  8007bb:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8007be:	8b 08                	mov    (%eax),%ecx
  8007c0:	8b 58 04             	mov    0x4(%eax),%ebx
  8007c3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8007c6:	8b 50 04             	mov    0x4(%eax),%edx
  8007c9:	8b 00                	mov    (%eax),%eax
  8007cb:	ff b5 44 fd ff ff    	pushl  -0x2bc(%ebp)
  8007d1:	57                   	push   %edi
  8007d2:	56                   	push   %esi
  8007d3:	53                   	push   %ebx
  8007d4:	51                   	push   %ecx
  8007d5:	52                   	push   %edx
  8007d6:	50                   	push   %eax
  8007d7:	68 54 46 80 00       	push   $0x804654
  8007dc:	e8 2f 08 00 00       	call   801010 <cprintf>
  8007e1:	83 c4 20             	add    $0x20,%esp
		cprintf("mean = %lld, var = %lld, min = %d, max = %d, med = %d\n", correctMean, correctVar, correctMin, correctMax, correctMed);
  8007e4:	8b 8d 10 fe ff ff    	mov    -0x1f0(%ebp),%ecx
  8007ea:	8b 9d 14 fe ff ff    	mov    -0x1ec(%ebp),%ebx
  8007f0:	8b 85 18 fe ff ff    	mov    -0x1e8(%ebp),%eax
  8007f6:	8b 95 1c fe ff ff    	mov    -0x1e4(%ebp),%edx
  8007fc:	ff 75 88             	pushl  -0x78(%ebp)
  8007ff:	ff 75 8c             	pushl  -0x74(%ebp)
  800802:	ff 75 98             	pushl  -0x68(%ebp)
  800805:	53                   	push   %ebx
  800806:	51                   	push   %ecx
  800807:	52                   	push   %edx
  800808:	50                   	push   %eax
  800809:	68 54 46 80 00       	push   $0x804654
  80080e:	e8 fd 07 00 00       	call   801010 <cprintf>
  800813:	83 c4 20             	add    $0x20,%esp
	}
#if USE_KERN_SEMAPHORE
	char signalCmd3[64] = "__KSem@2@Signal";
  800816:	8d 85 90 fd ff ff    	lea    -0x270(%ebp),%eax
  80081c:	bb 1e 48 80 00       	mov    $0x80481e,%ebx
  800821:	ba 04 00 00 00       	mov    $0x4,%edx
  800826:	89 c7                	mov    %eax,%edi
  800828:	89 de                	mov    %ebx,%esi
  80082a:	89 d1                	mov    %edx,%ecx
  80082c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80082e:	8d 95 a0 fd ff ff    	lea    -0x260(%ebp),%edx
  800834:	b9 0c 00 00 00       	mov    $0xc,%ecx
  800839:	b8 00 00 00 00       	mov    $0x0,%eax
  80083e:	89 d7                	mov    %edx,%edi
  800840:	f3 ab                	rep stos %eax,%es:(%edi)
	sys_utilities(signalCmd3, 0);
  800842:	83 ec 08             	sub    $0x8,%esp
  800845:	6a 00                	push   $0x0
  800847:	8d 85 90 fd ff ff    	lea    -0x270(%ebp),%eax
  80084d:	50                   	push   %eax
  80084e:	e8 d0 2a 00 00       	call   803323 <sys_utilities>
  800853:	83 c4 10             	add    $0x10,%esp
#else
	signal_semaphore(cons_mutex);
#endif

	if(*mean != correctMean || *var != correctVar|| *min != correctMin || *max != correctMax || *med != correctMed)
  800856:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800859:	8b 08                	mov    (%eax),%ecx
  80085b:	8b 58 04             	mov    0x4(%eax),%ebx
  80085e:	8b 85 18 fe ff ff    	mov    -0x1e8(%ebp),%eax
  800864:	8b 95 1c fe ff ff    	mov    -0x1e4(%ebp),%edx
  80086a:	89 de                	mov    %ebx,%esi
  80086c:	31 d6                	xor    %edx,%esi
  80086e:	31 c8                	xor    %ecx,%eax
  800870:	09 f0                	or     %esi,%eax
  800872:	85 c0                	test   %eax,%eax
  800874:	75 3e                	jne    8008b4 <_main+0x7a3>
  800876:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800879:	8b 08                	mov    (%eax),%ecx
  80087b:	8b 58 04             	mov    0x4(%eax),%ebx
  80087e:	8b 85 10 fe ff ff    	mov    -0x1f0(%ebp),%eax
  800884:	8b 95 14 fe ff ff    	mov    -0x1ec(%ebp),%edx
  80088a:	89 de                	mov    %ebx,%esi
  80088c:	31 d6                	xor    %edx,%esi
  80088e:	31 c8                	xor    %ecx,%eax
  800890:	09 f0                	or     %esi,%eax
  800892:	85 c0                	test   %eax,%eax
  800894:	75 1e                	jne    8008b4 <_main+0x7a3>
  800896:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800899:	8b 00                	mov    (%eax),%eax
  80089b:	3b 45 98             	cmp    -0x68(%ebp),%eax
  80089e:	75 14                	jne    8008b4 <_main+0x7a3>
  8008a0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8008a3:	8b 00                	mov    (%eax),%eax
  8008a5:	3b 45 8c             	cmp    -0x74(%ebp),%eax
  8008a8:	75 0a                	jne    8008b4 <_main+0x7a3>
  8008aa:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	3b 45 88             	cmp    -0x78(%ebp),%eax
  8008b2:	74 17                	je     8008cb <_main+0x7ba>
		panic("The array STATS are NOT calculated correctly") ;
  8008b4:	83 ec 04             	sub    $0x4,%esp
  8008b7:	68 8c 46 80 00       	push   $0x80468c
  8008bc:	68 b9 00 00 00       	push   $0xb9
  8008c1:	68 de 44 80 00       	push   $0x8044de
  8008c6:	e8 57 04 00 00       	call   800d22 <_panic>

	cprintf_colored(TEXT_light_green, "Congratulations!! Scenario of Using the Semaphores & Shared Variables completed successfully!!\n\n\n");
  8008cb:	83 ec 08             	sub    $0x8,%esp
  8008ce:	68 bc 46 80 00       	push   $0x8046bc
  8008d3:	6a 0a                	push   $0xa
  8008d5:	e8 63 07 00 00       	call   80103d <cprintf_colored>
  8008da:	83 c4 10             	add    $0x10,%esp

	return;
  8008dd:	90                   	nop
}
  8008de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008e1:	5b                   	pop    %ebx
  8008e2:	5e                   	pop    %esi
  8008e3:	5f                   	pop    %edi
  8008e4:	5d                   	pop    %ebp
  8008e5:	c3                   	ret    

008008e6 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8008e6:	55                   	push   %ebp
  8008e7:	89 e5                	mov    %esp,%ebp
  8008e9:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8008ec:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8008f3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8008fa:	eb 33                	jmp    80092f <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8008fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8008ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	01 d0                	add    %edx,%eax
  80090b:	8b 10                	mov    (%eax),%edx
  80090d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800910:	40                   	inc    %eax
  800911:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800918:	8b 45 08             	mov    0x8(%ebp),%eax
  80091b:	01 c8                	add    %ecx,%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	39 c2                	cmp    %eax,%edx
  800921:	7e 09                	jle    80092c <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800923:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80092a:	eb 0c                	jmp    800938 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80092c:	ff 45 f8             	incl   -0x8(%ebp)
  80092f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800932:	48                   	dec    %eax
  800933:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800936:	7f c4                	jg     8008fc <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800938:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80093b:	c9                   	leave  
  80093c:	c3                   	ret    

0080093d <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80093d:	55                   	push   %ebp
  80093e:	89 e5                	mov    %esp,%ebp
  800940:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800943:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80094a:	eb 17                	jmp    800963 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80094c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80094f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	01 c2                	add    %eax,%edx
  80095b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80095e:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800960:	ff 45 fc             	incl   -0x4(%ebp)
  800963:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800966:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800969:	7c e1                	jl     80094c <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}
}
  80096b:	90                   	nop
  80096c:	c9                   	leave  
  80096d:	c3                   	ret    

0080096e <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800974:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80097b:	eb 1b                	jmp    800998 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  80097d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800980:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800987:	8b 45 08             	mov    0x8(%ebp),%eax
  80098a:	01 c2                	add    %eax,%edx
  80098c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098f:	2b 45 fc             	sub    -0x4(%ebp),%eax
  800992:	48                   	dec    %eax
  800993:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800995:	ff 45 fc             	incl   -0x4(%ebp)
  800998:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80099b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80099e:	7c dd                	jl     80097d <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8009a0:	90                   	nop
  8009a1:	c9                   	leave  
  8009a2:	c3                   	ret    

008009a3 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8009a3:	55                   	push   %ebp
  8009a4:	89 e5                	mov    %esp,%ebp
  8009a6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8009a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ac:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8009b1:	f7 e9                	imul   %ecx
  8009b3:	c1 f9 1f             	sar    $0x1f,%ecx
  8009b6:	89 d0                	mov    %edx,%eax
  8009b8:	29 c8                	sub    %ecx,%eax
  8009ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8009bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009c4:	eb 1e                	jmp    8009e4 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8009c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8009d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009d9:	99                   	cltd   
  8009da:	f7 7d f8             	idivl  -0x8(%ebp)
  8009dd:	89 d0                	mov    %edx,%eax
  8009df:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8009e1:	ff 45 fc             	incl   -0x4(%ebp)
  8009e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009e7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009ea:	7c da                	jl     8009c6 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//cprintf("Elements[%d] = %d\n",i, Elements[i]);
	}

}
  8009ec:	90                   	nop
  8009ed:	c9                   	leave  
  8009ee:	c3                   	ret    

008009ef <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var)
{
  8009ef:	55                   	push   %ebp
  8009f0:	89 e5                	mov    %esp,%ebp
  8009f2:	57                   	push   %edi
  8009f3:	56                   	push   %esi
  8009f4:	53                   	push   %ebx
  8009f5:	83 ec 2c             	sub    $0x2c,%esp
	int i ;
	*mean =0 ;
  8009f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800a01:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800a08:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800a0f:	eb 29                	jmp    800a3a <ArrayStats+0x4b>
	{
		*mean += Elements[i];
  800a11:	8b 45 10             	mov    0x10(%ebp),%eax
  800a14:	8b 08                	mov    (%eax),%ecx
  800a16:	8b 58 04             	mov    0x4(%eax),%ebx
  800a19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a1c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	01 d0                	add    %edx,%eax
  800a28:	8b 00                	mov    (%eax),%eax
  800a2a:	99                   	cltd   
  800a2b:	01 c8                	add    %ecx,%eax
  800a2d:	11 da                	adc    %ebx,%edx
  800a2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a32:	89 01                	mov    %eax,(%ecx)
  800a34:	89 51 04             	mov    %edx,0x4(%ecx)

void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var)
{
	int i ;
	*mean =0 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800a37:	ff 45 e4             	incl   -0x1c(%ebp)
  800a3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a3d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a40:	7c cf                	jl     800a11 <ArrayStats+0x22>
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
  800a42:	8b 45 10             	mov    0x10(%ebp),%eax
  800a45:	8b 50 04             	mov    0x4(%eax),%edx
  800a48:	8b 00                	mov    (%eax),%eax
  800a4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a4d:	89 cb                	mov    %ecx,%ebx
  800a4f:	c1 fb 1f             	sar    $0x1f,%ebx
  800a52:	53                   	push   %ebx
  800a53:	51                   	push   %ecx
  800a54:	52                   	push   %edx
  800a55:	50                   	push   %eax
  800a56:	e8 79 36 00 00       	call   8040d4 <__divdi3>
  800a5b:	83 c4 10             	add    $0x10,%esp
  800a5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a61:	89 01                	mov    %eax,(%ecx)
  800a63:	89 51 04             	mov    %edx,0x4(%ecx)
	*var = 0;
  800a66:	8b 45 14             	mov    0x14(%ebp),%eax
  800a69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800a6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800a76:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800a7d:	eb 7e                	jmp    800afd <ArrayStats+0x10e>
	{
		*var += (int64) ((Elements[i] - *mean)*(Elements[i] - *mean));
  800a7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a82:	8b 50 04             	mov    0x4(%eax),%edx
  800a85:	8b 00                	mov    (%eax),%eax
  800a87:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a8a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800a8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a90:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	01 d0                	add    %edx,%eax
  800a9c:	8b 00                	mov    (%eax),%eax
  800a9e:	89 c1                	mov    %eax,%ecx
  800aa0:	89 c3                	mov    %eax,%ebx
  800aa2:	c1 fb 1f             	sar    $0x1f,%ebx
  800aa5:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa8:	8b 50 04             	mov    0x4(%eax),%edx
  800aab:	8b 00                	mov    (%eax),%eax
  800aad:	29 c1                	sub    %eax,%ecx
  800aaf:	19 d3                	sbb    %edx,%ebx
  800ab1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ab4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	01 d0                	add    %edx,%eax
  800ac0:	8b 00                	mov    (%eax),%eax
  800ac2:	89 c6                	mov    %eax,%esi
  800ac4:	89 c7                	mov    %eax,%edi
  800ac6:	c1 ff 1f             	sar    $0x1f,%edi
  800ac9:	8b 45 10             	mov    0x10(%ebp),%eax
  800acc:	8b 50 04             	mov    0x4(%eax),%edx
  800acf:	8b 00                	mov    (%eax),%eax
  800ad1:	29 c6                	sub    %eax,%esi
  800ad3:	19 d7                	sbb    %edx,%edi
  800ad5:	89 f0                	mov    %esi,%eax
  800ad7:	89 fa                	mov    %edi,%edx
  800ad9:	89 df                	mov    %ebx,%edi
  800adb:	0f af f8             	imul   %eax,%edi
  800ade:	89 d6                	mov    %edx,%esi
  800ae0:	0f af f1             	imul   %ecx,%esi
  800ae3:	01 fe                	add    %edi,%esi
  800ae5:	f7 e1                	mul    %ecx
  800ae7:	8d 0c 16             	lea    (%esi,%edx,1),%ecx
  800aea:	89 ca                	mov    %ecx,%edx
  800aec:	03 45 d0             	add    -0x30(%ebp),%eax
  800aef:	13 55 d4             	adc    -0x2c(%ebp),%edx
  800af2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800af5:	89 01                	mov    %eax,(%ecx)
  800af7:	89 51 04             	mov    %edx,0x4(%ecx)
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
	*var = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  800afa:	ff 45 e4             	incl   -0x1c(%ebp)
  800afd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b00:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b03:	0f 8c 76 ff ff ff    	jl     800a7f <ArrayStats+0x90>
	{
		*var += (int64) ((Elements[i] - *mean)*(Elements[i] - *mean));
//		if (i%1000 == 0)
//			cprintf("current #elements = %d, current var = %lld\n", i , *var);
	}
	*var /= NumOfElements;
  800b09:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0c:	8b 50 04             	mov    0x4(%eax),%edx
  800b0f:	8b 00                	mov    (%eax),%eax
  800b11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b14:	89 cb                	mov    %ecx,%ebx
  800b16:	c1 fb 1f             	sar    $0x1f,%ebx
  800b19:	53                   	push   %ebx
  800b1a:	51                   	push   %ecx
  800b1b:	52                   	push   %edx
  800b1c:	50                   	push   %eax
  800b1d:	e8 b2 35 00 00       	call   8040d4 <__divdi3>
  800b22:	83 c4 10             	add    $0x10,%esp
  800b25:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800b28:	89 01                	mov    %eax,(%ecx)
  800b2a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  800b2d:	90                   	nop
  800b2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b31:	5b                   	pop    %ebx
  800b32:	5e                   	pop    %esi
  800b33:	5f                   	pop    %edi
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800b42:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800b46:	83 ec 0c             	sub    $0xc,%esp
  800b49:	50                   	push   %eax
  800b4a:	e8 6d 24 00 00       	call   802fbc <sys_cputc>
  800b4f:	83 c4 10             	add    $0x10,%esp
}
  800b52:	90                   	nop
  800b53:	c9                   	leave  
  800b54:	c3                   	ret    

00800b55 <getchar>:


int
getchar(void)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  800b5b:	e8 fb 22 00 00       	call   802e5b <sys_cgetc>
  800b60:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b66:	c9                   	leave  
  800b67:	c3                   	ret    

00800b68 <iscons>:

int iscons(int fdnum)
{
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800b6b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800b70:	5d                   	pop    %ebp
  800b71:	c3                   	ret    

00800b72 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	57                   	push   %edi
  800b76:	56                   	push   %esi
  800b77:	53                   	push   %ebx
  800b78:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800b7b:	e8 6d 25 00 00       	call   8030ed <sys_getenvindex>
  800b80:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800b83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b86:	89 d0                	mov    %edx,%eax
  800b88:	01 c0                	add    %eax,%eax
  800b8a:	01 d0                	add    %edx,%eax
  800b8c:	c1 e0 02             	shl    $0x2,%eax
  800b8f:	01 d0                	add    %edx,%eax
  800b91:	c1 e0 02             	shl    $0x2,%eax
  800b94:	01 d0                	add    %edx,%eax
  800b96:	c1 e0 03             	shl    $0x3,%eax
  800b99:	01 d0                	add    %edx,%eax
  800b9b:	c1 e0 02             	shl    $0x2,%eax
  800b9e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ba3:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800ba8:	a1 20 60 80 00       	mov    0x806020,%eax
  800bad:	8a 40 20             	mov    0x20(%eax),%al
  800bb0:	84 c0                	test   %al,%al
  800bb2:	74 0d                	je     800bc1 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800bb4:	a1 20 60 80 00       	mov    0x806020,%eax
  800bb9:	83 c0 20             	add    $0x20,%eax
  800bbc:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800bc1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bc5:	7e 0a                	jle    800bd1 <libmain+0x5f>
		binaryname = argv[0];
  800bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bca:	8b 00                	mov    (%eax),%eax
  800bcc:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  800bd1:	83 ec 08             	sub    $0x8,%esp
  800bd4:	ff 75 0c             	pushl  0xc(%ebp)
  800bd7:	ff 75 08             	pushl  0x8(%ebp)
  800bda:	e8 32 f5 ff ff       	call   800111 <_main>
  800bdf:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800be2:	a1 00 60 80 00       	mov    0x806000,%eax
  800be7:	85 c0                	test   %eax,%eax
  800be9:	0f 84 01 01 00 00    	je     800cf0 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800bef:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800bf5:	bb d8 49 80 00       	mov    $0x8049d8,%ebx
  800bfa:	ba 0e 00 00 00       	mov    $0xe,%edx
  800bff:	89 c7                	mov    %eax,%edi
  800c01:	89 de                	mov    %ebx,%esi
  800c03:	89 d1                	mov    %edx,%ecx
  800c05:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800c07:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800c0a:	b9 56 00 00 00       	mov    $0x56,%ecx
  800c0f:	b0 00                	mov    $0x0,%al
  800c11:	89 d7                	mov    %edx,%edi
  800c13:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800c15:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800c1c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800c1f:	83 ec 08             	sub    $0x8,%esp
  800c22:	50                   	push   %eax
  800c23:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800c29:	50                   	push   %eax
  800c2a:	e8 f4 26 00 00       	call   803323 <sys_utilities>
  800c2f:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800c32:	e8 3d 22 00 00       	call   802e74 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800c37:	83 ec 0c             	sub    $0xc,%esp
  800c3a:	68 f8 48 80 00       	push   $0x8048f8
  800c3f:	e8 cc 03 00 00       	call   801010 <cprintf>
  800c44:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800c47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c4a:	85 c0                	test   %eax,%eax
  800c4c:	74 18                	je     800c66 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800c4e:	e8 ee 26 00 00       	call   803341 <sys_get_optimal_num_faults>
  800c53:	83 ec 08             	sub    $0x8,%esp
  800c56:	50                   	push   %eax
  800c57:	68 20 49 80 00       	push   $0x804920
  800c5c:	e8 af 03 00 00       	call   801010 <cprintf>
  800c61:	83 c4 10             	add    $0x10,%esp
  800c64:	eb 59                	jmp    800cbf <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800c66:	a1 20 60 80 00       	mov    0x806020,%eax
  800c6b:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  800c71:	a1 20 60 80 00       	mov    0x806020,%eax
  800c76:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  800c7c:	83 ec 04             	sub    $0x4,%esp
  800c7f:	52                   	push   %edx
  800c80:	50                   	push   %eax
  800c81:	68 44 49 80 00       	push   $0x804944
  800c86:	e8 85 03 00 00       	call   801010 <cprintf>
  800c8b:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800c8e:	a1 20 60 80 00       	mov    0x806020,%eax
  800c93:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800c99:	a1 20 60 80 00       	mov    0x806020,%eax
  800c9e:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800ca4:	a1 20 60 80 00       	mov    0x806020,%eax
  800ca9:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  800caf:	51                   	push   %ecx
  800cb0:	52                   	push   %edx
  800cb1:	50                   	push   %eax
  800cb2:	68 6c 49 80 00       	push   $0x80496c
  800cb7:	e8 54 03 00 00       	call   801010 <cprintf>
  800cbc:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800cbf:	a1 20 60 80 00       	mov    0x806020,%eax
  800cc4:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  800cca:	83 ec 08             	sub    $0x8,%esp
  800ccd:	50                   	push   %eax
  800cce:	68 c4 49 80 00       	push   $0x8049c4
  800cd3:	e8 38 03 00 00       	call   801010 <cprintf>
  800cd8:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800cdb:	83 ec 0c             	sub    $0xc,%esp
  800cde:	68 f8 48 80 00       	push   $0x8048f8
  800ce3:	e8 28 03 00 00       	call   801010 <cprintf>
  800ce8:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800ceb:	e8 9e 21 00 00       	call   802e8e <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800cf0:	e8 1f 00 00 00       	call   800d14 <exit>
}
  800cf5:	90                   	nop
  800cf6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf9:	5b                   	pop    %ebx
  800cfa:	5e                   	pop    %esi
  800cfb:	5f                   	pop    %edi
  800cfc:	5d                   	pop    %ebp
  800cfd:	c3                   	ret    

00800cfe <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800d04:	83 ec 0c             	sub    $0xc,%esp
  800d07:	6a 00                	push   $0x0
  800d09:	e8 ab 23 00 00       	call   8030b9 <sys_destroy_env>
  800d0e:	83 c4 10             	add    $0x10,%esp
}
  800d11:	90                   	nop
  800d12:	c9                   	leave  
  800d13:	c3                   	ret    

00800d14 <exit>:

void
exit(void)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800d1a:	e8 00 24 00 00       	call   80311f <sys_exit_env>
}
  800d1f:	90                   	nop
  800d20:	c9                   	leave  
  800d21:	c3                   	ret    

00800d22 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800d28:	8d 45 10             	lea    0x10(%ebp),%eax
  800d2b:	83 c0 04             	add    $0x4,%eax
  800d2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800d31:	a1 18 e1 81 00       	mov    0x81e118,%eax
  800d36:	85 c0                	test   %eax,%eax
  800d38:	74 16                	je     800d50 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800d3a:	a1 18 e1 81 00       	mov    0x81e118,%eax
  800d3f:	83 ec 08             	sub    $0x8,%esp
  800d42:	50                   	push   %eax
  800d43:	68 3c 4a 80 00       	push   $0x804a3c
  800d48:	e8 c3 02 00 00       	call   801010 <cprintf>
  800d4d:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800d50:	a1 04 60 80 00       	mov    0x806004,%eax
  800d55:	83 ec 0c             	sub    $0xc,%esp
  800d58:	ff 75 0c             	pushl  0xc(%ebp)
  800d5b:	ff 75 08             	pushl  0x8(%ebp)
  800d5e:	50                   	push   %eax
  800d5f:	68 44 4a 80 00       	push   $0x804a44
  800d64:	6a 74                	push   $0x74
  800d66:	e8 d2 02 00 00       	call   80103d <cprintf_colored>
  800d6b:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800d6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d71:	83 ec 08             	sub    $0x8,%esp
  800d74:	ff 75 f4             	pushl  -0xc(%ebp)
  800d77:	50                   	push   %eax
  800d78:	e8 24 02 00 00       	call   800fa1 <vcprintf>
  800d7d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800d80:	83 ec 08             	sub    $0x8,%esp
  800d83:	6a 00                	push   $0x0
  800d85:	68 6c 4a 80 00       	push   $0x804a6c
  800d8a:	e8 12 02 00 00       	call   800fa1 <vcprintf>
  800d8f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800d92:	e8 7d ff ff ff       	call   800d14 <exit>

	// should not return here
	while (1) ;
  800d97:	eb fe                	jmp    800d97 <_panic+0x75>

00800d99 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	53                   	push   %ebx
  800d9d:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800da0:	a1 20 60 80 00       	mov    0x806020,%eax
  800da5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800dab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dae:	39 c2                	cmp    %eax,%edx
  800db0:	74 14                	je     800dc6 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800db2:	83 ec 04             	sub    $0x4,%esp
  800db5:	68 70 4a 80 00       	push   $0x804a70
  800dba:	6a 26                	push   $0x26
  800dbc:	68 bc 4a 80 00       	push   $0x804abc
  800dc1:	e8 5c ff ff ff       	call   800d22 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800dc6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800dcd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800dd4:	e9 d9 00 00 00       	jmp    800eb2 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  800dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ddc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
  800de6:	01 d0                	add    %edx,%eax
  800de8:	8b 00                	mov    (%eax),%eax
  800dea:	85 c0                	test   %eax,%eax
  800dec:	75 08                	jne    800df6 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  800dee:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800df1:	e9 b9 00 00 00       	jmp    800eaf <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  800df6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dfd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800e04:	eb 79                	jmp    800e7f <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800e06:	a1 20 60 80 00       	mov    0x806020,%eax
  800e0b:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800e11:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e14:	89 d0                	mov    %edx,%eax
  800e16:	01 c0                	add    %eax,%eax
  800e18:	01 d0                	add    %edx,%eax
  800e1a:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800e21:	01 d8                	add    %ebx,%eax
  800e23:	01 d0                	add    %edx,%eax
  800e25:	01 c8                	add    %ecx,%eax
  800e27:	8a 40 04             	mov    0x4(%eax),%al
  800e2a:	84 c0                	test   %al,%al
  800e2c:	75 4e                	jne    800e7c <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e2e:	a1 20 60 80 00       	mov    0x806020,%eax
  800e33:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800e39:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e3c:	89 d0                	mov    %edx,%eax
  800e3e:	01 c0                	add    %eax,%eax
  800e40:	01 d0                	add    %edx,%eax
  800e42:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800e49:	01 d8                	add    %ebx,%eax
  800e4b:	01 d0                	add    %edx,%eax
  800e4d:	01 c8                	add    %ecx,%eax
  800e4f:	8b 00                	mov    (%eax),%eax
  800e51:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800e54:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800e57:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e5c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e61:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	01 c8                	add    %ecx,%eax
  800e6d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e6f:	39 c2                	cmp    %eax,%edx
  800e71:	75 09                	jne    800e7c <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  800e73:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800e7a:	eb 19                	jmp    800e95 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e7c:	ff 45 e8             	incl   -0x18(%ebp)
  800e7f:	a1 20 60 80 00       	mov    0x806020,%eax
  800e84:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800e8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800e8d:	39 c2                	cmp    %eax,%edx
  800e8f:	0f 87 71 ff ff ff    	ja     800e06 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800e95:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e99:	75 14                	jne    800eaf <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800e9b:	83 ec 04             	sub    $0x4,%esp
  800e9e:	68 c8 4a 80 00       	push   $0x804ac8
  800ea3:	6a 3a                	push   $0x3a
  800ea5:	68 bc 4a 80 00       	push   $0x804abc
  800eaa:	e8 73 fe ff ff       	call   800d22 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800eaf:	ff 45 f0             	incl   -0x10(%ebp)
  800eb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800eb8:	0f 8c 1b ff ff ff    	jl     800dd9 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800ebe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ec5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800ecc:	eb 2e                	jmp    800efc <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800ece:	a1 20 60 80 00       	mov    0x806020,%eax
  800ed3:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800ed9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800edc:	89 d0                	mov    %edx,%eax
  800ede:	01 c0                	add    %eax,%eax
  800ee0:	01 d0                	add    %edx,%eax
  800ee2:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800ee9:	01 d8                	add    %ebx,%eax
  800eeb:	01 d0                	add    %edx,%eax
  800eed:	01 c8                	add    %ecx,%eax
  800eef:	8a 40 04             	mov    0x4(%eax),%al
  800ef2:	3c 01                	cmp    $0x1,%al
  800ef4:	75 03                	jne    800ef9 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  800ef6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ef9:	ff 45 e0             	incl   -0x20(%ebp)
  800efc:	a1 20 60 80 00       	mov    0x806020,%eax
  800f01:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800f07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f0a:	39 c2                	cmp    %eax,%edx
  800f0c:	77 c0                	ja     800ece <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f11:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800f14:	74 14                	je     800f2a <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  800f16:	83 ec 04             	sub    $0x4,%esp
  800f19:	68 1c 4b 80 00       	push   $0x804b1c
  800f1e:	6a 44                	push   $0x44
  800f20:	68 bc 4a 80 00       	push   $0x804abc
  800f25:	e8 f8 fd ff ff       	call   800d22 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800f2a:	90                   	nop
  800f2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f2e:	c9                   	leave  
  800f2f:	c3                   	ret    

00800f30 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
  800f33:	53                   	push   %ebx
  800f34:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800f37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3a:	8b 00                	mov    (%eax),%eax
  800f3c:	8d 48 01             	lea    0x1(%eax),%ecx
  800f3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f42:	89 0a                	mov    %ecx,(%edx)
  800f44:	8b 55 08             	mov    0x8(%ebp),%edx
  800f47:	88 d1                	mov    %dl,%cl
  800f49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f4c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f53:	8b 00                	mov    (%eax),%eax
  800f55:	3d ff 00 00 00       	cmp    $0xff,%eax
  800f5a:	75 30                	jne    800f8c <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800f5c:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  800f62:	a0 44 60 80 00       	mov    0x806044,%al
  800f67:	0f b6 c0             	movzbl %al,%eax
  800f6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6d:	8b 09                	mov    (%ecx),%ecx
  800f6f:	89 cb                	mov    %ecx,%ebx
  800f71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f74:	83 c1 08             	add    $0x8,%ecx
  800f77:	52                   	push   %edx
  800f78:	50                   	push   %eax
  800f79:	53                   	push   %ebx
  800f7a:	51                   	push   %ecx
  800f7b:	e8 b0 1e 00 00       	call   802e30 <sys_cputs>
  800f80:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800f83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8f:	8b 40 04             	mov    0x4(%eax),%eax
  800f92:	8d 50 01             	lea    0x1(%eax),%edx
  800f95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f98:	89 50 04             	mov    %edx,0x4(%eax)
}
  800f9b:	90                   	nop
  800f9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f9f:	c9                   	leave  
  800fa0:	c3                   	ret    

00800fa1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800faa:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800fb1:	00 00 00 
	b.cnt = 0;
  800fb4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800fbb:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800fbe:	ff 75 0c             	pushl  0xc(%ebp)
  800fc1:	ff 75 08             	pushl  0x8(%ebp)
  800fc4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800fca:	50                   	push   %eax
  800fcb:	68 30 0f 80 00       	push   $0x800f30
  800fd0:	e8 5a 02 00 00       	call   80122f <vprintfmt>
  800fd5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800fd8:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  800fde:	a0 44 60 80 00       	mov    0x806044,%al
  800fe3:	0f b6 c0             	movzbl %al,%eax
  800fe6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800fec:	52                   	push   %edx
  800fed:	50                   	push   %eax
  800fee:	51                   	push   %ecx
  800fef:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ff5:	83 c0 08             	add    $0x8,%eax
  800ff8:	50                   	push   %eax
  800ff9:	e8 32 1e 00 00       	call   802e30 <sys_cputs>
  800ffe:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801001:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
	return b.cnt;
  801008:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80100e:	c9                   	leave  
  80100f:	c3                   	ret    

00801010 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
  801013:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801016:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	va_start(ap, fmt);
  80101d:	8d 45 0c             	lea    0xc(%ebp),%eax
  801020:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	83 ec 08             	sub    $0x8,%esp
  801029:	ff 75 f4             	pushl  -0xc(%ebp)
  80102c:	50                   	push   %eax
  80102d:	e8 6f ff ff ff       	call   800fa1 <vcprintf>
  801032:	83 c4 10             	add    $0x10,%esp
  801035:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801038:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80103b:	c9                   	leave  
  80103c:	c3                   	ret    

0080103d <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801043:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	c1 e0 08             	shl    $0x8,%eax
  801050:	a3 1c e1 81 00       	mov    %eax,0x81e11c
	va_start(ap, fmt);
  801055:	8d 45 0c             	lea    0xc(%ebp),%eax
  801058:	83 c0 04             	add    $0x4,%eax
  80105b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80105e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801061:	83 ec 08             	sub    $0x8,%esp
  801064:	ff 75 f4             	pushl  -0xc(%ebp)
  801067:	50                   	push   %eax
  801068:	e8 34 ff ff ff       	call   800fa1 <vcprintf>
  80106d:	83 c4 10             	add    $0x10,%esp
  801070:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  801073:	c7 05 1c e1 81 00 00 	movl   $0x700,0x81e11c
  80107a:	07 00 00 

	return cnt;
  80107d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801080:	c9                   	leave  
  801081:	c3                   	ret    

00801082 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801088:	e8 e7 1d 00 00       	call   802e74 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80108d:	8d 45 0c             	lea    0xc(%ebp),%eax
  801090:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	83 ec 08             	sub    $0x8,%esp
  801099:	ff 75 f4             	pushl  -0xc(%ebp)
  80109c:	50                   	push   %eax
  80109d:	e8 ff fe ff ff       	call   800fa1 <vcprintf>
  8010a2:	83 c4 10             	add    $0x10,%esp
  8010a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8010a8:	e8 e1 1d 00 00       	call   802e8e <sys_unlock_cons>
	return cnt;
  8010ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010b0:	c9                   	leave  
  8010b1:	c3                   	ret    

008010b2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	53                   	push   %ebx
  8010b6:	83 ec 14             	sub    $0x14,%esp
  8010b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8010c5:	8b 45 18             	mov    0x18(%ebp),%eax
  8010c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8010cd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8010d0:	77 55                	ja     801127 <printnum+0x75>
  8010d2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8010d5:	72 05                	jb     8010dc <printnum+0x2a>
  8010d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010da:	77 4b                	ja     801127 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8010dc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8010df:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8010e2:	8b 45 18             	mov    0x18(%ebp),%eax
  8010e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ea:	52                   	push   %edx
  8010eb:	50                   	push   %eax
  8010ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8010ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8010f2:	e8 45 31 00 00       	call   80423c <__udivdi3>
  8010f7:	83 c4 10             	add    $0x10,%esp
  8010fa:	83 ec 04             	sub    $0x4,%esp
  8010fd:	ff 75 20             	pushl  0x20(%ebp)
  801100:	53                   	push   %ebx
  801101:	ff 75 18             	pushl  0x18(%ebp)
  801104:	52                   	push   %edx
  801105:	50                   	push   %eax
  801106:	ff 75 0c             	pushl  0xc(%ebp)
  801109:	ff 75 08             	pushl  0x8(%ebp)
  80110c:	e8 a1 ff ff ff       	call   8010b2 <printnum>
  801111:	83 c4 20             	add    $0x20,%esp
  801114:	eb 1a                	jmp    801130 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801116:	83 ec 08             	sub    $0x8,%esp
  801119:	ff 75 0c             	pushl  0xc(%ebp)
  80111c:	ff 75 20             	pushl  0x20(%ebp)
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
  801122:	ff d0                	call   *%eax
  801124:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801127:	ff 4d 1c             	decl   0x1c(%ebp)
  80112a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80112e:	7f e6                	jg     801116 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801130:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801133:	bb 00 00 00 00       	mov    $0x0,%ebx
  801138:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80113b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80113e:	53                   	push   %ebx
  80113f:	51                   	push   %ecx
  801140:	52                   	push   %edx
  801141:	50                   	push   %eax
  801142:	e8 05 32 00 00       	call   80434c <__umoddi3>
  801147:	83 c4 10             	add    $0x10,%esp
  80114a:	05 94 4d 80 00       	add    $0x804d94,%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	0f be c0             	movsbl %al,%eax
  801154:	83 ec 08             	sub    $0x8,%esp
  801157:	ff 75 0c             	pushl  0xc(%ebp)
  80115a:	50                   	push   %eax
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	ff d0                	call   *%eax
  801160:	83 c4 10             	add    $0x10,%esp
}
  801163:	90                   	nop
  801164:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801167:	c9                   	leave  
  801168:	c3                   	ret    

00801169 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80116c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801170:	7e 1c                	jle    80118e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801172:	8b 45 08             	mov    0x8(%ebp),%eax
  801175:	8b 00                	mov    (%eax),%eax
  801177:	8d 50 08             	lea    0x8(%eax),%edx
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
  80117d:	89 10                	mov    %edx,(%eax)
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	8b 00                	mov    (%eax),%eax
  801184:	83 e8 08             	sub    $0x8,%eax
  801187:	8b 50 04             	mov    0x4(%eax),%edx
  80118a:	8b 00                	mov    (%eax),%eax
  80118c:	eb 40                	jmp    8011ce <getuint+0x65>
	else if (lflag)
  80118e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801192:	74 1e                	je     8011b2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
  801197:	8b 00                	mov    (%eax),%eax
  801199:	8d 50 04             	lea    0x4(%eax),%edx
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	89 10                	mov    %edx,(%eax)
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	8b 00                	mov    (%eax),%eax
  8011a6:	83 e8 04             	sub    $0x4,%eax
  8011a9:	8b 00                	mov    (%eax),%eax
  8011ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8011b0:	eb 1c                	jmp    8011ce <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	8b 00                	mov    (%eax),%eax
  8011b7:	8d 50 04             	lea    0x4(%eax),%edx
  8011ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bd:	89 10                	mov    %edx,(%eax)
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	8b 00                	mov    (%eax),%eax
  8011c4:	83 e8 04             	sub    $0x4,%eax
  8011c7:	8b 00                	mov    (%eax),%eax
  8011c9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8011ce:	5d                   	pop    %ebp
  8011cf:	c3                   	ret    

008011d0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8011d3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8011d7:	7e 1c                	jle    8011f5 <getint+0x25>
		return va_arg(*ap, long long);
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dc:	8b 00                	mov    (%eax),%eax
  8011de:	8d 50 08             	lea    0x8(%eax),%edx
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	89 10                	mov    %edx,(%eax)
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	8b 00                	mov    (%eax),%eax
  8011eb:	83 e8 08             	sub    $0x8,%eax
  8011ee:	8b 50 04             	mov    0x4(%eax),%edx
  8011f1:	8b 00                	mov    (%eax),%eax
  8011f3:	eb 38                	jmp    80122d <getint+0x5d>
	else if (lflag)
  8011f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011f9:	74 1a                	je     801215 <getint+0x45>
		return va_arg(*ap, long);
  8011fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fe:	8b 00                	mov    (%eax),%eax
  801200:	8d 50 04             	lea    0x4(%eax),%edx
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	89 10                	mov    %edx,(%eax)
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8b 00                	mov    (%eax),%eax
  80120d:	83 e8 04             	sub    $0x4,%eax
  801210:	8b 00                	mov    (%eax),%eax
  801212:	99                   	cltd   
  801213:	eb 18                	jmp    80122d <getint+0x5d>
	else
		return va_arg(*ap, int);
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8b 00                	mov    (%eax),%eax
  80121a:	8d 50 04             	lea    0x4(%eax),%edx
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	89 10                	mov    %edx,(%eax)
  801222:	8b 45 08             	mov    0x8(%ebp),%eax
  801225:	8b 00                	mov    (%eax),%eax
  801227:	83 e8 04             	sub    $0x4,%eax
  80122a:	8b 00                	mov    (%eax),%eax
  80122c:	99                   	cltd   
}
  80122d:	5d                   	pop    %ebp
  80122e:	c3                   	ret    

0080122f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80122f:	55                   	push   %ebp
  801230:	89 e5                	mov    %esp,%ebp
  801232:	56                   	push   %esi
  801233:	53                   	push   %ebx
  801234:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801237:	eb 17                	jmp    801250 <vprintfmt+0x21>
			if (ch == '\0')
  801239:	85 db                	test   %ebx,%ebx
  80123b:	0f 84 c1 03 00 00    	je     801602 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801241:	83 ec 08             	sub    $0x8,%esp
  801244:	ff 75 0c             	pushl  0xc(%ebp)
  801247:	53                   	push   %ebx
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	ff d0                	call   *%eax
  80124d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801250:	8b 45 10             	mov    0x10(%ebp),%eax
  801253:	8d 50 01             	lea    0x1(%eax),%edx
  801256:	89 55 10             	mov    %edx,0x10(%ebp)
  801259:	8a 00                	mov    (%eax),%al
  80125b:	0f b6 d8             	movzbl %al,%ebx
  80125e:	83 fb 25             	cmp    $0x25,%ebx
  801261:	75 d6                	jne    801239 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801263:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801267:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80126e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801275:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80127c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801283:	8b 45 10             	mov    0x10(%ebp),%eax
  801286:	8d 50 01             	lea    0x1(%eax),%edx
  801289:	89 55 10             	mov    %edx,0x10(%ebp)
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	0f b6 d8             	movzbl %al,%ebx
  801291:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801294:	83 f8 5b             	cmp    $0x5b,%eax
  801297:	0f 87 3d 03 00 00    	ja     8015da <vprintfmt+0x3ab>
  80129d:	8b 04 85 b8 4d 80 00 	mov    0x804db8(,%eax,4),%eax
  8012a4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8012a6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8012aa:	eb d7                	jmp    801283 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8012ac:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8012b0:	eb d1                	jmp    801283 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8012b2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8012b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8012bc:	89 d0                	mov    %edx,%eax
  8012be:	c1 e0 02             	shl    $0x2,%eax
  8012c1:	01 d0                	add    %edx,%eax
  8012c3:	01 c0                	add    %eax,%eax
  8012c5:	01 d8                	add    %ebx,%eax
  8012c7:	83 e8 30             	sub    $0x30,%eax
  8012ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8012cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d0:	8a 00                	mov    (%eax),%al
  8012d2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8012d5:	83 fb 2f             	cmp    $0x2f,%ebx
  8012d8:	7e 3e                	jle    801318 <vprintfmt+0xe9>
  8012da:	83 fb 39             	cmp    $0x39,%ebx
  8012dd:	7f 39                	jg     801318 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8012df:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8012e2:	eb d5                	jmp    8012b9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8012e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e7:	83 c0 04             	add    $0x4,%eax
  8012ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8012ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f0:	83 e8 04             	sub    $0x4,%eax
  8012f3:	8b 00                	mov    (%eax),%eax
  8012f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8012f8:	eb 1f                	jmp    801319 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8012fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012fe:	79 83                	jns    801283 <vprintfmt+0x54>
				width = 0;
  801300:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801307:	e9 77 ff ff ff       	jmp    801283 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80130c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801313:	e9 6b ff ff ff       	jmp    801283 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801318:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801319:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80131d:	0f 89 60 ff ff ff    	jns    801283 <vprintfmt+0x54>
				width = precision, precision = -1;
  801323:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801326:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801329:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801330:	e9 4e ff ff ff       	jmp    801283 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801335:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801338:	e9 46 ff ff ff       	jmp    801283 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80133d:	8b 45 14             	mov    0x14(%ebp),%eax
  801340:	83 c0 04             	add    $0x4,%eax
  801343:	89 45 14             	mov    %eax,0x14(%ebp)
  801346:	8b 45 14             	mov    0x14(%ebp),%eax
  801349:	83 e8 04             	sub    $0x4,%eax
  80134c:	8b 00                	mov    (%eax),%eax
  80134e:	83 ec 08             	sub    $0x8,%esp
  801351:	ff 75 0c             	pushl  0xc(%ebp)
  801354:	50                   	push   %eax
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	ff d0                	call   *%eax
  80135a:	83 c4 10             	add    $0x10,%esp
			break;
  80135d:	e9 9b 02 00 00       	jmp    8015fd <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801362:	8b 45 14             	mov    0x14(%ebp),%eax
  801365:	83 c0 04             	add    $0x4,%eax
  801368:	89 45 14             	mov    %eax,0x14(%ebp)
  80136b:	8b 45 14             	mov    0x14(%ebp),%eax
  80136e:	83 e8 04             	sub    $0x4,%eax
  801371:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801373:	85 db                	test   %ebx,%ebx
  801375:	79 02                	jns    801379 <vprintfmt+0x14a>
				err = -err;
  801377:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801379:	83 fb 64             	cmp    $0x64,%ebx
  80137c:	7f 0b                	jg     801389 <vprintfmt+0x15a>
  80137e:	8b 34 9d 00 4c 80 00 	mov    0x804c00(,%ebx,4),%esi
  801385:	85 f6                	test   %esi,%esi
  801387:	75 19                	jne    8013a2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801389:	53                   	push   %ebx
  80138a:	68 a5 4d 80 00       	push   $0x804da5
  80138f:	ff 75 0c             	pushl  0xc(%ebp)
  801392:	ff 75 08             	pushl  0x8(%ebp)
  801395:	e8 70 02 00 00       	call   80160a <printfmt>
  80139a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80139d:	e9 5b 02 00 00       	jmp    8015fd <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8013a2:	56                   	push   %esi
  8013a3:	68 ae 4d 80 00       	push   $0x804dae
  8013a8:	ff 75 0c             	pushl  0xc(%ebp)
  8013ab:	ff 75 08             	pushl  0x8(%ebp)
  8013ae:	e8 57 02 00 00       	call   80160a <printfmt>
  8013b3:	83 c4 10             	add    $0x10,%esp
			break;
  8013b6:	e9 42 02 00 00       	jmp    8015fd <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8013bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8013be:	83 c0 04             	add    $0x4,%eax
  8013c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8013c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c7:	83 e8 04             	sub    $0x4,%eax
  8013ca:	8b 30                	mov    (%eax),%esi
  8013cc:	85 f6                	test   %esi,%esi
  8013ce:	75 05                	jne    8013d5 <vprintfmt+0x1a6>
				p = "(null)";
  8013d0:	be b1 4d 80 00       	mov    $0x804db1,%esi
			if (width > 0 && padc != '-')
  8013d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8013d9:	7e 6d                	jle    801448 <vprintfmt+0x219>
  8013db:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8013df:	74 67                	je     801448 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8013e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013e4:	83 ec 08             	sub    $0x8,%esp
  8013e7:	50                   	push   %eax
  8013e8:	56                   	push   %esi
  8013e9:	e8 26 05 00 00       	call   801914 <strnlen>
  8013ee:	83 c4 10             	add    $0x10,%esp
  8013f1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8013f4:	eb 16                	jmp    80140c <vprintfmt+0x1dd>
					putch(padc, putdat);
  8013f6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8013fa:	83 ec 08             	sub    $0x8,%esp
  8013fd:	ff 75 0c             	pushl  0xc(%ebp)
  801400:	50                   	push   %eax
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	ff d0                	call   *%eax
  801406:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801409:	ff 4d e4             	decl   -0x1c(%ebp)
  80140c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801410:	7f e4                	jg     8013f6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801412:	eb 34                	jmp    801448 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801414:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801418:	74 1c                	je     801436 <vprintfmt+0x207>
  80141a:	83 fb 1f             	cmp    $0x1f,%ebx
  80141d:	7e 05                	jle    801424 <vprintfmt+0x1f5>
  80141f:	83 fb 7e             	cmp    $0x7e,%ebx
  801422:	7e 12                	jle    801436 <vprintfmt+0x207>
					putch('?', putdat);
  801424:	83 ec 08             	sub    $0x8,%esp
  801427:	ff 75 0c             	pushl  0xc(%ebp)
  80142a:	6a 3f                	push   $0x3f
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
  80142f:	ff d0                	call   *%eax
  801431:	83 c4 10             	add    $0x10,%esp
  801434:	eb 0f                	jmp    801445 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801436:	83 ec 08             	sub    $0x8,%esp
  801439:	ff 75 0c             	pushl  0xc(%ebp)
  80143c:	53                   	push   %ebx
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	ff d0                	call   *%eax
  801442:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801445:	ff 4d e4             	decl   -0x1c(%ebp)
  801448:	89 f0                	mov    %esi,%eax
  80144a:	8d 70 01             	lea    0x1(%eax),%esi
  80144d:	8a 00                	mov    (%eax),%al
  80144f:	0f be d8             	movsbl %al,%ebx
  801452:	85 db                	test   %ebx,%ebx
  801454:	74 24                	je     80147a <vprintfmt+0x24b>
  801456:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80145a:	78 b8                	js     801414 <vprintfmt+0x1e5>
  80145c:	ff 4d e0             	decl   -0x20(%ebp)
  80145f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801463:	79 af                	jns    801414 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801465:	eb 13                	jmp    80147a <vprintfmt+0x24b>
				putch(' ', putdat);
  801467:	83 ec 08             	sub    $0x8,%esp
  80146a:	ff 75 0c             	pushl  0xc(%ebp)
  80146d:	6a 20                	push   $0x20
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	ff d0                	call   *%eax
  801474:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801477:	ff 4d e4             	decl   -0x1c(%ebp)
  80147a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80147e:	7f e7                	jg     801467 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801480:	e9 78 01 00 00       	jmp    8015fd <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801485:	83 ec 08             	sub    $0x8,%esp
  801488:	ff 75 e8             	pushl  -0x18(%ebp)
  80148b:	8d 45 14             	lea    0x14(%ebp),%eax
  80148e:	50                   	push   %eax
  80148f:	e8 3c fd ff ff       	call   8011d0 <getint>
  801494:	83 c4 10             	add    $0x10,%esp
  801497:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80149a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80149d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014a3:	85 d2                	test   %edx,%edx
  8014a5:	79 23                	jns    8014ca <vprintfmt+0x29b>
				putch('-', putdat);
  8014a7:	83 ec 08             	sub    $0x8,%esp
  8014aa:	ff 75 0c             	pushl  0xc(%ebp)
  8014ad:	6a 2d                	push   $0x2d
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	ff d0                	call   *%eax
  8014b4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8014b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014bd:	f7 d8                	neg    %eax
  8014bf:	83 d2 00             	adc    $0x0,%edx
  8014c2:	f7 da                	neg    %edx
  8014c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8014ca:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8014d1:	e9 bc 00 00 00       	jmp    801592 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8014d6:	83 ec 08             	sub    $0x8,%esp
  8014d9:	ff 75 e8             	pushl  -0x18(%ebp)
  8014dc:	8d 45 14             	lea    0x14(%ebp),%eax
  8014df:	50                   	push   %eax
  8014e0:	e8 84 fc ff ff       	call   801169 <getuint>
  8014e5:	83 c4 10             	add    $0x10,%esp
  8014e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8014ee:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8014f5:	e9 98 00 00 00       	jmp    801592 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8014fa:	83 ec 08             	sub    $0x8,%esp
  8014fd:	ff 75 0c             	pushl  0xc(%ebp)
  801500:	6a 58                	push   $0x58
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
  801505:	ff d0                	call   *%eax
  801507:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80150a:	83 ec 08             	sub    $0x8,%esp
  80150d:	ff 75 0c             	pushl  0xc(%ebp)
  801510:	6a 58                	push   $0x58
  801512:	8b 45 08             	mov    0x8(%ebp),%eax
  801515:	ff d0                	call   *%eax
  801517:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80151a:	83 ec 08             	sub    $0x8,%esp
  80151d:	ff 75 0c             	pushl  0xc(%ebp)
  801520:	6a 58                	push   $0x58
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	ff d0                	call   *%eax
  801527:	83 c4 10             	add    $0x10,%esp
			break;
  80152a:	e9 ce 00 00 00       	jmp    8015fd <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80152f:	83 ec 08             	sub    $0x8,%esp
  801532:	ff 75 0c             	pushl  0xc(%ebp)
  801535:	6a 30                	push   $0x30
  801537:	8b 45 08             	mov    0x8(%ebp),%eax
  80153a:	ff d0                	call   *%eax
  80153c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80153f:	83 ec 08             	sub    $0x8,%esp
  801542:	ff 75 0c             	pushl  0xc(%ebp)
  801545:	6a 78                	push   $0x78
  801547:	8b 45 08             	mov    0x8(%ebp),%eax
  80154a:	ff d0                	call   *%eax
  80154c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80154f:	8b 45 14             	mov    0x14(%ebp),%eax
  801552:	83 c0 04             	add    $0x4,%eax
  801555:	89 45 14             	mov    %eax,0x14(%ebp)
  801558:	8b 45 14             	mov    0x14(%ebp),%eax
  80155b:	83 e8 04             	sub    $0x4,%eax
  80155e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801560:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801563:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80156a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801571:	eb 1f                	jmp    801592 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801573:	83 ec 08             	sub    $0x8,%esp
  801576:	ff 75 e8             	pushl  -0x18(%ebp)
  801579:	8d 45 14             	lea    0x14(%ebp),%eax
  80157c:	50                   	push   %eax
  80157d:	e8 e7 fb ff ff       	call   801169 <getuint>
  801582:	83 c4 10             	add    $0x10,%esp
  801585:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801588:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80158b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801592:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801596:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801599:	83 ec 04             	sub    $0x4,%esp
  80159c:	52                   	push   %edx
  80159d:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015a0:	50                   	push   %eax
  8015a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8015a7:	ff 75 0c             	pushl  0xc(%ebp)
  8015aa:	ff 75 08             	pushl  0x8(%ebp)
  8015ad:	e8 00 fb ff ff       	call   8010b2 <printnum>
  8015b2:	83 c4 20             	add    $0x20,%esp
			break;
  8015b5:	eb 46                	jmp    8015fd <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8015b7:	83 ec 08             	sub    $0x8,%esp
  8015ba:	ff 75 0c             	pushl  0xc(%ebp)
  8015bd:	53                   	push   %ebx
  8015be:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c1:	ff d0                	call   *%eax
  8015c3:	83 c4 10             	add    $0x10,%esp
			break;
  8015c6:	eb 35                	jmp    8015fd <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8015c8:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
			break;
  8015cf:	eb 2c                	jmp    8015fd <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8015d1:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
			break;
  8015d8:	eb 23                	jmp    8015fd <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8015da:	83 ec 08             	sub    $0x8,%esp
  8015dd:	ff 75 0c             	pushl  0xc(%ebp)
  8015e0:	6a 25                	push   $0x25
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	ff d0                	call   *%eax
  8015e7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8015ea:	ff 4d 10             	decl   0x10(%ebp)
  8015ed:	eb 03                	jmp    8015f2 <vprintfmt+0x3c3>
  8015ef:	ff 4d 10             	decl   0x10(%ebp)
  8015f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f5:	48                   	dec    %eax
  8015f6:	8a 00                	mov    (%eax),%al
  8015f8:	3c 25                	cmp    $0x25,%al
  8015fa:	75 f3                	jne    8015ef <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8015fc:	90                   	nop
		}
	}
  8015fd:	e9 35 fc ff ff       	jmp    801237 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801602:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801603:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801606:	5b                   	pop    %ebx
  801607:	5e                   	pop    %esi
  801608:	5d                   	pop    %ebp
  801609:	c3                   	ret    

0080160a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801610:	8d 45 10             	lea    0x10(%ebp),%eax
  801613:	83 c0 04             	add    $0x4,%eax
  801616:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801619:	8b 45 10             	mov    0x10(%ebp),%eax
  80161c:	ff 75 f4             	pushl  -0xc(%ebp)
  80161f:	50                   	push   %eax
  801620:	ff 75 0c             	pushl  0xc(%ebp)
  801623:	ff 75 08             	pushl  0x8(%ebp)
  801626:	e8 04 fc ff ff       	call   80122f <vprintfmt>
  80162b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80162e:	90                   	nop
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801634:	8b 45 0c             	mov    0xc(%ebp),%eax
  801637:	8b 40 08             	mov    0x8(%eax),%eax
  80163a:	8d 50 01             	lea    0x1(%eax),%edx
  80163d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801640:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801643:	8b 45 0c             	mov    0xc(%ebp),%eax
  801646:	8b 10                	mov    (%eax),%edx
  801648:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164b:	8b 40 04             	mov    0x4(%eax),%eax
  80164e:	39 c2                	cmp    %eax,%edx
  801650:	73 12                	jae    801664 <sprintputch+0x33>
		*b->buf++ = ch;
  801652:	8b 45 0c             	mov    0xc(%ebp),%eax
  801655:	8b 00                	mov    (%eax),%eax
  801657:	8d 48 01             	lea    0x1(%eax),%ecx
  80165a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165d:	89 0a                	mov    %ecx,(%edx)
  80165f:	8b 55 08             	mov    0x8(%ebp),%edx
  801662:	88 10                	mov    %dl,(%eax)
}
  801664:	90                   	nop
  801665:	5d                   	pop    %ebp
  801666:	c3                   	ret    

00801667 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
  80166a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801673:	8b 45 0c             	mov    0xc(%ebp),%eax
  801676:	8d 50 ff             	lea    -0x1(%eax),%edx
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	01 d0                	add    %edx,%eax
  80167e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801681:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801688:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80168c:	74 06                	je     801694 <vsnprintf+0x2d>
  80168e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801692:	7f 07                	jg     80169b <vsnprintf+0x34>
		return -E_INVAL;
  801694:	b8 03 00 00 00       	mov    $0x3,%eax
  801699:	eb 20                	jmp    8016bb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80169b:	ff 75 14             	pushl  0x14(%ebp)
  80169e:	ff 75 10             	pushl  0x10(%ebp)
  8016a1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8016a4:	50                   	push   %eax
  8016a5:	68 31 16 80 00       	push   $0x801631
  8016aa:	e8 80 fb ff ff       	call   80122f <vprintfmt>
  8016af:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8016b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8016b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8016c3:	8d 45 10             	lea    0x10(%ebp),%eax
  8016c6:	83 c0 04             	add    $0x4,%eax
  8016c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8016cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8016d2:	50                   	push   %eax
  8016d3:	ff 75 0c             	pushl  0xc(%ebp)
  8016d6:	ff 75 08             	pushl  0x8(%ebp)
  8016d9:	e8 89 ff ff ff       	call   801667 <vsnprintf>
  8016de:	83 c4 10             	add    $0x10,%esp
  8016e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8016e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8016ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016f3:	74 13                	je     801708 <readline+0x1f>
		cprintf("%s", prompt);
  8016f5:	83 ec 08             	sub    $0x8,%esp
  8016f8:	ff 75 08             	pushl  0x8(%ebp)
  8016fb:	68 28 4f 80 00       	push   $0x804f28
  801700:	e8 0b f9 ff ff       	call   801010 <cprintf>
  801705:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801708:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80170f:	83 ec 0c             	sub    $0xc,%esp
  801712:	6a 00                	push   $0x0
  801714:	e8 4f f4 ff ff       	call   800b68 <iscons>
  801719:	83 c4 10             	add    $0x10,%esp
  80171c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80171f:	e8 31 f4 ff ff       	call   800b55 <getchar>
  801724:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801727:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80172b:	79 22                	jns    80174f <readline+0x66>
			if (c != -E_EOF)
  80172d:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801731:	0f 84 ad 00 00 00    	je     8017e4 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801737:	83 ec 08             	sub    $0x8,%esp
  80173a:	ff 75 ec             	pushl  -0x14(%ebp)
  80173d:	68 2b 4f 80 00       	push   $0x804f2b
  801742:	e8 c9 f8 ff ff       	call   801010 <cprintf>
  801747:	83 c4 10             	add    $0x10,%esp
			break;
  80174a:	e9 95 00 00 00       	jmp    8017e4 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80174f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801753:	7e 34                	jle    801789 <readline+0xa0>
  801755:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80175c:	7f 2b                	jg     801789 <readline+0xa0>
			if (echoing)
  80175e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801762:	74 0e                	je     801772 <readline+0x89>
				cputchar(c);
  801764:	83 ec 0c             	sub    $0xc,%esp
  801767:	ff 75 ec             	pushl  -0x14(%ebp)
  80176a:	e8 c7 f3 ff ff       	call   800b36 <cputchar>
  80176f:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801775:	8d 50 01             	lea    0x1(%eax),%edx
  801778:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80177b:	89 c2                	mov    %eax,%edx
  80177d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801780:	01 d0                	add    %edx,%eax
  801782:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801785:	88 10                	mov    %dl,(%eax)
  801787:	eb 56                	jmp    8017df <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801789:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80178d:	75 1f                	jne    8017ae <readline+0xc5>
  80178f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801793:	7e 19                	jle    8017ae <readline+0xc5>
			if (echoing)
  801795:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801799:	74 0e                	je     8017a9 <readline+0xc0>
				cputchar(c);
  80179b:	83 ec 0c             	sub    $0xc,%esp
  80179e:	ff 75 ec             	pushl  -0x14(%ebp)
  8017a1:	e8 90 f3 ff ff       	call   800b36 <cputchar>
  8017a6:	83 c4 10             	add    $0x10,%esp

			i--;
  8017a9:	ff 4d f4             	decl   -0xc(%ebp)
  8017ac:	eb 31                	jmp    8017df <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8017ae:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8017b2:	74 0a                	je     8017be <readline+0xd5>
  8017b4:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8017b8:	0f 85 61 ff ff ff    	jne    80171f <readline+0x36>
			if (echoing)
  8017be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017c2:	74 0e                	je     8017d2 <readline+0xe9>
				cputchar(c);
  8017c4:	83 ec 0c             	sub    $0xc,%esp
  8017c7:	ff 75 ec             	pushl  -0x14(%ebp)
  8017ca:	e8 67 f3 ff ff       	call   800b36 <cputchar>
  8017cf:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8017d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d8:	01 d0                	add    %edx,%eax
  8017da:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8017dd:	eb 06                	jmp    8017e5 <readline+0xfc>
		}
	}
  8017df:	e9 3b ff ff ff       	jmp    80171f <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8017e4:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8017e5:	90                   	nop
  8017e6:	c9                   	leave  
  8017e7:	c3                   	ret    

008017e8 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
  8017eb:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8017ee:	e8 81 16 00 00       	call   802e74 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8017f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017f7:	74 13                	je     80180c <atomic_readline+0x24>
			cprintf("%s", prompt);
  8017f9:	83 ec 08             	sub    $0x8,%esp
  8017fc:	ff 75 08             	pushl  0x8(%ebp)
  8017ff:	68 28 4f 80 00       	push   $0x804f28
  801804:	e8 07 f8 ff ff       	call   801010 <cprintf>
  801809:	83 c4 10             	add    $0x10,%esp

		i = 0;
  80180c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  801813:	83 ec 0c             	sub    $0xc,%esp
  801816:	6a 00                	push   $0x0
  801818:	e8 4b f3 ff ff       	call   800b68 <iscons>
  80181d:	83 c4 10             	add    $0x10,%esp
  801820:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801823:	e8 2d f3 ff ff       	call   800b55 <getchar>
  801828:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  80182b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80182f:	79 22                	jns    801853 <atomic_readline+0x6b>
				if (c != -E_EOF)
  801831:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801835:	0f 84 ad 00 00 00    	je     8018e8 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  80183b:	83 ec 08             	sub    $0x8,%esp
  80183e:	ff 75 ec             	pushl  -0x14(%ebp)
  801841:	68 2b 4f 80 00       	push   $0x804f2b
  801846:	e8 c5 f7 ff ff       	call   801010 <cprintf>
  80184b:	83 c4 10             	add    $0x10,%esp
				break;
  80184e:	e9 95 00 00 00       	jmp    8018e8 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801853:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801857:	7e 34                	jle    80188d <atomic_readline+0xa5>
  801859:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801860:	7f 2b                	jg     80188d <atomic_readline+0xa5>
				if (echoing)
  801862:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801866:	74 0e                	je     801876 <atomic_readline+0x8e>
					cputchar(c);
  801868:	83 ec 0c             	sub    $0xc,%esp
  80186b:	ff 75 ec             	pushl  -0x14(%ebp)
  80186e:	e8 c3 f2 ff ff       	call   800b36 <cputchar>
  801873:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801879:	8d 50 01             	lea    0x1(%eax),%edx
  80187c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80187f:	89 c2                	mov    %eax,%edx
  801881:	8b 45 0c             	mov    0xc(%ebp),%eax
  801884:	01 d0                	add    %edx,%eax
  801886:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801889:	88 10                	mov    %dl,(%eax)
  80188b:	eb 56                	jmp    8018e3 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  80188d:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801891:	75 1f                	jne    8018b2 <atomic_readline+0xca>
  801893:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801897:	7e 19                	jle    8018b2 <atomic_readline+0xca>
				if (echoing)
  801899:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80189d:	74 0e                	je     8018ad <atomic_readline+0xc5>
					cputchar(c);
  80189f:	83 ec 0c             	sub    $0xc,%esp
  8018a2:	ff 75 ec             	pushl  -0x14(%ebp)
  8018a5:	e8 8c f2 ff ff       	call   800b36 <cputchar>
  8018aa:	83 c4 10             	add    $0x10,%esp
				i--;
  8018ad:	ff 4d f4             	decl   -0xc(%ebp)
  8018b0:	eb 31                	jmp    8018e3 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  8018b2:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8018b6:	74 0a                	je     8018c2 <atomic_readline+0xda>
  8018b8:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8018bc:	0f 85 61 ff ff ff    	jne    801823 <atomic_readline+0x3b>
				if (echoing)
  8018c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8018c6:	74 0e                	je     8018d6 <atomic_readline+0xee>
					cputchar(c);
  8018c8:	83 ec 0c             	sub    $0xc,%esp
  8018cb:	ff 75 ec             	pushl  -0x14(%ebp)
  8018ce:	e8 63 f2 ff ff       	call   800b36 <cputchar>
  8018d3:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8018d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018dc:	01 d0                	add    %edx,%eax
  8018de:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8018e1:	eb 06                	jmp    8018e9 <atomic_readline+0x101>
			}
		}
  8018e3:	e9 3b ff ff ff       	jmp    801823 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8018e8:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8018e9:	e8 a0 15 00 00       	call   802e8e <sys_unlock_cons>
}
  8018ee:	90                   	nop
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
  8018f4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8018f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018fe:	eb 06                	jmp    801906 <strlen+0x15>
		n++;
  801900:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801903:	ff 45 08             	incl   0x8(%ebp)
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	8a 00                	mov    (%eax),%al
  80190b:	84 c0                	test   %al,%al
  80190d:	75 f1                	jne    801900 <strlen+0xf>
		n++;
	return n;
  80190f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80191a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801921:	eb 09                	jmp    80192c <strnlen+0x18>
		n++;
  801923:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801926:	ff 45 08             	incl   0x8(%ebp)
  801929:	ff 4d 0c             	decl   0xc(%ebp)
  80192c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801930:	74 09                	je     80193b <strnlen+0x27>
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	84 c0                	test   %al,%al
  801939:	75 e8                	jne    801923 <strnlen+0xf>
		n++;
	return n;
  80193b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80194c:	90                   	nop
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	8d 50 01             	lea    0x1(%eax),%edx
  801953:	89 55 08             	mov    %edx,0x8(%ebp)
  801956:	8b 55 0c             	mov    0xc(%ebp),%edx
  801959:	8d 4a 01             	lea    0x1(%edx),%ecx
  80195c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80195f:	8a 12                	mov    (%edx),%dl
  801961:	88 10                	mov    %dl,(%eax)
  801963:	8a 00                	mov    (%eax),%al
  801965:	84 c0                	test   %al,%al
  801967:	75 e4                	jne    80194d <strcpy+0xd>
		/* do nothing */;
	return ret;
  801969:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
  801971:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801974:	8b 45 08             	mov    0x8(%ebp),%eax
  801977:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80197a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801981:	eb 1f                	jmp    8019a2 <strncpy+0x34>
		*dst++ = *src;
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	8d 50 01             	lea    0x1(%eax),%edx
  801989:	89 55 08             	mov    %edx,0x8(%ebp)
  80198c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198f:	8a 12                	mov    (%edx),%dl
  801991:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801993:	8b 45 0c             	mov    0xc(%ebp),%eax
  801996:	8a 00                	mov    (%eax),%al
  801998:	84 c0                	test   %al,%al
  80199a:	74 03                	je     80199f <strncpy+0x31>
			src++;
  80199c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80199f:	ff 45 fc             	incl   -0x4(%ebp)
  8019a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019a5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019a8:	72 d9                	jb     801983 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8019aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
  8019b2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8019bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019bf:	74 30                	je     8019f1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8019c1:	eb 16                	jmp    8019d9 <strlcpy+0x2a>
			*dst++ = *src++;
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	8d 50 01             	lea    0x1(%eax),%edx
  8019c9:	89 55 08             	mov    %edx,0x8(%ebp)
  8019cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8019d2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8019d5:	8a 12                	mov    (%edx),%dl
  8019d7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8019d9:	ff 4d 10             	decl   0x10(%ebp)
  8019dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019e0:	74 09                	je     8019eb <strlcpy+0x3c>
  8019e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e5:	8a 00                	mov    (%eax),%al
  8019e7:	84 c0                	test   %al,%al
  8019e9:	75 d8                	jne    8019c3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ee:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8019f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8019f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019f7:	29 c2                	sub    %eax,%edx
  8019f9:	89 d0                	mov    %edx,%eax
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801a00:	eb 06                	jmp    801a08 <strcmp+0xb>
		p++, q++;
  801a02:	ff 45 08             	incl   0x8(%ebp)
  801a05:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	8a 00                	mov    (%eax),%al
  801a0d:	84 c0                	test   %al,%al
  801a0f:	74 0e                	je     801a1f <strcmp+0x22>
  801a11:	8b 45 08             	mov    0x8(%ebp),%eax
  801a14:	8a 10                	mov    (%eax),%dl
  801a16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a19:	8a 00                	mov    (%eax),%al
  801a1b:	38 c2                	cmp    %al,%dl
  801a1d:	74 e3                	je     801a02 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	8a 00                	mov    (%eax),%al
  801a24:	0f b6 d0             	movzbl %al,%edx
  801a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2a:	8a 00                	mov    (%eax),%al
  801a2c:	0f b6 c0             	movzbl %al,%eax
  801a2f:	29 c2                	sub    %eax,%edx
  801a31:	89 d0                	mov    %edx,%eax
}
  801a33:	5d                   	pop    %ebp
  801a34:	c3                   	ret    

00801a35 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801a38:	eb 09                	jmp    801a43 <strncmp+0xe>
		n--, p++, q++;
  801a3a:	ff 4d 10             	decl   0x10(%ebp)
  801a3d:	ff 45 08             	incl   0x8(%ebp)
  801a40:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801a43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a47:	74 17                	je     801a60 <strncmp+0x2b>
  801a49:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4c:	8a 00                	mov    (%eax),%al
  801a4e:	84 c0                	test   %al,%al
  801a50:	74 0e                	je     801a60 <strncmp+0x2b>
  801a52:	8b 45 08             	mov    0x8(%ebp),%eax
  801a55:	8a 10                	mov    (%eax),%dl
  801a57:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5a:	8a 00                	mov    (%eax),%al
  801a5c:	38 c2                	cmp    %al,%dl
  801a5e:	74 da                	je     801a3a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801a60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a64:	75 07                	jne    801a6d <strncmp+0x38>
		return 0;
  801a66:	b8 00 00 00 00       	mov    $0x0,%eax
  801a6b:	eb 14                	jmp    801a81 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a70:	8a 00                	mov    (%eax),%al
  801a72:	0f b6 d0             	movzbl %al,%edx
  801a75:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a78:	8a 00                	mov    (%eax),%al
  801a7a:	0f b6 c0             	movzbl %al,%eax
  801a7d:	29 c2                	sub    %eax,%edx
  801a7f:	89 d0                	mov    %edx,%eax
}
  801a81:	5d                   	pop    %ebp
  801a82:	c3                   	ret    

00801a83 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	83 ec 04             	sub    $0x4,%esp
  801a89:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a8f:	eb 12                	jmp    801aa3 <strchr+0x20>
		if (*s == c)
  801a91:	8b 45 08             	mov    0x8(%ebp),%eax
  801a94:	8a 00                	mov    (%eax),%al
  801a96:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a99:	75 05                	jne    801aa0 <strchr+0x1d>
			return (char *) s;
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	eb 11                	jmp    801ab1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801aa0:	ff 45 08             	incl   0x8(%ebp)
  801aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa6:	8a 00                	mov    (%eax),%al
  801aa8:	84 c0                	test   %al,%al
  801aaa:	75 e5                	jne    801a91 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801aac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
  801ab6:	83 ec 04             	sub    $0x4,%esp
  801ab9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801abc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801abf:	eb 0d                	jmp    801ace <strfind+0x1b>
		if (*s == c)
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	8a 00                	mov    (%eax),%al
  801ac6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801ac9:	74 0e                	je     801ad9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801acb:	ff 45 08             	incl   0x8(%ebp)
  801ace:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad1:	8a 00                	mov    (%eax),%al
  801ad3:	84 c0                	test   %al,%al
  801ad5:	75 ea                	jne    801ac1 <strfind+0xe>
  801ad7:	eb 01                	jmp    801ada <strfind+0x27>
		if (*s == c)
			break;
  801ad9:	90                   	nop
	return (char *) s;
  801ada:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
  801ae2:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801aeb:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801aef:	76 63                	jbe    801b54 <memset+0x75>
		uint64 data_block = c;
  801af1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af4:	99                   	cltd   
  801af5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801af8:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801afb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801afe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b01:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801b05:	c1 e0 08             	shl    $0x8,%eax
  801b08:	09 45 f0             	or     %eax,-0x10(%ebp)
  801b0b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b14:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801b18:	c1 e0 10             	shl    $0x10,%eax
  801b1b:	09 45 f0             	or     %eax,-0x10(%ebp)
  801b1e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b27:	89 c2                	mov    %eax,%edx
  801b29:	b8 00 00 00 00       	mov    $0x0,%eax
  801b2e:	09 45 f0             	or     %eax,-0x10(%ebp)
  801b31:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801b34:	eb 18                	jmp    801b4e <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801b36:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b39:	8d 41 08             	lea    0x8(%ecx),%eax
  801b3c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b45:	89 01                	mov    %eax,(%ecx)
  801b47:	89 51 04             	mov    %edx,0x4(%ecx)
  801b4a:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801b4e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801b52:	77 e2                	ja     801b36 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801b54:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b58:	74 23                	je     801b7d <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801b5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801b60:	eb 0e                	jmp    801b70 <memset+0x91>
			*p8++ = (uint8)c;
  801b62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b65:	8d 50 01             	lea    0x1(%eax),%edx
  801b68:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6e:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801b70:	8b 45 10             	mov    0x10(%ebp),%eax
  801b73:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b76:	89 55 10             	mov    %edx,0x10(%ebp)
  801b79:	85 c0                	test   %eax,%eax
  801b7b:	75 e5                	jne    801b62 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801b7d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
  801b85:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b91:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801b94:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801b98:	76 24                	jbe    801bbe <memcpy+0x3c>
		while(n >= 8){
  801b9a:	eb 1c                	jmp    801bb8 <memcpy+0x36>
			*d64 = *s64;
  801b9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b9f:	8b 50 04             	mov    0x4(%eax),%edx
  801ba2:	8b 00                	mov    (%eax),%eax
  801ba4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801ba7:	89 01                	mov    %eax,(%ecx)
  801ba9:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801bac:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801bb0:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801bb4:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801bb8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801bbc:	77 de                	ja     801b9c <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801bbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bc2:	74 31                	je     801bf5 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801bc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801bca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801bd0:	eb 16                	jmp    801be8 <memcpy+0x66>
			*d8++ = *s8++;
  801bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd5:	8d 50 01             	lea    0x1(%eax),%edx
  801bd8:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801bdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bde:	8d 4a 01             	lea    0x1(%edx),%ecx
  801be1:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801be4:	8a 12                	mov    (%edx),%dl
  801be6:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801be8:	8b 45 10             	mov    0x10(%ebp),%eax
  801beb:	8d 50 ff             	lea    -0x1(%eax),%edx
  801bee:	89 55 10             	mov    %edx,0x10(%ebp)
  801bf1:	85 c0                	test   %eax,%eax
  801bf3:	75 dd                	jne    801bd2 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801bf5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
  801bfd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801c00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801c06:	8b 45 08             	mov    0x8(%ebp),%eax
  801c09:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801c0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c0f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801c12:	73 50                	jae    801c64 <memmove+0x6a>
  801c14:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c17:	8b 45 10             	mov    0x10(%ebp),%eax
  801c1a:	01 d0                	add    %edx,%eax
  801c1c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801c1f:	76 43                	jbe    801c64 <memmove+0x6a>
		s += n;
  801c21:	8b 45 10             	mov    0x10(%ebp),%eax
  801c24:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801c27:	8b 45 10             	mov    0x10(%ebp),%eax
  801c2a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801c2d:	eb 10                	jmp    801c3f <memmove+0x45>
			*--d = *--s;
  801c2f:	ff 4d f8             	decl   -0x8(%ebp)
  801c32:	ff 4d fc             	decl   -0x4(%ebp)
  801c35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c38:	8a 10                	mov    (%eax),%dl
  801c3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c3d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801c3f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c42:	8d 50 ff             	lea    -0x1(%eax),%edx
  801c45:	89 55 10             	mov    %edx,0x10(%ebp)
  801c48:	85 c0                	test   %eax,%eax
  801c4a:	75 e3                	jne    801c2f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801c4c:	eb 23                	jmp    801c71 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801c4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c51:	8d 50 01             	lea    0x1(%eax),%edx
  801c54:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801c57:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c5a:	8d 4a 01             	lea    0x1(%edx),%ecx
  801c5d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801c60:	8a 12                	mov    (%edx),%dl
  801c62:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801c64:	8b 45 10             	mov    0x10(%ebp),%eax
  801c67:	8d 50 ff             	lea    -0x1(%eax),%edx
  801c6a:	89 55 10             	mov    %edx,0x10(%ebp)
  801c6d:	85 c0                	test   %eax,%eax
  801c6f:	75 dd                	jne    801c4e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801c71:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801c82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c85:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801c88:	eb 2a                	jmp    801cb4 <memcmp+0x3e>
		if (*s1 != *s2)
  801c8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c8d:	8a 10                	mov    (%eax),%dl
  801c8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c92:	8a 00                	mov    (%eax),%al
  801c94:	38 c2                	cmp    %al,%dl
  801c96:	74 16                	je     801cae <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801c98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c9b:	8a 00                	mov    (%eax),%al
  801c9d:	0f b6 d0             	movzbl %al,%edx
  801ca0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ca3:	8a 00                	mov    (%eax),%al
  801ca5:	0f b6 c0             	movzbl %al,%eax
  801ca8:	29 c2                	sub    %eax,%edx
  801caa:	89 d0                	mov    %edx,%eax
  801cac:	eb 18                	jmp    801cc6 <memcmp+0x50>
		s1++, s2++;
  801cae:	ff 45 fc             	incl   -0x4(%ebp)
  801cb1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801cb4:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb7:	8d 50 ff             	lea    -0x1(%eax),%edx
  801cba:	89 55 10             	mov    %edx,0x10(%ebp)
  801cbd:	85 c0                	test   %eax,%eax
  801cbf:	75 c9                	jne    801c8a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801cc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    

00801cc8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
  801ccb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801cce:	8b 55 08             	mov    0x8(%ebp),%edx
  801cd1:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd4:	01 d0                	add    %edx,%eax
  801cd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801cd9:	eb 15                	jmp    801cf0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cde:	8a 00                	mov    (%eax),%al
  801ce0:	0f b6 d0             	movzbl %al,%edx
  801ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce6:	0f b6 c0             	movzbl %al,%eax
  801ce9:	39 c2                	cmp    %eax,%edx
  801ceb:	74 0d                	je     801cfa <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801ced:	ff 45 08             	incl   0x8(%ebp)
  801cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801cf6:	72 e3                	jb     801cdb <memfind+0x13>
  801cf8:	eb 01                	jmp    801cfb <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801cfa:	90                   	nop
	return (void *) s;
  801cfb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    

00801d00 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
  801d03:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801d06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801d0d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801d14:	eb 03                	jmp    801d19 <strtol+0x19>
		s++;
  801d16:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801d19:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1c:	8a 00                	mov    (%eax),%al
  801d1e:	3c 20                	cmp    $0x20,%al
  801d20:	74 f4                	je     801d16 <strtol+0x16>
  801d22:	8b 45 08             	mov    0x8(%ebp),%eax
  801d25:	8a 00                	mov    (%eax),%al
  801d27:	3c 09                	cmp    $0x9,%al
  801d29:	74 eb                	je     801d16 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	8a 00                	mov    (%eax),%al
  801d30:	3c 2b                	cmp    $0x2b,%al
  801d32:	75 05                	jne    801d39 <strtol+0x39>
		s++;
  801d34:	ff 45 08             	incl   0x8(%ebp)
  801d37:	eb 13                	jmp    801d4c <strtol+0x4c>
	else if (*s == '-')
  801d39:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3c:	8a 00                	mov    (%eax),%al
  801d3e:	3c 2d                	cmp    $0x2d,%al
  801d40:	75 0a                	jne    801d4c <strtol+0x4c>
		s++, neg = 1;
  801d42:	ff 45 08             	incl   0x8(%ebp)
  801d45:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801d4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d50:	74 06                	je     801d58 <strtol+0x58>
  801d52:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801d56:	75 20                	jne    801d78 <strtol+0x78>
  801d58:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5b:	8a 00                	mov    (%eax),%al
  801d5d:	3c 30                	cmp    $0x30,%al
  801d5f:	75 17                	jne    801d78 <strtol+0x78>
  801d61:	8b 45 08             	mov    0x8(%ebp),%eax
  801d64:	40                   	inc    %eax
  801d65:	8a 00                	mov    (%eax),%al
  801d67:	3c 78                	cmp    $0x78,%al
  801d69:	75 0d                	jne    801d78 <strtol+0x78>
		s += 2, base = 16;
  801d6b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801d6f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801d76:	eb 28                	jmp    801da0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801d78:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d7c:	75 15                	jne    801d93 <strtol+0x93>
  801d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d81:	8a 00                	mov    (%eax),%al
  801d83:	3c 30                	cmp    $0x30,%al
  801d85:	75 0c                	jne    801d93 <strtol+0x93>
		s++, base = 8;
  801d87:	ff 45 08             	incl   0x8(%ebp)
  801d8a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801d91:	eb 0d                	jmp    801da0 <strtol+0xa0>
	else if (base == 0)
  801d93:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d97:	75 07                	jne    801da0 <strtol+0xa0>
		base = 10;
  801d99:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	8a 00                	mov    (%eax),%al
  801da5:	3c 2f                	cmp    $0x2f,%al
  801da7:	7e 19                	jle    801dc2 <strtol+0xc2>
  801da9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dac:	8a 00                	mov    (%eax),%al
  801dae:	3c 39                	cmp    $0x39,%al
  801db0:	7f 10                	jg     801dc2 <strtol+0xc2>
			dig = *s - '0';
  801db2:	8b 45 08             	mov    0x8(%ebp),%eax
  801db5:	8a 00                	mov    (%eax),%al
  801db7:	0f be c0             	movsbl %al,%eax
  801dba:	83 e8 30             	sub    $0x30,%eax
  801dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dc0:	eb 42                	jmp    801e04 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc5:	8a 00                	mov    (%eax),%al
  801dc7:	3c 60                	cmp    $0x60,%al
  801dc9:	7e 19                	jle    801de4 <strtol+0xe4>
  801dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dce:	8a 00                	mov    (%eax),%al
  801dd0:	3c 7a                	cmp    $0x7a,%al
  801dd2:	7f 10                	jg     801de4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd7:	8a 00                	mov    (%eax),%al
  801dd9:	0f be c0             	movsbl %al,%eax
  801ddc:	83 e8 57             	sub    $0x57,%eax
  801ddf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801de2:	eb 20                	jmp    801e04 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801de4:	8b 45 08             	mov    0x8(%ebp),%eax
  801de7:	8a 00                	mov    (%eax),%al
  801de9:	3c 40                	cmp    $0x40,%al
  801deb:	7e 39                	jle    801e26 <strtol+0x126>
  801ded:	8b 45 08             	mov    0x8(%ebp),%eax
  801df0:	8a 00                	mov    (%eax),%al
  801df2:	3c 5a                	cmp    $0x5a,%al
  801df4:	7f 30                	jg     801e26 <strtol+0x126>
			dig = *s - 'A' + 10;
  801df6:	8b 45 08             	mov    0x8(%ebp),%eax
  801df9:	8a 00                	mov    (%eax),%al
  801dfb:	0f be c0             	movsbl %al,%eax
  801dfe:	83 e8 37             	sub    $0x37,%eax
  801e01:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e07:	3b 45 10             	cmp    0x10(%ebp),%eax
  801e0a:	7d 19                	jge    801e25 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801e0c:	ff 45 08             	incl   0x8(%ebp)
  801e0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e12:	0f af 45 10          	imul   0x10(%ebp),%eax
  801e16:	89 c2                	mov    %eax,%edx
  801e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1b:	01 d0                	add    %edx,%eax
  801e1d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801e20:	e9 7b ff ff ff       	jmp    801da0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801e25:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801e26:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e2a:	74 08                	je     801e34 <strtol+0x134>
		*endptr = (char *) s;
  801e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2f:	8b 55 08             	mov    0x8(%ebp),%edx
  801e32:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801e34:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801e38:	74 07                	je     801e41 <strtol+0x141>
  801e3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e3d:	f7 d8                	neg    %eax
  801e3f:	eb 03                	jmp    801e44 <strtol+0x144>
  801e41:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801e44:	c9                   	leave  
  801e45:	c3                   	ret    

00801e46 <ltostr>:

void
ltostr(long value, char *str)
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801e4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801e53:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801e5a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e5e:	79 13                	jns    801e73 <ltostr+0x2d>
	{
		neg = 1;
  801e60:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801e67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e6a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801e6d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801e70:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801e73:	8b 45 08             	mov    0x8(%ebp),%eax
  801e76:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801e7b:	99                   	cltd   
  801e7c:	f7 f9                	idiv   %ecx
  801e7e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801e81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e84:	8d 50 01             	lea    0x1(%eax),%edx
  801e87:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801e8a:	89 c2                	mov    %eax,%edx
  801e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8f:	01 d0                	add    %edx,%eax
  801e91:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e94:	83 c2 30             	add    $0x30,%edx
  801e97:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801e99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e9c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ea1:	f7 e9                	imul   %ecx
  801ea3:	c1 fa 02             	sar    $0x2,%edx
  801ea6:	89 c8                	mov    %ecx,%eax
  801ea8:	c1 f8 1f             	sar    $0x1f,%eax
  801eab:	29 c2                	sub    %eax,%edx
  801ead:	89 d0                	mov    %edx,%eax
  801eaf:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801eb2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801eb6:	75 bb                	jne    801e73 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801eb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801ebf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ec2:	48                   	dec    %eax
  801ec3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801ec6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801eca:	74 3d                	je     801f09 <ltostr+0xc3>
		start = 1 ;
  801ecc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801ed3:	eb 34                	jmp    801f09 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801ed5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801edb:	01 d0                	add    %edx,%eax
  801edd:	8a 00                	mov    (%eax),%al
  801edf:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801ee2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee8:	01 c2                	add    %eax,%edx
  801eea:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801eed:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef0:	01 c8                	add    %ecx,%eax
  801ef2:	8a 00                	mov    (%eax),%al
  801ef4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801ef6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ef9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801efc:	01 c2                	add    %eax,%edx
  801efe:	8a 45 eb             	mov    -0x15(%ebp),%al
  801f01:	88 02                	mov    %al,(%edx)
		start++ ;
  801f03:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801f06:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801f0f:	7c c4                	jl     801ed5 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801f11:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801f14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f17:	01 d0                	add    %edx,%eax
  801f19:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801f1c:	90                   	nop
  801f1d:	c9                   	leave  
  801f1e:	c3                   	ret    

00801f1f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
  801f22:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801f25:	ff 75 08             	pushl  0x8(%ebp)
  801f28:	e8 c4 f9 ff ff       	call   8018f1 <strlen>
  801f2d:	83 c4 04             	add    $0x4,%esp
  801f30:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801f33:	ff 75 0c             	pushl  0xc(%ebp)
  801f36:	e8 b6 f9 ff ff       	call   8018f1 <strlen>
  801f3b:	83 c4 04             	add    $0x4,%esp
  801f3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801f41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801f48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f4f:	eb 17                	jmp    801f68 <strcconcat+0x49>
		final[s] = str1[s] ;
  801f51:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f54:	8b 45 10             	mov    0x10(%ebp),%eax
  801f57:	01 c2                	add    %eax,%edx
  801f59:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5f:	01 c8                	add    %ecx,%eax
  801f61:	8a 00                	mov    (%eax),%al
  801f63:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801f65:	ff 45 fc             	incl   -0x4(%ebp)
  801f68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f6b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801f6e:	7c e1                	jl     801f51 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801f70:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801f77:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801f7e:	eb 1f                	jmp    801f9f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801f80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f83:	8d 50 01             	lea    0x1(%eax),%edx
  801f86:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801f89:	89 c2                	mov    %eax,%edx
  801f8b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f8e:	01 c2                	add    %eax,%edx
  801f90:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801f93:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f96:	01 c8                	add    %ecx,%eax
  801f98:	8a 00                	mov    (%eax),%al
  801f9a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801f9c:	ff 45 f8             	incl   -0x8(%ebp)
  801f9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fa2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801fa5:	7c d9                	jl     801f80 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801fa7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801faa:	8b 45 10             	mov    0x10(%ebp),%eax
  801fad:	01 d0                	add    %edx,%eax
  801faf:	c6 00 00             	movb   $0x0,(%eax)
}
  801fb2:	90                   	nop
  801fb3:	c9                   	leave  
  801fb4:	c3                   	ret    

00801fb5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801fb8:	8b 45 14             	mov    0x14(%ebp),%eax
  801fbb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801fc1:	8b 45 14             	mov    0x14(%ebp),%eax
  801fc4:	8b 00                	mov    (%eax),%eax
  801fc6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801fcd:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd0:	01 d0                	add    %edx,%eax
  801fd2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801fd8:	eb 0c                	jmp    801fe6 <strsplit+0x31>
			*string++ = 0;
  801fda:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdd:	8d 50 01             	lea    0x1(%eax),%edx
  801fe0:	89 55 08             	mov    %edx,0x8(%ebp)
  801fe3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe9:	8a 00                	mov    (%eax),%al
  801feb:	84 c0                	test   %al,%al
  801fed:	74 18                	je     802007 <strsplit+0x52>
  801fef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff2:	8a 00                	mov    (%eax),%al
  801ff4:	0f be c0             	movsbl %al,%eax
  801ff7:	50                   	push   %eax
  801ff8:	ff 75 0c             	pushl  0xc(%ebp)
  801ffb:	e8 83 fa ff ff       	call   801a83 <strchr>
  802000:	83 c4 08             	add    $0x8,%esp
  802003:	85 c0                	test   %eax,%eax
  802005:	75 d3                	jne    801fda <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802007:	8b 45 08             	mov    0x8(%ebp),%eax
  80200a:	8a 00                	mov    (%eax),%al
  80200c:	84 c0                	test   %al,%al
  80200e:	74 5a                	je     80206a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802010:	8b 45 14             	mov    0x14(%ebp),%eax
  802013:	8b 00                	mov    (%eax),%eax
  802015:	83 f8 0f             	cmp    $0xf,%eax
  802018:	75 07                	jne    802021 <strsplit+0x6c>
		{
			return 0;
  80201a:	b8 00 00 00 00       	mov    $0x0,%eax
  80201f:	eb 66                	jmp    802087 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802021:	8b 45 14             	mov    0x14(%ebp),%eax
  802024:	8b 00                	mov    (%eax),%eax
  802026:	8d 48 01             	lea    0x1(%eax),%ecx
  802029:	8b 55 14             	mov    0x14(%ebp),%edx
  80202c:	89 0a                	mov    %ecx,(%edx)
  80202e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802035:	8b 45 10             	mov    0x10(%ebp),%eax
  802038:	01 c2                	add    %eax,%edx
  80203a:	8b 45 08             	mov    0x8(%ebp),%eax
  80203d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80203f:	eb 03                	jmp    802044 <strsplit+0x8f>
			string++;
  802041:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	8a 00                	mov    (%eax),%al
  802049:	84 c0                	test   %al,%al
  80204b:	74 8b                	je     801fd8 <strsplit+0x23>
  80204d:	8b 45 08             	mov    0x8(%ebp),%eax
  802050:	8a 00                	mov    (%eax),%al
  802052:	0f be c0             	movsbl %al,%eax
  802055:	50                   	push   %eax
  802056:	ff 75 0c             	pushl  0xc(%ebp)
  802059:	e8 25 fa ff ff       	call   801a83 <strchr>
  80205e:	83 c4 08             	add    $0x8,%esp
  802061:	85 c0                	test   %eax,%eax
  802063:	74 dc                	je     802041 <strsplit+0x8c>
			string++;
	}
  802065:	e9 6e ff ff ff       	jmp    801fd8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80206a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80206b:	8b 45 14             	mov    0x14(%ebp),%eax
  80206e:	8b 00                	mov    (%eax),%eax
  802070:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802077:	8b 45 10             	mov    0x10(%ebp),%eax
  80207a:	01 d0                	add    %edx,%eax
  80207c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802082:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802087:	c9                   	leave  
  802088:	c3                   	ret    

00802089 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
  80208c:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80208f:	8b 45 08             	mov    0x8(%ebp),%eax
  802092:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  802095:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80209c:	eb 4a                	jmp    8020e8 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80209e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a4:	01 c2                	add    %eax,%edx
  8020a6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8020a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ac:	01 c8                	add    %ecx,%eax
  8020ae:	8a 00                	mov    (%eax),%al
  8020b0:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8020b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b8:	01 d0                	add    %edx,%eax
  8020ba:	8a 00                	mov    (%eax),%al
  8020bc:	3c 40                	cmp    $0x40,%al
  8020be:	7e 25                	jle    8020e5 <str2lower+0x5c>
  8020c0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c6:	01 d0                	add    %edx,%eax
  8020c8:	8a 00                	mov    (%eax),%al
  8020ca:	3c 5a                	cmp    $0x5a,%al
  8020cc:	7f 17                	jg     8020e5 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8020ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d4:	01 d0                	add    %edx,%eax
  8020d6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8020d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8020dc:	01 ca                	add    %ecx,%edx
  8020de:	8a 12                	mov    (%edx),%dl
  8020e0:	83 c2 20             	add    $0x20,%edx
  8020e3:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8020e5:	ff 45 fc             	incl   -0x4(%ebp)
  8020e8:	ff 75 0c             	pushl  0xc(%ebp)
  8020eb:	e8 01 f8 ff ff       	call   8018f1 <strlen>
  8020f0:	83 c4 04             	add    $0x4,%esp
  8020f3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8020f6:	7f a6                	jg     80209e <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8020f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8020fb:	c9                   	leave  
  8020fc:	c3                   	ret    

008020fd <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
  802100:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  802103:	83 ec 0c             	sub    $0xc,%esp
  802106:	6a 10                	push   $0x10
  802108:	e8 b2 15 00 00       	call   8036bf <alloc_block>
  80210d:	83 c4 10             	add    $0x10,%esp
  802110:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  802113:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802117:	75 14                	jne    80212d <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  802119:	83 ec 04             	sub    $0x4,%esp
  80211c:	68 3c 4f 80 00       	push   $0x804f3c
  802121:	6a 14                	push   $0x14
  802123:	68 65 4f 80 00       	push   $0x804f65
  802128:	e8 f5 eb ff ff       	call   800d22 <_panic>

	node->start = start;
  80212d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802130:	8b 55 08             	mov    0x8(%ebp),%edx
  802133:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  802135:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802138:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213b:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  80213e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  802145:	a1 24 60 80 00       	mov    0x806024,%eax
  80214a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80214d:	eb 18                	jmp    802167 <insert_page_alloc+0x6a>
		if (start < it->start)
  80214f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802152:	8b 00                	mov    (%eax),%eax
  802154:	3b 45 08             	cmp    0x8(%ebp),%eax
  802157:	77 37                	ja     802190 <insert_page_alloc+0x93>
			break;
		prev = it;
  802159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215c:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  80215f:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802164:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802167:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80216b:	74 08                	je     802175 <insert_page_alloc+0x78>
  80216d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802170:	8b 40 08             	mov    0x8(%eax),%eax
  802173:	eb 05                	jmp    80217a <insert_page_alloc+0x7d>
  802175:	b8 00 00 00 00       	mov    $0x0,%eax
  80217a:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80217f:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802184:	85 c0                	test   %eax,%eax
  802186:	75 c7                	jne    80214f <insert_page_alloc+0x52>
  802188:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80218c:	75 c1                	jne    80214f <insert_page_alloc+0x52>
  80218e:	eb 01                	jmp    802191 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  802190:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  802191:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802195:	75 64                	jne    8021fb <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  802197:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80219b:	75 14                	jne    8021b1 <insert_page_alloc+0xb4>
  80219d:	83 ec 04             	sub    $0x4,%esp
  8021a0:	68 74 4f 80 00       	push   $0x804f74
  8021a5:	6a 21                	push   $0x21
  8021a7:	68 65 4f 80 00       	push   $0x804f65
  8021ac:	e8 71 eb ff ff       	call   800d22 <_panic>
  8021b1:	8b 15 24 60 80 00    	mov    0x806024,%edx
  8021b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ba:	89 50 08             	mov    %edx,0x8(%eax)
  8021bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c0:	8b 40 08             	mov    0x8(%eax),%eax
  8021c3:	85 c0                	test   %eax,%eax
  8021c5:	74 0d                	je     8021d4 <insert_page_alloc+0xd7>
  8021c7:	a1 24 60 80 00       	mov    0x806024,%eax
  8021cc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021cf:	89 50 0c             	mov    %edx,0xc(%eax)
  8021d2:	eb 08                	jmp    8021dc <insert_page_alloc+0xdf>
  8021d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d7:	a3 28 60 80 00       	mov    %eax,0x806028
  8021dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021df:	a3 24 60 80 00       	mov    %eax,0x806024
  8021e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8021ee:	a1 30 60 80 00       	mov    0x806030,%eax
  8021f3:	40                   	inc    %eax
  8021f4:	a3 30 60 80 00       	mov    %eax,0x806030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  8021f9:	eb 71                	jmp    80226c <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  8021fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021ff:	74 06                	je     802207 <insert_page_alloc+0x10a>
  802201:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802205:	75 14                	jne    80221b <insert_page_alloc+0x11e>
  802207:	83 ec 04             	sub    $0x4,%esp
  80220a:	68 98 4f 80 00       	push   $0x804f98
  80220f:	6a 23                	push   $0x23
  802211:	68 65 4f 80 00       	push   $0x804f65
  802216:	e8 07 eb ff ff       	call   800d22 <_panic>
  80221b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221e:	8b 50 08             	mov    0x8(%eax),%edx
  802221:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802224:	89 50 08             	mov    %edx,0x8(%eax)
  802227:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222a:	8b 40 08             	mov    0x8(%eax),%eax
  80222d:	85 c0                	test   %eax,%eax
  80222f:	74 0c                	je     80223d <insert_page_alloc+0x140>
  802231:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802234:	8b 40 08             	mov    0x8(%eax),%eax
  802237:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80223a:	89 50 0c             	mov    %edx,0xc(%eax)
  80223d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802240:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802243:	89 50 08             	mov    %edx,0x8(%eax)
  802246:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802249:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80224c:	89 50 0c             	mov    %edx,0xc(%eax)
  80224f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802252:	8b 40 08             	mov    0x8(%eax),%eax
  802255:	85 c0                	test   %eax,%eax
  802257:	75 08                	jne    802261 <insert_page_alloc+0x164>
  802259:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80225c:	a3 28 60 80 00       	mov    %eax,0x806028
  802261:	a1 30 60 80 00       	mov    0x806030,%eax
  802266:	40                   	inc    %eax
  802267:	a3 30 60 80 00       	mov    %eax,0x806030
}
  80226c:	90                   	nop
  80226d:	c9                   	leave  
  80226e:	c3                   	ret    

0080226f <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
  802272:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  802275:	a1 24 60 80 00       	mov    0x806024,%eax
  80227a:	85 c0                	test   %eax,%eax
  80227c:	75 0c                	jne    80228a <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  80227e:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802283:	a3 68 e0 81 00       	mov    %eax,0x81e068
		return;
  802288:	eb 67                	jmp    8022f1 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  80228a:	a1 10 e1 81 00       	mov    0x81e110,%eax
  80228f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802292:	a1 24 60 80 00       	mov    0x806024,%eax
  802297:	89 45 f8             	mov    %eax,-0x8(%ebp)
  80229a:	eb 26                	jmp    8022c2 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  80229c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80229f:	8b 10                	mov    (%eax),%edx
  8022a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022a4:	8b 40 04             	mov    0x4(%eax),%eax
  8022a7:	01 d0                	add    %edx,%eax
  8022a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  8022ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022af:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8022b2:	76 06                	jbe    8022ba <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8022ba:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8022bf:	89 45 f8             	mov    %eax,-0x8(%ebp)
  8022c2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8022c6:	74 08                	je     8022d0 <recompute_page_alloc_break+0x61>
  8022c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022cb:	8b 40 08             	mov    0x8(%eax),%eax
  8022ce:	eb 05                	jmp    8022d5 <recompute_page_alloc_break+0x66>
  8022d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d5:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8022da:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8022df:	85 c0                	test   %eax,%eax
  8022e1:	75 b9                	jne    80229c <recompute_page_alloc_break+0x2d>
  8022e3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8022e7:	75 b3                	jne    80229c <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  8022e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022ec:	a3 68 e0 81 00       	mov    %eax,0x81e068
}
  8022f1:	c9                   	leave  
  8022f2:	c3                   	ret    

008022f3 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
  8022f6:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  8022f9:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802300:	8b 55 08             	mov    0x8(%ebp),%edx
  802303:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802306:	01 d0                	add    %edx,%eax
  802308:	48                   	dec    %eax
  802309:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80230c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80230f:	ba 00 00 00 00       	mov    $0x0,%edx
  802314:	f7 75 d8             	divl   -0x28(%ebp)
  802317:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80231a:	29 d0                	sub    %edx,%eax
  80231c:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  80231f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802323:	75 0a                	jne    80232f <alloc_pages_custom_fit+0x3c>
		return NULL;
  802325:	b8 00 00 00 00       	mov    $0x0,%eax
  80232a:	e9 7e 01 00 00       	jmp    8024ad <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  80232f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  802336:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  80233a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  802341:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  802348:	a1 10 e1 81 00       	mov    0x81e110,%eax
  80234d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  802350:	a1 24 60 80 00       	mov    0x806024,%eax
  802355:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802358:	eb 69                	jmp    8023c3 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  80235a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80235d:	8b 00                	mov    (%eax),%eax
  80235f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802362:	76 47                	jbe    8023ab <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  802364:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802367:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  80236a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80236d:	8b 00                	mov    (%eax),%eax
  80236f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802372:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  802375:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802378:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80237b:	72 2e                	jb     8023ab <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  80237d:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  802381:	75 14                	jne    802397 <alloc_pages_custom_fit+0xa4>
  802383:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802386:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802389:	75 0c                	jne    802397 <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  80238b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80238e:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  802391:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  802395:	eb 14                	jmp    8023ab <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  802397:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80239a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80239d:	76 0c                	jbe    8023ab <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  80239f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8023a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  8023a5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8023a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  8023ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023ae:	8b 10                	mov    (%eax),%edx
  8023b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023b3:	8b 40 04             	mov    0x4(%eax),%eax
  8023b6:	01 d0                	add    %edx,%eax
  8023b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  8023bb:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8023c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8023c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8023c7:	74 08                	je     8023d1 <alloc_pages_custom_fit+0xde>
  8023c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023cc:	8b 40 08             	mov    0x8(%eax),%eax
  8023cf:	eb 05                	jmp    8023d6 <alloc_pages_custom_fit+0xe3>
  8023d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d6:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8023db:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8023e0:	85 c0                	test   %eax,%eax
  8023e2:	0f 85 72 ff ff ff    	jne    80235a <alloc_pages_custom_fit+0x67>
  8023e8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8023ec:	0f 85 68 ff ff ff    	jne    80235a <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  8023f2:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8023f7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8023fa:	76 47                	jbe    802443 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  8023fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023ff:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  802402:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802407:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80240a:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  80240d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802410:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802413:	72 2e                	jb     802443 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  802415:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  802419:	75 14                	jne    80242f <alloc_pages_custom_fit+0x13c>
  80241b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80241e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802421:	75 0c                	jne    80242f <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  802423:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802426:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  802429:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  80242d:	eb 14                	jmp    802443 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  80242f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802432:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802435:	76 0c                	jbe    802443 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  802437:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80243a:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  80243d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802440:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  802443:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  80244a:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  80244e:	74 08                	je     802458 <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  802450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802453:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802456:	eb 40                	jmp    802498 <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  802458:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80245c:	74 08                	je     802466 <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  80245e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802461:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802464:	eb 32                	jmp    802498 <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  802466:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80246b:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80246e:	89 c2                	mov    %eax,%edx
  802470:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802475:	39 c2                	cmp    %eax,%edx
  802477:	73 07                	jae    802480 <alloc_pages_custom_fit+0x18d>
			return NULL;
  802479:	b8 00 00 00 00       	mov    $0x0,%eax
  80247e:	eb 2d                	jmp    8024ad <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  802480:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802485:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  802488:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  80248e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802491:	01 d0                	add    %edx,%eax
  802493:	a3 68 e0 81 00       	mov    %eax,0x81e068
	}


	insert_page_alloc((uint32)result, required_size);
  802498:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80249b:	83 ec 08             	sub    $0x8,%esp
  80249e:	ff 75 d0             	pushl  -0x30(%ebp)
  8024a1:	50                   	push   %eax
  8024a2:	e8 56 fc ff ff       	call   8020fd <insert_page_alloc>
  8024a7:	83 c4 10             	add    $0x10,%esp

	return result;
  8024aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  8024ad:	c9                   	leave  
  8024ae:	c3                   	ret    

008024af <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  8024af:	55                   	push   %ebp
  8024b0:	89 e5                	mov    %esp,%ebp
  8024b2:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  8024b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8024bb:	a1 24 60 80 00       	mov    0x806024,%eax
  8024c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8024c3:	eb 1a                	jmp    8024df <find_allocated_size+0x30>
		if (it->start == va)
  8024c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024c8:	8b 00                	mov    (%eax),%eax
  8024ca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8024cd:	75 08                	jne    8024d7 <find_allocated_size+0x28>
			return it->size;
  8024cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024d2:	8b 40 04             	mov    0x4(%eax),%eax
  8024d5:	eb 34                	jmp    80250b <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8024d7:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8024dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8024df:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8024e3:	74 08                	je     8024ed <find_allocated_size+0x3e>
  8024e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024e8:	8b 40 08             	mov    0x8(%eax),%eax
  8024eb:	eb 05                	jmp    8024f2 <find_allocated_size+0x43>
  8024ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f2:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8024f7:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8024fc:	85 c0                	test   %eax,%eax
  8024fe:	75 c5                	jne    8024c5 <find_allocated_size+0x16>
  802500:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802504:	75 bf                	jne    8024c5 <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  802506:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80250b:	c9                   	leave  
  80250c:	c3                   	ret    

0080250d <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  80250d:	55                   	push   %ebp
  80250e:	89 e5                	mov    %esp,%ebp
  802510:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  802513:	8b 45 08             	mov    0x8(%ebp),%eax
  802516:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  802519:	a1 24 60 80 00       	mov    0x806024,%eax
  80251e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802521:	e9 e1 01 00 00       	jmp    802707 <free_pages+0x1fa>
		if (it->start == va) {
  802526:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802529:	8b 00                	mov    (%eax),%eax
  80252b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80252e:	0f 85 cb 01 00 00    	jne    8026ff <free_pages+0x1f2>

			uint32 start = it->start;
  802534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802537:	8b 00                	mov    (%eax),%eax
  802539:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 40 04             	mov    0x4(%eax),%eax
  802542:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  802545:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802548:	f7 d0                	not    %eax
  80254a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80254d:	73 1d                	jae    80256c <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  80254f:	83 ec 0c             	sub    $0xc,%esp
  802552:	ff 75 e4             	pushl  -0x1c(%ebp)
  802555:	ff 75 e8             	pushl  -0x18(%ebp)
  802558:	68 cc 4f 80 00       	push   $0x804fcc
  80255d:	68 a5 00 00 00       	push   $0xa5
  802562:	68 65 4f 80 00       	push   $0x804f65
  802567:	e8 b6 e7 ff ff       	call   800d22 <_panic>
			}

			uint32 start_end = start + size;
  80256c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80256f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802572:	01 d0                	add    %edx,%eax
  802574:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  802577:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80257a:	85 c0                	test   %eax,%eax
  80257c:	79 19                	jns    802597 <free_pages+0x8a>
  80257e:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  802585:	77 10                	ja     802597 <free_pages+0x8a>
  802587:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  80258e:	77 07                	ja     802597 <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  802590:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802593:	85 c0                	test   %eax,%eax
  802595:	78 2c                	js     8025c3 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  802597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80259a:	83 ec 0c             	sub    $0xc,%esp
  80259d:	68 00 00 00 a0       	push   $0xa0000000
  8025a2:	ff 75 e0             	pushl  -0x20(%ebp)
  8025a5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8025a8:	ff 75 e8             	pushl  -0x18(%ebp)
  8025ab:	ff 75 e4             	pushl  -0x1c(%ebp)
  8025ae:	50                   	push   %eax
  8025af:	68 10 50 80 00       	push   $0x805010
  8025b4:	68 ad 00 00 00       	push   $0xad
  8025b9:	68 65 4f 80 00       	push   $0x804f65
  8025be:	e8 5f e7 ff ff       	call   800d22 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  8025c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8025c9:	e9 88 00 00 00       	jmp    802656 <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  8025ce:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  8025d5:	76 17                	jbe    8025ee <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  8025d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8025da:	68 74 50 80 00       	push   $0x805074
  8025df:	68 b4 00 00 00       	push   $0xb4
  8025e4:	68 65 4f 80 00       	push   $0x804f65
  8025e9:	e8 34 e7 ff ff       	call   800d22 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  8025ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f1:	05 00 10 00 00       	add    $0x1000,%eax
  8025f6:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  8025f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025fc:	85 c0                	test   %eax,%eax
  8025fe:	79 2e                	jns    80262e <free_pages+0x121>
  802600:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  802607:	77 25                	ja     80262e <free_pages+0x121>
  802609:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802610:	77 1c                	ja     80262e <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  802612:	83 ec 08             	sub    $0x8,%esp
  802615:	68 00 10 00 00       	push   $0x1000
  80261a:	ff 75 f0             	pushl  -0x10(%ebp)
  80261d:	e8 38 0d 00 00       	call   80335a <sys_free_user_mem>
  802622:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802625:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  80262c:	eb 28                	jmp    802656 <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  80262e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802631:	68 00 00 00 a0       	push   $0xa0000000
  802636:	ff 75 dc             	pushl  -0x24(%ebp)
  802639:	68 00 10 00 00       	push   $0x1000
  80263e:	ff 75 f0             	pushl  -0x10(%ebp)
  802641:	50                   	push   %eax
  802642:	68 b4 50 80 00       	push   $0x8050b4
  802647:	68 bd 00 00 00       	push   $0xbd
  80264c:	68 65 4f 80 00       	push   $0x804f65
  802651:	e8 cc e6 ff ff       	call   800d22 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  802656:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802659:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80265c:	0f 82 6c ff ff ff    	jb     8025ce <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  802662:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802666:	75 17                	jne    80267f <free_pages+0x172>
  802668:	83 ec 04             	sub    $0x4,%esp
  80266b:	68 16 51 80 00       	push   $0x805116
  802670:	68 c1 00 00 00       	push   $0xc1
  802675:	68 65 4f 80 00       	push   $0x804f65
  80267a:	e8 a3 e6 ff ff       	call   800d22 <_panic>
  80267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802682:	8b 40 08             	mov    0x8(%eax),%eax
  802685:	85 c0                	test   %eax,%eax
  802687:	74 11                	je     80269a <free_pages+0x18d>
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	8b 40 08             	mov    0x8(%eax),%eax
  80268f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802692:	8b 52 0c             	mov    0xc(%edx),%edx
  802695:	89 50 0c             	mov    %edx,0xc(%eax)
  802698:	eb 0b                	jmp    8026a5 <free_pages+0x198>
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a0:	a3 28 60 80 00       	mov    %eax,0x806028
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ab:	85 c0                	test   %eax,%eax
  8026ad:	74 11                	je     8026c0 <free_pages+0x1b3>
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b8:	8b 52 08             	mov    0x8(%edx),%edx
  8026bb:	89 50 08             	mov    %edx,0x8(%eax)
  8026be:	eb 0b                	jmp    8026cb <free_pages+0x1be>
  8026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c3:	8b 40 08             	mov    0x8(%eax),%eax
  8026c6:	a3 24 60 80 00       	mov    %eax,0x806024
  8026cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ce:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8026d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8026df:	a1 30 60 80 00       	mov    0x806030,%eax
  8026e4:	48                   	dec    %eax
  8026e5:	a3 30 60 80 00       	mov    %eax,0x806030
			free_block(it);
  8026ea:	83 ec 0c             	sub    $0xc,%esp
  8026ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8026f0:	e8 24 15 00 00       	call   803c19 <free_block>
  8026f5:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  8026f8:	e8 72 fb ff ff       	call   80226f <recompute_page_alloc_break>

			return;
  8026fd:	eb 37                	jmp    802736 <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8026ff:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802704:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802707:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270b:	74 08                	je     802715 <free_pages+0x208>
  80270d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802710:	8b 40 08             	mov    0x8(%eax),%eax
  802713:	eb 05                	jmp    80271a <free_pages+0x20d>
  802715:	b8 00 00 00 00       	mov    $0x0,%eax
  80271a:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80271f:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802724:	85 c0                	test   %eax,%eax
  802726:	0f 85 fa fd ff ff    	jne    802526 <free_pages+0x19>
  80272c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802730:	0f 85 f0 fd ff ff    	jne    802526 <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  802736:	c9                   	leave  
  802737:	c3                   	ret    

00802738 <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  802738:	55                   	push   %ebp
  802739:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  80273b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802740:	5d                   	pop    %ebp
  802741:	c3                   	ret    

00802742 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802742:	55                   	push   %ebp
  802743:	89 e5                	mov    %esp,%ebp
  802745:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802748:	a1 08 60 80 00       	mov    0x806008,%eax
  80274d:	85 c0                	test   %eax,%eax
  80274f:	74 60                	je     8027b1 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802751:	83 ec 08             	sub    $0x8,%esp
  802754:	68 00 00 00 82       	push   $0x82000000
  802759:	68 00 00 00 80       	push   $0x80000000
  80275e:	e8 0d 0d 00 00       	call   803470 <initialize_dynamic_allocator>
  802763:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802766:	e8 f3 0a 00 00       	call   80325e <sys_get_uheap_strategy>
  80276b:	a3 60 e0 81 00       	mov    %eax,0x81e060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802770:	a1 40 60 80 00       	mov    0x806040,%eax
  802775:	05 00 10 00 00       	add    $0x1000,%eax
  80277a:	a3 10 e1 81 00       	mov    %eax,0x81e110
		uheapPageAllocBreak = uheapPageAllocStart;
  80277f:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802784:	a3 68 e0 81 00       	mov    %eax,0x81e068

		LIST_INIT(&page_alloc_list);
  802789:	c7 05 24 60 80 00 00 	movl   $0x0,0x806024
  802790:	00 00 00 
  802793:	c7 05 28 60 80 00 00 	movl   $0x0,0x806028
  80279a:	00 00 00 
  80279d:	c7 05 30 60 80 00 00 	movl   $0x0,0x806030
  8027a4:	00 00 00 

		__firstTimeFlag = 0;
  8027a7:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  8027ae:	00 00 00 
	}
}
  8027b1:	90                   	nop
  8027b2:	c9                   	leave  
  8027b3:	c3                   	ret    

008027b4 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8027b4:	55                   	push   %ebp
  8027b5:	89 e5                	mov    %esp,%ebp
  8027b7:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8027ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8027c8:	83 ec 08             	sub    $0x8,%esp
  8027cb:	68 06 04 00 00       	push   $0x406
  8027d0:	50                   	push   %eax
  8027d1:	e8 d2 06 00 00       	call   802ea8 <__sys_allocate_page>
  8027d6:	83 c4 10             	add    $0x10,%esp
  8027d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8027dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027e0:	79 17                	jns    8027f9 <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  8027e2:	83 ec 04             	sub    $0x4,%esp
  8027e5:	68 34 51 80 00       	push   $0x805134
  8027ea:	68 ea 00 00 00       	push   $0xea
  8027ef:	68 65 4f 80 00       	push   $0x804f65
  8027f4:	e8 29 e5 ff ff       	call   800d22 <_panic>
	return 0;
  8027f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027fe:	c9                   	leave  
  8027ff:	c3                   	ret    

00802800 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802800:	55                   	push   %ebp
  802801:	89 e5                	mov    %esp,%ebp
  802803:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802806:	8b 45 08             	mov    0x8(%ebp),%eax
  802809:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80280c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802814:	83 ec 0c             	sub    $0xc,%esp
  802817:	50                   	push   %eax
  802818:	e8 d2 06 00 00       	call   802eef <__sys_unmap_frame>
  80281d:	83 c4 10             	add    $0x10,%esp
  802820:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802823:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802827:	79 17                	jns    802840 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  802829:	83 ec 04             	sub    $0x4,%esp
  80282c:	68 70 51 80 00       	push   $0x805170
  802831:	68 f5 00 00 00       	push   $0xf5
  802836:	68 65 4f 80 00       	push   $0x804f65
  80283b:	e8 e2 e4 ff ff       	call   800d22 <_panic>
}
  802840:	90                   	nop
  802841:	c9                   	leave  
  802842:	c3                   	ret    

00802843 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802843:	55                   	push   %ebp
  802844:	89 e5                	mov    %esp,%ebp
  802846:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802849:	e8 f4 fe ff ff       	call   802742 <uheap_init>
	if (size == 0) return NULL ;
  80284e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802852:	75 0a                	jne    80285e <malloc+0x1b>
  802854:	b8 00 00 00 00       	mov    $0x0,%eax
  802859:	e9 67 01 00 00       	jmp    8029c5 <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  80285e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  802865:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80286c:	77 16                	ja     802884 <malloc+0x41>
		result = alloc_block(size);
  80286e:	83 ec 0c             	sub    $0xc,%esp
  802871:	ff 75 08             	pushl  0x8(%ebp)
  802874:	e8 46 0e 00 00       	call   8036bf <alloc_block>
  802879:	83 c4 10             	add    $0x10,%esp
  80287c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80287f:	e9 3e 01 00 00       	jmp    8029c2 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  802884:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80288b:	8b 55 08             	mov    0x8(%ebp),%edx
  80288e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802891:	01 d0                	add    %edx,%eax
  802893:	48                   	dec    %eax
  802894:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802897:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289a:	ba 00 00 00 00       	mov    $0x0,%edx
  80289f:	f7 75 f0             	divl   -0x10(%ebp)
  8028a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a5:	29 d0                	sub    %edx,%eax
  8028a7:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  8028aa:	a1 10 e1 81 00       	mov    0x81e110,%eax
  8028af:	85 c0                	test   %eax,%eax
  8028b1:	75 0a                	jne    8028bd <malloc+0x7a>
			return NULL;
  8028b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b8:	e9 08 01 00 00       	jmp    8029c5 <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  8028bd:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8028c2:	85 c0                	test   %eax,%eax
  8028c4:	74 0f                	je     8028d5 <malloc+0x92>
  8028c6:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  8028cc:	a1 10 e1 81 00       	mov    0x81e110,%eax
  8028d1:	39 c2                	cmp    %eax,%edx
  8028d3:	73 0a                	jae    8028df <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  8028d5:	a1 10 e1 81 00       	mov    0x81e110,%eax
  8028da:	a3 68 e0 81 00       	mov    %eax,0x81e068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  8028df:	a1 60 e0 81 00       	mov    0x81e060,%eax
  8028e4:	83 f8 05             	cmp    $0x5,%eax
  8028e7:	75 11                	jne    8028fa <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  8028e9:	83 ec 0c             	sub    $0xc,%esp
  8028ec:	ff 75 e8             	pushl  -0x18(%ebp)
  8028ef:	e8 ff f9 ff ff       	call   8022f3 <alloc_pages_custom_fit>
  8028f4:	83 c4 10             	add    $0x10,%esp
  8028f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  8028fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028fe:	0f 84 be 00 00 00    	je     8029c2 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  80290a:	83 ec 0c             	sub    $0xc,%esp
  80290d:	ff 75 f4             	pushl  -0xc(%ebp)
  802910:	e8 9a fb ff ff       	call   8024af <find_allocated_size>
  802915:	83 c4 10             	add    $0x10,%esp
  802918:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  80291b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80291f:	75 17                	jne    802938 <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  802921:	ff 75 f4             	pushl  -0xc(%ebp)
  802924:	68 b0 51 80 00       	push   $0x8051b0
  802929:	68 24 01 00 00       	push   $0x124
  80292e:	68 65 4f 80 00       	push   $0x804f65
  802933:	e8 ea e3 ff ff       	call   800d22 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  802938:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80293b:	f7 d0                	not    %eax
  80293d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802940:	73 1d                	jae    80295f <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  802942:	83 ec 0c             	sub    $0xc,%esp
  802945:	ff 75 e0             	pushl  -0x20(%ebp)
  802948:	ff 75 e4             	pushl  -0x1c(%ebp)
  80294b:	68 f8 51 80 00       	push   $0x8051f8
  802950:	68 29 01 00 00       	push   $0x129
  802955:	68 65 4f 80 00       	push   $0x804f65
  80295a:	e8 c3 e3 ff ff       	call   800d22 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  80295f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802962:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802965:	01 d0                	add    %edx,%eax
  802967:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  80296a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80296d:	85 c0                	test   %eax,%eax
  80296f:	79 2c                	jns    80299d <malloc+0x15a>
  802971:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  802978:	77 23                	ja     80299d <malloc+0x15a>
  80297a:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  802981:	77 1a                	ja     80299d <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  802983:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802986:	85 c0                	test   %eax,%eax
  802988:	79 13                	jns    80299d <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  80298a:	83 ec 08             	sub    $0x8,%esp
  80298d:	ff 75 e0             	pushl  -0x20(%ebp)
  802990:	ff 75 e4             	pushl  -0x1c(%ebp)
  802993:	e8 de 09 00 00       	call   803376 <sys_allocate_user_mem>
  802998:	83 c4 10             	add    $0x10,%esp
  80299b:	eb 25                	jmp    8029c2 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  80299d:	68 00 00 00 a0       	push   $0xa0000000
  8029a2:	ff 75 dc             	pushl  -0x24(%ebp)
  8029a5:	ff 75 e0             	pushl  -0x20(%ebp)
  8029a8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8029ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8029ae:	68 34 52 80 00       	push   $0x805234
  8029b3:	68 33 01 00 00       	push   $0x133
  8029b8:	68 65 4f 80 00       	push   $0x804f65
  8029bd:	e8 60 e3 ff ff       	call   800d22 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  8029c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  8029c5:	c9                   	leave  
  8029c6:	c3                   	ret    

008029c7 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8029c7:	55                   	push   %ebp
  8029c8:	89 e5                	mov    %esp,%ebp
  8029ca:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  8029cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029d1:	0f 84 26 01 00 00    	je     802afd <free+0x136>

	uint32 addr = (uint32)virtual_address;
  8029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029da:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  8029dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e0:	85 c0                	test   %eax,%eax
  8029e2:	79 1c                	jns    802a00 <free+0x39>
  8029e4:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  8029eb:	77 13                	ja     802a00 <free+0x39>
		free_block(virtual_address);
  8029ed:	83 ec 0c             	sub    $0xc,%esp
  8029f0:	ff 75 08             	pushl  0x8(%ebp)
  8029f3:	e8 21 12 00 00       	call   803c19 <free_block>
  8029f8:	83 c4 10             	add    $0x10,%esp
		return;
  8029fb:	e9 01 01 00 00       	jmp    802b01 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  802a00:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802a05:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  802a08:	0f 82 d8 00 00 00    	jb     802ae6 <free+0x11f>
  802a0e:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  802a15:	0f 87 cb 00 00 00    	ja     802ae6 <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  802a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1e:	25 ff 0f 00 00       	and    $0xfff,%eax
  802a23:	85 c0                	test   %eax,%eax
  802a25:	74 17                	je     802a3e <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  802a27:	ff 75 08             	pushl  0x8(%ebp)
  802a2a:	68 a4 52 80 00       	push   $0x8052a4
  802a2f:	68 57 01 00 00       	push   $0x157
  802a34:	68 65 4f 80 00       	push   $0x804f65
  802a39:	e8 e4 e2 ff ff       	call   800d22 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  802a3e:	83 ec 0c             	sub    $0xc,%esp
  802a41:	ff 75 08             	pushl  0x8(%ebp)
  802a44:	e8 66 fa ff ff       	call   8024af <find_allocated_size>
  802a49:	83 c4 10             	add    $0x10,%esp
  802a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  802a4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a53:	0f 84 a7 00 00 00    	je     802b00 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  802a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5c:	f7 d0                	not    %eax
  802a5e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802a61:	73 1d                	jae    802a80 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  802a63:	83 ec 0c             	sub    $0xc,%esp
  802a66:	ff 75 f0             	pushl  -0x10(%ebp)
  802a69:	ff 75 f4             	pushl  -0xc(%ebp)
  802a6c:	68 cc 52 80 00       	push   $0x8052cc
  802a71:	68 61 01 00 00       	push   $0x161
  802a76:	68 65 4f 80 00       	push   $0x804f65
  802a7b:	e8 a2 e2 ff ff       	call   800d22 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  802a80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a86:	01 d0                	add    %edx,%eax
  802a88:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  802a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8e:	85 c0                	test   %eax,%eax
  802a90:	79 19                	jns    802aab <free+0xe4>
  802a92:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  802a99:	77 10                	ja     802aab <free+0xe4>
  802a9b:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  802aa2:	77 07                	ja     802aab <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  802aa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa7:	85 c0                	test   %eax,%eax
  802aa9:	78 2b                	js     802ad6 <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  802aab:	83 ec 0c             	sub    $0xc,%esp
  802aae:	68 00 00 00 a0       	push   $0xa0000000
  802ab3:	ff 75 ec             	pushl  -0x14(%ebp)
  802ab6:	ff 75 f0             	pushl  -0x10(%ebp)
  802ab9:	ff 75 f4             	pushl  -0xc(%ebp)
  802abc:	ff 75 f0             	pushl  -0x10(%ebp)
  802abf:	ff 75 08             	pushl  0x8(%ebp)
  802ac2:	68 08 53 80 00       	push   $0x805308
  802ac7:	68 69 01 00 00       	push   $0x169
  802acc:	68 65 4f 80 00       	push   $0x804f65
  802ad1:	e8 4c e2 ff ff       	call   800d22 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  802ad6:	83 ec 0c             	sub    $0xc,%esp
  802ad9:	ff 75 08             	pushl  0x8(%ebp)
  802adc:	e8 2c fa ff ff       	call   80250d <free_pages>
  802ae1:	83 c4 10             	add    $0x10,%esp
		return;
  802ae4:	eb 1b                	jmp    802b01 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  802ae6:	ff 75 08             	pushl  0x8(%ebp)
  802ae9:	68 64 53 80 00       	push   $0x805364
  802aee:	68 70 01 00 00       	push   $0x170
  802af3:	68 65 4f 80 00       	push   $0x804f65
  802af8:	e8 25 e2 ff ff       	call   800d22 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  802afd:	90                   	nop
  802afe:	eb 01                	jmp    802b01 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  802b00:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  802b01:	c9                   	leave  
  802b02:	c3                   	ret    

00802b03 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802b03:	55                   	push   %ebp
  802b04:	89 e5                	mov    %esp,%ebp
  802b06:	83 ec 38             	sub    $0x38,%esp
  802b09:	8b 45 10             	mov    0x10(%ebp),%eax
  802b0c:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802b0f:	e8 2e fc ff ff       	call   802742 <uheap_init>
	if (size == 0) return NULL ;
  802b14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b18:	75 0a                	jne    802b24 <smalloc+0x21>
  802b1a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b1f:	e9 3d 01 00 00       	jmp    802c61 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  802b24:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b27:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  802b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b2d:	25 ff 0f 00 00       	and    $0xfff,%eax
  802b32:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  802b35:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b39:	74 0e                	je     802b49 <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  802b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3e:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802b41:	05 00 10 00 00       	add    $0x1000,%eax
  802b46:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  802b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4c:	c1 e8 0c             	shr    $0xc,%eax
  802b4f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  802b52:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802b57:	85 c0                	test   %eax,%eax
  802b59:	75 0a                	jne    802b65 <smalloc+0x62>
		return NULL;
  802b5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b60:	e9 fc 00 00 00       	jmp    802c61 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  802b65:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802b6a:	85 c0                	test   %eax,%eax
  802b6c:	74 0f                	je     802b7d <smalloc+0x7a>
  802b6e:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802b74:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802b79:	39 c2                	cmp    %eax,%edx
  802b7b:	73 0a                	jae    802b87 <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  802b7d:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802b82:	a3 68 e0 81 00       	mov    %eax,0x81e068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802b87:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802b8c:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802b91:	29 c2                	sub    %eax,%edx
  802b93:	89 d0                	mov    %edx,%eax
  802b95:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802b98:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802b9e:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802ba3:	29 c2                	sub    %eax,%edx
  802ba5:	89 d0                	mov    %edx,%eax
  802ba7:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  802baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bad:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802bb0:	77 13                	ja     802bc5 <smalloc+0xc2>
  802bb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802bb8:	77 0b                	ja     802bc5 <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  802bba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bbd:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  802bc0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802bc3:	73 0a                	jae    802bcf <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  802bc5:	b8 00 00 00 00       	mov    $0x0,%eax
  802bca:	e9 92 00 00 00       	jmp    802c61 <smalloc+0x15e>
	}

	void *va = NULL;
  802bcf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  802bd6:	a1 60 e0 81 00       	mov    0x81e060,%eax
  802bdb:	83 f8 05             	cmp    $0x5,%eax
  802bde:	75 11                	jne    802bf1 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  802be0:	83 ec 0c             	sub    $0xc,%esp
  802be3:	ff 75 f4             	pushl  -0xc(%ebp)
  802be6:	e8 08 f7 ff ff       	call   8022f3 <alloc_pages_custom_fit>
  802beb:	83 c4 10             	add    $0x10,%esp
  802bee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  802bf1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bf5:	75 27                	jne    802c1e <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802bf7:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  802bfe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c01:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802c04:	89 c2                	mov    %eax,%edx
  802c06:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802c0b:	39 c2                	cmp    %eax,%edx
  802c0d:	73 07                	jae    802c16 <smalloc+0x113>
			return NULL;}
  802c0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c14:	eb 4b                	jmp    802c61 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  802c16:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802c1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  802c1e:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802c22:	ff 75 f0             	pushl  -0x10(%ebp)
  802c25:	50                   	push   %eax
  802c26:	ff 75 0c             	pushl  0xc(%ebp)
  802c29:	ff 75 08             	pushl  0x8(%ebp)
  802c2c:	e8 cb 03 00 00       	call   802ffc <sys_create_shared_object>
  802c31:	83 c4 10             	add    $0x10,%esp
  802c34:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  802c37:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802c3b:	79 07                	jns    802c44 <smalloc+0x141>
		return NULL;
  802c3d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c42:	eb 1d                	jmp    802c61 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  802c44:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802c49:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802c4c:	75 10                	jne    802c5e <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  802c4e:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c57:	01 d0                	add    %edx,%eax
  802c59:	a3 68 e0 81 00       	mov    %eax,0x81e068
	}

	return va;
  802c5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  802c61:	c9                   	leave  
  802c62:	c3                   	ret    

00802c63 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802c63:	55                   	push   %ebp
  802c64:	89 e5                	mov    %esp,%ebp
  802c66:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802c69:	e8 d4 fa ff ff       	call   802742 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802c6e:	83 ec 08             	sub    $0x8,%esp
  802c71:	ff 75 0c             	pushl  0xc(%ebp)
  802c74:	ff 75 08             	pushl  0x8(%ebp)
  802c77:	e8 aa 03 00 00       	call   803026 <sys_size_of_shared_object>
  802c7c:	83 c4 10             	add    $0x10,%esp
  802c7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  802c82:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c86:	7f 0a                	jg     802c92 <sget+0x2f>
		return NULL;
  802c88:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8d:	e9 32 01 00 00       	jmp    802dc4 <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  802c92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c95:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  802c98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9b:	25 ff 0f 00 00       	and    $0xfff,%eax
  802ca0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  802ca3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ca7:	74 0e                	je     802cb7 <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  802ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cac:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802caf:	05 00 10 00 00       	add    $0x1000,%eax
  802cb4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  802cb7:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802cbc:	85 c0                	test   %eax,%eax
  802cbe:	75 0a                	jne    802cca <sget+0x67>
		return NULL;
  802cc0:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc5:	e9 fa 00 00 00       	jmp    802dc4 <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  802cca:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802ccf:	85 c0                	test   %eax,%eax
  802cd1:	74 0f                	je     802ce2 <sget+0x7f>
  802cd3:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802cd9:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802cde:	39 c2                	cmp    %eax,%edx
  802ce0:	73 0a                	jae    802cec <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  802ce2:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802ce7:	a3 68 e0 81 00       	mov    %eax,0x81e068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  802cec:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802cf1:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802cf6:	29 c2                	sub    %eax,%edx
  802cf8:	89 d0                	mov    %edx,%eax
  802cfa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  802cfd:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802d03:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802d08:	29 c2                	sub    %eax,%edx
  802d0a:	89 d0                	mov    %edx,%eax
  802d0c:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d12:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d15:	77 13                	ja     802d2a <sget+0xc7>
  802d17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d1a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d1d:	77 0b                	ja     802d2a <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  802d1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d22:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  802d25:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802d28:	73 0a                	jae    802d34 <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  802d2a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d2f:	e9 90 00 00 00       	jmp    802dc4 <sget+0x161>

	void *va = NULL;
  802d34:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  802d3b:	a1 60 e0 81 00       	mov    0x81e060,%eax
  802d40:	83 f8 05             	cmp    $0x5,%eax
  802d43:	75 11                	jne    802d56 <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  802d45:	83 ec 0c             	sub    $0xc,%esp
  802d48:	ff 75 f4             	pushl  -0xc(%ebp)
  802d4b:	e8 a3 f5 ff ff       	call   8022f3 <alloc_pages_custom_fit>
  802d50:	83 c4 10             	add    $0x10,%esp
  802d53:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  802d56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d5a:	75 27                	jne    802d83 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802d5c:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  802d63:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d66:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802d69:	89 c2                	mov    %eax,%edx
  802d6b:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802d70:	39 c2                	cmp    %eax,%edx
  802d72:	73 07                	jae    802d7b <sget+0x118>
			return NULL;
  802d74:	b8 00 00 00 00       	mov    $0x0,%eax
  802d79:	eb 49                	jmp    802dc4 <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  802d7b:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802d80:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  802d83:	83 ec 04             	sub    $0x4,%esp
  802d86:	ff 75 f0             	pushl  -0x10(%ebp)
  802d89:	ff 75 0c             	pushl  0xc(%ebp)
  802d8c:	ff 75 08             	pushl  0x8(%ebp)
  802d8f:	e8 af 02 00 00       	call   803043 <sys_get_shared_object>
  802d94:	83 c4 10             	add    $0x10,%esp
  802d97:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  802d9a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802d9e:	79 07                	jns    802da7 <sget+0x144>
		return NULL;
  802da0:	b8 00 00 00 00       	mov    $0x0,%eax
  802da5:	eb 1d                	jmp    802dc4 <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  802da7:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802dac:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802daf:	75 10                	jne    802dc1 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  802db1:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dba:	01 d0                	add    %edx,%eax
  802dbc:	a3 68 e0 81 00       	mov    %eax,0x81e068

	return va;
  802dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  802dc4:	c9                   	leave  
  802dc5:	c3                   	ret    

00802dc6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802dc6:	55                   	push   %ebp
  802dc7:	89 e5                	mov    %esp,%ebp
  802dc9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802dcc:	e8 71 f9 ff ff       	call   802742 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802dd1:	83 ec 04             	sub    $0x4,%esp
  802dd4:	68 88 53 80 00       	push   $0x805388
  802dd9:	68 19 02 00 00       	push   $0x219
  802dde:	68 65 4f 80 00       	push   $0x804f65
  802de3:	e8 3a df ff ff       	call   800d22 <_panic>

00802de8 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802de8:	55                   	push   %ebp
  802de9:	89 e5                	mov    %esp,%ebp
  802deb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802dee:	83 ec 04             	sub    $0x4,%esp
  802df1:	68 b0 53 80 00       	push   $0x8053b0
  802df6:	68 2b 02 00 00       	push   $0x22b
  802dfb:	68 65 4f 80 00       	push   $0x804f65
  802e00:	e8 1d df ff ff       	call   800d22 <_panic>

00802e05 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802e05:	55                   	push   %ebp
  802e06:	89 e5                	mov    %esp,%ebp
  802e08:	57                   	push   %edi
  802e09:	56                   	push   %esi
  802e0a:	53                   	push   %ebx
  802e0b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e11:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e14:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e17:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e1a:	8b 7d 18             	mov    0x18(%ebp),%edi
  802e1d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802e20:	cd 30                	int    $0x30
  802e22:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802e25:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802e28:	83 c4 10             	add    $0x10,%esp
  802e2b:	5b                   	pop    %ebx
  802e2c:	5e                   	pop    %esi
  802e2d:	5f                   	pop    %edi
  802e2e:	5d                   	pop    %ebp
  802e2f:	c3                   	ret    

00802e30 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802e30:	55                   	push   %ebp
  802e31:	89 e5                	mov    %esp,%ebp
  802e33:	83 ec 04             	sub    $0x4,%esp
  802e36:	8b 45 10             	mov    0x10(%ebp),%eax
  802e39:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802e3c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802e3f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802e43:	8b 45 08             	mov    0x8(%ebp),%eax
  802e46:	6a 00                	push   $0x0
  802e48:	51                   	push   %ecx
  802e49:	52                   	push   %edx
  802e4a:	ff 75 0c             	pushl  0xc(%ebp)
  802e4d:	50                   	push   %eax
  802e4e:	6a 00                	push   $0x0
  802e50:	e8 b0 ff ff ff       	call   802e05 <syscall>
  802e55:	83 c4 18             	add    $0x18,%esp
}
  802e58:	90                   	nop
  802e59:	c9                   	leave  
  802e5a:	c3                   	ret    

00802e5b <sys_cgetc>:

int
sys_cgetc(void)
{
  802e5b:	55                   	push   %ebp
  802e5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802e5e:	6a 00                	push   $0x0
  802e60:	6a 00                	push   $0x0
  802e62:	6a 00                	push   $0x0
  802e64:	6a 00                	push   $0x0
  802e66:	6a 00                	push   $0x0
  802e68:	6a 02                	push   $0x2
  802e6a:	e8 96 ff ff ff       	call   802e05 <syscall>
  802e6f:	83 c4 18             	add    $0x18,%esp
}
  802e72:	c9                   	leave  
  802e73:	c3                   	ret    

00802e74 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802e74:	55                   	push   %ebp
  802e75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802e77:	6a 00                	push   $0x0
  802e79:	6a 00                	push   $0x0
  802e7b:	6a 00                	push   $0x0
  802e7d:	6a 00                	push   $0x0
  802e7f:	6a 00                	push   $0x0
  802e81:	6a 03                	push   $0x3
  802e83:	e8 7d ff ff ff       	call   802e05 <syscall>
  802e88:	83 c4 18             	add    $0x18,%esp
}
  802e8b:	90                   	nop
  802e8c:	c9                   	leave  
  802e8d:	c3                   	ret    

00802e8e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802e8e:	55                   	push   %ebp
  802e8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802e91:	6a 00                	push   $0x0
  802e93:	6a 00                	push   $0x0
  802e95:	6a 00                	push   $0x0
  802e97:	6a 00                	push   $0x0
  802e99:	6a 00                	push   $0x0
  802e9b:	6a 04                	push   $0x4
  802e9d:	e8 63 ff ff ff       	call   802e05 <syscall>
  802ea2:	83 c4 18             	add    $0x18,%esp
}
  802ea5:	90                   	nop
  802ea6:	c9                   	leave  
  802ea7:	c3                   	ret    

00802ea8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802ea8:	55                   	push   %ebp
  802ea9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802eab:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eae:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb1:	6a 00                	push   $0x0
  802eb3:	6a 00                	push   $0x0
  802eb5:	6a 00                	push   $0x0
  802eb7:	52                   	push   %edx
  802eb8:	50                   	push   %eax
  802eb9:	6a 08                	push   $0x8
  802ebb:	e8 45 ff ff ff       	call   802e05 <syscall>
  802ec0:	83 c4 18             	add    $0x18,%esp
}
  802ec3:	c9                   	leave  
  802ec4:	c3                   	ret    

00802ec5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802ec5:	55                   	push   %ebp
  802ec6:	89 e5                	mov    %esp,%ebp
  802ec8:	56                   	push   %esi
  802ec9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802eca:	8b 75 18             	mov    0x18(%ebp),%esi
  802ecd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802ed0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ed3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed9:	56                   	push   %esi
  802eda:	53                   	push   %ebx
  802edb:	51                   	push   %ecx
  802edc:	52                   	push   %edx
  802edd:	50                   	push   %eax
  802ede:	6a 09                	push   $0x9
  802ee0:	e8 20 ff ff ff       	call   802e05 <syscall>
  802ee5:	83 c4 18             	add    $0x18,%esp
}
  802ee8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802eeb:	5b                   	pop    %ebx
  802eec:	5e                   	pop    %esi
  802eed:	5d                   	pop    %ebp
  802eee:	c3                   	ret    

00802eef <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802eef:	55                   	push   %ebp
  802ef0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802ef2:	6a 00                	push   $0x0
  802ef4:	6a 00                	push   $0x0
  802ef6:	6a 00                	push   $0x0
  802ef8:	6a 00                	push   $0x0
  802efa:	ff 75 08             	pushl  0x8(%ebp)
  802efd:	6a 0a                	push   $0xa
  802eff:	e8 01 ff ff ff       	call   802e05 <syscall>
  802f04:	83 c4 18             	add    $0x18,%esp
}
  802f07:	c9                   	leave  
  802f08:	c3                   	ret    

00802f09 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802f09:	55                   	push   %ebp
  802f0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802f0c:	6a 00                	push   $0x0
  802f0e:	6a 00                	push   $0x0
  802f10:	6a 00                	push   $0x0
  802f12:	ff 75 0c             	pushl  0xc(%ebp)
  802f15:	ff 75 08             	pushl  0x8(%ebp)
  802f18:	6a 0b                	push   $0xb
  802f1a:	e8 e6 fe ff ff       	call   802e05 <syscall>
  802f1f:	83 c4 18             	add    $0x18,%esp
}
  802f22:	c9                   	leave  
  802f23:	c3                   	ret    

00802f24 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802f24:	55                   	push   %ebp
  802f25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802f27:	6a 00                	push   $0x0
  802f29:	6a 00                	push   $0x0
  802f2b:	6a 00                	push   $0x0
  802f2d:	6a 00                	push   $0x0
  802f2f:	6a 00                	push   $0x0
  802f31:	6a 0c                	push   $0xc
  802f33:	e8 cd fe ff ff       	call   802e05 <syscall>
  802f38:	83 c4 18             	add    $0x18,%esp
}
  802f3b:	c9                   	leave  
  802f3c:	c3                   	ret    

00802f3d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802f3d:	55                   	push   %ebp
  802f3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802f40:	6a 00                	push   $0x0
  802f42:	6a 00                	push   $0x0
  802f44:	6a 00                	push   $0x0
  802f46:	6a 00                	push   $0x0
  802f48:	6a 00                	push   $0x0
  802f4a:	6a 0d                	push   $0xd
  802f4c:	e8 b4 fe ff ff       	call   802e05 <syscall>
  802f51:	83 c4 18             	add    $0x18,%esp
}
  802f54:	c9                   	leave  
  802f55:	c3                   	ret    

00802f56 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802f56:	55                   	push   %ebp
  802f57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802f59:	6a 00                	push   $0x0
  802f5b:	6a 00                	push   $0x0
  802f5d:	6a 00                	push   $0x0
  802f5f:	6a 00                	push   $0x0
  802f61:	6a 00                	push   $0x0
  802f63:	6a 0e                	push   $0xe
  802f65:	e8 9b fe ff ff       	call   802e05 <syscall>
  802f6a:	83 c4 18             	add    $0x18,%esp
}
  802f6d:	c9                   	leave  
  802f6e:	c3                   	ret    

00802f6f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802f6f:	55                   	push   %ebp
  802f70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802f72:	6a 00                	push   $0x0
  802f74:	6a 00                	push   $0x0
  802f76:	6a 00                	push   $0x0
  802f78:	6a 00                	push   $0x0
  802f7a:	6a 00                	push   $0x0
  802f7c:	6a 0f                	push   $0xf
  802f7e:	e8 82 fe ff ff       	call   802e05 <syscall>
  802f83:	83 c4 18             	add    $0x18,%esp
}
  802f86:	c9                   	leave  
  802f87:	c3                   	ret    

00802f88 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802f88:	55                   	push   %ebp
  802f89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802f8b:	6a 00                	push   $0x0
  802f8d:	6a 00                	push   $0x0
  802f8f:	6a 00                	push   $0x0
  802f91:	6a 00                	push   $0x0
  802f93:	ff 75 08             	pushl  0x8(%ebp)
  802f96:	6a 10                	push   $0x10
  802f98:	e8 68 fe ff ff       	call   802e05 <syscall>
  802f9d:	83 c4 18             	add    $0x18,%esp
}
  802fa0:	c9                   	leave  
  802fa1:	c3                   	ret    

00802fa2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802fa2:	55                   	push   %ebp
  802fa3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802fa5:	6a 00                	push   $0x0
  802fa7:	6a 00                	push   $0x0
  802fa9:	6a 00                	push   $0x0
  802fab:	6a 00                	push   $0x0
  802fad:	6a 00                	push   $0x0
  802faf:	6a 11                	push   $0x11
  802fb1:	e8 4f fe ff ff       	call   802e05 <syscall>
  802fb6:	83 c4 18             	add    $0x18,%esp
}
  802fb9:	90                   	nop
  802fba:	c9                   	leave  
  802fbb:	c3                   	ret    

00802fbc <sys_cputc>:

void
sys_cputc(const char c)
{
  802fbc:	55                   	push   %ebp
  802fbd:	89 e5                	mov    %esp,%ebp
  802fbf:	83 ec 04             	sub    $0x4,%esp
  802fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802fc8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802fcc:	6a 00                	push   $0x0
  802fce:	6a 00                	push   $0x0
  802fd0:	6a 00                	push   $0x0
  802fd2:	6a 00                	push   $0x0
  802fd4:	50                   	push   %eax
  802fd5:	6a 01                	push   $0x1
  802fd7:	e8 29 fe ff ff       	call   802e05 <syscall>
  802fdc:	83 c4 18             	add    $0x18,%esp
}
  802fdf:	90                   	nop
  802fe0:	c9                   	leave  
  802fe1:	c3                   	ret    

00802fe2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802fe2:	55                   	push   %ebp
  802fe3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802fe5:	6a 00                	push   $0x0
  802fe7:	6a 00                	push   $0x0
  802fe9:	6a 00                	push   $0x0
  802feb:	6a 00                	push   $0x0
  802fed:	6a 00                	push   $0x0
  802fef:	6a 14                	push   $0x14
  802ff1:	e8 0f fe ff ff       	call   802e05 <syscall>
  802ff6:	83 c4 18             	add    $0x18,%esp
}
  802ff9:	90                   	nop
  802ffa:	c9                   	leave  
  802ffb:	c3                   	ret    

00802ffc <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802ffc:	55                   	push   %ebp
  802ffd:	89 e5                	mov    %esp,%ebp
  802fff:	83 ec 04             	sub    $0x4,%esp
  803002:	8b 45 10             	mov    0x10(%ebp),%eax
  803005:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803008:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80300b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80300f:	8b 45 08             	mov    0x8(%ebp),%eax
  803012:	6a 00                	push   $0x0
  803014:	51                   	push   %ecx
  803015:	52                   	push   %edx
  803016:	ff 75 0c             	pushl  0xc(%ebp)
  803019:	50                   	push   %eax
  80301a:	6a 15                	push   $0x15
  80301c:	e8 e4 fd ff ff       	call   802e05 <syscall>
  803021:	83 c4 18             	add    $0x18,%esp
}
  803024:	c9                   	leave  
  803025:	c3                   	ret    

00803026 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803026:	55                   	push   %ebp
  803027:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803029:	8b 55 0c             	mov    0xc(%ebp),%edx
  80302c:	8b 45 08             	mov    0x8(%ebp),%eax
  80302f:	6a 00                	push   $0x0
  803031:	6a 00                	push   $0x0
  803033:	6a 00                	push   $0x0
  803035:	52                   	push   %edx
  803036:	50                   	push   %eax
  803037:	6a 16                	push   $0x16
  803039:	e8 c7 fd ff ff       	call   802e05 <syscall>
  80303e:	83 c4 18             	add    $0x18,%esp
}
  803041:	c9                   	leave  
  803042:	c3                   	ret    

00803043 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803043:	55                   	push   %ebp
  803044:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803046:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803049:	8b 55 0c             	mov    0xc(%ebp),%edx
  80304c:	8b 45 08             	mov    0x8(%ebp),%eax
  80304f:	6a 00                	push   $0x0
  803051:	6a 00                	push   $0x0
  803053:	51                   	push   %ecx
  803054:	52                   	push   %edx
  803055:	50                   	push   %eax
  803056:	6a 17                	push   $0x17
  803058:	e8 a8 fd ff ff       	call   802e05 <syscall>
  80305d:	83 c4 18             	add    $0x18,%esp
}
  803060:	c9                   	leave  
  803061:	c3                   	ret    

00803062 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803062:	55                   	push   %ebp
  803063:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803065:	8b 55 0c             	mov    0xc(%ebp),%edx
  803068:	8b 45 08             	mov    0x8(%ebp),%eax
  80306b:	6a 00                	push   $0x0
  80306d:	6a 00                	push   $0x0
  80306f:	6a 00                	push   $0x0
  803071:	52                   	push   %edx
  803072:	50                   	push   %eax
  803073:	6a 18                	push   $0x18
  803075:	e8 8b fd ff ff       	call   802e05 <syscall>
  80307a:	83 c4 18             	add    $0x18,%esp
}
  80307d:	c9                   	leave  
  80307e:	c3                   	ret    

0080307f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80307f:	55                   	push   %ebp
  803080:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803082:	8b 45 08             	mov    0x8(%ebp),%eax
  803085:	6a 00                	push   $0x0
  803087:	ff 75 14             	pushl  0x14(%ebp)
  80308a:	ff 75 10             	pushl  0x10(%ebp)
  80308d:	ff 75 0c             	pushl  0xc(%ebp)
  803090:	50                   	push   %eax
  803091:	6a 19                	push   $0x19
  803093:	e8 6d fd ff ff       	call   802e05 <syscall>
  803098:	83 c4 18             	add    $0x18,%esp
}
  80309b:	c9                   	leave  
  80309c:	c3                   	ret    

0080309d <sys_run_env>:

void sys_run_env(int32 envId)
{
  80309d:	55                   	push   %ebp
  80309e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8030a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a3:	6a 00                	push   $0x0
  8030a5:	6a 00                	push   $0x0
  8030a7:	6a 00                	push   $0x0
  8030a9:	6a 00                	push   $0x0
  8030ab:	50                   	push   %eax
  8030ac:	6a 1a                	push   $0x1a
  8030ae:	e8 52 fd ff ff       	call   802e05 <syscall>
  8030b3:	83 c4 18             	add    $0x18,%esp
}
  8030b6:	90                   	nop
  8030b7:	c9                   	leave  
  8030b8:	c3                   	ret    

008030b9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8030b9:	55                   	push   %ebp
  8030ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8030bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bf:	6a 00                	push   $0x0
  8030c1:	6a 00                	push   $0x0
  8030c3:	6a 00                	push   $0x0
  8030c5:	6a 00                	push   $0x0
  8030c7:	50                   	push   %eax
  8030c8:	6a 1b                	push   $0x1b
  8030ca:	e8 36 fd ff ff       	call   802e05 <syscall>
  8030cf:	83 c4 18             	add    $0x18,%esp
}
  8030d2:	c9                   	leave  
  8030d3:	c3                   	ret    

008030d4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8030d4:	55                   	push   %ebp
  8030d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8030d7:	6a 00                	push   $0x0
  8030d9:	6a 00                	push   $0x0
  8030db:	6a 00                	push   $0x0
  8030dd:	6a 00                	push   $0x0
  8030df:	6a 00                	push   $0x0
  8030e1:	6a 05                	push   $0x5
  8030e3:	e8 1d fd ff ff       	call   802e05 <syscall>
  8030e8:	83 c4 18             	add    $0x18,%esp
}
  8030eb:	c9                   	leave  
  8030ec:	c3                   	ret    

008030ed <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8030ed:	55                   	push   %ebp
  8030ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8030f0:	6a 00                	push   $0x0
  8030f2:	6a 00                	push   $0x0
  8030f4:	6a 00                	push   $0x0
  8030f6:	6a 00                	push   $0x0
  8030f8:	6a 00                	push   $0x0
  8030fa:	6a 06                	push   $0x6
  8030fc:	e8 04 fd ff ff       	call   802e05 <syscall>
  803101:	83 c4 18             	add    $0x18,%esp
}
  803104:	c9                   	leave  
  803105:	c3                   	ret    

00803106 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803106:	55                   	push   %ebp
  803107:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803109:	6a 00                	push   $0x0
  80310b:	6a 00                	push   $0x0
  80310d:	6a 00                	push   $0x0
  80310f:	6a 00                	push   $0x0
  803111:	6a 00                	push   $0x0
  803113:	6a 07                	push   $0x7
  803115:	e8 eb fc ff ff       	call   802e05 <syscall>
  80311a:	83 c4 18             	add    $0x18,%esp
}
  80311d:	c9                   	leave  
  80311e:	c3                   	ret    

0080311f <sys_exit_env>:


void sys_exit_env(void)
{
  80311f:	55                   	push   %ebp
  803120:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803122:	6a 00                	push   $0x0
  803124:	6a 00                	push   $0x0
  803126:	6a 00                	push   $0x0
  803128:	6a 00                	push   $0x0
  80312a:	6a 00                	push   $0x0
  80312c:	6a 1c                	push   $0x1c
  80312e:	e8 d2 fc ff ff       	call   802e05 <syscall>
  803133:	83 c4 18             	add    $0x18,%esp
}
  803136:	90                   	nop
  803137:	c9                   	leave  
  803138:	c3                   	ret    

00803139 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803139:	55                   	push   %ebp
  80313a:	89 e5                	mov    %esp,%ebp
  80313c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80313f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803142:	8d 50 04             	lea    0x4(%eax),%edx
  803145:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803148:	6a 00                	push   $0x0
  80314a:	6a 00                	push   $0x0
  80314c:	6a 00                	push   $0x0
  80314e:	52                   	push   %edx
  80314f:	50                   	push   %eax
  803150:	6a 1d                	push   $0x1d
  803152:	e8 ae fc ff ff       	call   802e05 <syscall>
  803157:	83 c4 18             	add    $0x18,%esp
	return result;
  80315a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80315d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803160:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803163:	89 01                	mov    %eax,(%ecx)
  803165:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803168:	8b 45 08             	mov    0x8(%ebp),%eax
  80316b:	c9                   	leave  
  80316c:	c2 04 00             	ret    $0x4

0080316f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80316f:	55                   	push   %ebp
  803170:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803172:	6a 00                	push   $0x0
  803174:	6a 00                	push   $0x0
  803176:	ff 75 10             	pushl  0x10(%ebp)
  803179:	ff 75 0c             	pushl  0xc(%ebp)
  80317c:	ff 75 08             	pushl  0x8(%ebp)
  80317f:	6a 13                	push   $0x13
  803181:	e8 7f fc ff ff       	call   802e05 <syscall>
  803186:	83 c4 18             	add    $0x18,%esp
	return ;
  803189:	90                   	nop
}
  80318a:	c9                   	leave  
  80318b:	c3                   	ret    

0080318c <sys_rcr2>:
uint32 sys_rcr2()
{
  80318c:	55                   	push   %ebp
  80318d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80318f:	6a 00                	push   $0x0
  803191:	6a 00                	push   $0x0
  803193:	6a 00                	push   $0x0
  803195:	6a 00                	push   $0x0
  803197:	6a 00                	push   $0x0
  803199:	6a 1e                	push   $0x1e
  80319b:	e8 65 fc ff ff       	call   802e05 <syscall>
  8031a0:	83 c4 18             	add    $0x18,%esp
}
  8031a3:	c9                   	leave  
  8031a4:	c3                   	ret    

008031a5 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8031a5:	55                   	push   %ebp
  8031a6:	89 e5                	mov    %esp,%ebp
  8031a8:	83 ec 04             	sub    $0x4,%esp
  8031ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ae:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8031b1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8031b5:	6a 00                	push   $0x0
  8031b7:	6a 00                	push   $0x0
  8031b9:	6a 00                	push   $0x0
  8031bb:	6a 00                	push   $0x0
  8031bd:	50                   	push   %eax
  8031be:	6a 1f                	push   $0x1f
  8031c0:	e8 40 fc ff ff       	call   802e05 <syscall>
  8031c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8031c8:	90                   	nop
}
  8031c9:	c9                   	leave  
  8031ca:	c3                   	ret    

008031cb <rsttst>:
void rsttst()
{
  8031cb:	55                   	push   %ebp
  8031cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8031ce:	6a 00                	push   $0x0
  8031d0:	6a 00                	push   $0x0
  8031d2:	6a 00                	push   $0x0
  8031d4:	6a 00                	push   $0x0
  8031d6:	6a 00                	push   $0x0
  8031d8:	6a 21                	push   $0x21
  8031da:	e8 26 fc ff ff       	call   802e05 <syscall>
  8031df:	83 c4 18             	add    $0x18,%esp
	return ;
  8031e2:	90                   	nop
}
  8031e3:	c9                   	leave  
  8031e4:	c3                   	ret    

008031e5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8031e5:	55                   	push   %ebp
  8031e6:	89 e5                	mov    %esp,%ebp
  8031e8:	83 ec 04             	sub    $0x4,%esp
  8031eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8031ee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8031f1:	8b 55 18             	mov    0x18(%ebp),%edx
  8031f4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8031f8:	52                   	push   %edx
  8031f9:	50                   	push   %eax
  8031fa:	ff 75 10             	pushl  0x10(%ebp)
  8031fd:	ff 75 0c             	pushl  0xc(%ebp)
  803200:	ff 75 08             	pushl  0x8(%ebp)
  803203:	6a 20                	push   $0x20
  803205:	e8 fb fb ff ff       	call   802e05 <syscall>
  80320a:	83 c4 18             	add    $0x18,%esp
	return ;
  80320d:	90                   	nop
}
  80320e:	c9                   	leave  
  80320f:	c3                   	ret    

00803210 <chktst>:
void chktst(uint32 n)
{
  803210:	55                   	push   %ebp
  803211:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803213:	6a 00                	push   $0x0
  803215:	6a 00                	push   $0x0
  803217:	6a 00                	push   $0x0
  803219:	6a 00                	push   $0x0
  80321b:	ff 75 08             	pushl  0x8(%ebp)
  80321e:	6a 22                	push   $0x22
  803220:	e8 e0 fb ff ff       	call   802e05 <syscall>
  803225:	83 c4 18             	add    $0x18,%esp
	return ;
  803228:	90                   	nop
}
  803229:	c9                   	leave  
  80322a:	c3                   	ret    

0080322b <inctst>:

void inctst()
{
  80322b:	55                   	push   %ebp
  80322c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80322e:	6a 00                	push   $0x0
  803230:	6a 00                	push   $0x0
  803232:	6a 00                	push   $0x0
  803234:	6a 00                	push   $0x0
  803236:	6a 00                	push   $0x0
  803238:	6a 23                	push   $0x23
  80323a:	e8 c6 fb ff ff       	call   802e05 <syscall>
  80323f:	83 c4 18             	add    $0x18,%esp
	return ;
  803242:	90                   	nop
}
  803243:	c9                   	leave  
  803244:	c3                   	ret    

00803245 <gettst>:
uint32 gettst()
{
  803245:	55                   	push   %ebp
  803246:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803248:	6a 00                	push   $0x0
  80324a:	6a 00                	push   $0x0
  80324c:	6a 00                	push   $0x0
  80324e:	6a 00                	push   $0x0
  803250:	6a 00                	push   $0x0
  803252:	6a 24                	push   $0x24
  803254:	e8 ac fb ff ff       	call   802e05 <syscall>
  803259:	83 c4 18             	add    $0x18,%esp
}
  80325c:	c9                   	leave  
  80325d:	c3                   	ret    

0080325e <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80325e:	55                   	push   %ebp
  80325f:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803261:	6a 00                	push   $0x0
  803263:	6a 00                	push   $0x0
  803265:	6a 00                	push   $0x0
  803267:	6a 00                	push   $0x0
  803269:	6a 00                	push   $0x0
  80326b:	6a 25                	push   $0x25
  80326d:	e8 93 fb ff ff       	call   802e05 <syscall>
  803272:	83 c4 18             	add    $0x18,%esp
  803275:	a3 60 e0 81 00       	mov    %eax,0x81e060
	return uheapPlaceStrategy ;
  80327a:	a1 60 e0 81 00       	mov    0x81e060,%eax
}
  80327f:	c9                   	leave  
  803280:	c3                   	ret    

00803281 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803281:	55                   	push   %ebp
  803282:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803284:	8b 45 08             	mov    0x8(%ebp),%eax
  803287:	a3 60 e0 81 00       	mov    %eax,0x81e060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80328c:	6a 00                	push   $0x0
  80328e:	6a 00                	push   $0x0
  803290:	6a 00                	push   $0x0
  803292:	6a 00                	push   $0x0
  803294:	ff 75 08             	pushl  0x8(%ebp)
  803297:	6a 26                	push   $0x26
  803299:	e8 67 fb ff ff       	call   802e05 <syscall>
  80329e:	83 c4 18             	add    $0x18,%esp
	return ;
  8032a1:	90                   	nop
}
  8032a2:	c9                   	leave  
  8032a3:	c3                   	ret    

008032a4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8032a4:	55                   	push   %ebp
  8032a5:	89 e5                	mov    %esp,%ebp
  8032a7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8032a8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8032ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8032ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b4:	6a 00                	push   $0x0
  8032b6:	53                   	push   %ebx
  8032b7:	51                   	push   %ecx
  8032b8:	52                   	push   %edx
  8032b9:	50                   	push   %eax
  8032ba:	6a 27                	push   $0x27
  8032bc:	e8 44 fb ff ff       	call   802e05 <syscall>
  8032c1:	83 c4 18             	add    $0x18,%esp
}
  8032c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032c7:	c9                   	leave  
  8032c8:	c3                   	ret    

008032c9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8032c9:	55                   	push   %ebp
  8032ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8032cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d2:	6a 00                	push   $0x0
  8032d4:	6a 00                	push   $0x0
  8032d6:	6a 00                	push   $0x0
  8032d8:	52                   	push   %edx
  8032d9:	50                   	push   %eax
  8032da:	6a 28                	push   $0x28
  8032dc:	e8 24 fb ff ff       	call   802e05 <syscall>
  8032e1:	83 c4 18             	add    $0x18,%esp
}
  8032e4:	c9                   	leave  
  8032e5:	c3                   	ret    

008032e6 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8032e6:	55                   	push   %ebp
  8032e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8032e9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8032ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f2:	6a 00                	push   $0x0
  8032f4:	51                   	push   %ecx
  8032f5:	ff 75 10             	pushl  0x10(%ebp)
  8032f8:	52                   	push   %edx
  8032f9:	50                   	push   %eax
  8032fa:	6a 29                	push   $0x29
  8032fc:	e8 04 fb ff ff       	call   802e05 <syscall>
  803301:	83 c4 18             	add    $0x18,%esp
}
  803304:	c9                   	leave  
  803305:	c3                   	ret    

00803306 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803306:	55                   	push   %ebp
  803307:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803309:	6a 00                	push   $0x0
  80330b:	6a 00                	push   $0x0
  80330d:	ff 75 10             	pushl  0x10(%ebp)
  803310:	ff 75 0c             	pushl  0xc(%ebp)
  803313:	ff 75 08             	pushl  0x8(%ebp)
  803316:	6a 12                	push   $0x12
  803318:	e8 e8 fa ff ff       	call   802e05 <syscall>
  80331d:	83 c4 18             	add    $0x18,%esp
	return ;
  803320:	90                   	nop
}
  803321:	c9                   	leave  
  803322:	c3                   	ret    

00803323 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803323:	55                   	push   %ebp
  803324:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803326:	8b 55 0c             	mov    0xc(%ebp),%edx
  803329:	8b 45 08             	mov    0x8(%ebp),%eax
  80332c:	6a 00                	push   $0x0
  80332e:	6a 00                	push   $0x0
  803330:	6a 00                	push   $0x0
  803332:	52                   	push   %edx
  803333:	50                   	push   %eax
  803334:	6a 2a                	push   $0x2a
  803336:	e8 ca fa ff ff       	call   802e05 <syscall>
  80333b:	83 c4 18             	add    $0x18,%esp
	return;
  80333e:	90                   	nop
}
  80333f:	c9                   	leave  
  803340:	c3                   	ret    

00803341 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803341:	55                   	push   %ebp
  803342:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803344:	6a 00                	push   $0x0
  803346:	6a 00                	push   $0x0
  803348:	6a 00                	push   $0x0
  80334a:	6a 00                	push   $0x0
  80334c:	6a 00                	push   $0x0
  80334e:	6a 2b                	push   $0x2b
  803350:	e8 b0 fa ff ff       	call   802e05 <syscall>
  803355:	83 c4 18             	add    $0x18,%esp
}
  803358:	c9                   	leave  
  803359:	c3                   	ret    

0080335a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80335a:	55                   	push   %ebp
  80335b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80335d:	6a 00                	push   $0x0
  80335f:	6a 00                	push   $0x0
  803361:	6a 00                	push   $0x0
  803363:	ff 75 0c             	pushl  0xc(%ebp)
  803366:	ff 75 08             	pushl  0x8(%ebp)
  803369:	6a 2d                	push   $0x2d
  80336b:	e8 95 fa ff ff       	call   802e05 <syscall>
  803370:	83 c4 18             	add    $0x18,%esp
	return;
  803373:	90                   	nop
}
  803374:	c9                   	leave  
  803375:	c3                   	ret    

00803376 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803376:	55                   	push   %ebp
  803377:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803379:	6a 00                	push   $0x0
  80337b:	6a 00                	push   $0x0
  80337d:	6a 00                	push   $0x0
  80337f:	ff 75 0c             	pushl  0xc(%ebp)
  803382:	ff 75 08             	pushl  0x8(%ebp)
  803385:	6a 2c                	push   $0x2c
  803387:	e8 79 fa ff ff       	call   802e05 <syscall>
  80338c:	83 c4 18             	add    $0x18,%esp
	return ;
  80338f:	90                   	nop
}
  803390:	c9                   	leave  
  803391:	c3                   	ret    

00803392 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803392:	55                   	push   %ebp
  803393:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803395:	8b 55 0c             	mov    0xc(%ebp),%edx
  803398:	8b 45 08             	mov    0x8(%ebp),%eax
  80339b:	6a 00                	push   $0x0
  80339d:	6a 00                	push   $0x0
  80339f:	6a 00                	push   $0x0
  8033a1:	52                   	push   %edx
  8033a2:	50                   	push   %eax
  8033a3:	6a 2e                	push   $0x2e
  8033a5:	e8 5b fa ff ff       	call   802e05 <syscall>
  8033aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8033ad:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  8033ae:	c9                   	leave  
  8033af:	c3                   	ret    

008033b0 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8033b0:	55                   	push   %ebp
  8033b1:	89 e5                	mov    %esp,%ebp
  8033b3:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8033b6:	81 7d 08 60 60 80 00 	cmpl   $0x806060,0x8(%ebp)
  8033bd:	72 09                	jb     8033c8 <to_page_va+0x18>
  8033bf:	81 7d 08 60 e0 81 00 	cmpl   $0x81e060,0x8(%ebp)
  8033c6:	72 14                	jb     8033dc <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8033c8:	83 ec 04             	sub    $0x4,%esp
  8033cb:	68 d4 53 80 00       	push   $0x8053d4
  8033d0:	6a 15                	push   $0x15
  8033d2:	68 ff 53 80 00       	push   $0x8053ff
  8033d7:	e8 46 d9 ff ff       	call   800d22 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8033dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033df:	ba 60 60 80 00       	mov    $0x806060,%edx
  8033e4:	29 d0                	sub    %edx,%eax
  8033e6:	c1 f8 02             	sar    $0x2,%eax
  8033e9:	89 c2                	mov    %eax,%edx
  8033eb:	89 d0                	mov    %edx,%eax
  8033ed:	c1 e0 02             	shl    $0x2,%eax
  8033f0:	01 d0                	add    %edx,%eax
  8033f2:	c1 e0 02             	shl    $0x2,%eax
  8033f5:	01 d0                	add    %edx,%eax
  8033f7:	c1 e0 02             	shl    $0x2,%eax
  8033fa:	01 d0                	add    %edx,%eax
  8033fc:	89 c1                	mov    %eax,%ecx
  8033fe:	c1 e1 08             	shl    $0x8,%ecx
  803401:	01 c8                	add    %ecx,%eax
  803403:	89 c1                	mov    %eax,%ecx
  803405:	c1 e1 10             	shl    $0x10,%ecx
  803408:	01 c8                	add    %ecx,%eax
  80340a:	01 c0                	add    %eax,%eax
  80340c:	01 d0                	add    %edx,%eax
  80340e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803414:	c1 e0 0c             	shl    $0xc,%eax
  803417:	89 c2                	mov    %eax,%edx
  803419:	a1 64 e0 81 00       	mov    0x81e064,%eax
  80341e:	01 d0                	add    %edx,%eax
}
  803420:	c9                   	leave  
  803421:	c3                   	ret    

00803422 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803422:	55                   	push   %ebp
  803423:	89 e5                	mov    %esp,%ebp
  803425:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803428:	a1 64 e0 81 00       	mov    0x81e064,%eax
  80342d:	8b 55 08             	mov    0x8(%ebp),%edx
  803430:	29 c2                	sub    %eax,%edx
  803432:	89 d0                	mov    %edx,%eax
  803434:	c1 e8 0c             	shr    $0xc,%eax
  803437:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  80343a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80343e:	78 09                	js     803449 <to_page_info+0x27>
  803440:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803447:	7e 14                	jle    80345d <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  803449:	83 ec 04             	sub    $0x4,%esp
  80344c:	68 18 54 80 00       	push   $0x805418
  803451:	6a 22                	push   $0x22
  803453:	68 ff 53 80 00       	push   $0x8053ff
  803458:	e8 c5 d8 ff ff       	call   800d22 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  80345d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803460:	89 d0                	mov    %edx,%eax
  803462:	01 c0                	add    %eax,%eax
  803464:	01 d0                	add    %edx,%eax
  803466:	c1 e0 02             	shl    $0x2,%eax
  803469:	05 60 60 80 00       	add    $0x806060,%eax
}
  80346e:	c9                   	leave  
  80346f:	c3                   	ret    

00803470 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803470:	55                   	push   %ebp
  803471:	89 e5                	mov    %esp,%ebp
  803473:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803476:	8b 45 08             	mov    0x8(%ebp),%eax
  803479:	05 00 00 00 02       	add    $0x2000000,%eax
  80347e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803481:	73 16                	jae    803499 <initialize_dynamic_allocator+0x29>
  803483:	68 3c 54 80 00       	push   $0x80543c
  803488:	68 62 54 80 00       	push   $0x805462
  80348d:	6a 34                	push   $0x34
  80348f:	68 ff 53 80 00       	push   $0x8053ff
  803494:	e8 89 d8 ff ff       	call   800d22 <_panic>
		is_initialized = 1;
  803499:	c7 05 34 60 80 00 01 	movl   $0x1,0x806034
  8034a0:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  8034a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a6:	a3 64 e0 81 00       	mov    %eax,0x81e064
	dynAllocEnd = daEnd;
  8034ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ae:	a3 40 60 80 00       	mov    %eax,0x806040

	LIST_INIT(&freePagesList);
  8034b3:	c7 05 48 60 80 00 00 	movl   $0x0,0x806048
  8034ba:	00 00 00 
  8034bd:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  8034c4:	00 00 00 
  8034c7:	c7 05 54 60 80 00 00 	movl   $0x0,0x806054
  8034ce:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  8034d1:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  8034d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8034df:	eb 36                	jmp    803517 <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  8034e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e4:	c1 e0 04             	shl    $0x4,%eax
  8034e7:	05 80 e0 81 00       	add    $0x81e080,%eax
  8034ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f5:	c1 e0 04             	shl    $0x4,%eax
  8034f8:	05 84 e0 81 00       	add    $0x81e084,%eax
  8034fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803506:	c1 e0 04             	shl    $0x4,%eax
  803509:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80350e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  803514:	ff 45 f4             	incl   -0xc(%ebp)
  803517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80351d:	72 c2                	jb     8034e1 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  80351f:	8b 15 40 60 80 00    	mov    0x806040,%edx
  803525:	a1 64 e0 81 00       	mov    0x81e064,%eax
  80352a:	29 c2                	sub    %eax,%edx
  80352c:	89 d0                	mov    %edx,%eax
  80352e:	c1 e8 0c             	shr    $0xc,%eax
  803531:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  803534:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80353b:	e9 c8 00 00 00       	jmp    803608 <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  803540:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803543:	89 d0                	mov    %edx,%eax
  803545:	01 c0                	add    %eax,%eax
  803547:	01 d0                	add    %edx,%eax
  803549:	c1 e0 02             	shl    $0x2,%eax
  80354c:	05 68 60 80 00       	add    $0x806068,%eax
  803551:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  803556:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803559:	89 d0                	mov    %edx,%eax
  80355b:	01 c0                	add    %eax,%eax
  80355d:	01 d0                	add    %edx,%eax
  80355f:	c1 e0 02             	shl    $0x2,%eax
  803562:	05 6a 60 80 00       	add    $0x80606a,%eax
  803567:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  80356c:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  803572:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803575:	89 c8                	mov    %ecx,%eax
  803577:	01 c0                	add    %eax,%eax
  803579:	01 c8                	add    %ecx,%eax
  80357b:	c1 e0 02             	shl    $0x2,%eax
  80357e:	05 64 60 80 00       	add    $0x806064,%eax
  803583:	89 10                	mov    %edx,(%eax)
  803585:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803588:	89 d0                	mov    %edx,%eax
  80358a:	01 c0                	add    %eax,%eax
  80358c:	01 d0                	add    %edx,%eax
  80358e:	c1 e0 02             	shl    $0x2,%eax
  803591:	05 64 60 80 00       	add    $0x806064,%eax
  803596:	8b 00                	mov    (%eax),%eax
  803598:	85 c0                	test   %eax,%eax
  80359a:	74 1b                	je     8035b7 <initialize_dynamic_allocator+0x147>
  80359c:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  8035a2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8035a5:	89 c8                	mov    %ecx,%eax
  8035a7:	01 c0                	add    %eax,%eax
  8035a9:	01 c8                	add    %ecx,%eax
  8035ab:	c1 e0 02             	shl    $0x2,%eax
  8035ae:	05 60 60 80 00       	add    $0x806060,%eax
  8035b3:	89 02                	mov    %eax,(%edx)
  8035b5:	eb 16                	jmp    8035cd <initialize_dynamic_allocator+0x15d>
  8035b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035ba:	89 d0                	mov    %edx,%eax
  8035bc:	01 c0                	add    %eax,%eax
  8035be:	01 d0                	add    %edx,%eax
  8035c0:	c1 e0 02             	shl    $0x2,%eax
  8035c3:	05 60 60 80 00       	add    $0x806060,%eax
  8035c8:	a3 48 60 80 00       	mov    %eax,0x806048
  8035cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035d0:	89 d0                	mov    %edx,%eax
  8035d2:	01 c0                	add    %eax,%eax
  8035d4:	01 d0                	add    %edx,%eax
  8035d6:	c1 e0 02             	shl    $0x2,%eax
  8035d9:	05 60 60 80 00       	add    $0x806060,%eax
  8035de:	a3 4c 60 80 00       	mov    %eax,0x80604c
  8035e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035e6:	89 d0                	mov    %edx,%eax
  8035e8:	01 c0                	add    %eax,%eax
  8035ea:	01 d0                	add    %edx,%eax
  8035ec:	c1 e0 02             	shl    $0x2,%eax
  8035ef:	05 60 60 80 00       	add    $0x806060,%eax
  8035f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035fa:	a1 54 60 80 00       	mov    0x806054,%eax
  8035ff:	40                   	inc    %eax
  803600:	a3 54 60 80 00       	mov    %eax,0x806054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  803605:	ff 45 f0             	incl   -0x10(%ebp)
  803608:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80360b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80360e:	0f 82 2c ff ff ff    	jb     803540 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803614:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803617:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80361a:	eb 2f                	jmp    80364b <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  80361c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80361f:	89 d0                	mov    %edx,%eax
  803621:	01 c0                	add    %eax,%eax
  803623:	01 d0                	add    %edx,%eax
  803625:	c1 e0 02             	shl    $0x2,%eax
  803628:	05 68 60 80 00       	add    $0x806068,%eax
  80362d:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  803632:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803635:	89 d0                	mov    %edx,%eax
  803637:	01 c0                	add    %eax,%eax
  803639:	01 d0                	add    %edx,%eax
  80363b:	c1 e0 02             	shl    $0x2,%eax
  80363e:	05 6a 60 80 00       	add    $0x80606a,%eax
  803643:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  803648:	ff 45 ec             	incl   -0x14(%ebp)
  80364b:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  803652:	76 c8                	jbe    80361c <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803654:	90                   	nop
  803655:	c9                   	leave  
  803656:	c3                   	ret    

00803657 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803657:	55                   	push   %ebp
  803658:	89 e5                	mov    %esp,%ebp
  80365a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  80365d:	8b 55 08             	mov    0x8(%ebp),%edx
  803660:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803665:	29 c2                	sub    %eax,%edx
  803667:	89 d0                	mov    %edx,%eax
  803669:	c1 e8 0c             	shr    $0xc,%eax
  80366c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  80366f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803672:	89 d0                	mov    %edx,%eax
  803674:	01 c0                	add    %eax,%eax
  803676:	01 d0                	add    %edx,%eax
  803678:	c1 e0 02             	shl    $0x2,%eax
  80367b:	05 68 60 80 00       	add    $0x806068,%eax
  803680:	8b 00                	mov    (%eax),%eax
  803682:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803685:	c9                   	leave  
  803686:	c3                   	ret    

00803687 <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803687:	55                   	push   %ebp
  803688:	89 e5                	mov    %esp,%ebp
  80368a:	83 ec 14             	sub    $0x14,%esp
  80368d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  803690:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803694:	77 07                	ja     80369d <nearest_pow2_ceil.1513+0x16>
  803696:	b8 01 00 00 00       	mov    $0x1,%eax
  80369b:	eb 20                	jmp    8036bd <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  80369d:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  8036a4:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  8036a7:	eb 08                	jmp    8036b1 <nearest_pow2_ceil.1513+0x2a>
  8036a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8036ac:	01 c0                	add    %eax,%eax
  8036ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8036b1:	d1 6d 08             	shrl   0x8(%ebp)
  8036b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036b8:	75 ef                	jne    8036a9 <nearest_pow2_ceil.1513+0x22>
        return power;
  8036ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  8036bd:	c9                   	leave  
  8036be:	c3                   	ret    

008036bf <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8036bf:	55                   	push   %ebp
  8036c0:	89 e5                	mov    %esp,%ebp
  8036c2:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8036c5:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8036cc:	76 16                	jbe    8036e4 <alloc_block+0x25>
  8036ce:	68 78 54 80 00       	push   $0x805478
  8036d3:	68 62 54 80 00       	push   $0x805462
  8036d8:	6a 72                	push   $0x72
  8036da:	68 ff 53 80 00       	push   $0x8053ff
  8036df:	e8 3e d6 ff ff       	call   800d22 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  8036e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036e8:	75 0a                	jne    8036f4 <alloc_block+0x35>
  8036ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8036ef:	e9 bd 04 00 00       	jmp    803bb1 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  8036f4:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  8036fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803701:	73 06                	jae    803709 <alloc_block+0x4a>
        size = min_block_size;
  803703:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803706:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  803709:	83 ec 0c             	sub    $0xc,%esp
  80370c:	8d 45 cc             	lea    -0x34(%ebp),%eax
  80370f:	ff 75 08             	pushl  0x8(%ebp)
  803712:	89 c1                	mov    %eax,%ecx
  803714:	e8 6e ff ff ff       	call   803687 <nearest_pow2_ceil.1513>
  803719:	83 c4 10             	add    $0x10,%esp
  80371c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  80371f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803722:	83 ec 0c             	sub    $0xc,%esp
  803725:	8d 45 cc             	lea    -0x34(%ebp),%eax
  803728:	52                   	push   %edx
  803729:	89 c1                	mov    %eax,%ecx
  80372b:	e8 83 04 00 00       	call   803bb3 <log2_ceil.1520>
  803730:	83 c4 10             	add    $0x10,%esp
  803733:	83 e8 03             	sub    $0x3,%eax
  803736:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  803739:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80373c:	c1 e0 04             	shl    $0x4,%eax
  80373f:	05 80 e0 81 00       	add    $0x81e080,%eax
  803744:	8b 00                	mov    (%eax),%eax
  803746:	85 c0                	test   %eax,%eax
  803748:	0f 84 d8 00 00 00    	je     803826 <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  80374e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803751:	c1 e0 04             	shl    $0x4,%eax
  803754:	05 80 e0 81 00       	add    $0x81e080,%eax
  803759:	8b 00                	mov    (%eax),%eax
  80375b:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  80375e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803762:	75 17                	jne    80377b <alloc_block+0xbc>
  803764:	83 ec 04             	sub    $0x4,%esp
  803767:	68 99 54 80 00       	push   $0x805499
  80376c:	68 98 00 00 00       	push   $0x98
  803771:	68 ff 53 80 00       	push   $0x8053ff
  803776:	e8 a7 d5 ff ff       	call   800d22 <_panic>
  80377b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80377e:	8b 00                	mov    (%eax),%eax
  803780:	85 c0                	test   %eax,%eax
  803782:	74 10                	je     803794 <alloc_block+0xd5>
  803784:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803787:	8b 00                	mov    (%eax),%eax
  803789:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80378c:	8b 52 04             	mov    0x4(%edx),%edx
  80378f:	89 50 04             	mov    %edx,0x4(%eax)
  803792:	eb 14                	jmp    8037a8 <alloc_block+0xe9>
  803794:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803797:	8b 40 04             	mov    0x4(%eax),%eax
  80379a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80379d:	c1 e2 04             	shl    $0x4,%edx
  8037a0:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  8037a6:	89 02                	mov    %eax,(%edx)
  8037a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037ab:	8b 40 04             	mov    0x4(%eax),%eax
  8037ae:	85 c0                	test   %eax,%eax
  8037b0:	74 0f                	je     8037c1 <alloc_block+0x102>
  8037b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037b5:	8b 40 04             	mov    0x4(%eax),%eax
  8037b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037bb:	8b 12                	mov    (%edx),%edx
  8037bd:	89 10                	mov    %edx,(%eax)
  8037bf:	eb 13                	jmp    8037d4 <alloc_block+0x115>
  8037c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037c4:	8b 00                	mov    (%eax),%eax
  8037c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037c9:	c1 e2 04             	shl    $0x4,%edx
  8037cc:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  8037d2:	89 02                	mov    %eax,(%edx)
  8037d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ea:	c1 e0 04             	shl    $0x4,%eax
  8037ed:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8037f2:	8b 00                	mov    (%eax),%eax
  8037f4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8037f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fa:	c1 e0 04             	shl    $0x4,%eax
  8037fd:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803802:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803804:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803807:	83 ec 0c             	sub    $0xc,%esp
  80380a:	50                   	push   %eax
  80380b:	e8 12 fc ff ff       	call   803422 <to_page_info>
  803810:	83 c4 10             	add    $0x10,%esp
  803813:	89 c2                	mov    %eax,%edx
  803815:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803819:	48                   	dec    %eax
  80381a:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  80381e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803821:	e9 8b 03 00 00       	jmp    803bb1 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  803826:	a1 48 60 80 00       	mov    0x806048,%eax
  80382b:	85 c0                	test   %eax,%eax
  80382d:	0f 84 64 02 00 00    	je     803a97 <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  803833:	a1 48 60 80 00       	mov    0x806048,%eax
  803838:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  80383b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80383f:	75 17                	jne    803858 <alloc_block+0x199>
  803841:	83 ec 04             	sub    $0x4,%esp
  803844:	68 99 54 80 00       	push   $0x805499
  803849:	68 a0 00 00 00       	push   $0xa0
  80384e:	68 ff 53 80 00       	push   $0x8053ff
  803853:	e8 ca d4 ff ff       	call   800d22 <_panic>
  803858:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80385b:	8b 00                	mov    (%eax),%eax
  80385d:	85 c0                	test   %eax,%eax
  80385f:	74 10                	je     803871 <alloc_block+0x1b2>
  803861:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803864:	8b 00                	mov    (%eax),%eax
  803866:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803869:	8b 52 04             	mov    0x4(%edx),%edx
  80386c:	89 50 04             	mov    %edx,0x4(%eax)
  80386f:	eb 0b                	jmp    80387c <alloc_block+0x1bd>
  803871:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803874:	8b 40 04             	mov    0x4(%eax),%eax
  803877:	a3 4c 60 80 00       	mov    %eax,0x80604c
  80387c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80387f:	8b 40 04             	mov    0x4(%eax),%eax
  803882:	85 c0                	test   %eax,%eax
  803884:	74 0f                	je     803895 <alloc_block+0x1d6>
  803886:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803889:	8b 40 04             	mov    0x4(%eax),%eax
  80388c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80388f:	8b 12                	mov    (%edx),%edx
  803891:	89 10                	mov    %edx,(%eax)
  803893:	eb 0a                	jmp    80389f <alloc_block+0x1e0>
  803895:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803898:	8b 00                	mov    (%eax),%eax
  80389a:	a3 48 60 80 00       	mov    %eax,0x806048
  80389f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038b2:	a1 54 60 80 00       	mov    0x806054,%eax
  8038b7:	48                   	dec    %eax
  8038b8:	a3 54 60 80 00       	mov    %eax,0x806054

        page_info_e->block_size = pow;
  8038bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038c3:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  8038c7:	b8 00 10 00 00       	mov    $0x1000,%eax
  8038cc:	99                   	cltd   
  8038cd:	f7 7d e8             	idivl  -0x18(%ebp)
  8038d0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038d3:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  8038d7:	83 ec 0c             	sub    $0xc,%esp
  8038da:	ff 75 dc             	pushl  -0x24(%ebp)
  8038dd:	e8 ce fa ff ff       	call   8033b0 <to_page_va>
  8038e2:	83 c4 10             	add    $0x10,%esp
  8038e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  8038e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8038eb:	83 ec 0c             	sub    $0xc,%esp
  8038ee:	50                   	push   %eax
  8038ef:	e8 c0 ee ff ff       	call   8027b4 <get_page>
  8038f4:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  8038f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8038fe:	e9 aa 00 00 00       	jmp    8039ad <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  803903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803906:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  80390a:	89 c2                	mov    %eax,%edx
  80390c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80390f:	01 d0                	add    %edx,%eax
  803911:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  803914:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803918:	75 17                	jne    803931 <alloc_block+0x272>
  80391a:	83 ec 04             	sub    $0x4,%esp
  80391d:	68 b8 54 80 00       	push   $0x8054b8
  803922:	68 aa 00 00 00       	push   $0xaa
  803927:	68 ff 53 80 00       	push   $0x8053ff
  80392c:	e8 f1 d3 ff ff       	call   800d22 <_panic>
  803931:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803934:	c1 e0 04             	shl    $0x4,%eax
  803937:	05 84 e0 81 00       	add    $0x81e084,%eax
  80393c:	8b 10                	mov    (%eax),%edx
  80393e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803941:	89 50 04             	mov    %edx,0x4(%eax)
  803944:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803947:	8b 40 04             	mov    0x4(%eax),%eax
  80394a:	85 c0                	test   %eax,%eax
  80394c:	74 14                	je     803962 <alloc_block+0x2a3>
  80394e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803951:	c1 e0 04             	shl    $0x4,%eax
  803954:	05 84 e0 81 00       	add    $0x81e084,%eax
  803959:	8b 00                	mov    (%eax),%eax
  80395b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80395e:	89 10                	mov    %edx,(%eax)
  803960:	eb 11                	jmp    803973 <alloc_block+0x2b4>
  803962:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803965:	c1 e0 04             	shl    $0x4,%eax
  803968:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  80396e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803971:	89 02                	mov    %eax,(%edx)
  803973:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803976:	c1 e0 04             	shl    $0x4,%eax
  803979:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  80397f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803982:	89 02                	mov    %eax,(%edx)
  803984:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803987:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80398d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803990:	c1 e0 04             	shl    $0x4,%eax
  803993:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803998:	8b 00                	mov    (%eax),%eax
  80399a:	8d 50 01             	lea    0x1(%eax),%edx
  80399d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a0:	c1 e0 04             	shl    $0x4,%eax
  8039a3:	05 8c e0 81 00       	add    $0x81e08c,%eax
  8039a8:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  8039aa:	ff 45 f4             	incl   -0xc(%ebp)
  8039ad:	b8 00 10 00 00       	mov    $0x1000,%eax
  8039b2:	99                   	cltd   
  8039b3:	f7 7d e8             	idivl  -0x18(%ebp)
  8039b6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8039b9:	0f 8f 44 ff ff ff    	jg     803903 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  8039bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c2:	c1 e0 04             	shl    $0x4,%eax
  8039c5:	05 80 e0 81 00       	add    $0x81e080,%eax
  8039ca:	8b 00                	mov    (%eax),%eax
  8039cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  8039cf:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8039d3:	75 17                	jne    8039ec <alloc_block+0x32d>
  8039d5:	83 ec 04             	sub    $0x4,%esp
  8039d8:	68 99 54 80 00       	push   $0x805499
  8039dd:	68 ae 00 00 00       	push   $0xae
  8039e2:	68 ff 53 80 00       	push   $0x8053ff
  8039e7:	e8 36 d3 ff ff       	call   800d22 <_panic>
  8039ec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039ef:	8b 00                	mov    (%eax),%eax
  8039f1:	85 c0                	test   %eax,%eax
  8039f3:	74 10                	je     803a05 <alloc_block+0x346>
  8039f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039f8:	8b 00                	mov    (%eax),%eax
  8039fa:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8039fd:	8b 52 04             	mov    0x4(%edx),%edx
  803a00:	89 50 04             	mov    %edx,0x4(%eax)
  803a03:	eb 14                	jmp    803a19 <alloc_block+0x35a>
  803a05:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a08:	8b 40 04             	mov    0x4(%eax),%eax
  803a0b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a0e:	c1 e2 04             	shl    $0x4,%edx
  803a11:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803a17:	89 02                	mov    %eax,(%edx)
  803a19:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a1c:	8b 40 04             	mov    0x4(%eax),%eax
  803a1f:	85 c0                	test   %eax,%eax
  803a21:	74 0f                	je     803a32 <alloc_block+0x373>
  803a23:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a26:	8b 40 04             	mov    0x4(%eax),%eax
  803a29:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803a2c:	8b 12                	mov    (%edx),%edx
  803a2e:	89 10                	mov    %edx,(%eax)
  803a30:	eb 13                	jmp    803a45 <alloc_block+0x386>
  803a32:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a35:	8b 00                	mov    (%eax),%eax
  803a37:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a3a:	c1 e2 04             	shl    $0x4,%edx
  803a3d:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803a43:	89 02                	mov    %eax,(%edx)
  803a45:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a4e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a5b:	c1 e0 04             	shl    $0x4,%eax
  803a5e:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803a63:	8b 00                	mov    (%eax),%eax
  803a65:	8d 50 ff             	lea    -0x1(%eax),%edx
  803a68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a6b:	c1 e0 04             	shl    $0x4,%eax
  803a6e:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803a73:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  803a75:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a78:	83 ec 0c             	sub    $0xc,%esp
  803a7b:	50                   	push   %eax
  803a7c:	e8 a1 f9 ff ff       	call   803422 <to_page_info>
  803a81:	83 c4 10             	add    $0x10,%esp
  803a84:	89 c2                	mov    %eax,%edx
  803a86:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803a8a:	48                   	dec    %eax
  803a8b:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  803a8f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a92:	e9 1a 01 00 00       	jmp    803bb1 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  803a97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a9a:	40                   	inc    %eax
  803a9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803a9e:	e9 ed 00 00 00       	jmp    803b90 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  803aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aa6:	c1 e0 04             	shl    $0x4,%eax
  803aa9:	05 80 e0 81 00       	add    $0x81e080,%eax
  803aae:	8b 00                	mov    (%eax),%eax
  803ab0:	85 c0                	test   %eax,%eax
  803ab2:	0f 84 d5 00 00 00    	je     803b8d <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  803ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803abb:	c1 e0 04             	shl    $0x4,%eax
  803abe:	05 80 e0 81 00       	add    $0x81e080,%eax
  803ac3:	8b 00                	mov    (%eax),%eax
  803ac5:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  803ac8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803acc:	75 17                	jne    803ae5 <alloc_block+0x426>
  803ace:	83 ec 04             	sub    $0x4,%esp
  803ad1:	68 99 54 80 00       	push   $0x805499
  803ad6:	68 b8 00 00 00       	push   $0xb8
  803adb:	68 ff 53 80 00       	push   $0x8053ff
  803ae0:	e8 3d d2 ff ff       	call   800d22 <_panic>
  803ae5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ae8:	8b 00                	mov    (%eax),%eax
  803aea:	85 c0                	test   %eax,%eax
  803aec:	74 10                	je     803afe <alloc_block+0x43f>
  803aee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803af1:	8b 00                	mov    (%eax),%eax
  803af3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803af6:	8b 52 04             	mov    0x4(%edx),%edx
  803af9:	89 50 04             	mov    %edx,0x4(%eax)
  803afc:	eb 14                	jmp    803b12 <alloc_block+0x453>
  803afe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803b01:	8b 40 04             	mov    0x4(%eax),%eax
  803b04:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b07:	c1 e2 04             	shl    $0x4,%edx
  803b0a:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803b10:	89 02                	mov    %eax,(%edx)
  803b12:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803b15:	8b 40 04             	mov    0x4(%eax),%eax
  803b18:	85 c0                	test   %eax,%eax
  803b1a:	74 0f                	je     803b2b <alloc_block+0x46c>
  803b1c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803b1f:	8b 40 04             	mov    0x4(%eax),%eax
  803b22:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803b25:	8b 12                	mov    (%edx),%edx
  803b27:	89 10                	mov    %edx,(%eax)
  803b29:	eb 13                	jmp    803b3e <alloc_block+0x47f>
  803b2b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803b2e:	8b 00                	mov    (%eax),%eax
  803b30:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b33:	c1 e2 04             	shl    $0x4,%edx
  803b36:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803b3c:	89 02                	mov    %eax,(%edx)
  803b3e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803b41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b47:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803b4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b54:	c1 e0 04             	shl    $0x4,%eax
  803b57:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803b5c:	8b 00                	mov    (%eax),%eax
  803b5e:	8d 50 ff             	lea    -0x1(%eax),%edx
  803b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b64:	c1 e0 04             	shl    $0x4,%eax
  803b67:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803b6c:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  803b6e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803b71:	83 ec 0c             	sub    $0xc,%esp
  803b74:	50                   	push   %eax
  803b75:	e8 a8 f8 ff ff       	call   803422 <to_page_info>
  803b7a:	83 c4 10             	add    $0x10,%esp
  803b7d:	89 c2                	mov    %eax,%edx
  803b7f:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803b83:	48                   	dec    %eax
  803b84:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  803b88:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803b8b:	eb 24                	jmp    803bb1 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  803b8d:	ff 45 f0             	incl   -0x10(%ebp)
  803b90:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  803b94:	0f 8e 09 ff ff ff    	jle    803aa3 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  803b9a:	83 ec 04             	sub    $0x4,%esp
  803b9d:	68 db 54 80 00       	push   $0x8054db
  803ba2:	68 bf 00 00 00       	push   $0xbf
  803ba7:	68 ff 53 80 00       	push   $0x8053ff
  803bac:	e8 71 d1 ff ff       	call   800d22 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803bb1:	c9                   	leave  
  803bb2:	c3                   	ret    

00803bb3 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  803bb3:	55                   	push   %ebp
  803bb4:	89 e5                	mov    %esp,%ebp
  803bb6:	83 ec 14             	sub    $0x14,%esp
  803bb9:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  803bbc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bc0:	75 07                	jne    803bc9 <log2_ceil.1520+0x16>
  803bc2:	b8 00 00 00 00       	mov    $0x0,%eax
  803bc7:	eb 1b                	jmp    803be4 <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  803bc9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  803bd0:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  803bd3:	eb 06                	jmp    803bdb <log2_ceil.1520+0x28>
            x >>= 1;
  803bd5:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  803bd8:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  803bdb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bdf:	75 f4                	jne    803bd5 <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  803be1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  803be4:	c9                   	leave  
  803be5:	c3                   	ret    

00803be6 <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  803be6:	55                   	push   %ebp
  803be7:	89 e5                	mov    %esp,%ebp
  803be9:	83 ec 14             	sub    $0x14,%esp
  803bec:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  803bef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bf3:	75 07                	jne    803bfc <log2_ceil.1547+0x16>
  803bf5:	b8 00 00 00 00       	mov    $0x0,%eax
  803bfa:	eb 1b                	jmp    803c17 <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  803bfc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  803c03:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  803c06:	eb 06                	jmp    803c0e <log2_ceil.1547+0x28>
			x >>= 1;
  803c08:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  803c0b:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  803c0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c12:	75 f4                	jne    803c08 <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  803c14:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  803c17:	c9                   	leave  
  803c18:	c3                   	ret    

00803c19 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803c19:	55                   	push   %ebp
  803c1a:	89 e5                	mov    %esp,%ebp
  803c1c:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803c1f:	8b 55 08             	mov    0x8(%ebp),%edx
  803c22:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803c27:	39 c2                	cmp    %eax,%edx
  803c29:	72 0c                	jb     803c37 <free_block+0x1e>
  803c2b:	8b 55 08             	mov    0x8(%ebp),%edx
  803c2e:	a1 40 60 80 00       	mov    0x806040,%eax
  803c33:	39 c2                	cmp    %eax,%edx
  803c35:	72 19                	jb     803c50 <free_block+0x37>
  803c37:	68 e0 54 80 00       	push   $0x8054e0
  803c3c:	68 62 54 80 00       	push   $0x805462
  803c41:	68 d0 00 00 00       	push   $0xd0
  803c46:	68 ff 53 80 00       	push   $0x8053ff
  803c4b:	e8 d2 d0 ff ff       	call   800d22 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803c50:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c54:	0f 84 42 03 00 00    	je     803f9c <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  803c5a:	8b 55 08             	mov    0x8(%ebp),%edx
  803c5d:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803c62:	39 c2                	cmp    %eax,%edx
  803c64:	72 0c                	jb     803c72 <free_block+0x59>
  803c66:	8b 55 08             	mov    0x8(%ebp),%edx
  803c69:	a1 40 60 80 00       	mov    0x806040,%eax
  803c6e:	39 c2                	cmp    %eax,%edx
  803c70:	72 17                	jb     803c89 <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  803c72:	83 ec 04             	sub    $0x4,%esp
  803c75:	68 18 55 80 00       	push   $0x805518
  803c7a:	68 e6 00 00 00       	push   $0xe6
  803c7f:	68 ff 53 80 00       	push   $0x8053ff
  803c84:	e8 99 d0 ff ff       	call   800d22 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  803c89:	8b 55 08             	mov    0x8(%ebp),%edx
  803c8c:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803c91:	29 c2                	sub    %eax,%edx
  803c93:	89 d0                	mov    %edx,%eax
  803c95:	83 e0 07             	and    $0x7,%eax
  803c98:	85 c0                	test   %eax,%eax
  803c9a:	74 17                	je     803cb3 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  803c9c:	83 ec 04             	sub    $0x4,%esp
  803c9f:	68 4c 55 80 00       	push   $0x80554c
  803ca4:	68 ea 00 00 00       	push   $0xea
  803ca9:	68 ff 53 80 00       	push   $0x8053ff
  803cae:	e8 6f d0 ff ff       	call   800d22 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  803cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb6:	83 ec 0c             	sub    $0xc,%esp
  803cb9:	50                   	push   %eax
  803cba:	e8 63 f7 ff ff       	call   803422 <to_page_info>
  803cbf:	83 c4 10             	add    $0x10,%esp
  803cc2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  803cc5:	83 ec 0c             	sub    $0xc,%esp
  803cc8:	ff 75 08             	pushl  0x8(%ebp)
  803ccb:	e8 87 f9 ff ff       	call   803657 <get_block_size>
  803cd0:	83 c4 10             	add    $0x10,%esp
  803cd3:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  803cd6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803cda:	75 17                	jne    803cf3 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  803cdc:	83 ec 04             	sub    $0x4,%esp
  803cdf:	68 78 55 80 00       	push   $0x805578
  803ce4:	68 f1 00 00 00       	push   $0xf1
  803ce9:	68 ff 53 80 00       	push   $0x8053ff
  803cee:	e8 2f d0 ff ff       	call   800d22 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  803cf3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803cf6:	83 ec 0c             	sub    $0xc,%esp
  803cf9:	8d 45 d0             	lea    -0x30(%ebp),%eax
  803cfc:	52                   	push   %edx
  803cfd:	89 c1                	mov    %eax,%ecx
  803cff:	e8 e2 fe ff ff       	call   803be6 <log2_ceil.1547>
  803d04:	83 c4 10             	add    $0x10,%esp
  803d07:	83 e8 03             	sub    $0x3,%eax
  803d0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  803d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  803d10:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  803d13:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803d17:	75 17                	jne    803d30 <free_block+0x117>
  803d19:	83 ec 04             	sub    $0x4,%esp
  803d1c:	68 c4 55 80 00       	push   $0x8055c4
  803d21:	68 f6 00 00 00       	push   $0xf6
  803d26:	68 ff 53 80 00       	push   $0x8053ff
  803d2b:	e8 f2 cf ff ff       	call   800d22 <_panic>
  803d30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d33:	c1 e0 04             	shl    $0x4,%eax
  803d36:	05 80 e0 81 00       	add    $0x81e080,%eax
  803d3b:	8b 10                	mov    (%eax),%edx
  803d3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d40:	89 10                	mov    %edx,(%eax)
  803d42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d45:	8b 00                	mov    (%eax),%eax
  803d47:	85 c0                	test   %eax,%eax
  803d49:	74 15                	je     803d60 <free_block+0x147>
  803d4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d4e:	c1 e0 04             	shl    $0x4,%eax
  803d51:	05 80 e0 81 00       	add    $0x81e080,%eax
  803d56:	8b 00                	mov    (%eax),%eax
  803d58:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d5b:	89 50 04             	mov    %edx,0x4(%eax)
  803d5e:	eb 11                	jmp    803d71 <free_block+0x158>
  803d60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d63:	c1 e0 04             	shl    $0x4,%eax
  803d66:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  803d6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d6f:	89 02                	mov    %eax,(%edx)
  803d71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d74:	c1 e0 04             	shl    $0x4,%eax
  803d77:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  803d7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d80:	89 02                	mov    %eax,(%edx)
  803d82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d8f:	c1 e0 04             	shl    $0x4,%eax
  803d92:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803d97:	8b 00                	mov    (%eax),%eax
  803d99:	8d 50 01             	lea    0x1(%eax),%edx
  803d9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d9f:	c1 e0 04             	shl    $0x4,%eax
  803da2:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803da7:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  803da9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dac:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803db0:	40                   	inc    %eax
  803db1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803db4:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  803db8:	8b 55 08             	mov    0x8(%ebp),%edx
  803dbb:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803dc0:	29 c2                	sub    %eax,%edx
  803dc2:	89 d0                	mov    %edx,%eax
  803dc4:	c1 e8 0c             	shr    $0xc,%eax
  803dc7:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  803dca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dcd:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803dd1:	0f b7 c8             	movzwl %ax,%ecx
  803dd4:	b8 00 10 00 00       	mov    $0x1000,%eax
  803dd9:	99                   	cltd   
  803dda:	f7 7d e8             	idivl  -0x18(%ebp)
  803ddd:	39 c1                	cmp    %eax,%ecx
  803ddf:	0f 85 b8 01 00 00    	jne    803f9d <free_block+0x384>
    	uint32 blocks_removed = 0;
  803de5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  803dec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803def:	c1 e0 04             	shl    $0x4,%eax
  803df2:	05 80 e0 81 00       	add    $0x81e080,%eax
  803df7:	8b 00                	mov    (%eax),%eax
  803df9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803dfc:	e9 d5 00 00 00       	jmp    803ed6 <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  803e01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e04:	8b 00                	mov    (%eax),%eax
  803e06:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  803e09:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e0c:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803e11:	29 c2                	sub    %eax,%edx
  803e13:	89 d0                	mov    %edx,%eax
  803e15:	c1 e8 0c             	shr    $0xc,%eax
  803e18:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  803e1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e1e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803e21:	0f 85 a9 00 00 00    	jne    803ed0 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  803e27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e2b:	75 17                	jne    803e44 <free_block+0x22b>
  803e2d:	83 ec 04             	sub    $0x4,%esp
  803e30:	68 99 54 80 00       	push   $0x805499
  803e35:	68 04 01 00 00       	push   $0x104
  803e3a:	68 ff 53 80 00       	push   $0x8053ff
  803e3f:	e8 de ce ff ff       	call   800d22 <_panic>
  803e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e47:	8b 00                	mov    (%eax),%eax
  803e49:	85 c0                	test   %eax,%eax
  803e4b:	74 10                	je     803e5d <free_block+0x244>
  803e4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e50:	8b 00                	mov    (%eax),%eax
  803e52:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e55:	8b 52 04             	mov    0x4(%edx),%edx
  803e58:	89 50 04             	mov    %edx,0x4(%eax)
  803e5b:	eb 14                	jmp    803e71 <free_block+0x258>
  803e5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e60:	8b 40 04             	mov    0x4(%eax),%eax
  803e63:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e66:	c1 e2 04             	shl    $0x4,%edx
  803e69:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803e6f:	89 02                	mov    %eax,(%edx)
  803e71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e74:	8b 40 04             	mov    0x4(%eax),%eax
  803e77:	85 c0                	test   %eax,%eax
  803e79:	74 0f                	je     803e8a <free_block+0x271>
  803e7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e7e:	8b 40 04             	mov    0x4(%eax),%eax
  803e81:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e84:	8b 12                	mov    (%edx),%edx
  803e86:	89 10                	mov    %edx,(%eax)
  803e88:	eb 13                	jmp    803e9d <free_block+0x284>
  803e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e8d:	8b 00                	mov    (%eax),%eax
  803e8f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e92:	c1 e2 04             	shl    $0x4,%edx
  803e95:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803e9b:	89 02                	mov    %eax,(%edx)
  803e9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ea0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ea9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803eb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eb3:	c1 e0 04             	shl    $0x4,%eax
  803eb6:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803ebb:	8b 00                	mov    (%eax),%eax
  803ebd:	8d 50 ff             	lea    -0x1(%eax),%edx
  803ec0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ec3:	c1 e0 04             	shl    $0x4,%eax
  803ec6:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803ecb:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  803ecd:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  803ed0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803ed3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  803ed6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803eda:	0f 85 21 ff ff ff    	jne    803e01 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  803ee0:	b8 00 10 00 00       	mov    $0x1000,%eax
  803ee5:	99                   	cltd   
  803ee6:	f7 7d e8             	idivl  -0x18(%ebp)
  803ee9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803eec:	74 17                	je     803f05 <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  803eee:	83 ec 04             	sub    $0x4,%esp
  803ef1:	68 e8 55 80 00       	push   $0x8055e8
  803ef6:	68 0c 01 00 00       	push   $0x10c
  803efb:	68 ff 53 80 00       	push   $0x8053ff
  803f00:	e8 1d ce ff ff       	call   800d22 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  803f05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f08:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  803f0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f11:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  803f17:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803f1b:	75 17                	jne    803f34 <free_block+0x31b>
  803f1d:	83 ec 04             	sub    $0x4,%esp
  803f20:	68 b8 54 80 00       	push   $0x8054b8
  803f25:	68 11 01 00 00       	push   $0x111
  803f2a:	68 ff 53 80 00       	push   $0x8053ff
  803f2f:	e8 ee cd ff ff       	call   800d22 <_panic>
  803f34:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  803f3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f3d:	89 50 04             	mov    %edx,0x4(%eax)
  803f40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f43:	8b 40 04             	mov    0x4(%eax),%eax
  803f46:	85 c0                	test   %eax,%eax
  803f48:	74 0c                	je     803f56 <free_block+0x33d>
  803f4a:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803f4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f52:	89 10                	mov    %edx,(%eax)
  803f54:	eb 08                	jmp    803f5e <free_block+0x345>
  803f56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f59:	a3 48 60 80 00       	mov    %eax,0x806048
  803f5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f61:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803f66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f6f:	a1 54 60 80 00       	mov    0x806054,%eax
  803f74:	40                   	inc    %eax
  803f75:	a3 54 60 80 00       	mov    %eax,0x806054

        uint32 pp = to_page_va(page_info_e);
  803f7a:	83 ec 0c             	sub    $0xc,%esp
  803f7d:	ff 75 ec             	pushl  -0x14(%ebp)
  803f80:	e8 2b f4 ff ff       	call   8033b0 <to_page_va>
  803f85:	83 c4 10             	add    $0x10,%esp
  803f88:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  803f8b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f8e:	83 ec 0c             	sub    $0xc,%esp
  803f91:	50                   	push   %eax
  803f92:	e8 69 e8 ff ff       	call   802800 <return_page>
  803f97:	83 c4 10             	add    $0x10,%esp
  803f9a:	eb 01                	jmp    803f9d <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803f9c:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803f9d:	c9                   	leave  
  803f9e:	c3                   	ret    

00803f9f <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803f9f:	55                   	push   %ebp
  803fa0:	89 e5                	mov    %esp,%ebp
  803fa2:	83 ec 14             	sub    $0x14,%esp
  803fa5:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  803fa8:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803fac:	77 07                	ja     803fb5 <nearest_pow2_ceil.1572+0x16>
      return 1;
  803fae:	b8 01 00 00 00       	mov    $0x1,%eax
  803fb3:	eb 20                	jmp    803fd5 <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  803fb5:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  803fbc:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  803fbf:	eb 08                	jmp    803fc9 <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  803fc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803fc4:	01 c0                	add    %eax,%eax
  803fc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  803fc9:	d1 6d 08             	shrl   0x8(%ebp)
  803fcc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803fd0:	75 ef                	jne    803fc1 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  803fd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  803fd5:	c9                   	leave  
  803fd6:	c3                   	ret    

00803fd7 <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  803fd7:	55                   	push   %ebp
  803fd8:	89 e5                	mov    %esp,%ebp
  803fda:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  803fdd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803fe1:	75 13                	jne    803ff6 <realloc_block+0x1f>
    return alloc_block(new_size);
  803fe3:	83 ec 0c             	sub    $0xc,%esp
  803fe6:	ff 75 0c             	pushl  0xc(%ebp)
  803fe9:	e8 d1 f6 ff ff       	call   8036bf <alloc_block>
  803fee:	83 c4 10             	add    $0x10,%esp
  803ff1:	e9 d9 00 00 00       	jmp    8040cf <realloc_block+0xf8>
  }

  if (new_size == 0) {
  803ff6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803ffa:	75 18                	jne    804014 <realloc_block+0x3d>
    free_block(va);
  803ffc:	83 ec 0c             	sub    $0xc,%esp
  803fff:	ff 75 08             	pushl  0x8(%ebp)
  804002:	e8 12 fc ff ff       	call   803c19 <free_block>
  804007:	83 c4 10             	add    $0x10,%esp
    return NULL;
  80400a:	b8 00 00 00 00       	mov    $0x0,%eax
  80400f:	e9 bb 00 00 00       	jmp    8040cf <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  804014:	83 ec 0c             	sub    $0xc,%esp
  804017:	ff 75 08             	pushl  0x8(%ebp)
  80401a:	e8 38 f6 ff ff       	call   803657 <get_block_size>
  80401f:	83 c4 10             	add    $0x10,%esp
  804022:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  804025:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  80402c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80402f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  804032:	73 06                	jae    80403a <realloc_block+0x63>
    new_size = min_block_size;
  804034:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804037:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  80403a:	83 ec 0c             	sub    $0xc,%esp
  80403d:	8d 45 d8             	lea    -0x28(%ebp),%eax
  804040:	ff 75 0c             	pushl  0xc(%ebp)
  804043:	89 c1                	mov    %eax,%ecx
  804045:	e8 55 ff ff ff       	call   803f9f <nearest_pow2_ceil.1572>
  80404a:	83 c4 10             	add    $0x10,%esp
  80404d:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  804050:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804053:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  804056:	75 05                	jne    80405d <realloc_block+0x86>
    return va;
  804058:	8b 45 08             	mov    0x8(%ebp),%eax
  80405b:	eb 72                	jmp    8040cf <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  80405d:	83 ec 0c             	sub    $0xc,%esp
  804060:	ff 75 0c             	pushl  0xc(%ebp)
  804063:	e8 57 f6 ff ff       	call   8036bf <alloc_block>
  804068:	83 c4 10             	add    $0x10,%esp
  80406b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  80406e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804072:	75 07                	jne    80407b <realloc_block+0xa4>
    return NULL;
  804074:	b8 00 00 00 00       	mov    $0x0,%eax
  804079:	eb 54                	jmp    8040cf <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  80407b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80407e:	8b 45 0c             	mov    0xc(%ebp),%eax
  804081:	39 d0                	cmp    %edx,%eax
  804083:	76 02                	jbe    804087 <realloc_block+0xb0>
  804085:	89 d0                	mov    %edx,%eax
  804087:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  80408a:	8b 45 08             	mov    0x8(%ebp),%eax
  80408d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  804090:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804093:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  804096:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80409d:	eb 17                	jmp    8040b6 <realloc_block+0xdf>
    dst[i] = src[i];
  80409f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8040a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040a5:	01 c2                	add    %eax,%edx
  8040a7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8040aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040ad:	01 c8                	add    %ecx,%eax
  8040af:	8a 00                	mov    (%eax),%al
  8040b1:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  8040b3:	ff 45 f4             	incl   -0xc(%ebp)
  8040b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040b9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8040bc:	72 e1                	jb     80409f <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  8040be:	83 ec 0c             	sub    $0xc,%esp
  8040c1:	ff 75 08             	pushl  0x8(%ebp)
  8040c4:	e8 50 fb ff ff       	call   803c19 <free_block>
  8040c9:	83 c4 10             	add    $0x10,%esp

  return new_va;
  8040cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8040cf:	c9                   	leave  
  8040d0:	c3                   	ret    
  8040d1:	66 90                	xchg   %ax,%ax
  8040d3:	90                   	nop

008040d4 <__divdi3>:
  8040d4:	55                   	push   %ebp
  8040d5:	57                   	push   %edi
  8040d6:	56                   	push   %esi
  8040d7:	53                   	push   %ebx
  8040d8:	83 ec 1c             	sub    $0x1c,%esp
  8040db:	8b 44 24 30          	mov    0x30(%esp),%eax
  8040df:	8b 54 24 34          	mov    0x34(%esp),%edx
  8040e3:	8b 74 24 38          	mov    0x38(%esp),%esi
  8040e7:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  8040eb:	89 f9                	mov    %edi,%ecx
  8040ed:	85 d2                	test   %edx,%edx
  8040ef:	0f 88 bb 00 00 00    	js     8041b0 <__divdi3+0xdc>
  8040f5:	31 ed                	xor    %ebp,%ebp
  8040f7:	85 c9                	test   %ecx,%ecx
  8040f9:	0f 88 99 00 00 00    	js     804198 <__divdi3+0xc4>
  8040ff:	89 34 24             	mov    %esi,(%esp)
  804102:	89 7c 24 04          	mov    %edi,0x4(%esp)
  804106:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80410a:	89 d3                	mov    %edx,%ebx
  80410c:	8b 34 24             	mov    (%esp),%esi
  80410f:	8b 7c 24 04          	mov    0x4(%esp),%edi
  804113:	89 74 24 08          	mov    %esi,0x8(%esp)
  804117:	8b 34 24             	mov    (%esp),%esi
  80411a:	89 c1                	mov    %eax,%ecx
  80411c:	85 ff                	test   %edi,%edi
  80411e:	75 10                	jne    804130 <__divdi3+0x5c>
  804120:	8b 7c 24 08          	mov    0x8(%esp),%edi
  804124:	39 d7                	cmp    %edx,%edi
  804126:	76 4c                	jbe    804174 <__divdi3+0xa0>
  804128:	f7 f7                	div    %edi
  80412a:	89 c1                	mov    %eax,%ecx
  80412c:	31 f6                	xor    %esi,%esi
  80412e:	eb 08                	jmp    804138 <__divdi3+0x64>
  804130:	39 d7                	cmp    %edx,%edi
  804132:	76 1c                	jbe    804150 <__divdi3+0x7c>
  804134:	31 f6                	xor    %esi,%esi
  804136:	31 c9                	xor    %ecx,%ecx
  804138:	89 c8                	mov    %ecx,%eax
  80413a:	89 f2                	mov    %esi,%edx
  80413c:	85 ed                	test   %ebp,%ebp
  80413e:	74 07                	je     804147 <__divdi3+0x73>
  804140:	f7 d8                	neg    %eax
  804142:	83 d2 00             	adc    $0x0,%edx
  804145:	f7 da                	neg    %edx
  804147:	83 c4 1c             	add    $0x1c,%esp
  80414a:	5b                   	pop    %ebx
  80414b:	5e                   	pop    %esi
  80414c:	5f                   	pop    %edi
  80414d:	5d                   	pop    %ebp
  80414e:	c3                   	ret    
  80414f:	90                   	nop
  804150:	0f bd f7             	bsr    %edi,%esi
  804153:	83 f6 1f             	xor    $0x1f,%esi
  804156:	75 6c                	jne    8041c4 <__divdi3+0xf0>
  804158:	39 d7                	cmp    %edx,%edi
  80415a:	72 0e                	jb     80416a <__divdi3+0x96>
  80415c:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  804160:	39 7c 24 08          	cmp    %edi,0x8(%esp)
  804164:	0f 87 ca 00 00 00    	ja     804234 <__divdi3+0x160>
  80416a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80416f:	eb c7                	jmp    804138 <__divdi3+0x64>
  804171:	8d 76 00             	lea    0x0(%esi),%esi
  804174:	85 f6                	test   %esi,%esi
  804176:	75 0b                	jne    804183 <__divdi3+0xaf>
  804178:	b8 01 00 00 00       	mov    $0x1,%eax
  80417d:	31 d2                	xor    %edx,%edx
  80417f:	f7 f6                	div    %esi
  804181:	89 c6                	mov    %eax,%esi
  804183:	31 d2                	xor    %edx,%edx
  804185:	89 d8                	mov    %ebx,%eax
  804187:	f7 f6                	div    %esi
  804189:	89 c7                	mov    %eax,%edi
  80418b:	89 c8                	mov    %ecx,%eax
  80418d:	f7 f6                	div    %esi
  80418f:	89 c1                	mov    %eax,%ecx
  804191:	89 fe                	mov    %edi,%esi
  804193:	eb a3                	jmp    804138 <__divdi3+0x64>
  804195:	8d 76 00             	lea    0x0(%esi),%esi
  804198:	f7 d5                	not    %ebp
  80419a:	f7 de                	neg    %esi
  80419c:	83 d7 00             	adc    $0x0,%edi
  80419f:	f7 df                	neg    %edi
  8041a1:	89 34 24             	mov    %esi,(%esp)
  8041a4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8041a8:	e9 59 ff ff ff       	jmp    804106 <__divdi3+0x32>
  8041ad:	8d 76 00             	lea    0x0(%esi),%esi
  8041b0:	f7 d8                	neg    %eax
  8041b2:	83 d2 00             	adc    $0x0,%edx
  8041b5:	f7 da                	neg    %edx
  8041b7:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
  8041bc:	e9 36 ff ff ff       	jmp    8040f7 <__divdi3+0x23>
  8041c1:	8d 76 00             	lea    0x0(%esi),%esi
  8041c4:	b8 20 00 00 00       	mov    $0x20,%eax
  8041c9:	29 f0                	sub    %esi,%eax
  8041cb:	89 f1                	mov    %esi,%ecx
  8041cd:	d3 e7                	shl    %cl,%edi
  8041cf:	8b 54 24 08          	mov    0x8(%esp),%edx
  8041d3:	88 c1                	mov    %al,%cl
  8041d5:	d3 ea                	shr    %cl,%edx
  8041d7:	89 d1                	mov    %edx,%ecx
  8041d9:	09 f9                	or     %edi,%ecx
  8041db:	89 0c 24             	mov    %ecx,(%esp)
  8041de:	8b 54 24 08          	mov    0x8(%esp),%edx
  8041e2:	89 f1                	mov    %esi,%ecx
  8041e4:	d3 e2                	shl    %cl,%edx
  8041e6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8041ea:	89 df                	mov    %ebx,%edi
  8041ec:	88 c1                	mov    %al,%cl
  8041ee:	d3 ef                	shr    %cl,%edi
  8041f0:	89 f1                	mov    %esi,%ecx
  8041f2:	d3 e3                	shl    %cl,%ebx
  8041f4:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8041f8:	88 c1                	mov    %al,%cl
  8041fa:	d3 ea                	shr    %cl,%edx
  8041fc:	09 d3                	or     %edx,%ebx
  8041fe:	89 d8                	mov    %ebx,%eax
  804200:	89 fa                	mov    %edi,%edx
  804202:	f7 34 24             	divl   (%esp)
  804205:	89 d1                	mov    %edx,%ecx
  804207:	89 c3                	mov    %eax,%ebx
  804209:	f7 64 24 08          	mull   0x8(%esp)
  80420d:	39 d1                	cmp    %edx,%ecx
  80420f:	72 17                	jb     804228 <__divdi3+0x154>
  804211:	74 09                	je     80421c <__divdi3+0x148>
  804213:	89 d9                	mov    %ebx,%ecx
  804215:	31 f6                	xor    %esi,%esi
  804217:	e9 1c ff ff ff       	jmp    804138 <__divdi3+0x64>
  80421c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  804220:	89 f1                	mov    %esi,%ecx
  804222:	d3 e2                	shl    %cl,%edx
  804224:	39 c2                	cmp    %eax,%edx
  804226:	73 eb                	jae    804213 <__divdi3+0x13f>
  804228:	8d 4b ff             	lea    -0x1(%ebx),%ecx
  80422b:	31 f6                	xor    %esi,%esi
  80422d:	e9 06 ff ff ff       	jmp    804138 <__divdi3+0x64>
  804232:	66 90                	xchg   %ax,%ax
  804234:	31 c9                	xor    %ecx,%ecx
  804236:	e9 fd fe ff ff       	jmp    804138 <__divdi3+0x64>
  80423b:	90                   	nop

0080423c <__udivdi3>:
  80423c:	55                   	push   %ebp
  80423d:	57                   	push   %edi
  80423e:	56                   	push   %esi
  80423f:	53                   	push   %ebx
  804240:	83 ec 1c             	sub    $0x1c,%esp
  804243:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804247:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80424b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80424f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804253:	89 ca                	mov    %ecx,%edx
  804255:	89 f8                	mov    %edi,%eax
  804257:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80425b:	85 f6                	test   %esi,%esi
  80425d:	75 2d                	jne    80428c <__udivdi3+0x50>
  80425f:	39 cf                	cmp    %ecx,%edi
  804261:	77 65                	ja     8042c8 <__udivdi3+0x8c>
  804263:	89 fd                	mov    %edi,%ebp
  804265:	85 ff                	test   %edi,%edi
  804267:	75 0b                	jne    804274 <__udivdi3+0x38>
  804269:	b8 01 00 00 00       	mov    $0x1,%eax
  80426e:	31 d2                	xor    %edx,%edx
  804270:	f7 f7                	div    %edi
  804272:	89 c5                	mov    %eax,%ebp
  804274:	31 d2                	xor    %edx,%edx
  804276:	89 c8                	mov    %ecx,%eax
  804278:	f7 f5                	div    %ebp
  80427a:	89 c1                	mov    %eax,%ecx
  80427c:	89 d8                	mov    %ebx,%eax
  80427e:	f7 f5                	div    %ebp
  804280:	89 cf                	mov    %ecx,%edi
  804282:	89 fa                	mov    %edi,%edx
  804284:	83 c4 1c             	add    $0x1c,%esp
  804287:	5b                   	pop    %ebx
  804288:	5e                   	pop    %esi
  804289:	5f                   	pop    %edi
  80428a:	5d                   	pop    %ebp
  80428b:	c3                   	ret    
  80428c:	39 ce                	cmp    %ecx,%esi
  80428e:	77 28                	ja     8042b8 <__udivdi3+0x7c>
  804290:	0f bd fe             	bsr    %esi,%edi
  804293:	83 f7 1f             	xor    $0x1f,%edi
  804296:	75 40                	jne    8042d8 <__udivdi3+0x9c>
  804298:	39 ce                	cmp    %ecx,%esi
  80429a:	72 0a                	jb     8042a6 <__udivdi3+0x6a>
  80429c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8042a0:	0f 87 9e 00 00 00    	ja     804344 <__udivdi3+0x108>
  8042a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8042ab:	89 fa                	mov    %edi,%edx
  8042ad:	83 c4 1c             	add    $0x1c,%esp
  8042b0:	5b                   	pop    %ebx
  8042b1:	5e                   	pop    %esi
  8042b2:	5f                   	pop    %edi
  8042b3:	5d                   	pop    %ebp
  8042b4:	c3                   	ret    
  8042b5:	8d 76 00             	lea    0x0(%esi),%esi
  8042b8:	31 ff                	xor    %edi,%edi
  8042ba:	31 c0                	xor    %eax,%eax
  8042bc:	89 fa                	mov    %edi,%edx
  8042be:	83 c4 1c             	add    $0x1c,%esp
  8042c1:	5b                   	pop    %ebx
  8042c2:	5e                   	pop    %esi
  8042c3:	5f                   	pop    %edi
  8042c4:	5d                   	pop    %ebp
  8042c5:	c3                   	ret    
  8042c6:	66 90                	xchg   %ax,%ax
  8042c8:	89 d8                	mov    %ebx,%eax
  8042ca:	f7 f7                	div    %edi
  8042cc:	31 ff                	xor    %edi,%edi
  8042ce:	89 fa                	mov    %edi,%edx
  8042d0:	83 c4 1c             	add    $0x1c,%esp
  8042d3:	5b                   	pop    %ebx
  8042d4:	5e                   	pop    %esi
  8042d5:	5f                   	pop    %edi
  8042d6:	5d                   	pop    %ebp
  8042d7:	c3                   	ret    
  8042d8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8042dd:	89 eb                	mov    %ebp,%ebx
  8042df:	29 fb                	sub    %edi,%ebx
  8042e1:	89 f9                	mov    %edi,%ecx
  8042e3:	d3 e6                	shl    %cl,%esi
  8042e5:	89 c5                	mov    %eax,%ebp
  8042e7:	88 d9                	mov    %bl,%cl
  8042e9:	d3 ed                	shr    %cl,%ebp
  8042eb:	89 e9                	mov    %ebp,%ecx
  8042ed:	09 f1                	or     %esi,%ecx
  8042ef:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8042f3:	89 f9                	mov    %edi,%ecx
  8042f5:	d3 e0                	shl    %cl,%eax
  8042f7:	89 c5                	mov    %eax,%ebp
  8042f9:	89 d6                	mov    %edx,%esi
  8042fb:	88 d9                	mov    %bl,%cl
  8042fd:	d3 ee                	shr    %cl,%esi
  8042ff:	89 f9                	mov    %edi,%ecx
  804301:	d3 e2                	shl    %cl,%edx
  804303:	8b 44 24 08          	mov    0x8(%esp),%eax
  804307:	88 d9                	mov    %bl,%cl
  804309:	d3 e8                	shr    %cl,%eax
  80430b:	09 c2                	or     %eax,%edx
  80430d:	89 d0                	mov    %edx,%eax
  80430f:	89 f2                	mov    %esi,%edx
  804311:	f7 74 24 0c          	divl   0xc(%esp)
  804315:	89 d6                	mov    %edx,%esi
  804317:	89 c3                	mov    %eax,%ebx
  804319:	f7 e5                	mul    %ebp
  80431b:	39 d6                	cmp    %edx,%esi
  80431d:	72 19                	jb     804338 <__udivdi3+0xfc>
  80431f:	74 0b                	je     80432c <__udivdi3+0xf0>
  804321:	89 d8                	mov    %ebx,%eax
  804323:	31 ff                	xor    %edi,%edi
  804325:	e9 58 ff ff ff       	jmp    804282 <__udivdi3+0x46>
  80432a:	66 90                	xchg   %ax,%ax
  80432c:	8b 54 24 08          	mov    0x8(%esp),%edx
  804330:	89 f9                	mov    %edi,%ecx
  804332:	d3 e2                	shl    %cl,%edx
  804334:	39 c2                	cmp    %eax,%edx
  804336:	73 e9                	jae    804321 <__udivdi3+0xe5>
  804338:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80433b:	31 ff                	xor    %edi,%edi
  80433d:	e9 40 ff ff ff       	jmp    804282 <__udivdi3+0x46>
  804342:	66 90                	xchg   %ax,%ax
  804344:	31 c0                	xor    %eax,%eax
  804346:	e9 37 ff ff ff       	jmp    804282 <__udivdi3+0x46>
  80434b:	90                   	nop

0080434c <__umoddi3>:
  80434c:	55                   	push   %ebp
  80434d:	57                   	push   %edi
  80434e:	56                   	push   %esi
  80434f:	53                   	push   %ebx
  804350:	83 ec 1c             	sub    $0x1c,%esp
  804353:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804357:	8b 74 24 34          	mov    0x34(%esp),%esi
  80435b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80435f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804363:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804367:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80436b:	89 f3                	mov    %esi,%ebx
  80436d:	89 fa                	mov    %edi,%edx
  80436f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804373:	89 34 24             	mov    %esi,(%esp)
  804376:	85 c0                	test   %eax,%eax
  804378:	75 1a                	jne    804394 <__umoddi3+0x48>
  80437a:	39 f7                	cmp    %esi,%edi
  80437c:	0f 86 a2 00 00 00    	jbe    804424 <__umoddi3+0xd8>
  804382:	89 c8                	mov    %ecx,%eax
  804384:	89 f2                	mov    %esi,%edx
  804386:	f7 f7                	div    %edi
  804388:	89 d0                	mov    %edx,%eax
  80438a:	31 d2                	xor    %edx,%edx
  80438c:	83 c4 1c             	add    $0x1c,%esp
  80438f:	5b                   	pop    %ebx
  804390:	5e                   	pop    %esi
  804391:	5f                   	pop    %edi
  804392:	5d                   	pop    %ebp
  804393:	c3                   	ret    
  804394:	39 f0                	cmp    %esi,%eax
  804396:	0f 87 ac 00 00 00    	ja     804448 <__umoddi3+0xfc>
  80439c:	0f bd e8             	bsr    %eax,%ebp
  80439f:	83 f5 1f             	xor    $0x1f,%ebp
  8043a2:	0f 84 ac 00 00 00    	je     804454 <__umoddi3+0x108>
  8043a8:	bf 20 00 00 00       	mov    $0x20,%edi
  8043ad:	29 ef                	sub    %ebp,%edi
  8043af:	89 fe                	mov    %edi,%esi
  8043b1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8043b5:	89 e9                	mov    %ebp,%ecx
  8043b7:	d3 e0                	shl    %cl,%eax
  8043b9:	89 d7                	mov    %edx,%edi
  8043bb:	89 f1                	mov    %esi,%ecx
  8043bd:	d3 ef                	shr    %cl,%edi
  8043bf:	09 c7                	or     %eax,%edi
  8043c1:	89 e9                	mov    %ebp,%ecx
  8043c3:	d3 e2                	shl    %cl,%edx
  8043c5:	89 14 24             	mov    %edx,(%esp)
  8043c8:	89 d8                	mov    %ebx,%eax
  8043ca:	d3 e0                	shl    %cl,%eax
  8043cc:	89 c2                	mov    %eax,%edx
  8043ce:	8b 44 24 08          	mov    0x8(%esp),%eax
  8043d2:	d3 e0                	shl    %cl,%eax
  8043d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8043d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8043dc:	89 f1                	mov    %esi,%ecx
  8043de:	d3 e8                	shr    %cl,%eax
  8043e0:	09 d0                	or     %edx,%eax
  8043e2:	d3 eb                	shr    %cl,%ebx
  8043e4:	89 da                	mov    %ebx,%edx
  8043e6:	f7 f7                	div    %edi
  8043e8:	89 d3                	mov    %edx,%ebx
  8043ea:	f7 24 24             	mull   (%esp)
  8043ed:	89 c6                	mov    %eax,%esi
  8043ef:	89 d1                	mov    %edx,%ecx
  8043f1:	39 d3                	cmp    %edx,%ebx
  8043f3:	0f 82 87 00 00 00    	jb     804480 <__umoddi3+0x134>
  8043f9:	0f 84 91 00 00 00    	je     804490 <__umoddi3+0x144>
  8043ff:	8b 54 24 04          	mov    0x4(%esp),%edx
  804403:	29 f2                	sub    %esi,%edx
  804405:	19 cb                	sbb    %ecx,%ebx
  804407:	89 d8                	mov    %ebx,%eax
  804409:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80440d:	d3 e0                	shl    %cl,%eax
  80440f:	89 e9                	mov    %ebp,%ecx
  804411:	d3 ea                	shr    %cl,%edx
  804413:	09 d0                	or     %edx,%eax
  804415:	89 e9                	mov    %ebp,%ecx
  804417:	d3 eb                	shr    %cl,%ebx
  804419:	89 da                	mov    %ebx,%edx
  80441b:	83 c4 1c             	add    $0x1c,%esp
  80441e:	5b                   	pop    %ebx
  80441f:	5e                   	pop    %esi
  804420:	5f                   	pop    %edi
  804421:	5d                   	pop    %ebp
  804422:	c3                   	ret    
  804423:	90                   	nop
  804424:	89 fd                	mov    %edi,%ebp
  804426:	85 ff                	test   %edi,%edi
  804428:	75 0b                	jne    804435 <__umoddi3+0xe9>
  80442a:	b8 01 00 00 00       	mov    $0x1,%eax
  80442f:	31 d2                	xor    %edx,%edx
  804431:	f7 f7                	div    %edi
  804433:	89 c5                	mov    %eax,%ebp
  804435:	89 f0                	mov    %esi,%eax
  804437:	31 d2                	xor    %edx,%edx
  804439:	f7 f5                	div    %ebp
  80443b:	89 c8                	mov    %ecx,%eax
  80443d:	f7 f5                	div    %ebp
  80443f:	89 d0                	mov    %edx,%eax
  804441:	e9 44 ff ff ff       	jmp    80438a <__umoddi3+0x3e>
  804446:	66 90                	xchg   %ax,%ax
  804448:	89 c8                	mov    %ecx,%eax
  80444a:	89 f2                	mov    %esi,%edx
  80444c:	83 c4 1c             	add    $0x1c,%esp
  80444f:	5b                   	pop    %ebx
  804450:	5e                   	pop    %esi
  804451:	5f                   	pop    %edi
  804452:	5d                   	pop    %ebp
  804453:	c3                   	ret    
  804454:	3b 04 24             	cmp    (%esp),%eax
  804457:	72 06                	jb     80445f <__umoddi3+0x113>
  804459:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80445d:	77 0f                	ja     80446e <__umoddi3+0x122>
  80445f:	89 f2                	mov    %esi,%edx
  804461:	29 f9                	sub    %edi,%ecx
  804463:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804467:	89 14 24             	mov    %edx,(%esp)
  80446a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80446e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804472:	8b 14 24             	mov    (%esp),%edx
  804475:	83 c4 1c             	add    $0x1c,%esp
  804478:	5b                   	pop    %ebx
  804479:	5e                   	pop    %esi
  80447a:	5f                   	pop    %edi
  80447b:	5d                   	pop    %ebp
  80447c:	c3                   	ret    
  80447d:	8d 76 00             	lea    0x0(%esi),%esi
  804480:	2b 04 24             	sub    (%esp),%eax
  804483:	19 fa                	sbb    %edi,%edx
  804485:	89 d1                	mov    %edx,%ecx
  804487:	89 c6                	mov    %eax,%esi
  804489:	e9 71 ff ff ff       	jmp    8043ff <__umoddi3+0xb3>
  80448e:	66 90                	xchg   %ax,%ax
  804490:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804494:	72 ea                	jb     804480 <__umoddi3+0x134>
  804496:	89 d9                	mov    %ebx,%ecx
  804498:	e9 62 ff ff ff       	jmp    8043ff <__umoddi3+0xb3>
