require 'parameters/class_param'
require 'parameters/instance_param'
require 'parameters/exceptions'
require 'parameters/extensions/meta'

module Parameters
  def self.included(base) # :nodoc:
    base.metaclass_eval do
      #
      # Returns the +Hash+ of parameters for the class.
      #
      def params
        @params ||= {}
      end

      #
      # Adds a new parameters with the specified _name_ and the given
      # _options_ to the Class.
      #
      # _options_ may contain the following keys:
      # <tt>:description</tt>:: The description of the parameter.
      # <tt>:default</tt>:: The default value the parameter will have.
      #
      #   parameter 'var'
      #
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
      # Returns the class parameter with the specified _name_. If no
      # such class parameter exists, a ParamNotFound exception will be
      # raised.
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

        raise(ParamNotFound,"parameter #{name.to_s.dump} was not found in class #{self.name.dump}",caller)
      end

      #
      # Returns +true+ if a class parameters with the specified _name_
      # exists, returns +false+ otherwise.
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
      # specified _name_. If no such class parameter exists, a
      # ParamNotFound exception will be raised.
      #
      def describe_param(name)
        get_param(name).description
      end

      #
      # Returns the value of the class parameters with the specified
      # _name_. If no such class parameter exists, a ParamNotFound
      # exception will be raised.
      #
      def param_value(name)
        get_param(name).value
      end
    end
  end

  #
  # Initalizes the parameters of the object using the given
  # _values_, which can override the default values of
  # parameters.
  #
  def initialize(values={},&block)
    self.class.each_param do |param|
      # do not override existing instance value if present
      unless instance_variable_get("@#{param.name}")
        if values[param.name]
          value = values[param.name]
        elsif param.value
          begin
            value = param.value.clone
          rescue TypeError
            value = param.value
          end
        end

        instance_variable_set("@#{param.name}",value)
      end

      params[param.name] = InstanceParam.new(self,param.name,param.description)
    end

    super(values,&block)
  end

  #
  # Adds a new parameters with the specified _name_ and the given
  # _options_ to the object.
  #
  # _options_ may contain the following keys:
  # <tt>:description</tt>:: The description of the parameter.
  # <tt>:default</tt>:: The default value the parameter will have.
  #
  #   obj.parameter('var')
  #
  #   obj.parameter('var',:default => 3, :description => 'my variable')
  #
  def parameter(name,options={})
    name = name.to_sym

    # set the instance variable
    instance_variable_set("@#{name}",options[:default])

    # add the new parameter
    params[name] = InstanceParam.new(self,name,options[:description])

    instance_eval %{
      # define the reader method for the parameter
      def #{name}
        instance_variable_get("@#{name}")
      end

      # define the writer method for the parameter
      def #{name}=(value)
        instance_variable_set("@#{name}",value)
      end
    }

    return params[name]
  end

  #
  # Returns a Hash of the classes params.
  #
  def class_params
    self.class.params
  end

  #
  # Returns a +Hash+ of the instance parameters.
  #
  def params
    @params ||= {}
  end

  #
  # Returns +true+ if the a parameter with the specified _name_ exists,
  # returns +false+ otherwise.
  #
  #   obj.has_param?('rhost') # => true
  #
  def has_param?(name)
    params.has_key?(name.to_sym)
  end

  #
  # Returns the parameter with the specified _name_. If no such parameter
  # exists, a ParamNotFound exception will be raised.
  #
  #   obj.get_param('var') # => InstanceParam
  #
  def get_param(name)
    name = name.to_sym

    unless has_param?(name)
      raise(ParamNotFound,"parameter #{name.to_s.dump} was not found within #{self.to_s.dump}",caller)
    end

    return params[name]
  end

  #
  # Returns the description of the parameter with the specified _name_.
  # If no such parameter exists, a ParamNotFound exception will be raised.
  #
  #   obj.describe_param('rhost') # => "remote host"
  #
  def describe_param(name)
    get_param(name).description
  end

  #
  # Returns the value of the parameter with the specified _name_. If no
  # such parameter exists, a ParamNotFound exception will be raised.
  #
  #   obj.param_value('rhost') # => 80
  #
  def param_value(name)
    get_param(name).value
  end

  #
  # Sets the values of the parameters listed in the specified _values_.
  #
  #   obj.set_params(:rhost => 'www.example.com', :rport => 80)
  #   # => {:rhost=>"www.example.com", :rport=>80}
  #
  def set_params(values={})
    values.each do |name,value|
      get_param(name).value = value
    end
  end
end
