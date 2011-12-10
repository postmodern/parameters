require 'spec_helper'
require 'parameters/types/uri'

describe Parameters::Types::URI do
  subject { described_class }

  let(:url) { 'http://www.example.com/' }
  let(:uri) { URI.parse(url)            }

  describe "===" do
    it "should check if the value is kind of URI::Generic" do
      subject.should_not === URI

      subject.should === uri
    end
  end

  describe "coerce" do
    it "should parse Strings" do
      subject.coerce(url).should == uri
    end
  end
end
