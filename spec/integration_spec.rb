require File.join(File.dirname(__FILE__), 'spec_helper')

describe 'A class that includes Rorem::Model' do

  before do
    
    @class = Class.new
    @class.send(:include, Rorem::Model)
    @class.send(:attr_accessor, :first_name, :last_name, :name, :email, :length, :width, :height, :size, :special)
    
  end
  
  it "should fill with some simple assignments and randomizations" do
    @class.factory do |i|
      i.length = random(1..10)
      i.width = random(6..10)
      i.special = false
    end
    
    instance = @class.new
    instance.fill
    
    (1..10).should include(instance.length)
    (6..10).should include(instance.width)
    instance.special.should == false
  end
  
  it "should fill with some randomized values from lists" do
    @class.factory do |i|
      i.first_name = random.first_name
      i.last_name = random.last_name
    end
    
    instance = @class.new
    instance.fill
    
    Rorem::FIRST_NAMES.should include(instance.first_name)
    Rorem::LAST_NAMES.should include(instance.last_name)
  end

end