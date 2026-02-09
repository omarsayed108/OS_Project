
obj/user/heap_program:     file format elf32-i386


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
  800031:	e8 1a 02 00 00       	call   800250 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 5c             	sub    $0x5c,%esp
	int kilo = 1024;
  800041:	c7 45 d8 00 04 00 00 	movl   $0x400,-0x28(%ebp)
	int Mega = 1024*1024;
  800048:	c7 45 d4 00 00 10 00 	movl   $0x100000,-0x2c(%ebp)

	/// testing freeHeap()
	{
		uint32 size = 13*Mega;
  80004f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800052:	89 d0                	mov    %edx,%eax
  800054:	01 c0                	add    %eax,%eax
  800056:	01 d0                	add    %edx,%eax
  800058:	c1 e0 02             	shl    $0x2,%eax
  80005b:	01 d0                	add    %edx,%eax
  80005d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		char *x = malloc(sizeof( char)*size) ;
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	ff 75 d0             	pushl  -0x30(%ebp)
  800066:	e8 ae 1c 00 00       	call   801d19 <malloc>
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	89 45 cc             	mov    %eax,-0x34(%ebp)

		char *y = malloc(sizeof( char)*size) ;
  800071:	83 ec 0c             	sub    $0xc,%esp
  800074:	ff 75 d0             	pushl  -0x30(%ebp)
  800077:	e8 9d 1c 00 00       	call   801d19 <malloc>
  80007c:	83 c4 10             	add    $0x10,%esp
  80007f:	89 45 c8             	mov    %eax,-0x38(%ebp)


		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800082:	e8 be 23 00 00       	call   802445 <sys_pf_calculate_allocated_pages>
  800087:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		x[1]=-1;
  80008a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80008d:	40                   	inc    %eax
  80008e:	c6 00 ff             	movb   $0xff,(%eax)

		x[5*Mega]=-1;
  800091:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800094:	89 d0                	mov    %edx,%eax
  800096:	c1 e0 02             	shl    $0x2,%eax
  800099:	01 d0                	add    %edx,%eax
  80009b:	89 c2                	mov    %eax,%edx
  80009d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000a0:	01 d0                	add    %edx,%eax
  8000a2:	c6 00 ff             	movb   $0xff,(%eax)

		//Access VA 0x200000
		int *p1 = (int *)0x200000 ;
  8000a5:	c7 45 c0 00 00 20 00 	movl   $0x200000,-0x40(%ebp)
		*p1 = -1 ;
  8000ac:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8000af:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

		y[1*Mega]=-1;
  8000b5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000bb:	01 d0                	add    %edx,%eax
  8000bd:	c6 00 ff             	movb   $0xff,(%eax)

		x[8*Mega] = -1;
  8000c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000c3:	c1 e0 03             	shl    $0x3,%eax
  8000c6:	89 c2                	mov    %eax,%edx
  8000c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000cb:	01 d0                	add    %edx,%eax
  8000cd:	c6 00 ff             	movb   $0xff,(%eax)

		x[12*Mega]=-1;
  8000d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000d3:	89 d0                	mov    %edx,%eax
  8000d5:	01 c0                	add    %eax,%eax
  8000d7:	01 d0                	add    %edx,%eax
  8000d9:	c1 e0 02             	shl    $0x2,%eax
  8000dc:	89 c2                	mov    %eax,%edx
  8000de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000e1:	01 d0                	add    %edx,%eax
  8000e3:	c6 00 ff             	movb   $0xff,(%eax)


		//int usedDiskPages = sys_pf_calculate_allocated_pages() ;


		free(x);
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	ff 75 cc             	pushl  -0x34(%ebp)
  8000ec:	e8 ac 1d 00 00       	call   801e9d <free>
  8000f1:	83 c4 10             	add    $0x10,%esp
		free(y);
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	ff 75 c8             	pushl  -0x38(%ebp)
  8000fa:	e8 9e 1d 00 00       	call   801e9d <free>
  8000ff:	83 c4 10             	add    $0x10,%esp

		///		cprintf("%d\n",sys_pf_calculate_allocated_pages() - usedDiskPages);
		///assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 5 ); //4 pages + 1 table, that was not in WS

		int freePages = sys_calculate_free_frames();
  800102:	e8 f3 22 00 00       	call   8023fa <sys_calculate_free_frames>
  800107:	89 45 bc             	mov    %eax,-0x44(%ebp)
		x = malloc(sizeof(char)*size) ;
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	ff 75 d0             	pushl  -0x30(%ebp)
  800110:	e8 04 1c 00 00       	call   801d19 <malloc>
  800115:	83 c4 10             	add    $0x10,%esp
  800118:	89 45 cc             	mov    %eax,-0x34(%ebp)

		//Access VA 0x200000
		*p1 = -1 ;
  80011b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80011e:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


		x[1]=-2;
  800124:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800127:	40                   	inc    %eax
  800128:	c6 00 fe             	movb   $0xfe,(%eax)

		x[5*Mega]=-2;
  80012b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80012e:	89 d0                	mov    %edx,%eax
  800130:	c1 e0 02             	shl    $0x2,%eax
  800133:	01 d0                	add    %edx,%eax
  800135:	89 c2                	mov    %eax,%edx
  800137:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80013a:	01 d0                	add    %edx,%eax
  80013c:	c6 00 fe             	movb   $0xfe,(%eax)

		x[8*Mega] = -2;
  80013f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800142:	c1 e0 03             	shl    $0x3,%eax
  800145:	89 c2                	mov    %eax,%edx
  800147:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80014a:	01 d0                	add    %edx,%eax
  80014c:	c6 00 fe             	movb   $0xfe,(%eax)

//		x[12*Mega]=-2;

		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};
  80014f:	8d 45 9c             	lea    -0x64(%ebp),%eax
  800152:	bb 1c 39 80 00       	mov    $0x80391c,%ebx
  800157:	ba 07 00 00 00       	mov    $0x7,%edx
  80015c:	89 c7                	mov    %eax,%edi
  80015e:	89 de                	mov    %ebx,%esi
  800160:	89 d1                	mov    %edx,%ecx
  800162:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

		int i = 0, j ;
  800164:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for (; i < 7; i++)
  80016b:	e9 89 00 00 00       	jmp    8001f9 <_main+0x1c1>
		{
			int found = 0 ;
  800170:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  800177:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80017e:	eb 45                	jmp    8001c5 <_main+0x18d>
			{
				if (pageWSEntries[i] == ROUNDDOWN(myEnv->__uptr_pws[j].virtual_address,PAGE_SIZE) )
  800180:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800183:	8b 4c 85 9c          	mov    -0x64(%ebp,%eax,4),%ecx
  800187:	a1 20 50 80 00       	mov    0x805020,%eax
  80018c:	8b 98 6c 06 00 00    	mov    0x66c(%eax),%ebx
  800192:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800195:	89 d0                	mov    %edx,%eax
  800197:	01 c0                	add    %eax,%eax
  800199:	01 d0                	add    %edx,%eax
  80019b:	8d 34 c5 00 00 00 00 	lea    0x0(,%eax,8),%esi
  8001a2:	01 f0                	add    %esi,%eax
  8001a4:	01 d0                	add    %edx,%eax
  8001a6:	01 d8                	add    %ebx,%eax
  8001a8:	8b 00                	mov    (%eax),%eax
  8001aa:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001ad:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001b0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001b5:	39 c1                	cmp    %eax,%ecx
  8001b7:	75 09                	jne    8001c2 <_main+0x18a>
				{
					found = 1 ;
  8001b9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
					break;
  8001c0:	eb 15                	jmp    8001d7 <_main+0x19f>

		int i = 0, j ;
		for (; i < 7; i++)
		{
			int found = 0 ;
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  8001c2:	ff 45 e0             	incl   -0x20(%ebp)
  8001c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8001ca:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8001d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d3:	39 c2                	cmp    %eax,%edx
  8001d5:	77 a9                	ja     800180 <_main+0x148>
				{
					found = 1 ;
					break;
				}
			}
			if (!found)
  8001d7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001db:	75 19                	jne    8001f6 <_main+0x1be>
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
  8001dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001e0:	8b 44 85 9c          	mov    -0x64(%ebp,%eax,4),%eax
  8001e4:	50                   	push   %eax
  8001e5:	68 20 38 80 00       	push   $0x803820
  8001ea:	6a 4c                	push   $0x4c
  8001ec:	68 81 38 80 00       	push   $0x803881
  8001f1:	e8 0a 02 00 00       	call   800400 <_panic>
//		x[12*Mega]=-2;

		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};

		int i = 0, j ;
		for (; i < 7; i++)
  8001f6:	ff 45 e4             	incl   -0x1c(%ebp)
  8001f9:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  8001fd:	0f 8e 6d ff ff ff    	jle    800170 <_main+0x138>
			}
			if (!found)
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
		}

		if( (freePages - sys_calculate_free_frames() ) != 6 ) panic("Extra/Less memory are wrongly allocated. diff = %d, expected = %d", freePages - sys_calculate_free_frames(), 8);
  800203:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  800206:	e8 ef 21 00 00       	call   8023fa <sys_calculate_free_frames>
  80020b:	29 c3                	sub    %eax,%ebx
  80020d:	89 d8                	mov    %ebx,%eax
  80020f:	83 f8 06             	cmp    $0x6,%eax
  800212:	74 23                	je     800237 <_main+0x1ff>
  800214:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  800217:	e8 de 21 00 00       	call   8023fa <sys_calculate_free_frames>
  80021c:	29 c3                	sub    %eax,%ebx
  80021e:	89 d8                	mov    %ebx,%eax
  800220:	83 ec 0c             	sub    $0xc,%esp
  800223:	6a 08                	push   $0x8
  800225:	50                   	push   %eax
  800226:	68 98 38 80 00       	push   $0x803898
  80022b:	6a 4f                	push   $0x4f
  80022d:	68 81 38 80 00       	push   $0x803881
  800232:	e8 c9 01 00 00       	call   800400 <_panic>
	}

	cprintf("Congratulations!! test HEAP_PROGRAM completed successfully.\n");
  800237:	83 ec 0c             	sub    $0xc,%esp
  80023a:	68 dc 38 80 00       	push   $0x8038dc
  80023f:	e8 aa 04 00 00       	call   8006ee <cprintf>
  800244:	83 c4 10             	add    $0x10,%esp


	return;
  800247:	90                   	nop
}
  800248:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024b:	5b                   	pop    %ebx
  80024c:	5e                   	pop    %esi
  80024d:	5f                   	pop    %edi
  80024e:	5d                   	pop    %ebp
  80024f:	c3                   	ret    

00800250 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	57                   	push   %edi
  800254:	56                   	push   %esi
  800255:	53                   	push   %ebx
  800256:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800259:	e8 65 23 00 00       	call   8025c3 <sys_getenvindex>
  80025e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800261:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800264:	89 d0                	mov    %edx,%eax
  800266:	01 c0                	add    %eax,%eax
  800268:	01 d0                	add    %edx,%eax
  80026a:	c1 e0 02             	shl    $0x2,%eax
  80026d:	01 d0                	add    %edx,%eax
  80026f:	c1 e0 02             	shl    $0x2,%eax
  800272:	01 d0                	add    %edx,%eax
  800274:	c1 e0 03             	shl    $0x3,%eax
  800277:	01 d0                	add    %edx,%eax
  800279:	c1 e0 02             	shl    $0x2,%eax
  80027c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800281:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800286:	a1 20 50 80 00       	mov    0x805020,%eax
  80028b:	8a 40 20             	mov    0x20(%eax),%al
  80028e:	84 c0                	test   %al,%al
  800290:	74 0d                	je     80029f <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800292:	a1 20 50 80 00       	mov    0x805020,%eax
  800297:	83 c0 20             	add    $0x20,%eax
  80029a:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80029f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002a3:	7e 0a                	jle    8002af <libmain+0x5f>
		binaryname = argv[0];
  8002a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a8:	8b 00                	mov    (%eax),%eax
  8002aa:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8002af:	83 ec 08             	sub    $0x8,%esp
  8002b2:	ff 75 0c             	pushl  0xc(%ebp)
  8002b5:	ff 75 08             	pushl  0x8(%ebp)
  8002b8:	e8 7b fd ff ff       	call   800038 <_main>
  8002bd:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002c0:	a1 00 50 80 00       	mov    0x805000,%eax
  8002c5:	85 c0                	test   %eax,%eax
  8002c7:	0f 84 01 01 00 00    	je     8003ce <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8002cd:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002d3:	bb 30 3a 80 00       	mov    $0x803a30,%ebx
  8002d8:	ba 0e 00 00 00       	mov    $0xe,%edx
  8002dd:	89 c7                	mov    %eax,%edi
  8002df:	89 de                	mov    %ebx,%esi
  8002e1:	89 d1                	mov    %edx,%ecx
  8002e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8002e5:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8002e8:	b9 56 00 00 00       	mov    $0x56,%ecx
  8002ed:	b0 00                	mov    $0x0,%al
  8002ef:	89 d7                	mov    %edx,%edi
  8002f1:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8002f3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8002fa:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8002fd:	83 ec 08             	sub    $0x8,%esp
  800300:	50                   	push   %eax
  800301:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800307:	50                   	push   %eax
  800308:	e8 ec 24 00 00       	call   8027f9 <sys_utilities>
  80030d:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800310:	e8 35 20 00 00       	call   80234a <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800315:	83 ec 0c             	sub    $0xc,%esp
  800318:	68 50 39 80 00       	push   $0x803950
  80031d:	e8 cc 03 00 00       	call   8006ee <cprintf>
  800322:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800325:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800328:	85 c0                	test   %eax,%eax
  80032a:	74 18                	je     800344 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80032c:	e8 e6 24 00 00       	call   802817 <sys_get_optimal_num_faults>
  800331:	83 ec 08             	sub    $0x8,%esp
  800334:	50                   	push   %eax
  800335:	68 78 39 80 00       	push   $0x803978
  80033a:	e8 af 03 00 00       	call   8006ee <cprintf>
  80033f:	83 c4 10             	add    $0x10,%esp
  800342:	eb 59                	jmp    80039d <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800344:	a1 20 50 80 00       	mov    0x805020,%eax
  800349:	8b 90 88 06 00 00    	mov    0x688(%eax),%edx
  80034f:	a1 20 50 80 00       	mov    0x805020,%eax
  800354:	8b 80 78 06 00 00    	mov    0x678(%eax),%eax
  80035a:	83 ec 04             	sub    $0x4,%esp
  80035d:	52                   	push   %edx
  80035e:	50                   	push   %eax
  80035f:	68 9c 39 80 00       	push   $0x80399c
  800364:	e8 85 03 00 00       	call   8006ee <cprintf>
  800369:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80036c:	a1 20 50 80 00       	mov    0x805020,%eax
  800371:	8b 88 9c 06 00 00    	mov    0x69c(%eax),%ecx
  800377:	a1 20 50 80 00       	mov    0x805020,%eax
  80037c:	8b 90 98 06 00 00    	mov    0x698(%eax),%edx
  800382:	a1 20 50 80 00       	mov    0x805020,%eax
  800387:	8b 80 94 06 00 00    	mov    0x694(%eax),%eax
  80038d:	51                   	push   %ecx
  80038e:	52                   	push   %edx
  80038f:	50                   	push   %eax
  800390:	68 c4 39 80 00       	push   $0x8039c4
  800395:	e8 54 03 00 00       	call   8006ee <cprintf>
  80039a:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80039d:	a1 20 50 80 00       	mov    0x805020,%eax
  8003a2:	8b 80 a0 06 00 00    	mov    0x6a0(%eax),%eax
  8003a8:	83 ec 08             	sub    $0x8,%esp
  8003ab:	50                   	push   %eax
  8003ac:	68 1c 3a 80 00       	push   $0x803a1c
  8003b1:	e8 38 03 00 00       	call   8006ee <cprintf>
  8003b6:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003b9:	83 ec 0c             	sub    $0xc,%esp
  8003bc:	68 50 39 80 00       	push   $0x803950
  8003c1:	e8 28 03 00 00       	call   8006ee <cprintf>
  8003c6:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8003c9:	e8 96 1f 00 00       	call   802364 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8003ce:	e8 1f 00 00 00       	call   8003f2 <exit>
}
  8003d3:	90                   	nop
  8003d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003d7:	5b                   	pop    %ebx
  8003d8:	5e                   	pop    %esi
  8003d9:	5f                   	pop    %edi
  8003da:	5d                   	pop    %ebp
  8003db:	c3                   	ret    

008003dc <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003e2:	83 ec 0c             	sub    $0xc,%esp
  8003e5:	6a 00                	push   $0x0
  8003e7:	e8 a3 21 00 00       	call   80258f <sys_destroy_env>
  8003ec:	83 c4 10             	add    $0x10,%esp
}
  8003ef:	90                   	nop
  8003f0:	c9                   	leave  
  8003f1:	c3                   	ret    

008003f2 <exit>:

void
exit(void)
{
  8003f2:	55                   	push   %ebp
  8003f3:	89 e5                	mov    %esp,%ebp
  8003f5:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003f8:	e8 f8 21 00 00       	call   8025f5 <sys_exit_env>
}
  8003fd:	90                   	nop
  8003fe:	c9                   	leave  
  8003ff:	c3                   	ret    

00800400 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800400:	55                   	push   %ebp
  800401:	89 e5                	mov    %esp,%ebp
  800403:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800406:	8d 45 10             	lea    0x10(%ebp),%eax
  800409:	83 c0 04             	add    $0x4,%eax
  80040c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80040f:	a1 18 d1 81 00       	mov    0x81d118,%eax
  800414:	85 c0                	test   %eax,%eax
  800416:	74 16                	je     80042e <_panic+0x2e>
		cprintf("%s: ", argv0);
  800418:	a1 18 d1 81 00       	mov    0x81d118,%eax
  80041d:	83 ec 08             	sub    $0x8,%esp
  800420:	50                   	push   %eax
  800421:	68 94 3a 80 00       	push   $0x803a94
  800426:	e8 c3 02 00 00       	call   8006ee <cprintf>
  80042b:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80042e:	a1 04 50 80 00       	mov    0x805004,%eax
  800433:	83 ec 0c             	sub    $0xc,%esp
  800436:	ff 75 0c             	pushl  0xc(%ebp)
  800439:	ff 75 08             	pushl  0x8(%ebp)
  80043c:	50                   	push   %eax
  80043d:	68 9c 3a 80 00       	push   $0x803a9c
  800442:	6a 74                	push   $0x74
  800444:	e8 d2 02 00 00       	call   80071b <cprintf_colored>
  800449:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80044c:	8b 45 10             	mov    0x10(%ebp),%eax
  80044f:	83 ec 08             	sub    $0x8,%esp
  800452:	ff 75 f4             	pushl  -0xc(%ebp)
  800455:	50                   	push   %eax
  800456:	e8 24 02 00 00       	call   80067f <vcprintf>
  80045b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80045e:	83 ec 08             	sub    $0x8,%esp
  800461:	6a 00                	push   $0x0
  800463:	68 c4 3a 80 00       	push   $0x803ac4
  800468:	e8 12 02 00 00       	call   80067f <vcprintf>
  80046d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800470:	e8 7d ff ff ff       	call   8003f2 <exit>

	// should not return here
	while (1) ;
  800475:	eb fe                	jmp    800475 <_panic+0x75>

00800477 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800477:	55                   	push   %ebp
  800478:	89 e5                	mov    %esp,%ebp
  80047a:	53                   	push   %ebx
  80047b:	83 ec 24             	sub    $0x24,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80047e:	a1 20 50 80 00       	mov    0x805020,%eax
  800483:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048c:	39 c2                	cmp    %eax,%edx
  80048e:	74 14                	je     8004a4 <CheckWSArrayWithoutLastIndex+0x2d>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800490:	83 ec 04             	sub    $0x4,%esp
  800493:	68 c8 3a 80 00       	push   $0x803ac8
  800498:	6a 26                	push   $0x26
  80049a:	68 14 3b 80 00       	push   $0x803b14
  80049f:	e8 5c ff ff ff       	call   800400 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004b2:	e9 d9 00 00 00       	jmp    800590 <CheckWSArrayWithoutLastIndex+0x119>
		if (expectedPages[e] == 0) {
  8004b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c4:	01 d0                	add    %edx,%eax
  8004c6:	8b 00                	mov    (%eax),%eax
  8004c8:	85 c0                	test   %eax,%eax
  8004ca:	75 08                	jne    8004d4 <CheckWSArrayWithoutLastIndex+0x5d>
			expectedNumOfEmptyLocs++;
  8004cc:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004cf:	e9 b9 00 00 00       	jmp    80058d <CheckWSArrayWithoutLastIndex+0x116>
		}
		int found = 0;
  8004d4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004db:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004e2:	eb 79                	jmp    80055d <CheckWSArrayWithoutLastIndex+0xe6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004e4:	a1 20 50 80 00       	mov    0x805020,%eax
  8004e9:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8004ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004f2:	89 d0                	mov    %edx,%eax
  8004f4:	01 c0                	add    %eax,%eax
  8004f6:	01 d0                	add    %edx,%eax
  8004f8:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8004ff:	01 d8                	add    %ebx,%eax
  800501:	01 d0                	add    %edx,%eax
  800503:	01 c8                	add    %ecx,%eax
  800505:	8a 40 04             	mov    0x4(%eax),%al
  800508:	84 c0                	test   %al,%al
  80050a:	75 4e                	jne    80055a <CheckWSArrayWithoutLastIndex+0xe3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80050c:	a1 20 50 80 00       	mov    0x805020,%eax
  800511:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  800517:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80051a:	89 d0                	mov    %edx,%eax
  80051c:	01 c0                	add    %eax,%eax
  80051e:	01 d0                	add    %edx,%eax
  800520:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  800527:	01 d8                	add    %ebx,%eax
  800529:	01 d0                	add    %edx,%eax
  80052b:	01 c8                	add    %ecx,%eax
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800532:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800535:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80053a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80053c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80053f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800546:	8b 45 08             	mov    0x8(%ebp),%eax
  800549:	01 c8                	add    %ecx,%eax
  80054b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80054d:	39 c2                	cmp    %eax,%edx
  80054f:	75 09                	jne    80055a <CheckWSArrayWithoutLastIndex+0xe3>
						== expectedPages[e]) {
					found = 1;
  800551:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800558:	eb 19                	jmp    800573 <CheckWSArrayWithoutLastIndex+0xfc>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80055a:	ff 45 e8             	incl   -0x18(%ebp)
  80055d:	a1 20 50 80 00       	mov    0x805020,%eax
  800562:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800568:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80056b:	39 c2                	cmp    %eax,%edx
  80056d:	0f 87 71 ff ff ff    	ja     8004e4 <CheckWSArrayWithoutLastIndex+0x6d>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800573:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800577:	75 14                	jne    80058d <CheckWSArrayWithoutLastIndex+0x116>
			panic(
  800579:	83 ec 04             	sub    $0x4,%esp
  80057c:	68 20 3b 80 00       	push   $0x803b20
  800581:	6a 3a                	push   $0x3a
  800583:	68 14 3b 80 00       	push   $0x803b14
  800588:	e8 73 fe ff ff       	call   800400 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80058d:	ff 45 f0             	incl   -0x10(%ebp)
  800590:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800593:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800596:	0f 8c 1b ff ff ff    	jl     8004b7 <CheckWSArrayWithoutLastIndex+0x40>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80059c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005aa:	eb 2e                	jmp    8005da <CheckWSArrayWithoutLastIndex+0x163>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005ac:	a1 20 50 80 00       	mov    0x805020,%eax
  8005b1:	8b 88 6c 06 00 00    	mov    0x66c(%eax),%ecx
  8005b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005ba:	89 d0                	mov    %edx,%eax
  8005bc:	01 c0                	add    %eax,%eax
  8005be:	01 d0                	add    %edx,%eax
  8005c0:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  8005c7:	01 d8                	add    %ebx,%eax
  8005c9:	01 d0                	add    %edx,%eax
  8005cb:	01 c8                	add    %ecx,%eax
  8005cd:	8a 40 04             	mov    0x4(%eax),%al
  8005d0:	3c 01                	cmp    $0x1,%al
  8005d2:	75 03                	jne    8005d7 <CheckWSArrayWithoutLastIndex+0x160>
			actualNumOfEmptyLocs++;
  8005d4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005d7:	ff 45 e0             	incl   -0x20(%ebp)
  8005da:	a1 20 50 80 00       	mov    0x805020,%eax
  8005df:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e8:	39 c2                	cmp    %eax,%edx
  8005ea:	77 c0                	ja     8005ac <CheckWSArrayWithoutLastIndex+0x135>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005ef:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005f2:	74 14                	je     800608 <CheckWSArrayWithoutLastIndex+0x191>
		panic(
  8005f4:	83 ec 04             	sub    $0x4,%esp
  8005f7:	68 74 3b 80 00       	push   $0x803b74
  8005fc:	6a 44                	push   $0x44
  8005fe:	68 14 3b 80 00       	push   $0x803b14
  800603:	e8 f8 fd ff ff       	call   800400 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800608:	90                   	nop
  800609:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80060c:	c9                   	leave  
  80060d:	c3                   	ret    

0080060e <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80060e:	55                   	push   %ebp
  80060f:	89 e5                	mov    %esp,%ebp
  800611:	53                   	push   %ebx
  800612:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800615:	8b 45 0c             	mov    0xc(%ebp),%eax
  800618:	8b 00                	mov    (%eax),%eax
  80061a:	8d 48 01             	lea    0x1(%eax),%ecx
  80061d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800620:	89 0a                	mov    %ecx,(%edx)
  800622:	8b 55 08             	mov    0x8(%ebp),%edx
  800625:	88 d1                	mov    %dl,%cl
  800627:	8b 55 0c             	mov    0xc(%ebp),%edx
  80062a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80062e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800631:	8b 00                	mov    (%eax),%eax
  800633:	3d ff 00 00 00       	cmp    $0xff,%eax
  800638:	75 30                	jne    80066a <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80063a:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  800640:	a0 44 50 80 00       	mov    0x805044,%al
  800645:	0f b6 c0             	movzbl %al,%eax
  800648:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80064b:	8b 09                	mov    (%ecx),%ecx
  80064d:	89 cb                	mov    %ecx,%ebx
  80064f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800652:	83 c1 08             	add    $0x8,%ecx
  800655:	52                   	push   %edx
  800656:	50                   	push   %eax
  800657:	53                   	push   %ebx
  800658:	51                   	push   %ecx
  800659:	e8 a8 1c 00 00       	call   802306 <sys_cputs>
  80065e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800661:	8b 45 0c             	mov    0xc(%ebp),%eax
  800664:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80066a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80066d:	8b 40 04             	mov    0x4(%eax),%eax
  800670:	8d 50 01             	lea    0x1(%eax),%edx
  800673:	8b 45 0c             	mov    0xc(%ebp),%eax
  800676:	89 50 04             	mov    %edx,0x4(%eax)
}
  800679:	90                   	nop
  80067a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80067d:	c9                   	leave  
  80067e:	c3                   	ret    

0080067f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80067f:	55                   	push   %ebp
  800680:	89 e5                	mov    %esp,%ebp
  800682:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800688:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80068f:	00 00 00 
	b.cnt = 0;
  800692:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800699:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80069c:	ff 75 0c             	pushl  0xc(%ebp)
  80069f:	ff 75 08             	pushl  0x8(%ebp)
  8006a2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006a8:	50                   	push   %eax
  8006a9:	68 0e 06 80 00       	push   $0x80060e
  8006ae:	e8 5a 02 00 00       	call   80090d <vprintfmt>
  8006b3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006b6:	8b 15 1c d1 81 00    	mov    0x81d11c,%edx
  8006bc:	a0 44 50 80 00       	mov    0x805044,%al
  8006c1:	0f b6 c0             	movzbl %al,%eax
  8006c4:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8006ca:	52                   	push   %edx
  8006cb:	50                   	push   %eax
  8006cc:	51                   	push   %ecx
  8006cd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006d3:	83 c0 08             	add    $0x8,%eax
  8006d6:	50                   	push   %eax
  8006d7:	e8 2a 1c 00 00       	call   802306 <sys_cputs>
  8006dc:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006df:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  8006e6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006ec:	c9                   	leave  
  8006ed:	c3                   	ret    

008006ee <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006ee:	55                   	push   %ebp
  8006ef:	89 e5                	mov    %esp,%ebp
  8006f1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006f4:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  8006fb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	83 ec 08             	sub    $0x8,%esp
  800707:	ff 75 f4             	pushl  -0xc(%ebp)
  80070a:	50                   	push   %eax
  80070b:	e8 6f ff ff ff       	call   80067f <vcprintf>
  800710:	83 c4 10             	add    $0x10,%esp
  800713:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800716:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800719:	c9                   	leave  
  80071a:	c3                   	ret    

0080071b <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80071b:	55                   	push   %ebp
  80071c:	89 e5                	mov    %esp,%ebp
  80071e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800721:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	c1 e0 08             	shl    $0x8,%eax
  80072e:	a3 1c d1 81 00       	mov    %eax,0x81d11c
	va_start(ap, fmt);
  800733:	8d 45 0c             	lea    0xc(%ebp),%eax
  800736:	83 c0 04             	add    $0x4,%eax
  800739:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80073c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80073f:	83 ec 08             	sub    $0x8,%esp
  800742:	ff 75 f4             	pushl  -0xc(%ebp)
  800745:	50                   	push   %eax
  800746:	e8 34 ff ff ff       	call   80067f <vcprintf>
  80074b:	83 c4 10             	add    $0x10,%esp
  80074e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800751:	c7 05 1c d1 81 00 00 	movl   $0x700,0x81d11c
  800758:	07 00 00 

	return cnt;
  80075b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80075e:	c9                   	leave  
  80075f:	c3                   	ret    

00800760 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800760:	55                   	push   %ebp
  800761:	89 e5                	mov    %esp,%ebp
  800763:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800766:	e8 df 1b 00 00       	call   80234a <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80076b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80076e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800771:	8b 45 08             	mov    0x8(%ebp),%eax
  800774:	83 ec 08             	sub    $0x8,%esp
  800777:	ff 75 f4             	pushl  -0xc(%ebp)
  80077a:	50                   	push   %eax
  80077b:	e8 ff fe ff ff       	call   80067f <vcprintf>
  800780:	83 c4 10             	add    $0x10,%esp
  800783:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800786:	e8 d9 1b 00 00       	call   802364 <sys_unlock_cons>
	return cnt;
  80078b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80078e:	c9                   	leave  
  80078f:	c3                   	ret    

00800790 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	53                   	push   %ebx
  800794:	83 ec 14             	sub    $0x14,%esp
  800797:	8b 45 10             	mov    0x10(%ebp),%eax
  80079a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007a3:	8b 45 18             	mov    0x18(%ebp),%eax
  8007a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ab:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ae:	77 55                	ja     800805 <printnum+0x75>
  8007b0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007b3:	72 05                	jb     8007ba <printnum+0x2a>
  8007b5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007b8:	77 4b                	ja     800805 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007ba:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007bd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007c0:	8b 45 18             	mov    0x18(%ebp),%eax
  8007c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c8:	52                   	push   %edx
  8007c9:	50                   	push   %eax
  8007ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8007cd:	ff 75 f0             	pushl  -0x10(%ebp)
  8007d0:	e8 d3 2d 00 00       	call   8035a8 <__udivdi3>
  8007d5:	83 c4 10             	add    $0x10,%esp
  8007d8:	83 ec 04             	sub    $0x4,%esp
  8007db:	ff 75 20             	pushl  0x20(%ebp)
  8007de:	53                   	push   %ebx
  8007df:	ff 75 18             	pushl  0x18(%ebp)
  8007e2:	52                   	push   %edx
  8007e3:	50                   	push   %eax
  8007e4:	ff 75 0c             	pushl  0xc(%ebp)
  8007e7:	ff 75 08             	pushl  0x8(%ebp)
  8007ea:	e8 a1 ff ff ff       	call   800790 <printnum>
  8007ef:	83 c4 20             	add    $0x20,%esp
  8007f2:	eb 1a                	jmp    80080e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007f4:	83 ec 08             	sub    $0x8,%esp
  8007f7:	ff 75 0c             	pushl  0xc(%ebp)
  8007fa:	ff 75 20             	pushl  0x20(%ebp)
  8007fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800800:	ff d0                	call   *%eax
  800802:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800805:	ff 4d 1c             	decl   0x1c(%ebp)
  800808:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80080c:	7f e6                	jg     8007f4 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80080e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800811:	bb 00 00 00 00       	mov    $0x0,%ebx
  800816:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800819:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80081c:	53                   	push   %ebx
  80081d:	51                   	push   %ecx
  80081e:	52                   	push   %edx
  80081f:	50                   	push   %eax
  800820:	e8 93 2e 00 00       	call   8036b8 <__umoddi3>
  800825:	83 c4 10             	add    $0x10,%esp
  800828:	05 d4 3d 80 00       	add    $0x803dd4,%eax
  80082d:	8a 00                	mov    (%eax),%al
  80082f:	0f be c0             	movsbl %al,%eax
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	ff 75 0c             	pushl  0xc(%ebp)
  800838:	50                   	push   %eax
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	ff d0                	call   *%eax
  80083e:	83 c4 10             	add    $0x10,%esp
}
  800841:	90                   	nop
  800842:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800845:	c9                   	leave  
  800846:	c3                   	ret    

00800847 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800847:	55                   	push   %ebp
  800848:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80084a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80084e:	7e 1c                	jle    80086c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800850:	8b 45 08             	mov    0x8(%ebp),%eax
  800853:	8b 00                	mov    (%eax),%eax
  800855:	8d 50 08             	lea    0x8(%eax),%edx
  800858:	8b 45 08             	mov    0x8(%ebp),%eax
  80085b:	89 10                	mov    %edx,(%eax)
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	8b 00                	mov    (%eax),%eax
  800862:	83 e8 08             	sub    $0x8,%eax
  800865:	8b 50 04             	mov    0x4(%eax),%edx
  800868:	8b 00                	mov    (%eax),%eax
  80086a:	eb 40                	jmp    8008ac <getuint+0x65>
	else if (lflag)
  80086c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800870:	74 1e                	je     800890 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	8b 00                	mov    (%eax),%eax
  800877:	8d 50 04             	lea    0x4(%eax),%edx
  80087a:	8b 45 08             	mov    0x8(%ebp),%eax
  80087d:	89 10                	mov    %edx,(%eax)
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	8b 00                	mov    (%eax),%eax
  800884:	83 e8 04             	sub    $0x4,%eax
  800887:	8b 00                	mov    (%eax),%eax
  800889:	ba 00 00 00 00       	mov    $0x0,%edx
  80088e:	eb 1c                	jmp    8008ac <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	8b 00                	mov    (%eax),%eax
  800895:	8d 50 04             	lea    0x4(%eax),%edx
  800898:	8b 45 08             	mov    0x8(%ebp),%eax
  80089b:	89 10                	mov    %edx,(%eax)
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	8b 00                	mov    (%eax),%eax
  8008a2:	83 e8 04             	sub    $0x4,%eax
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008ac:	5d                   	pop    %ebp
  8008ad:	c3                   	ret    

008008ae <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008ae:	55                   	push   %ebp
  8008af:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008b1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008b5:	7e 1c                	jle    8008d3 <getint+0x25>
		return va_arg(*ap, long long);
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	8b 00                	mov    (%eax),%eax
  8008bc:	8d 50 08             	lea    0x8(%eax),%edx
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	89 10                	mov    %edx,(%eax)
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	8b 00                	mov    (%eax),%eax
  8008c9:	83 e8 08             	sub    $0x8,%eax
  8008cc:	8b 50 04             	mov    0x4(%eax),%edx
  8008cf:	8b 00                	mov    (%eax),%eax
  8008d1:	eb 38                	jmp    80090b <getint+0x5d>
	else if (lflag)
  8008d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008d7:	74 1a                	je     8008f3 <getint+0x45>
		return va_arg(*ap, long);
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	8d 50 04             	lea    0x4(%eax),%edx
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	89 10                	mov    %edx,(%eax)
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	8b 00                	mov    (%eax),%eax
  8008eb:	83 e8 04             	sub    $0x4,%eax
  8008ee:	8b 00                	mov    (%eax),%eax
  8008f0:	99                   	cltd   
  8008f1:	eb 18                	jmp    80090b <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	8b 00                	mov    (%eax),%eax
  8008f8:	8d 50 04             	lea    0x4(%eax),%edx
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	89 10                	mov    %edx,(%eax)
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	8b 00                	mov    (%eax),%eax
  800905:	83 e8 04             	sub    $0x4,%eax
  800908:	8b 00                	mov    (%eax),%eax
  80090a:	99                   	cltd   
}
  80090b:	5d                   	pop    %ebp
  80090c:	c3                   	ret    

