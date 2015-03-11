#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "bel-token.h"

static const int  set_start  = 1;
static const int  set_first_final  = 1;
static const int  set_error  = 0;
static const int  set_en_term  = 1;
bel_token_list* bel_tokenize_term(char* line) {
    int                  cs;
    char                 *p;
    char                 *pe;
    char                 *ts;
    char                 *te;
    char                 *eof;
    int                  token_i;
    bel_token_list       *token_list;
    bel_token            *tokens;
    bel_token            *new_token;

    p                  = line;
    pe                 = line + strlen(line);
    eof                = pe;
    token_i            = 0;
    token_list         = bel_new_token_list(256);
    tokens             = token_list->tokens;

    
	{
	cs = set_start;
ts = 0;
te = 0;
}

	{
	if ( p == pe  )
	goto _test_eof;
	
switch ( cs  ) {
	case 1:
goto st_case_1;
	case 0:
goto st_case_0;
	case 2:
goto st_case_2;
	case 3:
goto st_case_3;
	case 4:
goto st_case_4;
	case 5:
goto st_case_5;
	
}
goto st_out;
ctr3:
	{{te = p+1;
{new_token = bel_new_token(O_PAREN, line, ts, te);
            tokens[token_i++] = *new_token;
        }
}}


	goto st1;
ctr4:
	{{te = p+1;
{new_token = bel_new_token(C_PAREN, line, ts, te);
            tokens[token_i++] = *new_token;
        }
}}


	goto st1;
ctr5:
	{{te = p+1;
{new_token = bel_new_token(COMMA, line, ts, te);
            tokens[token_i++] = *new_token;
        }
}}


	goto st1;
ctr7:
	{{te = p+1;
{new_token = bel_new_token(COLON, line, ts, te);
            tokens[token_i++] = *new_token;
        }
}}


	goto st1;
ctr8:
	{{te = p;
p = p - 1;
{new_token = bel_new_token(SPACES, line, ts, te);
            tokens[token_i++] = *new_token;
        }
}}


	goto st1;
ctr9:
	{{te = p;
p = p - 1;
{new_token = bel_new_token(STRING, line, ts, te);
            tokens[token_i++] = *new_token;
        }
}}


	goto st1;
ctr10:
	{{te = p+1;
{new_token = bel_new_token(STRING, line, ts, te);
            tokens[token_i++] = *new_token;
        }
}}


	goto st1;
ctr12:
	{{te = p;
p = p - 1;
{new_token = bel_new_token(IDENT, line, ts, te);
            tokens[token_i++] = *new_token;
        }
}}


	goto st1;
st1:
	{{ts = 0;
}}

	p+= 1;
if ( p == pe  )
	goto _test_eof1;

st_case_1:
	{{ts = p;
}}
switch ( ( (*( p  ))
)  ) {
	case 32:
{
goto st2;
	}
		 case 34:
{
goto st3;
	}
		 case 40:
{
goto ctr3;
	}
		 case 41:
{
goto ctr4;
	}
		 case 44:
{
goto ctr5;
	}
		 case 58:
{
goto ctr7;
	}
		 case 95:
{
goto st5;
	}
	
}
if ( ( (*( p  ))
) < 65  )
	{
		if ( 48 <= ( (*( p  ))
) && ( (*( p  ))
) <= 57  )
	{
			goto st5;
		}
	
} 
else if ( ( (*( p  ))
) > 90  )
	{
		if ( 97 <= ( (*( p  ))
) && ( (*( p  ))
) <= 122  )
	{
			goto st5;
		}
	
} 
else
	{
		goto st5;
	}

{
	goto st0;
}
st_case_0:
st0:
cs = 0;
goto _out;
st2:
	p+= 1;
if ( p == pe  )
	goto _test_eof2;

st_case_2:
	if ( ( (*( p  ))
) == 32  )
	{
		goto st2;
	}
	
if ( 33 <= ( (*( p  ))
)  )
	{
		goto ctr8;
	}

{
	goto ctr8;
}
st3:
	p+= 1;
if ( p == pe  )
	goto _test_eof3;

st_case_3:
	switch ( ( (*( p  ))
)  ) {
	case 34:
{
goto ctr10;
	}
		 case 92:
{
goto st4;
	}
	
}
if ( ( (*( p  ))
) > 91  )
	{
		if ( 93 <= ( (*( p  ))
)  )
	{
			goto st3;
		}
	
} 
else if ( ( (*( p  ))
) >= 35  )
	{
		goto st3;
	}

{
	goto st3;
}
st4:
	p+= 1;
if ( p == pe  )
	goto _test_eof4;

st_case_4:
	if ( ( (*( p  ))
) == 92  )
	{
		goto st4;
	}
	
if ( 93 <= ( (*( p  ))
)  )
	{
		goto st3;
	}

{
	goto st3;
}
st5:
	p+= 1;
if ( p == pe  )
	goto _test_eof5;

st_case_5:
	switch ( ( (*( p  ))
)  ) {
	case 95:
{
goto st5;
	}
		 case 96:
{
goto ctr12;
	}
	
}
if ( ( (*( p  ))
) < 65  )
	{
		if ( ( (*( p  ))
) > 57  )
	{
			{
				goto ctr12;
			}
		} 
else if ( ( (*( p  ))
) >= 48  )
	{
			goto st5;
		}
	
} 
else if ( ( (*( p  ))
) > 90  )
	{
		if ( ( (*( p  ))
) < 97  )
	{
			if ( ( (*( p  ))
) <= 94  )
	{
				goto ctr12;
			}
		
} 
else if ( ( (*( p  ))
) > 122  )
	{
			{
				goto ctr12;
			}
		} 
else
	{
			goto st5;
		}
	
} 
else
	{
		goto st5;
	}

{
	goto ctr12;
}
	st_out:
	_test_eof1: cs = 1;
goto _test_eof; 
	_test_eof2: cs = 2;
goto _test_eof; 
	_test_eof3: cs = 3;
goto _test_eof; 
	_test_eof4: cs = 4;
goto _test_eof; 
	_test_eof5: cs = 5;
goto _test_eof; 

	_test_eof: {}
	if ( p == eof  )
	{
	switch ( cs  ) {
	case 2:
goto ctr8;
	case 3:
goto ctr9;
	case 4:
goto ctr9;
	case 5:
goto ctr12;
	
}
}

	
_out: {}
	}
token_list->length = token_i;
    return token_list;
};
// vim: ft=c sw=4 ts=4 sts=4 expandtab

