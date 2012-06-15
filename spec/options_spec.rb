require 'spec_helper'
require 'classes/option_parameters'
require 'parameters/options'

describe Parameters::Options do
  let(:object) { OptionParameters.new }
  let(:params) { object.params        }

  describe "flag" do
    it "should prefix the name with '--'" do
      subject.flag(params[:path]).should == '--path'
    end

    it "should replace '_' characters with '-'" do
      subject.flag(params[:with_foo]).should == '--with-foo'
    end

    it "should include '[no-]' for Boolean params" do
      subject.flag(params[:verbose]).should == '--[no-]verbose'
    end
  end

  describe "usage" do
    it "should use the param name for params without a type" do
      subject.usage(params[:path]).should == 'PATH'
    end

    it "should use the param type to derive the USAGE String" do
      subject.usage(params[:count]).should == 'NUM'
    end

    context "complex types" do
      it "should recognize Array params" do
        subject.usage(params[:names]).should == 'NAMES [...]'
      end

      it "should recognize Set params" do
        subject.usage(params[:ids]).should == 'NUM [...]'
      end

      it "should recognize Hash params" do
        subject.usage(params[:mapping]).should == 'NAME:NUM [...]'
      end
    end
  end

  describe "accepts" do
    it "should map Object params to Object" do
      subject.accepts(params[:path]).should == Object
    end

    it "should map Boolean params to TrueClass" do
      subject.accepts(params[:verbose]).should == TrueClass
    end

    it "should map Array params to Array" do
      subject.accepts(params[:names]).should == Array
    end

    it "should map Set params to Array" do
      subject.accepts(params[:ids]).should == Array
    end

    it "should map Hash params to Hash" do
      subject.accepts(params[:mapping]).should == Hash
    end
  end

  describe "parser" do
    subject { Parameters::Options.parser(object) }

    it "should set the param values" do
      path = 'foo.rb'

      subject.parse(['--path', path])

      object.path.should == path
    end

    context "Symbol params" do
      it "should accept identifier values" do
        type = :foo

        subject.parse(['--type', type.to_s])

        object.type.should == type
      end

      it "should reject non-identifier values" do
        lambda {
          subject.parse(['--type', '10'])
        }.should raise_error(OptionParser::InvalidArgument)
      end
    end

    context "Array params" do
      it "should merge multiple values together" do
        name1 = 'foo'
        name2 = 'bar'

        subject.parse(['--names', name1, '--names', name2])

        object.names.should == [name1, name2]
      end
    end

    context "Set params" do
      it "should merge multiple values together" do
        id1 = 10
        id2 = 20

        subject.parse(['--ids', id1.to_s, '--ids', id2.to_s])

        object.ids.should == Set[id1, id2]
      end
    end

    context "Hash params" do
      it "should accept 'key:value' pairs" do
        hash = {:foo => 1}

        subject.parse(['--mapping', 'foo:1'])

        object.mapping.should == hash
      end

      it "should accept 'foo\\:bar:baz pairs" do
        hash = {:"foo:bar" => 1}

        subject.parse(['--mapping', "foo\\:bar:1"])

        object.mapping.should == hash
      end
      
      it "should reject non 'key:value' pairs" do
        lambda {
          subject.parse(['--mapping', 'foo'])
        }.should raise_error(OptionParser::InvalidArgument)
      end

      it "should merge multiple values together" do
        hash = {:foo => 1, :bar => 2}

        subject.parse(['--mapping', 'foo:1', '--mapping', 'bar:2'])

        object.mapping.should == hash
      end
    end
  end
end
