require 'parameters/param'

module Parameters
  class ClassParam < Param

    # Default value of the class parameter
    attr_accessor :value

    #
    # Creates a new ClassParam object with the specified _name_,
    # given _description_ and _value_.
    #
    # @param [Symbol, String] name
    #   The name of the class parameter.
    #
    # @param [String, nil] description
    #   The description of the class parameter.
    #
    # @param [Object, nil] value
    #   The default value of the class parameter.
    #
    def initialize(name,description=nil,value=nil)
      super(name,description)

      @value = value
    end

    #
    # @return [String]
    #   The representation of the class param.
    #
    def to_s
      text = "  #{@name}"

      text << " [#{@value.inspect}]" if @value
      text << "\t\t#{@description}" if @description

      return text
    end

    #
    # @return [String]
    #   Inspection of the class params value.
    #
    def inspect
      @value.inspect
    end

  end
end
