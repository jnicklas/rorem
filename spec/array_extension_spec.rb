require File.join(File.dirname(__FILE__), 'spec_helper')

describe Array do
  it "should sum all elements if they're integers" do
    [1, 2, 3, 4].sum.should == 10
  end
  
  it "should sum all elements if they're strings" do
    %w(j o n a s).sum.should == "jonas"
  end
  
  it "should not sum if array contains only one element" do
    [4].sum.should == 4
    %w(j).sum.should == "j"
  end
  
  it "should pick a random element" do
    a = [1, 2, 3, 4]
    a.include?(a.random).should == true
    
    a = %w(a b c d)
    a.include?(a.random).should == true
  end
end