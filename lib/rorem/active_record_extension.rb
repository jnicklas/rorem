module Rorem
  
  module ActiveRecordExtension
      
    def make_fillable(options={})
      self.send(:include, ActiveRecordMethods)
      if options[:attributes]
        self.rorem_attributes = options[:attributes]
      else
        self.rorem_attributes = self.column_names - [ self.primary_key ]
        self.rorem_attributes -= options[:exclude_attributes] if options[:exclude_attributes]
        self.rorem_attributes += options[:include_attributes] if options[:include_attributes]
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
        fill_attribute(attribute)
      end
      
      self.class.rorem_associations.each do |association_name|
        fill_association_by_name(association_name)
      end
      
      self.class.rorem_polymorphic_associations.each do |association_name, klass|
        fill_polymorphic_association_by_name(association_name, klass)
      end
    end
    
    protected
    
    def fill_attribute(attribute)
      unless self.send(attribute)
        result = run_attribute_against_matchers(attribute)
        self.send("#{attribute}=", result) unless result == :nothing
      end
    end
    
    def fill_association_by_name(association_name)
      association = self.class.reflect_on_association(association_name)
      fill_association(association) if association
    end
    
    def fill_polymorphic_association_by_name(association_name, klass)
      association = self.class.reflect_on_association(association_name)
      fill_polymorphic_association(association, klass) if association
    end
    
    def fill_association(association)
      record = find_random_record_to_associate(association)
      if record      
        case association.macro
        when :belongs_to, :has_one
          self.send("#{association.name}=", record)
        when :has_many, :has_and_belongs_to_many
          self.send(association.name).push record
        end
      end
    end
    
    def fill_polymorphic_association(association, klass)
      record = find_random_record_to_associate(association, klass)
      record ||= klass.new
      
      case association.macro
      when :belongs_to, :has_one
        self.send("#{association.name}=", record)
      when :has_many
        self.send(association.name).push record
      end
      
      record.fill if respond_to?(:fill)
    end
    
    def find_random_record_to_associate(association, klass = association.class_name.constantize)
      # To my knowledge there is no way to randomly select, that works across databases, so we
      # have to do this manually.
      random_id = klass.find(:all).to_a.random.id
      return klass.find(random_id)
    end
    
    def run_attribute_against_matchers(attribute)
      # loop through all existing matchers and check if this attribute matches anything 
      self.class.all_rorem_matchers.each do |matcher|
    
        # if the matcher matches it will return a parameter, which might be an Array if the 
        # matcher's condition was a Regex with capturing groups.
        if match_parameters = matcher.match?(attribute, self.class.table_name)
          if match_parameters.is_a?(Array)
            return self.instance_exec(Rorem::Generator, *match_parameters, &matcher)
          else
            return self.instance_exec(Rorem::Generator, &matcher)
          end
        end
      end
      
      return Rorem::Generator.send(self.class.columns_hash[attribute].type) if self.class.columns_hash[attribute]
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
          Rorem::Randomizer.random_integer(count).times do
            record = self.new
            record.fill
            record.save!
          end
        end
      end
      
    end
    
  end
end