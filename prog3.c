#include "types.h"
#include "stat.h"
#include "user.h"
#include "x86.h"
#include "thread_lib.h"

static int output = 0;
static int numofthread;
static int passnum; //number of total passes
static int workpid = 0;//this time should be no workpid's time to work

void* worker();
struct lock_t *lock;

extern struct lock_t *lock;

int main (int argc , char * argv [])
{
        numofthread =atoi(argv[1]);// num of threads is decided by the parameter passed by user
        passnum = atoi(argv[2]);
        printf(1,"PARENT PID:%d\n",getpid());
        int i = 0 ;
        int pid = 0;
        lock_init(lock);
        for(i=0;i<numofthread;i++)
        {
            printf(1,"loop start count:%d with main pid: %d\n\n",i,getpid());
            pid = thread_create(worker,(void *)i);
            printf(1,"out of count:%d, with main pid: %d\n",i,getpid());
        }
        if(pid >0)
                printf(1,"parent's pid num is %d\n",getpid());
        if(pid ==0)
                printf(1,"child's pid num is %d\n",getpid());

        if (pid > 0) // pid > 0 -> parent
        {
            for (i = 0; i <numofthread; i++)
            {
                wait(); //wait each time for each thread created for parent
                printf(1,"end of wait!!PID:%d\n",pid);
            }
        }

        printf(1,"end of program!!!PID:%d\n",pid);
        exit();

}
/*worker is the function passed into the threads
 * each thread after created will do the function
 * arg is the parameter passed into the thread_create
 * and make "arg" as the id of each thread
 * in while loop every thread acquire the lock and the thread get the lock stil need to check pid num
 * 1 pass token to 2,2 to 3 and so on.
 * if the thread get the lock does not the thread should work
 * it will sleep and release the lock
 * */

void* worker(void *arg)
{
        int pidnum = (int)arg; // pidnum = thread num
        printf(1,"child's pid num is %d\n",pidnum);

        while(output<passnum)//when pass time  bigger than it should be passed
        {
                if(output==passnum) //stop we are done
                        break;
                lock_acquire(lock);
                if(pidnum==workpid) //workpid == current thread that should get the number the fribee toss to it. I.E if current thread 1 -> workpid(thread 2.)
                {
                        output++; //used to count the number of passes currently
                        printf(1,"pass number no: %d, Thread %d is passing the token to ",output,pidnum);
                        workpid++;
                        if(workpid == numofthread)// because thread num is start from 0
                                workpid = 0 ;
                        printf(1," %d\n",workpid);
                        lock_release(lock);
                        sleep(1);

                }
                else
                {
                    lock_release(lock);
                    sleep(1); //sleep the other thread that should not be working
                }

        }

        printf(1,"time to end: %d\n",pidnum);
        return 0;
}

