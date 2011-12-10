module Parameters
  module Types
    class Type

      #
      # Determines if the value is an instance of the Type.
      #
      # @return [Boolean]
      #   Specifies whether the value is already an instance of the Type.
      #
      # @abstract
      #
      def self.===(value)
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
      def self.coerce(value)
      end

      #
      # @see ===
      #
      def ===(value)
        self.class === value
      end

      #
      # @see coerce
      #
      def coerce(value)
        self.class.coerce(value)
      end

    end
  end
end
