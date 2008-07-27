require File.join(File.dirname(__FILE__), *%w[lib rorem])

module Rorem
  
  class << self
    
    alias_method_chain :init, :rails
    
    def init_with_rails
      init_without_rails
      require File.join(File.dirname(__FILE__), *%w[lib rorem active_record])
      require File.join(RAILS_ROOT, 'config', 'rorem')
    end
    
  end
  
end