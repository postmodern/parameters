require 'spec_helper'
require 'parameters/types/integer'

describe Parameters::Types::Integer do
  subject { described_class }

  describe "coerce" do
    it "should call #to_i" do
      subject.coerce(10.0).should == 10
    end

    context "when coercing a String" do
      it "should pass 0 to #to_i" do
        subject.coerce('0x10').should == 16
      end
    end
  end
end
