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
  end
  
end



