#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "rand.h"

static int numofthread = 0;
struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;

int max = 4000000; //LAB-2
int TOTAL_MAX_TICKETS = 100000; //LAB-2
int ALLOCATION_COUNT = 100;//LAB-2
int DEFAULT_TICKETS=1;//LAB-2
extern void forkret(void);
extern void trapret(void);
int allocate_info(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// NEED TO MAKE SURE TO HAVE A BOUNDED Region between 0 to max
long genrand64_int64(long max) {
    // max <= RAND_MAX < ULONG_MAX, so this is okay.
  unsigned long  bins = (unsigned long) max + 1; //number of bins
  unsigned long  num_rand = (unsigned long) RAND_MAX + 1;
  unsigned long  bin_size = num_rand / bins;
  unsigned long  defect   = num_rand % bins;

  long x;

   x = genrand();
  // This is carefully written not to overflow
  while (num_rand - defect <= (unsigned long)x);
  {
      x = genrand();
  }

  // Truncated division is intentional
  return x/bin_size;
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc()
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    //  p->syscall_count = 0;
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->syscall_count = 0; //LAB-1
  p->state = EMBRYO;
  p->pid = nextpid++;

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
  p->pass = 0;
  p->thread_indictor = 0; //LAB-3
  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
  p->state = RUNNABLE;
  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *p;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;


  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
           if(p->state == RUNNABLE || p->state == RUNNING)
           {
               //initialze
                  if(p->tickets != 0)
                 {
                  p->stride = (TOTAL_MAX_TICKETS/p->tickets);
                  p->pass = p->stride;   //LAB-2
                  p->execution_count=0;//LAB-2
                  p->execution_time=0;//LAB-2
                  }
           }
           else
           {

               p->execution_count=0;//LAB-2
               p->execution_time=0;//LAB-2
               p->tickets = DEFAULT_TICKETS;
               p->stride = 0;
           }
}
  release(&ptable.lock);

  return pid;
}

/* clone
 * clone a new thread sharing the same address space with their parents insead of duplicate it
 * Therefore, file discriptor should be shared
 * And append new stack on the original stack in address space
 * */
int
clone(void* stack,int size)//LAB-3
{
  numofthread++;//one clone add one thread
  cprintf("this is clone %d\n",size);
  int i,pid;
  struct proc *newp;//new process and in here is new thread
  if((newp=allocproc())==0)
    return -1;

  struct proc *curproc = myproc();
  newp ->pgdir = curproc->pgdir;
  newp ->sz  = curproc ->sz; // size of process
  newp ->parent = curproc;//parent will be original process
  *newp ->tf = *curproc ->tf;
  newp ->thread_indictor= 1; //indicator a thread
  newp ->tf -> eax = 0 ;// clone in child will return 0

  /* NEED TO GRAB THE LOCATION OF STACK and  curproc->tf->esp
  PLACE FOR NEW CLONES THREAD ON TOP OF PARENT'S STACK
  */

  void *bottom_stack= (void*)curproc->tf->esp; //current stack pointer //12156
  void *top_stack = (void*)curproc->tf->ebp +4*sizeof(stack);//why 16? //12200
  cprintf("old esp :%d old ebp %d\n",bottom_stack,top_stack);
  uint parent_size = (uint)(top_stack - bottom_stack); //positive  44 size of stack!!
  cprintf("copysize:%d, stack:%d\n",parent_size,stack);
  newp->tf->esp = (uint) (stack - parent_size);//40916, stack = 10,936 + 40916
  newp->tf->ebp = (uint) (stack -4*sizeof(stack)); //40944, 10,936 - 16
  cprintf("new stack esp %d ebp: %d\n",newp->tf->esp,newp->tf->ebp);
  memmove(stack - parent_size,bottom_stack,parent_size); //move current proc esp below new esp


  cprintf("new eip:%d\n",newp->tf->eip);
  for(i=0;i<NOFILE;i++)
  {
    if(curproc->ofile[i])
      newp->ofile[i]=(curproc->ofile[i]);
  }
  newp->cwd = (curproc->cwd);

  pid = newp->pid;
  newp->state = RUNNABLE;
  safestrcpy(newp->name, curproc->name, sizeof(curproc->name));
  cprintf("In clone function this is a pid %d\n",pid);

  return pid;
}

void
exit(void)
{
    cprintf("enter exit..\n");
  struct proc *curproc = myproc();

  struct proc *p;
  int fd;
    if(curproc == initproc)
      panic("init exiting");

    if (numofthread==0) //LAB-3
    {
        for(fd = 0; fd < NOFILE; fd++){
        if(curproc->ofile[fd]){
            fileclose(curproc->ofile[fd]);
            curproc->ofile[fd] = 0;
            }
        }

    begin_op();
    iput(curproc->cwd);
    end_op();
    curproc->cwd = 0;
    }
    acquire(&ptable.lock);

    //parents might be sleeping in wait
    wakeup1(curproc->parent);
    //pass the children to init
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent == curproc){
          cprintf("enter parent == current, p->PID:%d \n", p->pid);
        p->parent = initproc;
        if(p->state == ZOMBIE)
          wakeup1(initproc);
      }
    }

    //jump to the scheduler and never return
    curproc->state = ZOMBIE;
    sched();
    panic("zombie exit");
}

