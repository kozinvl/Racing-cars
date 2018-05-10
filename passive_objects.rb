require_relative 'position'


$window_width = 800
$window_heigth = 800
$rop = 20

class Enemy
  attr_accessor :pos, :angle

  def initialize
    @pos = Position.zero
    @image = Gosu::Image.new('res/car.png')
    @angle = 0.0
    @timer = 0.0
  end

  def setP(pos)
    @pos = pos
  end

  def set_angle(angle)
    @angle = angle
  end

  def draw
    @image.draw_rot(@pos.x, @pos.y, 1, @angle)
  end
end
