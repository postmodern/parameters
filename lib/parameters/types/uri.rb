require 'parameters/types/object'

require 'uri'

module Parameters
  module Types
    class URI < Object

      #
      # Determines if the value is already a URI.
      #
      # @param [Object] value
      #   The value to inspect.
      #
      # @return [Boolean]
      #   Specifies whether the value inherits `URI::Generic`.
      #
      def self.===(value)
        value.kind_of?(::URI::Generic)
      end

      #
      # Coerces a value into a URI.
      #
      # @param [#to_uri, #to_s] value
      #   The value to coerce.
      # 
      # @return [URI::Generic]
      #   The coerced URI.
      #
      def self.coerce(value)
        if value.respond_to?(:to_uri)
          value.to_uri
        else
          ::URI.parse(value.to_s)
        end
      end

    end
  end
end
