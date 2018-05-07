require_relative 'position'

$window_width = 800
$window_heigth = 800
$rop = 20

class Player
  attr_accessor :pos, :vel, :angle
  attr_reader :l

  def initialize
    @pos = Position.zero
    @vel = Position.zero
    @angle = 90.0
    @buttons = {Gosu::KbA => false, Gosu::KbD => false, Gosu::KbW => false, Gosu::KbS => false}
    @image = Gosu::Image.new('res/car_b.png')
  end

  def setP(pos)
    @pos = pos
  end

  def setV(vel)
    @vel = vel
  end

  def draw
    @image.draw_rot(@pos.x, @pos.y, 1, @angle)
  end

  def update
    @pos = Position.add(@pos, @vel)
    @pos.x = [[@pos.x, $window_width - 1].min, 0].max
    @pos.y = [[@pos.y, $window_heigth - 1].min, 0].max
    check_presseds
  end

  def check_presseds()
    if @buttons[Gosu::KbA]
      @angle -= 4.5
    end
    if @buttons[Gosu::KbD]
      @angle += 4.5
    end
    if @buttons[Gosu::KbW]
      @vel.x += Gosu.offset_x(@angle, 0.5)
      @vel.y += Gosu.offset_y(@angle, 0.5)
      @vel.x *= 0.9
      @vel.y *= 0.9
    end
    if @buttons[Gosu::KbS]
      @vel.x = 0.0
      @vel.y = 0.0

    end
  end

  def button_down(id)
    @buttons[id] = true
  end

  def button_up(id)
    @buttons[id] = false
  end
end