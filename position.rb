
class Position
  attr_accessor :x, :y

  def initialize(x, y, bool = false)
    @x = x
    @y = y
    puts to_s if bool
  end

  def to_s
    "x: #{@x}, y: #{@y}"
  end

  def self.zero
    Position.new(0.0, 0.0)
  end

  def self.add(a, b)
    Position.new(a.x + b.x, a.y + b.y)
  end
end

