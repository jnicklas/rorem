module Rorem
  
  class DistributionError < StandardError; end
  
  class Distribution
    
    attr_accessor :set, :weights
    
    def self.pick(*attrs)
      self.new(*attrs).pick
    end
    
    def initialize(set, weights)
      raise DistributionError, 'set and probabilities must have same size' unless set.size == weights.size
      self.weights = weights
      self.set = set
    end
    
    def pick
      weighted_rand(self.set, self.weights)
    end
    
    protected
    
    def weight_to_distribution(weights)
        sum = weights.sum.to_f
        weights.map do |weight|
          weight.to_f / sum
        end
    end

    def weighted_rand(set, weights)
      probabilities = weight_to_distribution(weights)
      random = rand;
      probabilities.each_with_index do |probability, i|
        random -= probability
        return set[i] if random < 0
      end
      return set.last
    end
    
  end
  
  
  
  
end