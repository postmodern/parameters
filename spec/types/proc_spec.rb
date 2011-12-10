require 'spec_helper'
require 'classes/custom_type'
require 'parameters/types/proc'

describe Parameters::Types::Proc do
  let(:callback) { proc { |value| "0x%x" % value } }

  subject { described_class.new(callback) }

  describe "#===" do
    it "should always return false" do
      subject.should_not === "0x10"
    end
  end

  describe "#coerce" do
    it "should pass the value to the callback" do
      subject.coerce(16).should == "0x10"
    end
  end
end
