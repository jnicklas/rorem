# use this file to test the aesthetics of the generated values, this stuff is unfortunately
# impossible to spec.

require File.join(File.dirname(__FILE__), 'spec_helper')

class TestClass
  
  include Rorem::Model
  
  attr_accessor :stuff, :text, :text2, :text3, :title, :title2, :story, :story2
  
end

TestClass.factory do |tc|
  
  tc.text = random.text 40..60
  tc.text2 = random.text 60..200
  tc.text3 = random.text 200..300
  
  tc.title = random.title
  
  #tc.stuff = random(%w(llama monkey donkey horse rabbit dog cat), :distribution => [30, 10, 10, 2, 2, 1, 0])
  #tc.stuff = random.integer 1..3, :distribution => [10, 3, 1]
  
end

i = TestClass.new
i.fill

#is = []
#100.times do
#  i = TestClass.new
#  i.fill
#  is << i
#end
#is.map! {|i| i.stuff}
#puts is.sort.inspect

puts i.title
puts "=" * i.title.size
puts ''
puts ''
puts i.text
puts ''
puts i.text2
puts ''
puts i.text3