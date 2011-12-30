require 'spec_helper'
require 'parameters/types/array'
require 'parameters/types/integer'

describe Parameters::Types::Array do
  let(:array) { [1, 2, 3] }

  subject { described_class }

  describe "coerce" do
    it "should call #to_a" do
      subject.coerce(array.enum_for).should == array
    end
  end

  context "instance" do
    let(:element_type) { Parameters::Types::Integer }
    let(:numbers)      { %w[1 2 3]                  }

    subject { described_class.new(element_type) }

    it "should have a Ruby type" do
      subject.to_ruby.should == Array[Integer]
    end

    it "should be equal to another Array type with the same element-type" do
      subject.should == described_class.new(element_type)
    end

    it "should be related to the Array type" do
      subject.should < described_class
    end

    describe "#===" do
      it "should check the type of each element" do
        subject.should_not === numbers

        subject.should === array
      end
    end

    describe "#coerce" do
      it "should coerce each element" do
        subject.coerce(numbers).should == array
      end
    end
  end
end
