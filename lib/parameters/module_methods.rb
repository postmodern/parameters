require 'parameters/class_methods'

module Parameters
  module ModuleMethods
    #
    # Ensures that the module will re-extend Parameters::ClassMethods,
    # when included.
    #
    def included(base)
      base.extend ClassMethods

      if base.kind_of?(Module)
        # re-extend the ModuleMethods
        base.extend ModuleMethods
      end
    end

    #
    # Ensures that the module will initialize parameters, when extended
    # into an Object.
    #
    def extended(object)
      each_param do |param|
        object.params[param.name] = param.to_instance(object)
      end
    end
  end
end
