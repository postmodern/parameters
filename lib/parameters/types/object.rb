require 'parameters/types/type'

module Parameters
  module Types
    class Object < Type

      #
      # The Ruby Class the Type represents.
      #
      # @return [Class]
      #   The Ruby Class that matches the Types name.
      #
      def self.to_ruby
        @ruby_class ||= ::Object.const_get(self.name.split('::').last)
      end

      #
      # Determines if the value is an Object.
      #
      # @return [true]
      #
      def self.===(value)
        value.kind_of?(to_ruby)
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
      def self.coerce(value)
        value
      end

      #
      # Determines if the value is an Object.
      #
      # @return [true]
      #
      def ===(value)
        value.kind_of?(to_ruby)
      end

    end
  end
end
