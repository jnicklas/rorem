module Rorem
  
  module ActiveRecord
    
    def self.included(base)
      super
      base.extend ClassMethods
    end
    
    module ClassMethods
      
      def fill(length = nil, options={})
        length ||= factory_count || 10..20
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