require File.join(File.dirname(__FILE__), 'spec_helper')

describe Rorem::Model, '.factory' do

  before(:each) do
    @class = Class.new
    @class.send(:include, Rorem::Model)    
  end

  it "should save a proc for later" do
    a_proc = proc{}
    @class.factory(&a_proc)
    @class.factory_block.should == a_proc
  end
  
  it "should optionally save a length for later" do
    @class.factory(1..5) {}
    @class.factory_length.should == (1..5)
  end

end

describe Rorem::Model, "#fill" do
  
  before(:each) do
    @class = Class.new
    @class.send(:include, Rorem::Model)    
    @instance = @class.new
    @proc = proc{}
    @class.factory(&@proc)
  end
  
  it "should defer to a Rorem::Filler" do
    Rorem::Filler.should_receive(:fill).with(@instance, @proc)
    @instance.fill
  end
end