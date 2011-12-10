require 'spec_helper'
require 'parameters/instance_param'

describe Parameters::InstanceParam do
  it "should read values from another object" do
    obj = Object.new
    param = described_class.new(obj,:x)

    obj.instance_variable_set(:"@x",5)
    param.value.should == 5
  end

  it "should write values to another object" do
    obj = Object.new
    param = described_class.new(obj,:x)

    param.value = 5
    obj.instance_variable_get(:"@x").should == 5
  end
end
