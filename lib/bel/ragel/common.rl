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

  SP = ' ';
  IDENT = [a-zA-Z0-9]+;
  STRING = '"' ([^"] | '\\\"')* '"';
}%%
=end
