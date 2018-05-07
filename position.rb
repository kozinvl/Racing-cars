class Position
  @@count = 1
  attr_accessor :x, :y

  def initialize(x, y, bool = false)
    @x = x
    @y = y
    puts to_s if bool
    @@count += 1
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

  def self.sub(a, b)
    Position.new(a.x - b.x, a.y - b.y)
  end

  def self.mult(a, m)
    Position.new(a.x * m, a.y * m)
  end

  def self.distance(a, b)
    res = Position.sub(a, b)
    modulo(res)
  end

  def self.modulo(pos)
    Math.sqrt(pos.x**2 + pos.y**2)
  end

  def self.prodInterno(a, b)
    (a.x * b.x + a.y * b.y)
  end

  def self.intermediario(a, b, t)
    Position.add(Position.mult(a, (1.0 - t)), Position.mult(b, t))
  end

  def self.to_Rad(angle)
    angle.to_f / 180.0 * Math::PI
  end

  def self.to_degree(angle)
    angle.to_f * 180.0 / Math::PI
  end

  def self.le(texto)
    print texto
    gets
  end

  def self.leArrayInt(texto)
    le(texto).split.map(&:to_i)
  end

  private_class_method :leArrayInt

  def self.crFromUser
    puts @@count.to_s + 'ª ' + name
    begin
      posArray = leArrayInt('Enter x & y: ')
      bool = posArray.size != 2
      puts 'Wrong entry, re-enter please' if bool
    end while bool
    Position.new(posArray[0], posArray[1], true)
  end
end
