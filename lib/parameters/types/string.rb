require 'parameters/types/object'

module Parameters
  module Types
    class String < Object

      #
      # Coerces a value into a String.
      #
      # @param [#to_s] value
      #   The value to coerce.
      #
      # @return [::String]
      #   The coerced String.
      #
      def coerce(value)
        value.to_s
      end

    end
  end
end
