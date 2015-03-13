#include "bel-ast.h"
#include "bel-token.h"

#ifndef _BEL_PARSER_H
#define _BEL_PARSER_H

bel_ast* bel_parse_term(char* line);

bel_ast* bel_parse_statement(char* line);

bel_token_list* bel_tokenize_term(char* line);

#endif /* not defined _BEL_PARSER_H */
