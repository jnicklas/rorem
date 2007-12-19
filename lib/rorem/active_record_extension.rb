module Rorem
  
  module ActiveRecordExtension
      
    def make_fillable(options={})
      self.send(:include, ActiveRecordMethods)
      if options[:attributes]
        self.rorem_attributes = options[:attributes]
      else
        self.rorem_attributes = self.column_names - [ self.primary_key ]
        self.rorem_attributes -= options[:exclude_attributes]
        self.rorem_attributes += options[:include_attributes]
      end
      self.rorem_associations = options[:associations] || []
      self.rorem_polymorphic_associations = options[:polymorphic_associations] || []
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
      
      self.class.rorem_associations.each do |association_name|
        association = self.class.reflect_on_association(association_name)
        
        continue unless association

        record = association.active_record.find(:first, :order => 'RAND()') rand(2).zero?
        record ||= association.active_record.new
        case association.macro
        when :belongs_to, :has_one
          self.send("#{association_name}=", record)
        when :has_many
          self.send(association_name).push record
        end
        record.save!
      end
    end
    
    module ClassMethods

      attr_accessor :rorem_attributes, :rorem_associations, :rorem_polymorphic_associations
      
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