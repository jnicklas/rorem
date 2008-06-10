require 'digest/sha1'


# the generator generates pseudo-random data of different types. Initializing a generator is very slow,
# since it parses in a lot of data and converts it to ruby structures. If at all possible you should not initialize
# more than one generator. ever.
module Rorem
  
  module Generator
  
    def random(type, options={})
      length = options[:length]
      if length
        self.send(type, length, options)
      else
        self.send(type, options)
      end
    end
  
    def word( length = 2..10, options = {} )
      length = get_length(length, options)
      @words_by_length[length].random
    end
    
    def text(length = 10..100, options = {})
      length = random_integer(length, options[:bias])
      sentence = []
      length.times do
        sentence << self.word.dup
      end
      position = random_integer(3..20, -1)
      while position < (length -2)
        mark = pick_randomly_from_distribution(Rorem::Analytics.punctuation)
        sentence[position] << mark
        if mark =~ /[.?!]/
          sentence[position+1].capitalize!
        end
        position = position + random_integer(3..10, -2)
      end
      sentence.first.capitalize!
      sentence.last << "."
      sentence.join(" ")
    end
    
    def title(length = 2..5, options={})
      length = random_integer(length, options[:bias])
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
      random_datetime(first..second, options[:bias])
    end
    
    def date(first = 1.year.ago..Time.now, second = nil, options = {})
      random_datetime(first..second, options[:bias]).to_date
    end
    
    def monkey(options={})
      mals = %w(monkey llama donkey moose emu porcupine duck gorilla)
      mals[rand(mals.length)]
    end
    
    def integer(range = 0..9999, options={})
      random_integer(range, options[:bias])
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
    
    def inspect
      "<Rorem::Generator #{self.object_id}>"
    end
    
    protected
    
    def asset_path(asset)
      File.join(File.dirname(__FILE__), '..', '..', 'assets', "#{asset}.txt"))
    end
    
    def asset_array(asset)
      File.read(asset_path(asset)).to_s
    end
    
    def jobs
      @jobs ||= asset_array('jobs')
    end
    
    def first_names
      @first_names ||= asset_array('first_names')
    end
    
    def last_names
      @last_names ||= asset_array('last_names')
    end
    
    def words
      @words ||= File.read(asset_path('latin')).gsub(/[^a-zA-Z\s]/, '').split.uniq.delete_if { |w| w.length < 2 }
    end
    
    def words_by_length
      return @words_by_length if @words_by_length
      @words_by_length = {}
      words.each do |w|
        @words_by_length[w.length] ||= []
        @words_by_length[w.length] << w.downcase
      end
    end
  end
  
  Generator = GeneratorClass.new
end