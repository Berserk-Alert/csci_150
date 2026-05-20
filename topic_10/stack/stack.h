#include "stdint.h"
#include "stdbool.h"
#include "stdlib.h"

#ifndef STACK_H
#define STACK_H
//#define NULL 0

typedef struct Node Node;

struct Node 
{
    uint32_t value;
    Node* node;
};

typedef struct
{
    Node* head;
} Stack;

void push(Stack*, uint32_t);
void pop(Stack*);
uint32_t peek(Stack*);
bool empty(Stack*);
Stack* stackFactory();
void stackJunkYard(Stack*);

#endif /* STACK_H*/