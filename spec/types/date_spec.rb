require 'spec_helper'
require 'parameters/types/date'

describe Parameters::Types::Date do
  subject { described_class }

  describe "coerce" do
    let(:string) { '2010-02-18'        }
    let(:date)   { Date.new(2010,2,18) }
    let(:time)   { Time.parse(string)  }

    it "should call #to_date when possible" do
      subject.coerce(time).should == date
    end

    it "should parse Strings" do
      subject.coerce(string).should == date
    end
  end
end
