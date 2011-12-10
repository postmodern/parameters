require 'spec_helper'
require 'classes/custom_type'
require 'parameters/types/class'

describe Parameters::Types::Class do
  let(:base_class) { CustomType }
  let(:value) { :foo }

  subject { described_class.new(base_class) }

  it "should have a base-class" do
    subject.base_class.should == base_class
  end

  describe "#===" do
    it "should check if the value inherits from the base-class" do
      subject.should === base_class.new(value)

      subject.should_not === Object.new
    end
  end

  describe "#coerce" do
    it "should pass the value to the base-class" do
      obj = subject.coerce(value)

      obj.should be_kind_of(base_class)
      obj.value.should == value
    end
  end
end
