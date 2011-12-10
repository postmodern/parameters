require 'parameters/types/object'

require 'time'

module Parameters
  module Types
    class Time < Object

      #
      # Coerces a value into a Time object.
      #
      # @param [Integer, #to_time, #to_s] value
      #   The value to coerce.
      #
      # @return [::Time]
      #   The coerced Time object.
      #
      def self.coerce(value)
        case value
        when Integer
          ::Time.at(value)
        else
          if value.respond_to?(:to_time)
            value.to_time
          else
            ::Time.parse(value.to_s)
          end
        end
      end

    end
  end
end
