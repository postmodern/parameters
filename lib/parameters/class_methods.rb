require 'parameters/exceptions'
require 'parameters/class_param'
require 'parameters/extensions/meta'

module Parameters
  module ClassMethods
    def included(base)
      base.extend ClassMethods
    end

    #
    # @return [Hash]
    #   Parameters for the class.
    #
    def params
      @params ||= {}
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

      # add the parameter to the class params list
      params[name] = Parameters::ClassParam.new(
        name,
        options[:type],
        options[:description],
        options[:default]
      )

      # define the reader class method for the parameter
      meta_def(name) do
        get_param(name).value
      end

      # define the writer class method for the parameter
      meta_def("#{name}=") do |value|
        get_param(name).value = value
      end

      # define the getter/setter instance methods for the parameter
      attr_accessor(name)
    end

    #
    # Searches for the class parameter with the matching name.
    #
    # @param [Symbol, String] name
    #   The class parameter name to search for.
    #
    # @return [ClassParam]
    #   The class parameter with the matching _name_.
    #
    # @raise [ParamNotFound]
    #   No class parameter with the specified _name_ could be found.
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
    # @return [Boolean]
    #   Specifies whether or not there is a class parameter with the
    #   specified _name_.
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
    # Iterates over the parameters of the class and it's ancestors.
    #
    # @yield [param]
    #   The block that will be passed each class parameter.
    #
    def each_param(&block)
      ancestors.each do |ancestor|
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
