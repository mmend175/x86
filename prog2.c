#include "types.h"
#include "user.h"
#include "stat.h"

int Scheduler(const char *total_tickets)
{
    int total= atoi(total_tickets);
    int pid;
    int i, j, k;
    //int total = 60;
    int high = total/2;
    int mid = total/3;
    int lowest = total-(high+mid);
    /*Replace YOUR_SYSCALL_TO_ASSIGN_TICKET with what you implement to assign ticket */
   // tickets(60); total*(3-i)/6 = 60*(1/2)= 60/2 + 3 + 6
   // tickets(total);
    for (i = 0; i < 3; i++)
    {
        pid = fork();
        if (pid > 0) //parent
        {
            continue;
        }
        else if (pid == 0) //child
        {
            if(i==0)
               {tickets(high); }
            if(i==1)
               {tickets(mid); }
            if(i==2)
            {
                    tickets(lowest);
            }

            for (j = 0; j < 50000; j++)
            {
                for (k = 0; k < 50000; k++)
                {
                    asm("nop");
                }
            }
            if(i==0)
            printf(1, "\n  child# %d with %d tickets has finished!  \n", getpid(), high);
            if(i==1)
            printf(1, "\n  child# %d with %d tickets has finished!  \n", getpid(),mid);
            if(i==2)
            printf(1, "\n  child# %d with %d tickets has finished!  \n", getpid(), lowest);
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

int main(int argc, char *argv[])
{
   if (argc != 2)
   {
        printf(1, "usage: x y\n");
        exit();
    }

  int Scheduler(const char *);

  Scheduler(argv[1]);
  return 0;
}



