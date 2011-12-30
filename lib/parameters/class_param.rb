require 'parameters/param'

module Parameters
  class ClassParam < Param

    #
    # Creates a new ClassParam object.
    #
    # @param [Class] base_class
    #   The Class the ClassParam was defined in.
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
    def initialize(base_class,name,type=nil,description=nil,value=nil)
      super(base_class,name,type,description)

      self.value = value
    end

    #
    # Sets the value of the class param.
    #
    # @param [Proc, Object] value
    #   The new value of the class param.
    #
    # @return [Object]
    #   The new value of the class param.
    #
    # @since 0.5.0
    #
    def value=(value)
      case value
      when Proc
        super(value)
      else
        super(coerce(value))
      end
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
        self.value
      )
    end

  end
end
