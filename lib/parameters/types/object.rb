require 'parameters/types/type'

module Parameters
  module Types
    class Object < Type

      #
      # Determines if the value is an Object.
      #
      # @return [true]
      #
      def ===(value)
        value.kind_of?(self.class.type)
      end

      #
      # Coerces the value into an Object.
      #
      # @param [::Object] value
      #   The value to coerce.
      #
      # @return [value]
      #   Passes through the value.
      #
      def coerce(value)
        value
      end

    end
  end
end
