require 'spec_helper'
require 'parameters/types/array'
require 'parameters/types/integer'

describe Parameters::Types::Array do
  let(:array) { [1, 2, 3] }

  describe "#coerce" do
    it "should call #to_a" do
      subject.coerce(array.enum_for).should == array
    end

    context "with element-type" do
      let(:numbers) { %w[1 2 3] }

      subject { described_class.new(Parameters::Types::Integer.new) }

      it "should coerce each element" do
        subject.coerce(numbers).should == array
      end
    end
  end
end
