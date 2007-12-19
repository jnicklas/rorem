module Rorem
  
  class Filler
    
    @@matchers = []
    @@setters = []
    @@models = []
    
    def initialize
      @matchers = []
      @setters = []
    end
    
    class << self
      def match(condition, *args, &block)      
        @@matchers << Rorem::Matcher.new(condition, *args, &block)
      end
      
      def set(argument, *args, &block)
        @@setters << Rorem::Setter.new(argument, *args, &block)
      end
      
      def setters
        @@setters
      end
      
      def matchers
        @@matchers
      end
      
      def models
        @@models
      end
      
      def models=(models)
        @@models = models
      end
      
      def clear
        @@matchers = []
        @@setters = []
      end
    end
    
    def matchers
      @@matchers + @matchers
    end
    
    def match(condition, *args, &block)      
      @matchers << Rorem::Matcher.new(condition, *args, &block)
    end
    
    def setters
      @@setters + @setters
    end
    
    def set(argument, *args, &block)      
      @setters << Rorem::Setter.new(argument, *args, &block)
    end
    
    def clear
      @matchers = []
      @setters = []
    end
    
    def evaluate(column, table)
      # do this in reverse, so that newer matchers get run
      # before older ones
      self.matchers.reverse.each do |matcher|
        if match = matcher.match?(column, table)
          if match.is_a?(Array)
            # this will not use send, because with matchers we are working with database columns
            # not model objects, that's what setters are for.
            return matcher.to_proc.call(Rorem::Generator, *match)
          else
            return matcher.to_proc.call(Rorem::Generator)
          end
        end
      end
      return nil
    end
    
    def method_missing(method, *args)
      Rorem::Generator.send(method, *args)
    end
    
  end
end