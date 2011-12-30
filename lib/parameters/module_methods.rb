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

      # add all of the modules parameters
      self.parameters.each do |param|
        base.parameters << param
      end
    end

    #
    # Ensures that the module will initialize parameters, when extended
    # into an Object.
    #
    def extended(object)
      self.parameters.each do |param|
        object.parameters << param.to_instance(object)
      end
    end
  end
end
