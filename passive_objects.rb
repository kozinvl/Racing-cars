require_relative 'position'


$window_width = 800
$window_heigth = 800

class Enemy
  attr_accessor :position, :angle, :score

  def initialize
    @position = Position.zero
    @image = Gosu::Image.new('res/car.png')
    @angle = 0.0
    @score = 0.0
  end

  def set_position(position)
    @position = position
  end

  def set_angle(angle)
    @angle = angle
  end

  def set_score(score)
    @score = score
  end

  def draw
    @image.draw_rot(@position.x, @position.y, ZOrder::PLAYER, @angle)
  end
end
