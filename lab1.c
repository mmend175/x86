#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
char * c= "";
printf(1,"Please Enter Value [1-3]:\n(1)A count of the processes in the system\n"
         "(2)A count of the total number of system calls that the current process has made so "
         "far\n(3)The number of memory pages the current process is using.\n");

c = gets(c,2);
if(atoi(c) == 1)
{
    int n = info(atoi(c));
    printf(1, "Number of Process on System: (%d)\n", n);
}
else if (atoi(c) == 2)
{
    int n = info(atoi(c));
    printf(1,"Current Process has %d system calls\n", n);

}
else if (atoi(c) == 3)
{
    int n = info(atoi(c));
    printf(1,"The number of memory pages the current process is using is %d\n", n);

}
exit();
}
