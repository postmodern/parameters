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
      def coerce(value)
        set = if value.respond_to?(:to_set)
                value.to_set
              else
                ::Set[value]
              end

        if @element_type
          set.map! { |element| @element_type.coerce(element) }
        end

        return set
      end

    end
  end
end
