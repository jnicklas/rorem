require 'rubygems'
require 'spec'
gem 'activerecord'
require 'active_record'

require File.join(File.dirname(__FILE__), '..', 'lib', 'rorem.rb')
Rorem.init

describe ActiveRecord::Base do
  
  it "should respond to rorem" do
    ActiveRecord::Base.should respond_to(:rorem)
  end
  
end