require 'parameters/exceptions'
require 'parameters/class_methods'
require 'parameters/class_param'
require 'parameters/instance_param'
require 'parameters/exceptions'
require 'parameters/extensions/meta'

module Parameters
  def self.included(base)
    base.extend ClassMethods
  end

  #
  # Initalizes the parameters of the object using the given
  # values, which can override the default values of parameters.
  #
  # @param [Hash] values
  #   The names and values to initialize the instance parameters to.
  #
  def initialize_params(values={})
    self.class.each_param do |param|
      # do not override existing instance value if present
      if instance_variable_get("@#{param.name}".to_sym).nil?
        begin
          if param.value.kind_of?(Proc)
            value = if param.value.arity > 0
                      param.value.call(self)
                    else
                      param.value.call()
                    end
          else
            value = param.value.clone
          end
        rescue TypeError
          value = param.value
        end

        instance_variable_set("@#{param.name}".to_sym,value)
      end

      self.params[param.name] = InstanceParam.new(
        self,
        param.name,
        param.type,
        param.description
      )
    end

    self.params = values if values.kind_of?(Hash)
  end

  #
  # Initializes the parameters using initialize_params. If a `Hash`
  # is passed in as the first argument, it will be used to set the values
  # of parameters described within the `Hash`.
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
  def parameter(name,options={})
    name = name.to_s
    default = options[:default]

    # resolve the default value
    if default.kind_of?(Proc)
      value = if default.arity > 0
                default.call(self)
              else
                default.call()
              end
    else
      value = default
    end

    # set the instance variable
    instance_variable_set(:"@#{name}",value)

    # add the new parameter
    self.params[name] = InstanceParam.new(
      self,
      name,
      options[:type],
      options[:description]
    )

    instance_eval %{
      # define the reader method for the parameter
      def #{name}
        get_param(#{name.dump}).value
      end

      # define the writer method for the parameter
      def #{name}=(new_value)
        get_param(#{name.dump}).value = new_value
      end
    }

    return params[name]
  end

  #
  # @return [Hash]
  #   The parameteres of the class and it's ancestors.
  #
  def class_params
    self.class.params
  end

  #
  # @return [Hash]
  #   The instance parameters of the object.
  #
  def params
    @params ||= {}
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
  def params=(values)
    values.each do |name,value|
      name = name.to_sym

      if has_param?(name)
        if (value.kind_of?(Parameters::ClassParam) || value.kind_of?(Parameters::InstanceParam))
          value = value.value
        end

        self.params[name].value = value
      end
    end
  end

  #
  # Iterates over each instance parameter in the object.
  #
  # @yield [param]
  #   The block that will be passed each instance parameter.
  #
  def each_param(&block)
    self.params.each_value(&block)
  end

  #
  # @return [Boolean]
  #   Specifies whether or not there is a instance parameter with the
  #   specified name.
  #
  # @example
  #   obj.has_param?('rhost') # => true
  #
  def has_param?(name)
    self.params.has_key?(name.to_sym)
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
  def get_param(name)
    name = name.to_sym

    unless has_param?(name)
      raise(Parameters::ParamNotFound,"parameter #{name.to_s.dump} was not found within #{self.to_s.dump}",caller)
    end

    return self.params[name]
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
  def describe_param(name)
    get_param(name).description
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
  def param_value(name)
    get_param(name).value
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
  def require_params(*names)
    names.each do |name|
      name = name.to_s

      if instance_variable_get("@#{name}".to_sym).nil?
        raise(Parameters::MissingParam,"parameter #{name.dump} has no value",caller)
      end
    end

    return true
  end
end
