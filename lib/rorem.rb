module Rorem

  class Initializer
    
    def self.init
      %w(array_extension randomizer analytics generator record matcher setter filler).each do |path|
        require File.join(File.dirname(__FILE__), 'rorem', path)
      end
      
      require File.join(File.dirname(__FILE__), 'matchers', 'english')

      ActiveRecord::Base.send(:include, Rorem::Record)
      
      self.rails_init if defined?(RAILS_ROOT)

      nil # otherwise this returns AR::Base which looks weird :P
    end
    
    def self.rails_init
      ActionView::Base.send(:include, Rorem::Helper)
      ActionController::Base.send(:include, Rorem::Helper)

      rorem_file = File.join(RAILS_ROOT, *%w(config rorem.rb))

      require rorem_file if File.exists?(rorem_file)
    end
  end
  
end

def Rorem.init
  Rorem::Initializer.init
end