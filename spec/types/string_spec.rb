require 'spec_helper'
require 'parameters/types/string'

describe Parameters::Types::String do
  describe "#coerce" do
    it "should call #to_s" do
      subject.coerce(1).should == '1'
    end
  end
end
