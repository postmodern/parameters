require 'parameters/types/hash'
require 'parameters/types/set'
require 'parameters/types/array'
require 'parameters/types/boolean'
require 'parameters/types/object'
require 'parameters/types/proc'
require 'parameters/types/class'

module Parameters
  #
  # @since 0.3.0
  #
  # @api private
  #
  module Types
    #
    # Determines if a Type is defined.
    #
    # @param [Symbol, String] name
    #   The name of the type.
    #
    # @return [Boolean]
    #   Specifies whether the type was defined within {Types}.
    #
    def self.type_defined?(name)
      const_defined?(name,false)
    end

    #
    # Looks up a Type.
    #
    # @param [Symbol, String] name
    #   The name of the type.
    #
    # @return [Type]
    #   The type within {Types}.
    #
    # @raise [NameError]
    #   The type could not be found.
    #
    def self.type_get(name)
      const_get(name,false)
    end

    if RUBY_VERSION < '1.9'
      def self.type_defined?(name)
        const_defined?(name)
      end

      def self.type_get(name)
        const_get(name)
      end
    end

    #
    # Maps a Hash, Set, Array, Proc or Class to a Type.
    #
    # @param [Hash, Set, Array, Proc, Class] type
    #   The Ruby Class or Hash, Set, Array, Proc to map to a Type.
    #
    # @return [Types::Type]
    #   The mapped type.
    #
    # @raise [TypeError]
    #   The Ruby Type could not be mapped to a Parameter Type.
    #
    def self.[](type)
      case type
      when ::Hash
        key_type, value_type = type.entries[0]

        Hash.new(self[key_type],self[value_type])
      when ::Set
        Set.new(self[type.entries[0]])
      when ::Array
        Array.new(self[type[0]])
      when ::Proc
        Proc.new(type)
      when true
        Boolean.new
      when nil
        Object.new
      when ::Class
        if type_defined?(type.name)
          type_get(type.name).new
        else
          Class.new(type)
        end
      when ::Module
        if type_defined?(type.name)
          type_get(type.name).new
        else
          raise(TypeError,"unknown parameter type: #{type.inspect}")
        end
      else
        raise(TypeError,"invalid parameter type: #{type.inspect}")
      end
    end
  end
end
