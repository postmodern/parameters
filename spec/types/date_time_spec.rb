require 'spec_helper'
require 'parameters/types/date_time'

describe Parameters::Types::DateTime do
  subject { described_class }

  describe "coerce" do
    let(:string)    { '2010-02-18T00:36:31-08:00' }
    let(:time)      { Time.parse(string)          }
    let(:date_time) { DateTime.parse(string)      }

    it "should call #to_datetime when possible" do
      subject.coerce(time).should == date_time
    end

    it "should parse Strings" do
      subject.coerce(string).should == date_time
    end
  end
end
