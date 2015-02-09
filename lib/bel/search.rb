module BEL
  module Search

    def self.use(name, options = {})
      case name
      when :sqlite3
        require_relative 'search/sqlite3'
        Sqlite3FTS.new(options)
      when :remote_api
        require_relative 'search/remote_api'
      else
        fail ArgumentError.new("The #{name} implementation does not exist.")
      end
    end
  end
end
