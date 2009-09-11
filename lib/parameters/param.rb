module Parameters
  class Param

    # Name of parameter
    attr_reader :name

    # Description of parameter
    attr_reader :description

    #
    # Creates a new Param object.
    #
    # @param [Symbol, String] name
    #   The name of the parameter.
    #
    # @param [String, nil] description
    #   The description of the parameter.
    #
    def initialize(name,description=nil)
      @name = name.to_sym
      @description = description
    end

  end
end
