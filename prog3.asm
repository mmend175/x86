
_prog3:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
struct lock_t *lock;

extern struct lock_t *lock;

int main (int argc , char * argv [])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 18             	sub    $0x18,%esp
  13:	8b 59 04             	mov    0x4(%ecx),%ebx
        numofthread =atoi(argv[1]);// num of threads is decided by the parameter passed by user
  16:	ff 73 04             	pushl  0x4(%ebx)
  19:	e8 b2 04 00 00       	call   4d0 <atoi>
  1e:	a3 68 0e 00 00       	mov    %eax,0xe68
        passnum = atoi(argv[2]);
  23:	58                   	pop    %eax
  24:	ff 73 08             	pushl  0x8(%ebx)
  27:	e8 a4 04 00 00       	call   4d0 <atoi>
  2c:	a3 64 0e 00 00       	mov    %eax,0xe64
        printf(1,"PARENT PID:%d\n",getpid());
  31:	e8 8c 05 00 00       	call   5c2 <getpid>
  36:	83 c4 0c             	add    $0xc,%esp
  39:	50                   	push   %eax
  3a:	68 1a 0a 00 00       	push   $0xa1a
  3f:	6a 01                	push   $0x1
  41:	e8 5a 06 00 00       	call   6a0 <printf>
        int i = 0 ;
        int pid = 0;
        lock_init(lock);
  46:	a1 7c 0e 00 00       	mov    0xe7c,%eax
        for(i=0;i<numofthread;i++)
  4b:	83 c4 10             	add    $0x10,%esp
};

