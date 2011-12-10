require 'parameters/types/object'

require 'date'

module Parameters
  module Types
    class Date < Object

      #
      # Coerces a value into a Date.
      #
      # @param [::String, #to_date] value
      #   The value to coerce.
      #
      # @return [::Date]
      #   The coerced Date.
      #
      def coerce(value)
        if value.respond_to?(:to_date)
          value.to_date
        else
          ::Date.parse(value.to_s)
        end
      end

    end
  end
end
