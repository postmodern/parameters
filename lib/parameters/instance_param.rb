require 'parameters/param'

module Parameters
  class InstanceParam < Param

    # Owning object
    attr_reader :object

    #
    # Creates a new InstanceParam object.
    #
    # @param [Object] object
    #   The object containing the instance variable for the instance
    #   parameter.
    #
    # @param [Symbol, String] name
    #   The name of the instance parameter.
    #
    # @param [Class, Array[Class]] type
    #   The enforced type of the instance parameter.
    #
    # @param [String, nil] description
    #   The description of the instance parameter.
    #
    # @param [Object] value
    #   The initial value for the instance parameter.
    #
    def initialize(object,name,type=nil,description=nil,value=nil)
      super(name,type,description)

      @object = object

      if (self.value.nil? && value)
        self.value = case value
                     when Proc
                       if value.arity > 0
                         value.call(@object)
                       else
                         value.call()
                       end
                     else
                       begin
                         value.clone
                       rescue TypeError
                         value
                       end
                     end
      end
    end

    #
    # @return
    #   The value of the instance param.
    #
    def value
      @object.instance_variable_get(:"@#{@name}")
    end

    #
    # Sets the value of the instance param.
    #
    # @param [Object] value
    #   The new value of the instance param.
    #
    # @return [Object]
    #   The new value of the instance param.
    #
    def value=(value)
      @object.instance_variable_set(:"@#{@name}",coerce(value))
    end

    #
    # @return [String]
    #   Representation of the instance param.
    #
    def to_s
      text = @name.to_s

      text << " [#{value.inspect}]" if value
      text << "\t#{@description}"   if @description

      return text
    end

    #
    # Inspects the instance parameter.
    #
    # @return [String]
    #   Inspection of the instance params value.
    #
    def inspect
      "#<#{self.class}: #{value.inspect}>"
    end

  end
end