//this part is for spin lock
void lock_init(struct lock_t *lk)
{
        lk -> locked = 0;//initial situation is unlocked
  4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  54:	a1 68 0e 00 00       	mov    0xe68,%eax
  59:	85 c0                	test   %eax,%eax
  5b:	0f 8e b1 00 00 00    	jle    112 <main+0x112>
  61:	31 db                	xor    %ebx,%ebx
  63:	90                   	nop
  64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        {
            printf(1,"loop start count:%d with main pid: %d\n\n",i,getpid());
  68:	e8 55 05 00 00       	call   5c2 <getpid>
  6d:	50                   	push   %eax
  6e:	53                   	push   %ebx
  6f:	68 a8 0a 00 00       	push   $0xaa8
  74:	6a 01                	push   $0x1
  76:	e8 25 06 00 00       	call   6a0 <printf>
            pid = thread_create(worker,(void *)i);
  7b:	5e                   	pop    %esi
  7c:	58                   	pop    %eax
  7d:	53                   	push   %ebx
  7e:	68 30 01 00 00       	push   $0x130
  83:	e8 e8 01 00 00       	call   270 <thread_create>
  88:	89 c6                	mov    %eax,%esi
            printf(1,"out of count:%d, with main pid: %d\n",i,getpid());
  8a:	e8 33 05 00 00       	call   5c2 <getpid>
  8f:	50                   	push   %eax
  90:	53                   	push   %ebx
        passnum = atoi(argv[2]);
        printf(1,"PARENT PID:%d\n",getpid());
        int i = 0 ;
        int pid = 0;
        lock_init(lock);
        for(i=0;i<numofthread;i++)
  91:	83 c3 01             	add    $0x1,%ebx
        {
            printf(1,"loop start count:%d with main pid: %d\n\n",i,getpid());
            pid = thread_create(worker,(void *)i);
            printf(1,"out of count:%d, with main pid: %d\n",i,getpid());
  94:	68 d0 0a 00 00       	push   $0xad0
  99:	6a 01                	push   $0x1
  9b:	e8 00 06 00 00       	call   6a0 <printf>
        passnum = atoi(argv[2]);
        printf(1,"PARENT PID:%d\n",getpid());
        int i = 0 ;
        int pid = 0;
        lock_init(lock);
        for(i=0;i<numofthread;i++)
  a0:	83 c4 20             	add    $0x20,%esp
  a3:	39 1d 68 0e 00 00    	cmp    %ebx,0xe68
  a9:	7f bd                	jg     68 <main+0x68>
        {
            printf(1,"loop start count:%d with main pid: %d\n\n",i,getpid());
            pid = thread_create(worker,(void *)i);
            printf(1,"out of count:%d, with main pid: %d\n",i,getpid());
        }
        if(pid >0)
  ab:	83 fe 00             	cmp    $0x0,%esi
  ae:	7e 60                	jle    110 <main+0x110>
                printf(1,"parent's pid num is %d\n",getpid());
  b0:	e8 0d 05 00 00       	call   5c2 <getpid>
  b5:	83 ec 04             	sub    $0x4,%esp
        if(pid ==0)
                printf(1,"child's pid num is %d\n",getpid());

        if (pid > 0) // pid > 0 -> parent
        {
            for (i = 0; i <numofthread; i++)
  b8:	31 db                	xor    %ebx,%ebx
            printf(1,"loop start count:%d with main pid: %d\n\n",i,getpid());
            pid = thread_create(worker,(void *)i);
            printf(1,"out of count:%d, with main pid: %d\n",i,getpid());
        }
        if(pid >0)
                printf(1,"parent's pid num is %d\n",getpid());
  ba:	50                   	push   %eax
  bb:	68 29 0a 00 00       	push   $0xa29
  c0:	6a 01                	push   $0x1
  c2:	e8 d9 05 00 00       	call   6a0 <printf>
        if(pid ==0)
                printf(1,"child's pid num is %d\n",getpid());

        if (pid > 0) // pid > 0 -> parent
        {
            for (i = 0; i <numofthread; i++)
  c7:	8b 0d 68 0e 00 00    	mov    0xe68,%ecx
  cd:	83 c4 10             	add    $0x10,%esp
  d0:	85 c9                	test   %ecx,%ecx
  d2:	7e 27                	jle    fb <main+0xfb>
  d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            {
                wait(); //wait each time for each thread created for parent
  d8:	e8 6d 04 00 00       	call   54a <wait>
                printf(1,"end of wait!!PID:%d\n",pid);
  dd:	83 ec 04             	sub    $0x4,%esp
        if(pid ==0)
                printf(1,"child's pid num is %d\n",getpid());

        if (pid > 0) // pid > 0 -> parent
        {
            for (i = 0; i <numofthread; i++)
  e0:	83 c3 01             	add    $0x1,%ebx
            {
                wait(); //wait each time for each thread created for parent
                printf(1,"end of wait!!PID:%d\n",pid);
  e3:	56                   	push   %esi
  e4:	68 41 0a 00 00       	push   $0xa41
  e9:	6a 01                	push   $0x1
  eb:	e8 b0 05 00 00       	call   6a0 <printf>
        if(pid ==0)
                printf(1,"child's pid num is %d\n",getpid());

        if (pid > 0) // pid > 0 -> parent
        {
            for (i = 0; i <numofthread; i++)
  f0:	83 c4 10             	add    $0x10,%esp
  f3:	39 1d 68 0e 00 00    	cmp    %ebx,0xe68
  f9:	7f dd                	jg     d8 <main+0xd8>
                wait(); //wait each time for each thread created for parent
                printf(1,"end of wait!!PID:%d\n",pid);
            }
        }

        printf(1,"end of program!!!PID:%d\n",pid);
  fb:	83 ec 04             	sub    $0x4,%esp
  fe:	56                   	push   %esi
  ff:	68 56 0a 00 00       	push   $0xa56
 104:	6a 01                	push   $0x1
 106:	e8 95 05 00 00       	call   6a0 <printf>
        exit();
 10b:	e8 32 04 00 00       	call   542 <exit>
            pid = thread_create(worker,(void *)i);
            printf(1,"out of count:%d, with main pid: %d\n",i,getpid());
        }
        if(pid >0)
                printf(1,"parent's pid num is %d\n",getpid());
        if(pid ==0)
 110:	75 e9                	jne    fb <main+0xfb>
                printf(1,"child's pid num is %d\n",getpid());
 112:	e8 ab 04 00 00       	call   5c2 <getpid>
 117:	52                   	push   %edx
 118:	50                   	push   %eax
 119:	31 f6                	xor    %esi,%esi
 11b:	68 c0 09 00 00       	push   $0x9c0
 120:	6a 01                	push   $0x1
 122:	e8 79 05 00 00       	call   6a0 <printf>
 127:	83 c4 10             	add    $0x10,%esp
 12a:	eb cf                	jmp    fb <main+0xfb>
 12c:	66 90                	xchg   %ax,%ax
 12e:	66 90                	xchg   %ax,%ax

00000130 <worker>:
 * if the thread get the lock does not the thread should work
 * it will sleep and release the lock
 * */

void* worker(void *arg)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	56                   	push   %esi
 134:	53                   	push   %ebx
 135:	8b 5d 08             	mov    0x8(%ebp),%ebx
        int pidnum = (int)arg; // pidnum = thread num
        printf(1,"child's pid num is %d\n",pidnum);
 138:	83 ec 04             	sub    $0x4,%esp
 13b:	53                   	push   %ebx
 13c:	68 c0 09 00 00       	push   $0x9c0
 141:	6a 01                	push   $0x1
 143:	e8 58 05 00 00       	call   6a0 <printf>

        while(output<passnum)//when pass time  bigger than it should be passed
 148:	83 c4 10             	add    $0x10,%esp
 14b:	a1 6c 0e 00 00       	mov    0xe6c,%eax
 150:	39 05 64 0e 00 00    	cmp    %eax,0xe64
 156:	7e 4e                	jle    1a6 <worker+0x76>
 158:	be 01 00 00 00       	mov    $0x1,%esi
 15d:	8d 76 00             	lea    0x0(%esi),%esi
 160:	8b 15 7c 0e 00 00    	mov    0xe7c,%edx
 166:	8d 76 00             	lea    0x0(%esi),%esi
 169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 170:	89 f0                	mov    %esi,%eax
 172:	f0 87 02             	lock xchg %eax,(%edx)
}
void lock_acquire(struct lock_t *lk)
{
        while(xchg(&lk->locked,1) != 0);
 175:	85 c0                	test   %eax,%eax
 177:	75 f7                	jne    170 <worker+0x40>
        {
                if(output==passnum) //stop we are done
                        break;
                lock_acquire(lock);
                if(pidnum==workpid) //workpid == current thread that should get the number the fribee toss to it. I.E if current thread 1 -> workpid(thread 2.)
 179:	3b 1d 60 0e 00 00    	cmp    0xe60,%ebx
 17f:	74 3f                	je     1c0 <worker+0x90>
                        sleep(1);

                }
                else
                {                    
                    sleep(1); //sleep the other thread that should not be working
 181:	83 ec 0c             	sub    $0xc,%esp
 184:	6a 01                	push   $0x1
 186:	e8 47 04 00 00       	call   5d2 <sleep>
 18b:	83 c4 10             	add    $0x10,%esp
}
void lock_release(struct lock_t *lock)
{
        xchg(&lock->locked,0);
 18e:	8b 15 7c 0e 00 00    	mov    0xe7c,%edx
 194:	31 c0                	xor    %eax,%eax
 196:	f0 87 02             	lock xchg %eax,(%edx)
void* worker(void *arg)
{
        int pidnum = (int)arg; // pidnum = thread num
        printf(1,"child's pid num is %d\n",pidnum);

        while(output<passnum)//when pass time  bigger than it should be passed
 199:	a1 64 0e 00 00       	mov    0xe64,%eax
 19e:	39 05 6c 0e 00 00    	cmp    %eax,0xe6c
 1a4:	7c ba                	jl     160 <worker+0x30>
                }
                lock_release(lock);

        }

        printf(1,"time to end: %d\n",pidnum);
 1a6:	83 ec 04             	sub    $0x4,%esp
 1a9:	53                   	push   %ebx
 1aa:	68 d7 09 00 00       	push   $0x9d7
 1af:	6a 01                	push   $0x1
 1b1:	e8 ea 04 00 00       	call   6a0 <printf>
        return 0;
}
 1b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1b9:	31 c0                	xor    %eax,%eax
 1bb:	5b                   	pop    %ebx
 1bc:	5e                   	pop    %esi
 1bd:	5d                   	pop    %ebp
 1be:	c3                   	ret    
 1bf:	90                   	nop
                if(output==passnum) //stop we are done
                        break;
                lock_acquire(lock);
                if(pidnum==workpid) //workpid == current thread that should get the number the fribee toss to it. I.E if current thread 1 -> workpid(thread 2.)
                {
                        output++; //used to count the number of passes currently
 1c0:	a1 6c 0e 00 00       	mov    0xe6c,%eax
                        printf(1,"pass number no: %d, Thread %d is passing the token to ",output,pidnum);
 1c5:	53                   	push   %ebx
                if(output==passnum) //stop we are done
                        break;
                lock_acquire(lock);
                if(pidnum==workpid) //workpid == current thread that should get the number the fribee toss to it. I.E if current thread 1 -> workpid(thread 2.)
                {
                        output++; //used to count the number of passes currently
 1c6:	83 c0 01             	add    $0x1,%eax
                        printf(1,"pass number no: %d, Thread %d is passing the token to ",output,pidnum);
 1c9:	50                   	push   %eax
 1ca:	68 70 0a 00 00       	push   $0xa70
 1cf:	6a 01                	push   $0x1
                if(output==passnum) //stop we are done
                        break;
                lock_acquire(lock);
                if(pidnum==workpid) //workpid == current thread that should get the number the fribee toss to it. I.E if current thread 1 -> workpid(thread 2.)
                {
                        output++; //used to count the number of passes currently
 1d1:	a3 6c 0e 00 00       	mov    %eax,0xe6c
                        printf(1,"pass number no: %d, Thread %d is passing the token to ",output,pidnum);
 1d6:	e8 c5 04 00 00       	call   6a0 <printf>
                        workpid++;
 1db:	a1 60 0e 00 00       	mov    0xe60,%eax
                        if(workpid == numofthread)// because thread num is start from 0
 1e0:	83 c4 10             	add    $0x10,%esp
                lock_acquire(lock);
                if(pidnum==workpid) //workpid == current thread that should get the number the fribee toss to it. I.E if current thread 1 -> workpid(thread 2.)
                {
                        output++; //used to count the number of passes currently
                        printf(1,"pass number no: %d, Thread %d is passing the token to ",output,pidnum);
                        workpid++;
 1e3:	83 c0 01             	add    $0x1,%eax
                        if(workpid == numofthread)// because thread num is start from 0
 1e6:	3b 05 68 0e 00 00    	cmp    0xe68,%eax
                lock_acquire(lock);
                if(pidnum==workpid) //workpid == current thread that should get the number the fribee toss to it. I.E if current thread 1 -> workpid(thread 2.)
                {
                        output++; //used to count the number of passes currently
                        printf(1,"pass number no: %d, Thread %d is passing the token to ",output,pidnum);
                        workpid++;
 1ec:	a3 60 0e 00 00       	mov    %eax,0xe60
                        if(workpid == numofthread)// because thread num is start from 0
 1f1:	74 24                	je     217 <worker+0xe7>
                                workpid = 0 ;
                        printf(1," %d\n",workpid);                       
 1f3:	83 ec 04             	sub    $0x4,%esp
 1f6:	50                   	push   %eax
 1f7:	68 e3 09 00 00       	push   $0x9e3
 1fc:	6a 01                	push   $0x1
 1fe:	e8 9d 04 00 00       	call   6a0 <printf>
                        sleep(1);
 203:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 20a:	e8 c3 03 00 00       	call   5d2 <sleep>
 20f:	83 c4 10             	add    $0x10,%esp
 212:	e9 77 ff ff ff       	jmp    18e <worker+0x5e>
                {
                        output++; //used to count the number of passes currently
                        printf(1,"pass number no: %d, Thread %d is passing the token to ",output,pidnum);
                        workpid++;
                        if(workpid == numofthread)// because thread num is start from 0
                                workpid = 0 ;
 217:	c7 05 60 0e 00 00 00 	movl   $0x0,0xe60
 21e:	00 00 00 
 221:	31 c0                	xor    %eax,%eax
 223:	eb ce                	jmp    1f3 <worker+0xc3>
 225:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000230 <lock_init>:
	uint locked;
};

//this part is for spin lock
void lock_init(struct lock_t *lk)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
        lk -> locked = 0;//initial situation is unlocked
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 23c:	5d                   	pop    %ebp
 23d:	c3                   	ret    
 23e:	66 90                	xchg   %ax,%ax

00000240 <lock_acquire>:
void lock_acquire(struct lock_t *lk)
{
 240:	55                   	push   %ebp
 241:	b9 01 00 00 00       	mov    $0x1,%ecx
 246:	89 e5                	mov    %esp,%ebp
 248:	8b 55 08             	mov    0x8(%ebp),%edx
 24b:	90                   	nop
 24c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 250:	89 c8                	mov    %ecx,%eax
 252:	f0 87 02             	lock xchg %eax,(%edx)
        while(xchg(&lk->locked,1) != 0);
 255:	85 c0                	test   %eax,%eax
 257:	75 f7                	jne    250 <lock_acquire+0x10>
}
 259:	5d                   	pop    %ebp
 25a:	c3                   	ret    
 25b:	90                   	nop
 25c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000260 <lock_release>:
void lock_release(struct lock_t *lock)
{
 260:	55                   	push   %ebp
 261:	31 c0                	xor    %eax,%eax
 263:	89 e5                	mov    %esp,%ebp
 265:	8b 55 08             	mov    0x8(%ebp),%edx
 268:	f0 87 02             	lock xchg %eax,(%edx)
        xchg(&lock->locked,0);
}
 26b:	5d                   	pop    %ebp
 26c:	c3                   	ret    
 26d:	8d 76 00             	lea    0x0(%esi),%esi

00000270 <thread_create>:

int thread_create(void*(*start_routine)(void*), void *arg)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	53                   	push   %ebx
 274:	83 ec 10             	sub    $0x10,%esp
        void* newp = malloc(2*PGSIZE); //need twice as much to make sure
 277:	68 00 20 00 00       	push   $0x2000
 27c:	e8 4f 06 00 00       	call   8d0 <malloc>
 281:	89 c3                	mov    %eax,%ebx
        int rc;
        printf(1,"%s :%d\n",__func__, getpid());
 283:	e8 3a 03 00 00       	call   5c2 <getpid>
 288:	50                   	push   %eax
 289:	68 f4 0a 00 00       	push   $0xaf4
 28e:	68 e8 09 00 00       	push   $0x9e8
 293:	6a 01                	push   $0x1
 295:	e8 06 04 00 00       	call   6a0 <printf>
        rc = clone(newp,2*PGSIZE);
 29a:	83 c4 18             	add    $0x18,%esp
 29d:	68 00 20 00 00       	push   $0x2000
 2a2:	53                   	push   %ebx
 2a3:	e8 4a 03 00 00       	call   5f2 <clone>
        //clone returns the PID of the child to the parent,
        // and 0 to the newly-created child thread
        printf(1,"%s,returns PID :%d\n",__func__,rc);
 2a8:	50                   	push   %eax
 2a9:	68 f4 0a 00 00       	push   $0xaf4
int thread_create(void*(*start_routine)(void*), void *arg)
{
        void* newp = malloc(2*PGSIZE); //need twice as much to make sure
        int rc;
        printf(1,"%s :%d\n",__func__, getpid());
        rc = clone(newp,2*PGSIZE);
 2ae:	89 c3                	mov    %eax,%ebx
        //clone returns the PID of the child to the parent,
        // and 0 to the newly-created child thread
        printf(1,"%s,returns PID :%d\n",__func__,rc);
 2b0:	68 f0 09 00 00       	push   $0x9f0
 2b5:	6a 01                	push   $0x1
 2b7:	e8 e4 03 00 00       	call   6a0 <printf>
        if (rc == 0) //child
 2bc:	83 c4 20             	add    $0x20,%esp
 2bf:	83 fb 00             	cmp    $0x0,%ebx
 2c2:	74 22                	je     2e6 <thread_create+0x76>
        {
            (*start_routine)(arg);
            exit(); //terminate thread
        }
        else if(rc > 0) //parent
 2c4:	7e 07                	jle    2cd <thread_create+0x5d>
 2c6:	89 d8                	mov    %ebx,%eax
        else
            {
                printf(2, "  OPPS...\n  Error  \n ");
                return -1;
            }
}
 2c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2cb:	c9                   	leave  
 2cc:	c3                   	ret    
        }
        else if(rc > 0) //parent
            return rc;
        else
            {
                printf(2, "  OPPS...\n  Error  \n ");
 2cd:	83 ec 08             	sub    $0x8,%esp
 2d0:	68 04 0a 00 00       	push   $0xa04
 2d5:	6a 02                	push   $0x2
 2d7:	e8 c4 03 00 00       	call   6a0 <printf>
                return -1;
 2dc:	83 c4 10             	add    $0x10,%esp
 2df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2e4:	eb e2                	jmp    2c8 <thread_create+0x58>
        //clone returns the PID of the child to the parent,
        // and 0 to the newly-created child thread
        printf(1,"%s,returns PID :%d\n",__func__,rc);
        if (rc == 0) //child
        {
            (*start_routine)(arg);
 2e6:	83 ec 0c             	sub    $0xc,%esp
 2e9:	ff 75 0c             	pushl  0xc(%ebp)
 2ec:	ff 55 08             	call   *0x8(%ebp)
            exit(); //terminate thread
 2ef:	e8 4e 02 00 00       	call   542 <exit>
 2f4:	66 90                	xchg   %ax,%ax
 2f6:	66 90                	xchg   %ax,%ax
 2f8:	66 90                	xchg   %ax,%ax
 2fa:	66 90                	xchg   %ax,%ax
 2fc:	66 90                	xchg   %ax,%ax
 2fe:	66 90                	xchg   %ax,%ax

00000300 <strcpy>:
//}


char*
strcpy(char *s, const char *t)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	53                   	push   %ebx
 304:	8b 45 08             	mov    0x8(%ebp),%eax
 307:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 30a:	89 c2                	mov    %eax,%edx
 30c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 310:	83 c1 01             	add    $0x1,%ecx
 313:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 317:	83 c2 01             	add    $0x1,%edx
 31a:	84 db                	test   %bl,%bl
 31c:	88 5a ff             	mov    %bl,-0x1(%edx)
 31f:	75 ef                	jne    310 <strcpy+0x10>
    ;
  return os;
}
 321:	5b                   	pop    %ebx
 322:	5d                   	pop    %ebp
 323:	c3                   	ret    
 324:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 32a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000330 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	56                   	push   %esi
 334:	53                   	push   %ebx
 335:	8b 55 08             	mov    0x8(%ebp),%edx
 338:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 33b:	0f b6 02             	movzbl (%edx),%eax
 33e:	0f b6 19             	movzbl (%ecx),%ebx
 341:	84 c0                	test   %al,%al
 343:	75 1e                	jne    363 <strcmp+0x33>
 345:	eb 29                	jmp    370 <strcmp+0x40>
 347:	89 f6                	mov    %esi,%esi
 349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 350:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 353:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 356:	8d 71 01             	lea    0x1(%ecx),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 359:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 35d:	84 c0                	test   %al,%al
 35f:	74 0f                	je     370 <strcmp+0x40>
 361:	89 f1                	mov    %esi,%ecx
 363:	38 d8                	cmp    %bl,%al
 365:	74 e9                	je     350 <strcmp+0x20>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 367:	29 d8                	sub    %ebx,%eax
}
 369:	5b                   	pop    %ebx
 36a:	5e                   	pop    %esi
 36b:	5d                   	pop    %ebp
 36c:	c3                   	ret    
 36d:	8d 76 00             	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 370:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 372:	29 d8                	sub    %ebx,%eax
}
 374:	5b                   	pop    %ebx
 375:	5e                   	pop    %esi
 376:	5d                   	pop    %ebp
 377:	c3                   	ret    
 378:	90                   	nop
 379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000380 <strlen>:

uint
strlen(const char *s)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 386:	80 39 00             	cmpb   $0x0,(%ecx)
 389:	74 12                	je     39d <strlen+0x1d>
 38b:	31 d2                	xor    %edx,%edx
 38d:	8d 76 00             	lea    0x0(%esi),%esi
 390:	83 c2 01             	add    $0x1,%edx
 393:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 397:	89 d0                	mov    %edx,%eax
 399:	75 f5                	jne    390 <strlen+0x10>
    ;
  return n;
}
 39b:	5d                   	pop    %ebp
 39c:	c3                   	ret    
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 39d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 39f:	5d                   	pop    %ebp
 3a0:	c3                   	ret    
 3a1:	eb 0d                	jmp    3b0 <memset>
 3a3:	90                   	nop
 3a4:	90                   	nop
 3a5:	90                   	nop
 3a6:	90                   	nop
 3a7:	90                   	nop
 3a8:	90                   	nop
 3a9:	90                   	nop
 3aa:	90                   	nop
 3ab:	90                   	nop
 3ac:	90                   	nop
 3ad:	90                   	nop
 3ae:	90                   	nop
 3af:	90                   	nop

000003b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 3b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bd:	89 d7                	mov    %edx,%edi
 3bf:	fc                   	cld    
 3c0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3c2:	89 d0                	mov    %edx,%eax
 3c4:	5f                   	pop    %edi
 3c5:	5d                   	pop    %ebp
 3c6:	c3                   	ret    
 3c7:	89 f6                	mov    %esi,%esi
 3c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003d0 <strchr>:

char*
strchr(const char *s, char c)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	53                   	push   %ebx
 3d4:	8b 45 08             	mov    0x8(%ebp),%eax
 3d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 3da:	0f b6 10             	movzbl (%eax),%edx
 3dd:	84 d2                	test   %dl,%dl
 3df:	74 1d                	je     3fe <strchr+0x2e>
    if(*s == c)
 3e1:	38 d3                	cmp    %dl,%bl
 3e3:	89 d9                	mov    %ebx,%ecx
 3e5:	75 0d                	jne    3f4 <strchr+0x24>
 3e7:	eb 17                	jmp    400 <strchr+0x30>
 3e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3f0:	38 ca                	cmp    %cl,%dl
 3f2:	74 0c                	je     400 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 3f4:	83 c0 01             	add    $0x1,%eax
 3f7:	0f b6 10             	movzbl (%eax),%edx
 3fa:	84 d2                	test   %dl,%dl
 3fc:	75 f2                	jne    3f0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 3fe:	31 c0                	xor    %eax,%eax
}
 400:	5b                   	pop    %ebx
 401:	5d                   	pop    %ebp
 402:	c3                   	ret    
 403:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000410 <gets>:

char*
gets(char *buf, int max)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	57                   	push   %edi
 414:	56                   	push   %esi
 415:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 416:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 418:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 41b:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 41e:	eb 29                	jmp    449 <gets+0x39>
    cc = read(0, &c, 1);
 420:	83 ec 04             	sub    $0x4,%esp
 423:	6a 01                	push   $0x1
 425:	57                   	push   %edi
 426:	6a 00                	push   $0x0
 428:	e8 2d 01 00 00       	call   55a <read>
    if(cc < 1)
 42d:	83 c4 10             	add    $0x10,%esp
 430:	85 c0                	test   %eax,%eax
 432:	7e 1d                	jle    451 <gets+0x41>
      break;
    buf[i++] = c;
 434:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 438:	8b 55 08             	mov    0x8(%ebp),%edx
 43b:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 43d:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 43f:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 443:	74 1b                	je     460 <gets+0x50>
 445:	3c 0d                	cmp    $0xd,%al
 447:	74 17                	je     460 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 449:	8d 5e 01             	lea    0x1(%esi),%ebx
 44c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 44f:	7c cf                	jl     420 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 451:	8b 45 08             	mov    0x8(%ebp),%eax
 454:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 458:	8d 65 f4             	lea    -0xc(%ebp),%esp
 45b:	5b                   	pop    %ebx
 45c:	5e                   	pop    %esi
 45d:	5f                   	pop    %edi
 45e:	5d                   	pop    %ebp
 45f:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 460:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 463:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 465:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 469:	8d 65 f4             	lea    -0xc(%ebp),%esp
 46c:	5b                   	pop    %ebx
 46d:	5e                   	pop    %esi
 46e:	5f                   	pop    %edi
 46f:	5d                   	pop    %ebp
 470:	c3                   	ret    
 471:	eb 0d                	jmp    480 <stat>
 473:	90                   	nop
 474:	90                   	nop
 475:	90                   	nop
 476:	90                   	nop
 477:	90                   	nop
 478:	90                   	nop
 479:	90                   	nop
 47a:	90                   	nop
 47b:	90                   	nop
 47c:	90                   	nop
 47d:	90                   	nop
 47e:	90                   	nop
 47f:	90                   	nop

00000480 <stat>:

int
stat(const char *n, struct stat *st)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	56                   	push   %esi
 484:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 485:	83 ec 08             	sub    $0x8,%esp
 488:	6a 00                	push   $0x0
 48a:	ff 75 08             	pushl  0x8(%ebp)
 48d:	e8 f0 00 00 00       	call   582 <open>
  if(fd < 0)
 492:	83 c4 10             	add    $0x10,%esp
 495:	85 c0                	test   %eax,%eax
 497:	78 27                	js     4c0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 499:	83 ec 08             	sub    $0x8,%esp
 49c:	ff 75 0c             	pushl  0xc(%ebp)
 49f:	89 c3                	mov    %eax,%ebx
 4a1:	50                   	push   %eax
 4a2:	e8 f3 00 00 00       	call   59a <fstat>
 4a7:	89 c6                	mov    %eax,%esi
  close(fd);
 4a9:	89 1c 24             	mov    %ebx,(%esp)
 4ac:	e8 b9 00 00 00       	call   56a <close>
  return r;
 4b1:	83 c4 10             	add    $0x10,%esp
 4b4:	89 f0                	mov    %esi,%eax
}
 4b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4b9:	5b                   	pop    %ebx
 4ba:	5e                   	pop    %esi
 4bb:	5d                   	pop    %ebp
 4bc:	c3                   	ret    
 4bd:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 4c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4c5:	eb ef                	jmp    4b6 <stat+0x36>
 4c7:	89 f6                	mov    %esi,%esi
 4c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004d0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	53                   	push   %ebx
 4d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4d7:	0f be 11             	movsbl (%ecx),%edx
 4da:	8d 42 d0             	lea    -0x30(%edx),%eax
 4dd:	3c 09                	cmp    $0x9,%al
 4df:	b8 00 00 00 00       	mov    $0x0,%eax
 4e4:	77 1f                	ja     505 <atoi+0x35>
 4e6:	8d 76 00             	lea    0x0(%esi),%esi
 4e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 4f0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 4f3:	83 c1 01             	add    $0x1,%ecx
 4f6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4fa:	0f be 11             	movsbl (%ecx),%edx
 4fd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 500:	80 fb 09             	cmp    $0x9,%bl
 503:	76 eb                	jbe    4f0 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 505:	5b                   	pop    %ebx
 506:	5d                   	pop    %ebp
 507:	c3                   	ret    
 508:	90                   	nop
 509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000510 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	56                   	push   %esi
 514:	53                   	push   %ebx
 515:	8b 5d 10             	mov    0x10(%ebp),%ebx
 518:	8b 45 08             	mov    0x8(%ebp),%eax
 51b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 51e:	85 db                	test   %ebx,%ebx
 520:	7e 14                	jle    536 <memmove+0x26>
 522:	31 d2                	xor    %edx,%edx
 524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 528:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 52c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 52f:	83 c2 01             	add    $0x1,%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 532:	39 da                	cmp    %ebx,%edx
 534:	75 f2                	jne    528 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 536:	5b                   	pop    %ebx
 537:	5e                   	pop    %esi
 538:	5d                   	pop    %ebp
 539:	c3                   	ret    

0000053a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 53a:	b8 01 00 00 00       	mov    $0x1,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <exit>:
SYSCALL(exit)
 542:	b8 02 00 00 00       	mov    $0x2,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <wait>:
SYSCALL(wait)
 54a:	b8 03 00 00 00       	mov    $0x3,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <pipe>:
SYSCALL(pipe)
 552:	b8 04 00 00 00       	mov    $0x4,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <read>:
SYSCALL(read)
 55a:	b8 05 00 00 00       	mov    $0x5,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <write>:
SYSCALL(write)
 562:	b8 10 00 00 00       	mov    $0x10,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <close>:
SYSCALL(close)
 56a:	b8 15 00 00 00       	mov    $0x15,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <kill>:
SYSCALL(kill)
 572:	b8 06 00 00 00       	mov    $0x6,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <exec>:
SYSCALL(exec)
 57a:	b8 07 00 00 00       	mov    $0x7,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <open>:
SYSCALL(open)
 582:	b8 0f 00 00 00       	mov    $0xf,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <mknod>:
SYSCALL(mknod)
 58a:	b8 11 00 00 00       	mov    $0x11,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <unlink>:
SYSCALL(unlink)
 592:	b8 12 00 00 00       	mov    $0x12,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <fstat>:
SYSCALL(fstat)
 59a:	b8 08 00 00 00       	mov    $0x8,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <link>:
SYSCALL(link)
 5a2:	b8 13 00 00 00       	mov    $0x13,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <mkdir>:
SYSCALL(mkdir)
 5aa:	b8 14 00 00 00       	mov    $0x14,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <chdir>:
SYSCALL(chdir)
 5b2:	b8 09 00 00 00       	mov    $0x9,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <dup>:
SYSCALL(dup)
 5ba:	b8 0a 00 00 00       	mov    $0xa,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <getpid>:
SYSCALL(getpid)
 5c2:	b8 0b 00 00 00       	mov    $0xb,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <sbrk>:
SYSCALL(sbrk)
 5ca:	b8 0c 00 00 00       	mov    $0xc,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <sleep>:
SYSCALL(sleep)
 5d2:	b8 0d 00 00 00       	mov    $0xd,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <uptime>:
SYSCALL(uptime)
 5da:	b8 0e 00 00 00       	mov    $0xe,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <info>:
SYSCALL(info) // LAB-1
 5e2:	b8 16 00 00 00       	mov    $0x16,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <tickets>:
SYSCALL(tickets) // LAB-2
 5ea:	b8 17 00 00 00       	mov    $0x17,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <clone>:
SYSCALL(clone) // LAB-3
 5f2:	b8 18 00 00 00       	mov    $0x18,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    
 5fa:	66 90                	xchg   %ax,%ax
 5fc:	66 90                	xchg   %ax,%ax
 5fe:	66 90                	xchg   %ax,%ax

00000600 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	57                   	push   %edi
 604:	56                   	push   %esi
 605:	53                   	push   %ebx
 606:	89 c6                	mov    %eax,%esi
 608:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 60b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 60e:	85 db                	test   %ebx,%ebx
 610:	74 7e                	je     690 <printint+0x90>
 612:	89 d0                	mov    %edx,%eax
 614:	c1 e8 1f             	shr    $0x1f,%eax
 617:	84 c0                	test   %al,%al
 619:	74 75                	je     690 <printint+0x90>
    neg = 1;
    x = -xx;
 61b:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 61d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 624:	f7 d8                	neg    %eax
 626:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 629:	31 ff                	xor    %edi,%edi
 62b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 62e:	89 ce                	mov    %ecx,%esi
 630:	eb 08                	jmp    63a <printint+0x3a>
 632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 638:	89 cf                	mov    %ecx,%edi
 63a:	31 d2                	xor    %edx,%edx
 63c:	8d 4f 01             	lea    0x1(%edi),%ecx
 63f:	f7 f6                	div    %esi
 641:	0f b6 92 0c 0b 00 00 	movzbl 0xb0c(%edx),%edx
  }while((x /= base) != 0);
 648:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 64a:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 64d:	75 e9                	jne    638 <printint+0x38>
  if(neg)
 64f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 652:	8b 75 c0             	mov    -0x40(%ebp),%esi
 655:	85 c0                	test   %eax,%eax
 657:	74 08                	je     661 <printint+0x61>
    buf[i++] = '-';
 659:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 65e:	8d 4f 02             	lea    0x2(%edi),%ecx
 661:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 665:	8d 76 00             	lea    0x0(%esi),%esi
 668:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 66b:	83 ec 04             	sub    $0x4,%esp
 66e:	83 ef 01             	sub    $0x1,%edi
 671:	6a 01                	push   $0x1
 673:	53                   	push   %ebx
 674:	56                   	push   %esi
 675:	88 45 d7             	mov    %al,-0x29(%ebp)
 678:	e8 e5 fe ff ff       	call   562 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 67d:	83 c4 10             	add    $0x10,%esp
 680:	39 df                	cmp    %ebx,%edi
 682:	75 e4                	jne    668 <printint+0x68>
    putc(fd, buf[i]);
}
 684:	8d 65 f4             	lea    -0xc(%ebp),%esp
 687:	5b                   	pop    %ebx
 688:	5e                   	pop    %esi
 689:	5f                   	pop    %edi
 68a:	5d                   	pop    %ebp
 68b:	c3                   	ret    
 68c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 690:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 692:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 699:	eb 8b                	jmp    626 <printint+0x26>
 69b:	90                   	nop
 69c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006a0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 6a0:	55                   	push   %ebp
 6a1:	89 e5                	mov    %esp,%ebp
 6a3:	57                   	push   %edi
 6a4:	56                   	push   %esi
 6a5:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6a6:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 6a9:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6ac:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 6af:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6b5:	0f b6 1e             	movzbl (%esi),%ebx
 6b8:	83 c6 01             	add    $0x1,%esi
 6bb:	84 db                	test   %bl,%bl
 6bd:	0f 84 b0 00 00 00    	je     773 <printf+0xd3>
 6c3:	31 d2                	xor    %edx,%edx
 6c5:	eb 39                	jmp    700 <printf+0x60>
 6c7:	89 f6                	mov    %esi,%esi
 6c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 6d0:	83 f8 25             	cmp    $0x25,%eax
 6d3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 6d6:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 6db:	74 18                	je     6f5 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6dd:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 6e0:	83 ec 04             	sub    $0x4,%esp
 6e3:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 6e6:	6a 01                	push   $0x1
 6e8:	50                   	push   %eax
 6e9:	57                   	push   %edi
 6ea:	e8 73 fe ff ff       	call   562 <write>
 6ef:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 6f2:	83 c4 10             	add    $0x10,%esp
 6f5:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6f8:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 6fc:	84 db                	test   %bl,%bl
 6fe:	74 73                	je     773 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 700:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 702:	0f be cb             	movsbl %bl,%ecx
 705:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 708:	74 c6                	je     6d0 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 70a:	83 fa 25             	cmp    $0x25,%edx
 70d:	75 e6                	jne    6f5 <printf+0x55>
      if(c == 'd'){
 70f:	83 f8 64             	cmp    $0x64,%eax
 712:	0f 84 f8 00 00 00    	je     810 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 718:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 71e:	83 f9 70             	cmp    $0x70,%ecx
 721:	74 5d                	je     780 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 723:	83 f8 73             	cmp    $0x73,%eax
 726:	0f 84 84 00 00 00    	je     7b0 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 72c:	83 f8 63             	cmp    $0x63,%eax
 72f:	0f 84 ea 00 00 00    	je     81f <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 735:	83 f8 25             	cmp    $0x25,%eax
 738:	0f 84 c2 00 00 00    	je     800 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 73e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 741:	83 ec 04             	sub    $0x4,%esp
 744:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 748:	6a 01                	push   $0x1
 74a:	50                   	push   %eax
 74b:	57                   	push   %edi
 74c:	e8 11 fe ff ff       	call   562 <write>
 751:	83 c4 0c             	add    $0xc,%esp
 754:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 757:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 75a:	6a 01                	push   $0x1
 75c:	50                   	push   %eax
 75d:	57                   	push   %edi
 75e:	83 c6 01             	add    $0x1,%esi
 761:	e8 fc fd ff ff       	call   562 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 766:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 76a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 76d:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 76f:	84 db                	test   %bl,%bl
 771:	75 8d                	jne    700 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 773:	8d 65 f4             	lea    -0xc(%ebp),%esp
 776:	5b                   	pop    %ebx
 777:	5e                   	pop    %esi
 778:	5f                   	pop    %edi
 779:	5d                   	pop    %ebp
 77a:	c3                   	ret    
 77b:	90                   	nop
 77c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 780:	83 ec 0c             	sub    $0xc,%esp
 783:	b9 10 00 00 00       	mov    $0x10,%ecx
 788:	6a 00                	push   $0x0
 78a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 78d:	89 f8                	mov    %edi,%eax
 78f:	8b 13                	mov    (%ebx),%edx
 791:	e8 6a fe ff ff       	call   600 <printint>
        ap++;
 796:	89 d8                	mov    %ebx,%eax
 798:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 79b:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 79d:	83 c0 04             	add    $0x4,%eax
 7a0:	89 45 d0             	mov    %eax,-0x30(%ebp)
 7a3:	e9 4d ff ff ff       	jmp    6f5 <printf+0x55>
 7a8:	90                   	nop
 7a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 7b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 7b3:	8b 18                	mov    (%eax),%ebx
        ap++;
 7b5:	83 c0 04             	add    $0x4,%eax
 7b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 7bb:	b8 02 0b 00 00       	mov    $0xb02,%eax
 7c0:	85 db                	test   %ebx,%ebx
 7c2:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 7c5:	0f b6 03             	movzbl (%ebx),%eax
 7c8:	84 c0                	test   %al,%al
 7ca:	74 23                	je     7ef <printf+0x14f>
 7cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7d0:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7d3:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 7d6:	83 ec 04             	sub    $0x4,%esp
 7d9:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 7db:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7de:	50                   	push   %eax
 7df:	57                   	push   %edi
 7e0:	e8 7d fd ff ff       	call   562 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7e5:	0f b6 03             	movzbl (%ebx),%eax
 7e8:	83 c4 10             	add    $0x10,%esp
 7eb:	84 c0                	test   %al,%al
 7ed:	75 e1                	jne    7d0 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7ef:	31 d2                	xor    %edx,%edx
 7f1:	e9 ff fe ff ff       	jmp    6f5 <printf+0x55>
 7f6:	8d 76 00             	lea    0x0(%esi),%esi
 7f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 800:	83 ec 04             	sub    $0x4,%esp
 803:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 806:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 809:	6a 01                	push   $0x1
 80b:	e9 4c ff ff ff       	jmp    75c <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 810:	83 ec 0c             	sub    $0xc,%esp
 813:	b9 0a 00 00 00       	mov    $0xa,%ecx
 818:	6a 01                	push   $0x1
 81a:	e9 6b ff ff ff       	jmp    78a <printf+0xea>
 81f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 822:	83 ec 04             	sub    $0x4,%esp
 825:	8b 03                	mov    (%ebx),%eax
 827:	6a 01                	push   $0x1
 829:	88 45 e4             	mov    %al,-0x1c(%ebp)
 82c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 82f:	50                   	push   %eax
 830:	57                   	push   %edi
 831:	e8 2c fd ff ff       	call   562 <write>
 836:	e9 5b ff ff ff       	jmp    796 <printf+0xf6>
 83b:	66 90                	xchg   %ax,%ax
 83d:	66 90                	xchg   %ax,%ax
 83f:	90                   	nop

00000840 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 840:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 841:	a1 70 0e 00 00       	mov    0xe70,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 846:	89 e5                	mov    %esp,%ebp
 848:	57                   	push   %edi
 849:	56                   	push   %esi
 84a:	53                   	push   %ebx
 84b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84e:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 850:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 853:	39 c8                	cmp    %ecx,%eax
 855:	73 19                	jae    870 <free+0x30>
 857:	89 f6                	mov    %esi,%esi
 859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 860:	39 d1                	cmp    %edx,%ecx
 862:	72 1c                	jb     880 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 864:	39 d0                	cmp    %edx,%eax
 866:	73 18                	jae    880 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 868:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86a:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86c:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86e:	72 f0                	jb     860 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 870:	39 d0                	cmp    %edx,%eax
 872:	72 f4                	jb     868 <free+0x28>
 874:	39 d1                	cmp    %edx,%ecx
 876:	73 f0                	jae    868 <free+0x28>
 878:	90                   	nop
 879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 880:	8b 73 fc             	mov    -0x4(%ebx),%esi
 883:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 886:	39 d7                	cmp    %edx,%edi
 888:	74 19                	je     8a3 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 88a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 88d:	8b 50 04             	mov    0x4(%eax),%edx
 890:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 893:	39 f1                	cmp    %esi,%ecx
 895:	74 23                	je     8ba <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 897:	89 08                	mov    %ecx,(%eax)
  freep = p;
 899:	a3 70 0e 00 00       	mov    %eax,0xe70
}
 89e:	5b                   	pop    %ebx
 89f:	5e                   	pop    %esi
 8a0:	5f                   	pop    %edi
 8a1:	5d                   	pop    %ebp
 8a2:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8a3:	03 72 04             	add    0x4(%edx),%esi
 8a6:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 8a9:	8b 10                	mov    (%eax),%edx
 8ab:	8b 12                	mov    (%edx),%edx
 8ad:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 8b0:	8b 50 04             	mov    0x4(%eax),%edx
 8b3:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8b6:	39 f1                	cmp    %esi,%ecx
 8b8:	75 dd                	jne    897 <free+0x57>
    p->s.size += bp->s.size;
 8ba:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 8bd:	a3 70 0e 00 00       	mov    %eax,0xe70
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8c2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8c5:	8b 53 f8             	mov    -0x8(%ebx),%edx
 8c8:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 8ca:	5b                   	pop    %ebx
 8cb:	5e                   	pop    %esi
 8cc:	5f                   	pop    %edi
 8cd:	5d                   	pop    %ebp
 8ce:	c3                   	ret    
 8cf:	90                   	nop

000008d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8d0:	55                   	push   %ebp
 8d1:	89 e5                	mov    %esp,%ebp
 8d3:	57                   	push   %edi
 8d4:	56                   	push   %esi
 8d5:	53                   	push   %ebx
 8d6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 8dc:	8b 15 70 0e 00 00    	mov    0xe70,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e2:	8d 78 07             	lea    0x7(%eax),%edi
 8e5:	c1 ef 03             	shr    $0x3,%edi
 8e8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 8eb:	85 d2                	test   %edx,%edx
 8ed:	0f 84 a3 00 00 00    	je     996 <malloc+0xc6>
 8f3:	8b 02                	mov    (%edx),%eax
 8f5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 8f8:	39 cf                	cmp    %ecx,%edi
 8fa:	76 74                	jbe    970 <malloc+0xa0>
 8fc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 902:	be 00 10 00 00       	mov    $0x1000,%esi
 907:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 90e:	0f 43 f7             	cmovae %edi,%esi
 911:	ba 00 80 00 00       	mov    $0x8000,%edx
 916:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 91c:	0f 46 da             	cmovbe %edx,%ebx
 91f:	eb 10                	jmp    931 <malloc+0x61>
 921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 928:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 92a:	8b 48 04             	mov    0x4(%eax),%ecx
 92d:	39 cf                	cmp    %ecx,%edi
 92f:	76 3f                	jbe    970 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 931:	39 05 70 0e 00 00    	cmp    %eax,0xe70
 937:	89 c2                	mov    %eax,%edx
 939:	75 ed                	jne    928 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 93b:	83 ec 0c             	sub    $0xc,%esp
 93e:	53                   	push   %ebx
 93f:	e8 86 fc ff ff       	call   5ca <sbrk>
  if(p == (char*)-1)
 944:	83 c4 10             	add    $0x10,%esp
 947:	83 f8 ff             	cmp    $0xffffffff,%eax
 94a:	74 1c                	je     968 <malloc+0x98>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 94c:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 94f:	83 ec 0c             	sub    $0xc,%esp
 952:	83 c0 08             	add    $0x8,%eax
 955:	50                   	push   %eax
 956:	e8 e5 fe ff ff       	call   840 <free>
  return freep;
 95b:	8b 15 70 0e 00 00    	mov    0xe70,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 961:	83 c4 10             	add    $0x10,%esp
 964:	85 d2                	test   %edx,%edx
 966:	75 c0                	jne    928 <malloc+0x58>
        return 0;
 968:	31 c0                	xor    %eax,%eax
 96a:	eb 1c                	jmp    988 <malloc+0xb8>
 96c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 970:	39 cf                	cmp    %ecx,%edi
 972:	74 1c                	je     990 <malloc+0xc0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 974:	29 f9                	sub    %edi,%ecx
 976:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 979:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 97c:	89 78 04             	mov    %edi,0x4(%eax)
      }
      freep = prevp;
 97f:	89 15 70 0e 00 00    	mov    %edx,0xe70
      return (void*)(p + 1);
 985:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 988:	8d 65 f4             	lea    -0xc(%ebp),%esp
 98b:	5b                   	pop    %ebx
 98c:	5e                   	pop    %esi
 98d:	5f                   	pop    %edi
 98e:	5d                   	pop    %ebp
 98f:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 990:	8b 08                	mov    (%eax),%ecx
 992:	89 0a                	mov    %ecx,(%edx)
 994:	eb e9                	jmp    97f <malloc+0xaf>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 996:	c7 05 70 0e 00 00 74 	movl   $0xe74,0xe70
 99d:	0e 00 00 
 9a0:	c7 05 74 0e 00 00 74 	movl   $0xe74,0xe74
 9a7:	0e 00 00 
    base.s.size = 0;
 9aa:	b8 74 0e 00 00       	mov    $0xe74,%eax
 9af:	c7 05 78 0e 00 00 00 	movl   $0x0,0xe78
 9b6:	00 00 00 
 9b9:	e9 3e ff ff ff       	jmp    8fc <malloc+0x2c>
