class String
  def seed_metrics()
    
  end
end

module Rorem
  
  Biases = {
    :number => { :very_low => -2, :low => -1, :high => 1, :very_high => 2 },
    :word => { :very_short => -2, :short => -1, :long => 1, :very_long => 2 },
    :time => { :very_early => -2, :early => -1, :late => 1, :very_late => 2 }
  }
  
  Metrics = {
    :number => { :very_low => 0..15, :low => 0..30, :high => 70..100, :very_high => 85..100 },
    :word => { :very_short => 0..15, :short => 0..30, :long => 70..100, :very_long => 85..100 },
    :time => { :very_early => 0..15, :early => 0..30, :late => 70..100, :very_late => 85..100 },
  }
  
  module RandomMetrics
    
    def self.included(base)
      puts "monkey!"
    end
    
    
    
  end
  
  module Randomizers
    
    def random_datetime(range, bias = 0)
      return Time.at(random_integer(range), bias)
    end
    
    def random_integer(length, bias = 0)
      if length.respond_to?(:to_i)
        return length.to_i
      else
        bias = translate_bias(bias)
        first = length.first.to_i
        last = length.last.to_i
        
        diff = first - last

        random = rand(diff) + first
        
        # Generate a new random number <bias> times and check if it is more biased than the old number
        bias.abs.times do
          new_random = rand(diff) + first
          random = ((new_random > random) ^ (bias < 0)) ? new_random : random
        end

        return random
      end
    end
    
    def pick_randomly_from_distribution(distribution)
      sum = 0
      distribution.values.each {|i| sum = sum + i }
      r = rand(sum)
      distribution.each do |k, v|
        return k unless v < r
        r = r - v
      end
    end
    
    private
    
    # Takes a bias which may be a symbol and translates it into an integer value.
    def translate_bias(fancy_bias)
      
      bias = nil
      
      Rorem::Biases.each do |type, biases|
        bias = biases[fancy_bias] if biases.has_key?(fancy_bias)
      end
      
      bias || fancy_bias || 0
    end
  end
  
  Randomizer = Class.new.extend Randomizers
  
end