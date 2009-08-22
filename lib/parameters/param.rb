module Parameters
  class Param

    # Name of parameter
    attr_reader :name

    # Description of parameter
    attr_reader :description

    #
    # Creates a new Param object with the specified _name_ and the given
    # _description_.
    #
    # @param [Symbol, String] name the name of the parameter.
    # @param [String, nil] description the description of the parameter.
    #
    def initialize(name,description=nil)
      @name = name.to_sym
      @description = description
    end

  end
end
