require 'rubygems'
require 'spec'
gem 'activerecord'
require 'active_record'

require File.join(File.dirname(__FILE__), '..', 'lib', 'rorem.rb')
Rorem.init

describe Rorem::Matcher do
  
  it "should raise an error on neither type nor block" do
    
    lambda { Rorem::Matcher.new('first_name') }.should raise_error(ArgumentError)
    
  end
  
  it "should remember condition and type" do
    matcher = Rorem::Matcher.new('monkey', 'plane')
    matcher.condition.should == 'monkey'
    matcher.type.should == 'plane'
  end
  
  it "should remember condition and block" do
    proc = proc{}
    matcher = Rorem::Matcher.new('monkey', &proc)
    matcher.condition.should == 'monkey'
    matcher.block.should == proc
  end
  
  
end

describe Rorem::Matcher, "with a block" do
  
  before(:each) do
    @proc = proc{}
    @matcher = Rorem::Matcher.new('monkey', &@proc)
  end
  
  it "should return the block on to_proc" do
    @matcher.to_proc.should == @proc
  end
  
  it "should say something sensible on inspect" do
    @matcher.inspect.should == "<Matcher: match monkey and set with a proc>"
  end
  
end

describe Rorem::Matcher, "with a type" do
  
  before(:each) do
    @matcher = Rorem::Matcher.new('monkey', 'text', { :monkey => true } )
  end
  
  it "should return a proper block on to_proc" do
    @matcher.to_proc.should be_instance_of(Proc)
    generator = mock('rorem generator')
    generator.should_receive(:send).with('text', { :monkey => true }).and_return('some text')
    
    @matcher.to_proc.call(generator).should == 'some text'
  end
  
  it "should say something sensible on inspect" do
    @matcher.inspect.should == "<Matcher: match monkey and generate a random text>"
  end
  
end

describe Rorem::Matcher, "with a string condition" do
  
  before(:each) do
    @matcher = Rorem::Matcher.new('monkey', 'text')
  end
  
  it "should match the string" do
    @matcher.match?('monkey', 'users').should == "monkey"
  end
  
  it "should not match a different string" do
    @matcher.match?('ape', 'users').should == nil
  end
end

describe Rorem::Matcher, "with a regexp condition" do
  
  before(:each) do
    @matcher = Rorem::Matcher.new(/^[a-z]+_name$/, 'text')
  end
  
  it "should match if the regexp matches" do
    @matcher.match?('first_name', 'users').should == "first_name"
    @matcher.match?('last_name', 'users').should == "last_name"
    @matcher.match?('family_name', 'users').should == "family_name"
  end
  
  it "should not match if the regexp doesn't match" do
    @matcher.match?('ape', 'users').should == nil
    @matcher.match?('firstname', 'users').should == nil
    @matcher.match?('monkey', 'users').should == nil
  end
end

describe Rorem::Matcher, "with a regexp condition with capturing groups" do
  
  before(:each) do
    @matcher = Rorem::Matcher.new(/(^[a-z]+)_(name|soup)$/, 'text')
  end
  
  it "should match if the regexp matches and return an array of capturings" do
    @matcher.match?('first_name', 'users').should == %w(first name)
    @matcher.match?('last_name', 'users').should == %w(last name)
    @matcher.match?('family_name', 'users').should == %w(family name)
    @matcher.match?('mushroom_soup', 'users').should == %w(mushroom soup)
  end
  
  it "should not match if the regexp doesn't match" do
    @matcher.match?('ape', 'users').should == nil
    @matcher.match?('firstname', 'users').should == nil
    @matcher.match?('monkey', 'users').should == nil
  end
end

describe Rorem::Matcher, "with an array condition" do
  
  before(:each) do
    @matcher = Rorem::Matcher.new(%w(ape monkey llama), 'text')
  end
  
  it "should match a String if it's included in the array" do
    @matcher.match?('ape', 'users').should == "ape"
    @matcher.match?('monkey', 'users').should == "monkey"
    @matcher.match?('llama', 'users').should == "llama"
  end
  
  it "should not match a String if it isn't included in the array" do
    @matcher.match?('bear', 'users').should == nil
    @matcher.match?('firstname', 'users').should == nil
    @matcher.match?('gorilla', 'users').should == nil
  end
end

describe Rorem::Matcher, "with a string table condition" do
  
  before(:each) do
    @matcher = Rorem::Matcher.new('monkey', 'text', :table => 'users')
  end
  
  it "should match the string" do
    @matcher.match?('monkey', 'users').should == "monkey"
  end
  
  it "should not match a different string" do
    @matcher.match?('monkey', 'bears').should == nil
  end
end

describe Rorem::Matcher, "with a regexp table condition" do
  
  before(:each) do
    @matcher = Rorem::Matcher.new('monkey', 'text', :table => /user(?:s)?/)
  end
  
  it "should match if the regexp matches the tablename" do
    @matcher.match?('monkey', 'users').should == "monkey"
    @matcher.match?('monkey', 'user').should == "monkey"
  end
  
  it "should not match if the regexp doesn't match the tablename" do
    @matcher.match?('monkey', 'people').should == nil
    @matcher.match?('monkey', 'llamas').should == nil
    @matcher.match?('monkey', 'bears').should == nil    
  end
end

describe Rorem::Matcher, "with an array table condition" do
  
  before(:each) do
    @matcher = Rorem::Matcher.new('monkey', 'text', :table => %w(apes monkeys llamas))
  end
  
  it "should match a tablename if it's included in the array" do
    @matcher.match?('monkey', 'apes').should == "monkey"
    @matcher.match?('monkey', 'monkeys').should == "monkey"
    @matcher.match?('monkey', 'llamas').should == "monkey"
  end
  
  it "should not match a tablename if it isn't included in the array" do
    @matcher.match?('monkey', 'users').should == nil
    @matcher.match?('monkey', 'imposters').should == nil
    @matcher.match?('monkey', 'wizards').should == nil
  end
end