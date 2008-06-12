require 'digest/sha1'


# the generator generates pseudo-random data of different types. Initializing a generator is very slow,
# since it parses in a lot of data and converts it to ruby structures. If at all possible you should not initialize
# more than one generator. ever.
module Rorem
  
  class Generator
  
    def word(length = 2..10, options = {})
      length = get_length(length, options)
      # pick a word from the list and duplicate it, so that no changes
      # will be made in the list in case the word is modified later on.
      Rorem::WORDS_BY_LENGTH[length].random.dup
    end
    
    def text(length = 10..100, options = {})
      length = get_length(length, options)
      sentence = []
      
      # add words to sentence
      length.times do
        sentence << word
      end
      # add puctuation to words
      position = integer(3..10)
      while position < (length -2)
        # get a random punctuation mark
        mark = set(['!', ',', '.', ':', ';', '?'], :distribution => [5, 54, 22, 2, 2, 5])
        # add it to the word at position
        sentence[position] << mark
        # Capitalize the next word if the mark is . ? or !
        if mark =~ /[.?!]/
          sentence[position+1].capitalize!
        end
        position = position + integer(3..10)
      end
      # Capitalize the first word in the text
      sentence.first.capitalize!
      # Add a period after the last word in the text
      sentence.last << "."

      sentence.join(" ")
    end
    
    def title(length = 2..5, options={})
      length = get_length(length, options)
      words = []
      length.times do
        words << word(2..10, :bias => 1)
      end
      words.first.capitalize!
      words.join(' ')
    end
    
    # FIXME: date and time need to be reworked
    #def time(ranget = 1.year.ago..Time.now, options = {})
    #  random_datetime(first..second, options[:bias])
    #end
    #
    #def date(first = 1.year.ago..Time.now, second = nil, options = {})
    #  random_datetime(first..second, options[:bias]).to_date
    #end
    
    def set(set, options={})
      case set
      when Array, Range
        if options[:distribution]
          return Rorem::Distribution.pick(set.to_a, options[:distribution])
        else
          return set.to_a.random
        end
      else
        return set
      end
    end
    
    def integer(length = 0..1000, options={})
      if length.respond_to?(:to_i)
        return length.to_i
      elsif options[:distribution]
        return set(length.to_a, options)
      else
        first, last = [length.first.to_i, length.last.to_i].sort
        
        diff = last - first
        
        return rand(diff + 1) + first
      end
    end
    
    def boolean(options={})
      [true, false].random
    end
    
    def digest(options={})
      Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{word}--")
    end
    
    def job(options={})
      Rorem::JOBS.random.dup
    end
    
    def first_name(options={})
      Rorem::FIRST_NAMES.random.dup
    end
    
    def last_name(options={})
      Rorem::LAST_NAMES.random.dup
    end
    
    def name(options={})
      "#{first_name} #{last_name}"
    end
    
    def inspect
      "<Rorem::Generator #{self.object_id}>"
    end
    
    protected
    
    def get_length(length, options)
      integer(length, options)
    end
    
    def asset_path(asset)
      File.join(File.dirname(__FILE__), '..', '..', 'assets', "#{asset}.txt")
    end
    
    def asset_array(asset)
      c = 0
      File.read(asset_path(asset)).to_a.map {|a| a.chomp }.delete_if {
        c += 1
        c % 4 != 0
      }
    end
        
  end

end