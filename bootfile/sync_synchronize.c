inline void __sync_synchronize()
{
    asm volatile("" ::: "memory");
}