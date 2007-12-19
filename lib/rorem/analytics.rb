# analytics analyzes a text file and aggregates statistics about the language used.
# at the moment it is not extensively used by the generator.
module Rorem
  
  class AnalyticsClass
    
    attr_accessor :letters, :punctuation, :average_fragment_length, :average_word_length

    def initialize( path = File.join(File.dirname(__FILE__), '..', '..', 'assets', 'alice30.txt'))
      @file = File.open(path)
      letter_frequency
      punctuation_frequency
      word_length
    end

    private

    def punctuation_frequency
      @file.rewind

      punctuation = {}
      total_fragment_length = 0

      string = @file.read
      sentences = string.split(/[\.,:;!\?]/)

      for line in sentences
        total_fragment_length = total_fragment_length + line.split.length
      end

      self.average_fragment_length = total_fragment_length/sentences.length

      self.punctuation = {}
      %w(. , : ; ? !).each do |mark|
        self.punctuation[mark] = (string.scan(mark).length.to_f/sentences.length.to_f * 100).round
      end
    end

    def letter_frequency
      @file.rewind
      self.letters = {}

      ('a'..'z').to_a.each do |l|
        self.letters[l] = 0
      end

      count = 0

      until(@file.eof?)
        line = @file.readline
        line.length.times do |i|
          char = line[i, 1].downcase
          if self.letters.has_key?(char)
            self.letters[char] = self.letters[char] + 1 
            count = count + 1
          end
        end
      end

      self.letters.each do |letter, occurrences|
        self.letters[letter] = (occurrences.to_f/count.to_f) * 100
      end
    end

    def word_length
      @file.rewind
      words = @file.read.gsub(/[^a-zA-Z\s]/, '').split
      self.average_word_length = words.map{|w| w.length}.sum / words.length
    end 
    
  end
  
  Analytics = AnalyticsClass.new
  
end