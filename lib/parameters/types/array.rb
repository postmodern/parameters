require 'parameters/types/object'

module Parameters
  module Types
    class Array < Object

      # The type to coerce all Array elements with
      attr_reader :element_type

      #
      # Initializes the Array type.
      #
      # @param [Type, nil] element_type
      #   Optional type for the elements of the Array.
      #
      def initialize(element_type)
        @element_type = element_type
      end

      #
      # The element type of the Array type.
      #
      # @return [Object]
      #   The default element type.
      #
      # @since 0.4.0
      #
      def self.element_type
        Object
      end

      #
      # Coerces a value into an Array.
      #
      # @param [#to_a, ::Object] value
      #   The value to coerce.
      #
      # @return [::Array]
      #   The coerced Array.
      #
      def self.coerce(value)
        if value.respond_to?(:to_a)
          value.to_a
        elsif value.respond_to?(:to_ary)
          value.to_ary
        else
          [value]
        end
      end

      #
      # The Ruby Type for the Array Type instance.
      #
      # @return [Array<Class>]
      #   A singleton Array containing the element-type.
      #
      def to_ruby
        self.class.to_ruby[@element_type.to_ruby]
      end

      #
      # Compares the instance type with another type.
      #
      # @param [Array, Type] other
      #   The other type to compare against.
      #
      # @return [::Boolean]
      #   Specificies whether the instance type has the same element type
      #   as the other Array instance type.
      #
      # @since 0.4.0
      #
      def ==(other)
        super(other) && (@element_type == other.element_type)
      end

      #
      # Determines if the value is an Array.
      #
      # @param [::Object] value
      #   The value to inspect.
      #
      # @return [::Boolean]
      #
      def ===(value)
        (self.class === value) && value.all? { |element|
          @element_type === element
        }
      end

      #
      # Coerces a value into an Array, and coerces the elements of the Array.
      #
      # @param [#to_a, ::Object] value
      #   The value to coerce.
      #
      # @return [::Array]
      #   The coerced Array.
      #
      # @see coerce
      #
      def coerce(value)
        array = super(value)
        array.map! { |element| @element_type.coerce(element) }

        return array
      end

    end
  end
end
