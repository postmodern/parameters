require 'parameters/types/object'

module Parameters
  module Types
    class Float < Object

      #
      # The coerces a value into a Float.
      #
      # @param [#to_f, ::String] value
      #   The value to coerce.
      #
      # @return [::Float]
      #   The coerced Float.
      #
      def self.coerce(value)
        if value.respond_to?(:to_f)
          value.to_f
        else
          0.0
        end
      end

    end
  end
end
