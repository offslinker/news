require 'ostruct'
class News < OpenStruct
  def <=>(b)
    points <=> b.points
  end
end

