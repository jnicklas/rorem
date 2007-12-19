module Rorem
  
  def self.matchers
    @matchers ||= []
  end
    
  def self.init(language = 'english')
    %w(array_extension randomizer analytics generator active_record_extension matcher).each do |path|
      require File.join(File.dirname(__FILE__), 'rorem', path)
    end
    
    require File.join(File.dirname(__FILE__), 'matchers', language) if language

    ActiveRecord::Base.extend Rorem::ActiveRecordExtension
    
    self.rails_init if defined?(RAILS_ROOT)

    nil # otherwise this returns AR::Base which looks weird :P
  end
  
  def self.rails_init
    ActionView::Base.send(:include, Rorem::Helper)
    ActionController::Base.send(:include, Rorem::Helper)

    rorem_file = File.join(RAILS_ROOT, *%w(config rorem.rb))

    require rorem_file if File.exists?(rorem_file)
  end
  
  def self.add_matcher(condition, *args, &block)
    self.matchers.push(Rorem::Matcher.new(condition, *args, &block))
  end
  
end