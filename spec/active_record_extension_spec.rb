require 'rubygems'
require 'spec'
gem 'activerecord'
require 'active_record'

require File.join(File.dirname(__FILE__), '..', 'lib', 'rorem.rb')

Rorem.init(nil) # Init with nil, so that no default matchers will be loaded!

class Entry < ActiveRecord::Base; end

def disconnected_model(klass, *args)
  klass.stub!(:columns).and_returns([])
  klass.new(*args)
end

describe Rorem::ActiveRecordMethods do
  
  before(:each) do
    @klass = Class.new(ActiveRecord::Base)
    @klass.stub!(:columns).and_return([])
    @klass.make_fillable
    @klass.rorem_attributes = [ "first_name", "last_name", "email", "monkey" ]
    @klass.class_eval do
      attr_accessor :first_name, :last_name, :email, :monkey
    end
  end
  
  describe "#fill" do
    before(:each) do
      @instance = @klass.new
    end
    
    it "should match some simple matchers" do
      matcher1 = Rorem::Matcher.new("first_name", :first_name)
      matcher2 = Rorem::Matcher.new("monkey", :monkey)
      
      @klass.should_receive(:all_rorem_matchers).exactly(4).times.and_return([matcher1, matcher2])
      
      @instance.fill
      @instance.first_name.should_not be_nil
      @instance.monkey.should_not be_nil
      
      @instance.last_name.should be_nil
      @instance.email.should be_nil
    end
    
    it "should match a regex matcher" do
      matcher1 = Rorem::Matcher.new(/_name$/, :first_name)
      matcher2 = Rorem::Matcher.new(/giraffe$/, :monkey)

      @klass.should_receive(:all_rorem_matchers).exactly(4).times.and_return([matcher1, matcher2])

      @instance.fill
      @instance.first_name.should_not be_nil
      @instance.last_name.should_not be_nil

      @instance.monkey.should be_nil
      @instance.email.should be_nil
    end
    
    it "should be awesome with a regex capturing group" do
      matcher1 = Rorem::Matcher.new(/^(.*?)_name$/) do |rorem, type_of_name|
        type_of_name
      end

      @klass.should_receive(:all_rorem_matchers).exactly(4).times.and_return([matcher1])

      @instance.fill
      @instance.first_name.should == "first"
      @instance.last_name.should == "last"
    end
    
    it "should remember instance variables across matchers" do

      matcher1 = Rorem::Matcher.new(/_name$/) do |rorem|
        @word ||= rorem.word
      end

      @klass.should_receive(:all_rorem_matchers).exactly(4).times.and_return([matcher1])

      @instance.fill
      @instance.first_name.should == @instance.last_name
    end
    
    it "should not remember instance variables across instances" do

      matcher1 = Rorem::Matcher.new(/_name$/) do |rorem|
        @word ||= rorem.word
      end

      @klass.should_receive(:all_rorem_matchers).exactly(8).times.and_return([matcher1])

      @instance.fill
      @instance.first_name.should == @instance.last_name
      
      @instance2 = @klass.new
      @instance2.fill
      @instance2.first_name.should_not == @instance.first_name
    end
    
    it "should not overwrite an already filled attribute" do
      
      @instance.first_name = "Walruss"
      
      matcher1 = Rorem::Matcher.new("first_name", :first_name)

      @klass.should_receive(:all_rorem_matchers).exactly(3).times.and_return([matcher1])

      @instance.fill
      @instance.first_name.should == "Walruss"
    end
  end
  
end



