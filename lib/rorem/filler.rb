module Rorem
  
  class Filler
    
    attr_accessor :object, :block
    
    def self.fill(*attrs)
      self.new(*attrs).fill
    end
    
    def initialize(object, block)
      @object = object
      @block = block
    end
    
    def fill
      instance_exec(@object, &@block)
    end
    
    def random(set, options={})
      Rorem::Random.random(set, options)
    end
    
    def sequence(name, options={})
      #Rorem::Sequence.get(name, options).next
    end
    
    def normal(average, standard_deviation)
      #Rorem::NormalDistribution(average, standard_deviation)
    end
    
  end
  
end