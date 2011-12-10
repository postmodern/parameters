module Parameters
  module Types
    class Type

      #
      # The Ruby Class the type represents.
      #
      # @return [Class]
      #   A Ruby Class the Type represents.
      #
      # @abstract
      #
      def self.type
      end

      #
      # @see type
      #
      def type
        self.class.type
      end

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
