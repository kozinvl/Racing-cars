require_relative 'position'


$window_width = 800
$window_heigth = 800

class Enemy
  attr_accessor :position, :angle, :circle_counter

  def initialize
    @position = Position.zero
    @image = Gosu::Image.new('res/car.png')
    @angle = 0.0
  end

  def set_position(pos)
    @pos = pos
  end

  def set_angle(angle)
    @angle = angle
  end

  def draw
    @image.draw_rot(@pos.x, @pos.y, ZOrder::PLAYER, @angle)
  end
end
