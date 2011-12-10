require 'spec_helper'
require 'parameters/types/time'

describe Parameters::Types::Time do
  subject { described_class }

  describe "coerce" do
    let(:string)    { '2011-12-03 19:39:09 -0800' }
    let(:timestamp) { 1322969949                  }
    let(:time)      { Time.at(1322969949)         }
    let(:date)      { time.to_datetime            }

    it "should accept Integers" do
      subject.coerce(timestamp).should == time
    end

    it "should call #to_time when possible" do
      subject.coerce(date).should == time
    end

    it "should parse Strings" do
      subject.coerce(string).should == time
    end
  end
end