0080090d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80090d:	55                   	push   %ebp
  80090e:	89 e5                	mov    %esp,%ebp
  800910:	56                   	push   %esi
  800911:	53                   	push   %ebx
  800912:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800915:	eb 17                	jmp    80092e <vprintfmt+0x21>
			if (ch == '\0')
  800917:	85 db                	test   %ebx,%ebx
  800919:	0f 84 c1 03 00 00    	je     800ce0 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80091f:	83 ec 08             	sub    $0x8,%esp
  800922:	ff 75 0c             	pushl  0xc(%ebp)
  800925:	53                   	push   %ebx
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	ff d0                	call   *%eax
  80092b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80092e:	8b 45 10             	mov    0x10(%ebp),%eax
  800931:	8d 50 01             	lea    0x1(%eax),%edx
  800934:	89 55 10             	mov    %edx,0x10(%ebp)
  800937:	8a 00                	mov    (%eax),%al
  800939:	0f b6 d8             	movzbl %al,%ebx
  80093c:	83 fb 25             	cmp    $0x25,%ebx
  80093f:	75 d6                	jne    800917 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800941:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800945:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80094c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800953:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80095a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800961:	8b 45 10             	mov    0x10(%ebp),%eax
  800964:	8d 50 01             	lea    0x1(%eax),%edx
  800967:	89 55 10             	mov    %edx,0x10(%ebp)
  80096a:	8a 00                	mov    (%eax),%al
  80096c:	0f b6 d8             	movzbl %al,%ebx
  80096f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800972:	83 f8 5b             	cmp    $0x5b,%eax
  800975:	0f 87 3d 03 00 00    	ja     800cb8 <vprintfmt+0x3ab>
  80097b:	8b 04 85 f8 3d 80 00 	mov    0x803df8(,%eax,4),%eax
  800982:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800984:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800988:	eb d7                	jmp    800961 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80098a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80098e:	eb d1                	jmp    800961 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800990:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800997:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80099a:	89 d0                	mov    %edx,%eax
  80099c:	c1 e0 02             	shl    $0x2,%eax
  80099f:	01 d0                	add    %edx,%eax
  8009a1:	01 c0                	add    %eax,%eax
  8009a3:	01 d8                	add    %ebx,%eax
  8009a5:	83 e8 30             	sub    $0x30,%eax
  8009a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ae:	8a 00                	mov    (%eax),%al
  8009b0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009b3:	83 fb 2f             	cmp    $0x2f,%ebx
  8009b6:	7e 3e                	jle    8009f6 <vprintfmt+0xe9>
  8009b8:	83 fb 39             	cmp    $0x39,%ebx
  8009bb:	7f 39                	jg     8009f6 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009bd:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009c0:	eb d5                	jmp    800997 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c5:	83 c0 04             	add    $0x4,%eax
  8009c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8009cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ce:	83 e8 04             	sub    $0x4,%eax
  8009d1:	8b 00                	mov    (%eax),%eax
  8009d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009d6:	eb 1f                	jmp    8009f7 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009dc:	79 83                	jns    800961 <vprintfmt+0x54>
				width = 0;
  8009de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009e5:	e9 77 ff ff ff       	jmp    800961 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009ea:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009f1:	e9 6b ff ff ff       	jmp    800961 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009f6:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009fb:	0f 89 60 ff ff ff    	jns    800961 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a07:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a0e:	e9 4e ff ff ff       	jmp    800961 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a13:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a16:	e9 46 ff ff ff       	jmp    800961 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1e:	83 c0 04             	add    $0x4,%eax
  800a21:	89 45 14             	mov    %eax,0x14(%ebp)
  800a24:	8b 45 14             	mov    0x14(%ebp),%eax
  800a27:	83 e8 04             	sub    $0x4,%eax
  800a2a:	8b 00                	mov    (%eax),%eax
  800a2c:	83 ec 08             	sub    $0x8,%esp
  800a2f:	ff 75 0c             	pushl  0xc(%ebp)
  800a32:	50                   	push   %eax
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	ff d0                	call   *%eax
  800a38:	83 c4 10             	add    $0x10,%esp
			break;
  800a3b:	e9 9b 02 00 00       	jmp    800cdb <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a40:	8b 45 14             	mov    0x14(%ebp),%eax
  800a43:	83 c0 04             	add    $0x4,%eax
  800a46:	89 45 14             	mov    %eax,0x14(%ebp)
  800a49:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4c:	83 e8 04             	sub    $0x4,%eax
  800a4f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a51:	85 db                	test   %ebx,%ebx
  800a53:	79 02                	jns    800a57 <vprintfmt+0x14a>
				err = -err;
  800a55:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a57:	83 fb 64             	cmp    $0x64,%ebx
  800a5a:	7f 0b                	jg     800a67 <vprintfmt+0x15a>
  800a5c:	8b 34 9d 40 3c 80 00 	mov    0x803c40(,%ebx,4),%esi
  800a63:	85 f6                	test   %esi,%esi
  800a65:	75 19                	jne    800a80 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a67:	53                   	push   %ebx
  800a68:	68 e5 3d 80 00       	push   $0x803de5
  800a6d:	ff 75 0c             	pushl  0xc(%ebp)
  800a70:	ff 75 08             	pushl  0x8(%ebp)
  800a73:	e8 70 02 00 00       	call   800ce8 <printfmt>
  800a78:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a7b:	e9 5b 02 00 00       	jmp    800cdb <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a80:	56                   	push   %esi
  800a81:	68 ee 3d 80 00       	push   $0x803dee
  800a86:	ff 75 0c             	pushl  0xc(%ebp)
  800a89:	ff 75 08             	pushl  0x8(%ebp)
  800a8c:	e8 57 02 00 00       	call   800ce8 <printfmt>
  800a91:	83 c4 10             	add    $0x10,%esp
			break;
  800a94:	e9 42 02 00 00       	jmp    800cdb <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a99:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9c:	83 c0 04             	add    $0x4,%eax
  800a9f:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa5:	83 e8 04             	sub    $0x4,%eax
  800aa8:	8b 30                	mov    (%eax),%esi
  800aaa:	85 f6                	test   %esi,%esi
  800aac:	75 05                	jne    800ab3 <vprintfmt+0x1a6>
				p = "(null)";
  800aae:	be f1 3d 80 00       	mov    $0x803df1,%esi
			if (width > 0 && padc != '-')
  800ab3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ab7:	7e 6d                	jle    800b26 <vprintfmt+0x219>
  800ab9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800abd:	74 67                	je     800b26 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800abf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ac2:	83 ec 08             	sub    $0x8,%esp
  800ac5:	50                   	push   %eax
  800ac6:	56                   	push   %esi
  800ac7:	e8 1e 03 00 00       	call   800dea <strnlen>
  800acc:	83 c4 10             	add    $0x10,%esp
  800acf:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ad2:	eb 16                	jmp    800aea <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ad4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ad8:	83 ec 08             	sub    $0x8,%esp
  800adb:	ff 75 0c             	pushl  0xc(%ebp)
  800ade:	50                   	push   %eax
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	ff d0                	call   *%eax
  800ae4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ae7:	ff 4d e4             	decl   -0x1c(%ebp)
  800aea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aee:	7f e4                	jg     800ad4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800af0:	eb 34                	jmp    800b26 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800af2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800af6:	74 1c                	je     800b14 <vprintfmt+0x207>
  800af8:	83 fb 1f             	cmp    $0x1f,%ebx
  800afb:	7e 05                	jle    800b02 <vprintfmt+0x1f5>
  800afd:	83 fb 7e             	cmp    $0x7e,%ebx
  800b00:	7e 12                	jle    800b14 <vprintfmt+0x207>
					putch('?', putdat);
  800b02:	83 ec 08             	sub    $0x8,%esp
  800b05:	ff 75 0c             	pushl  0xc(%ebp)
  800b08:	6a 3f                	push   $0x3f
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	ff d0                	call   *%eax
  800b0f:	83 c4 10             	add    $0x10,%esp
  800b12:	eb 0f                	jmp    800b23 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b14:	83 ec 08             	sub    $0x8,%esp
  800b17:	ff 75 0c             	pushl  0xc(%ebp)
  800b1a:	53                   	push   %ebx
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	ff d0                	call   *%eax
  800b20:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b23:	ff 4d e4             	decl   -0x1c(%ebp)
  800b26:	89 f0                	mov    %esi,%eax
  800b28:	8d 70 01             	lea    0x1(%eax),%esi
  800b2b:	8a 00                	mov    (%eax),%al
  800b2d:	0f be d8             	movsbl %al,%ebx
  800b30:	85 db                	test   %ebx,%ebx
  800b32:	74 24                	je     800b58 <vprintfmt+0x24b>
  800b34:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b38:	78 b8                	js     800af2 <vprintfmt+0x1e5>
  800b3a:	ff 4d e0             	decl   -0x20(%ebp)
  800b3d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b41:	79 af                	jns    800af2 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b43:	eb 13                	jmp    800b58 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b45:	83 ec 08             	sub    $0x8,%esp
  800b48:	ff 75 0c             	pushl  0xc(%ebp)
  800b4b:	6a 20                	push   $0x20
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	ff d0                	call   *%eax
  800b52:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b55:	ff 4d e4             	decl   -0x1c(%ebp)
  800b58:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b5c:	7f e7                	jg     800b45 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b5e:	e9 78 01 00 00       	jmp    800cdb <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b63:	83 ec 08             	sub    $0x8,%esp
  800b66:	ff 75 e8             	pushl  -0x18(%ebp)
  800b69:	8d 45 14             	lea    0x14(%ebp),%eax
  800b6c:	50                   	push   %eax
  800b6d:	e8 3c fd ff ff       	call   8008ae <getint>
  800b72:	83 c4 10             	add    $0x10,%esp
  800b75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b78:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b81:	85 d2                	test   %edx,%edx
  800b83:	79 23                	jns    800ba8 <vprintfmt+0x29b>
				putch('-', putdat);
  800b85:	83 ec 08             	sub    $0x8,%esp
  800b88:	ff 75 0c             	pushl  0xc(%ebp)
  800b8b:	6a 2d                	push   $0x2d
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	ff d0                	call   *%eax
  800b92:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b9b:	f7 d8                	neg    %eax
  800b9d:	83 d2 00             	adc    $0x0,%edx
  800ba0:	f7 da                	neg    %edx
  800ba2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ba8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800baf:	e9 bc 00 00 00       	jmp    800c70 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bb4:	83 ec 08             	sub    $0x8,%esp
  800bb7:	ff 75 e8             	pushl  -0x18(%ebp)
  800bba:	8d 45 14             	lea    0x14(%ebp),%eax
  800bbd:	50                   	push   %eax
  800bbe:	e8 84 fc ff ff       	call   800847 <getuint>
  800bc3:	83 c4 10             	add    $0x10,%esp
  800bc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bcc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bd3:	e9 98 00 00 00       	jmp    800c70 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bd8:	83 ec 08             	sub    $0x8,%esp
  800bdb:	ff 75 0c             	pushl  0xc(%ebp)
  800bde:	6a 58                	push   $0x58
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	ff d0                	call   *%eax
  800be5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800be8:	83 ec 08             	sub    $0x8,%esp
  800beb:	ff 75 0c             	pushl  0xc(%ebp)
  800bee:	6a 58                	push   $0x58
  800bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf3:	ff d0                	call   *%eax
  800bf5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bf8:	83 ec 08             	sub    $0x8,%esp
  800bfb:	ff 75 0c             	pushl  0xc(%ebp)
  800bfe:	6a 58                	push   $0x58
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	ff d0                	call   *%eax
  800c05:	83 c4 10             	add    $0x10,%esp
			break;
  800c08:	e9 ce 00 00 00       	jmp    800cdb <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c0d:	83 ec 08             	sub    $0x8,%esp
  800c10:	ff 75 0c             	pushl  0xc(%ebp)
  800c13:	6a 30                	push   $0x30
  800c15:	8b 45 08             	mov    0x8(%ebp),%eax
  800c18:	ff d0                	call   *%eax
  800c1a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c1d:	83 ec 08             	sub    $0x8,%esp
  800c20:	ff 75 0c             	pushl  0xc(%ebp)
  800c23:	6a 78                	push   $0x78
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	ff d0                	call   *%eax
  800c2a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c30:	83 c0 04             	add    $0x4,%eax
  800c33:	89 45 14             	mov    %eax,0x14(%ebp)
  800c36:	8b 45 14             	mov    0x14(%ebp),%eax
  800c39:	83 e8 04             	sub    $0x4,%eax
  800c3c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c48:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c4f:	eb 1f                	jmp    800c70 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c51:	83 ec 08             	sub    $0x8,%esp
  800c54:	ff 75 e8             	pushl  -0x18(%ebp)
  800c57:	8d 45 14             	lea    0x14(%ebp),%eax
  800c5a:	50                   	push   %eax
  800c5b:	e8 e7 fb ff ff       	call   800847 <getuint>
  800c60:	83 c4 10             	add    $0x10,%esp
  800c63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c66:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c69:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c70:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c77:	83 ec 04             	sub    $0x4,%esp
  800c7a:	52                   	push   %edx
  800c7b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c7e:	50                   	push   %eax
  800c7f:	ff 75 f4             	pushl  -0xc(%ebp)
  800c82:	ff 75 f0             	pushl  -0x10(%ebp)
  800c85:	ff 75 0c             	pushl  0xc(%ebp)
  800c88:	ff 75 08             	pushl  0x8(%ebp)
  800c8b:	e8 00 fb ff ff       	call   800790 <printnum>
  800c90:	83 c4 20             	add    $0x20,%esp
			break;
  800c93:	eb 46                	jmp    800cdb <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c95:	83 ec 08             	sub    $0x8,%esp
  800c98:	ff 75 0c             	pushl  0xc(%ebp)
  800c9b:	53                   	push   %ebx
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	ff d0                	call   *%eax
  800ca1:	83 c4 10             	add    $0x10,%esp
			break;
  800ca4:	eb 35                	jmp    800cdb <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ca6:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
			break;
  800cad:	eb 2c                	jmp    800cdb <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800caf:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
			break;
  800cb6:	eb 23                	jmp    800cdb <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cb8:	83 ec 08             	sub    $0x8,%esp
  800cbb:	ff 75 0c             	pushl  0xc(%ebp)
  800cbe:	6a 25                	push   $0x25
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	ff d0                	call   *%eax
  800cc5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cc8:	ff 4d 10             	decl   0x10(%ebp)
  800ccb:	eb 03                	jmp    800cd0 <vprintfmt+0x3c3>
  800ccd:	ff 4d 10             	decl   0x10(%ebp)
  800cd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd3:	48                   	dec    %eax
  800cd4:	8a 00                	mov    (%eax),%al
  800cd6:	3c 25                	cmp    $0x25,%al
  800cd8:	75 f3                	jne    800ccd <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800cda:	90                   	nop
		}
	}
  800cdb:	e9 35 fc ff ff       	jmp    800915 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ce0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ce1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ce4:	5b                   	pop    %ebx
  800ce5:	5e                   	pop    %esi
  800ce6:	5d                   	pop    %ebp
  800ce7:	c3                   	ret    

00800ce8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cee:	8d 45 10             	lea    0x10(%ebp),%eax
  800cf1:	83 c0 04             	add    $0x4,%eax
  800cf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cf7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfa:	ff 75 f4             	pushl  -0xc(%ebp)
  800cfd:	50                   	push   %eax
  800cfe:	ff 75 0c             	pushl  0xc(%ebp)
  800d01:	ff 75 08             	pushl  0x8(%ebp)
  800d04:	e8 04 fc ff ff       	call   80090d <vprintfmt>
  800d09:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d0c:	90                   	nop
  800d0d:	c9                   	leave  
  800d0e:	c3                   	ret    

00800d0f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d0f:	55                   	push   %ebp
  800d10:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d15:	8b 40 08             	mov    0x8(%eax),%eax
  800d18:	8d 50 01             	lea    0x1(%eax),%edx
  800d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d24:	8b 10                	mov    (%eax),%edx
  800d26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d29:	8b 40 04             	mov    0x4(%eax),%eax
  800d2c:	39 c2                	cmp    %eax,%edx
  800d2e:	73 12                	jae    800d42 <sprintputch+0x33>
		*b->buf++ = ch;
  800d30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d33:	8b 00                	mov    (%eax),%eax
  800d35:	8d 48 01             	lea    0x1(%eax),%ecx
  800d38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3b:	89 0a                	mov    %ecx,(%edx)
  800d3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d40:	88 10                	mov    %dl,(%eax)
}
  800d42:	90                   	nop
  800d43:	5d                   	pop    %ebp
  800d44:	c3                   	ret    

00800d45 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d45:	55                   	push   %ebp
  800d46:	89 e5                	mov    %esp,%ebp
  800d48:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d54:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	01 d0                	add    %edx,%eax
  800d5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d6a:	74 06                	je     800d72 <vsnprintf+0x2d>
  800d6c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d70:	7f 07                	jg     800d79 <vsnprintf+0x34>
		return -E_INVAL;
  800d72:	b8 03 00 00 00       	mov    $0x3,%eax
  800d77:	eb 20                	jmp    800d99 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d79:	ff 75 14             	pushl  0x14(%ebp)
  800d7c:	ff 75 10             	pushl  0x10(%ebp)
  800d7f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d82:	50                   	push   %eax
  800d83:	68 0f 0d 80 00       	push   $0x800d0f
  800d88:	e8 80 fb ff ff       	call   80090d <vprintfmt>
  800d8d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d93:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d99:	c9                   	leave  
  800d9a:	c3                   	ret    

00800d9b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800da1:	8d 45 10             	lea    0x10(%ebp),%eax
  800da4:	83 c0 04             	add    $0x4,%eax
  800da7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800daa:	8b 45 10             	mov    0x10(%ebp),%eax
  800dad:	ff 75 f4             	pushl  -0xc(%ebp)
  800db0:	50                   	push   %eax
  800db1:	ff 75 0c             	pushl  0xc(%ebp)
  800db4:	ff 75 08             	pushl  0x8(%ebp)
  800db7:	e8 89 ff ff ff       	call   800d45 <vsnprintf>
  800dbc:	83 c4 10             	add    $0x10,%esp
  800dbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dc5:	c9                   	leave  
  800dc6:	c3                   	ret    

00800dc7 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dcd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dd4:	eb 06                	jmp    800ddc <strlen+0x15>
		n++;
  800dd6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd9:	ff 45 08             	incl   0x8(%ebp)
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	84 c0                	test   %al,%al
  800de3:	75 f1                	jne    800dd6 <strlen+0xf>
		n++;
	return n;
  800de5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800de8:	c9                   	leave  
  800de9:	c3                   	ret    

00800dea <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800df7:	eb 09                	jmp    800e02 <strnlen+0x18>
		n++;
  800df9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dfc:	ff 45 08             	incl   0x8(%ebp)
  800dff:	ff 4d 0c             	decl   0xc(%ebp)
  800e02:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e06:	74 09                	je     800e11 <strnlen+0x27>
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	8a 00                	mov    (%eax),%al
  800e0d:	84 c0                	test   %al,%al
  800e0f:	75 e8                	jne    800df9 <strnlen+0xf>
		n++;
	return n;
  800e11:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e14:	c9                   	leave  
  800e15:	c3                   	ret    

00800e16 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e22:	90                   	nop
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	8d 50 01             	lea    0x1(%eax),%edx
  800e29:	89 55 08             	mov    %edx,0x8(%ebp)
  800e2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e2f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e32:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e35:	8a 12                	mov    (%edx),%dl
  800e37:	88 10                	mov    %dl,(%eax)
  800e39:	8a 00                	mov    (%eax),%al
  800e3b:	84 c0                	test   %al,%al
  800e3d:	75 e4                	jne    800e23 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e42:	c9                   	leave  
  800e43:	c3                   	ret    

00800e44 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e44:	55                   	push   %ebp
  800e45:	89 e5                	mov    %esp,%ebp
  800e47:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e50:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e57:	eb 1f                	jmp    800e78 <strncpy+0x34>
		*dst++ = *src;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	8d 50 01             	lea    0x1(%eax),%edx
  800e5f:	89 55 08             	mov    %edx,0x8(%ebp)
  800e62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e65:	8a 12                	mov    (%edx),%dl
  800e67:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	84 c0                	test   %al,%al
  800e70:	74 03                	je     800e75 <strncpy+0x31>
			src++;
  800e72:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e75:	ff 45 fc             	incl   -0x4(%ebp)
  800e78:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e7e:	72 d9                	jb     800e59 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e80:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e83:	c9                   	leave  
  800e84:	c3                   	ret    

00800e85 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e95:	74 30                	je     800ec7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e97:	eb 16                	jmp    800eaf <strlcpy+0x2a>
			*dst++ = *src++;
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	8d 50 01             	lea    0x1(%eax),%edx
  800e9f:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eab:	8a 12                	mov    (%edx),%dl
  800ead:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800eaf:	ff 4d 10             	decl   0x10(%ebp)
  800eb2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb6:	74 09                	je     800ec1 <strlcpy+0x3c>
  800eb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	84 c0                	test   %al,%al
  800ebf:	75 d8                	jne    800e99 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ec7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecd:	29 c2                	sub    %eax,%edx
  800ecf:	89 d0                	mov    %edx,%eax
}
  800ed1:	c9                   	leave  
  800ed2:	c3                   	ret    

00800ed3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ed6:	eb 06                	jmp    800ede <strcmp+0xb>
		p++, q++;
  800ed8:	ff 45 08             	incl   0x8(%ebp)
  800edb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	8a 00                	mov    (%eax),%al
  800ee3:	84 c0                	test   %al,%al
  800ee5:	74 0e                	je     800ef5 <strcmp+0x22>
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	8a 10                	mov    (%eax),%dl
  800eec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eef:	8a 00                	mov    (%eax),%al
  800ef1:	38 c2                	cmp    %al,%dl
  800ef3:	74 e3                	je     800ed8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	8a 00                	mov    (%eax),%al
  800efa:	0f b6 d0             	movzbl %al,%edx
  800efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f00:	8a 00                	mov    (%eax),%al
  800f02:	0f b6 c0             	movzbl %al,%eax
  800f05:	29 c2                	sub    %eax,%edx
  800f07:	89 d0                	mov    %edx,%eax
}
  800f09:	5d                   	pop    %ebp
  800f0a:	c3                   	ret    

00800f0b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f0e:	eb 09                	jmp    800f19 <strncmp+0xe>
		n--, p++, q++;
  800f10:	ff 4d 10             	decl   0x10(%ebp)
  800f13:	ff 45 08             	incl   0x8(%ebp)
  800f16:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1d:	74 17                	je     800f36 <strncmp+0x2b>
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	84 c0                	test   %al,%al
  800f26:	74 0e                	je     800f36 <strncmp+0x2b>
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	8a 10                	mov    (%eax),%dl
  800f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f30:	8a 00                	mov    (%eax),%al
  800f32:	38 c2                	cmp    %al,%dl
  800f34:	74 da                	je     800f10 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3a:	75 07                	jne    800f43 <strncmp+0x38>
		return 0;
  800f3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800f41:	eb 14                	jmp    800f57 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	0f b6 d0             	movzbl %al,%edx
  800f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	0f b6 c0             	movzbl %al,%eax
  800f53:	29 c2                	sub    %eax,%edx
  800f55:	89 d0                	mov    %edx,%eax
}
  800f57:	5d                   	pop    %ebp
  800f58:	c3                   	ret    

