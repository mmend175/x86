// This test case is designed for lottery scheduler
#include "types.h"
#include "stat.h"
#include "user.h"


int main(int argc, char *argv[])
{

    int Scheduler(void);

    Scheduler();
    return 0;
}

int Scheduler(void)
{

    int pid;
    int i, j, k;

    /*Replace YOUR_SYSCALL_TO_ASSIGN_TICKET with what you implement to assign ticket */
    tickets(100);
    for (i = 0; i < 3; i++)
    {
        pid = fork();
        if (pid > 0) //parent
        {
            continue;
        }
        else if (pid == 0) //child
        {
                if (i == 0)
               tickets(50);
                if (i == 1)
               tickets(33);
                if (i == 2)
               tickets(17);
            for (j = 0; j < 50000; j++)
            {
                for (k = 0; k < 50000; k++)
                {
                    asm("nop");
                }
            }
            printf(1, "\n  child# %d with %d tickets has finished!  \n", getpid(), 30 - 10 * i);
            exit();
        }
        else
        {
            printf(2, "  \n  Error  \n ");
        }
    }

    if (pid > 0)
    {
        for (i = 0; i < 3; i++)
        {
            wait();
        }
    }
    exit();
    return 0;
}


