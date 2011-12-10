require 'spec_helper'
require 'classes/custom_type'
require 'parameters/types'

describe Parameters::Types do
  describe "type_defined?" do
    it "should lookup constants" do
      subject.type_defined?('Array').should == true
    end

    it "should ignore top-level constants" do
      subject.type_defined?('Kernel').should == false
    end
  end

  describe "type_get" do
    it "should lookup constants" do
      subject.type_get('Array').should == Parameters::Types::Array
    end

    it "should ignore top-level constants" do
      lambda {
        subject.type_get('Kernel')
      }.should raise_error(NameError)
    end
  end

  describe "[]" do
    it "should map known Classes to Types" do
      subject[Array].class.should == Parameters::Types::Array
    end

    it "should map Arrays to the Array type" do
      type = subject[Array[Integer]]

      type.class.should == Parameters::Types::Array
      type.element_type.class.should == Parameters::Types::Integer
    end

    it "should map Sets to the Set type" do
      type = subject[Set[Symbol]]

      type.class.should == Parameters::Types::Set
      type.element_type.class.should == Parameters::Types::Symbol
    end

    it "should map Hashes to the Hash type" do
      type = subject[Hash[Symbol => Integer]]

      type.class.should == Parameters::Types::Hash
      type.key_type.class.should == Parameters::Types::Symbol
      type.value_type.class.should == Parameters::Types::Integer
    end

    it "should map unknown Classes to the Class type" do
      type = subject[CustomType]
      
      type.class.should == Parameters::Types::Class
      type.base_class.should == CustomType
    end

    it "should map Procs to the Proc type" do
      type = subject[proc { |value| "0x%x" % value }]
      
      type.class.should == Parameters::Types::Proc
    end

    it "should map true to the Boolean type" do
      subject[true].class.should == Parameters::Types::Boolean
    end

    it "should map nil to the Object type" do
      subject[nil].class.should == Parameters::Types::Object
    end

    it "should raise a TypeError for unmappable Objects" do
      lambda {
        subject[Object.new]
      }.should raise_error(TypeError)
    end
  end
end
