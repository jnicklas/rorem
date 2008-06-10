require 'rubygems'
require 'facets'

path = File.join(File.dirname(__FILE__), 'rorem/')

require path + 'analytics'
require path + 'generator'
require path + 'array_extension'
require path + 'model'
require path + 'filler'

class Car

  include Rorem::Model

  attr_accessor :brand, :seats, :owner_name, :owner_age, :special_car, :description
  
end