#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

//LAB-1
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

//find number of currently USED processes in system
//LAB-1
int
sys_info(void)
{
        int n;
        argint(0, &n);
  if(n == 1)
  {     int n;
        n = running_processes();        
        return n; 
  }
   //total number of system calls current process has made so far
  else if(n == 2)
  {
      return myproc()->syscall_count;
  }
 //number of memory pages the current process is using.  
  else if(n == 3)
  {
      int count = 0;      
      pde_t *pte;
      uint i;
      //traverse through page directory and see if a page entry is present.
      for(i = 0; i < myproc()->sz; i += PGSIZE){
        pte = walkpgdir(myproc()->pgdir, (void *) i, 0);
        if(*pte & PTE_P) count++;
      }
      return count;
  }
  return -1;
}

int
sys_tickets(void) { //LAB-2 allocation n number of tickets to current process
int n;

if(argint(0, &n) < 0)
    return -1;
    myproc()->tickets = n;   
    cprintf("proc:%d has been gaving %d tickets with name %s...\n",myproc()->pid,myproc()->tickets, myproc()->name);

    return 0;
}
int
sys_clone(void) { //LAB-3
    int size;
    void *stack;
 //   cprintf("entered sys_clone");
   if(argptr(0, (void*)&stack, sizeof(void*)) < 0 || argint(1, &size) < 0)
    {
        return -1;
    }

   return clone(stack,size);
}