00800f59 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
  800f5c:	83 ec 04             	sub    $0x4,%esp
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f65:	eb 12                	jmp    800f79 <strchr+0x20>
		if (*s == c)
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	8a 00                	mov    (%eax),%al
  800f6c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f6f:	75 05                	jne    800f76 <strchr+0x1d>
			return (char *) s;
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	eb 11                	jmp    800f87 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f76:	ff 45 08             	incl   0x8(%ebp)
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	8a 00                	mov    (%eax),%al
  800f7e:	84 c0                	test   %al,%al
  800f80:	75 e5                	jne    800f67 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f87:	c9                   	leave  
  800f88:	c3                   	ret    

00800f89 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
  800f8c:	83 ec 04             	sub    $0x4,%esp
  800f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f92:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f95:	eb 0d                	jmp    800fa4 <strfind+0x1b>
		if (*s == c)
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f9f:	74 0e                	je     800faf <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fa1:	ff 45 08             	incl   0x8(%ebp)
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	84 c0                	test   %al,%al
  800fab:	75 ea                	jne    800f97 <strfind+0xe>
  800fad:	eb 01                	jmp    800fb0 <strfind+0x27>
		if (*s == c)
			break;
  800faf:	90                   	nop
	return (char *) s;
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb3:	c9                   	leave  
  800fb4:	c3                   	ret    

00800fb5 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
  800fb8:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800fc1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fc5:	76 63                	jbe    80102a <memset+0x75>
		uint64 data_block = c;
  800fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fca:	99                   	cltd   
  800fcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fce:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800fd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd7:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800fdb:	c1 e0 08             	shl    $0x8,%eax
  800fde:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fe1:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fe7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fea:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800fee:	c1 e0 10             	shl    $0x10,%eax
  800ff1:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ff4:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ff7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ffa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ffd:	89 c2                	mov    %eax,%edx
  800fff:	b8 00 00 00 00       	mov    $0x0,%eax
  801004:	09 45 f0             	or     %eax,-0x10(%ebp)
  801007:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80100a:	eb 18                	jmp    801024 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80100c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80100f:	8d 41 08             	lea    0x8(%ecx),%eax
  801012:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801015:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801018:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80101b:	89 01                	mov    %eax,(%ecx)
  80101d:	89 51 04             	mov    %edx,0x4(%ecx)
  801020:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801024:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801028:	77 e2                	ja     80100c <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80102a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80102e:	74 23                	je     801053 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801030:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801033:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801036:	eb 0e                	jmp    801046 <memset+0x91>
			*p8++ = (uint8)c;
  801038:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103b:	8d 50 01             	lea    0x1(%eax),%edx
  80103e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801041:	8b 55 0c             	mov    0xc(%ebp),%edx
  801044:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801046:	8b 45 10             	mov    0x10(%ebp),%eax
  801049:	8d 50 ff             	lea    -0x1(%eax),%edx
  80104c:	89 55 10             	mov    %edx,0x10(%ebp)
  80104f:	85 c0                	test   %eax,%eax
  801051:	75 e5                	jne    801038 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801056:	c9                   	leave  
  801057:	c3                   	ret    

00801058 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
  80105b:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80105e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801061:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80106a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80106e:	76 24                	jbe    801094 <memcpy+0x3c>
		while(n >= 8){
  801070:	eb 1c                	jmp    80108e <memcpy+0x36>
			*d64 = *s64;
  801072:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801075:	8b 50 04             	mov    0x4(%eax),%edx
  801078:	8b 00                	mov    (%eax),%eax
  80107a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80107d:	89 01                	mov    %eax,(%ecx)
  80107f:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801082:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801086:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80108a:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80108e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801092:	77 de                	ja     801072 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801094:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801098:	74 31                	je     8010cb <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80109a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8010a6:	eb 16                	jmp    8010be <memcpy+0x66>
			*d8++ = *s8++;
  8010a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010ab:	8d 50 01             	lea    0x1(%eax),%edx
  8010ae:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8010b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010b4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010b7:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8010ba:	8a 12                	mov    (%edx),%dl
  8010bc:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8010be:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c4:	89 55 10             	mov    %edx,0x10(%ebp)
  8010c7:	85 c0                	test   %eax,%eax
  8010c9:	75 dd                	jne    8010a8 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ce:	c9                   	leave  
  8010cf:	c3                   	ret    

008010d0 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010df:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010e8:	73 50                	jae    80113a <memmove+0x6a>
  8010ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f0:	01 d0                	add    %edx,%eax
  8010f2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010f5:	76 43                	jbe    80113a <memmove+0x6a>
		s += n;
  8010f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fa:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801100:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801103:	eb 10                	jmp    801115 <memmove+0x45>
			*--d = *--s;
  801105:	ff 4d f8             	decl   -0x8(%ebp)
  801108:	ff 4d fc             	decl   -0x4(%ebp)
  80110b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80110e:	8a 10                	mov    (%eax),%dl
  801110:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801113:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801115:	8b 45 10             	mov    0x10(%ebp),%eax
  801118:	8d 50 ff             	lea    -0x1(%eax),%edx
  80111b:	89 55 10             	mov    %edx,0x10(%ebp)
  80111e:	85 c0                	test   %eax,%eax
  801120:	75 e3                	jne    801105 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801122:	eb 23                	jmp    801147 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801124:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801127:	8d 50 01             	lea    0x1(%eax),%edx
  80112a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80112d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801130:	8d 4a 01             	lea    0x1(%edx),%ecx
  801133:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801136:	8a 12                	mov    (%edx),%dl
  801138:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80113a:	8b 45 10             	mov    0x10(%ebp),%eax
  80113d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801140:	89 55 10             	mov    %edx,0x10(%ebp)
  801143:	85 c0                	test   %eax,%eax
  801145:	75 dd                	jne    801124 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80114a:	c9                   	leave  
  80114b:	c3                   	ret    

0080114c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
  801155:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80115e:	eb 2a                	jmp    80118a <memcmp+0x3e>
		if (*s1 != *s2)
  801160:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801163:	8a 10                	mov    (%eax),%dl
  801165:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801168:	8a 00                	mov    (%eax),%al
  80116a:	38 c2                	cmp    %al,%dl
  80116c:	74 16                	je     801184 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80116e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	0f b6 d0             	movzbl %al,%edx
  801176:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	0f b6 c0             	movzbl %al,%eax
  80117e:	29 c2                	sub    %eax,%edx
  801180:	89 d0                	mov    %edx,%eax
  801182:	eb 18                	jmp    80119c <memcmp+0x50>
		s1++, s2++;
  801184:	ff 45 fc             	incl   -0x4(%ebp)
  801187:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80118a:	8b 45 10             	mov    0x10(%ebp),%eax
  80118d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801190:	89 55 10             	mov    %edx,0x10(%ebp)
  801193:	85 c0                	test   %eax,%eax
  801195:	75 c9                	jne    801160 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801197:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80119c:	c9                   	leave  
  80119d:	c3                   	ret    

0080119e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80119e:	55                   	push   %ebp
  80119f:	89 e5                	mov    %esp,%ebp
  8011a1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011aa:	01 d0                	add    %edx,%eax
  8011ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011af:	eb 15                	jmp    8011c6 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b4:	8a 00                	mov    (%eax),%al
  8011b6:	0f b6 d0             	movzbl %al,%edx
  8011b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bc:	0f b6 c0             	movzbl %al,%eax
  8011bf:	39 c2                	cmp    %eax,%edx
  8011c1:	74 0d                	je     8011d0 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011c3:	ff 45 08             	incl   0x8(%ebp)
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011cc:	72 e3                	jb     8011b1 <memfind+0x13>
  8011ce:	eb 01                	jmp    8011d1 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011d0:	90                   	nop
	return (void *) s;
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011d4:	c9                   	leave  
  8011d5:	c3                   	ret    

008011d6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011d6:	55                   	push   %ebp
  8011d7:	89 e5                	mov    %esp,%ebp
  8011d9:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011e3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011ea:	eb 03                	jmp    8011ef <strtol+0x19>
		s++;
  8011ec:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	8a 00                	mov    (%eax),%al
  8011f4:	3c 20                	cmp    $0x20,%al
  8011f6:	74 f4                	je     8011ec <strtol+0x16>
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	8a 00                	mov    (%eax),%al
  8011fd:	3c 09                	cmp    $0x9,%al
  8011ff:	74 eb                	je     8011ec <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801201:	8b 45 08             	mov    0x8(%ebp),%eax
  801204:	8a 00                	mov    (%eax),%al
  801206:	3c 2b                	cmp    $0x2b,%al
  801208:	75 05                	jne    80120f <strtol+0x39>
		s++;
  80120a:	ff 45 08             	incl   0x8(%ebp)
  80120d:	eb 13                	jmp    801222 <strtol+0x4c>
	else if (*s == '-')
  80120f:	8b 45 08             	mov    0x8(%ebp),%eax
  801212:	8a 00                	mov    (%eax),%al
  801214:	3c 2d                	cmp    $0x2d,%al
  801216:	75 0a                	jne    801222 <strtol+0x4c>
		s++, neg = 1;
  801218:	ff 45 08             	incl   0x8(%ebp)
  80121b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801222:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801226:	74 06                	je     80122e <strtol+0x58>
  801228:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80122c:	75 20                	jne    80124e <strtol+0x78>
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	3c 30                	cmp    $0x30,%al
  801235:	75 17                	jne    80124e <strtol+0x78>
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	40                   	inc    %eax
  80123b:	8a 00                	mov    (%eax),%al
  80123d:	3c 78                	cmp    $0x78,%al
  80123f:	75 0d                	jne    80124e <strtol+0x78>
		s += 2, base = 16;
  801241:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801245:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80124c:	eb 28                	jmp    801276 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80124e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801252:	75 15                	jne    801269 <strtol+0x93>
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	3c 30                	cmp    $0x30,%al
  80125b:	75 0c                	jne    801269 <strtol+0x93>
		s++, base = 8;
  80125d:	ff 45 08             	incl   0x8(%ebp)
  801260:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801267:	eb 0d                	jmp    801276 <strtol+0xa0>
	else if (base == 0)
  801269:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80126d:	75 07                	jne    801276 <strtol+0xa0>
		base = 10;
  80126f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801276:	8b 45 08             	mov    0x8(%ebp),%eax
  801279:	8a 00                	mov    (%eax),%al
  80127b:	3c 2f                	cmp    $0x2f,%al
  80127d:	7e 19                	jle    801298 <strtol+0xc2>
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	3c 39                	cmp    $0x39,%al
  801286:	7f 10                	jg     801298 <strtol+0xc2>
			dig = *s - '0';
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	8a 00                	mov    (%eax),%al
  80128d:	0f be c0             	movsbl %al,%eax
  801290:	83 e8 30             	sub    $0x30,%eax
  801293:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801296:	eb 42                	jmp    8012da <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801298:	8b 45 08             	mov    0x8(%ebp),%eax
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	3c 60                	cmp    $0x60,%al
  80129f:	7e 19                	jle    8012ba <strtol+0xe4>
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	8a 00                	mov    (%eax),%al
  8012a6:	3c 7a                	cmp    $0x7a,%al
  8012a8:	7f 10                	jg     8012ba <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	8a 00                	mov    (%eax),%al
  8012af:	0f be c0             	movsbl %al,%eax
  8012b2:	83 e8 57             	sub    $0x57,%eax
  8012b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012b8:	eb 20                	jmp    8012da <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	8a 00                	mov    (%eax),%al
  8012bf:	3c 40                	cmp    $0x40,%al
  8012c1:	7e 39                	jle    8012fc <strtol+0x126>
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	8a 00                	mov    (%eax),%al
  8012c8:	3c 5a                	cmp    $0x5a,%al
  8012ca:	7f 30                	jg     8012fc <strtol+0x126>
			dig = *s - 'A' + 10;
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	8a 00                	mov    (%eax),%al
  8012d1:	0f be c0             	movsbl %al,%eax
  8012d4:	83 e8 37             	sub    $0x37,%eax
  8012d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012dd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012e0:	7d 19                	jge    8012fb <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012e2:	ff 45 08             	incl   0x8(%ebp)
  8012e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e8:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012ec:	89 c2                	mov    %eax,%edx
  8012ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012f1:	01 d0                	add    %edx,%eax
  8012f3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012f6:	e9 7b ff ff ff       	jmp    801276 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012fb:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801300:	74 08                	je     80130a <strtol+0x134>
		*endptr = (char *) s;
  801302:	8b 45 0c             	mov    0xc(%ebp),%eax
  801305:	8b 55 08             	mov    0x8(%ebp),%edx
  801308:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80130a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80130e:	74 07                	je     801317 <strtol+0x141>
  801310:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801313:	f7 d8                	neg    %eax
  801315:	eb 03                	jmp    80131a <strtol+0x144>
  801317:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80131a:	c9                   	leave  
  80131b:	c3                   	ret    

0080131c <ltostr>:

void
ltostr(long value, char *str)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801322:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801329:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801330:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801334:	79 13                	jns    801349 <ltostr+0x2d>
	{
		neg = 1;
  801336:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80133d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801340:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801343:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801346:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801351:	99                   	cltd   
  801352:	f7 f9                	idiv   %ecx
  801354:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801357:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135a:	8d 50 01             	lea    0x1(%eax),%edx
  80135d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801360:	89 c2                	mov    %eax,%edx
  801362:	8b 45 0c             	mov    0xc(%ebp),%eax
  801365:	01 d0                	add    %edx,%eax
  801367:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80136a:	83 c2 30             	add    $0x30,%edx
  80136d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80136f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801372:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801377:	f7 e9                	imul   %ecx
  801379:	c1 fa 02             	sar    $0x2,%edx
  80137c:	89 c8                	mov    %ecx,%eax
  80137e:	c1 f8 1f             	sar    $0x1f,%eax
  801381:	29 c2                	sub    %eax,%edx
  801383:	89 d0                	mov    %edx,%eax
  801385:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801388:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80138c:	75 bb                	jne    801349 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80138e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801395:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801398:	48                   	dec    %eax
  801399:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80139c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013a0:	74 3d                	je     8013df <ltostr+0xc3>
		start = 1 ;
  8013a2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013a9:	eb 34                	jmp    8013df <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b1:	01 d0                	add    %edx,%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013be:	01 c2                	add    %eax,%edx
  8013c0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c6:	01 c8                	add    %ecx,%eax
  8013c8:	8a 00                	mov    (%eax),%al
  8013ca:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d2:	01 c2                	add    %eax,%edx
  8013d4:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013d7:	88 02                	mov    %al,(%edx)
		start++ ;
  8013d9:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013dc:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013e5:	7c c4                	jl     8013ab <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013e7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ed:	01 d0                	add    %edx,%eax
  8013ef:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013f2:	90                   	nop
  8013f3:	c9                   	leave  
  8013f4:	c3                   	ret    

008013f5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013f5:	55                   	push   %ebp
  8013f6:	89 e5                	mov    %esp,%ebp
  8013f8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013fb:	ff 75 08             	pushl  0x8(%ebp)
  8013fe:	e8 c4 f9 ff ff       	call   800dc7 <strlen>
  801403:	83 c4 04             	add    $0x4,%esp
  801406:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801409:	ff 75 0c             	pushl  0xc(%ebp)
  80140c:	e8 b6 f9 ff ff       	call   800dc7 <strlen>
  801411:	83 c4 04             	add    $0x4,%esp
  801414:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801417:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80141e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801425:	eb 17                	jmp    80143e <strcconcat+0x49>
		final[s] = str1[s] ;
  801427:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80142a:	8b 45 10             	mov    0x10(%ebp),%eax
  80142d:	01 c2                	add    %eax,%edx
  80142f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	01 c8                	add    %ecx,%eax
  801437:	8a 00                	mov    (%eax),%al
  801439:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80143b:	ff 45 fc             	incl   -0x4(%ebp)
  80143e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801441:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801444:	7c e1                	jl     801427 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801446:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80144d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801454:	eb 1f                	jmp    801475 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801456:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801459:	8d 50 01             	lea    0x1(%eax),%edx
  80145c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80145f:	89 c2                	mov    %eax,%edx
  801461:	8b 45 10             	mov    0x10(%ebp),%eax
  801464:	01 c2                	add    %eax,%edx
  801466:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801469:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146c:	01 c8                	add    %ecx,%eax
  80146e:	8a 00                	mov    (%eax),%al
  801470:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801472:	ff 45 f8             	incl   -0x8(%ebp)
  801475:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801478:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80147b:	7c d9                	jl     801456 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80147d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801480:	8b 45 10             	mov    0x10(%ebp),%eax
  801483:	01 d0                	add    %edx,%eax
  801485:	c6 00 00             	movb   $0x0,(%eax)
}
  801488:	90                   	nop
  801489:	c9                   	leave  
  80148a:	c3                   	ret    

0080148b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80148b:	55                   	push   %ebp
  80148c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80148e:	8b 45 14             	mov    0x14(%ebp),%eax
  801491:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801497:	8b 45 14             	mov    0x14(%ebp),%eax
  80149a:	8b 00                	mov    (%eax),%eax
  80149c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a6:	01 d0                	add    %edx,%eax
  8014a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014ae:	eb 0c                	jmp    8014bc <strsplit+0x31>
			*string++ = 0;
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	8d 50 01             	lea    0x1(%eax),%edx
  8014b6:	89 55 08             	mov    %edx,0x8(%ebp)
  8014b9:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	8a 00                	mov    (%eax),%al
  8014c1:	84 c0                	test   %al,%al
  8014c3:	74 18                	je     8014dd <strsplit+0x52>
  8014c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c8:	8a 00                	mov    (%eax),%al
  8014ca:	0f be c0             	movsbl %al,%eax
  8014cd:	50                   	push   %eax
  8014ce:	ff 75 0c             	pushl  0xc(%ebp)
  8014d1:	e8 83 fa ff ff       	call   800f59 <strchr>
  8014d6:	83 c4 08             	add    $0x8,%esp
  8014d9:	85 c0                	test   %eax,%eax
  8014db:	75 d3                	jne    8014b0 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e0:	8a 00                	mov    (%eax),%al
  8014e2:	84 c0                	test   %al,%al
  8014e4:	74 5a                	je     801540 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e9:	8b 00                	mov    (%eax),%eax
  8014eb:	83 f8 0f             	cmp    $0xf,%eax
  8014ee:	75 07                	jne    8014f7 <strsplit+0x6c>
		{
			return 0;
  8014f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f5:	eb 66                	jmp    80155d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014fa:	8b 00                	mov    (%eax),%eax
  8014fc:	8d 48 01             	lea    0x1(%eax),%ecx
  8014ff:	8b 55 14             	mov    0x14(%ebp),%edx
  801502:	89 0a                	mov    %ecx,(%edx)
  801504:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80150b:	8b 45 10             	mov    0x10(%ebp),%eax
  80150e:	01 c2                	add    %eax,%edx
  801510:	8b 45 08             	mov    0x8(%ebp),%eax
  801513:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801515:	eb 03                	jmp    80151a <strsplit+0x8f>
			string++;
  801517:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80151a:	8b 45 08             	mov    0x8(%ebp),%eax
  80151d:	8a 00                	mov    (%eax),%al
  80151f:	84 c0                	test   %al,%al
  801521:	74 8b                	je     8014ae <strsplit+0x23>
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	8a 00                	mov    (%eax),%al
  801528:	0f be c0             	movsbl %al,%eax
  80152b:	50                   	push   %eax
  80152c:	ff 75 0c             	pushl  0xc(%ebp)
  80152f:	e8 25 fa ff ff       	call   800f59 <strchr>
  801534:	83 c4 08             	add    $0x8,%esp
  801537:	85 c0                	test   %eax,%eax
  801539:	74 dc                	je     801517 <strsplit+0x8c>
			string++;
	}
  80153b:	e9 6e ff ff ff       	jmp    8014ae <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801540:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801541:	8b 45 14             	mov    0x14(%ebp),%eax
  801544:	8b 00                	mov    (%eax),%eax
  801546:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80154d:	8b 45 10             	mov    0x10(%ebp),%eax
  801550:	01 d0                	add    %edx,%eax
  801552:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801558:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80155d:	c9                   	leave  
  80155e:	c3                   	ret    

0080155f <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
  801562:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801565:	8b 45 08             	mov    0x8(%ebp),%eax
  801568:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80156b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801572:	eb 4a                	jmp    8015be <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801574:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	01 c2                	add    %eax,%edx
  80157c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80157f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801582:	01 c8                	add    %ecx,%eax
  801584:	8a 00                	mov    (%eax),%al
  801586:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801588:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80158b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158e:	01 d0                	add    %edx,%eax
  801590:	8a 00                	mov    (%eax),%al
  801592:	3c 40                	cmp    $0x40,%al
  801594:	7e 25                	jle    8015bb <str2lower+0x5c>
  801596:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801599:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159c:	01 d0                	add    %edx,%eax
  80159e:	8a 00                	mov    (%eax),%al
  8015a0:	3c 5a                	cmp    $0x5a,%al
  8015a2:	7f 17                	jg     8015bb <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8015a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015aa:	01 d0                	add    %edx,%eax
  8015ac:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015af:	8b 55 08             	mov    0x8(%ebp),%edx
  8015b2:	01 ca                	add    %ecx,%edx
  8015b4:	8a 12                	mov    (%edx),%dl
  8015b6:	83 c2 20             	add    $0x20,%edx
  8015b9:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8015bb:	ff 45 fc             	incl   -0x4(%ebp)
  8015be:	ff 75 0c             	pushl  0xc(%ebp)
  8015c1:	e8 01 f8 ff ff       	call   800dc7 <strlen>
  8015c6:	83 c4 04             	add    $0x4,%esp
  8015c9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015cc:	7f a6                	jg     801574 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8015ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    

008015d3 <insert_page_alloc>:

LIST_HEAD(PageAllocList, PageAlloc);
static struct PageAllocList page_alloc_list;

static void insert_page_alloc(uint32 start, uint32 size)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	83 ec 18             	sub    $0x18,%esp
	struct PageAlloc *node =
  8015d9:	83 ec 0c             	sub    $0xc,%esp
  8015dc:	6a 10                	push   $0x10
  8015de:	e8 b2 15 00 00       	call   802b95 <alloc_block>
  8015e3:	83 c4 10             	add    $0x10,%esp
  8015e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		(struct PageAlloc *) alloc_block(sizeof(struct PageAlloc));
	if (node == NULL)
  8015e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015ed:	75 14                	jne    801603 <insert_page_alloc+0x30>
		panic("insert_page_alloc: no space for metadata");
  8015ef:	83 ec 04             	sub    $0x4,%esp
  8015f2:	68 68 3f 80 00       	push   $0x803f68
  8015f7:	6a 14                	push   $0x14
  8015f9:	68 91 3f 80 00       	push   $0x803f91
  8015fe:	e8 fd ed ff ff       	call   800400 <_panic>

	node->start = start;
  801603:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801606:	8b 55 08             	mov    0x8(%ebp),%edx
  801609:	89 10                	mov    %edx,(%eax)
	node->size  = size;
  80160b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80160e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801611:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageAlloc *it, *prev = NULL;
  801614:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	LIST_FOREACH(it, &page_alloc_list) {
  80161b:	a1 24 50 80 00       	mov    0x805024,%eax
  801620:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801623:	eb 18                	jmp    80163d <insert_page_alloc+0x6a>
		if (start < it->start)
  801625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801628:	8b 00                	mov    (%eax),%eax
  80162a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80162d:	77 37                	ja     801666 <insert_page_alloc+0x93>
			break;
		prev = it;
  80162f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801632:	89 45 f0             	mov    %eax,-0x10(%ebp)

	node->start = start;
	node->size  = size;

	struct PageAlloc *it, *prev = NULL;
	LIST_FOREACH(it, &page_alloc_list) {
  801635:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80163a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80163d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801641:	74 08                	je     80164b <insert_page_alloc+0x78>
  801643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801646:	8b 40 08             	mov    0x8(%eax),%eax
  801649:	eb 05                	jmp    801650 <insert_page_alloc+0x7d>
  80164b:	b8 00 00 00 00       	mov    $0x0,%eax
  801650:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801655:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80165a:	85 c0                	test   %eax,%eax
  80165c:	75 c7                	jne    801625 <insert_page_alloc+0x52>
  80165e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801662:	75 c1                	jne    801625 <insert_page_alloc+0x52>
  801664:	eb 01                	jmp    801667 <insert_page_alloc+0x94>
		if (start < it->start)
			break;
  801666:	90                   	nop
		prev = it;
	}

	if (prev == NULL)
  801667:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80166b:	75 64                	jne    8016d1 <insert_page_alloc+0xfe>
		LIST_INSERT_HEAD(&page_alloc_list, node);
  80166d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801671:	75 14                	jne    801687 <insert_page_alloc+0xb4>
  801673:	83 ec 04             	sub    $0x4,%esp
  801676:	68 a0 3f 80 00       	push   $0x803fa0
  80167b:	6a 21                	push   $0x21
  80167d:	68 91 3f 80 00       	push   $0x803f91
  801682:	e8 79 ed ff ff       	call   800400 <_panic>
  801687:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80168d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801690:	89 50 08             	mov    %edx,0x8(%eax)
  801693:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801696:	8b 40 08             	mov    0x8(%eax),%eax
  801699:	85 c0                	test   %eax,%eax
  80169b:	74 0d                	je     8016aa <insert_page_alloc+0xd7>
  80169d:	a1 24 50 80 00       	mov    0x805024,%eax
  8016a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016a5:	89 50 0c             	mov    %edx,0xc(%eax)
  8016a8:	eb 08                	jmp    8016b2 <insert_page_alloc+0xdf>
  8016aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ad:	a3 28 50 80 00       	mov    %eax,0x805028
  8016b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b5:	a3 24 50 80 00       	mov    %eax,0x805024
  8016ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016bd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8016c4:	a1 30 50 80 00       	mov    0x805030,%eax
  8016c9:	40                   	inc    %eax
  8016ca:	a3 30 50 80 00       	mov    %eax,0x805030
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
}
  8016cf:	eb 71                	jmp    801742 <insert_page_alloc+0x16f>
	}

	if (prev == NULL)
		LIST_INSERT_HEAD(&page_alloc_list, node);
	else
		LIST_INSERT_AFTER(&page_alloc_list, prev, node);
  8016d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016d5:	74 06                	je     8016dd <insert_page_alloc+0x10a>
  8016d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016db:	75 14                	jne    8016f1 <insert_page_alloc+0x11e>
  8016dd:	83 ec 04             	sub    $0x4,%esp
  8016e0:	68 c4 3f 80 00       	push   $0x803fc4
  8016e5:	6a 23                	push   $0x23
  8016e7:	68 91 3f 80 00       	push   $0x803f91
  8016ec:	e8 0f ed ff ff       	call   800400 <_panic>
  8016f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f4:	8b 50 08             	mov    0x8(%eax),%edx
  8016f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016fa:	89 50 08             	mov    %edx,0x8(%eax)
  8016fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801700:	8b 40 08             	mov    0x8(%eax),%eax
  801703:	85 c0                	test   %eax,%eax
  801705:	74 0c                	je     801713 <insert_page_alloc+0x140>
  801707:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170a:	8b 40 08             	mov    0x8(%eax),%eax
  80170d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801710:	89 50 0c             	mov    %edx,0xc(%eax)
  801713:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801716:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801719:	89 50 08             	mov    %edx,0x8(%eax)
  80171c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80171f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801722:	89 50 0c             	mov    %edx,0xc(%eax)
  801725:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801728:	8b 40 08             	mov    0x8(%eax),%eax
  80172b:	85 c0                	test   %eax,%eax
  80172d:	75 08                	jne    801737 <insert_page_alloc+0x164>
  80172f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801732:	a3 28 50 80 00       	mov    %eax,0x805028
  801737:	a1 30 50 80 00       	mov    0x805030,%eax
  80173c:	40                   	inc    %eax
  80173d:	a3 30 50 80 00       	mov    %eax,0x805030
}
  801742:	90                   	nop
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <recompute_page_alloc_break>:

static void recompute_page_alloc_break()
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	83 ec 10             	sub    $0x10,%esp
	if (LIST_EMPTY(&page_alloc_list)) {
  80174b:	a1 24 50 80 00       	mov    0x805024,%eax
  801750:	85 c0                	test   %eax,%eax
  801752:	75 0c                	jne    801760 <recompute_page_alloc_break+0x1b>
		uheapPageAllocBreak = uheapPageAllocStart;
  801754:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801759:	a3 68 d0 81 00       	mov    %eax,0x81d068
		return;
  80175e:	eb 67                	jmp    8017c7 <recompute_page_alloc_break+0x82>
	}

	uint32 maxEnd = uheapPageAllocStart;
  801760:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801765:	89 45 fc             	mov    %eax,-0x4(%ebp)
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801768:	a1 24 50 80 00       	mov    0x805024,%eax
  80176d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801770:	eb 26                	jmp    801798 <recompute_page_alloc_break+0x53>
		uint32 end = it->start + it->size;
  801772:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801775:	8b 10                	mov    (%eax),%edx
  801777:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80177a:	8b 40 04             	mov    0x4(%eax),%eax
  80177d:	01 d0                	add    %edx,%eax
  80177f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (end > maxEnd)
  801782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801785:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801788:	76 06                	jbe    801790 <recompute_page_alloc_break+0x4b>
			maxEnd = end;
  80178a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178d:	89 45 fc             	mov    %eax,-0x4(%ebp)
		return;
	}

	uint32 maxEnd = uheapPageAllocStart;
	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801790:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801795:	89 45 f8             	mov    %eax,-0x8(%ebp)
  801798:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80179c:	74 08                	je     8017a6 <recompute_page_alloc_break+0x61>
  80179e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a1:	8b 40 08             	mov    0x8(%eax),%eax
  8017a4:	eb 05                	jmp    8017ab <recompute_page_alloc_break+0x66>
  8017a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ab:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8017b0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8017b5:	85 c0                	test   %eax,%eax
  8017b7:	75 b9                	jne    801772 <recompute_page_alloc_break+0x2d>
  8017b9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017bd:	75 b3                	jne    801772 <recompute_page_alloc_break+0x2d>
		uint32 end = it->start + it->size;
		if (end > maxEnd)
			maxEnd = end;
	}
	uheapPageAllocBreak = maxEnd;
  8017bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017c2:	a3 68 d0 81 00       	mov    %eax,0x81d068
}
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    

