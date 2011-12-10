require 'parameters/types/object'

module Parameters
  module Types
    class Regexp < Object

      #
      # Coerces a value into a Regular Expression.
      #
      # @param [#to_regexp, #to_s] value
      #   The value to coerce.
      #
      # @return [::Regexp]
      #   The coerced Regular Expression.
      #
      def coerce(value)
        if value.respond_to?(:to_regexp)
          value.to_regexp
        else
          ::Regexp.new(value.to_s)
        end
      end

    end
  end
end
