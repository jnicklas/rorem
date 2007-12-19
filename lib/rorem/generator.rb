require 'digest/sha1'


# the generator generates pseudo-random data of different types. Initializing a generator is very slow,
# since it parses in a lot of data and converts it to ruby structures. If at all possible you should not initialize
# more than one generator. ever.
module Rorem
  
  class GeneratorClass
  
    include Rorem::Randomizers
  
    attr_reader :words, :words_by_length, :jobs, :first_names, :last_names
  
    def initialize
      
      File.open(File.join(File.dirname(__FILE__), '..', '..', 'assets', 'latin.txt')) do |f|
        @words = f.read.gsub(/[^a-zA-Z\s]/, '').split.uniq.delete_if { |w| w.length < 2 }
        @words_by_length = {}
        @words.each do |w|
          @words_by_length[w.length] ||= []
          @words_by_length[w.length] << w.downcase
        end
      end
      
      File.open(File.join(File.dirname(__FILE__), '..', '..', 'assets', 'jobs.txt')) do |f|
        @jobs = f.read.to_a.map {|l| l.chomp }
      end

      File.open(File.join(File.dirname(__FILE__), '..', '..', 'assets', 'names.first.txt')) do |f|
        @first_names = f.read.to_a.map {|l| l.chomp }
      end

      File.open(File.join(File.dirname(__FILE__), '..', '..', 'assets', 'names.last.txt')) do |f|
        @last_names = f.read.to_a.map {|l| l.chomp }
      end

    end

    def word( length = 2..10, options = {} )
      length = random_length(length, options[:bias])
      @words_by_length[length].random
    end
    
    def text(length = 10..100, options = {})
      length = random_length(length, options[:bias])
      sentence = []
      length.times do
        sentence << self.word.dup
      end
      position = biasedrand(3..20, -1)
      while position < (length -2)
        mark = distributionrand(Rorem::Analytics.punctuation)
        sentence[position] << mark
        if mark =~ /[.?!]/
          sentence[position+1].capitalize!
        end
        position = position + biasedrand(3..10, -2)
      end
      sentence.first.capitalize!
      sentence.last << "."
      sentence.join(" ")
    end
    
    def title(length = 2..5, options={})
      length = random_length(length, options[:bias])
      words = []
      length.times do
        words << word(2..10, :bias => 1)
      end
      words.first.capitalize!
      words.join(' ')
    end
    
    def string(*args)
      word(*args).capitalize
    end
    
    def datetime(*args)
      time(*args)
    end
    
    def time(first = 1.year.ago, second = Time.now, options = {})
      random_datetime(first, second, options[:bias])
    end
    
    def date(first = 1.year.ago..Time.now, second = nil, options = {})
      random_datetime(first, second, options[:bias]).to_date
    end
    
    def monkey
      mals = %w(monkey llama donkey moose emu porcupine duck gorilla)
      mals[rand(mals.length)]
    end
    
    def integer(range = 0..9999, options={})
      random_length(range, options[:bias])
    end
    
    def boolean(options={})
      [true, false].random
    end
    
    def digest(options={})
      Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{self.word}--")
    end
    
    def job(options={})
      self.jobs.random
    end
    
    def first_name(options={})
      self.first_names.random
    end
    
    def last_name(options={})
      self.last_names.random
    end
    
    def name(options={})
      "#{first_name} #{last_name}"
    end
    
    def nothing(options={})
      :nothing
    end
    
    def inspect
      "<Rorem::Generator #{self.object_id}>"
    end
  end
  
  # most of the time you'll be using Rorem::Generator, which is an INSTANCE of GeneratorClass,
  # it is NOT a class or module!
  Generator = GeneratorClass.new
end