008017c9 <alloc_pages_custom_fit>:

//=================================
// CUSTOM FIT page allocation
//=================================
void* alloc_pages_custom_fit(uint32 size)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	83 ec 48             	sub    $0x48,%esp

	uint32 required_size = ROUNDUP(size, PAGE_SIZE);
  8017cf:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8017d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8017d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017dc:	01 d0                	add    %edx,%eax
  8017de:	48                   	dec    %eax
  8017df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8017e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ea:	f7 75 d8             	divl   -0x28(%ebp)
  8017ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017f0:	29 d0                	sub    %edx,%eax
  8017f2:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (required_size == 0)
  8017f5:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8017f9:	75 0a                	jne    801805 <alloc_pages_custom_fit+0x3c>
		return NULL;
  8017fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801800:	e9 7e 01 00 00       	jmp    801983 <alloc_pages_custom_fit+0x1ba>

	void *exact_fit = NULL;
  801805:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint8 has_exact = 0;
  80180c:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	void *worst_fit = NULL;
  801810:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 worst_fit_size = 0;
  801817:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)



	uint32 cur = uheapPageAllocStart;
  80181e:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801823:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801826:	a1 24 50 80 00       	mov    0x805024,%eax
  80182b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80182e:	eb 69                	jmp    801899 <alloc_pages_custom_fit+0xd0>
		if (it->start > cur) {
  801830:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801833:	8b 00                	mov    (%eax),%eax
  801835:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801838:	76 47                	jbe    801881 <alloc_pages_custom_fit+0xb8>

			uint32 hole_start = cur;
  80183a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80183d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			uint32 hole_size  = it->start - cur;
  801840:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801843:	8b 00                	mov    (%eax),%eax
  801845:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801848:	89 45 c8             	mov    %eax,-0x38(%ebp)

			if (hole_size >= required_size) {
  80184b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80184e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801851:	72 2e                	jb     801881 <alloc_pages_custom_fit+0xb8>
				if (!has_exact && hole_size == required_size) {
  801853:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801857:	75 14                	jne    80186d <alloc_pages_custom_fit+0xa4>
  801859:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80185c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80185f:	75 0c                	jne    80186d <alloc_pages_custom_fit+0xa4>
					exact_fit = (void*)hole_start;
  801861:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801864:	89 45 f4             	mov    %eax,-0xc(%ebp)
					has_exact = 1;
  801867:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  80186b:	eb 14                	jmp    801881 <alloc_pages_custom_fit+0xb8>
				} else if (hole_size > worst_fit_size) {
  80186d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801870:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801873:	76 0c                	jbe    801881 <alloc_pages_custom_fit+0xb8>
					worst_fit      = (void*)hole_start;
  801875:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801878:	89 45 ec             	mov    %eax,-0x14(%ebp)
					worst_fit_size = hole_size;
  80187b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80187e:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
			}
		}
		cur = it->start + it->size;
  801881:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801884:	8b 10                	mov    (%eax),%edx
  801886:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801889:	8b 40 04             	mov    0x4(%eax),%eax
  80188c:	01 d0                	add    %edx,%eax
  80188e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 cur = uheapPageAllocStart;
	struct PageAlloc *it;


	LIST_FOREACH(it, &page_alloc_list) {
  801891:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801896:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801899:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80189d:	74 08                	je     8018a7 <alloc_pages_custom_fit+0xde>
  80189f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018a2:	8b 40 08             	mov    0x8(%eax),%eax
  8018a5:	eb 05                	jmp    8018ac <alloc_pages_custom_fit+0xe3>
  8018a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ac:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8018b1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8018b6:	85 c0                	test   %eax,%eax
  8018b8:	0f 85 72 ff ff ff    	jne    801830 <alloc_pages_custom_fit+0x67>
  8018be:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018c2:	0f 85 68 ff ff ff    	jne    801830 <alloc_pages_custom_fit+0x67>
		}
		cur = it->start + it->size;
	}


	if (uheapPageAllocBreak > cur) {
  8018c8:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8018cd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8018d0:	76 47                	jbe    801919 <alloc_pages_custom_fit+0x150>
		uint32 hole_start = cur;
  8018d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018d5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 hole_size  = uheapPageAllocBreak - cur;
  8018d8:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8018dd:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8018e0:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (hole_size >= required_size) {
  8018e3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8018e6:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8018e9:	72 2e                	jb     801919 <alloc_pages_custom_fit+0x150>
			if (!has_exact && hole_size == required_size) {
  8018eb:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  8018ef:	75 14                	jne    801905 <alloc_pages_custom_fit+0x13c>
  8018f1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8018f4:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8018f7:	75 0c                	jne    801905 <alloc_pages_custom_fit+0x13c>
				exact_fit = (void*)hole_start;
  8018f9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8018fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
				has_exact = 1;
  8018ff:	c6 45 f3 01          	movb   $0x1,-0xd(%ebp)
  801903:	eb 14                	jmp    801919 <alloc_pages_custom_fit+0x150>
			} else if (hole_size > worst_fit_size) {
  801905:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801908:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80190b:	76 0c                	jbe    801919 <alloc_pages_custom_fit+0x150>
				worst_fit      = (void*)hole_start;
  80190d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801910:	89 45 ec             	mov    %eax,-0x14(%ebp)
				worst_fit_size = hole_size;
  801913:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801916:	89 45 e8             	mov    %eax,-0x18(%ebp)
			}
		}
	}

	void *result = NULL;
  801919:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

	if (has_exact) {
  801920:	80 7d f3 00          	cmpb   $0x0,-0xd(%ebp)
  801924:	74 08                	je     80192e <alloc_pages_custom_fit+0x165>

		result = exact_fit;
  801926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801929:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80192c:	eb 40                	jmp    80196e <alloc_pages_custom_fit+0x1a5>
	} else if (worst_fit != NULL) {
  80192e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801932:	74 08                	je     80193c <alloc_pages_custom_fit+0x173>

		result = worst_fit;
  801934:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801937:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80193a:	eb 32                	jmp    80196e <alloc_pages_custom_fit+0x1a5>
	} else {

		if (uheapPageAllocBreak > (uint32)USER_HEAP_MAX - required_size)
  80193c:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801941:	2b 45 d0             	sub    -0x30(%ebp),%eax
  801944:	89 c2                	mov    %eax,%edx
  801946:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80194b:	39 c2                	cmp    %eax,%edx
  80194d:	73 07                	jae    801956 <alloc_pages_custom_fit+0x18d>
			return NULL;
  80194f:	b8 00 00 00 00       	mov    $0x0,%eax
  801954:	eb 2d                	jmp    801983 <alloc_pages_custom_fit+0x1ba>

		result = (void*)uheapPageAllocBreak;
  801956:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80195b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uheapPageAllocBreak += required_size;
  80195e:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801964:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801967:	01 d0                	add    %edx,%eax
  801969:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}


	insert_page_alloc((uint32)result, required_size);
  80196e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801971:	83 ec 08             	sub    $0x8,%esp
  801974:	ff 75 d0             	pushl  -0x30(%ebp)
  801977:	50                   	push   %eax
  801978:	e8 56 fc ff ff       	call   8015d3 <insert_page_alloc>
  80197d:	83 c4 10             	add    $0x10,%esp

	return result;
  801980:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <find_allocated_size>:

//=================================
// Find allocated size for a given VA
//=================================
uint32 find_allocated_size(void* virtual_address)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	83 ec 10             	sub    $0x10,%esp
	uint32 va = (uint32)virtual_address;
  80198b:	8b 45 08             	mov    0x8(%ebp),%eax
  80198e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801991:	a1 24 50 80 00       	mov    0x805024,%eax
  801996:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801999:	eb 1a                	jmp    8019b5 <find_allocated_size+0x30>
		if (it->start == va)
  80199b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80199e:	8b 00                	mov    (%eax),%eax
  8019a0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8019a3:	75 08                	jne    8019ad <find_allocated_size+0x28>
			return it->size;
  8019a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019a8:	8b 40 04             	mov    0x4(%eax),%eax
  8019ab:	eb 34                	jmp    8019e1 <find_allocated_size+0x5c>
uint32 find_allocated_size(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8019ad:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8019b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8019b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019b9:	74 08                	je     8019c3 <find_allocated_size+0x3e>
  8019bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019be:	8b 40 08             	mov    0x8(%eax),%eax
  8019c1:	eb 05                	jmp    8019c8 <find_allocated_size+0x43>
  8019c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8019cd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8019d2:	85 c0                	test   %eax,%eax
  8019d4:	75 c5                	jne    80199b <find_allocated_size+0x16>
  8019d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019da:	75 bf                	jne    80199b <find_allocated_size+0x16>
		if (it->start == va)
			return it->size;
	}
	return 0;
  8019dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <free_pages>:

//=================================
// Free pages in page allocator
//=================================
void free_pages(void* virtual_address)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	83 ec 28             	sub    $0x28,%esp
	uint32 va = (uint32)virtual_address;
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  8019ef:	a1 24 50 80 00       	mov    0x805024,%eax
  8019f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019f7:	e9 e1 01 00 00       	jmp    801bdd <free_pages+0x1fa>
		if (it->start == va) {
  8019fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ff:	8b 00                	mov    (%eax),%eax
  801a01:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801a04:	0f 85 cb 01 00 00    	jne    801bd5 <free_pages+0x1f2>

			uint32 start = it->start;
  801a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a0d:	8b 00                	mov    (%eax),%eax
  801a0f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			uint32 size  = it->size;
  801a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a15:	8b 40 04             	mov    0x4(%eax),%eax
  801a18:	89 45 e4             	mov    %eax,-0x1c(%ebp)


			if (start > 0xFFFFFFFFU - size) {
  801a1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a1e:	f7 d0                	not    %eax
  801a20:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a23:	73 1d                	jae    801a42 <free_pages+0x5f>
				panic("free_pages(): address + size would overflow (start=%x, size=%x)\n", start, size);
  801a25:	83 ec 0c             	sub    $0xc,%esp
  801a28:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a2b:	ff 75 e8             	pushl  -0x18(%ebp)
  801a2e:	68 f8 3f 80 00       	push   $0x803ff8
  801a33:	68 a5 00 00 00       	push   $0xa5
  801a38:	68 91 3f 80 00       	push   $0x803f91
  801a3d:	e8 be e9 ff ff       	call   800400 <_panic>
			}

			uint32 start_end = start + size;
  801a42:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a48:	01 d0                	add    %edx,%eax
  801a4a:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (start < USER_HEAP_START || start >= USER_HEAP_MAX ||
  801a4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a50:	85 c0                	test   %eax,%eax
  801a52:	79 19                	jns    801a6d <free_pages+0x8a>
  801a54:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801a5b:	77 10                	ja     801a6d <free_pages+0x8a>
  801a5d:	81 7d e0 00 00 00 a0 	cmpl   $0xa0000000,-0x20(%ebp)
  801a64:	77 07                	ja     801a6d <free_pages+0x8a>
				start_end > USER_HEAP_MAX || start_end < USER_HEAP_START) {
  801a66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a69:	85 c0                	test   %eax,%eax
  801a6b:	78 2c                	js     801a99 <free_pages+0xb6>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
  801a6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a70:	83 ec 0c             	sub    $0xc,%esp
  801a73:	68 00 00 00 a0       	push   $0xa0000000
  801a78:	ff 75 e0             	pushl  -0x20(%ebp)
  801a7b:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a7e:	ff 75 e8             	pushl  -0x18(%ebp)
  801a81:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a84:	50                   	push   %eax
  801a85:	68 3c 40 80 00       	push   $0x80403c
  801a8a:	68 ad 00 00 00       	push   $0xad
  801a8f:	68 91 3f 80 00       	push   $0x803f91
  801a94:	e8 67 e9 ff ff       	call   800400 <_panic>
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801a99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a9f:	e9 88 00 00 00       	jmp    801b2c <free_pages+0x149>

				if (cur > 0xFFFFFFFFU - PAGE_SIZE) {
  801aa4:	81 7d f0 ff ef ff ff 	cmpl   $0xffffefff,-0x10(%ebp)
  801aab:	76 17                	jbe    801ac4 <free_pages+0xe1>
					panic("free_pages(): page address + PAGE_SIZE would overflow (cur=%x)\n", cur);
  801aad:	ff 75 f0             	pushl  -0x10(%ebp)
  801ab0:	68 a0 40 80 00       	push   $0x8040a0
  801ab5:	68 b4 00 00 00       	push   $0xb4
  801aba:	68 91 3f 80 00       	push   $0x803f91
  801abf:	e8 3c e9 ff ff       	call   800400 <_panic>
				}

				uint32 cur_end = cur + PAGE_SIZE;
  801ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac7:	05 00 10 00 00       	add    $0x1000,%eax
  801acc:	89 45 dc             	mov    %eax,-0x24(%ebp)

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
  801acf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad2:	85 c0                	test   %eax,%eax
  801ad4:	79 2e                	jns    801b04 <free_pages+0x121>
  801ad6:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801add:	77 25                	ja     801b04 <free_pages+0x121>
  801adf:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801ae6:	77 1c                	ja     801b04 <free_pages+0x121>
					sys_free_user_mem(cur, PAGE_SIZE);
  801ae8:	83 ec 08             	sub    $0x8,%esp
  801aeb:	68 00 10 00 00       	push   $0x1000
  801af0:	ff 75 f0             	pushl  -0x10(%ebp)
  801af3:	e8 38 0d 00 00       	call   802830 <sys_free_user_mem>
  801af8:	83 c4 10             	add    $0x10,%esp
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801afb:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801b02:	eb 28                	jmp    801b2c <free_pages+0x149>
				uint32 cur_end = cur + PAGE_SIZE;

				if (cur >= USER_HEAP_START && cur < USER_HEAP_MAX && cur_end < USER_HEAP_MAX) {
					sys_free_user_mem(cur, PAGE_SIZE);
				} else {
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
  801b04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b07:	68 00 00 00 a0       	push   $0xa0000000
  801b0c:	ff 75 dc             	pushl  -0x24(%ebp)
  801b0f:	68 00 10 00 00       	push   $0x1000
  801b14:	ff 75 f0             	pushl  -0x10(%ebp)
  801b17:	50                   	push   %eax
  801b18:	68 e0 40 80 00       	push   $0x8040e0
  801b1d:	68 bd 00 00 00       	push   $0xbd
  801b22:	68 91 3f 80 00       	push   $0x803f91
  801b27:	e8 d4 e8 ff ff       	call   800400 <_panic>
				panic("free_pages(): invalid address %p or size %u (start=%x, size=%x, start+size=%x, USER_HEAP_MAX=%x)\n",
					(void*)start, size, start, size, start_end, USER_HEAP_MAX);
			}


			for(uint32 cur = start; cur < start_end; cur += PAGE_SIZE){
  801b2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b2f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801b32:	0f 82 6c ff ff ff    	jb     801aa4 <free_pages+0xc1>
					panic("free_pages(): invalid page address %p (cur=%x, PAGE_SIZE=%x, cur+PAGE_SIZE=%x, USER_HEAP_MAX=%x)\n",
						(void*)cur, cur, PAGE_SIZE, cur_end, USER_HEAP_MAX);
				}
			}

			LIST_REMOVE(&page_alloc_list, it);
  801b38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b3c:	75 17                	jne    801b55 <free_pages+0x172>
  801b3e:	83 ec 04             	sub    $0x4,%esp
  801b41:	68 42 41 80 00       	push   $0x804142
  801b46:	68 c1 00 00 00       	push   $0xc1
  801b4b:	68 91 3f 80 00       	push   $0x803f91
  801b50:	e8 ab e8 ff ff       	call   800400 <_panic>
  801b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b58:	8b 40 08             	mov    0x8(%eax),%eax
  801b5b:	85 c0                	test   %eax,%eax
  801b5d:	74 11                	je     801b70 <free_pages+0x18d>
  801b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b62:	8b 40 08             	mov    0x8(%eax),%eax
  801b65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b68:	8b 52 0c             	mov    0xc(%edx),%edx
  801b6b:	89 50 0c             	mov    %edx,0xc(%eax)
  801b6e:	eb 0b                	jmp    801b7b <free_pages+0x198>
  801b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b73:	8b 40 0c             	mov    0xc(%eax),%eax
  801b76:	a3 28 50 80 00       	mov    %eax,0x805028
  801b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b7e:	8b 40 0c             	mov    0xc(%eax),%eax
  801b81:	85 c0                	test   %eax,%eax
  801b83:	74 11                	je     801b96 <free_pages+0x1b3>
  801b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b88:	8b 40 0c             	mov    0xc(%eax),%eax
  801b8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b8e:	8b 52 08             	mov    0x8(%edx),%edx
  801b91:	89 50 08             	mov    %edx,0x8(%eax)
  801b94:	eb 0b                	jmp    801ba1 <free_pages+0x1be>
  801b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b99:	8b 40 08             	mov    0x8(%eax),%eax
  801b9c:	a3 24 50 80 00       	mov    %eax,0x805024
  801ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bae:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801bb5:	a1 30 50 80 00       	mov    0x805030,%eax
  801bba:	48                   	dec    %eax
  801bbb:	a3 30 50 80 00       	mov    %eax,0x805030
			free_block(it);
  801bc0:	83 ec 0c             	sub    $0xc,%esp
  801bc3:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc6:	e8 24 15 00 00       	call   8030ef <free_block>
  801bcb:	83 c4 10             	add    $0x10,%esp
			recompute_page_alloc_break();
  801bce:	e8 72 fb ff ff       	call   801745 <recompute_page_alloc_break>

			return;
  801bd3:	eb 37                	jmp    801c0c <free_pages+0x229>
void free_pages(void* virtual_address)
{
	uint32 va = (uint32)virtual_address;

	struct PageAlloc *it;
	LIST_FOREACH(it, &page_alloc_list) {
  801bd5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801bda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801be1:	74 08                	je     801beb <free_pages+0x208>
  801be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be6:	8b 40 08             	mov    0x8(%eax),%eax
  801be9:	eb 05                	jmp    801bf0 <free_pages+0x20d>
  801beb:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801bf5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801bfa:	85 c0                	test   %eax,%eax
  801bfc:	0f 85 fa fd ff ff    	jne    8019fc <free_pages+0x19>
  801c02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c06:	0f 85 f0 fd ff ff    	jne    8019fc <free_pages+0x19>
			recompute_page_alloc_break();

			return;
		}
	}
}
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    

00801c0e <get_free_region_size>:

uint32 get_free_region_size(uint32 va)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
	(void)va;
	return 0;
  801c11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c16:	5d                   	pop    %ebp
  801c17:	c3                   	ret    

00801c18 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
  801c1b:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801c1e:	a1 08 50 80 00       	mov    0x805008,%eax
  801c23:	85 c0                	test   %eax,%eax
  801c25:	74 60                	je     801c87 <uheap_init+0x6f>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801c27:	83 ec 08             	sub    $0x8,%esp
  801c2a:	68 00 00 00 82       	push   $0x82000000
  801c2f:	68 00 00 00 80       	push   $0x80000000
  801c34:	e8 0d 0d 00 00       	call   802946 <initialize_dynamic_allocator>
  801c39:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801c3c:	e8 f3 0a 00 00       	call   802734 <sys_get_uheap_strategy>
  801c41:	a3 60 d0 81 00       	mov    %eax,0x81d060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801c46:	a1 40 50 80 00       	mov    0x805040,%eax
  801c4b:	05 00 10 00 00       	add    $0x1000,%eax
  801c50:	a3 10 d1 81 00       	mov    %eax,0x81d110
		uheapPageAllocBreak = uheapPageAllocStart;
  801c55:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801c5a:	a3 68 d0 81 00       	mov    %eax,0x81d068

		LIST_INIT(&page_alloc_list);
  801c5f:	c7 05 24 50 80 00 00 	movl   $0x0,0x805024
  801c66:	00 00 00 
  801c69:	c7 05 28 50 80 00 00 	movl   $0x0,0x805028
  801c70:	00 00 00 
  801c73:	c7 05 30 50 80 00 00 	movl   $0x0,0x805030
  801c7a:	00 00 00 

		__firstTimeFlag = 0;
  801c7d:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801c84:	00 00 00 
	}
}
  801c87:	90                   	nop
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
  801c8d:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801c90:	8b 45 08             	mov    0x8(%ebp),%eax
  801c93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c99:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c9e:	83 ec 08             	sub    $0x8,%esp
  801ca1:	68 06 04 00 00       	push   $0x406
  801ca6:	50                   	push   %eax
  801ca7:	e8 d2 06 00 00       	call   80237e <__sys_allocate_page>
  801cac:	83 c4 10             	add    $0x10,%esp
  801caf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801cb2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cb6:	79 17                	jns    801ccf <get_page+0x45>
		panic("get_page() in user: failed to allocate page from the kernel");
  801cb8:	83 ec 04             	sub    $0x4,%esp
  801cbb:	68 60 41 80 00       	push   $0x804160
  801cc0:	68 ea 00 00 00       	push   $0xea
  801cc5:	68 91 3f 80 00       	push   $0x803f91
  801cca:	e8 31 e7 ff ff       	call   800400 <_panic>
	return 0;
  801ccf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
  801cd9:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801cea:	83 ec 0c             	sub    $0xc,%esp
  801ced:	50                   	push   %eax
  801cee:	e8 d2 06 00 00       	call   8023c5 <__sys_unmap_frame>
  801cf3:	83 c4 10             	add    $0x10,%esp
  801cf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801cf9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cfd:	79 17                	jns    801d16 <return_page+0x40>
		panic("return_page() in user: failed to return a page to the kernel");
  801cff:	83 ec 04             	sub    $0x4,%esp
  801d02:	68 9c 41 80 00       	push   $0x80419c
  801d07:	68 f5 00 00 00       	push   $0xf5
  801d0c:	68 91 3f 80 00       	push   $0x803f91
  801d11:	e8 ea e6 ff ff       	call   800400 <_panic>
}
  801d16:	90                   	nop
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
  801d1c:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801d1f:	e8 f4 fe ff ff       	call   801c18 <uheap_init>
	if (size == 0) return NULL ;
  801d24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d28:	75 0a                	jne    801d34 <malloc+0x1b>
  801d2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2f:	e9 67 01 00 00       	jmp    801e9b <malloc+0x182>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here

#if USE_KHEAP

	void* result = NULL;
  801d34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)


	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801d3b:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801d42:	77 16                	ja     801d5a <malloc+0x41>
		result = alloc_block(size);
  801d44:	83 ec 0c             	sub    $0xc,%esp
  801d47:	ff 75 08             	pushl  0x8(%ebp)
  801d4a:	e8 46 0e 00 00       	call   802b95 <alloc_block>
  801d4f:	83 c4 10             	add    $0x10,%esp
  801d52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d55:	e9 3e 01 00 00       	jmp    801e98 <malloc+0x17f>

	} else {

		uint32 alloc_size = ROUNDUP(size, PAGE_SIZE);
  801d5a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d61:	8b 55 08             	mov    0x8(%ebp),%edx
  801d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d67:	01 d0                	add    %edx,%eax
  801d69:	48                   	dec    %eax
  801d6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d70:	ba 00 00 00 00       	mov    $0x0,%edx
  801d75:	f7 75 f0             	divl   -0x10(%ebp)
  801d78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d7b:	29 d0                	sub    %edx,%eax
  801d7d:	89 45 e8             	mov    %eax,-0x18(%ebp)


		if (uheapPageAllocStart == 0) {
  801d80:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801d85:	85 c0                	test   %eax,%eax
  801d87:	75 0a                	jne    801d93 <malloc+0x7a>
			return NULL;
  801d89:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8e:	e9 08 01 00 00       	jmp    801e9b <malloc+0x182>
		}
		if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart) {
  801d93:	a1 68 d0 81 00       	mov    0x81d068,%eax
  801d98:	85 c0                	test   %eax,%eax
  801d9a:	74 0f                	je     801dab <malloc+0x92>
  801d9c:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  801da2:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801da7:	39 c2                	cmp    %eax,%edx
  801da9:	73 0a                	jae    801db5 <malloc+0x9c>
			uheapPageAllocBreak = uheapPageAllocStart;
  801dab:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801db0:	a3 68 d0 81 00       	mov    %eax,0x81d068
		}
		if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  801db5:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801dba:	83 f8 05             	cmp    $0x5,%eax
  801dbd:	75 11                	jne    801dd0 <malloc+0xb7>
		result = alloc_pages_custom_fit(alloc_size);
  801dbf:	83 ec 0c             	sub    $0xc,%esp
  801dc2:	ff 75 e8             	pushl  -0x18(%ebp)
  801dc5:	e8 ff f9 ff ff       	call   8017c9 <alloc_pages_custom_fit>
  801dca:	83 c4 10             	add    $0x10,%esp
  801dcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		if (result != NULL) {
  801dd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dd4:	0f 84 be 00 00 00    	je     801e98 <malloc+0x17f>
			uint32 result_va = (uint32)result;
  801dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 actual_size = find_allocated_size(result);
  801de0:	83 ec 0c             	sub    $0xc,%esp
  801de3:	ff 75 f4             	pushl  -0xc(%ebp)
  801de6:	e8 9a fb ff ff       	call   801985 <find_allocated_size>
  801deb:	83 c4 10             	add    $0x10,%esp
  801dee:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if (actual_size == 0) {
  801df1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801df5:	75 17                	jne    801e0e <malloc+0xf5>
				panic("malloc(): allocation succeeded but metadata not found for address %p\n", result);
  801df7:	ff 75 f4             	pushl  -0xc(%ebp)
  801dfa:	68 dc 41 80 00       	push   $0x8041dc
  801dff:	68 24 01 00 00       	push   $0x124
  801e04:	68 91 3f 80 00       	push   $0x803f91
  801e09:	e8 f2 e5 ff ff       	call   800400 <_panic>
			}


			if (result_va > 0xFFFFFFFFU - actual_size) {
  801e0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e11:	f7 d0                	not    %eax
  801e13:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801e16:	73 1d                	jae    801e35 <malloc+0x11c>
				panic("malloc(): address + size would overflow (va=%x, size=%x)\n", result_va, actual_size);
  801e18:	83 ec 0c             	sub    $0xc,%esp
  801e1b:	ff 75 e0             	pushl  -0x20(%ebp)
  801e1e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e21:	68 24 42 80 00       	push   $0x804224
  801e26:	68 29 01 00 00       	push   $0x129
  801e2b:	68 91 3f 80 00       	push   $0x803f91
  801e30:	e8 cb e5 ff ff       	call   800400 <_panic>
			}

			uint32 result_end = result_va + actual_size;
  801e35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e3b:	01 d0                	add    %edx,%eax
  801e3d:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if (result_va >= USER_HEAP_START && result_va < USER_HEAP_MAX &&
  801e40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e43:	85 c0                	test   %eax,%eax
  801e45:	79 2c                	jns    801e73 <malloc+0x15a>
  801e47:	81 7d e4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x1c(%ebp)
  801e4e:	77 23                	ja     801e73 <malloc+0x15a>
  801e50:	81 7d dc ff ff ff 9f 	cmpl   $0x9fffffff,-0x24(%ebp)
  801e57:	77 1a                	ja     801e73 <malloc+0x15a>
				result_end < USER_HEAP_MAX && result_end >= USER_HEAP_START) {
  801e59:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e5c:	85 c0                	test   %eax,%eax
  801e5e:	79 13                	jns    801e73 <malloc+0x15a>
				sys_allocate_user_mem(result_va, actual_size);
  801e60:	83 ec 08             	sub    $0x8,%esp
  801e63:	ff 75 e0             	pushl  -0x20(%ebp)
  801e66:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e69:	e8 de 09 00 00       	call   80284c <sys_allocate_user_mem>
  801e6e:	83 c4 10             	add    $0x10,%esp
  801e71:	eb 25                	jmp    801e98 <malloc+0x17f>
			} else {
				panic("malloc(): alloc_pages_custom_fit returned invalid address %p (va=%x, size=%x, va+size=%x, USER_HEAP_MAX=%x)\n",
  801e73:	68 00 00 00 a0       	push   $0xa0000000
  801e78:	ff 75 dc             	pushl  -0x24(%ebp)
  801e7b:	ff 75 e0             	pushl  -0x20(%ebp)
  801e7e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e81:	ff 75 f4             	pushl  -0xc(%ebp)
  801e84:	68 60 42 80 00       	push   $0x804260
  801e89:	68 33 01 00 00       	push   $0x133
  801e8e:	68 91 3f 80 00       	push   $0x803f91
  801e93:	e8 68 e5 ff ff       	call   800400 <_panic>
					result, result_va, actual_size, result_end, USER_HEAP_MAX);
			}
		}
	}

	return result;
  801e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("malloc() is not implemented yet...!!");
}
  801e9b:	c9                   	leave  
  801e9c:	c3                   	ret    

