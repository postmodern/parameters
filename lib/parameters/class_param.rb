require 'parameters/param'

module Parameters
  class ClassParam < Param

    # Default value of the class parameter
    attr_accessor :value

    #
    # Creates a new ClassParam object with the specified _name_,
    # given _description_ and _value_.
    #
    def initialize(name,description=nil,value=nil)
      super(name,description)

      @value = value
    end

    #
    # Returns the String representation of the class param.
    #
    def to_s
      text = "  #{@name}"

      text << " [#{@value.inspect}]" if @value
      text << "\t#{@description}" if @description

      return text
    end

    #
    # Inspects the class params value.
    #
    def inspect
      @value.inspect
    end

  end
end
