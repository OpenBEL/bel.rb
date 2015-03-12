#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "bel-node-stack.h"

bel_node_stack* stack_init(int max) {
    bel_node_stack*  stack = malloc(sizeof(int) *2 + sizeof(bel_ast_node) * max );
    bel_ast_node*    contents[max];

    if (contents == NULL) {
        fprintf(stderr, "Insufficient memory to initialize stack.\n");
        return NULL;
    }

    stack->top      = -1;
    stack->max      = max;

    return stack;
};

void stack_destroy(bel_node_stack* stack) {
    free(stack);
};

bel_ast_node* stack_peek(bel_node_stack* stack) {
    bel_ast_node* (*nodes)[];
    bel_ast_node* top;

    if (stack_is_empty(stack)) {
        return NULL;
    }

    nodes = &stack->contents;
    top = (*nodes)[stack->top];
    return top;
};

void stack_push(bel_node_stack* stack, bel_ast_node* node) {
    bel_ast_node* (*nodes)[];

    if (stack_is_full(stack)) {
        fprintf(stderr, "Stack is full, cannot push\n");
        return;
    }

    nodes = &stack->contents;
    (*nodes)[++stack->top] = node;
};

bel_ast_node* stack_pop(bel_node_stack* stack) {
    bel_ast_node* (*nodes)[];
    bel_ast_node* popped_top;

    if (stack_is_empty(stack)) {
        fprintf(stderr, "Stack is empty, cannot pop\n");
        return NULL;
    }

    nodes = &stack->contents;
    popped_top = (*nodes)[stack->top--];
    return popped_top;
};

int stack_is_empty(bel_node_stack* stack) {
    return stack->top == -1;
};

int stack_is_full(bel_node_stack* stack) {
    return stack->top >= stack->max - 1;
};

void stack_print(bel_node_stack* stack) {
    bel_ast_node* el;
    int i;
    fprintf(stdout, "stack count: %d\n", (stack->top + 1));
    for(i = (stack->top); i > -1; i--) {
        char tree_flat_string[1024 * 32];
        memset(tree_flat_string, '\0', 1024 * 32);
        el = stack->contents[i];
        bel_print_ast_node(el, tree_flat_string);
        fprintf(stdout, "stack[%d]: %s\n", i, tree_flat_string);
    }
};
