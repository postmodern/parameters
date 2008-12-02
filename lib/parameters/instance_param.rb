module Parameters
  class InstanceParam < Param

    # Owning object
    attr_reader :object

    #
    # Creates a new InstanceParam object with the specified _object_ and
    # _name_, and the given _description_.
    #
    def initialize(object,name,description='')
      super(name,description)

      @object = object
    end

    #
    # Returns the value of the instance param.
    #
    def value
      @object.instance_variable_get("@#{@name}")
    end

    #
    # Sets the value of the instance param.
    #
    def value=(value)
      @object.instance_variable_set("@#{@name}",value)
    end

    #
    # Inspects the instance params value.
    #
    def inspect
      value.inspect
    end

  end
end
