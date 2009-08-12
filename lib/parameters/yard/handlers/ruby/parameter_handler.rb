require 'yard/handlers/ruby/base'

module YARD
  module Handlers
    module Ruby
      class ParameterHandler < Base

        handles method_call(:parameter)

        def process
          obj = statement.parameters(false).first
          nobj = namespace
          mscope = scope
          name = case obj.type
                   when :symbol_literal
                     obj.jump(:ident, :op, :kw, :const).source
                   when :string_literal
                     obj.jump(:string_content).source
                   end
                 end

          register MethodObject.new(nobj, name, mscope) do |o|
            o.visibility = :public
            o.source = statement.source
            o.signature = "def #{name}"
          end

          register MethodObject.new(nobj, "#{name}=", mscope) do |o|
            o.visibility = :public
            o.source = statement.source
            o.signature = "def #{name}=(value)"
            o.parameters = [['value', nil]]
          end
        end

      end
    end
  end
end
