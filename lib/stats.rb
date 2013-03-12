require 'bigdecimal'

class Stats
  attr_reader :items

  def initialize(items)
    @items = items.sort
  end

  def median
    items[items.size / 2]
  end
  
  def average
    items.reduce(:+) / BigDecimal.new(items.size)
  end

  def mode
    items.each_with_object(Hash.new(0)) do |element, hash|
      hash[element] = hash[element] + 1
    end.max_by{|key, value| value}[0]
  end
end


