require 'parameters/param'

module Parameters
  class InstanceParam < Param

    # Owning object
    alias object context

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
    # @api semipublic
    #
    def initialize(object,name,type=nil,description=nil,value=nil)
      super(object,name,type,description)

      if (self.value.nil? && value)
        self.value = case value
                     when Proc
                       if value.arity > 0
                         value.call(object)
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
    # Sets the value of the instance param.
    #
    # @param [Object] value
    #   The new value of the instance param.
    #
    # @return [Object]
    #   The new value of the instance param.
    #
    # @since 0.5.0
    #
    def value=(value)
      super(coerce(value))
    end

  end
end