00801e9d <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
  801ea0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801ea3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ea7:	0f 84 26 01 00 00    	je     801fd3 <free+0x136>

	uint32 addr = (uint32)virtual_address;
  801ead:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (addr >= USER_HEAP_START && addr < USER_HEAP_START + DYN_ALLOC_MAX_SIZE) {
  801eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb6:	85 c0                	test   %eax,%eax
  801eb8:	79 1c                	jns    801ed6 <free+0x39>
  801eba:	81 7d f4 ff ff ff 81 	cmpl   $0x81ffffff,-0xc(%ebp)
  801ec1:	77 13                	ja     801ed6 <free+0x39>
		free_block(virtual_address);
  801ec3:	83 ec 0c             	sub    $0xc,%esp
  801ec6:	ff 75 08             	pushl  0x8(%ebp)
  801ec9:	e8 21 12 00 00       	call   8030ef <free_block>
  801ece:	83 c4 10             	add    $0x10,%esp
		return;
  801ed1:	e9 01 01 00 00       	jmp    801fd7 <free+0x13a>
	}

	if (addr >= uheapPageAllocStart && addr < (uint32)USTACKTOP) {
  801ed6:	a1 10 d1 81 00       	mov    0x81d110,%eax
  801edb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801ede:	0f 82 d8 00 00 00    	jb     801fbc <free+0x11f>
  801ee4:	81 7d f4 ff df bf ee 	cmpl   $0xeebfdfff,-0xc(%ebp)
  801eeb:	0f 87 cb 00 00 00    	ja     801fbc <free+0x11f>
		if (addr % PAGE_SIZE != 0) {
  801ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef4:	25 ff 0f 00 00       	and    $0xfff,%eax
  801ef9:	85 c0                	test   %eax,%eax
  801efb:	74 17                	je     801f14 <free+0x77>
			panic("free(): address not page-aligned: %p\n", virtual_address);
  801efd:	ff 75 08             	pushl  0x8(%ebp)
  801f00:	68 d0 42 80 00       	push   $0x8042d0
  801f05:	68 57 01 00 00       	push   $0x157
  801f0a:	68 91 3f 80 00       	push   $0x803f91
  801f0f:	e8 ec e4 ff ff       	call   800400 <_panic>
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
  801f14:	83 ec 0c             	sub    $0xc,%esp
  801f17:	ff 75 08             	pushl  0x8(%ebp)
  801f1a:	e8 66 fa ff ff       	call   801985 <find_allocated_size>
  801f1f:	83 c4 10             	add    $0x10,%esp
  801f22:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (alloc_size == 0) {
  801f25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f29:	0f 84 a7 00 00 00    	je     801fd6 <free+0x139>
			return;
		}


		if (addr > 0xFFFFFFFFU - alloc_size) {
  801f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f32:	f7 d0                	not    %eax
  801f34:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801f37:	73 1d                	jae    801f56 <free+0xb9>
			panic("free(): address + size would overflow (addr=%x, size=%x)\n", addr, alloc_size);
  801f39:	83 ec 0c             	sub    $0xc,%esp
  801f3c:	ff 75 f0             	pushl  -0x10(%ebp)
  801f3f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f42:	68 f8 42 80 00       	push   $0x8042f8
  801f47:	68 61 01 00 00       	push   $0x161
  801f4c:	68 91 3f 80 00       	push   $0x803f91
  801f51:	e8 aa e4 ff ff       	call   800400 <_panic>
		}

		uint32 addr_end = addr + alloc_size;
  801f56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5c:	01 d0                	add    %edx,%eax
  801f5e:	89 45 ec             	mov    %eax,-0x14(%ebp)

		if (addr < USER_HEAP_START || addr >= USER_HEAP_MAX ||
  801f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f64:	85 c0                	test   %eax,%eax
  801f66:	79 19                	jns    801f81 <free+0xe4>
  801f68:	81 7d f4 ff ff ff 9f 	cmpl   $0x9fffffff,-0xc(%ebp)
  801f6f:	77 10                	ja     801f81 <free+0xe4>
  801f71:	81 7d ec 00 00 00 a0 	cmpl   $0xa0000000,-0x14(%ebp)
  801f78:	77 07                	ja     801f81 <free+0xe4>
			addr_end > USER_HEAP_MAX || addr_end < USER_HEAP_START) {
  801f7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f7d:	85 c0                	test   %eax,%eax
  801f7f:	78 2b                	js     801fac <free+0x10f>
			panic("free(): invalid address %p or size %u (addr=%x, size=%x, addr+size=%x, USER_HEAP_MAX=%x)\n",
  801f81:	83 ec 0c             	sub    $0xc,%esp
  801f84:	68 00 00 00 a0       	push   $0xa0000000
  801f89:	ff 75 ec             	pushl  -0x14(%ebp)
  801f8c:	ff 75 f0             	pushl  -0x10(%ebp)
  801f8f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f92:	ff 75 f0             	pushl  -0x10(%ebp)
  801f95:	ff 75 08             	pushl  0x8(%ebp)
  801f98:	68 34 43 80 00       	push   $0x804334
  801f9d:	68 69 01 00 00       	push   $0x169
  801fa2:	68 91 3f 80 00       	push   $0x803f91
  801fa7:	e8 54 e4 ff ff       	call   800400 <_panic>
				virtual_address, alloc_size, addr, alloc_size, addr_end, USER_HEAP_MAX);
		}

		free_pages(virtual_address);
  801fac:	83 ec 0c             	sub    $0xc,%esp
  801faf:	ff 75 08             	pushl  0x8(%ebp)
  801fb2:	e8 2c fa ff ff       	call   8019e3 <free_pages>
  801fb7:	83 c4 10             	add    $0x10,%esp
		return;
  801fba:	eb 1b                	jmp    801fd7 <free+0x13a>
	}

	panic("free(): invalid virtual address %p\n", virtual_address);
  801fbc:	ff 75 08             	pushl  0x8(%ebp)
  801fbf:	68 90 43 80 00       	push   $0x804390
  801fc4:	68 70 01 00 00       	push   $0x170
  801fc9:	68 91 3f 80 00       	push   $0x803f91
  801fce:	e8 2d e4 ff ff       	call   800400 <_panic>
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here

#if USE_KHEAP

	if (virtual_address == NULL) return;
  801fd3:	90                   	nop
  801fd4:	eb 01                	jmp    801fd7 <free+0x13a>
			panic("free(): address not page-aligned: %p\n", virtual_address);
		}

		uint32 alloc_size = find_allocated_size(virtual_address);
		if (alloc_size == 0) {
			return;
  801fd6:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("free() is not implemented yet...!!");
}
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    

00801fd9 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
  801fdc:	83 ec 38             	sub    $0x38,%esp
  801fdf:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe2:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801fe5:	e8 2e fc ff ff       	call   801c18 <uheap_init>
	if (size == 0) return NULL ;
  801fea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fee:	75 0a                	jne    801ffa <smalloc+0x21>
  801ff0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff5:	e9 3d 01 00 00       	jmp    802137 <smalloc+0x15e>
	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here

#if USE_KHEAP

	uint32 alignedSize = size;
  801ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ffd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 remainder = size & (PAGE_SIZE - 1);
  802000:	8b 45 0c             	mov    0xc(%ebp),%eax
  802003:	25 ff 0f 00 00       	and    $0xfff,%eax
  802008:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (remainder != 0)
  80200b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80200f:	74 0e                	je     80201f <smalloc+0x46>
	    alignedSize += (PAGE_SIZE - remainder);
  802011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802014:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802017:	05 00 10 00 00       	add    $0x1000,%eax
  80201c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32 requiredPages = alignedSize / PAGE_SIZE;
  80201f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802022:	c1 e8 0c             	shr    $0xc,%eax
  802025:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (uheapPageAllocStart == 0)
  802028:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80202d:	85 c0                	test   %eax,%eax
  80202f:	75 0a                	jne    80203b <smalloc+0x62>
		return NULL;
  802031:	b8 00 00 00 00       	mov    $0x0,%eax
  802036:	e9 fc 00 00 00       	jmp    802137 <smalloc+0x15e>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  80203b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802040:	85 c0                	test   %eax,%eax
  802042:	74 0f                	je     802053 <smalloc+0x7a>
  802044:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80204a:	a1 10 d1 81 00       	mov    0x81d110,%eax
  80204f:	39 c2                	cmp    %eax,%edx
  802051:	73 0a                	jae    80205d <smalloc+0x84>
	        	uheapPageAllocBreak = uheapPageAllocStart;
  802053:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802058:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  80205d:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802062:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802067:	29 c2                	sub    %eax,%edx
  802069:	89 d0                	mov    %edx,%eax
  80206b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  80206e:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  802074:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802079:	29 c2                	sub    %eax,%edx
  80207b:	89 d0                	mov    %edx,%eax
  80207d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  802080:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802083:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802086:	77 13                	ja     80209b <smalloc+0xc2>
  802088:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80208b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80208e:	77 0b                	ja     80209b <smalloc+0xc2>
		usedSize > sharedLimitSize - alignedSize){
  802090:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802093:	2b 45 f4             	sub    -0xc(%ebp),%eax

	uint32 sharedLimitSize = (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;

	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedSize > sharedLimitSize || usedSize > sharedLimitSize ||
  802096:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802099:	73 0a                	jae    8020a5 <smalloc+0xcc>
		usedSize > sharedLimitSize - alignedSize){
		return NULL;
  80209b:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a0:	e9 92 00 00 00       	jmp    802137 <smalloc+0x15e>
	}

	void *va = NULL;
  8020a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT) {
  8020ac:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8020b1:	83 f8 05             	cmp    $0x5,%eax
  8020b4:	75 11                	jne    8020c7 <smalloc+0xee>
		va = alloc_pages_custom_fit(alignedSize);
  8020b6:	83 ec 0c             	sub    $0xc,%esp
  8020b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8020bc:	e8 08 f7 ff ff       	call   8017c9 <alloc_pages_custom_fit>
  8020c1:	83 c4 10             	add    $0x10,%esp
  8020c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	if (va == NULL) {
  8020c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020cb:	75 27                	jne    8020f4 <smalloc+0x11b>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  8020cd:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)
		if (uheapPageAllocBreak > max_allowed - alignedSize){
  8020d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8020d7:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8020da:	89 c2                	mov    %eax,%edx
  8020dc:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8020e1:	39 c2                	cmp    %eax,%edx
  8020e3:	73 07                	jae    8020ec <smalloc+0x113>
			return NULL;}
  8020e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ea:	eb 4b                	jmp    802137 <smalloc+0x15e>

		va = (void *)uheapPageAllocBreak;
  8020ec:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8020f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_create_shared_object(sharedVarName, size, isWritable, va);
  8020f4:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8020f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8020fb:	50                   	push   %eax
  8020fc:	ff 75 0c             	pushl  0xc(%ebp)
  8020ff:	ff 75 08             	pushl  0x8(%ebp)
  802102:	e8 cb 03 00 00       	call   8024d2 <sys_create_shared_object>
  802107:	83 c4 10             	add    $0x10,%esp
  80210a:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (sharedID < 0)
  80210d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802111:	79 07                	jns    80211a <smalloc+0x141>
		return NULL;
  802113:	b8 00 00 00 00       	mov    $0x0,%eax
  802118:	eb 1d                	jmp    802137 <smalloc+0x15e>

	if (va == (void *)uheapPageAllocBreak) {
  80211a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80211f:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802122:	75 10                	jne    802134 <smalloc+0x15b>
		uheapPageAllocBreak +=alignedSize;
  802124:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80212a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212d:	01 d0                	add    %edx,%eax
  80212f:	a3 68 d0 81 00       	mov    %eax,0x81d068
	}

	return va;
  802134:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("smalloc() is not implemented yet...!!");
}
  802137:	c9                   	leave  
  802138:	c3                   	ret    

00802139 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
  80213c:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80213f:	e8 d4 fa ff ff       	call   801c18 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
#if USE_KHEAP
	int objsizeeeee = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802144:	83 ec 08             	sub    $0x8,%esp
  802147:	ff 75 0c             	pushl  0xc(%ebp)
  80214a:	ff 75 08             	pushl  0x8(%ebp)
  80214d:	e8 aa 03 00 00       	call   8024fc <sys_size_of_shared_object>
  802152:	83 c4 10             	add    $0x10,%esp
  802155:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (objsizeeeee <= 0)
  802158:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80215c:	7f 0a                	jg     802168 <sget+0x2f>
		return NULL;
  80215e:	b8 00 00 00 00       	mov    $0x0,%eax
  802163:	e9 32 01 00 00       	jmp    80229a <sget+0x161>

	uint32 alignedsize = objsizeeeee;
  802168:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80216b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32 remainder = objsizeeeee & (PAGE_SIZE - 1);
  80216e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802171:	25 ff 0f 00 00       	and    $0xfff,%eax
  802176:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (remainder != 0)
  802179:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80217d:	74 0e                	je     80218d <sget+0x54>
		    alignedsize += (PAGE_SIZE - remainder);
  80217f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802182:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802185:	05 00 10 00 00       	add    $0x1000,%eax
  80218a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (uheapPageAllocStart == 0)
  80218d:	a1 10 d1 81 00       	mov    0x81d110,%eax
  802192:	85 c0                	test   %eax,%eax
  802194:	75 0a                	jne    8021a0 <sget+0x67>
		return NULL;
  802196:	b8 00 00 00 00       	mov    $0x0,%eax
  80219b:	e9 fa 00 00 00       	jmp    80229a <sget+0x161>

	if (uheapPageAllocBreak == 0 || uheapPageAllocBreak < uheapPageAllocStart)
  8021a0:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8021a5:	85 c0                	test   %eax,%eax
  8021a7:	74 0f                	je     8021b8 <sget+0x7f>
  8021a9:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8021af:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8021b4:	39 c2                	cmp    %eax,%edx
  8021b6:	73 0a                	jae    8021c2 <sget+0x89>
		uheapPageAllocBreak = uheapPageAllocStart;
  8021b8:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8021bd:	a3 68 d0 81 00       	mov    %eax,0x81d068

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
  8021c2:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8021c7:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8021cc:	29 c2                	sub    %eax,%edx
  8021ce:	89 d0                	mov    %edx,%eax
  8021d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;
  8021d3:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8021d9:	a1 10 d1 81 00       	mov    0x81d110,%eax
  8021de:	29 c2                	sub    %eax,%edx
  8021e0:	89 d0                	mov    %edx,%eax
  8021e2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8021e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8021eb:	77 13                	ja     802200 <sget+0xc7>
  8021ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021f0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8021f3:	77 0b                	ja     802200 <sget+0xc7>
		usedSize > sharedLimitSize - alignedsize)
  8021f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021f8:	2b 45 f4             	sub    -0xc(%ebp),%eax
		uheapPageAllocBreak = uheapPageAllocStart;

	uint32 sharedLimitSize =   (USER_HEAP_MAX - uheapPageAllocStart) - PAGE_SIZE;
	uint32 usedSize = uheapPageAllocBreak - uheapPageAllocStart;

	if (alignedsize > sharedLimitSize || usedSize > sharedLimitSize ||
  8021fb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8021fe:	73 0a                	jae    80220a <sget+0xd1>
		usedSize > sharedLimitSize - alignedsize)
		return NULL;
  802200:	b8 00 00 00 00       	mov    $0x0,%eax
  802205:	e9 90 00 00 00       	jmp    80229a <sget+0x161>

	void *va = NULL;
  80220a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if (uheapPlaceStrategy == UHP_PLACE_CUSTOMFIT)
  802211:	a1 60 d0 81 00       	mov    0x81d060,%eax
  802216:	83 f8 05             	cmp    $0x5,%eax
  802219:	75 11                	jne    80222c <sget+0xf3>
		va = alloc_pages_custom_fit(alignedsize);
  80221b:	83 ec 0c             	sub    $0xc,%esp
  80221e:	ff 75 f4             	pushl  -0xc(%ebp)
  802221:	e8 a3 f5 ff ff       	call   8017c9 <alloc_pages_custom_fit>
  802226:	83 c4 10             	add    $0x10,%esp
  802229:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (va == NULL) {
  80222c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802230:	75 27                	jne    802259 <sget+0x120>
		uint32 max_allowed = USER_HEAP_MAX - PAGE_SIZE;
  802232:	c7 45 dc 00 f0 ff 9f 	movl   $0x9ffff000,-0x24(%ebp)

		if (uheapPageAllocBreak > max_allowed - alignedsize)
  802239:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80223c:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80223f:	89 c2                	mov    %eax,%edx
  802241:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802246:	39 c2                	cmp    %eax,%edx
  802248:	73 07                	jae    802251 <sget+0x118>
			return NULL;
  80224a:	b8 00 00 00 00       	mov    $0x0,%eax
  80224f:	eb 49                	jmp    80229a <sget+0x161>

		va = (void *)uheapPageAllocBreak;
  802251:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802256:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	int sharedID = sys_get_shared_object(ownerEnvID, sharedVarName, va);
  802259:	83 ec 04             	sub    $0x4,%esp
  80225c:	ff 75 f0             	pushl  -0x10(%ebp)
  80225f:	ff 75 0c             	pushl  0xc(%ebp)
  802262:	ff 75 08             	pushl  0x8(%ebp)
  802265:	e8 af 02 00 00       	call   802519 <sys_get_shared_object>
  80226a:	83 c4 10             	add    $0x10,%esp
  80226d:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (sharedID < 0)
  802270:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802274:	79 07                	jns    80227d <sget+0x144>
		return NULL;
  802276:	b8 00 00 00 00       	mov    $0x0,%eax
  80227b:	eb 1d                	jmp    80229a <sget+0x161>

	if (va == (void *)uheapPageAllocBreak)
  80227d:	a1 68 d0 81 00       	mov    0x81d068,%eax
  802282:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  802285:	75 10                	jne    802297 <sget+0x15e>
		uheapPageAllocBreak += alignedsize;
  802287:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80228d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802290:	01 d0                	add    %edx,%eax
  802292:	a3 68 d0 81 00       	mov    %eax,0x81d068

	return va;
  802297:	8b 45 f0             	mov    -0x10(%ebp),%eax
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sget() is not implemented yet...!!");
}
  80229a:	c9                   	leave  
  80229b:	c3                   	ret    

0080229c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
  80229f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8022a2:	e8 71 f9 ff ff       	call   801c18 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8022a7:	83 ec 04             	sub    $0x4,%esp
  8022aa:	68 b4 43 80 00       	push   $0x8043b4
  8022af:	68 19 02 00 00       	push   $0x219
  8022b4:	68 91 3f 80 00       	push   $0x803f91
  8022b9:	e8 42 e1 ff ff       	call   800400 <_panic>

008022be <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
  8022c1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8022c4:	83 ec 04             	sub    $0x4,%esp
  8022c7:	68 dc 43 80 00       	push   $0x8043dc
  8022cc:	68 2b 02 00 00       	push   $0x22b
  8022d1:	68 91 3f 80 00       	push   $0x803f91
  8022d6:	e8 25 e1 ff ff       	call   800400 <_panic>

008022db <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
  8022de:	57                   	push   %edi
  8022df:	56                   	push   %esi
  8022e0:	53                   	push   %ebx
  8022e1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8022e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022ed:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022f0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8022f3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8022f6:	cd 30                	int    $0x30
  8022f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8022fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8022fe:	83 c4 10             	add    $0x10,%esp
  802301:	5b                   	pop    %ebx
  802302:	5e                   	pop    %esi
  802303:	5f                   	pop    %edi
  802304:	5d                   	pop    %ebp
  802305:	c3                   	ret    

00802306 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
  802309:	83 ec 04             	sub    $0x4,%esp
  80230c:	8b 45 10             	mov    0x10(%ebp),%eax
  80230f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802312:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802315:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	6a 00                	push   $0x0
  80231e:	51                   	push   %ecx
  80231f:	52                   	push   %edx
  802320:	ff 75 0c             	pushl  0xc(%ebp)
  802323:	50                   	push   %eax
  802324:	6a 00                	push   $0x0
  802326:	e8 b0 ff ff ff       	call   8022db <syscall>
  80232b:	83 c4 18             	add    $0x18,%esp
}
  80232e:	90                   	nop
  80232f:	c9                   	leave  
  802330:	c3                   	ret    

00802331 <sys_cgetc>:

int
sys_cgetc(void)
{
  802331:	55                   	push   %ebp
  802332:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802334:	6a 00                	push   $0x0
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 02                	push   $0x2
  802340:	e8 96 ff ff ff       	call   8022db <syscall>
  802345:	83 c4 18             	add    $0x18,%esp
}
  802348:	c9                   	leave  
  802349:	c3                   	ret    

0080234a <sys_lock_cons>:

void sys_lock_cons(void)
{
  80234a:	55                   	push   %ebp
  80234b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 03                	push   $0x3
  802359:	e8 7d ff ff ff       	call   8022db <syscall>
  80235e:	83 c4 18             	add    $0x18,%esp
}
  802361:	90                   	nop
  802362:	c9                   	leave  
  802363:	c3                   	ret    

00802364 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802364:	55                   	push   %ebp
  802365:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 04                	push   $0x4
  802373:	e8 63 ff ff ff       	call   8022db <syscall>
  802378:	83 c4 18             	add    $0x18,%esp
}
  80237b:	90                   	nop
  80237c:	c9                   	leave  
  80237d:	c3                   	ret    

0080237e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80237e:	55                   	push   %ebp
  80237f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802381:	8b 55 0c             	mov    0xc(%ebp),%edx
  802384:	8b 45 08             	mov    0x8(%ebp),%eax
  802387:	6a 00                	push   $0x0
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	52                   	push   %edx
  80238e:	50                   	push   %eax
  80238f:	6a 08                	push   $0x8
  802391:	e8 45 ff ff ff       	call   8022db <syscall>
  802396:	83 c4 18             	add    $0x18,%esp
}
  802399:	c9                   	leave  
  80239a:	c3                   	ret    

0080239b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80239b:	55                   	push   %ebp
  80239c:	89 e5                	mov    %esp,%ebp
  80239e:	56                   	push   %esi
  80239f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8023a0:	8b 75 18             	mov    0x18(%ebp),%esi
  8023a3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8023af:	56                   	push   %esi
  8023b0:	53                   	push   %ebx
  8023b1:	51                   	push   %ecx
  8023b2:	52                   	push   %edx
  8023b3:	50                   	push   %eax
  8023b4:	6a 09                	push   $0x9
  8023b6:	e8 20 ff ff ff       	call   8022db <syscall>
  8023bb:	83 c4 18             	add    $0x18,%esp
}
  8023be:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023c1:	5b                   	pop    %ebx
  8023c2:	5e                   	pop    %esi
  8023c3:	5d                   	pop    %ebp
  8023c4:	c3                   	ret    

008023c5 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8023c5:	55                   	push   %ebp
  8023c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	ff 75 08             	pushl  0x8(%ebp)
  8023d3:	6a 0a                	push   $0xa
  8023d5:	e8 01 ff ff ff       	call   8022db <syscall>
  8023da:	83 c4 18             	add    $0x18,%esp
}
  8023dd:	c9                   	leave  
  8023de:	c3                   	ret    

008023df <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8023df:	55                   	push   %ebp
  8023e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	ff 75 0c             	pushl  0xc(%ebp)
  8023eb:	ff 75 08             	pushl  0x8(%ebp)
  8023ee:	6a 0b                	push   $0xb
  8023f0:	e8 e6 fe ff ff       	call   8022db <syscall>
  8023f5:	83 c4 18             	add    $0x18,%esp
}
  8023f8:	c9                   	leave  
  8023f9:	c3                   	ret    

008023fa <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 00                	push   $0x0
  802407:	6a 0c                	push   $0xc
  802409:	e8 cd fe ff ff       	call   8022db <syscall>
  80240e:	83 c4 18             	add    $0x18,%esp
}
  802411:	c9                   	leave  
  802412:	c3                   	ret    

00802413 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802413:	55                   	push   %ebp
  802414:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	6a 00                	push   $0x0
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	6a 0d                	push   $0xd
  802422:	e8 b4 fe ff ff       	call   8022db <syscall>
  802427:	83 c4 18             	add    $0x18,%esp
}
  80242a:	c9                   	leave  
  80242b:	c3                   	ret    

0080242c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80242c:	55                   	push   %ebp
  80242d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 0e                	push   $0xe
  80243b:	e8 9b fe ff ff       	call   8022db <syscall>
  802440:	83 c4 18             	add    $0x18,%esp
}
  802443:	c9                   	leave  
  802444:	c3                   	ret    

00802445 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802445:	55                   	push   %ebp
  802446:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 0f                	push   $0xf
  802454:	e8 82 fe ff ff       	call   8022db <syscall>
  802459:	83 c4 18             	add    $0x18,%esp
}
  80245c:	c9                   	leave  
  80245d:	c3                   	ret    

0080245e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80245e:	55                   	push   %ebp
  80245f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 00                	push   $0x0
  802469:	ff 75 08             	pushl  0x8(%ebp)
  80246c:	6a 10                	push   $0x10
  80246e:	e8 68 fe ff ff       	call   8022db <syscall>
  802473:	83 c4 18             	add    $0x18,%esp
}
  802476:	c9                   	leave  
  802477:	c3                   	ret    

00802478 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802478:	55                   	push   %ebp
  802479:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	6a 11                	push   $0x11
  802487:	e8 4f fe ff ff       	call   8022db <syscall>
  80248c:	83 c4 18             	add    $0x18,%esp
}
  80248f:	90                   	nop
  802490:	c9                   	leave  
  802491:	c3                   	ret    

00802492 <sys_cputc>:

void
sys_cputc(const char c)
{
  802492:	55                   	push   %ebp
  802493:	89 e5                	mov    %esp,%ebp
  802495:	83 ec 04             	sub    $0x4,%esp
  802498:	8b 45 08             	mov    0x8(%ebp),%eax
  80249b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80249e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 00                	push   $0x0
  8024a6:	6a 00                	push   $0x0
  8024a8:	6a 00                	push   $0x0
  8024aa:	50                   	push   %eax
  8024ab:	6a 01                	push   $0x1
  8024ad:	e8 29 fe ff ff       	call   8022db <syscall>
  8024b2:	83 c4 18             	add    $0x18,%esp
}
  8024b5:	90                   	nop
  8024b6:	c9                   	leave  
  8024b7:	c3                   	ret    

008024b8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8024b8:	55                   	push   %ebp
  8024b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 14                	push   $0x14
  8024c7:	e8 0f fe ff ff       	call   8022db <syscall>
  8024cc:	83 c4 18             	add    $0x18,%esp
}
  8024cf:	90                   	nop
  8024d0:	c9                   	leave  
  8024d1:	c3                   	ret    

008024d2 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8024d2:	55                   	push   %ebp
  8024d3:	89 e5                	mov    %esp,%ebp
  8024d5:	83 ec 04             	sub    $0x4,%esp
  8024d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8024db:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8024de:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024e1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8024e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e8:	6a 00                	push   $0x0
  8024ea:	51                   	push   %ecx
  8024eb:	52                   	push   %edx
  8024ec:	ff 75 0c             	pushl  0xc(%ebp)
  8024ef:	50                   	push   %eax
  8024f0:	6a 15                	push   $0x15
  8024f2:	e8 e4 fd ff ff       	call   8022db <syscall>
  8024f7:	83 c4 18             	add    $0x18,%esp
}
  8024fa:	c9                   	leave  
  8024fb:	c3                   	ret    

008024fc <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8024fc:	55                   	push   %ebp
  8024fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8024ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  802502:	8b 45 08             	mov    0x8(%ebp),%eax
  802505:	6a 00                	push   $0x0
  802507:	6a 00                	push   $0x0
  802509:	6a 00                	push   $0x0
  80250b:	52                   	push   %edx
  80250c:	50                   	push   %eax
  80250d:	6a 16                	push   $0x16
  80250f:	e8 c7 fd ff ff       	call   8022db <syscall>
  802514:	83 c4 18             	add    $0x18,%esp
}
  802517:	c9                   	leave  
  802518:	c3                   	ret    

00802519 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802519:	55                   	push   %ebp
  80251a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80251c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80251f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802522:	8b 45 08             	mov    0x8(%ebp),%eax
  802525:	6a 00                	push   $0x0
  802527:	6a 00                	push   $0x0
  802529:	51                   	push   %ecx
  80252a:	52                   	push   %edx
  80252b:	50                   	push   %eax
  80252c:	6a 17                	push   $0x17
  80252e:	e8 a8 fd ff ff       	call   8022db <syscall>
  802533:	83 c4 18             	add    $0x18,%esp
}
  802536:	c9                   	leave  
  802537:	c3                   	ret    

00802538 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80253b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80253e:	8b 45 08             	mov    0x8(%ebp),%eax
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	52                   	push   %edx
  802548:	50                   	push   %eax
  802549:	6a 18                	push   $0x18
  80254b:	e8 8b fd ff ff       	call   8022db <syscall>
  802550:	83 c4 18             	add    $0x18,%esp
}
  802553:	c9                   	leave  
  802554:	c3                   	ret    

00802555 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802555:	55                   	push   %ebp
  802556:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802558:	8b 45 08             	mov    0x8(%ebp),%eax
  80255b:	6a 00                	push   $0x0
  80255d:	ff 75 14             	pushl  0x14(%ebp)
  802560:	ff 75 10             	pushl  0x10(%ebp)
  802563:	ff 75 0c             	pushl  0xc(%ebp)
  802566:	50                   	push   %eax
  802567:	6a 19                	push   $0x19
  802569:	e8 6d fd ff ff       	call   8022db <syscall>
  80256e:	83 c4 18             	add    $0x18,%esp
}
  802571:	c9                   	leave  
  802572:	c3                   	ret    

00802573 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802573:	55                   	push   %ebp
  802574:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802576:	8b 45 08             	mov    0x8(%ebp),%eax
  802579:	6a 00                	push   $0x0
  80257b:	6a 00                	push   $0x0
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	50                   	push   %eax
  802582:	6a 1a                	push   $0x1a
  802584:	e8 52 fd ff ff       	call   8022db <syscall>
  802589:	83 c4 18             	add    $0x18,%esp
}
  80258c:	90                   	nop
  80258d:	c9                   	leave  
  80258e:	c3                   	ret    

