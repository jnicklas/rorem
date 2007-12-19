require 'rubygems'
require 'spec'
gem 'activerecord'
require 'active_record'

require File.join(File.dirname(__FILE__), '..', 'lib', 'rorem.rb')
Rorem.init

def mock_active_record(string = 'an active record')
  record = mock(string)
  arclass = mock('an active record class')
  record.stub!(:class).and_return(arclass)
  arclass.stub!(:table_name).and_return('donkeys')
  return record
end

describe Rorem::Filler do
  
  it "should respond to match" do
    Rorem::Filler.should respond_to(:match)
  end
  
  it "should add a new matcher when match is called" do
    matcher = mock('a matcher')
    Rorem::Matcher.should_receive(:new).with(:monkey, :first_name).and_return(matcher)
    
    Rorem::Filler.match(:monkey, :first_name)
  end
  
  it "should respond to set" do
    Rorem::Filler.should respond_to(:set)
  end
  
  it "should add a new setter when set is called" do
    setter = mock('a setter')
    Rorem::Setter.should_receive(:new).with(:monkey, :first_name).and_return(setter)
    
    Rorem::Filler.set(:monkey, :first_name)
  end
  
  it "should return an empty array for models" do
    Rorem::Filler.models.should be_instance_of(Hash)
    Rorem::Filler.models.should be_empty
  end
  
  it "should set the models" do
    models = mock('some models')
    Rorem::Filler.models = models
    Rorem::Filler.models.should == models
  end
  
  after(:each) do
    Rorem::Filler.clear
  end
  
end

describe Rorem::Filler, "with a single matcher" do
  
  before(:each) do
    matcher = mock('a matcher')
    Rorem::Matcher.should_receive(:new).with(:monkey, :first_name).and_return(matcher)  
    Rorem::Filler.match(:monkey, :first_name)
  end
  
  it "should have no matchers after clear" do
    Rorem::Filler.matchers.should_not be_empty
    Rorem::Filler.clear
    Rorem::Filler.matchers.should be_empty
  end
  
  after(:each) do
    Rorem::Filler.clear
  end
  
end

describe Rorem::Filler, "with a single setter" do
  
  before(:each) do
    setter = mock('a setter')
    Rorem::Setter.should_receive(:new).with(:monkey, :first_name).and_return(setter)  
    Rorem::Filler.set(:monkey, :first_name)
  end
  
  it "should have no matchers after clear" do
    Rorem::Filler.setters.should_not be_empty
    Rorem::Filler.clear
    Rorem::Filler.setters.should be_empty
  end
  
  after(:each) do
    Rorem::Filler.clear
  end
  
end

describe Rorem::Filler, "an instance of Rorem::Filler" do
  
  before(:each) do
    @filler = Rorem::Filler.new
  end
  
  it "should add a new matcher for this instance if match is called" do
    matcher = mock('a matcher')
    Rorem::Matcher.should_receive(:new).with(:ape, :last_name).and_return(matcher)  
    @filler.match(:ape, :last_name)
  
    @filler.matchers.should include(matcher)
    Rorem::Filler.matchers.should_not include(matcher)  
  end
  
  it "should add a new setter for this instance if set is called" do
    setter = mock('a setter')
    Rorem::Setter.should_receive(:new).with(:ape, :last_name).and_return(setter)  
    @filler.set(:ape, :last_name)
  
    @filler.setters.should include(setter)
    Rorem::Filler.setters.should_not include(setter)
  end
  
  it "should send on messages to the generator" do
    Rorem::Generator.should_receive(:quuomolux).with('monkey')
    @filler.quuomolux('monkey')
  end
  
  after(:each) do
    @filler.clear
  end
  
end

describe Rorem::Filler, "an instance of Rorem::Filler with a single matcher" do
  
  before(:each) do
    @filler = Rorem::Filler.new
    @matcher = mock('a matcher')
    Rorem::Matcher.should_receive(:new).with(:ape, :last_name).and_return(@matcher)  
    @filler.match(:ape, :last_name)
  end
  
  it "should have no matchers after clear" do
    @filler.clear
    @filler.matchers.should be_empty
  end
  
  it "should evalutate a match" do
    @matcher.should_receive(:match?).with('monkey', 'donkeys').and_return( "monkey" )
    
    proc = mock('a proc')
    proc.should_receive(:call).with(Rorem::Generator)
    @matcher.should_receive(:to_proc).and_return(proc)
    
    @filler.evaluate('monkey', 'donkeys')
  end
  
  it "should evalutate a match that is an Array" do
    @matcher.should_receive(:match?).with('monkey', 'donkeys').and_return( ["mon", "key"] )
    proc = mock('a proc')
    proc.should_receive(:call).with(Rorem::Generator, "mon", "key")
    @matcher.should_receive(:to_proc).and_return(proc)
    @filler.evaluate('monkey', 'donkeys')
  end
  
  after(:each) do
    @filler.clear
  end
  
