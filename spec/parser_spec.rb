require 'parameters/parser'

require 'spec_helper'

describe Parameters::Parser do
  it "should parse string values" do
    Parameters::Parser.parse_value("'bla \\' \\\" bla'").should == "bla ' \\\" bla"
  end

  it "should parse decimal values" do
    Parameters::Parser.parse_value("100").should == 100
  end

  it "should parse octal values" do
    Parameters::Parser.parse_value("012").should == 10
  end

  it "should parse hexadecimal values" do
    Parameters::Parser.parse_value("0xff").should == 0xff
  end

  it "should parse boolean values" do
    Parameters::Parser.parse_value('true').should == true
    Parameters::Parser.parse_value('false').should == false
  end

  it "should parse URI values" do
    url = 'http://example.com/'

    Parameters::Parser.parse_value(url).should == URI(url)
  end

  it "should parse params of the form 'name'" do
    Parameters::Parser.parse_param('var').should == {:var => nil}
  end

  it "should parse params of the form 'name=value'" do
    Parameters::Parser.parse_param('var1=test').should == {:var1 => 'test'}
  end
end