0080258f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802592:	8b 45 08             	mov    0x8(%ebp),%eax
  802595:	6a 00                	push   $0x0
  802597:	6a 00                	push   $0x0
  802599:	6a 00                	push   $0x0
  80259b:	6a 00                	push   $0x0
  80259d:	50                   	push   %eax
  80259e:	6a 1b                	push   $0x1b
  8025a0:	e8 36 fd ff ff       	call   8022db <syscall>
  8025a5:	83 c4 18             	add    $0x18,%esp
}
  8025a8:	c9                   	leave  
  8025a9:	c3                   	ret    

008025aa <sys_getenvid>:

int32 sys_getenvid(void)
{
  8025aa:	55                   	push   %ebp
  8025ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 00                	push   $0x0
  8025b1:	6a 00                	push   $0x0
  8025b3:	6a 00                	push   $0x0
  8025b5:	6a 00                	push   $0x0
  8025b7:	6a 05                	push   $0x5
  8025b9:	e8 1d fd ff ff       	call   8022db <syscall>
  8025be:	83 c4 18             	add    $0x18,%esp
}
  8025c1:	c9                   	leave  
  8025c2:	c3                   	ret    

008025c3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8025c3:	55                   	push   %ebp
  8025c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8025c6:	6a 00                	push   $0x0
  8025c8:	6a 00                	push   $0x0
  8025ca:	6a 00                	push   $0x0
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 06                	push   $0x6
  8025d2:	e8 04 fd ff ff       	call   8022db <syscall>
  8025d7:	83 c4 18             	add    $0x18,%esp
}
  8025da:	c9                   	leave  
  8025db:	c3                   	ret    

008025dc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8025dc:	55                   	push   %ebp
  8025dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8025df:	6a 00                	push   $0x0
  8025e1:	6a 00                	push   $0x0
  8025e3:	6a 00                	push   $0x0
  8025e5:	6a 00                	push   $0x0
  8025e7:	6a 00                	push   $0x0
  8025e9:	6a 07                	push   $0x7
  8025eb:	e8 eb fc ff ff       	call   8022db <syscall>
  8025f0:	83 c4 18             	add    $0x18,%esp
}
  8025f3:	c9                   	leave  
  8025f4:	c3                   	ret    

008025f5 <sys_exit_env>:


void sys_exit_env(void)
{
  8025f5:	55                   	push   %ebp
  8025f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8025f8:	6a 00                	push   $0x0
  8025fa:	6a 00                	push   $0x0
  8025fc:	6a 00                	push   $0x0
  8025fe:	6a 00                	push   $0x0
  802600:	6a 00                	push   $0x0
  802602:	6a 1c                	push   $0x1c
  802604:	e8 d2 fc ff ff       	call   8022db <syscall>
  802609:	83 c4 18             	add    $0x18,%esp
}
  80260c:	90                   	nop
  80260d:	c9                   	leave  
  80260e:	c3                   	ret    

0080260f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80260f:	55                   	push   %ebp
  802610:	89 e5                	mov    %esp,%ebp
  802612:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802615:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802618:	8d 50 04             	lea    0x4(%eax),%edx
  80261b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80261e:	6a 00                	push   $0x0
  802620:	6a 00                	push   $0x0
  802622:	6a 00                	push   $0x0
  802624:	52                   	push   %edx
  802625:	50                   	push   %eax
  802626:	6a 1d                	push   $0x1d
  802628:	e8 ae fc ff ff       	call   8022db <syscall>
  80262d:	83 c4 18             	add    $0x18,%esp
	return result;
  802630:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802633:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802636:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802639:	89 01                	mov    %eax,(%ecx)
  80263b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80263e:	8b 45 08             	mov    0x8(%ebp),%eax
  802641:	c9                   	leave  
  802642:	c2 04 00             	ret    $0x4

00802645 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802648:	6a 00                	push   $0x0
  80264a:	6a 00                	push   $0x0
  80264c:	ff 75 10             	pushl  0x10(%ebp)
  80264f:	ff 75 0c             	pushl  0xc(%ebp)
  802652:	ff 75 08             	pushl  0x8(%ebp)
  802655:	6a 13                	push   $0x13
  802657:	e8 7f fc ff ff       	call   8022db <syscall>
  80265c:	83 c4 18             	add    $0x18,%esp
	return ;
  80265f:	90                   	nop
}
  802660:	c9                   	leave  
  802661:	c3                   	ret    

00802662 <sys_rcr2>:
uint32 sys_rcr2()
{
  802662:	55                   	push   %ebp
  802663:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802665:	6a 00                	push   $0x0
  802667:	6a 00                	push   $0x0
  802669:	6a 00                	push   $0x0
  80266b:	6a 00                	push   $0x0
  80266d:	6a 00                	push   $0x0
  80266f:	6a 1e                	push   $0x1e
  802671:	e8 65 fc ff ff       	call   8022db <syscall>
  802676:	83 c4 18             	add    $0x18,%esp
}
  802679:	c9                   	leave  
  80267a:	c3                   	ret    

0080267b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80267b:	55                   	push   %ebp
  80267c:	89 e5                	mov    %esp,%ebp
  80267e:	83 ec 04             	sub    $0x4,%esp
  802681:	8b 45 08             	mov    0x8(%ebp),%eax
  802684:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802687:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80268b:	6a 00                	push   $0x0
  80268d:	6a 00                	push   $0x0
  80268f:	6a 00                	push   $0x0
  802691:	6a 00                	push   $0x0
  802693:	50                   	push   %eax
  802694:	6a 1f                	push   $0x1f
  802696:	e8 40 fc ff ff       	call   8022db <syscall>
  80269b:	83 c4 18             	add    $0x18,%esp
	return ;
  80269e:	90                   	nop
}
  80269f:	c9                   	leave  
  8026a0:	c3                   	ret    

008026a1 <rsttst>:
void rsttst()
{
  8026a1:	55                   	push   %ebp
  8026a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8026a4:	6a 00                	push   $0x0
  8026a6:	6a 00                	push   $0x0
  8026a8:	6a 00                	push   $0x0
  8026aa:	6a 00                	push   $0x0
  8026ac:	6a 00                	push   $0x0
  8026ae:	6a 21                	push   $0x21
  8026b0:	e8 26 fc ff ff       	call   8022db <syscall>
  8026b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8026b8:	90                   	nop
}
  8026b9:	c9                   	leave  
  8026ba:	c3                   	ret    

008026bb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8026bb:	55                   	push   %ebp
  8026bc:	89 e5                	mov    %esp,%ebp
  8026be:	83 ec 04             	sub    $0x4,%esp
  8026c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8026c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8026c7:	8b 55 18             	mov    0x18(%ebp),%edx
  8026ca:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026ce:	52                   	push   %edx
  8026cf:	50                   	push   %eax
  8026d0:	ff 75 10             	pushl  0x10(%ebp)
  8026d3:	ff 75 0c             	pushl  0xc(%ebp)
  8026d6:	ff 75 08             	pushl  0x8(%ebp)
  8026d9:	6a 20                	push   $0x20
  8026db:	e8 fb fb ff ff       	call   8022db <syscall>
  8026e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8026e3:	90                   	nop
}
  8026e4:	c9                   	leave  
  8026e5:	c3                   	ret    

008026e6 <chktst>:
void chktst(uint32 n)
{
  8026e6:	55                   	push   %ebp
  8026e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8026e9:	6a 00                	push   $0x0
  8026eb:	6a 00                	push   $0x0
  8026ed:	6a 00                	push   $0x0
  8026ef:	6a 00                	push   $0x0
  8026f1:	ff 75 08             	pushl  0x8(%ebp)
  8026f4:	6a 22                	push   $0x22
  8026f6:	e8 e0 fb ff ff       	call   8022db <syscall>
  8026fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8026fe:	90                   	nop
}
  8026ff:	c9                   	leave  
  802700:	c3                   	ret    

00802701 <inctst>:

void inctst()
{
  802701:	55                   	push   %ebp
  802702:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802704:	6a 00                	push   $0x0
  802706:	6a 00                	push   $0x0
  802708:	6a 00                	push   $0x0
  80270a:	6a 00                	push   $0x0
  80270c:	6a 00                	push   $0x0
  80270e:	6a 23                	push   $0x23
  802710:	e8 c6 fb ff ff       	call   8022db <syscall>
  802715:	83 c4 18             	add    $0x18,%esp
	return ;
  802718:	90                   	nop
}
  802719:	c9                   	leave  
  80271a:	c3                   	ret    

0080271b <gettst>:
uint32 gettst()
{
  80271b:	55                   	push   %ebp
  80271c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80271e:	6a 00                	push   $0x0
  802720:	6a 00                	push   $0x0
  802722:	6a 00                	push   $0x0
  802724:	6a 00                	push   $0x0
  802726:	6a 00                	push   $0x0
  802728:	6a 24                	push   $0x24
  80272a:	e8 ac fb ff ff       	call   8022db <syscall>
  80272f:	83 c4 18             	add    $0x18,%esp
}
  802732:	c9                   	leave  
  802733:	c3                   	ret    

00802734 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802734:	55                   	push   %ebp
  802735:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802737:	6a 00                	push   $0x0
  802739:	6a 00                	push   $0x0
  80273b:	6a 00                	push   $0x0
  80273d:	6a 00                	push   $0x0
  80273f:	6a 00                	push   $0x0
  802741:	6a 25                	push   $0x25
  802743:	e8 93 fb ff ff       	call   8022db <syscall>
  802748:	83 c4 18             	add    $0x18,%esp
  80274b:	a3 60 d0 81 00       	mov    %eax,0x81d060
	return uheapPlaceStrategy ;
  802750:	a1 60 d0 81 00       	mov    0x81d060,%eax
}
  802755:	c9                   	leave  
  802756:	c3                   	ret    

00802757 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802757:	55                   	push   %ebp
  802758:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80275a:	8b 45 08             	mov    0x8(%ebp),%eax
  80275d:	a3 60 d0 81 00       	mov    %eax,0x81d060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802762:	6a 00                	push   $0x0
  802764:	6a 00                	push   $0x0
  802766:	6a 00                	push   $0x0
  802768:	6a 00                	push   $0x0
  80276a:	ff 75 08             	pushl  0x8(%ebp)
  80276d:	6a 26                	push   $0x26
  80276f:	e8 67 fb ff ff       	call   8022db <syscall>
  802774:	83 c4 18             	add    $0x18,%esp
	return ;
  802777:	90                   	nop
}
  802778:	c9                   	leave  
  802779:	c3                   	ret    

0080277a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80277a:	55                   	push   %ebp
  80277b:	89 e5                	mov    %esp,%ebp
  80277d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80277e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802781:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802784:	8b 55 0c             	mov    0xc(%ebp),%edx
  802787:	8b 45 08             	mov    0x8(%ebp),%eax
  80278a:	6a 00                	push   $0x0
  80278c:	53                   	push   %ebx
  80278d:	51                   	push   %ecx
  80278e:	52                   	push   %edx
  80278f:	50                   	push   %eax
  802790:	6a 27                	push   $0x27
  802792:	e8 44 fb ff ff       	call   8022db <syscall>
  802797:	83 c4 18             	add    $0x18,%esp
}
  80279a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80279d:	c9                   	leave  
  80279e:	c3                   	ret    

0080279f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80279f:	55                   	push   %ebp
  8027a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8027a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a8:	6a 00                	push   $0x0
  8027aa:	6a 00                	push   $0x0
  8027ac:	6a 00                	push   $0x0
  8027ae:	52                   	push   %edx
  8027af:	50                   	push   %eax
  8027b0:	6a 28                	push   $0x28
  8027b2:	e8 24 fb ff ff       	call   8022db <syscall>
  8027b7:	83 c4 18             	add    $0x18,%esp
}
  8027ba:	c9                   	leave  
  8027bb:	c3                   	ret    

008027bc <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8027bc:	55                   	push   %ebp
  8027bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8027bf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8027c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c8:	6a 00                	push   $0x0
  8027ca:	51                   	push   %ecx
  8027cb:	ff 75 10             	pushl  0x10(%ebp)
  8027ce:	52                   	push   %edx
  8027cf:	50                   	push   %eax
  8027d0:	6a 29                	push   $0x29
  8027d2:	e8 04 fb ff ff       	call   8022db <syscall>
  8027d7:	83 c4 18             	add    $0x18,%esp
}
  8027da:	c9                   	leave  
  8027db:	c3                   	ret    

008027dc <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8027dc:	55                   	push   %ebp
  8027dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8027df:	6a 00                	push   $0x0
  8027e1:	6a 00                	push   $0x0
  8027e3:	ff 75 10             	pushl  0x10(%ebp)
  8027e6:	ff 75 0c             	pushl  0xc(%ebp)
  8027e9:	ff 75 08             	pushl  0x8(%ebp)
  8027ec:	6a 12                	push   $0x12
  8027ee:	e8 e8 fa ff ff       	call   8022db <syscall>
  8027f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8027f6:	90                   	nop
}
  8027f7:	c9                   	leave  
  8027f8:	c3                   	ret    

008027f9 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8027f9:	55                   	push   %ebp
  8027fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8027fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802802:	6a 00                	push   $0x0
  802804:	6a 00                	push   $0x0
  802806:	6a 00                	push   $0x0
  802808:	52                   	push   %edx
  802809:	50                   	push   %eax
  80280a:	6a 2a                	push   $0x2a
  80280c:	e8 ca fa ff ff       	call   8022db <syscall>
  802811:	83 c4 18             	add    $0x18,%esp
	return;
  802814:	90                   	nop
}
  802815:	c9                   	leave  
  802816:	c3                   	ret    

00802817 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802817:	55                   	push   %ebp
  802818:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80281a:	6a 00                	push   $0x0
  80281c:	6a 00                	push   $0x0
  80281e:	6a 00                	push   $0x0
  802820:	6a 00                	push   $0x0
  802822:	6a 00                	push   $0x0
  802824:	6a 2b                	push   $0x2b
  802826:	e8 b0 fa ff ff       	call   8022db <syscall>
  80282b:	83 c4 18             	add    $0x18,%esp
}
  80282e:	c9                   	leave  
  80282f:	c3                   	ret    

00802830 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802830:	55                   	push   %ebp
  802831:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802833:	6a 00                	push   $0x0
  802835:	6a 00                	push   $0x0
  802837:	6a 00                	push   $0x0
  802839:	ff 75 0c             	pushl  0xc(%ebp)
  80283c:	ff 75 08             	pushl  0x8(%ebp)
  80283f:	6a 2d                	push   $0x2d
  802841:	e8 95 fa ff ff       	call   8022db <syscall>
  802846:	83 c4 18             	add    $0x18,%esp
	return;
  802849:	90                   	nop
}
  80284a:	c9                   	leave  
  80284b:	c3                   	ret    

0080284c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80284c:	55                   	push   %ebp
  80284d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80284f:	6a 00                	push   $0x0
  802851:	6a 00                	push   $0x0
  802853:	6a 00                	push   $0x0
  802855:	ff 75 0c             	pushl  0xc(%ebp)
  802858:	ff 75 08             	pushl  0x8(%ebp)
  80285b:	6a 2c                	push   $0x2c
  80285d:	e8 79 fa ff ff       	call   8022db <syscall>
  802862:	83 c4 18             	add    $0x18,%esp
	return ;
  802865:	90                   	nop
}
  802866:	c9                   	leave  
  802867:	c3                   	ret    

00802868 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802868:	55                   	push   %ebp
  802869:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
#if USE_KHEAP
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80286b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80286e:	8b 45 08             	mov    0x8(%ebp),%eax
  802871:	6a 00                	push   $0x0
  802873:	6a 00                	push   $0x0
  802875:	6a 00                	push   $0x0
  802877:	52                   	push   %edx
  802878:	50                   	push   %eax
  802879:	6a 2e                	push   $0x2e
  80287b:	e8 5b fa ff ff       	call   8022db <syscall>
  802880:	83 c4 18             	add    $0x18,%esp
	return ;
  802883:	90                   	nop
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
}
  802884:	c9                   	leave  
  802885:	c3                   	ret    

00802886 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802886:	55                   	push   %ebp
  802887:	89 e5                	mov    %esp,%ebp
  802889:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  80288c:	81 7d 08 60 50 80 00 	cmpl   $0x805060,0x8(%ebp)
  802893:	72 09                	jb     80289e <to_page_va+0x18>
  802895:	81 7d 08 60 d0 81 00 	cmpl   $0x81d060,0x8(%ebp)
  80289c:	72 14                	jb     8028b2 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  80289e:	83 ec 04             	sub    $0x4,%esp
  8028a1:	68 00 44 80 00       	push   $0x804400
  8028a6:	6a 15                	push   $0x15
  8028a8:	68 2b 44 80 00       	push   $0x80442b
  8028ad:	e8 4e db ff ff       	call   800400 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8028b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b5:	ba 60 50 80 00       	mov    $0x805060,%edx
  8028ba:	29 d0                	sub    %edx,%eax
  8028bc:	c1 f8 02             	sar    $0x2,%eax
  8028bf:	89 c2                	mov    %eax,%edx
  8028c1:	89 d0                	mov    %edx,%eax
  8028c3:	c1 e0 02             	shl    $0x2,%eax
  8028c6:	01 d0                	add    %edx,%eax
  8028c8:	c1 e0 02             	shl    $0x2,%eax
  8028cb:	01 d0                	add    %edx,%eax
  8028cd:	c1 e0 02             	shl    $0x2,%eax
  8028d0:	01 d0                	add    %edx,%eax
  8028d2:	89 c1                	mov    %eax,%ecx
  8028d4:	c1 e1 08             	shl    $0x8,%ecx
  8028d7:	01 c8                	add    %ecx,%eax
  8028d9:	89 c1                	mov    %eax,%ecx
  8028db:	c1 e1 10             	shl    $0x10,%ecx
  8028de:	01 c8                	add    %ecx,%eax
  8028e0:	01 c0                	add    %eax,%eax
  8028e2:	01 d0                	add    %edx,%eax
  8028e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ea:	c1 e0 0c             	shl    $0xc,%eax
  8028ed:	89 c2                	mov    %eax,%edx
  8028ef:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8028f4:	01 d0                	add    %edx,%eax
}
  8028f6:	c9                   	leave  
  8028f7:	c3                   	ret    

008028f8 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8028f8:	55                   	push   %ebp
  8028f9:	89 e5                	mov    %esp,%ebp
  8028fb:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8028fe:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802903:	8b 55 08             	mov    0x8(%ebp),%edx
  802906:	29 c2                	sub    %eax,%edx
  802908:	89 d0                	mov    %edx,%eax
  80290a:	c1 e8 0c             	shr    $0xc,%eax
  80290d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802910:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802914:	78 09                	js     80291f <to_page_info+0x27>
  802916:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80291d:	7e 14                	jle    802933 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  80291f:	83 ec 04             	sub    $0x4,%esp
  802922:	68 44 44 80 00       	push   $0x804444
  802927:	6a 22                	push   $0x22
  802929:	68 2b 44 80 00       	push   $0x80442b
  80292e:	e8 cd da ff ff       	call   800400 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802933:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802936:	89 d0                	mov    %edx,%eax
  802938:	01 c0                	add    %eax,%eax
  80293a:	01 d0                	add    %edx,%eax
  80293c:	c1 e0 02             	shl    $0x2,%eax
  80293f:	05 60 50 80 00       	add    $0x805060,%eax
}
  802944:	c9                   	leave  
  802945:	c3                   	ret    

