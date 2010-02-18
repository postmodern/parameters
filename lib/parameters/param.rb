require 'set'
require 'uri'
require 'date'

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
      @type = type
      @description = description
    end

    protected

    # Type classes and their coersion methods
    TYPE_COERSION = {
      Hash => :coerce_hash,
      Set => :coerce_set,
      Array => :coerce_array,
      URI => :coerce_uri,
      DateTime => :coerce_date,
      Date => :coerce_date,
      Symbol => :coerce_symbol,
      String => :coerce_string,
      Integer => :coerce_integer,
      Float => :coerce_float
    }

    #
    # Coerces a given value into a specific type.
    #
    # @param [Class] type
    #   The type to coerce the value into.
    #
    # @param [Object] value
    #   The value to coerce.
    #
    # @return [Object]
    #   The coerced value.
    #
    # @since 0.2.0
    #
    def coerce_type(type,value)
      if type.kind_of?(Set)
        coerce_array(Array,value).map { |element|
          coerce_type(type.first,element)
        }.to_set
      elsif type.kind_of?(Array)
        coerce_array(Array,value).map do |element|
          coerce_type(type.first,element)
        end
      elsif (method_name = TYPE_COERSION[type])
        self.send(method_name,type,value)
      else
        value
      end
    end

    #
    # Coerces a given value into the `type` of the param.
    #
    # @param [Object] value
    #   The value to coerce.
    #
    # @return [Object]
    #   The coerced value.
    #
    # @since 0.2.0
    #
    def coerce(value)
      coerce_type(@type,value)
    end

    #
    # Coerces a given value into a `Set`.
    #
    # @param [Set[Class]] type
    #   An optional `Set` containing the type to coerce the elements
    #   of the given value to.
    #
    # @param [Enumerable, Object] value
    #   The value to coerce into a `Set`.
    #
    # @return [Set]
    #   The coerced value.
    #
    # @since 0.2.0
    #
    def coerce_set(type,value)
      if value.kind_of?(Set)
        value
      elsif (value.kind_of?(Enumerable) || value.respond_to?(:to_set))
        value.to_set
      else
        Set[value]
      end
    end

    #
    # Coerces a given value into an `Array`.
    #
    # @param [Array[Class]] type
    #   An optional `Array` containing the type to coerce the elements
    #   of the given value to.
    #
    # @param [Enumerable, Object] value
    #   The value to coerce into an `Array`.
    #
    # @return [Array]
    #   The coerced value.
    #
    # @since 0.2.0
    #
    def coerce_array(type,value)
      if value.kind_of?(Array)
        value
      elsif (value.kind_of?(Enumerable) || value.respond_to?(:to_a))
        value.to_a
      else
        [value]
      end
    end

    #
    # Coerces a given value into a `URI`.
    #
    # @param [Class] type
    #   The `URI` type to coerce to.
    #
    # @param [URI::Generic, #to_s] value
    #   The value to coerce into a `URI`.
    #
    # @return [URI::Generic]
    #   The coerced value.
    #
    # @since 0.2.0
    #
    def coerce_uri(type,value)
      if value.kind_of?(type)
        value
      else
        URI.parse(value.to_s)
      end
    end

    #
    # Coerces a given value into a `Symbol`.
    #
    # @param [Class] type
    #   The `Symbol` class.
    #
    # @param [#to_s] value
    #   The value to coerce.
    #
    # @return [Symbol]
    #   The coerced value.
    #
    # @since 0.2.0
    #
    def coerce_symbol(type,value)
      if value.kind_of?(type)
        value
      else
        value.to_s.to_sym
      end
    end

    #
    # Coerces a given value into a `String`.
    #
    # @param [Class] type
    #   The `String` class.
    #
    # @param [#to_s] value
    #   The value to coerce into a `String`.
    #
    # @return [String]
    #   The coerced value.
    #
    # @since 0.2.0
    #
    def coerce_string(type,value)
      if value.kind_of?(type)
        value
      else
        value.to_s
      end
    end

    #
    # Coerces a given value into an `Integer`.
    #
    # @param [Class]
    #   The Integer class.
    #
    # @param [String, #to_i] value
    #   The value to coerce into an `Integer`.
    #
    # @return [Integer]
    #   The coerced value.
    #
    # @since 0.2.0
    #
    def coerce_integer(type,value)
      if value.kind_of?(type)
        value
      elsif value.kind_of?(String)
        base = if value[0..1] == '0x'
                 16
               elsif value[0..0] == '0'
                 8
               else
                 10
               end

        value.to_i(base)
      elsif value.respond_to?(:to_i)
        value.to_i
      else
        0
      end
    end

    #
    # Coerces a given value into a `Float`.
    #
    # @param [Class] type
    #   The `Float` class.
    #
    # @param [String, #to_f] value
    #   The value to coerce into a `Float`.
    #
    # @return [Float]
    #   The coerced value.
    #
    # @since 0.2.0
    #
    def coerce_float(type,value)
      if value.kind_of?(type)
        value
      elsif (value.kind_of?(String) || value.respond_to?(:to_f))
        value.to_f
      else
        0.0
      end
    end

    #
    # Coerces a given value into a `DateTime` or `Date`.
    #
    # @param [Class] type
    #   The `DateTime` or `Date` class.
    #
    # @param [#to_s] value
    #   The value to coerce into either a `Date` or `DateTime` object.
    #
    # @return [DateTime, Date]
    #   The coerced value.
    #
    # @since 0.2.0
    #
    def coerce_date(type,value)
      if value.kind_of?(type)
        value
      else
        type.parse(value.to_s)
      end
    end

  end
end
