require 'parameters/class_param'

require 'spec_helper'
require 'set'

describe Parameters::ClassParam do
  describe "type coersion" do
    it "should coerce Sets" do
      param = Parameters::ClassParam.new(:x,Set)

      param.value = [1, 2, 3, 2]
      param.value.should == Set[1, 2, 3]
    end

    it "should coerce Sets with types" do
      param = Parameters::ClassParam.new(:x,Set[Integer])

      param.value = ['x', '0', '1', '2', '3']
      param.value.should == Set[0, 1, 2, 3]
    end

    it "should coerce Arrays" do
      param = Parameters::ClassParam.new(:x,Array)

      param.value = Set[1, 2, 3]
      param.value.should == [1, 2, 3]
    end

    it "should coerce Arrays with types" do
      param = Parameters::ClassParam.new(:x,Array[Integer])

      param.value = Set['1', '2', '3']
      param.value.should == [1, 2, 3]
    end

    it "should coerce URIs" do
      param = Parameters::ClassParam.new(:x,URI)

      param.value = 'http://bla.com/'
      param.value.should == URI::HTTP.build(:host => 'bla.com')
    end

    it "should coerce Symbols" do
      param = Parameters::ClassParam.new(:x,Symbol)

      param.value = 'str'
      param.value.should == :str
    end

    it "should coerce Strings" do
      param = Parameters::ClassParam.new(:x,String)

      param.value = :str
      param.value.should == 'str'
    end

    it "should coerce Floats" do
      param = Parameters::ClassParam.new(:x,Float)

      param.value = '0.5'
      param.value.should == 0.5
    end

    it "should coerce Integers" do
      param = Parameters::ClassParam.new(:x,Integer)

      param.value = '5'
      param.value.should == 5
    end

    it "should coerce hex Integers" do
      param = Parameters::ClassParam.new(:x,Integer)

      param.value = '0xa'
      param.value.should == 10
    end

    it "should coerce octal Integers" do
      param = Parameters::ClassParam.new(:x,Integer)

      param.value = '010'
      param.value.should == 8
    end

    it "should not coerce unknown types" do
      param = Parameters::ClassParam.new(:x)
      obj1 = Object.new

      param.value = obj1
      param.value.should == obj1
    end
  end
end
