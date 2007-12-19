class Array
  def random
    self[rand(self.length)]
  end
  
  def sum
    if self.length > 1
      total = self.first #This must be a value from the array
      self[1,self.length].each do |v|
        total = total + v
      end
      return total
    else
      return self.first
    end
  end
end