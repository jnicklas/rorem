module Rorem
  
  module Model
    
    def self.included(base)
      super
      base.extend ClassMethods
    end
    
    def fill
      Rorem::Filler.fill(self, self.class.factory_block)
    end
    
    module ClassMethods
      
      attr_reader :factory_block, :factory_count
    
      def factory(count=nil, &block)
        @factory_count = count
        @factory_block = block
      end
      
    end
    
  end
  
end