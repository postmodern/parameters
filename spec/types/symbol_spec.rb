require 'spec_helper'
require 'parameters/types/symbol'

describe Parameters::Types::Symbol do
  describe "#coerce" do
    it "should call #to_sym" do
      subject.coerce('a').should == :a
    end
  end
end
