require 'parameters/types'

module Parameters
  class Param

    # The context the parameter was defined in
    attr_reader :context

    # Name of parameter
    attr_reader :name

    # Enforced type of the parameter
    attr_reader :type

    # Description of parameter
    attr_reader :description

    #
    # Creates a new Param object.
    #
    # @param [Class, Object] context
    #   The context the parameter was defined in.
    #
    # @param [Symbol, String] name
    #   The name of the parameter.
    #
    # @param [Class, nil] type
    #   The enforced type of the parameter.
    #
    # @param [String, nil] description
    #   The description of the parameter.
    #
    # @api semipublic
    #
    def initialize(context,name,type=nil,description=nil)
      @context = context

      @name = name.to_sym
      @type = if (type.kind_of?(Types::Type)) ||
                 (type.kind_of?(Class) && (type < Types::Type))
                type
              else
                Types[type]
              end

      @description = description
    end

    #
    # Coerces the value into the param type.
    #
    # @param [Object] value
    #   The value to coerce.
    #
    # @return [Object]
    #   The coerced value.
    #
    # @api semipublic
    #
    def coerce(value)
      if (value.nil? || (@type === value))
        value
      else
        @type.coerce(value)
      end
    end

    #
    # @return
    #   The value of the param.
    #
    # @since 0.5.0
    #
    def value
      @context.instance_variable_get(:"@#{@name}")
    end

    #
    # Sets the value of the param.
    #
    # @param [Object] value
    #   The new value of the param.
    #
    # @return [Object]
    #   The new value of the param.
    #
    # @since 0.5.0
    #
    def value=(value)
      @context.instance_variable_set(:"@#{@name}",value)
    end

    #
    # @return [String]
    #   Representation of the instance param.
    #
    # @since 0.5.0
    #
    def to_s
      text = @name.to_s

      text << "\t[#{self.value.inspect}]" if self.value
      text << "\t#{@description}"         if @description

      return text
    end

    #
    # Inspects the instance parameter.
    #
    # @return [String]
    #   Inspection of the instance params value.
    #
    # @since 0.5.0
    #
    def inspect
      "#<#{self.class}: #{value.inspect}>"
    end

  end
end
