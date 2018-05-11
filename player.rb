require_relative 'position'

$window_width = 800
$window_heigth = 800
$rop = 20

class Player
  attr_accessor :player_position, :vel, :angle, :score

  def initialize
    @centre_position = Position.new(400, 400)
    @finish_position = Position.new(410, 700)
    @player_position = Position.zero
    @vel = Position.zero
    @angle = 90.0
    @buttons = { Gosu::KbA => false, Gosu::KbD => false,
                 Gosu::KbW => false, Gosu::KbS => false }
    @image = Gosu::Image.new('res/car_b.png')
    @radius = 80
    @score = 0
  end

  def set_position(pos)
    @player_position = pos
  end

  def set_velocity(vel)
    @vel = vel
  end

  def draw
    @image.draw_rot(@player_position.x, @player_position.y, ZOrder::PLAYER, @angle)
  end

  def update
    @player_position = Position.add(@player_position, @vel)
    @player_position.x = [[@player_position.x, $window_width - 1].min, 0].max
    @player_position.y = [[@player_position.y, $window_heigth - 1].min, 0].max
    if collide?(@centre_position, @player_position, @radius * 3)
      @vel.x = 0
      @vel.y = 0
    end
    @score += 1 if collide?(@finish_position, @player_position, @radius / 4)
    check_pressed
  end

  def collide?(object_a, object_b, radius)
    distance = Gosu.distance(object_a.x, object_a.y, object_b.x, object_b.y)
    distance < radius
  end

  def check_pressed
    @angle -= 4.5 if @buttons[Gosu::KbA]
    @angle += 4.5 if @buttons[Gosu::KbD]
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
