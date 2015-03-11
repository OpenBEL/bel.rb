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
    int len;
    char line[LINE_CHAR_LEN];
    int type;

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

    int print = 0;
    if (getenv("AST_PRINT") != NULL) {
        print = 1;
    }

    int verbose = 0;
    if (getenv("AST_VERBOSE") != NULL) {
        verbose = 1;
    }

    if (argc > 1) {
    }

    while (fgets(line, LINE_CHAR_LEN, input) != NULL) {
        // force newline if statement ends with closed paren; aids parser
        len = strlen(line);
        if (line[len - 1] == ')') {
            line[len - 1] = '\n';
        }

        if (verbose) {
            fprintf(stdout, "parsing line -> %s\n", line);
        }

        if (type == 0) {
            if (verbose) {
                fprintf(stdout, "using default statement parser\n");
            }
            bel_ast* tree = bel_parse_statement(line);

            if (!tree->root) {
                fprintf(stderr, "parse failed\n");
            }

            if (print) {
                bel_print_ast(tree);
            }
            bel_free_ast(tree);
        } else if (type == 1) {
            if (verbose) {
                fprintf(stdout, "using lookahead term parser\n");
            }
            bel_token_list* token_list = bel_tokenize_term(line);
            bel_print_token_list(token_list);
            free_bel_token_list(token_list);
        }
    }
    fclose(input);
    return 0;
}
// vim: ft=c sw=4 ts=4 sts=4 expandtab
