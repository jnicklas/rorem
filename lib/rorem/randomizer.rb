module Rorem
  
  module Randomizers
    def random_datetime(first, second, bias = 0)
      if second
        r = Range.new(first.to_i, second.to_i)
        return Time.at(biasedrand(r))
      elsif first.is_a?(Range)
        return Time.at(biasedrand(first))
      else
        return first
      end
    end
    
    def random_length(length, bias = 0)
      if length.respond_to?(:to_i)
        length.to_i
      else
        biasedrand(length, bias)
      end
    end
    
    def distributionrand(distribution)
      sum = 0
      distribution.values.each {|i| sum = sum + i }
      r = rand(sum)
      distribution.each do |k, v|
        return k unless v < r
        r = r - v
      end
    end
    
    def biasedrand(range, bias = 0)
      bias ||= 0
      first = range.first.to_i
      last = range.last.to_i
      diff = first - last
  
      random = rand(diff) + first
  
      bias.abs.times do
        new_random = rand(diff) + first
        random = ((new_random > random) ^ (bias < 0)) ? new_random : random
      end
  
      return random
    end
  end
  
  Randomizer = Class.new.extend Randomizers
  
end