require 'parameters/types/object'

module Parameters
  module Types
    class Integer < Object

      #
      # Coerces a value into an Integer.
      #
      # @param [::String, #to_i] value
      #   The value to coerce.
      #
      # @return [::Integer]
      #   The coerced Integer.
      #
      def self.coerce(value)
        case value
        when ::String
          value.to_i(0)
        else
          if value.respond_to?(:to_i)
            value.to_i
          else
            0
          end
        end
      end

    end
  end
end
