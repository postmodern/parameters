require 'parameters/types/object'

module Parameters
  module Types
    class Hash < Object

      # The type to apply to all keys
      attr_reader :key_type

      # The type to apply to all values
      attr_reader :value_type

      #
      # @param [Type] key_type
      #
      # @param [Type] value_type
      #
      def initialize(key_type=Object,value_type=Object)
        @key_type   = key_type
        @value_type = value_type
      end

      #
      # The key type of the Hash type.
      #
      # @return [Object]
      #   The default key type.
      #
      # @since 0.3.1
      #
      def self.key_type
        Object
      end

      #
      # The value type of the Hash type.
      #
      # @return [Object]
      #   The default value type.
      #
      # @since 0.3.1
      #
      def self.value_type
        Object
      end

      #
      # Coerces a value into a Hash.
      #
      # @param [::Array, #to_hash, ::Object] value
      #   The value to coerce.
      #
      # @return [::Hash]
      #   The coerced Hash.
      #
      def self.coerce(value)
        case value
        when ::Hash
          value
        when ::Array
          ::Hash[*value]
        else
          if value.respond_to?(:to_hash)
            value.to_hash
          else
            raise(TypeError,"cannot coerce #{value.inspect} into a Hash")
          end
        end
      end

      #
      # The Ruby Type that the Hash Type instance represents.
      #
      # @return [Hash{Class => Class}]
      #   A singleton Hash containing the key and value types.
      #
      def to_ruby
        ::Hash[@key_type.to_ruby => @value_type.to_ruby]
      end

      #
      # Compares the instance type with another type.
      #
      # @param [Hash, Type] other
      #   The other type to compare against.
      #
      # @return [::Boolean]
      #   Specificies whether the instance type has the same key/value
      #   types as the other Hash instance type.
      #
      # @since 0.3.1
      #
      def ==(other)
        super(other) && (
          (@key_type   == other.key_type) &&
          (@value_type == other.value_type)
        )
      end

      #
      # Determines if the Hash, and all keys/values, are related to the Type.
      #
      # @param [Object, Hash] value
      #   The value to inspect.
      #
      # @return [Boolean]
      #   Specifies whether the Hash, and all keys/values, match the Type.
      #
      def ===(value)
        (self.class === value) && value.entries.all? do |k,v|
          (@key_type.nil? || @key_type === k) &&
          (@value_type.nil? || @value_type === v)
        end
      end

      #
      # Coerces a value into a Hash, and coerces the keys/values of the Hash.
      #
      # @param [::Array, #to_hash, ::Object] value
      #   The value to coerce.
      #
      # @return [::Hash]
      #   The coerced Hash.
      #
      def coerce(value)
        hash         = super(value)
        coerced_hash = {}

        hash.each do |k,v|
          k = @key_type.coerce(k)   if @key_type
          v = @value_type.coerce(v) if @value_type

          coerced_hash[k] = v
        end

        return coerced_hash
      end

    end
  end
end
