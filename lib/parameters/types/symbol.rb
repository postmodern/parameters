require 'parameters/types/object'

module Parameters
  module Types
    class Symbol < Object

      #
      # Coerces a value into a Symbol.
      #
      # @param [#to_sym, #to_s] value
      #   The value to coerce.
      #
      # @return [::Symbol]
      #   The coerced Symbol.
      #
      def coerce(value)
        if value.respond_to?(:to_sym)
          value.to_sym
        else
          value.to_s.to_sym
        end
      end

    end
  end
end
