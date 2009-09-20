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
    # @example
    #   Parser.parse_value("0x1")
    #   # => 1
    #
    # @example
    #   Parser.parse_value("'mesg'")
    #   # => "mesg"
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
    # @example
    #   Parser.parse_param('var=2')
    #   # => {:var=>2}
    #
    # @since 0.1.8
    #
    def Parser.parse_param(name_and_value)
      name, value = name_and_value.split('=',2)

      value = Parser.parse_value(value) if value
      return {name.to_sym => value}
    end

    #
    # Parses one or more parameter strings of the form +name=value+.
    #
    # @param [Array<String>] names_and_values
    #   The names and values of the parameters, joined by the +=+
    #   character.
    #
    # @return [Hash]
    #   The names and values of the parameters.
    #
    # @example
    #   Parser.parse(["x=2", "y=true"])
    #   # => {:x=>2, :y=>true}
    #
    def Parser.parse(names_and_values)
      params = {}

      names_and_values.each do |name_and_value|
        params.merge!(Parser.parse_param(name_and_value))
      end

      return params
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
