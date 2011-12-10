require 'spec_helper'
require 'parameters/types/boolean'

describe Parameters::Types::Boolean do
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

    it "should map nil to false" do
      subject.coerce(nil).should == false
    end

    it "should map everything else to true" do
      subject.coerce(:foo).should == true
    end
  end
end