end

describe Rorem::Filler, "an instance of Rorem::Filler with a single setter" do
  
  before(:each) do
    @filler = Rorem::Filler.new
    @setter = mock('a setter')
    Rorem::Setter.should_receive(:new).with(:ape, :last_name).and_return(@setter)  
    @filler.set(:ape, :last_name)
  end
  
  it "should have no setters after clear" do
    @filler.clear
    @filler.setters.should be_empty
  end
  
  after(:each) do
    @filler.clear
  end
  
end

describe Rorem::Filler, "an instance of Rorem::Filler with a few matchers and a few class matchers" do
  
  before(:each) do
    @filler = Rorem::Filler.new
    
    @matcher1 = mock('a matcher')
    Rorem::Matcher.should_receive(:new).with(:ape, :last_name).and_return(@matcher1)
    @filler.match(:ape, :last_name)
    
    @matcher2 = mock('another matcher')
    Rorem::Matcher.should_receive(:new).with(:llama, :name).and_return(@matcher2)
    @filler.match(:llama, :name)
    
    @matcher3 = mock('yet another matcher')
    Rorem::Matcher.should_receive(:new).with(:giraffe, :title).and_return(@matcher3)
    @filler.match(:giraffe, :title)
    
    @class_matcher1 = mock('a class matcher')
    Rorem::Matcher.should_receive(:new).with(:walruss, :last_name).and_return(@class_matcher1)
    Rorem::Filler.match(:walruss, :last_name)
    
    @class_matcher2 = mock('another class matcher')
    Rorem::Matcher.should_receive(:new).with(:emu, :name).and_return(@class_matcher2)
    Rorem::Filler.match(:emu, :name)
  end
  
  it "should combine all matchers" do
    @filler.matchers.should include(@class_matcher1)
    @filler.matchers.should include(@class_matcher2)
    @filler.matchers.should include(@matcher1)
    @filler.matchers.should include(@matcher2)
    @filler.matchers.should include(@matcher3)
  end
  
  it "should check all matchers for a match" do
    @class_matcher1.should_receive(:match?).with('sioux', 'indians').and_return(nil)
    @class_matcher2.should_receive(:match?).with('sioux', 'indians').and_return(nil)
    @matcher1.should_receive(:match?).with('sioux', 'indians').and_return(nil)
    @matcher2.should_receive(:match?).with('sioux', 'indians').and_return(nil)
    @matcher3.should_receive(:match?).with('sioux', 'indians').and_return(nil)
    
    @filler.evaluate('sioux', 'indians')
  end
  
  it "should check it's own matchers first, last defined first" do
    proc = mock('a proc')
    proc.should_receive(:call).with(Rorem::Generator)
    @matcher3.should_receive(:match?).with('sioux', 'indians').and_return(nil)
    @matcher2.should_receive(:match?).with('sioux', 'indians').and_return('sioux')
    @matcher2.should_receive(:to_proc).and_return(proc)
    @matcher1.should_not_receive(:match?)
    
    @filler.evaluate('sioux', 'indians')
  end
  
  it "should check it's own matchers first, then the class matchers, last defined first" do
    proc = mock('a proc')
    proc.should_receive(:call).with(Rorem::Generator)
    @matcher3.should_receive(:match?).with('sioux', 'indians').and_return(nil)
    @matcher2.should_receive(:match?).with('sioux', 'indians').and_return(nil)
    @matcher1.should_receive(:match?).with('sioux', 'indians').and_return(nil)
    @class_matcher2.should_receive(:match?).with('sioux', 'indians').and_return(true)
    @class_matcher2.should_receive(:to_proc).and_return(proc)
    @class_matcher1.should_not_receive(:match?)
    
    @filler.evaluate('sioux', 'indians')
  end
  
  after(:each) do
    @filler.clear
    Rorem::Filler.clear
  end
  
end