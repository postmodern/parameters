require 'parameters/types/array'

require 'set'

module Parameters
  module Types
    class Set < Array

      #
      # Coerces a value into a Set.
      #
      # @param [#to_set, ::Object] value
      #   The value to coerce.
      #
      # @return [::Set]
      #   The coerced Set.
      #
      def self.coerce(value)
        if value.respond_to?(:to_set)
          value.to_set
        else
          ::Set[value]
        end
      end

    end
  end
end
