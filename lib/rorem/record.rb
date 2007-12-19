module Rorem
  
  module Record
    
    def self.append_features(base) #:nodoc:
      super
      base.extend(ClassMethods)
    end
    
    def fill
      self.class.rorem.setters.each do |setter|
        if self.respond_to?("#{setter.argument}=")
          self.send("#{setter.argument}=", setter.to_proc.call(Rorem::Generator))
        end
      end
      
      self.class.columns.each do |column|
        unless self[column.name]
          data = self.class.rorem.evaluate(column.name, self.class.table_name)
          data ||= Rorem::Generator.send(column.type)
          self[column.name] = data if data != :nothing
        end
      end
    end
    
    module ClassMethods
      
      def fill(count)
        Rorem::Randomizer.random_length(count).times do
          record = self.new
          record.fill
          record.save
        end
      end
      
      def rorem
        @filler ||= Rorem::Filler.new
      end
      
    end
    
  end
end