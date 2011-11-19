require 'parameters/parameters'

require 'spec_helper'

require 'classes/module_parameters'
require 'classes/test_parameters'
require 'classes/custom_parameters'
require 'classes/inherited_parameters'
require 'classes/other_parameters'

describe Parameters do
  context "in a Module" do
    it "should provide parameters" do
      ModuleParameters.should have_param(:mixin_var)
    end

    it "should re-extend ClassMethods when including the module" do
      new_class = Class.new do
        include ModuleParameters
      end

      new_class.should have_param(:mixin_var)
    end
  end

  context "in a Class" do
    subject { TestParameters }

    let(:inherited_class) { InheritedParameters }

    it "should provide parameters" do
      subject.params.should_not be_empty
    end

    it "should have default values for parameters" do
      subject.param_value(:var_with_default).should == 'thing'
    end

    it "should provide class methods for paremters" do
      subject.var = 1
      subject.var.should == 1
    end

    it "should inherite the super-classes parameters" do
      inherited_class.has_param?(:var).should == true
      inherited_class.has_param?(:child_var).should == true
    end

    it "should provide direct access to the parameter objects" do
      param = subject.get_param(:var)

      param.should_not be_nil
      param.name.should == :var
    end

    it "should raise a ParamNotFound exception when directly accessing non-existent parameter objects" do
      lambda {
        subject.get_param(:unknown)
      }.should raise_error(Parameters::ParamNotFound)
    end

    it "should provide descriptions for parameters" do
      subject.describe_param(:var).should_not be_empty
    end

    it "should be able to initialize parameters" do
      obj = subject.new

      obj.params.should_not be_empty
    end

    it "should set initialize parameters with initial nil values" do
      obj = CustomParameters.new

      obj.var_with_default.should == 10
    end

    it "should not override previous parameter values" do
      obj = CustomParameters.new(:test,5)

      obj.var.should == :test
      obj.var_with_default.should == 5
    end

    it "should not override previous 'false' values of parameters" do
      obj = CustomParameters.new(false,false)

      obj.var.should == false
      obj.var_with_default.should == false
    end

    it "should be able to create an object with initial parameter values" do
      obj = subject.new(:var => 2, :var_with_default => 'stuff')

      obj.var.should == 2
      obj.var_with_default.should == 'stuff'
    end
  end

  context "in an Object" do
    subject { TestParameters.new }

    let(:inherited_params) { InheritedParameters.new }

    it "should provide direct access to all parameters" do
      subject.params[:var].should_not be_nil
      subject.params[:var_with_default].should_not be_nil
    end

    it "should have default values for parameters" do
      subject.param_value(:var_with_default).should == 'thing'
    end

    it "should provide instance methods for parameters" do
      subject.var = 2
      subject.var.should == 2
    end

    it "should set instance variables for paramters" do
      subject.instance_variable_get(:@var_with_default).should == 'thing'

      subject.var = 3
      subject.instance_variable_get(:@var).should == 3
    end

    it "should allow using lambdas for the default values of parameters" do
      other_params = TestParameters.new

      subject.var_with_lambda.should_not == other_params.var_with_lambda
    end

    it "should contain the parameters from all ancestors" do
      inherited_params.has_param?(:var).should == true
      inherited_params.has_param?(:child_var).should == true
    end

    it "should provide direct access to the parameter objects" do
      @param = subject.get_param(:var)

      @param.should_not be_nil
      @param.name.should == :var
    end

    it "should raise a ParamNotFound exception when directly accessing non-existent parameter objects" do
      lambda {
        subject.get_param(:unknown)
      }.should raise_error(Parameters::ParamNotFound)
    end

    it "should allow setting arbitrary parameters" do
      @test.set_param(:var,2)

      @test.get_param(:var).value.should == 2
    end

    it "should raise a ParamNotFound exception when setting non-existent parameters" do
      lambda { @test.set_param(:unknown,2) }.should raise_error(Parameters::ParamNotFound)
    end

    it "should allow for setting parameters en-mass" do
      subject.params = {:var => 3, :var_with_default => 7}

      subject.param_value(:var).should == 3
      subject.param_value(:var_with_default).should == 7
    end

    it "should allow for setting parameters en-mass from another object" do
      obj = TestParameters.new(:var => 5, :var_with_default => 'hello')
      subject.params = obj.params

      subject.var.should == 5
      subject.var_with_default.should == 'hello'
    end

    it "should allow for setting parameters en-mass from another class" do
      subject.params = OtherParameters.params

      subject.var.should be_nil
      subject.var_with_default.should == 'other'
    end

    it "should provide descriptions for parameters" do
      subject.describe_param(:var).should_not be_empty
    end

    it "should require that certain parameters have non nil values" do
      lambda {
        subject.instance_eval { require_params(:var_without_default) }
      }.should raise_error(Parameters::MissingParam)
    end
  end

  describe "runtime" do
    subject { TestParameters.new }

    before(:each) do
      subject.parameter :new_param

      subject.parameter :new_param_with_default,
                        :default => 5

      subject.parameter :new_param_with_lambda,
                        :default => lambda { |obj|
                          obj.new_param_with_default + 2
                        }
    end

    it "should allow for the addition of parameters" do
      subject.has_param?(:new_param).should == true
    end

    it "should provide direct access to all parameters" do
      subject.params[:new_param].should_not be_nil
      subject.params[:new_param_with_default].should_not be_nil
      subject.params[:new_param_with_lambda].should_not be_nil
    end

    it "should add reader methods for parameters" do
      subject.new_param.should be_nil
    end

    it "should add writer methods for parameters" do
      subject.new_param = 10
      subject.new_param.should == 10
    end

    it "should set the instance variables of parameters" do
      subject.instance_variable_get(:@new_param_with_default).should == 5

      subject.new_param_with_default = 10
      subject.instance_variable_get(:@new_param_with_default).should == 10
    end

    it "should initialize parameters with default values" do
      subject.new_param_with_default.should == 5
    end

    it "should initialize pamareters with default lambda values" do
      subject.new_param_with_lambda.should == 7
    end
  end
end
