require 'parameters/exceptions/param_not_found'
require 'parameters/param'

module Parameters
  #
  # @since 0.5.0
  #
  class ParamSet

    #
    # Initializes the Param Set.
    #
    # @param [ParamSet] parent_set
    #   The optional parent Set to merge into the new Param Set.
    #
    # @api private
    #
    def initialize(parent_set=nil)
      @set = {}

      if parent_set
        parent_set.each { |param| self << param }
      end
    end

    #
    # Determines if the Set contains a specific parameter.
    #
    # @param [Symbol, String] name
    #   The name of the parameter.
    #
    # @return [Boolean]
    #   Specifies whether the Set contains the parameter.
    #
    # @api public
    # 
    def has?(name)
      @set.has_key?(name.to_sym)
    end

    #
    # Gets a parameter from the Set.
    #
    # @param [Symbol, String] name
    #   The name of the parameter.
    #
    # @return [Param]
    #   The parameter from the Set.
    #
    # @raise [ParamNotFound]
    #   The parameter could not be found in the Set.
    #
    # @api public
    #
    def get(name)
      name = name.to_sym

      unless @set.has_key?(name)
        raise(ParamNotFound,"unknown parameter: #{name}")
      end

      return @set[name]
    end

    #
    # Determines if the parameter has a value.
    #
    # @return [Boolean]
    #   Specifies if the parameter has a value yet.
    #
    # @api public
    #
    def set?(name)
      get(name).value?
    end

    #
    # Sets the value of a parameter in the Set.
    #
    # @param [String, Symbol] name
    #   The name of the parameter in the Set.
    #
    # @param [Object] value
    #   The new value for the parameter.
    #
    # @raise [ParamNotFound]
    #   The parameter could not be found in the Set.
    #
    # @api public
    #
    def set(name,value)
      get(name).value = value
    end

    #
    # Finds the description for a parameter in the Set.
    #
    # @param [String, Symbol] name
    #   The name of the parameter in the Set.
    #
    # @return [String, nil]
    #   The description of the parameter in the Set.
    #
    # @raise [ParamNotFound]
    #   The parameter could not be found in the Set.
    #
    # @api public
    #
    def describe(name)
      get(name).description
    end

    #
    # Enumerates the parameters in the Set.
    #
    # @yield [(name,) param]
    #   The given block may be passed the name and the parameter.
    #
    # @yieldparam [Symbol] name
    #   The name of the parameter.
    #
    # @yieldparam [Param] param
    #   A parameter from the Set.
    #
    # @return [ParamSet]
    #
    # @api public
    #
    def each(&block)
      return enum_for unless block

      if block.arity == 1
        @set.each_value(&block)
      else
        @set.each(&block)
      end

      return self
    end

    #
    # Updates the values of the parameter Set.
    #
    # @param [Hash{String,Symbol => Param,Object}] values
    #   The new values for the parameters.
    #
    # @return [ParamSet]
    #   The updated parameter Set.
    #
    # @api public
    #
    def update(values={})
      values.each do |name,value|
        if has?(name)
          self[name] = case value
                       when Param
                         value.value
                       else
                         value
                       end
        end
      end

      return self
    end

    #
    # Determines if the parameter Set is empty.
    #
    # @return [Boolean]
    #   Specifies whether the parameter Set is empty.
    #
    # @api public
    #
    def empty?
      @set.empty?
    end

    #
    # The number of parameters in the Set.
    #
    # @return [Integer]
    #   The number of parameters in the Set.
    #
    # @api public
    #
    def size
      @set.size
    end

    alias length size

    #
    # Gets the value of a parameter from the Set.
    #
    # @param [Symbol, String] name
    #   The name of the parameter.
    #
    # @return [Object, nil]
    #   The value of the parameter.
    #
    # @raise [ParamNotFound]
    #   The parameter could not be found in the Set.
    #
    # @api public
    #
    def [](name)
      get(name).value
    end

    alias []= set

    #
    # Adds a new parameter to the Set.
    #
    # @param [Param] param
    #   The new parameter to add to the Set.
    #
    # @return [ParamSet]
    #
    # @api semipublic
    #
    def <<(param)
      @set[param.name] = param
      return self
    end

    #
    # Converts the parameter Set into a Hash.
    #
    # @param [Hash{Symbol => Param}]
    #   The Hash of names and parameters.
    #
    # @api public
    #
    def to_hash
      @set
    end

    #
    # Inspects the parameter set.
    #
    # @return [String]
    #   The inspected parameter set.
    #
    def inspect
      "#<#{self.class}: #{@set.inspect}>"
    end

  end
end
