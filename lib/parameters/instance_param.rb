module Parameters
  class InstanceParam < Param

    # Owning object
    attr_reader :object

    #
    # Creates a new InstanceParam object with the specified _object_ and
    # _name_, and the given _description_.
    #
    def initialize(object,name,description=nil)
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
    # Returns a String representation of the instance param.
    #
    def to_s
      text = "  #{@name}"

      text << " [#{value.inspect}]" if value
      text << "\t#{@description}" if @description

      return text
    end

    #
    # Inspects the instance params value.
    #
    def inspect
      value.inspect
    end

  end
end
