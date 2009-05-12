class OtherParameters
  include Parameters

  parameter :var, :description => 'Test parameter'

  parameter :var_with_default,
    :default => 'other',
    :description => 'This parameter has a default value'

end
