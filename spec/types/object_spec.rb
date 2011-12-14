require 'spec_helper'
require 'parameters/types/object'

describe Parameters::Types::Object do
  describe "type" do
    it "should lookup the Ruby Class that the Type is named after" do
      described_class.to_ruby.should == ::Object
    end
  end

  describe "#===" do
    it "should always return true" do
      subject.should === 1
    end
  end

  describe "#coerce" do
    let(:obj) { Object.new }

    it "should pass through values" do
      subject.coerce(obj).should == obj
    end
  end
end
