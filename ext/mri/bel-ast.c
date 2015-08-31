#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "bel-ast.h"

bel_ast_node* bel_new_ast_node_token(bel_ast_token_type type) {
    bel_ast_node* node;

    node                              = malloc(sizeof(bel_ast_node));
    node->token                       = malloc(sizeof(bel_ast_node_token));
    node->token->type                 = BEL_TOKEN;
    node->token->ttype                = type;
    node->token->left                 = NULL;
    node->token->right                = NULL;
	node->token->is_complete          = 0;
	node->token->start_position       = -1;
	node->token->end_position         = -1;
    return node;
};

bel_ast_node* bel_new_ast_node_value(bel_ast_value_type type, char* value,
		int start_position, int end_position) {
    bel_ast_node* node;
    char*         copy_value;

    if (value) {
        copy_value = malloc(strlen(value) + 1);
        strcpy(copy_value, value);
    } else {
        copy_value = NULL;
    }

    node = malloc(sizeof(bel_ast_node));
    node->value                 = malloc(sizeof(bel_ast_node_value));
    node->value->type           = BEL_VALUE;
    node->value->vtype          = type;
    node->value->value          = copy_value;
	node->value->start_position = start_position;
	node->value->end_position   = end_position;
    return node;
};

bel_ast_node* bel_copy_ast_node(bel_ast_node* node) {
	bel_ast_node* copy_node;
    char* copy_value;

    if (!node) {
        return NULL;
	}

	copy_node = malloc(sizeof(bel_ast_node));

    if (node->type_info->type == BEL_VALUE) {
		if (node->value->value) {
			copy_value = malloc(strlen(node->value->value) + 1);
			strcpy(copy_value, node->value->value);
		} else {
			copy_value = NULL;
		}

		copy_node->value = malloc(sizeof(bel_ast_node_value));
		copy_node->value->type           = node->value->type;
		copy_node->value->vtype          = node->value->vtype;
		copy_node->value->value          = copy_value;
		copy_node->value->start_position = node->value->start_position;
		copy_node->value->end_position   = node->value->end_position;
    } else {
		copy_node->token = malloc(sizeof(bel_ast_node_token));
		copy_node->token->type                 = node->token->type;
		copy_node->token->ttype                = node->token->ttype;
		copy_node->token->left                 = bel_copy_ast_node(node->token->left);
		copy_node->token->right                = bel_copy_ast_node(node->token->right);
		copy_node->token->is_complete          = node->token->is_complete;
		copy_node->token->start_position       = node->token->start_position;
		copy_node->token->end_position         = node->token->end_position;
	}

	return copy_node;
}

bel_ast_node* bel_set_value(bel_ast_node* node, char* value) {
    char* copy_value;

    if (!node) {
        // TODO Debug node error to stderr; node is NULL
        return NULL;
    }

    if (node->type_info->type != BEL_VALUE) {
        // TODO Debug node error to stderr; node cannot hold value
        return NULL;
    }

    if (value) {
        copy_value = malloc(strlen(value) + 1);
        strcpy(copy_value, value);
    } else {
        copy_value = NULL;
    }

    free(node->value->value);
    node->value->value = copy_value;
    return node;
}

bel_ast* bel_new_ast() {
    bel_ast* ast;
    ast = malloc(sizeof(bel_ast));
    ast->root = NULL;
    return ast;
};

void bel_free_ast(bel_ast* ast) {
    if (!ast) {
        return;
    }
    bel_free_ast_node(ast->root);
    free(ast);
};

void bel_free_ast_node(bel_ast_node* node) {
    if(!node) {
        return;
    }
    if (node->type_info->type == BEL_TOKEN) {
        if (node->token->left != NULL) {
            bel_free_ast_node(node->token->left);
        }
        if (node->token->right != NULL) {
            bel_free_ast_node(node->token->right);
        }
        free(node->token);
    } else {
        free(node->value->value);
        free(node->value);
    }

    free(node);
};

