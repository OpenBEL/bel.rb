/*
 * Parses BEL terms.
 */
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "bel-parser.h"

#define LINE_CHAR_LEN 1024 * 32 // 32 kilobytes

int main(int argc, char *argv[]) {
    FILE *input;
    char line[LINE_CHAR_LEN];
    int type;
    int print;
    int verbose;
    bel_ast* tree;
    bel_token_list* token_list;

    if (argc == 2) {
        type = 0;
        if (strcmp(argv[1], "tk") == 0) {
            type = 1;
            input = stdin;
        } else {
            input = fopen(argv[1], "rb");
        }
    } else if (argc == 3) {
        if (strcmp(argv[1], "tk") == 0) {
            type = 1;
        } else {
            type = 0;
        }
        input = fopen(argv[2], "rb");
    } else {
        type = 0;
        input = stdin;
    }

    print = 0;
    if (getenv("AST_PRINT") != NULL) {
        print = 1;
    }

    verbose = 0;
    if (getenv("AST_VERBOSE") != NULL) {
        verbose = 1;
    }

    while (fgets(line, LINE_CHAR_LEN, input) != NULL) {
        if (verbose) {
            fprintf(stdout, "parsing line -> %s\n", line);
        }

        if (type == 0) {
            if (verbose) {
                fprintf(stdout, "using expression parser\n");
            }
            tree = bel_parse_term(line);

            if (!tree->root) {
                fprintf(stderr, "parse failed\n");
            }

            if (print) {
                bel_print_ast(tree);
            }
            bel_free_ast(tree);
        } else if (type == 1) {
            if (verbose) {
                fprintf(stdout, "using term tokenizer\n");
            }
            token_list = bel_tokenize_term(line);
            bel_print_token_list(token_list);
            free_bel_token_list(token_list);
        }
    }
    fclose(input);
    return 0;
}
// vim: ft=c sw=4 ts=4 sts=4 expandtab
