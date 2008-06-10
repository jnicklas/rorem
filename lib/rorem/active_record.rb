module Rorem
  
  module ActiveRecord
    
    def self.included(base)
      super
      base.extend ClassMethods
    end
    
    module ClassMethods
      
      def fill(length = 10..20, options={})
        count = Rorem::Generator.new.integer(length, options={})
        count.times do
          self.new
          self.fill
          self.save!
        end
      end
      
    end
    
  end
  
end