void bel_print_ast_node(bel_ast_node* node, char* tree_flat_string) {
    char val[1024 * 32];
    if (node == NULL) {
        strcat(tree_flat_string, "(null) ");
        return;
    }

    switch(node->type_info->type) {
        case BEL_TOKEN:
            switch(node->type_info->ttype) {
				case BEL_TOKEN_NULL:
					sprintf(val, "NULL[%d] ", node->token->is_complete);
                    strcat(tree_flat_string, val);
                    break;
                case BEL_TOKEN_ARG:
					sprintf(val, "ARG[%d] ", node->token->is_complete);
                    strcat(tree_flat_string, val);
                    break;
                case BEL_TOKEN_NV:
					sprintf(val, "NV[%d][%d, %d] ",
							node->token->is_complete,
							node->token->start_position,
							node->token->end_position);
                    strcat(tree_flat_string, val);
                    break;
                case BEL_TOKEN_TERM:
					sprintf(val, "TERM[%d][%d, %d] ",
							node->token->is_complete,
							node->token->start_position,
							node->token->end_position);
                    strcat(tree_flat_string, val);
                    break;
				case BEL_TOKEN_SUBJECT:
					sprintf(val, "SUBJECT[%d] ", node->token->is_complete);
                    strcat(tree_flat_string, val);
                    break;
				case BEL_TOKEN_REL:
					sprintf(val, "REL[%d] ", node->token->is_complete);
                    strcat(tree_flat_string, val);
                    break;
				case BEL_TOKEN_OBJECT:
					sprintf(val, "OBJECT[%d] ", node->token->is_complete);
                    strcat(tree_flat_string, val);
                    break;
                case BEL_TOKEN_STATEMENT:
					sprintf(val, "STATEMENT[%d] ", node->token->is_complete);
                    strcat(tree_flat_string, val);
                    break;
            };
            bel_print_ast_node(node->token->left, tree_flat_string);
            bel_print_ast_node(node->token->right, tree_flat_string);
            break;
        case BEL_VALUE:
            switch(node->type_info->vtype) {
                case BEL_VALUE_FX:
					if (node->value->value == NULL) {
						strcat(tree_flat_string, "fx((null)) ");
					} else {
						sprintf(val, "fx(%s)[%d, %d] ", node->value->value,
								node->value->start_position,
								node->value->end_position);
						strcat(tree_flat_string, val);
					}
                    break;
                case BEL_VALUE_REL:
					if (node->value->value == NULL) {
						strcat(tree_flat_string, "rel((null)) ");
					} else {
						sprintf(val, "rel(%s)[%d, %d] ",
								node->value->value,
								node->value->start_position,
								node->value->end_position);
						strcat(tree_flat_string, val);
					}
                    break;
                case BEL_VALUE_PFX:
					if (node->value->value == NULL) {
						strcat(tree_flat_string, "pfx((null)) ");
					} else {
						sprintf(val, "pfx(%s)[%d, %d] ",
								node->value->value,
								node->value->start_position,
								node->value->end_position);
						strcat(tree_flat_string, val);
					}
                    break;
                case BEL_VALUE_VAL:
					if (node->value->value == NULL) {
						strcat(tree_flat_string, "val((null)) ");
					} else {
						sprintf(val, "val(%s)[%d, %d] ",
								node->value->value,
								node->value->start_position,
								node->value->end_position);
						strcat(tree_flat_string, val);
					}
                    break;
            };
            break;
    };
};

void bel_print_ast(bel_ast* ast) {
    char tree_flat_string[1024 * 32];

    if (!ast) {
        return;
    }

    memset(tree_flat_string, '\0', 1024 * 32);
    bel_print_ast_node(ast->root, tree_flat_string);
    fprintf(stdout, "%s\n", tree_flat_string);
};

char* bel_ast_as_string(bel_ast* ast) {
    char *tree_flat_string;

    if (!ast) {
        return NULL;
    }

    tree_flat_string = calloc(1024 * 32, 1);
    bel_print_ast_node(ast->root, tree_flat_string);
    return tree_flat_string;
};

char* bel_ast_node_as_string(bel_ast_node* node) {
    char *tree_flat_string;

    if (!node) {
        return NULL;
    }

    tree_flat_string = calloc(1024 * 32, 1);
    bel_print_ast_node(node, tree_flat_string);
    return tree_flat_string;
};