00802946 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802946:	55                   	push   %ebp
  802947:	89 e5                	mov    %esp,%ebp
  802949:	83 ec 28             	sub    $0x28,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80294c:	8b 45 08             	mov    0x8(%ebp),%eax
  80294f:	05 00 00 00 02       	add    $0x2000000,%eax
  802954:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802957:	73 16                	jae    80296f <initialize_dynamic_allocator+0x29>
  802959:	68 68 44 80 00       	push   $0x804468
  80295e:	68 8e 44 80 00       	push   $0x80448e
  802963:	6a 34                	push   $0x34
  802965:	68 2b 44 80 00       	push   $0x80442b
  80296a:	e8 91 da ff ff       	call   800400 <_panic>
		is_initialized = 1;
  80296f:	c7 05 34 50 80 00 01 	movl   $0x1,0x805034
  802976:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here

	dynAllocStart = daStart;
  802979:	8b 45 08             	mov    0x8(%ebp),%eax
  80297c:	a3 64 d0 81 00       	mov    %eax,0x81d064
	dynAllocEnd = daEnd;
  802981:	8b 45 0c             	mov    0xc(%ebp),%eax
  802984:	a3 40 50 80 00       	mov    %eax,0x805040

	LIST_INIT(&freePagesList);
  802989:	c7 05 48 50 80 00 00 	movl   $0x0,0x805048
  802990:	00 00 00 
  802993:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80299a:	00 00 00 
  80299d:	c7 05 54 50 80 00 00 	movl   $0x0,0x805054
  8029a4:	00 00 00 

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;
  8029a7:	c7 45 e8 09 00 00 00 	movl   $0x9,-0x18(%ebp)

	for(int i = 0; i < num ; ++i){
  8029ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8029b5:	eb 36                	jmp    8029ed <initialize_dynamic_allocator+0xa7>
	    LIST_INIT(&freeBlockLists[i]);
  8029b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ba:	c1 e0 04             	shl    $0x4,%eax
  8029bd:	05 80 d0 81 00       	add    $0x81d080,%eax
  8029c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cb:	c1 e0 04             	shl    $0x4,%eax
  8029ce:	05 84 d0 81 00       	add    $0x81d084,%eax
  8029d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	c1 e0 04             	shl    $0x4,%eax
  8029df:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8029e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	LIST_INIT(&freePagesList);

	uint32 num=LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1;

	for(int i = 0; i < num ; ++i){
  8029ea:	ff 45 f4             	incl   -0xc(%ebp)
  8029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8029f3:	72 c2                	jb     8029b7 <initialize_dynamic_allocator+0x71>
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;
  8029f5:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029fb:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802a00:	29 c2                	sub    %eax,%edx
  802a02:	89 d0                	mov    %edx,%eax
  802a04:	c1 e8 0c             	shr    $0xc,%eax
  802a07:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	for(int i = 0; i < total_num_pages ; ++i){
  802a0a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802a11:	e9 c8 00 00 00       	jmp    802ade <initialize_dynamic_allocator+0x198>
		pageBlockInfoArr[i].block_size = 0;
  802a16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a19:	89 d0                	mov    %edx,%eax
  802a1b:	01 c0                	add    %eax,%eax
  802a1d:	01 d0                	add    %edx,%eax
  802a1f:	c1 e0 02             	shl    $0x2,%eax
  802a22:	05 68 50 80 00       	add    $0x805068,%eax
  802a27:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802a2c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a2f:	89 d0                	mov    %edx,%eax
  802a31:	01 c0                	add    %eax,%eax
  802a33:	01 d0                	add    %edx,%eax
  802a35:	c1 e0 02             	shl    $0x2,%eax
  802a38:	05 6a 50 80 00       	add    $0x80506a,%eax
  802a3d:	66 c7 00 00 00       	movw   $0x0,(%eax)

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802a42:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802a48:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802a4b:	89 c8                	mov    %ecx,%eax
  802a4d:	01 c0                	add    %eax,%eax
  802a4f:	01 c8                	add    %ecx,%eax
  802a51:	c1 e0 02             	shl    $0x2,%eax
  802a54:	05 64 50 80 00       	add    $0x805064,%eax
  802a59:	89 10                	mov    %edx,(%eax)
  802a5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a5e:	89 d0                	mov    %edx,%eax
  802a60:	01 c0                	add    %eax,%eax
  802a62:	01 d0                	add    %edx,%eax
  802a64:	c1 e0 02             	shl    $0x2,%eax
  802a67:	05 64 50 80 00       	add    $0x805064,%eax
  802a6c:	8b 00                	mov    (%eax),%eax
  802a6e:	85 c0                	test   %eax,%eax
  802a70:	74 1b                	je     802a8d <initialize_dynamic_allocator+0x147>
  802a72:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  802a78:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802a7b:	89 c8                	mov    %ecx,%eax
  802a7d:	01 c0                	add    %eax,%eax
  802a7f:	01 c8                	add    %ecx,%eax
  802a81:	c1 e0 02             	shl    $0x2,%eax
  802a84:	05 60 50 80 00       	add    $0x805060,%eax
  802a89:	89 02                	mov    %eax,(%edx)
  802a8b:	eb 16                	jmp    802aa3 <initialize_dynamic_allocator+0x15d>
  802a8d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a90:	89 d0                	mov    %edx,%eax
  802a92:	01 c0                	add    %eax,%eax
  802a94:	01 d0                	add    %edx,%eax
  802a96:	c1 e0 02             	shl    $0x2,%eax
  802a99:	05 60 50 80 00       	add    $0x805060,%eax
  802a9e:	a3 48 50 80 00       	mov    %eax,0x805048
  802aa3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aa6:	89 d0                	mov    %edx,%eax
  802aa8:	01 c0                	add    %eax,%eax
  802aaa:	01 d0                	add    %edx,%eax
  802aac:	c1 e0 02             	shl    $0x2,%eax
  802aaf:	05 60 50 80 00       	add    $0x805060,%eax
  802ab4:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802ab9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802abc:	89 d0                	mov    %edx,%eax
  802abe:	01 c0                	add    %eax,%eax
  802ac0:	01 d0                	add    %edx,%eax
  802ac2:	c1 e0 02             	shl    $0x2,%eax
  802ac5:	05 60 50 80 00       	add    $0x805060,%eax
  802aca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad0:	a1 54 50 80 00       	mov    0x805054,%eax
  802ad5:	40                   	inc    %eax
  802ad6:	a3 54 50 80 00       	mov    %eax,0x805054
	    LIST_INIT(&freeBlockLists[i]);
	}

	uint32 total_num_pages=(dynAllocEnd - dynAllocStart) / PAGE_SIZE;

	for(int i = 0; i < total_num_pages ; ++i){
  802adb:	ff 45 f0             	incl   -0x10(%ebp)
  802ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802ae4:	0f 82 2c ff ff ff    	jb     802a16 <initialize_dynamic_allocator+0xd0>
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802aea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802af0:	eb 2f                	jmp    802b21 <initialize_dynamic_allocator+0x1db>
	        pageBlockInfoArr[i].block_size = 0;
  802af2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802af5:	89 d0                	mov    %edx,%eax
  802af7:	01 c0                	add    %eax,%eax
  802af9:	01 d0                	add    %edx,%eax
  802afb:	c1 e0 02             	shl    $0x2,%eax
  802afe:	05 68 50 80 00       	add    $0x805068,%eax
  802b03:	66 c7 00 00 00       	movw   $0x0,(%eax)
	        pageBlockInfoArr[i].num_of_free_blocks = 0;
  802b08:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b0b:	89 d0                	mov    %edx,%eax
  802b0d:	01 c0                	add    %eax,%eax
  802b0f:	01 d0                	add    %edx,%eax
  802b11:	c1 e0 02             	shl    $0x2,%eax
  802b14:	05 6a 50 80 00       	add    $0x80506a,%eax
  802b19:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;

	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	for(uint32 i = total_num_pages; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; ++i) {
  802b1e:	ff 45 ec             	incl   -0x14(%ebp)
  802b21:	81 7d ec ff 1f 00 00 	cmpl   $0x1fff,-0x14(%ebp)
  802b28:	76 c8                	jbe    802af2 <initialize_dynamic_allocator+0x1ac>
	}

	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802b2a:	90                   	nop
  802b2b:	c9                   	leave  
  802b2c:	c3                   	ret    

00802b2d <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802b2d:	55                   	push   %ebp
  802b2e:	89 e5                	mov    %esp,%ebp
  802b30:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	int index = ((uint32)va - dynAllocStart) / PAGE_SIZE;
  802b33:	8b 55 08             	mov    0x8(%ebp),%edx
  802b36:	a1 64 d0 81 00       	mov    0x81d064,%eax
  802b3b:	29 c2                	sub    %eax,%edx
  802b3d:	89 d0                	mov    %edx,%eax
  802b3f:	c1 e8 0c             	shr    $0xc,%eax
  802b42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return pageBlockInfoArr[index].block_size;
  802b45:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802b48:	89 d0                	mov    %edx,%eax
  802b4a:	01 c0                	add    %eax,%eax
  802b4c:	01 d0                	add    %edx,%eax
  802b4e:	c1 e0 02             	shl    $0x2,%eax
  802b51:	05 68 50 80 00       	add    $0x805068,%eax
  802b56:	8b 00                	mov    (%eax),%eax
  802b58:	0f b7 c0             	movzwl %ax,%eax

	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802b5b:	c9                   	leave  
  802b5c:	c3                   	ret    

00802b5d <nearest_pow2_ceil.1513>:
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here

    inline unsigned int nearest_pow2_ceil(unsigned int x) {
  802b5d:	55                   	push   %ebp
  802b5e:	89 e5                	mov    %esp,%ebp
  802b60:	83 ec 14             	sub    $0x14,%esp
  802b63:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x <= 1) return 1;
  802b66:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  802b6a:	77 07                	ja     802b73 <nearest_pow2_ceil.1513+0x16>
  802b6c:	b8 01 00 00 00       	mov    $0x1,%eax
  802b71:	eb 20                	jmp    802b93 <nearest_pow2_ceil.1513+0x36>
        int power = 2;
  802b73:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
        x--;
  802b7a:	ff 4d 08             	decl   0x8(%ebp)
        while (x >>= 1) power <<= 1;
  802b7d:	eb 08                	jmp    802b87 <nearest_pow2_ceil.1513+0x2a>
  802b7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b82:	01 c0                	add    %eax,%eax
  802b84:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b87:	d1 6d 08             	shrl   0x8(%ebp)
  802b8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b8e:	75 ef                	jne    802b7f <nearest_pow2_ceil.1513+0x22>
        return power;
  802b90:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  802b93:	c9                   	leave  
  802b94:	c3                   	ret    

00802b95 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802b95:	55                   	push   %ebp
  802b96:	89 e5                	mov    %esp,%ebp
  802b98:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802b9b:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802ba2:	76 16                	jbe    802bba <alloc_block+0x25>
  802ba4:	68 a4 44 80 00       	push   $0x8044a4
  802ba9:	68 8e 44 80 00       	push   $0x80448e
  802bae:	6a 72                	push   $0x72
  802bb0:	68 2b 44 80 00       	push   $0x80442b
  802bb5:	e8 46 d8 ff ff       	call   800400 <_panic>
            bits_cnt++;
        }
        return bits_cnt;
    }

    if(!size) return NULL;
  802bba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bbe:	75 0a                	jne    802bca <alloc_block+0x35>
  802bc0:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc5:	e9 bd 04 00 00       	jmp    803087 <alloc_block+0x4f2>

    uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  802bca:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
    if (size < min_block_size)
  802bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802bd7:	73 06                	jae    802bdf <alloc_block+0x4a>
        size = min_block_size;
  802bd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdc:	89 45 08             	mov    %eax,0x8(%ebp)

    int pow = nearest_pow2_ceil(size);
  802bdf:	83 ec 0c             	sub    $0xc,%esp
  802be2:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802be5:	ff 75 08             	pushl  0x8(%ebp)
  802be8:	89 c1                	mov    %eax,%ecx
  802bea:	e8 6e ff ff ff       	call   802b5d <nearest_pow2_ceil.1513>
  802bef:	83 c4 10             	add    $0x10,%esp
  802bf2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    int index = log2_ceil(pow) - LOG2_MIN_SIZE;
  802bf5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bf8:	83 ec 0c             	sub    $0xc,%esp
  802bfb:	8d 45 cc             	lea    -0x34(%ebp),%eax
  802bfe:	52                   	push   %edx
  802bff:	89 c1                	mov    %eax,%ecx
  802c01:	e8 83 04 00 00       	call   803089 <log2_ceil.1520>
  802c06:	83 c4 10             	add    $0x10,%esp
  802c09:	83 e8 03             	sub    $0x3,%eax
  802c0c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // CASE 1: free block exists
    if (!LIST_EMPTY(&freeBlockLists[index])) {
  802c0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c12:	c1 e0 04             	shl    $0x4,%eax
  802c15:	05 80 d0 81 00       	add    $0x81d080,%eax
  802c1a:	8b 00                	mov    (%eax),%eax
  802c1c:	85 c0                	test   %eax,%eax
  802c1e:	0f 84 d8 00 00 00    	je     802cfc <alloc_block+0x167>
        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802c24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c27:	c1 e0 04             	shl    $0x4,%eax
  802c2a:	05 80 d0 81 00       	add    $0x81d080,%eax
  802c2f:	8b 00                	mov    (%eax),%eax
  802c31:	89 45 e0             	mov    %eax,-0x20(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802c34:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c38:	75 17                	jne    802c51 <alloc_block+0xbc>
  802c3a:	83 ec 04             	sub    $0x4,%esp
  802c3d:	68 c5 44 80 00       	push   $0x8044c5
  802c42:	68 98 00 00 00       	push   $0x98
  802c47:	68 2b 44 80 00       	push   $0x80442b
  802c4c:	e8 af d7 ff ff       	call   800400 <_panic>
  802c51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c54:	8b 00                	mov    (%eax),%eax
  802c56:	85 c0                	test   %eax,%eax
  802c58:	74 10                	je     802c6a <alloc_block+0xd5>
  802c5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c5d:	8b 00                	mov    (%eax),%eax
  802c5f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c62:	8b 52 04             	mov    0x4(%edx),%edx
  802c65:	89 50 04             	mov    %edx,0x4(%eax)
  802c68:	eb 14                	jmp    802c7e <alloc_block+0xe9>
  802c6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c6d:	8b 40 04             	mov    0x4(%eax),%eax
  802c70:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c73:	c1 e2 04             	shl    $0x4,%edx
  802c76:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802c7c:	89 02                	mov    %eax,(%edx)
  802c7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c81:	8b 40 04             	mov    0x4(%eax),%eax
  802c84:	85 c0                	test   %eax,%eax
  802c86:	74 0f                	je     802c97 <alloc_block+0x102>
  802c88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c8b:	8b 40 04             	mov    0x4(%eax),%eax
  802c8e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c91:	8b 12                	mov    (%edx),%edx
  802c93:	89 10                	mov    %edx,(%eax)
  802c95:	eb 13                	jmp    802caa <alloc_block+0x115>
  802c97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c9a:	8b 00                	mov    (%eax),%eax
  802c9c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c9f:	c1 e2 04             	shl    $0x4,%edx
  802ca2:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802ca8:	89 02                	mov    %eax,(%edx)
  802caa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cb6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cc0:	c1 e0 04             	shl    $0x4,%eax
  802cc3:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802cc8:	8b 00                	mov    (%eax),%eax
  802cca:	8d 50 ff             	lea    -0x1(%eax),%edx
  802ccd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cd0:	c1 e0 04             	shl    $0x4,%eax
  802cd3:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802cd8:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802cda:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cdd:	83 ec 0c             	sub    $0xc,%esp
  802ce0:	50                   	push   %eax
  802ce1:	e8 12 fc ff ff       	call   8028f8 <to_page_info>
  802ce6:	83 c4 10             	add    $0x10,%esp
  802ce9:	89 c2                	mov    %eax,%edx
  802ceb:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802cef:	48                   	dec    %eax
  802cf0:	66 89 42 0a          	mov    %ax,0xa(%edx)
        return (void *)e;
  802cf4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cf7:	e9 8b 03 00 00       	jmp    803087 <alloc_block+0x4f2>
    }

    // CASE 2: allocate a new page
    if (!LIST_EMPTY(&freePagesList)) {
  802cfc:	a1 48 50 80 00       	mov    0x805048,%eax
  802d01:	85 c0                	test   %eax,%eax
  802d03:	0f 84 64 02 00 00    	je     802f6d <alloc_block+0x3d8>
        struct PageInfoElement *page_info_e = LIST_FIRST(&freePagesList);
  802d09:	a1 48 50 80 00       	mov    0x805048,%eax
  802d0e:	89 45 dc             	mov    %eax,-0x24(%ebp)
        LIST_REMOVE(&freePagesList, page_info_e);
  802d11:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d15:	75 17                	jne    802d2e <alloc_block+0x199>
  802d17:	83 ec 04             	sub    $0x4,%esp
  802d1a:	68 c5 44 80 00       	push   $0x8044c5
  802d1f:	68 a0 00 00 00       	push   $0xa0
  802d24:	68 2b 44 80 00       	push   $0x80442b
  802d29:	e8 d2 d6 ff ff       	call   800400 <_panic>
  802d2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d31:	8b 00                	mov    (%eax),%eax
  802d33:	85 c0                	test   %eax,%eax
  802d35:	74 10                	je     802d47 <alloc_block+0x1b2>
  802d37:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d3a:	8b 00                	mov    (%eax),%eax
  802d3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d3f:	8b 52 04             	mov    0x4(%edx),%edx
  802d42:	89 50 04             	mov    %edx,0x4(%eax)
  802d45:	eb 0b                	jmp    802d52 <alloc_block+0x1bd>
  802d47:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d4a:	8b 40 04             	mov    0x4(%eax),%eax
  802d4d:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802d52:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d55:	8b 40 04             	mov    0x4(%eax),%eax
  802d58:	85 c0                	test   %eax,%eax
  802d5a:	74 0f                	je     802d6b <alloc_block+0x1d6>
  802d5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d5f:	8b 40 04             	mov    0x4(%eax),%eax
  802d62:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d65:	8b 12                	mov    (%edx),%edx
  802d67:	89 10                	mov    %edx,(%eax)
  802d69:	eb 0a                	jmp    802d75 <alloc_block+0x1e0>
  802d6b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d6e:	8b 00                	mov    (%eax),%eax
  802d70:	a3 48 50 80 00       	mov    %eax,0x805048
  802d75:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d7e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d88:	a1 54 50 80 00       	mov    0x805054,%eax
  802d8d:	48                   	dec    %eax
  802d8e:	a3 54 50 80 00       	mov    %eax,0x805054

        page_info_e->block_size = pow;
  802d93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d96:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d99:	66 89 42 08          	mov    %ax,0x8(%edx)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;
  802d9d:	b8 00 10 00 00       	mov    $0x1000,%eax
  802da2:	99                   	cltd   
  802da3:	f7 7d e8             	idivl  -0x18(%ebp)
  802da6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802da9:	66 89 42 0a          	mov    %ax,0xa(%edx)

        uint32 page_address = to_page_va(page_info_e);
  802dad:	83 ec 0c             	sub    $0xc,%esp
  802db0:	ff 75 dc             	pushl  -0x24(%ebp)
  802db3:	e8 ce fa ff ff       	call   802886 <to_page_va>
  802db8:	83 c4 10             	add    $0x10,%esp
  802dbb:	89 45 d8             	mov    %eax,-0x28(%ebp)
        get_page((void *)page_address);
  802dbe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802dc1:	83 ec 0c             	sub    $0xc,%esp
  802dc4:	50                   	push   %eax
  802dc5:	e8 c0 ee ff ff       	call   801c8a <get_page>
  802dca:	83 c4 10             	add    $0x10,%esp

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802dcd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802dd4:	e9 aa 00 00 00       	jmp    802e83 <alloc_block+0x2ee>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
  802dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddc:	0f af 45 e8          	imul   -0x18(%ebp),%eax
  802de0:	89 c2                	mov    %eax,%edx
  802de2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802de5:	01 d0                	add    %edx,%eax
  802de7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
  802dea:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802dee:	75 17                	jne    802e07 <alloc_block+0x272>
  802df0:	83 ec 04             	sub    $0x4,%esp
  802df3:	68 e4 44 80 00       	push   $0x8044e4
  802df8:	68 aa 00 00 00       	push   $0xaa
  802dfd:	68 2b 44 80 00       	push   $0x80442b
  802e02:	e8 f9 d5 ff ff       	call   800400 <_panic>
  802e07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e0a:	c1 e0 04             	shl    $0x4,%eax
  802e0d:	05 84 d0 81 00       	add    $0x81d084,%eax
  802e12:	8b 10                	mov    (%eax),%edx
  802e14:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e17:	89 50 04             	mov    %edx,0x4(%eax)
  802e1a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e1d:	8b 40 04             	mov    0x4(%eax),%eax
  802e20:	85 c0                	test   %eax,%eax
  802e22:	74 14                	je     802e38 <alloc_block+0x2a3>
  802e24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e27:	c1 e0 04             	shl    $0x4,%eax
  802e2a:	05 84 d0 81 00       	add    $0x81d084,%eax
  802e2f:	8b 00                	mov    (%eax),%eax
  802e31:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802e34:	89 10                	mov    %edx,(%eax)
  802e36:	eb 11                	jmp    802e49 <alloc_block+0x2b4>
  802e38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e3b:	c1 e0 04             	shl    $0x4,%eax
  802e3e:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  802e44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e47:	89 02                	mov    %eax,(%edx)
  802e49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e4c:	c1 e0 04             	shl    $0x4,%eax
  802e4f:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  802e55:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e58:	89 02                	mov    %eax,(%edx)
  802e5a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e66:	c1 e0 04             	shl    $0x4,%eax
  802e69:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802e6e:	8b 00                	mov    (%eax),%eax
  802e70:	8d 50 01             	lea    0x1(%eax),%edx
  802e73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e76:	c1 e0 04             	shl    $0x4,%eax
  802e79:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802e7e:	89 10                	mov    %edx,(%eax)
        page_info_e->num_of_free_blocks = PAGE_SIZE / pow;

        uint32 page_address = to_page_va(page_info_e);
        get_page((void *)page_address);

        for (int i = 0; i < PAGE_SIZE / pow; ++i) {
  802e80:	ff 45 f4             	incl   -0xc(%ebp)
  802e83:	b8 00 10 00 00       	mov    $0x1000,%eax
  802e88:	99                   	cltd   
  802e89:	f7 7d e8             	idivl  -0x18(%ebp)
  802e8c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802e8f:	0f 8f 44 ff ff ff    	jg     802dd9 <alloc_block+0x244>
            struct BlockElement *block = (struct BlockElement *)(page_address + i * pow);
            LIST_INSERT_TAIL(&freeBlockLists[index], block);
        }

        struct BlockElement *e = LIST_FIRST(&freeBlockLists[index]);
  802e95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e98:	c1 e0 04             	shl    $0x4,%eax
  802e9b:	05 80 d0 81 00       	add    $0x81d080,%eax
  802ea0:	8b 00                	mov    (%eax),%eax
  802ea2:	89 45 d0             	mov    %eax,-0x30(%ebp)
        LIST_REMOVE(&freeBlockLists[index], e);
  802ea5:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802ea9:	75 17                	jne    802ec2 <alloc_block+0x32d>
  802eab:	83 ec 04             	sub    $0x4,%esp
  802eae:	68 c5 44 80 00       	push   $0x8044c5
  802eb3:	68 ae 00 00 00       	push   $0xae
  802eb8:	68 2b 44 80 00       	push   $0x80442b
  802ebd:	e8 3e d5 ff ff       	call   800400 <_panic>
  802ec2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ec5:	8b 00                	mov    (%eax),%eax
  802ec7:	85 c0                	test   %eax,%eax
  802ec9:	74 10                	je     802edb <alloc_block+0x346>
  802ecb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ece:	8b 00                	mov    (%eax),%eax
  802ed0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802ed3:	8b 52 04             	mov    0x4(%edx),%edx
  802ed6:	89 50 04             	mov    %edx,0x4(%eax)
  802ed9:	eb 14                	jmp    802eef <alloc_block+0x35a>
  802edb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ede:	8b 40 04             	mov    0x4(%eax),%eax
  802ee1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ee4:	c1 e2 04             	shl    $0x4,%edx
  802ee7:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802eed:	89 02                	mov    %eax,(%edx)
  802eef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ef2:	8b 40 04             	mov    0x4(%eax),%eax
  802ef5:	85 c0                	test   %eax,%eax
  802ef7:	74 0f                	je     802f08 <alloc_block+0x373>
  802ef9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802efc:	8b 40 04             	mov    0x4(%eax),%eax
  802eff:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802f02:	8b 12                	mov    (%edx),%edx
  802f04:	89 10                	mov    %edx,(%eax)
  802f06:	eb 13                	jmp    802f1b <alloc_block+0x386>
  802f08:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f0b:	8b 00                	mov    (%eax),%eax
  802f0d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f10:	c1 e2 04             	shl    $0x4,%edx
  802f13:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  802f19:	89 02                	mov    %eax,(%edx)
  802f1b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f24:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f31:	c1 e0 04             	shl    $0x4,%eax
  802f34:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f39:	8b 00                	mov    (%eax),%eax
  802f3b:	8d 50 ff             	lea    -0x1(%eax),%edx
  802f3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f41:	c1 e0 04             	shl    $0x4,%eax
  802f44:	05 8c d0 81 00       	add    $0x81d08c,%eax
  802f49:	89 10                	mov    %edx,(%eax)
        to_page_info((uint32) e)->num_of_free_blocks--;
  802f4b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f4e:	83 ec 0c             	sub    $0xc,%esp
  802f51:	50                   	push   %eax
  802f52:	e8 a1 f9 ff ff       	call   8028f8 <to_page_info>
  802f57:	83 c4 10             	add    $0x10,%esp
  802f5a:	89 c2                	mov    %eax,%edx
  802f5c:	66 8b 42 0a          	mov    0xa(%edx),%ax
  802f60:	48                   	dec    %eax
  802f61:	66 89 42 0a          	mov    %ax,0xa(%edx)

        return (void *)e;
  802f65:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f68:	e9 1a 01 00 00       	jmp    803087 <alloc_block+0x4f2>
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  802f6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f70:	40                   	inc    %eax
  802f71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802f74:	e9 ed 00 00 00       	jmp    803066 <alloc_block+0x4d1>
        if (!LIST_EMPTY(&freeBlockLists[i])) {
  802f79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7c:	c1 e0 04             	shl    $0x4,%eax
  802f7f:	05 80 d0 81 00       	add    $0x81d080,%eax
  802f84:	8b 00                	mov    (%eax),%eax
  802f86:	85 c0                	test   %eax,%eax
  802f88:	0f 84 d5 00 00 00    	je     803063 <alloc_block+0x4ce>
            struct BlockElement *e = LIST_FIRST(&freeBlockLists[i]);
  802f8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f91:	c1 e0 04             	shl    $0x4,%eax
  802f94:	05 80 d0 81 00       	add    $0x81d080,%eax
  802f99:	8b 00                	mov    (%eax),%eax
  802f9b:	89 45 cc             	mov    %eax,-0x34(%ebp)
            LIST_REMOVE(&freeBlockLists[i], e);
  802f9e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802fa2:	75 17                	jne    802fbb <alloc_block+0x426>
  802fa4:	83 ec 04             	sub    $0x4,%esp
  802fa7:	68 c5 44 80 00       	push   $0x8044c5
  802fac:	68 b8 00 00 00       	push   $0xb8
  802fb1:	68 2b 44 80 00       	push   $0x80442b
  802fb6:	e8 45 d4 ff ff       	call   800400 <_panic>
  802fbb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fbe:	8b 00                	mov    (%eax),%eax
  802fc0:	85 c0                	test   %eax,%eax
  802fc2:	74 10                	je     802fd4 <alloc_block+0x43f>
  802fc4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fc7:	8b 00                	mov    (%eax),%eax
  802fc9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802fcc:	8b 52 04             	mov    0x4(%edx),%edx
  802fcf:	89 50 04             	mov    %edx,0x4(%eax)
  802fd2:	eb 14                	jmp    802fe8 <alloc_block+0x453>
  802fd4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fd7:	8b 40 04             	mov    0x4(%eax),%eax
  802fda:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fdd:	c1 e2 04             	shl    $0x4,%edx
  802fe0:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  802fe6:	89 02                	mov    %eax,(%edx)
  802fe8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802feb:	8b 40 04             	mov    0x4(%eax),%eax
  802fee:	85 c0                	test   %eax,%eax
  802ff0:	74 0f                	je     803001 <alloc_block+0x46c>
  802ff2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ff5:	8b 40 04             	mov    0x4(%eax),%eax
  802ff8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ffb:	8b 12                	mov    (%edx),%edx
  802ffd:	89 10                	mov    %edx,(%eax)
  802fff:	eb 13                	jmp    803014 <alloc_block+0x47f>
  803001:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803004:	8b 00                	mov    (%eax),%eax
  803006:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803009:	c1 e2 04             	shl    $0x4,%edx
  80300c:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803012:	89 02                	mov    %eax,(%edx)
  803014:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803017:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80301d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803020:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803027:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302a:	c1 e0 04             	shl    $0x4,%eax
  80302d:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803032:	8b 00                	mov    (%eax),%eax
  803034:	8d 50 ff             	lea    -0x1(%eax),%edx
  803037:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303a:	c1 e0 04             	shl    $0x4,%eax
  80303d:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803042:	89 10                	mov    %edx,(%eax)
            to_page_info((uint32) e)->num_of_free_blocks--;
  803044:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803047:	83 ec 0c             	sub    $0xc,%esp
  80304a:	50                   	push   %eax
  80304b:	e8 a8 f8 ff ff       	call   8028f8 <to_page_info>
  803050:	83 c4 10             	add    $0x10,%esp
  803053:	89 c2                	mov    %eax,%edx
  803055:	66 8b 42 0a          	mov    0xa(%edx),%ax
  803059:	48                   	dec    %eax
  80305a:	66 89 42 0a          	mov    %ax,0xa(%edx)
            return (void *)e;
  80305e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803061:	eb 24                	jmp    803087 <alloc_block+0x4f2>

        return (void *)e;
    }

    // CASE 3
    for (int i = index + 1; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; ++i) {
  803063:	ff 45 f0             	incl   -0x10(%ebp)
  803066:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  80306a:	0f 8e 09 ff ff ff    	jle    802f79 <alloc_block+0x3e4>
            return (void *)e;
        }
    }

    // CASE 4:
    panic("...");
  803070:	83 ec 04             	sub    $0x4,%esp
  803073:	68 07 45 80 00       	push   $0x804507
  803078:	68 bf 00 00 00       	push   $0xbf
  80307d:	68 2b 44 80 00       	push   $0x80442b
  803082:	e8 79 d3 ff ff       	call   800400 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  803087:	c9                   	leave  
  803088:	c3                   	ret    

00803089 <log2_ceil.1520>:
        x--;
        while (x >>= 1) power <<= 1;
        return power;
    }

    inline unsigned int log2_ceil(unsigned int x) {
  803089:	55                   	push   %ebp
  80308a:	89 e5                	mov    %esp,%ebp
  80308c:	83 ec 14             	sub    $0x14,%esp
  80308f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        if (x == 0) return 0;
  803092:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803096:	75 07                	jne    80309f <log2_ceil.1520+0x16>
  803098:	b8 00 00 00 00       	mov    $0x0,%eax
  80309d:	eb 1b                	jmp    8030ba <log2_ceil.1520+0x31>
        int bits_cnt = 0;
  80309f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        x--;
  8030a6:	ff 4d 08             	decl   0x8(%ebp)
        while (x > 0) {
  8030a9:	eb 06                	jmp    8030b1 <log2_ceil.1520+0x28>
            x >>= 1;
  8030ab:	d1 6d 08             	shrl   0x8(%ebp)
            bits_cnt++;
  8030ae:	ff 45 fc             	incl   -0x4(%ebp)

    inline unsigned int log2_ceil(unsigned int x) {
        if (x == 0) return 0;
        int bits_cnt = 0;
        x--;
        while (x > 0) {
  8030b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030b5:	75 f4                	jne    8030ab <log2_ceil.1520+0x22>
            x >>= 1;
            bits_cnt++;
        }
        return bits_cnt;
  8030b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    }
  8030ba:	c9                   	leave  
  8030bb:	c3                   	ret    

008030bc <log2_ceil.1547>:
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	inline unsigned int log2_ceil(unsigned int x) {
  8030bc:	55                   	push   %ebp
  8030bd:	89 e5                	mov    %esp,%ebp
  8030bf:	83 ec 14             	sub    $0x14,%esp
  8030c2:	89 4d ec             	mov    %ecx,-0x14(%ebp)
		if (x == 0) return 0;
  8030c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c9:	75 07                	jne    8030d2 <log2_ceil.1547+0x16>
  8030cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8030d0:	eb 1b                	jmp    8030ed <log2_ceil.1547+0x31>
		int bits_cnt = 0;
  8030d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		x--;
  8030d9:	ff 4d 08             	decl   0x8(%ebp)
		while (x > 0) {
  8030dc:	eb 06                	jmp    8030e4 <log2_ceil.1547+0x28>
			x >>= 1;
  8030de:	d1 6d 08             	shrl   0x8(%ebp)
			bits_cnt++;
  8030e1:	ff 45 fc             	incl   -0x4(%ebp)

	inline unsigned int log2_ceil(unsigned int x) {
		if (x == 0) return 0;
		int bits_cnt = 0;
		x--;
		while (x > 0) {
  8030e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030e8:	75 f4                	jne    8030de <log2_ceil.1547+0x22>
			x >>= 1;
			bits_cnt++;
		}
		return bits_cnt;
  8030ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  8030ed:	c9                   	leave  
  8030ee:	c3                   	ret    

008030ef <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8030ef:	55                   	push   %ebp
  8030f0:	89 e5                	mov    %esp,%ebp
  8030f2:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8030f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f8:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8030fd:	39 c2                	cmp    %eax,%edx
  8030ff:	72 0c                	jb     80310d <free_block+0x1e>
  803101:	8b 55 08             	mov    0x8(%ebp),%edx
  803104:	a1 40 50 80 00       	mov    0x805040,%eax
  803109:	39 c2                	cmp    %eax,%edx
  80310b:	72 19                	jb     803126 <free_block+0x37>
  80310d:	68 0c 45 80 00       	push   $0x80450c
  803112:	68 8e 44 80 00       	push   $0x80448e
  803117:	68 d0 00 00 00       	push   $0xd0
  80311c:	68 2b 44 80 00       	push   $0x80442b
  803121:	e8 da d2 ff ff       	call   800400 <_panic>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803126:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80312a:	0f 84 42 03 00 00    	je     803472 <free_block+0x383>

	if ((uint32)va < dynAllocStart || (uint32)va >= dynAllocEnd) {
  803130:	8b 55 08             	mov    0x8(%ebp),%edx
  803133:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803138:	39 c2                	cmp    %eax,%edx
  80313a:	72 0c                	jb     803148 <free_block+0x59>
  80313c:	8b 55 08             	mov    0x8(%ebp),%edx
  80313f:	a1 40 50 80 00       	mov    0x805040,%eax
  803144:	39 c2                	cmp    %eax,%edx
  803146:	72 17                	jb     80315f <free_block+0x70>
		panic("free_block: address outside dynamic allocator range");
  803148:	83 ec 04             	sub    $0x4,%esp
  80314b:	68 44 45 80 00       	push   $0x804544
  803150:	68 e6 00 00 00       	push   $0xe6
  803155:	68 2b 44 80 00       	push   $0x80442b
  80315a:	e8 a1 d2 ff ff       	call   800400 <_panic>
	}

	if (((uint32)va - dynAllocStart) % DYN_ALLOC_MIN_BLOCK_SIZE != 0) {
  80315f:	8b 55 08             	mov    0x8(%ebp),%edx
  803162:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803167:	29 c2                	sub    %eax,%edx
  803169:	89 d0                	mov    %edx,%eax
  80316b:	83 e0 07             	and    $0x7,%eax
  80316e:	85 c0                	test   %eax,%eax
  803170:	74 17                	je     803189 <free_block+0x9a>
		panic("free_block: address is not properly aligned");
  803172:	83 ec 04             	sub    $0x4,%esp
  803175:	68 78 45 80 00       	push   $0x804578
  80317a:	68 ea 00 00 00       	push   $0xea
  80317f:	68 2b 44 80 00       	push   $0x80442b
  803184:	e8 77 d2 ff ff       	call   800400 <_panic>
	}

	struct PageInfoElement *page_info_e = to_page_info((uint32) va);
  803189:	8b 45 08             	mov    0x8(%ebp),%eax
  80318c:	83 ec 0c             	sub    $0xc,%esp
  80318f:	50                   	push   %eax
  803190:	e8 63 f7 ff ff       	call   8028f8 <to_page_info>
  803195:	83 c4 10             	add    $0x10,%esp
  803198:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int size = get_block_size(va);
  80319b:	83 ec 0c             	sub    $0xc,%esp
  80319e:	ff 75 08             	pushl  0x8(%ebp)
  8031a1:	e8 87 f9 ff ff       	call   802b2d <get_block_size>
  8031a6:	83 c4 10             	add    $0x10,%esp
  8031a9:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if (size == 0) {
  8031ac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031b0:	75 17                	jne    8031c9 <free_block+0xda>
		panic("free_block: attempting to free from unallocated page (double free detected)");
  8031b2:	83 ec 04             	sub    $0x4,%esp
  8031b5:	68 a4 45 80 00       	push   $0x8045a4
  8031ba:	68 f1 00 00 00       	push   $0xf1
  8031bf:	68 2b 44 80 00       	push   $0x80442b
  8031c4:	e8 37 d2 ff ff       	call   800400 <_panic>
	}

    int index = log2_ceil(size) - LOG2_MIN_SIZE;
  8031c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031cc:	83 ec 0c             	sub    $0xc,%esp
  8031cf:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8031d2:	52                   	push   %edx
  8031d3:	89 c1                	mov    %eax,%ecx
  8031d5:	e8 e2 fe ff ff       	call   8030bc <log2_ceil.1547>
  8031da:	83 c4 10             	add    $0x10,%esp
  8031dd:	83 e8 03             	sub    $0x3,%eax
  8031e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct BlockElement * block = (struct BlockElement *) va;
  8031e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    LIST_INSERT_HEAD(&freeBlockLists[index], block);
  8031e9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8031ed:	75 17                	jne    803206 <free_block+0x117>
  8031ef:	83 ec 04             	sub    $0x4,%esp
  8031f2:	68 f0 45 80 00       	push   $0x8045f0
  8031f7:	68 f6 00 00 00       	push   $0xf6
  8031fc:	68 2b 44 80 00       	push   $0x80442b
  803201:	e8 fa d1 ff ff       	call   800400 <_panic>
  803206:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803209:	c1 e0 04             	shl    $0x4,%eax
  80320c:	05 80 d0 81 00       	add    $0x81d080,%eax
  803211:	8b 10                	mov    (%eax),%edx
  803213:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803216:	89 10                	mov    %edx,(%eax)
  803218:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80321b:	8b 00                	mov    (%eax),%eax
  80321d:	85 c0                	test   %eax,%eax
  80321f:	74 15                	je     803236 <free_block+0x147>
  803221:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803224:	c1 e0 04             	shl    $0x4,%eax
  803227:	05 80 d0 81 00       	add    $0x81d080,%eax
  80322c:	8b 00                	mov    (%eax),%eax
  80322e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803231:	89 50 04             	mov    %edx,0x4(%eax)
  803234:	eb 11                	jmp    803247 <free_block+0x158>
  803236:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803239:	c1 e0 04             	shl    $0x4,%eax
  80323c:	8d 90 84 d0 81 00    	lea    0x81d084(%eax),%edx
  803242:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803245:	89 02                	mov    %eax,(%edx)
  803247:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80324a:	c1 e0 04             	shl    $0x4,%eax
  80324d:	8d 90 80 d0 81 00    	lea    0x81d080(%eax),%edx
  803253:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803256:	89 02                	mov    %eax,(%edx)
  803258:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80325b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803262:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803265:	c1 e0 04             	shl    $0x4,%eax
  803268:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80326d:	8b 00                	mov    (%eax),%eax
  80326f:	8d 50 01             	lea    0x1(%eax),%edx
  803272:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803275:	c1 e0 04             	shl    $0x4,%eax
  803278:	05 8c d0 81 00       	add    $0x81d08c,%eax
  80327d:	89 10                	mov    %edx,(%eax)
    page_info_e->num_of_free_blocks++;
  80327f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803282:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803286:	40                   	inc    %eax
  803287:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80328a:	66 89 42 0a          	mov    %ax,0xa(%edx)

	uint32 page_index = ((uint32) va - dynAllocStart) / PAGE_SIZE;
  80328e:	8b 55 08             	mov    0x8(%ebp),%edx
  803291:	a1 64 d0 81 00       	mov    0x81d064,%eax
  803296:	29 c2                	sub    %eax,%edx
  803298:	89 d0                	mov    %edx,%eax
  80329a:	c1 e8 0c             	shr    $0xc,%eax
  80329d:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
  8032a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a3:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8032a7:	0f b7 c8             	movzwl %ax,%ecx
  8032aa:	b8 00 10 00 00       	mov    $0x1000,%eax
  8032af:	99                   	cltd   
  8032b0:	f7 7d e8             	idivl  -0x18(%ebp)
  8032b3:	39 c1                	cmp    %eax,%ecx
  8032b5:	0f 85 b8 01 00 00    	jne    803473 <free_block+0x384>
    	uint32 blocks_removed = 0;
  8032bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
  8032c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032c5:	c1 e0 04             	shl    $0x4,%eax
  8032c8:	05 80 d0 81 00       	add    $0x81d080,%eax
  8032cd:	8b 00                	mov    (%eax),%eax
  8032cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8032d2:	e9 d5 00 00 00       	jmp    8033ac <free_block+0x2bd>
		 tmp = LIST_NEXT(element);
  8032d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032da:	8b 00                	mov    (%eax),%eax
  8032dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
		 uint32 page_indexB = ((uint32)element - dynAllocStart) / PAGE_SIZE;
  8032df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032e2:	a1 64 d0 81 00       	mov    0x81d064,%eax
  8032e7:	29 c2                	sub    %eax,%edx
  8032e9:	89 d0                	mov    %edx,%eax
  8032eb:	c1 e8 0c             	shr    $0xc,%eax
  8032ee:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		 if (page_indexB == page_index){
  8032f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032f4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8032f7:	0f 85 a9 00 00 00    	jne    8033a6 <free_block+0x2b7>
				 LIST_REMOVE(&freeBlockLists[index], element);
  8032fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803301:	75 17                	jne    80331a <free_block+0x22b>
  803303:	83 ec 04             	sub    $0x4,%esp
  803306:	68 c5 44 80 00       	push   $0x8044c5
  80330b:	68 04 01 00 00       	push   $0x104
  803310:	68 2b 44 80 00       	push   $0x80442b
  803315:	e8 e6 d0 ff ff       	call   800400 <_panic>
  80331a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331d:	8b 00                	mov    (%eax),%eax
  80331f:	85 c0                	test   %eax,%eax
  803321:	74 10                	je     803333 <free_block+0x244>
  803323:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803326:	8b 00                	mov    (%eax),%eax
  803328:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80332b:	8b 52 04             	mov    0x4(%edx),%edx
  80332e:	89 50 04             	mov    %edx,0x4(%eax)
  803331:	eb 14                	jmp    803347 <free_block+0x258>
  803333:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803336:	8b 40 04             	mov    0x4(%eax),%eax
  803339:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80333c:	c1 e2 04             	shl    $0x4,%edx
  80333f:	81 c2 84 d0 81 00    	add    $0x81d084,%edx
  803345:	89 02                	mov    %eax,(%edx)
  803347:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334a:	8b 40 04             	mov    0x4(%eax),%eax
  80334d:	85 c0                	test   %eax,%eax
  80334f:	74 0f                	je     803360 <free_block+0x271>
  803351:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803354:	8b 40 04             	mov    0x4(%eax),%eax
  803357:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80335a:	8b 12                	mov    (%edx),%edx
  80335c:	89 10                	mov    %edx,(%eax)
  80335e:	eb 13                	jmp    803373 <free_block+0x284>
  803360:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803363:	8b 00                	mov    (%eax),%eax
  803365:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803368:	c1 e2 04             	shl    $0x4,%edx
  80336b:	81 c2 80 d0 81 00    	add    $0x81d080,%edx
  803371:	89 02                	mov    %eax,(%edx)
  803373:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803376:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80337c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803386:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803389:	c1 e0 04             	shl    $0x4,%eax
  80338c:	05 8c d0 81 00       	add    $0x81d08c,%eax
  803391:	8b 00                	mov    (%eax),%eax
  803393:	8d 50 ff             	lea    -0x1(%eax),%edx
  803396:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803399:	c1 e0 04             	shl    $0x4,%eax
  80339c:	05 8c d0 81 00       	add    $0x81d08c,%eax
  8033a1:	89 10                	mov    %edx,(%eax)
				 blocks_removed++;
  8033a3:	ff 45 f4             	incl   -0xc(%ebp)
			 }

		 	 element = tmp;
  8033a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(page_info_e->num_of_free_blocks == PAGE_SIZE / size){
    	uint32 blocks_removed = 0;
    	 struct BlockElement *element = LIST_FIRST(&freeBlockLists[index]);
    	 struct BlockElement *tmp;

    	 while(element != NULL){
  8033ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033b0:	0f 85 21 ff ff ff    	jne    8032d7 <free_block+0x1e8>
			 }

		 	 element = tmp;
    	 }

    	 if (blocks_removed != PAGE_SIZE / size) {
  8033b6:	b8 00 10 00 00       	mov    $0x1000,%eax
  8033bb:	99                   	cltd   
  8033bc:	f7 7d e8             	idivl  -0x18(%ebp)
  8033bf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8033c2:	74 17                	je     8033db <free_block+0x2ec>
			panic("free_block: mismatch in number of blocks removed");
  8033c4:	83 ec 04             	sub    $0x4,%esp
  8033c7:	68 14 46 80 00       	push   $0x804614
  8033cc:	68 0c 01 00 00       	push   $0x10c
  8033d1:	68 2b 44 80 00       	push   $0x80442b
  8033d6:	e8 25 d0 ff ff       	call   800400 <_panic>
		}

    	page_info_e->num_of_free_blocks = 0;
  8033db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033de:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
        page_info_e->block_size = 0;
  8033e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033e7:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        LIST_INSERT_TAIL(&freePagesList, page_info_e);
  8033ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033f1:	75 17                	jne    80340a <free_block+0x31b>
  8033f3:	83 ec 04             	sub    $0x4,%esp
  8033f6:	68 e4 44 80 00       	push   $0x8044e4
  8033fb:	68 11 01 00 00       	push   $0x111
  803400:	68 2b 44 80 00       	push   $0x80442b
  803405:	e8 f6 cf ff ff       	call   800400 <_panic>
  80340a:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  803410:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803413:	89 50 04             	mov    %edx,0x4(%eax)
  803416:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803419:	8b 40 04             	mov    0x4(%eax),%eax
  80341c:	85 c0                	test   %eax,%eax
  80341e:	74 0c                	je     80342c <free_block+0x33d>
  803420:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803425:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803428:	89 10                	mov    %edx,(%eax)
  80342a:	eb 08                	jmp    803434 <free_block+0x345>
  80342c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80342f:	a3 48 50 80 00       	mov    %eax,0x805048
  803434:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803437:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80343c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80343f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803445:	a1 54 50 80 00       	mov    0x805054,%eax
  80344a:	40                   	inc    %eax
  80344b:	a3 54 50 80 00       	mov    %eax,0x805054

        uint32 pp = to_page_va(page_info_e);
  803450:	83 ec 0c             	sub    $0xc,%esp
  803453:	ff 75 ec             	pushl  -0x14(%ebp)
  803456:	e8 2b f4 ff ff       	call   802886 <to_page_va>
  80345b:	83 c4 10             	add    $0x10,%esp
  80345e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        return_page((void*) pp);
  803461:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803464:	83 ec 0c             	sub    $0xc,%esp
  803467:	50                   	push   %eax
  803468:	e8 69 e8 ff ff       	call   801cd6 <return_page>
  80346d:	83 c4 10             	add    $0x10,%esp
  803470:	eb 01                	jmp    803473 <free_block+0x384>
			bits_cnt++;
		}
		return bits_cnt;
	}

	if(va==NULL) return;
  803472:	90                   	nop
        return_page((void*) pp);
    }

	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  803473:	c9                   	leave  
  803474:	c3                   	ret    

00803475 <nearest_pow2_ceil.1572>:

  // Get current block size
  uint32 current_size = get_block_size(va);

  // If new size fits in current block (same power of 2), return same pointer
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
  803475:	55                   	push   %ebp
  803476:	89 e5                	mov    %esp,%ebp
  803478:	83 ec 14             	sub    $0x14,%esp
  80347b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    if (x <= 1)
  80347e:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803482:	77 07                	ja     80348b <nearest_pow2_ceil.1572+0x16>
      return 1;
  803484:	b8 01 00 00 00       	mov    $0x1,%eax
  803489:	eb 20                	jmp    8034ab <nearest_pow2_ceil.1572+0x36>
    int power = 2;
  80348b:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
    x--;
  803492:	ff 4d 08             	decl   0x8(%ebp)
    while (x >>= 1)
  803495:	eb 08                	jmp    80349f <nearest_pow2_ceil.1572+0x2a>
      power <<= 1;
  803497:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80349a:	01 c0                	add    %eax,%eax
  80349c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  inline unsigned int nearest_pow2_ceil(unsigned int x) {
    if (x <= 1)
      return 1;
    int power = 2;
    x--;
    while (x >>= 1)
  80349f:	d1 6d 08             	shrl   0x8(%ebp)
  8034a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034a6:	75 ef                	jne    803497 <nearest_pow2_ceil.1572+0x22>
      power <<= 1;
    return power;
  8034a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  8034ab:	c9                   	leave  
  8034ac:	c3                   	ret    

008034ad <realloc_block>:
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void *va, uint32 new_size) {
  8034ad:	55                   	push   %ebp
  8034ae:	89 e5                	mov    %esp,%ebp
  8034b0:	83 ec 28             	sub    $0x28,%esp
  // TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
  // Your code is here

  // Handle special cases similar to standard realloc
  if (va == NULL) {
  8034b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034b7:	75 13                	jne    8034cc <realloc_block+0x1f>
    return alloc_block(new_size);
  8034b9:	83 ec 0c             	sub    $0xc,%esp
  8034bc:	ff 75 0c             	pushl  0xc(%ebp)
  8034bf:	e8 d1 f6 ff ff       	call   802b95 <alloc_block>
  8034c4:	83 c4 10             	add    $0x10,%esp
  8034c7:	e9 d9 00 00 00       	jmp    8035a5 <realloc_block+0xf8>
  }

  if (new_size == 0) {
  8034cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034d0:	75 18                	jne    8034ea <realloc_block+0x3d>
    free_block(va);
  8034d2:	83 ec 0c             	sub    $0xc,%esp
  8034d5:	ff 75 08             	pushl  0x8(%ebp)
  8034d8:	e8 12 fc ff ff       	call   8030ef <free_block>
  8034dd:	83 c4 10             	add    $0x10,%esp
    return NULL;
  8034e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8034e5:	e9 bb 00 00 00       	jmp    8035a5 <realloc_block+0xf8>
  }

  // Get current block size
  uint32 current_size = get_block_size(va);
  8034ea:	83 ec 0c             	sub    $0xc,%esp
  8034ed:	ff 75 08             	pushl  0x8(%ebp)
  8034f0:	e8 38 f6 ff ff       	call   802b2d <get_block_size>
  8034f5:	83 c4 10             	add    $0x10,%esp
  8034f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (x >>= 1)
      power <<= 1;
    return power;
  }

  uint32 min_block_size = 1 << LOG2_MIN_SIZE;
  8034fb:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  if (new_size < min_block_size)
  803502:	8b 45 0c             	mov    0xc(%ebp),%eax
  803505:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803508:	73 06                	jae    803510 <realloc_block+0x63>
    new_size = min_block_size;
  80350a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80350d:	89 45 0c             	mov    %eax,0xc(%ebp)

  uint32 new_block_size = nearest_pow2_ceil(new_size);
  803510:	83 ec 0c             	sub    $0xc,%esp
  803513:	8d 45 d8             	lea    -0x28(%ebp),%eax
  803516:	ff 75 0c             	pushl  0xc(%ebp)
  803519:	89 c1                	mov    %eax,%ecx
  80351b:	e8 55 ff ff ff       	call   803475 <nearest_pow2_ceil.1572>
  803520:	83 c4 10             	add    $0x10,%esp
  803523:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // If block size doesn't change, return same pointer
  if (new_block_size == current_size) {
  803526:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803529:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80352c:	75 05                	jne    803533 <realloc_block+0x86>
    return va;
  80352e:	8b 45 08             	mov    0x8(%ebp),%eax
  803531:	eb 72                	jmp    8035a5 <realloc_block+0xf8>
  }

  // Otherwise, allocate new block and copy data
  void *new_va = alloc_block(new_size);
  803533:	83 ec 0c             	sub    $0xc,%esp
  803536:	ff 75 0c             	pushl  0xc(%ebp)
  803539:	e8 57 f6 ff ff       	call   802b95 <alloc_block>
  80353e:	83 c4 10             	add    $0x10,%esp
  803541:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (new_va == NULL) {
  803544:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803548:	75 07                	jne    803551 <realloc_block+0xa4>
    return NULL;
  80354a:	b8 00 00 00 00       	mov    $0x0,%eax
  80354f:	eb 54                	jmp    8035a5 <realloc_block+0xf8>
  }

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  803551:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803554:	8b 45 0c             	mov    0xc(%ebp),%eax
  803557:	39 d0                	cmp    %edx,%eax
  803559:	76 02                	jbe    80355d <realloc_block+0xb0>
  80355b:	89 d0                	mov    %edx,%eax
  80355d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint8 *src = (uint8 *)va;
  803560:	8b 45 08             	mov    0x8(%ebp),%eax
  803563:	89 45 dc             	mov    %eax,-0x24(%ebp)
  uint8 *dst = (uint8 *)new_va;
  803566:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803569:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (uint32 i = 0; i < copy_size; i++) {
  80356c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803573:	eb 17                	jmp    80358c <realloc_block+0xdf>
    dst[i] = src[i];
  803575:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357b:	01 c2                	add    %eax,%edx
  80357d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  803580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803583:	01 c8                	add    %ecx,%eax
  803585:	8a 00                	mov    (%eax),%al
  803587:	88 02                	mov    %al,(%edx)

  // Copy data (copy minimum of old and new size)
  uint32 copy_size = (current_size < new_size) ? current_size : new_size;
  uint8 *src = (uint8 *)va;
  uint8 *dst = (uint8 *)new_va;
  for (uint32 i = 0; i < copy_size; i++) {
  803589:	ff 45 f4             	incl   -0xc(%ebp)
  80358c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803592:	72 e1                	jb     803575 <realloc_block+0xc8>
    dst[i] = src[i];
  }

  // Free old block
  free_block(va);
  803594:	83 ec 0c             	sub    $0xc,%esp
  803597:	ff 75 08             	pushl  0x8(%ebp)
  80359a:	e8 50 fb ff ff       	call   8030ef <free_block>
  80359f:	83 c4 10             	add    $0x10,%esp

  return new_va;
  8035a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8035a5:	c9                   	leave  
  8035a6:	c3                   	ret    
  8035a7:	90                   	nop

008035a8 <__udivdi3>:
  8035a8:	55                   	push   %ebp
  8035a9:	57                   	push   %edi
  8035aa:	56                   	push   %esi
  8035ab:	53                   	push   %ebx
  8035ac:	83 ec 1c             	sub    $0x1c,%esp
  8035af:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8035b3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8035b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035bb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8035bf:	89 ca                	mov    %ecx,%edx
  8035c1:	89 f8                	mov    %edi,%eax
  8035c3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8035c7:	85 f6                	test   %esi,%esi
  8035c9:	75 2d                	jne    8035f8 <__udivdi3+0x50>
  8035cb:	39 cf                	cmp    %ecx,%edi
  8035cd:	77 65                	ja     803634 <__udivdi3+0x8c>
  8035cf:	89 fd                	mov    %edi,%ebp
  8035d1:	85 ff                	test   %edi,%edi
  8035d3:	75 0b                	jne    8035e0 <__udivdi3+0x38>
  8035d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8035da:	31 d2                	xor    %edx,%edx
  8035dc:	f7 f7                	div    %edi
  8035de:	89 c5                	mov    %eax,%ebp
  8035e0:	31 d2                	xor    %edx,%edx
  8035e2:	89 c8                	mov    %ecx,%eax
  8035e4:	f7 f5                	div    %ebp
  8035e6:	89 c1                	mov    %eax,%ecx
  8035e8:	89 d8                	mov    %ebx,%eax
  8035ea:	f7 f5                	div    %ebp
  8035ec:	89 cf                	mov    %ecx,%edi
  8035ee:	89 fa                	mov    %edi,%edx
  8035f0:	83 c4 1c             	add    $0x1c,%esp
  8035f3:	5b                   	pop    %ebx
  8035f4:	5e                   	pop    %esi
  8035f5:	5f                   	pop    %edi
  8035f6:	5d                   	pop    %ebp
  8035f7:	c3                   	ret    
  8035f8:	39 ce                	cmp    %ecx,%esi
  8035fa:	77 28                	ja     803624 <__udivdi3+0x7c>
  8035fc:	0f bd fe             	bsr    %esi,%edi
  8035ff:	83 f7 1f             	xor    $0x1f,%edi
  803602:	75 40                	jne    803644 <__udivdi3+0x9c>
  803604:	39 ce                	cmp    %ecx,%esi
  803606:	72 0a                	jb     803612 <__udivdi3+0x6a>
  803608:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80360c:	0f 87 9e 00 00 00    	ja     8036b0 <__udivdi3+0x108>
  803612:	b8 01 00 00 00       	mov    $0x1,%eax
  803617:	89 fa                	mov    %edi,%edx
  803619:	83 c4 1c             	add    $0x1c,%esp
  80361c:	5b                   	pop    %ebx
  80361d:	5e                   	pop    %esi
  80361e:	5f                   	pop    %edi
  80361f:	5d                   	pop    %ebp
  803620:	c3                   	ret    
  803621:	8d 76 00             	lea    0x0(%esi),%esi
  803624:	31 ff                	xor    %edi,%edi
  803626:	31 c0                	xor    %eax,%eax
  803628:	89 fa                	mov    %edi,%edx
  80362a:	83 c4 1c             	add    $0x1c,%esp
  80362d:	5b                   	pop    %ebx
  80362e:	5e                   	pop    %esi
  80362f:	5f                   	pop    %edi
  803630:	5d                   	pop    %ebp
  803631:	c3                   	ret    
  803632:	66 90                	xchg   %ax,%ax
  803634:	89 d8                	mov    %ebx,%eax
  803636:	f7 f7                	div    %edi
  803638:	31 ff                	xor    %edi,%edi
  80363a:	89 fa                	mov    %edi,%edx
  80363c:	83 c4 1c             	add    $0x1c,%esp
  80363f:	5b                   	pop    %ebx
  803640:	5e                   	pop    %esi
  803641:	5f                   	pop    %edi
  803642:	5d                   	pop    %ebp
  803643:	c3                   	ret    
  803644:	bd 20 00 00 00       	mov    $0x20,%ebp
  803649:	89 eb                	mov    %ebp,%ebx
  80364b:	29 fb                	sub    %edi,%ebx
  80364d:	89 f9                	mov    %edi,%ecx
  80364f:	d3 e6                	shl    %cl,%esi
  803651:	89 c5                	mov    %eax,%ebp
  803653:	88 d9                	mov    %bl,%cl
  803655:	d3 ed                	shr    %cl,%ebp
  803657:	89 e9                	mov    %ebp,%ecx
  803659:	09 f1                	or     %esi,%ecx
  80365b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80365f:	89 f9                	mov    %edi,%ecx
  803661:	d3 e0                	shl    %cl,%eax
  803663:	89 c5                	mov    %eax,%ebp
  803665:	89 d6                	mov    %edx,%esi
  803667:	88 d9                	mov    %bl,%cl
  803669:	d3 ee                	shr    %cl,%esi
  80366b:	89 f9                	mov    %edi,%ecx
  80366d:	d3 e2                	shl    %cl,%edx
  80366f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803673:	88 d9                	mov    %bl,%cl
  803675:	d3 e8                	shr    %cl,%eax
  803677:	09 c2                	or     %eax,%edx
  803679:	89 d0                	mov    %edx,%eax
  80367b:	89 f2                	mov    %esi,%edx
  80367d:	f7 74 24 0c          	divl   0xc(%esp)
  803681:	89 d6                	mov    %edx,%esi
  803683:	89 c3                	mov    %eax,%ebx
  803685:	f7 e5                	mul    %ebp
  803687:	39 d6                	cmp    %edx,%esi
  803689:	72 19                	jb     8036a4 <__udivdi3+0xfc>
  80368b:	74 0b                	je     803698 <__udivdi3+0xf0>
  80368d:	89 d8                	mov    %ebx,%eax
  80368f:	31 ff                	xor    %edi,%edi
  803691:	e9 58 ff ff ff       	jmp    8035ee <__udivdi3+0x46>
  803696:	66 90                	xchg   %ax,%ax
  803698:	8b 54 24 08          	mov    0x8(%esp),%edx
  80369c:	89 f9                	mov    %edi,%ecx
  80369e:	d3 e2                	shl    %cl,%edx
  8036a0:	39 c2                	cmp    %eax,%edx
  8036a2:	73 e9                	jae    80368d <__udivdi3+0xe5>
  8036a4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8036a7:	31 ff                	xor    %edi,%edi
  8036a9:	e9 40 ff ff ff       	jmp    8035ee <__udivdi3+0x46>
  8036ae:	66 90                	xchg   %ax,%ax
  8036b0:	31 c0                	xor    %eax,%eax
  8036b2:	e9 37 ff ff ff       	jmp    8035ee <__udivdi3+0x46>
  8036b7:	90                   	nop

008036b8 <__umoddi3>:
  8036b8:	55                   	push   %ebp
  8036b9:	57                   	push   %edi
  8036ba:	56                   	push   %esi
  8036bb:	53                   	push   %ebx
  8036bc:	83 ec 1c             	sub    $0x1c,%esp
  8036bf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8036c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8036c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8036cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036d7:	89 f3                	mov    %esi,%ebx
  8036d9:	89 fa                	mov    %edi,%edx
  8036db:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036df:	89 34 24             	mov    %esi,(%esp)
  8036e2:	85 c0                	test   %eax,%eax
  8036e4:	75 1a                	jne    803700 <__umoddi3+0x48>
  8036e6:	39 f7                	cmp    %esi,%edi
  8036e8:	0f 86 a2 00 00 00    	jbe    803790 <__umoddi3+0xd8>
  8036ee:	89 c8                	mov    %ecx,%eax
  8036f0:	89 f2                	mov    %esi,%edx
  8036f2:	f7 f7                	div    %edi
  8036f4:	89 d0                	mov    %edx,%eax
  8036f6:	31 d2                	xor    %edx,%edx
  8036f8:	83 c4 1c             	add    $0x1c,%esp
  8036fb:	5b                   	pop    %ebx
  8036fc:	5e                   	pop    %esi
  8036fd:	5f                   	pop    %edi
  8036fe:	5d                   	pop    %ebp
  8036ff:	c3                   	ret    
  803700:	39 f0                	cmp    %esi,%eax
  803702:	0f 87 ac 00 00 00    	ja     8037b4 <__umoddi3+0xfc>
  803708:	0f bd e8             	bsr    %eax,%ebp
  80370b:	83 f5 1f             	xor    $0x1f,%ebp
  80370e:	0f 84 ac 00 00 00    	je     8037c0 <__umoddi3+0x108>
  803714:	bf 20 00 00 00       	mov    $0x20,%edi
  803719:	29 ef                	sub    %ebp,%edi
  80371b:	89 fe                	mov    %edi,%esi
  80371d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803721:	89 e9                	mov    %ebp,%ecx
  803723:	d3 e0                	shl    %cl,%eax
  803725:	89 d7                	mov    %edx,%edi
  803727:	89 f1                	mov    %esi,%ecx
  803729:	d3 ef                	shr    %cl,%edi
  80372b:	09 c7                	or     %eax,%edi
  80372d:	89 e9                	mov    %ebp,%ecx
  80372f:	d3 e2                	shl    %cl,%edx
  803731:	89 14 24             	mov    %edx,(%esp)
  803734:	89 d8                	mov    %ebx,%eax
  803736:	d3 e0                	shl    %cl,%eax
  803738:	89 c2                	mov    %eax,%edx
  80373a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80373e:	d3 e0                	shl    %cl,%eax
  803740:	89 44 24 04          	mov    %eax,0x4(%esp)
  803744:	8b 44 24 08          	mov    0x8(%esp),%eax
  803748:	89 f1                	mov    %esi,%ecx
  80374a:	d3 e8                	shr    %cl,%eax
  80374c:	09 d0                	or     %edx,%eax
  80374e:	d3 eb                	shr    %cl,%ebx
  803750:	89 da                	mov    %ebx,%edx
  803752:	f7 f7                	div    %edi
  803754:	89 d3                	mov    %edx,%ebx
  803756:	f7 24 24             	mull   (%esp)
  803759:	89 c6                	mov    %eax,%esi
  80375b:	89 d1                	mov    %edx,%ecx
  80375d:	39 d3                	cmp    %edx,%ebx
  80375f:	0f 82 87 00 00 00    	jb     8037ec <__umoddi3+0x134>
  803765:	0f 84 91 00 00 00    	je     8037fc <__umoddi3+0x144>
  80376b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80376f:	29 f2                	sub    %esi,%edx
  803771:	19 cb                	sbb    %ecx,%ebx
  803773:	89 d8                	mov    %ebx,%eax
  803775:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803779:	d3 e0                	shl    %cl,%eax
  80377b:	89 e9                	mov    %ebp,%ecx
  80377d:	d3 ea                	shr    %cl,%edx
  80377f:	09 d0                	or     %edx,%eax
  803781:	89 e9                	mov    %ebp,%ecx
  803783:	d3 eb                	shr    %cl,%ebx
  803785:	89 da                	mov    %ebx,%edx
  803787:	83 c4 1c             	add    $0x1c,%esp
  80378a:	5b                   	pop    %ebx
  80378b:	5e                   	pop    %esi
  80378c:	5f                   	pop    %edi
  80378d:	5d                   	pop    %ebp
  80378e:	c3                   	ret    
  80378f:	90                   	nop
  803790:	89 fd                	mov    %edi,%ebp
  803792:	85 ff                	test   %edi,%edi
  803794:	75 0b                	jne    8037a1 <__umoddi3+0xe9>
  803796:	b8 01 00 00 00       	mov    $0x1,%eax
  80379b:	31 d2                	xor    %edx,%edx
  80379d:	f7 f7                	div    %edi
  80379f:	89 c5                	mov    %eax,%ebp
  8037a1:	89 f0                	mov    %esi,%eax
  8037a3:	31 d2                	xor    %edx,%edx
  8037a5:	f7 f5                	div    %ebp
  8037a7:	89 c8                	mov    %ecx,%eax
  8037a9:	f7 f5                	div    %ebp
  8037ab:	89 d0                	mov    %edx,%eax
  8037ad:	e9 44 ff ff ff       	jmp    8036f6 <__umoddi3+0x3e>
  8037b2:	66 90                	xchg   %ax,%ax
  8037b4:	89 c8                	mov    %ecx,%eax
  8037b6:	89 f2                	mov    %esi,%edx
  8037b8:	83 c4 1c             	add    $0x1c,%esp
  8037bb:	5b                   	pop    %ebx
  8037bc:	5e                   	pop    %esi
  8037bd:	5f                   	pop    %edi
  8037be:	5d                   	pop    %ebp
  8037bf:	c3                   	ret    
  8037c0:	3b 04 24             	cmp    (%esp),%eax
  8037c3:	72 06                	jb     8037cb <__umoddi3+0x113>
  8037c5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8037c9:	77 0f                	ja     8037da <__umoddi3+0x122>
  8037cb:	89 f2                	mov    %esi,%edx
  8037cd:	29 f9                	sub    %edi,%ecx
  8037cf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8037d3:	89 14 24             	mov    %edx,(%esp)
  8037d6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037da:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037de:	8b 14 24             	mov    (%esp),%edx
  8037e1:	83 c4 1c             	add    $0x1c,%esp
  8037e4:	5b                   	pop    %ebx
  8037e5:	5e                   	pop    %esi
  8037e6:	5f                   	pop    %edi
  8037e7:	5d                   	pop    %ebp
  8037e8:	c3                   	ret    
  8037e9:	8d 76 00             	lea    0x0(%esi),%esi
  8037ec:	2b 04 24             	sub    (%esp),%eax
  8037ef:	19 fa                	sbb    %edi,%edx
  8037f1:	89 d1                	mov    %edx,%ecx
  8037f3:	89 c6                	mov    %eax,%esi
  8037f5:	e9 71 ff ff ff       	jmp    80376b <__umoddi3+0xb3>
  8037fa:	66 90                	xchg   %ax,%ax
  8037fc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803800:	72 ea                	jb     8037ec <__umoddi3+0x134>
  803802:	89 d9                	mov    %ebx,%ecx
  803804:	e9 62 ff ff ff       	jmp    80376b <__umoddi3+0xb3>
