module Rorem
  module Helper
    def rorem
      @rorem ||= Generator.new
    end
  end
end