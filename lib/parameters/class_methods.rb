require 'parameters/exceptions'
require 'parameters/class_param'
require 'parameters/extensions/meta'

module Parameters
  module ClassMethods
    #
    # @return [Hash]
    #   Parameters for the class.
    #
    def params
      @parameters ||= {}
    end

    #
    # Sets the values of the class parameters.
    #
    # @param [Hash] values
    #   The names and new values to set the class params to.
    #
    # @example
    #   Test.params = {:x => 5, :y => 2}
    #   # => {:x=>5, :y=>2}
    #
    def params=(values)
      values.each do |name,value|
        if has_param?(name)
          get_param(name).value = case value
                                  when Parameters::ClassParam,
                                       Parameters::InstanceParam
                                    value.value
                                  else
                                    value
                                  end
        end
      end
    end

    #
    # Adds a new parameters to the class.
    #
    # @param [Symbol, String] name
    #   The name of the new parameter.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @option options [Class, Array[Class]] :type
    #   The type to enforce the parameter values to.
    #
    # @option options [Object, Proc] :default
    #   The default value for the new parameter.
    #
    # @option options [String] :description
    #   The description for the new parameter.
    #
    # @example
    #   parameter 'var'
    #
    # @example
    #   parameter 'var', :default => 3, :description => 'my variable' 
    #
    def parameter(name,options={})
      name = name.to_sym

      # define the reader class method for the parameter
      meta_def(name) do
        get_param(name).value
      end

      # define the writer class method for the parameter
      meta_def("#{name}=") do |value|
        get_param(name).value = value
      end

      # define the ? method, to determine if the parameter is set
      meta_def("#{name}?") do
        !!get_param(name).value
      end

      # define the reader instance methods for the parameter
      define_method(name) do
        get_param(name).value
      end

      # define the writter instance methods for the parameter
      define_method("#{name}=") do |value|
        get_param(name).value = value
      end

      # define the ? method, to determine if the parameter is set
      define_method("#{name}?") do
        !!get_param(name).value
      end

      # create the new parameter
      new_param = Parameters::ClassParam.new(
        name,
        options[:type],
        options[:description],
        options[:default]
      )

      # add the parameter to the class params list
      params[name] = new_param
      return new_param
    end

    #
    # Determines if a class parameter exists with the given name.
    #
    # @return [Boolean]
    #   Specifies whether or not there is a class parameter with the
    #   specified name.
    #
    def has_param?(name)
      name = name.to_sym

      ancestors.each do |ancestor|
        if ancestor.included_modules.include?(Parameters)
          return true if ancestor.params.has_key?(name)
        end
      end

      return false
    end

    #
    # Searches for the class parameter with the matching name.
    #
    # @param [Symbol, String] name
    #   The class parameter name to search for.
    #
    # @return [ClassParam]
    #   The class parameter with the matching name.
    #
    # @raise [ParamNotFound]
    #   No class parameter with the specified name could be found.
    #
    def get_param(name)
      name = name.to_sym

      ancestors.each do |ancestor|
        if ancestor.included_modules.include?(Parameters)
          if ancestor.params.has_key?(name)
            return ancestor.params[name]
          end
        end
      end

      raise(Parameters::ParamNotFound,"parameter #{name.to_s.dump} was not found in class #{self}")
    end

    #
    # Sets a class parameter.
    #
    # @param [Symbol, String] name
    #   The name of the class parameter.
    #
    # @param [Object] value
    #   The new value for the class parameter.
    #
    # @return [Object]
    #   The new value of the class parameter.
    #
    # @raise [ParamNotfound]
    #   No class parameter with the specified name could be found.
    #
    # @since 0.3.0
    #
    def set_param(name,value)
      name = name.to_sym

      ancestors.each do |ancestor|
        if ancestor.included_modules.include?(Parameters)
          if ancestor.params.has_key?(name)
            return ancestor.params[name].set(value)
          end
        end
      end

      raise(Parameters::ParamNotFound,"parameter #{name.to_s.dump} was not found in class #{self}")
    end

    #
    # Iterates over the parameters of the class and it's ancestors.
    #
    # @yield [param]
    #   The block that will be passed each class parameter.
    #
    def each_param(&block)
      ancestors.reverse_each do |ancestor|
        if ancestor.included_modules.include?(Parameters)
          ancestor.params.each_value(&block)
        end
      end

      return self
    end

    #
    # Returns the description of the class parameters with a given name.
    #
    # @return [String]
    #   Description of the class parameter with the specified name.
    #
    # @raise [ParamNotFound]
    #   No class parameter with the specified name could be found.
    #
    def describe_param(name)
      get_param(name).description
    end

    #
    # Returns the value of the class parameters with a given name.
    #
    # @return [Object]
    #   Value of the class parameter with the specified name.
    #
    # @raise [ParamNotFound]
    #   No class parameter with the specified name could be found.
    #
    def param_value(name)
      get_param(name).value
    end
  end
end
