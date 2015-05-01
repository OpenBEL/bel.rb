#ifndef _BEL_AST_H
#define _BEL_AST_H

typedef enum {
    BEL_TOKEN,
    BEL_VALUE
} bel_ast_node_type;

typedef enum {
    BEL_TOKEN_STATEMENT,
    BEL_TOKEN_SUBJECT,
    BEL_TOKEN_OBJECT,
    BEL_TOKEN_REL,
    BEL_TOKEN_TERM,
    BEL_TOKEN_ARG,
    BEL_TOKEN_NV,
    BEL_TOKEN_NULL
} bel_ast_token_type;

typedef enum {
    BEL_VALUE_FX,
    BEL_VALUE_REL,
    BEL_VALUE_PFX,
    BEL_VALUE_VAL
} bel_ast_value_type;

typedef struct {
    bel_ast_node_type type;
    union {
    bel_ast_token_type ttype;
    bel_ast_value_type vtype;
    };
} bel_ast_node_type_info;

typedef struct bel_ast_node_token bel_ast_node_token;
typedef struct bel_ast_node_value bel_ast_node_value;

typedef struct {
    union {
        bel_ast_node_type_info* type_info;
        bel_ast_node_token*    token;
        bel_ast_node_value*    value;
    };
} bel_ast_node;

struct bel_ast_node_token {
    bel_ast_node_type  type;
    bel_ast_token_type ttype;
    bel_ast_node*      left;
    bel_ast_node*      right;
    int                start_position;
    int                end_position;
    int                is_complete;
};

struct bel_ast_node_value {
    bel_ast_node_type  type;
    bel_ast_value_type vtype;
    char*              value;
    int                start_position;
    int                end_position;
};

typedef struct {
    bel_ast_node* root;
} bel_ast;

bel_ast_node* bel_new_ast_node_token(bel_ast_token_type type);

bel_ast_node* bel_new_ast_node_value(bel_ast_value_type type, char* value,
        int start_position, int end_position);

bel_ast_node* bel_copy_ast_node(bel_ast_node* node);

bel_ast_node* bel_set_value(bel_ast_node* node, char* value);

bel_ast* bel_new_ast();

void bel_free_ast_node(bel_ast_node* node);

void bel_free_ast(bel_ast* ast);

void bel_print_ast_node(bel_ast_node* node, char* tree_flat_string);

void bel_print_ast(bel_ast* ast);

char* bel_ast_as_string(bel_ast* ast);

char* bel_ast_node_as_string(bel_ast_node* node);

#endif /* not defined _BEL_AST_H */
