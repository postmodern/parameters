class TestParameters
  include Parameters

  parameter :var, :description => 'Test parameter'

  parameter :var_with_default,
    :default => 'thing',
    :description => 'This parameter has a default value'

  parameter :var_without_default,
    :description => 'This parameter does not have a default value'

  parameter :var_with_lambda,
    :default => lambda { rand },
    :description => 'This parameter uses a lambda instead of a default value'
end
