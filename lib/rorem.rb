module Rorem

  class << self
    def init
      require 'rubygems'
      require 'facets' # TODO: REMOVE THIS PIECE OF SHIT
    
      path = File.join(File.dirname(__FILE__), 'rorem/')

      require path + 'lists'
      require path + 'generator'
      require path + 'distribution'
      require path + 'array_extension'
      require path + 'model'
      require path + 'filler'
    end
  end
  
end