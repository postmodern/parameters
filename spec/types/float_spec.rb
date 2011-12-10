require 'spec_helper'
require 'parameters/types/float'

describe Parameters::Types::Float do
  subject { described_class }

  describe "coerce" do
    it "should call #to_f" do
      subject.coerce('-0.001').should == -0.001
    end
  end
end
