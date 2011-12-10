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
      def initialize(key_type=nil,value_type=nil)
        @key_type   = key_type
        @value_type = value_type
      end

      def ===(value)
        super(value) && value.entries.all? do |k,v|
          (@key_type.nil? || @key_type === k) &&
          (@value_type.nil? || @value_type === v)
        end
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
      def coerce(value)
        hash = case value
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
