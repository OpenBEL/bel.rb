=begin
%%{
machine bel;

  action return {fret;}
  action hold {fhold;}

  action s {
    buffer = []
  }

  action n {
    buffer << fc
  }

  action name {
    @name = buffer.map(&:chr).join()
  }

  action val {
    if buffer[0] == 34 && buffer[-1] == 34
      buffer = buffer[1...-1]
    end
    @value = buffer.map(&:chr).join().gsub '\"', '"'
  }

  action lists {
    listvals = []
    listbuffer = []
  }

  action listn {
    listbuffer << fc
  }

  action liste {
    listvals << listbuffer.map(&:chr).join()
    listbuffer = []
  }

  action listv {
    @value = listvals
  }

  SP = ' ';
  IDENT = [a-zA-Z0-9]+;
  STRING = '"' ([^"] | '\\\"')* '"';
  LIST = '{' @lists SP*
         (STRING | IDENT) $listn SP*
         (',' @liste SP* (STRING | IDENT) $listn SP*)*
         '}' @liste @listv;
}%%
=end
