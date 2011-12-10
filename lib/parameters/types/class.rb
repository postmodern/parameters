require 'parameters/types/object'

module Parameters
  module Types
    class Class < Object

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
      # The Ruby Class the type represents.
      #
      # @return [Class]
      #   The base-class of the Class Type.
      #
      def type
        @base_class
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
