require 'parameters/instance_param'

require 'spec_helper'
require 'set'

describe Parameters::InstanceParam do
  it "should read values from another object" do
    obj = Object.new
    param = Parameters::InstanceParam.new(obj,:x)

    obj.instance_variable_set(:"@x",5)
    param.value.should == 5
  end

  it "should write values to another object" do
    obj = Object.new
    param = Parameters::InstanceParam.new(obj,:x)

    param.value = 5
    obj.instance_variable_get(:"@x").should == 5
  end

  describe "type coercion" do
    before(:each) do
      @obj = Object.new
    end

    it "should coerce Sets" do
      param = Parameters::InstanceParam.new(@obj,:x,Set)

      param.value = [1, 2, 3, 2]
      param.value.should == Set[1, 2, 3]
    end

    it "should coerce Sets with types" do
      param = Parameters::InstanceParam.new(@obj,:x,Set[Integer])

      param.value = ['x', '0', '1', '2', '3']
      param.value.should == Set[0, 1, 2, 3]
    end

    it "should coerce Arrays" do
      param = Parameters::InstanceParam.new(@obj,:x,Array)

      param.value = Set[1, 2, 3]
      param.value.should == [1, 2, 3]
    end

    it "should coerce Arrays with types" do
      param = Parameters::InstanceParam.new(@obj,:x,Array[Integer])

      param.value = Set['1', '2', '3']
      param.value.should == [1, 2, 3]
    end

    it "should coerce URIs" do
      param = Parameters::InstanceParam.new(@obj,:x,URI)

      param.value = 'http://bla.com/'
      param.value.should == URI::HTTP.build(:host => 'bla.com')
    end

    it "should coerce Symbols" do
      param = Parameters::InstanceParam.new(@obj,:x,Symbol)

      param.value = 'str'
      param.value.should == :str
    end

    it "should coerce Strings" do
      param = Parameters::InstanceParam.new(@obj,:x,String)

      param.value = :str
      param.value.should == 'str'
    end

    it "should coerce Floats" do
      param = Parameters::InstanceParam.new(@obj,:x,Float)

      param.value = '0.5'
      param.value.should == 0.5
    end

    it "should coerce Integers" do
      param = Parameters::InstanceParam.new(@obj,:x,Integer)

      param.value = '5'
      param.value.should == 5
    end

    it "should coerce hex Integers" do
      param = Parameters::InstanceParam.new(@obj,:x,Integer)

      param.value = '0xa'
      param.value.should == 10
    end

    it "should coerce octal Integers" do
      param = Parameters::InstanceParam.new(@obj,:x,Integer)

      param.value = '010'
      param.value.should == 8
    end

    it "should coerce true boolean values" do
      param = Parameters::InstanceParam.new(@obj,:x,true)

      param.value = true
      param.value.should == true
    end

    it "should coerce non-false boolean values as true" do
      param = Parameters::InstanceParam.new(@obj,:x,true)

      param.value = '1'
      param.value.should == true
    end

    it "should coerce 'true' boolean values" do
      param = Parameters::InstanceParam.new(@obj,:x,true)

      param.value = 'true'
      param.value.should == true
    end

    it "should coerce :true boolean values" do
      param = Parameters::InstanceParam.new(@obj,:x,true)

      param.value = :true
      param.value.should == true
    end

    it "should coerce false values" do
      param = Parameters::InstanceParam.new(@obj,:x,true)

      param.value = false
      param.value.should == false
    end

    it "should coerce 'false' boolean values" do
      param = Parameters::InstanceParam.new(@obj,:x,true)

      param.value = 'false'
      param.value.should == false
    end

    it "should coerce :false boolean values" do
      param = Parameters::InstanceParam.new(@obj,:x,true)

      param.value = :false
      param.value.should == false
    end

    it "should not coerce unknown types" do
      param = Parameters::InstanceParam.new(@obj,:x)
      obj1 = Object.new

      param.value = obj1
      param.value.should == obj1
    end
  end
end