int
wait(void)
{
  cprintf("ENTER WAIT\n");
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc) //LAB-3- if current == parent or current has
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        if(p->thread_indictor == 1)//clone
        {
            numofthread--;
            cprintf("count thread:%d\n",numofthread);
            p->state = UNUSED;
            pid = p->pid;
            release(&ptable.lock);
            return pid;
        }
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }
    cprintf("EXIT SLEEP for parent\n");

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    cprintf("EXIT SLEEP for parent\n");

  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  cprintf("starting round robin...\n");
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);

  }
}
//LAB-2
/* This is the lottery implimentation that required change in mpmain(void) in main.c to replace
 * scheduler() line with lottery_scheduler();
 */
void
lottery_scheduler(void)
{
  cprintf("starting  lottery...\n");
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  //used to pick the correct bin the winner in
  int ticket_bin =0;
  //collect total tickets for lottery pick
  int totalTickets = 0;
  //lottery winner
  long winner =0;
 // long current_bin = 0;
  //tracking start of ticks of process
  uint start = 0;
  for(;;){
    // Enable interrupts on this processor.
    sti();
    start = ticks;
    acquire(&ptable.lock);
    ticket_bin = 0;
    totalTickets = 0;
    winner=0;
  //  current_bin=0;
    //LAB-2 : go through all processs and grab ticket total
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
          if(p->state == RUNNABLE)
            totalTickets = totalTickets + p->tickets;
    }
    release(&ptable.lock);

   winner = genrand() % (totalTickets + 1);

   // allocate_info(); //used for making FIGURE 9.

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

    //check who is the winner in which bin
   //   current_bin = ticket_bin + p->tickets;
      if( ticket_bin + p->tickets < winner)
      {
         ticket_bin += p->tickets;
         continue;
      }

      if(p->tickets > 1){
          p->execution_count++; //keep track of # of runs
      }
     //  allocate_info(); //used for making FIGURE 9.
       // Switch to chosen process.  It is the process's job
       // to release ptable.lock and then reacquire it
       // before jumping back to us.
       c->proc = p;
       switchuvm(p);
       p->state = RUNNING;
       swtch(&(c->scheduler), p->context);
       switchkvm();
       //number of ticks process has run.
       // Process is done running for now.
       p->execution_time += ticks - start;
       // It should have changed its p->state before coming back.
       c->proc = 0;
       break;
    }
    release(&ptable.lock);
    start = 0;
  }
}

//LAB-2
/* This is the stride implimentation that requires change in mpmain(void) in main.c to replace
 * scheduler() line with stride_scheduler();
 */
void
stride_scheduler(void)
{
  cprintf("starting stride scheduler...\n");
  struct proc *p;
  struct proc *min=0;
  struct cpu *c = mycpu();

  c->proc = 0;
  //tracking start of ticks of process
  uint start = 0;

  for(;;){
    // Enable interrupts on this processor.
    sti();
    start = ticks;
    acquire(&ptable.lock);
    int minpass = max;

    //Find process with minimum current pass.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
           if(p->state != RUNNABLE)
                continue;
           if(p->pass < minpass)
               {
                   minpass = p->pass;
                   if(p->tickets !=0)
                   p->stride = (TOTAL_MAX_TICKETS/p->tickets);
                   min= p;

               }
     }
    release(&ptable.lock);


    acquire(&ptable.lock);
    if(min && min->state==RUNNABLE )
     {
        if(minpass >= max && minpass >0)
       {
          for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
                   p->pass = p->stride;
       }

        p= min;
        p->pass = p->pass + p->stride;
        p->execution_count++; //keep track of # of runs
     //   allocate_info(); //used for making FIGURE 9.
       // Switch to chosen process.  It is the process's job
       // to release ptable.lock and then reacquire it
       // before jumping back to us.
       c->proc = p;
       switchuvm(p);

       p->state = RUNNING;

       swtch(&(c->scheduler), p->context);
       switchkvm();
       //number of ticks process has run.
       p->execution_time += ticks - start;
       // Process is done running for now.
       // It should have changed its p->state before coming back.
       c->proc = 0;
    }
    release(&ptable.lock);
    start = 0;
  }
}


//collect amount of allocation total for graphs results//LAB-2
int
allocate_info(void){

    struct proc *p;
    int total_all =0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
         if(p->state == RUNNABLE || p->state == RUNNING)
         {
        total_all +=p->execution_count;

         }
    }
    if (total_all == ALLOCATION_COUNT)
    {
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        {
                if(p->name[0] =='p')
                cprintf("%s's with pid:%d, scheduled times=%d tickets=%d\n", p->name,p->pid, p->execution_count,p->tickets);

        }
    }

    return 0;
}
// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  //cprintf("GOING TO BED!!!!\n");
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s tickets:%d count:%d ", p->pid, state, p->name,p->tickets,p->execution_count);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

// grabs a list of the processes being utilized in the system
//LAB-1
int 
running_processes(void)
{
    int n=0;
    struct proc *p;
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
          // check the ptable to see if a process is actually being used
          if(p->state != UNUSED) n++;
      }
    release(&ptable.lock);
    return n;
}

