require 'parameters/class_param'

require 'spec_helper'
require 'set'

describe Parameters::ClassParam do
  describe "type coercion" do
    it "should coerce values into Sets" do
      param = Parameters::ClassParam.new(:x,Set)

      param.value = [1, 2, 3, 2]
      param.value.should == Set[1, 2, 3]
    end

    it "should coerce values into Sets with types" do
      param = Parameters::ClassParam.new(:x,Set[Integer])

      param.value = ['x', '0', '1', '2', '3']
      param.value.should == Set[0, 1, 2, 3]
    end

    it "should coerce values into Arrays" do
      param = Parameters::ClassParam.new(:x,Array)

      param.value = Set[1, 2, 3]
      param.value.should == [1, 2, 3]
    end

    it "should coerce values into Arrays with types" do
      param = Parameters::ClassParam.new(:x,Array[Integer])

      param.value = Set['1', '2', '3']
      param.value.should == [1, 2, 3]
    end

    it "should coerce values into URIs" do
      param = Parameters::ClassParam.new(:x,URI)

      param.value = 'http://bla.com/'
      param.value.should == URI::HTTP.build(:host => 'bla.com')
    end

    it "should coerce values into Regexp" do
      param = Parameters::ClassParam.new(:x,Regexp)

      param.value = 'x*'
      param.value.should == /x*/
    end

    it "should coerce values into Dates" do
      param = Parameters::ClassParam.new(:x,Date)

      param.value = '2010-02-18'
      param.value.should == Date.new(2010,2,18)
    end

    it "should coerce values into DateTimes" do
      param = Parameters::ClassParam.new(:x,DateTime)

      param.value = '2010-02-18T00:36:31-08:00'
      param.value.should == DateTime.new(2010,2,18,0,36,31,Rational(-1,3),2299161)
    end

    it "should coerce values into Symbols" do
      param = Parameters::ClassParam.new(:x,Symbol)

      param.value = 'str'
      param.value.should == :str
    end

    it "should coerce values into Strings" do
      param = Parameters::ClassParam.new(:x,String)

      param.value = :str
      param.value.should == 'str'
    end

    it "should coerce values into Floats" do
      param = Parameters::ClassParam.new(:x,Float)

      param.value = '0.5'
      param.value.should == 0.5
    end

    it "should coerce values into Integers" do
      param = Parameters::ClassParam.new(:x,Integer)

      param.value = '5'
      param.value.should == 5
    end

    it "should coerce values into hex Integers" do
      param = Parameters::ClassParam.new(:x,Integer)

      param.value = '0xa'
      param.value.should == 10
    end

    it "should coerce values into octal Integers" do
      param = Parameters::ClassParam.new(:x,Integer)

      param.value = '010'
      param.value.should == 8
    end

    it "should coerce values into true boolean values" do
      param = Parameters::ClassParam.new(:x,true)

      param.value = true
      param.value.should == true
    end

    it "should coerce non-false boolean values as true" do
      param = Parameters::ClassParam.new(:x,true)

      param.value = '1'
      param.value.should == true
    end

    it "should coerce 'true' boolean values into true" do
      param = Parameters::ClassParam.new(:x,true)

      param.value = 'true'
      param.value.should == true
    end

    it "should coerce :true boolean values into true" do
      param = Parameters::ClassParam.new(:x,true)

      param.value = :true
      param.value.should == true
    end

    it "should coerce values into false" do
      param = Parameters::ClassParam.new(:x,true)

      param.value = false
      param.value.should == false
    end

    it "should coerce 'false' boolean values into false" do
      param = Parameters::ClassParam.new(:x,true)

      param.value = 'false'
      param.value.should == false
    end

    it "should coerce :false boolean values into false" do
      param = Parameters::ClassParam.new(:x,true)

      param.value = :false
      param.value.should == false
    end

    it "should not coerce unknown types" do
      param = Parameters::ClassParam.new(:x)
      obj1 = Object.new

      param.value = obj1
      param.value.should == obj1
    end
  end
end
