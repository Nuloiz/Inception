#include <fcntl.h>
#include <unistd.h>

int main (void)
{
    int f;

    f = open("test.cpp", O_RDONLY);
    close (f);
    return (1);
}