#include "stack.h"

static Node* nodeFactory(uint32_t, Node*);

void push(Stack* stack, uint32_t value)
{
    stack->head = nodeFactory(value, stack->head);
}

void pop(Stack* stack)
{
    if(stack && stack->head){           // if stack is a valid address (aka null) and its head ptr is also valid address
        Node* ptr = stack->head;
        stack->head = stack->head->node;
        free(ptr);
    }
}

uint32_t peek(Stack* stack)
{
    uint32_t rtnVal = 0;
    if(stack && stack->head){
        rtnVal = stack->head->value;
    }
    return rtnVal;
}

bool empty(Stack* stack)
{
    return stack->head == NULL;
}

Stack* stackFactory(){
    Stack* stack = malloc(sizeof(Stack));
    stack->head = NULL;
    return stack;
}

void stackJunkYard(Stack* stack){
   
    if(stack){
        while(!empty(stack))
            pop(stack);
        free(stack);
    }
}

static Node* nodeFactory(uint32_t value, Node* next)
{
    Node* node = malloc(sizeof(Node));

    node->value = value;
    node->node = next;

    return node;
}

