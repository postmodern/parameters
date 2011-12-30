require 'parameters/exceptions'
require 'parameters/class_methods'
require 'parameters/module_methods'
require 'parameters/class_param'
require 'parameters/instance_param'
require 'parameters/param_set'
require 'parameters/extensions/meta'

module Parameters
  def self.included(base)
    base.extend ClassMethods

    if base.kind_of?(Module)
      # add Module specific methods
      base.extend Parameters::ModuleMethods
    end
  end

  #
  # Initalizes the parameters of the object using the given
  # values, which can override the default values of parameters.
  #
  # @param [Hash] values
  #   The names and values to initialize the instance parameters to.
  #
  # @api public
  #
  def initialize_params(values={})
    if self.class.included_modules.include?(Parameters)
      self.class.parameters.each do |param|
        self.parameters << param.to_instance(self)
      end
    end

    self.parameters = values if values.kind_of?(Hash)
  end

  #
  # Initializes the parameters using initialize_params. If a `Hash`
  # is passed in as the first argument, it will be used to set the values
  # of parameters described within the `Hash`.
  #
  # @api public
  #
  def initialize(*args,&block)
    initialize_params(args.first)
  end

  #
  # Adds a new parameter to the object.
  #
  # @param [Symbol, String] name
  #   The name for the new instance parameter.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [Class, Array[Class]] :type
  #   The type to enforce the new parameter values to.
  #
  # @option options [Object, Proc] :default
  #   The default value for the new parameter.
  #
  # @option options [String] :description
  #   The description for the new parameter.
  #
  # @return [InstanceParam]
  #   The newly created instance parameter.
  #
  # @example
  #   obj.parameter('var')
  #
  # @example
  #   obj.parameter('var',:default => 3, :description => 'my variable')
  #
  # @api public
  #
  def parameter(name,options={})
    name    = name.to_sym

    instance_eval %{
      # define the reader method for the parameter
      def #{name}
        parameters[#{name.inspect}]
      end

      # define the writer method for the parameter
      def #{name}=(new_value)
        parameters[#{name.inspect}] = new_value
      end

      def #{name}?
        parameters.set?(#{name.inspect})
      end
    }

    # create the new parameter
    new_param = InstanceParam.new(
      self,
      name,
      options[:type],
      options[:description],
      options[:default]
    )

    # add the new parameter
    self.parameters << new_param
    return new_param
  end

  #
  # @return [Hash]
  #   The parameteres of the class and it's ancestors.
  #
  # @api semipublic
  #
  # @deprecated
  #   Deprecated as of 0.5.0, please use `self.class.parameters`
  #   instead.
  #
  def class_params
    self.class.params
  end

  #
  # @return [ParamSet]
  #   The instance parameters of the object.
  #
  # @api semipublic
  #
  def parameters
    @parameters ||= ParamSet.new
  end

  #
  # @return [Hash]
  #   The instance parameters of the object.
  #
  # @api semipublic
  #
  # @deprecated Deprecated as of 0.5.0, please use {#parameters} instead.
  #
  def params
    parameters.to_hash
  end

  #
  # Sets the values of existing parameters in the object.
  #
  # @param [Hash] values
  #   The names and values to set the instance parameters to.
  #
  # @example
  #   obj.params = {:x => 5, :y => 2}
  #   # => {:x=>5, :y=>2}
  #
  # @api semipublic
  #
  def parameters=(values)
    self.parameters.update(values)
  end

  #
  # @deprecated
  #   Deprecated as of 0.5.0, please use {#parameters=} instead.
  #
  def params=(values)
    self.parameters = values
  end

  #
  # Iterates over each instance parameter in the object.
  #
  # @yield [param]
  #   The block that will be passed each instance parameter.
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
  # @return [Boolean]
  #   Specifies whether or not there is a instance parameter with the
  #   specified name.
  #
  # @example
  #   obj.has_param?('rhost') # => true
  #
  # @api semipublic
  #
  # @deprecated
  #   Deprecated as of 0.5.0, please use `parameters.has?(name)`
  #   instead.
  #
  def has_param?(name)
    self.parameters.has?(name.to_sym)
  end

  #
  # Searches for the instance parameter with a specific name.
  #
  # @param [Symbol, String] name
  #   The name of the instance parameter to search for.
  #
  # @return [InstanceParam]
  #   The instance parameter with the specified name.
  #
  # @raise [ParamNotFound]
  #   Could not find the instance parameter with the specified name.
  #
  # @example
  #   obj.get_param('var') # => InstanceParam
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
  # Sets an instance parameter.
  #
  # @param [Symbol, String] name
  #   The name of the instance parameter.
  #
  # @param [Object] value
  #   The new value for the instance parameter.
  #
  # @return [Object]
  #   The new value of the instance parameter.
  #
  # @raise [ParamNotfound]
  #   No instance parameter with the specified name could be found.
  #
  # @example
  #   obj.set_param('var',2)
  #   # => 2
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
    self.parameters.set(name,value)
  end

  #
  # Returns the description of the parameter with a specific name.
  #
  # @param [Symbol, String] name
  #   The name of the instance parameter to search for.
  #
  # @return [String]
  #   The description of the instance parameter.
  #
  # @raise [ParamNotFound]
  #   Could not find the instance parameter with the specified name.
  #
  # @example
  #   obj.describe_param('rhost') # => "remote host"
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
  # Returns the value of the parameter with a specific name.
  #
  # @param [Symbol, String] name
  #   The name of the instance parameter to search for.
  #
  # @return [Object]
  #   The value of the instance parameter with the specified name.
  #
  # @raise [ParamNotFound]
  #   Could not find the instance parameter with the specified name.
  #
  # @example
  #   obj.param_value('rhost') # => 80
  #
  # @api semipublic
  #
  # @deprecated
  #   Deprecated as of 0.5.0, please use `parameters[name]` instead.
  #
  def param_value(name)
    self.parameters[name]
  end

  protected

  #
  # Requires that the instance parameters with specific names have
  # non `nil` values.
  #
  # @return [true]
  #   All the instance parameters have non `nil` values.
  #
  # @raise [MissingParam]
  #   One of the instance parameters was not set.
  #
  # @api public
  #
  def require_params(*names)
    names.each do |name|
      name = name.to_s

      unless self.parameters.set?(name)
        raise(Parameters::MissingParam,"parameter #{name.dump} has no value")
      end
    end

    return true
  end
end
