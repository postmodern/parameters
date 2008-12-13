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

  end
end
