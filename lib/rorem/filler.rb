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
    
    def random(*args)
      if args.any?
        return generator.set(*args)
      else
        return generator
      end
    end
    
    def sequence(name, options={})
      #Rorem::Sequence.get(name, options).next
    end
    
    def normal(average, standard_deviation)
      #Rorem::NormalDistribution(average, standard_deviation)
    end
    
    protected
    
    def generator
      @generato ||= Rorem::Generator.new
    end
    
  end
  
end