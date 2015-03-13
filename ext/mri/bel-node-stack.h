#include "bel-ast.h"

#ifndef _BEL_NODE_STACK_H
#define _BEL_NODE_STACK_H

typedef struct {
    int                        top;
    int                        max;
    bel_ast_node*              contents[];
} bel_node_stack;

bel_node_stack* stack_init(int max);

void stack_destroy(bel_node_stack* stack);

bel_ast_node* stack_peek(bel_node_stack* stack);

void stack_push(bel_node_stack* stack, bel_ast_node* node);

bel_ast_node* stack_pop(bel_node_stack* stack);

int stack_is_empty(bel_node_stack* stack);

int stack_is_full(bel_node_stack* stack);

#endif /* not defined _BEL_NODE_STACK_H */
