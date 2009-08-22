require 'parameters/exceptions'
require 'parameters/class_param'
require 'parameters/instance_param'
require 'parameters/exceptions'
require 'parameters/extensions/meta'

module Parameters
  def self.included(base) # :nodoc:
    base.metaclass_eval do
      #
      # @returns [Hash] Parameters for the class.
      #
      def params
        @params ||= {}
      end

      #
      # Sets the values of the class parameters.
      #
      # @param [Hash] values the names and new values to set the class
      #               params to.
      # @example
      #   Test.params = {:x => 5, :y => 2}
      #   # => {:x=>5, :y=>2}
      #
      def params=(values)
        values.each do |name,value|
          if has_param?(name)
            if (value.kind_of?(Parameters::ClassParam) || value.kind_of?(Parameters::InstanceParam))
              value = value.value
            end

            get_param(name).value = value
          end
        end
      end

      #
      # Adds a new parameters with the specified _name_ and the given
      # _options_ to the Class.
      #
      # _options_ may contain the following keys:
      # <tt>:description</tt>:: The description of the parameter.
      # <tt>:default</tt>:: The default value the parameter will have.
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
        params[name] = Parameters::ClassParam.new(name,options[:description],options[:default])

        # define the reader class method for the parameter
        meta_def(name) do
          params[name].value
        end

        # define the writer class method for the parameter
        meta_def("#{name}=") do |value|
          params[name].value = value
        end

        # define the getter/setter instance methods for the parameter
        attr_accessor(name)
      end

      #
      # Searches for the class parameter with the matching _name_.
      #
      # @param [String, Symbol] name the class parameter name to search for.
      # @return [ClassParam] The class parameter with the matching _name_.
      # @raise [ParamNotFound] No class parameter with the specified _name_
      #                        could be found.
      #
      def get_param(name)
        name = name.to_sym

        ancestors.each do |ancestor|
          if ancestor.include?(Parameters)
            if ancestor.params.has_key?(name)
              return ancestor.params[name]
            end
          end
        end

        raise(Parameters::ParamNotFound,"parameter #{name.to_s.dump} was not found in class #{self.name.dump}",caller)
      end

      #
      # @return [true] There is a class parameter with the specified _name_.
      # @return [false] No class parameter could be found with the specified
      #                 _name_.
      #
      def has_param?(name)
        name = name.to_sym

        ancestors.each do |ancestor|
          if ancestor.include?(Parameters)
            return true if ancestor.params.has_key?(name)
          end
        end

        return false
      end

      #
      # Iterates over all class parameters, passing each one to the
      # specified _block_.
      #
      # @yield [param] Block that will be passed each class parameter.
      #
      def each_param(&block)
        ancestors.each do |ancestor|
          if ancestor.include?(Parameters)
            ancestor.params.each_value(&block)
          end
        end

        return self
      end

      #
      # Returns the description of the class parameters with the
      # specified _name_.
      #
      # @return [String] Description of the class parameter with the
      #                  specified _name_.
      # @raise [ParamNotFound] No class parameter with the specified _name_
      #                        could be found.
      #
      def describe_param(name)
        get_param(name).description
      end

      #
      # Returns the value of the class parameters with the specified
      # _name_.
      #
      # @return [Object] Value of the class parameter with the specified
      #                  _name_.
      # @raise [ParamNotFound] No class parameter with the specified _name_
      #                        could be found.
      #
      def param_value(name)
        get_param(name).value
      end

      #
      # Print the class parameters to the given _output_ stream.
      #
      # @param [#puts] output the stream to print the class parameters to.
      #
      def print_params(output=STDOUT)
        each_param do |param|
          output.puts param
        end
      end
    end
  end

  #
  # Initalizes the parameters of the object using the given
  # _values_, which can override the default values of
  # parameters.
  #
  # @param [Hash] values the names and values to initialize the instance
  #               parameters to.
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

      self.params[param.name] = InstanceParam.new(self,param.name,param.description)
    end

    self.params = values if values.kind_of?(Hash)
  end

  #
  # Initializes the parameters using initialize_params. If a +Hash+
  # is passed in as the first argument, it will be used to set the values
  # of parameters described within the Hash.
  #
  def initialize(*args,&block)
    initialize_params(args.first)
  end

  #
  # Adds a new parameters with the specified _name_ and the given
  # _options_ to the object.
  #
  # _options_ may contain the following keys:
  # <tt>:description</tt>:: The description of the parameter.
  # <tt>:default</tt>:: The default value the parameter will have.
  #
  # @return [InstanceParam] The newly created instance parameter.
  #
  # @example
  #   obj.parameter('var')
  #
  # @example
  #   obj.parameter('var',:default => 3, :description => 'my variable')
  #
  def parameter(name,options={})
    name = name.to_sym
    default = options[:default]
    description = options[:description]

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
    instance_variable_set("@#{name}".to_sym,value)

    # add the new parameter
    self.params[name] = InstanceParam.new(self,name,description)

    instance_eval %{
      # define the reader method for the parameter
      def #{name}
        instance_variable_get("@#{name}".to_sym)
      end

      # define the writer method for the parameter
      def #{name}=(value)
        instance_variable_set("@#{name}".to_sym,value)
      end
    }

    return params[name]
  end

  #
  # @return [Hash] Classes parameteres.
  #
  def class_params
    self.class.params
  end

  #
  # @return [Hash] Instance parameters.
  #
  def params
    @params ||= {}
  end

  #
  # Sets the values of the parameters described in the _values_ +Hash+.
  #
  # @param [Hash] The names and values to set the instance parameters to.
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
  # Iterates over each instance parameter, passing each one to the given
  # _block_.
  #
  # @yield [param] The block that will be passed each instance parameter.
  #
  def each_param(&block)
    self.params.each_value(&block)
  end

  #
  # @return [true] There is a instance parameter with the specified _name_.
  # @return [false] There is not an instance parameter with the specified
  #                 _name_.
  #
  # @example
  #   obj.has_param?('rhost') # => true
  #
  def has_param?(name)
    self.params.has_key?(name.to_sym)
  end

  #
  # Searches for the instance parameter with the specified _name_.
  #
  # @param [String, Symbol] The _name_ of the instance parameter to search
  #                         for.
  # @return [InstanceParam] The instance parameter with the specified
  #                         _name_.
  # @raise [ParamNotFound] Could not find the instance parameter with the
  #                        specified _name_.
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
  # Returns the description of the parameter with the specified _name_.
  #
  # @param [String, Symbol] The _name_ of the instance parameter to search
  #                         for.
  # @return [String] The description of the instance parameter.
  # @raise [ParamNotFound] Could not find the instance parameter with the
  #                        specified _name_.
  #
  # @example
  #   obj.describe_param('rhost') # => "remote host"
  #
  def describe_param(name)
    get_param(name).description
  end

  #
  # Returns the value of the parameter with the specified _name_.
  #
  # @param [String, Symbol] The _name_ of the instance parameter to search
  #                         for.
  # @return [Object] The value of the instance parameter with the specified
  #                  _name_.
  # @raise [ParamNotFound] Could not find the instance parameter with the
  #                        specified _name_.
  #
  # @example
  #   obj.param_value('rhost') # => 80
  #
  def param_value(name)
    get_param(name).value
  end

  #
  # Print the instance parameters to the given _output_ stream.
  #
  # @param [#puts] The output stream to print the instance parameters to.
  #
  def print_params(output=STDOUT)
    each_param do |param|
      output.puts param
    end
  end

  protected

  #
  # Requires that the instance parameters with the specified _names_ have
  # non +nil+ values.
  #
  # @return [true] All the instance parameters listed in _name_ have
  #                 non +nil+ values.
  # @raise [MissingParam] One of the instance parameters listed in _names_
  #                       was not set.
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
