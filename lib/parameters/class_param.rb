require 'parameters/param'

module Parameters
  class ClassParam < Param

    # Default value of the class parameter
    attr_reader :value

    #
    # Creates a new ClassParam object.
    #
    # @param [Symbol, String] name
    #   The name of the class parameter.
    #
    # @param [Class, Array[Class]] type
    #   The enforced type of the class parameter.
    #
    # @param [String, nil] description
    #   The description of the class parameter.
    #
    # @param [Object, nil] value
    #   The default value of the class parameter.
    #
    def initialize(name,type=nil,description=nil,value=nil)
      super(name,type,description)

      @value = value
    end

    #
    # Sets the value of the class param.
    #
    # @param [Object] new_value
    #   The new value of the class param.
    #
    # @return [Object]
    #   The new value of the class param.
    #
    # @since 0.2.0
    #
    def value=(new_value)
      @value = coerce(new_value)
    end

    #
    # Creates an instance parameter from the class param.
    #
    # @param [Object] object
    #   The object the instance parameter should be connected to.
    #
    # @return [InstanceParam]
    #   The new instance parameter.
    #
    # @since 0.3.0
    #
    # @api semipublic
    #
    def to_instance(object)
      InstanceParam.new(
        object,
        @name,
        @type,
        @description,
        @value
      )
    end

    #
    # @return [String]
    #   The representation of the class param.
    #
    def to_s
      text = @name.to_s

      text << "\t[#{@value.inspect}]" if @value
      text << "\t#{@description}"     if @description

      return text
    end

    #
    # Inspects the class parameter.
    #
    # @return [String]
    #   Inspection of the class params value.
    #
    def inspect
      "#<#{self.class}: #{@value.inspect}>"
    end

  end
end
