# vim: ts=2 sw=2:
module BEL
  autoload :Language,  "#{File.dirname(__FILE__)}/bel/language"
  autoload :Namespace, "#{File.dirname(__FILE__)}/bel/namespace"
  autoload :Script,    "#{File.dirname(__FILE__)}/bel/script"
end
