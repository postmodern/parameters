require 'parameters'

class CustomParameters

  include Parameters

  parameter :var, :description => 'A basic parameter'

  parameter :var_with_default,
            :default => 10,
            :description => 'A parameter with a default value'

  def initialize(var=nil,var_with_default=nil)
    @var = var
    @var_with_default = var_with_default

    initialize_params()
  end

end
