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
    def initialize(name,description='')
      @name = name.to_sym
      @description = description
    end

  end
end
