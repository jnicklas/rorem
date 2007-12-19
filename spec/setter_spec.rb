require 'rubygems'
require 'spec'
gem 'activerecord'
require 'active_record'

require File.join(File.dirname(__FILE__), '..', 'lib', 'rorem.rb')
Rorem.init

describe Rorem::Setter do
  
  it "should raise an error on neither type nor block" do
    
    lambda { Rorem::Setter.new('first_name') }.should raise_error(ArgumentError)
    
  end
  
  it "should remember argument and type" do
    matcher = Rorem::Setter.new(:monkey, 'plane')
    matcher.argument.should == :monkey
    matcher.type.should == 'plane'
  end
  
  it "should remember argument and block" do
    proc = proc{}
    matcher = Rorem::Setter.new(:monkey, &proc)
    matcher.argument.should == :monkey
    matcher.block.should == proc
  end

end

describe Rorem::Setter, "with a block" do
  
  before(:each) do
    @proc = proc{}
    @matcher = Rorem::Setter.new('monkey', &@proc)
  end
  
  it "should return the block on to_proc" do
    @matcher.to_proc.should == @proc
  end
  
  it "should say something sensible on inspect" do
    @matcher.inspect.should == "<Setter: set monkey with a proc>"
  end
  
end

describe Rorem::Setter, "with a type" do
  
  before(:each) do
    @matcher = Rorem::Setter.new('monkey', 'text', { :monkey => true } )
  end
  
  it "should return a proper block on to_proc" do
    @matcher.to_proc.should be_instance_of(Proc)
    generator = mock('rorem generator')
    generator.should_receive(:send).with('text', { :monkey => true }).and_return('some text')
    
    @matcher.to_proc.call(generator).should == 'some text'
  end
  
  it "should say something sensible on inspect" do
    @matcher.inspect.should == "<Setter: set monkey by generating a random text>"
  end
  
end


describe Rorem::Setter, "with a string table condition" do
  
  before(:each) do
    @matcher = Rorem::Setter.new('monkey', 'text', :table => 'users')
  end
  
  it "should match the string" do
    @matcher.should be_a_match('monkey', 'users')
  end
  
  it "should not match a different string" do
    @matcher.should_not be_a_match('monkey', 'bears')
  end
end

describe Rorem::Setter, "with a regexp table condition" do
  
  before(:each) do
    @matcher = Rorem::Setter.new('monkey', 'text', :table => /user(?:s)?/)
  end
  
  it "should match if the regexp matches the tablename" do
    @matcher.should be_a_match('monkey', 'users')
    @matcher.should be_a_match('monkey', 'user')
  end
  
  it "should not match if the regexp doesn't match the tablename" do
    @matcher.should_not be_a_match('monkey', 'people')
    @matcher.should_not be_a_match('monkey', 'llamas')
    @matcher.should_not be_a_match('monkey', 'bears')
  end
end

describe Rorem::Setter, "with an array table condition" do
  
  before(:each) do
    @matcher = Rorem::Setter.new('monkey', 'text', :table => %w(apes monkeys llamas))
  end
  
  it "should match a tablename if it's included in the array" do
    @matcher.should be_a_match('monkey', 'apes')
    @matcher.should be_a_match('monkey', 'monkeys')
    @matcher.should be_a_match('monkey', 'llamas')
  end
  
  it "should not match a tablename if it isn't included in the array" do
    @matcher.should_not be_a_match('monkey', 'users')
    @matcher.should_not be_a_match('monkey', 'imposters')
    @matcher.should_not be_a_match('monkey', 'wizards')
  end
end