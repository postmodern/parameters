require 'spec_helper'
require 'parameters/types/regexp'

describe Parameters::Types::Regexp do
  describe "#coerce" do
    it "should parse Strings" do
      subject.coerce('[a-z]').should == /[a-z]/
    end
  end
end
