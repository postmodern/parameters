require 'spec_helper'
require 'parameters/types/date'

describe Parameters::Types::Date do
  describe "#coerce" do
    let(:string) { '2010-02-18'        }
    let(:date)   { Date.new(2010,2,18) }
    let(:time)   { date.to_time        }

    it "should call #to_time when possible" do
      subject.coerce(time).should == date
    end

    it "should parse Strings" do
      subject.coerce(string).should == date
    end
  end
end
