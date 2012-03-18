require 'parameters/exceptions'
require 'parameters/class_param'
require 'parameters/param_set'
require 'parameters/extensions/meta'

module Parameters
  module ClassMethods
    #
    # Adds the classes parameters to the extending sub-class.
    #
    # @param [Class] subclass
    #   The sub-class that is inheriting the base-class.
    #
    # @since 0.5.0
    #
    def inherited(subclass)
      super(subclass)

      self.parameters.each do |param|
        subclass.parameters << param
      end
    end

    #
    # @return [ParamSet]
    #   Parameters for the class.
    #
    # @api semipublic
    #
    # @since 0.5.0
    #
    def parameters
      @parameters ||= ParamSet.new
    end

    #
    # @return [Hash]
    #   Parameters for the class.
    #
    # @api semipublic
    #
    # @deprecated Deprecated as of 0.5.0, please use {#parameters} instead.
    #
    def params
      parameters.to_hash
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
    # @api semipublic
    #
    # @since 0.5.0
    #
    def parameters=(values)
      self.parameters.update(values)
    end

    #
    # @deprecated Deprecated as of 0.5.0, please use {#parameters=} instead.
    #
    def params=(values)
      self.parameters = values
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
    # @api public
    #
    def parameter(name,options={})
      name = name.to_sym

      # define the reader class method for the parameter
      meta_def(name) do
        parameters[name]
      end

      # define the writer class method for the parameter
      meta_def("#{name}=") do |value|
        parameters[name] = value
      end

      # define the ? method, to determine if the parameter is set
      meta_def("#{name}?") do
        parameters.set?(name)
      end

      # define the reader instance methods for the parameter
      define_method(name) do
        self.parameters[name]
      end

      # define the writter instance methods for the parameter
      define_method("#{name}=") do |value|
        parameters[name] = value
      end

      # define the ? method, to determine if the parameter is set
      define_method("#{name}?") do
        parameters.set?(name)
      end

      # create the new parameter
      new_param = Parameters::ClassParam.new(
        self,
        name,
        options[:type],
        options[:description],
        options[:default]
      )

      # add the parameter to the class params list
      self.parameters << new_param
      return new_param
    end

    #
    # Determines if a class parameter exists with the given name.
    #
    # @return [Boolean]
    #   Specifies whether or not there is a class parameter with the
    #   specified name.
    #
    # @api semipublic
    #
    # @deprecated
    #   Deprecated as of 0.5.0, please use `parameters.has?(name)`
    #   instead.
    #
    def has_param?(name)
      self.parameters.has?(name)
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
    # @api semipublic
    #
    # @deprecated
    #   Deprecated as of 0.5.0, please use `parameters.get(name)`
    #   instead.
    #
    def get_param(name)
      self.parameters.get(name)
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
    # @api semipublic
    #
    # @deprecated
    #   Deprecated as of 0.5.0, please use `parameters.set(name,value)`
    #   instead.
    #
    def set_param(name,value)
      self.parameters.set(name)
    end

    #
    # Iterates over the parameters of the class and it's ancestors.
    #
    # @yield [param]
    #   The block that will be passed each class parameter.
    #
    # @api semipublic
    #
    # @deprecated
    #   Deprecated as of 0.5.0, please use `parameters.each { |param| ... }`
    #   instead.
    #
    def each_param(&block)
      self.parameters.each(&block)
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
    # @api semipublic
    #
    # @deprecated
    #   Deprecated as of 0.5.0, please use `parameters.describe(name)` instead.
    #
    def describe_param(name)
      self.parameters.describe(name)
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
    # @api semipublic
    #
    # @deprecated
    #   Deprecated as of 0.5.0, please use `parameters[name]` instead.
    #
    def param_value(name)
      self.parameters[name]
    end
  end
end
