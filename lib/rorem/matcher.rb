module Rorem
  
  class Matcher
    
    attr_reader :condition, :options, :type, :length, :block
    
    def initialize(condition, *args, &block)
      @options = args.last.respond_to?(:to_hash) ? args.last.to_hash : {}
      @type = args.first unless block
      @block = block if block
      @length = @options[:length]
      @condition = condition
      raise ArgumentError.new("invalid matcher: must supply either a type or a block!") unless @type || @block
    end
    
    def to_proc
      return @block if @block
      # TODO: fix this ugly, ugly hack
      return eval(%(proc {|rorem| rorem.send("#{@type}", #{@options.inspect})}))
    end
    
    # Will return a string or an array if a match is found
    def match?(column, table)
      if not @options[:table] or match_against_condition(table, @options[:table])
        match_against_condition(column, @condition)
      end
    end
    
    def inspect
      set = @block ? "set with a proc" : "generate a random #{@type}"
      "<Matcher: match #{@condition} and #{set}>"
    end
    
    private
    
    def match_against_condition(name, condition)
      if condition.is_a?(Array)
        return name if condition.include?(name)
      elsif condition.is_a?(Regexp) and not (a = name.to_s.scan(condition)).empty?
        return a.first
      else
        return name if name.to_s == condition.to_s
      end
    end
    
  end
  
end