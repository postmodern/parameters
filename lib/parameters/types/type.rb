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
      def self.to_ruby
      end

      #
      # @see to_ruby
      #
      def to_ruby
        self.class.to_ruby
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
      # Determines if the instance of the type is related to another Type.
      #
      # @param [Type] type
      #   The other type class.
      #
      # @return [::Boolean]
      #   Specifies whether the instance of the type inherites from another
      #   type.
      #
      # @since 0.3.1
      #
      def <(other)
        kind_of?(other) || (self.class <= other)
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
