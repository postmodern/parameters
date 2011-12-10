require 'parameters/types/date'

require 'date'
require 'time'

module Parameters
  module Types
    class DateTime < Date

      #
      # Coerces a value into a DateTime object.
      #
      # @param [#to_datetime, ::String] value
      #   The value to coerce.
      #
      # @return [::DateTime]
      #   The coerced DateTime.
      #
      def coerce(value)
        if value.respond_to?(:to_datetime)
          value.to_datetime
        else
          ::DateTime.parse(value.to_s)
        end
      end

    end
  end
end
