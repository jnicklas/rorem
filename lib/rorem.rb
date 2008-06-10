require 'rubygems'
require 'facets'

path = File.join(File.dirname(__FILE__), 'rorem/')

require path + 'analytics'
require path + 'random'
require path + 'array_extension'
require path + 'model'
require path + 'filler'

class Car

  include Rorem::Model

  attr_accessor :brand, :seats, :owner_name, :owner_age, :special_car
  
end

Car.factory do |car|

  # all brands are equality likely
  car.brand = random(%w(BMW Mercedes Volvo Jaguar))
  
  # assign probabilities to each value
  car.seats = random([2, 4], :distribution => [0.2, 0.8])
  
  # use a normal distribution to describe probabilities
  car.owner_age = random(18..70, :distribution => normal(40, 15))
  
  # generate a name from rorem's database of names
  car.owner_name = random(:name)
  
  # a deterministic value can be set
  car.special_car = false

end

c = Car.new

c.fill

p c.brand #=> 'BMW'
p c.seats #=> 4
p c.owner_age #=> 27
p c.owner_name #=> 'Allan Hernandez'
p c.special_car #=> false