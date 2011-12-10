require 'spec_helper'
require 'parameters/types/set'
require 'parameters/types/integer'

describe Parameters::Types::Set do
  let(:array) { [1, 2, 3]    }
  let(:set)   { Set[1, 2, 3] }

  subject { described_class }

  describe "coerce" do
    it "should call #to_set" do
      subject.coerce(array).should == set
    end
  end

  context "instance" do
    let(:numbers) { %w[1 2 3] }

    subject { described_class.new(Parameters::Types::Integer.new) }

    it "should have an instance type" do
      subject.type.should == Set[Integer]
    end

    describe "#===" do
      it "should check the type of each element" do
        subject.should_not === numbers

        subject.should === set
      end
    end

    describe "#coerce" do
      it "should coerce each element" do
        subject.coerce(numbers).should == set
      end
    end
  end
end
