module Rorem
  
  module ActiveRecordExtension
      
    def make_fillable(options={})
      self.send(:include, ActiveRecordMethods)
      self.rorem_attributes = self.column_names - [ self.primary_key ]
    end   
    
  end
  
  
  module ActiveRecordMethods
    
    def self.append_features(base) #:nodoc:
      super
      base.extend(ClassMethods)
    end
    
    def fill
      self.class.rorem_attributes.each do |attribute|
              
        unless self.send(attribute)
          # loop through all existing matchers and check if this attribute matches anything 
          self.class.all_rorem_matchers.each do |matcher|
        
            # if the matcher matches it will return a parameter, which might be an Array if the 
            # matcher's condition was a Regex with capturing groups.
            if match_parameters = matcher.match?(attribute, self.class.table_name)
              if match_parameters.is_a?(Array)
                self.send("#{attribute}=", self.instance_exec(Rorem::Generator, *match_parameters, &matcher))
              else
                self.send("#{attribute}=", self.instance_exec(Rorem::Generator, &matcher))
              end
              break # abort the looping of the matchers
            end
          end
        end
        
      end
    end
    
    module ClassMethods

      attr_accessor :rorem_attributes
      
      def rorem_matchers
        @rorem_matchers ||= []
      end
      
      def all_rorem_matchers
        self.rorem_matchers + Rorem.matchers
      end
      
      def add_rorem_matcher(condition, *args, &block)
        self.rorem_matchers.push(Rorem::Matcher.new(condition, *args, &block))
      end
      
      def fill(count)
        self.transaction do
          Rorem::Randomizer.random_length(count).times do
            record = self.new
            record.fill
            record.save!
          end
        end
      end
      
    end
    
  end
end