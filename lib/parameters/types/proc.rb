require 'parameters/types/type'

module Parameters
  module Types
    class Proc < Type

      # The callback that will coerce values
      attr_reader :callback

      #
      # Creates a new Proc type.
      #
      # @param [#call] callback
      #   The callback that will handle the actual coercion.
      #
      def initialize(callback)
        @callback = callback
      end

      #
      # Coerces the value using the callback.
      #
      # @param [::Object] value
      #   The value to coerce.
      #
      # @return [::Object]
      #   The result of the callback.
      #
      def coerce(value)
        @callback.call(value)
      end

    end
  end
end
