require 'spec_helper'
require 'parameters/types/boolean'

describe Parameters::Types::Boolean do
  subject { described_class }

  describe "#===" do
    it "should match true" do
      subject.should === true
    end

    it "should match false" do
      subject.should === false
    end

    it "should not match anything else" do
      subject.should_not === 1
    end
  end

  describe "#coerce" do
    it "should map false to false" do
      subject.coerce(false).should == false
    end

    it "should map 'false' to false" do
      subject.coerce('false').should == false
    end

    it "should map :false to false" do
      subject.coerce(:false).should == false
    end

    it "should map everything else to true" do
      subject.coerce(:foo).should == true
    end
  end
end
