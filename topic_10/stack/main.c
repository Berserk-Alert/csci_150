#include "stdlib.h"
#include "stack.h"
#include "stdio.h"

int main(int argc, char const *argv[])
{
    Stack* stack = stackFactory();

    for(uint32_t i = 1; i <= 10; i++){
        push(stack, i);
    }

    while(!empty(stack)){
        printf("%d\n", (unsigned int)peek(stack));
        pop(stack);
    }

    stackJunkYard(stack);
    return 0;
}