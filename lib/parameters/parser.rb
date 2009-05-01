require 'uri'

module Parameters
  module Parser
    #
    # The Array of parameter patterns and their parsers.
    #
    def Parser.formats
      @@ronin_param_formats ||= []
    end

    #
    # Itereates over each parameter pattern and parser, passing them to the
    # specified _block_.
    #
    def Parser.each_format(&block)
      Parser.formats.each do |format|
        block.call(format[:pattern],format[:parser])
      end
    end

    #
    # Adds a new parameter _pattern_ using the specified _block_ as the
    # parser.
    #
    def Parser.recognize(pattern,&block)
      Parser.formats.unshift({
        :pattern => pattern,
        :parser => block
      })
    end

    #
    # Parses the specified _value_ string and returns the native Ruby value.
    # If the _value_ matches one of the patterns within +FORMATS+,
    # then the associated parser will be used to parse the _value_.
    #
    def Parser.parse_value(value)
      Parser.each_format do |pattern,parser|
        if value.match(pattern)
          return parser.call(value)
        end
      end

      return value
    end

    #
    # Parses the specified _name_and_value_ string of the form
    # "name=value" and extracts both the _name_ and the _value_, saving
    # both the _name_ and _value_ within the +params+ Hash. If the
    # extracted _value_ matches one of the patterns within +FORMATS+,
    # then the associated parser will first parse the _value_.
    #
    def Parser.parse_param(name_and_value)
      name, value = name_and_value.split('=',2)

      value = Parser.parse_value(value) if value
      return {name.to_sym => value}
    end

    Parser.recognize(/^'(\\'|[^'])+'/) { |value| value[1...-1].gsub("\\'","'") }
    Parser.recognize(/^[a-zA-Z][a-zA-Z0-9]*:\/\//) { |value| URI(value) }
    Parser.recognize('false') { |value| false }
    Parser.recognize('true') { |value| true }
    Parser.recognize(/^0x[0-9a-fA-F]+$/) { |value| value.hex }
    Parser.recognize(/^0[0-7]+$/) { |value| value.oct }
    Parser.recognize(/^[0-9]+$/) { |value| value.to_i }

  end
end
