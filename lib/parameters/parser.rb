require 'uri'

module Parameters
  module Parser
    #
    # @return [Array]
    #   The parameter patterns and their parsers.
    #
    def Parser.formats
      @@parameters_parser_formats ||= []
    end

    #
    # Itereates over each parameter pattern and parser.
    #
    # @yield [pattern, parser]
    #   The block will be passed each parameter pattern and the associated
    #   parser.
    #
    # @yieldparam [Regexp, String] pattern
    #   The pattern to match recognize parameter values with.
    #
    # @yieldparam [Proc] parser
    #   The parser for the parameter value.
    #
    def Parser.each_format(&block)
      Parser.formats.each do |format|
        block.call(format[:pattern],format[:parser])
      end
    end

    #
    # Adds a new parameter parser.
    #
    # @param [Regexp, String] pattern
    #   The pattern to recognize parameter values with.
    #
    # @yield [value]
    #   The block will be used as the parser for the recognized parameter
    #   values.
    #
    # @yieldparam [String] value
    #   The parameter value to parser.
    #
    def Parser.recognize(pattern,&block)
      Parser.formats.unshift({
        :pattern => pattern,
        :parser => block
      })
    end

    #
    # Recognizes and parses the given parameter value.
    #
    # @param [String] value
    #   The parameter value to parse.
    #
    # @return [Object]
    #   The parsed parameter value.
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
    # Parses the a parameter string of the form +name=value+.
    #
    # @param [String] name_and_value
    #   The name and value parameter join with a +=+ character.
    #
    # @return [Hash{Symbol => Object}]
    #   A singleton Hash containing the parameter name and it's value.
    #
    # @since 0.1.8
    #
    def Parser.parse(name_and_value)
      name, value = name_and_value.split('=',2)

      value = Parser.parse_value(value) if value
      return {name.to_sym => value}
    end

    Parser.recognize(/^'(\\'|[^'])+'/) { |value|
      value[1...-1].gsub("\\'","'")
    }
    Parser.recognize(/^[a-zA-Z][a-zA-Z0-9]*:\/\//) { |value| URI(value) }
    Parser.recognize('false') { |value| false }
    Parser.recognize('true') { |value| true }
    Parser.recognize(/^[0-9]+$/) { |value| value.to_i }
    Parser.recognize(/^0[0-7]+$/) { |value| value.oct }
    Parser.recognize(/^0x[0-9a-fA-F]+$/) { |value| value.hex }

  end
end
