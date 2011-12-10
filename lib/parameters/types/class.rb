require 'parameters/types/type'

module Parameters
  module Types
    class Class < Type

      # The base-class of the Class Type
      attr_reader :base_class

      #
      # Initializes the Class Type.
      #
      # @param [Class] base_class
      #   The base-class to wrap all values within.
      #
      def initialize(base_class)
        @base_class = base_class
      end

      #
      # Determines if the value inherites from the base-class.
      #
      # @return [Boolean]
      #   Specifies whether the value inherits from the base-class.
      #
      def ===(value)
        value.kind_of?(@base_class)
      end

      #
      # Coerces a value into an instance of the Class.
      #
      # @param [Object] value
      #   The value to coerce.
      #
      # @return [Object]
      #   The instance of the Class, created using the value.
      #
      def coerce(value)
        @base_class.new(value)
      end

    end
  end
end
