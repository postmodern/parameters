require 'parameters/types'

module Parameters
  class Param

    # Name of parameter
    attr_reader :name

    # Enforced type of the parameter
    attr_reader :type

    # Description of parameter
    attr_reader :description

    #
    # Creates a new Param object.
    #
    # @param [Symbol, String] name
    #   The name of the parameter.
    #
    # @param [Class] type
    #   The enforced type of the parameter.
    #
    # @param [String, nil] description
    #   The description of the parameter.
    #
    def initialize(name,type=nil,description=nil)
      @name = name.to_sym
      @type = case type
              when Types::Type
                type
              when Class
                if type < Types::Type
                  type
                else
                  Types[type]
                end
              else
                Types[type]
              end

      @description = description
    end

    protected

    #
    # Coerces the value into the param type.
    #
    # @param [Object] value
    #   The value to coerce.
    #
    # @return [Object]
    #   The coerced value.
    #
    def coerce(value)
      if @type === value 
        value
      else
        @type.coerce(value)
      end
    end

  end
end
