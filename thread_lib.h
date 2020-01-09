#ifndef THREAD_LIB
#define THREAD_LIB
#define PGSIZE 4096

struct lock_t
{
	uint locked;
};

//this part is for spin lock
void lock_init(struct lock_t *lk)
{
        lk -> locked = 0;//initial situation is unlocked
}
void lock_acquire(struct lock_t *lk)
{
        while(xchg(&lk->locked,1) != 0);
}
void lock_release(struct lock_t *lock)
{
        xchg(&lock->locked,0);
}

int thread_create(void*(*start_routine)(void*), void *arg)
{
        void* newp = malloc(2*PGSIZE); //need twice as much to make sure
        int rc;
        printf(1,"%s :%d\n",__func__, getpid());
        rc = clone(newp,2*PGSIZE);
        //clone returns the PID of the child to the parent,
        // and 0 to the newly-created child thread
        printf(1,"%s,returns PID :%d\n",__func__,rc);
        if (rc == 0) //child
        {
            (*start_routine)(arg);
            exit(); //terminate thread
        }
        else if(rc > 0) //parent
            return rc;
        else
            {
                printf(2, "  OPPS...\n  Error  \n ");
                return -1;
            }
}
#endif
