module Parameters
  module Types
    class Type

      #
      # The Ruby Class the Type represents.
      #
      # @return [Class]
      #   The Ruby Class that matches the Types name.
      #
      def self.type
        @type ||= ::Object.const_get(self.name.split('::').last)
      end

      #
      # Determines if the value is an instance of the Type.
      #
      # @return [Boolean]
      #   Specifies whether the value is already an instance of the Type.
      #
      # @abstract
      #
      def ===(value)
        false
      end

      #
      # Coerces an Object into an instances of the Type.
      #
      # @param [Object] value
      #   The value to coerce.
      #
      # @return [Object]
      #   The coerced value.
      #
      # @abstract
      #
      def coerce(value)
      end

    end
  end
end
