module Rorem
  
  class Random
    
    attr_accessor :set, :options
    
    def self.random(set, options={})
      self.new(set, options={}).next
    end
    
    def initialize(set, options={})
      self.set = fetch_set(set)
      self.options = options
    end
    
    def next
      self.set.random
    end
    
    protected
    
    def fetch_set(set)
      case set
      when Array, Range
        return set.to_a
      when Symbol
        raise "NotImplementedYet!"
      else
        raise "deterministic value"
      end
    end
    
    
  end
  
  
  
end