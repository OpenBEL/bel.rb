#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "bel-token.h"

bel_token* bel_new_token(bel_token_type type, char* input, char* ts, char* te) {
    bel_token *new_token;
    int       length;
    char      *match_copy;

    new_token = malloc(sizeof(bel_token));
    new_token->type = type;
    new_token->pos_start = ts - input;
    new_token->pos_end   = te - input;

    length = te - ts;
    match_copy = malloc(length + 1);
    strncpy(match_copy, ts, length);
    match_copy[length] = '\0';
    new_token->value = match_copy;
    return new_token;
};

bel_token_list* bel_new_token_list(int length) {
    bel_token_list       *list;
    list               = malloc(sizeof(bel_token_list));
    list->length       = length;
    list->tokens       = calloc(length, sizeof(bel_token));
    return list;
};

bel_token_iterator* bel_new_token_iterator(bel_token_list *list) {
    bel_token_iterator *iterator;
    bel_token *tokens;

    if (!list) {
        return NULL;
    }

    tokens  = list->tokens;

    iterator = malloc(sizeof(bel_token_iterator));
    iterator->index         = 0;
    iterator->list          = list;
    iterator->current_token = &tokens[0];
    return iterator;
};

bel_token* bel_token_iterator_get(bel_token_iterator *iterator) {
    if (!iterator) {
	      return NULL;
    }
    return iterator->current_token;
};

void bel_token_iterator_next(bel_token_iterator *iterator) {
    bel_token *tokens;

    if (!iterator || !iterator->list) {
	      return;
    }

    tokens = iterator->list->tokens;
    iterator->current_token = &tokens[++iterator->index];
};

int bel_token_iterator_end(bel_token_iterator *iterator) {
    if (!iterator || !(iterator->list)) {
	      return 1;
    }
    return (iterator->index < iterator->list->length) ? 0 : 1;
};

void bel_print_token(bel_token* token) {
    if (!token) {
	      return;
    }

    switch(token->type) {
    case IDENT:
        fprintf(stdout, "IDENT(\"%s\", %d, %d) ", token->value, token->pos_start, token->pos_end);
        break;
    case STRING:
        fprintf(stdout, "STRING(\"%s\", %d, %d) ", token->value, token->pos_start, token->pos_end);
        break;
    case O_PAREN:
        fprintf(stdout, "O_PAREN(\"%s\", %d, %d) ", token->value, token->pos_start, token->pos_end);
        break;
    case C_PAREN:
        fprintf(stdout, "C_PAREN(\"%s\", %d, %d) ", token->value, token->pos_start, token->pos_end);
        break;
    case COLON:
        fprintf(stdout, "COLON(\"%s\", %d, %d) ", token->value, token->pos_start, token->pos_end);
        break;
    case COMMA:
        fprintf(stdout, "COMMA(\"%s\", %d, %d) ", token->value, token->pos_start, token->pos_end);
        break;
    case SPACES:
        fprintf(stdout, "SPACES(\"%s\", %d, %d) ", token->value, token->pos_start, token->pos_end);
        break;
    };
};

void bel_print_token_list(bel_token_list* token_list) {
    bel_token *tokens;
    bel_token *next;
    int       token_i;
    int       list_length;

    if (!token_list) {
        return;
    }

    tokens  = token_list->tokens;
    list_length = token_list->length;
    for (token_i = 0; token_i < list_length; token_i++) {
        next = &tokens[token_i];
        bel_print_token(next);
    }
    fprintf(stdout, "\n");
};

void free_bel_token(bel_token* token) {
    if (!token) {
        return;
    }
    if (token->value) {
        free(token->value);
    }
};

void free_bel_token_list(bel_token_list* token_list) {
    int       token_i;
    int       list_length;
    bel_token *next;

    if (!token_list) {
        return;
    }

    list_length = token_list->length;
    for (token_i = 0; token_i < list_length; token_i++) {
        next = &token_list->tokens[token_i];
        if (!next && next->value) {
            free(next->value);
        }
	// FIXME Memory leak, cannot free, yields, "free(): invalid size"
  //    free(next);
    }

    free(token_list->tokens);
    free(token_list);
};

void free_bel_token_iterator(bel_token_iterator *iterator) {
    if (!iterator) {
        return;
    }
    free(iterator);
};

