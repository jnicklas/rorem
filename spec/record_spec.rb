require 'rubygems'
require 'spec'
gem 'activerecord'
require 'active_record'

require File.join(File.dirname(__FILE__), '..', 'lib', 'rorem.rb')
Rorem.init

class Entry < ActiveRecord::Base; end

def disconnected_model(klass, *args)
  klass.stub!(:columns).and_returns([])
  klass.new(*args)
end

describe Rorem::Record do
  
  it "should cache the filler" do
    filler = mock('a filler')
    Rorem::Filler.should_receive(:new).and_return(filler)
    Entry.rorem.should == filler
    Entry.rorem.should == filler
  end
  
end



