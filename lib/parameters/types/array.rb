require 'parameters/types/object'

module Parameters
  module Types
    class Array < Object

      attr_reader :element_type

      #
      # Initializes the Array type.
      #
      # @param [Type, nil] element_type
      #   Optional type for the elements of the Array.
      #
      def initialize(element_type=nil)
        @element_type = element_type
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
        super(value) && (@element_type.nil? || value.all? { |element|
          @element_type === element
        })
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
      def coerce(value)
        array = if value.respond_to?(:to_a)
                  value.to_a
                elsif value.respond_to?(:to_ary)
                  value.to_ary
                else
                  [value]
                end

        if @element_type
          array.map! { |element| @element_type.coerce(element) }
        end

        return array
      end

    end
  end
end
