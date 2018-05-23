require_relative 'position'
require 'gosu'

$window_width = 800
$window_heigth = 800

class Player
  # player class description
  attr_accessor :player_position, :velocity, :angle, :score

  def initialize
    @centre_position = Position.new(400, 400)
    @finish_position = Position.new(285, 650)
    @player_position = Position.zero
    @velocity = Position.zero
    @angle = 90.0
    @buttons = {Gosu::KbA => false, Gosu::KbD => false,
                Gosu::KbW => false, Gosu::KbS => false}
    @image = Gosu::Image.new('res/car_b.png')
    @radius = 80
    @score = 0
    @reverse_moving = false
  end

  def set_position(pos)
    @player_position = pos
  end

  def set_velocity(vel)
    @velocity = vel
  end

  def draw
    # The method of rendering all that is in the area of the created window
    @image.draw_rot(@player_position.x, @player_position.y, ZOrder::PLAYER, @angle)
  end

  def update
    # method of updating the area of rendering and game processes
    @player_position = Position.add(@player_position, @velocity)
    @player_position.x = [[@player_position.x, $window_width - 1].min, 0].max
    @player_position.y = [[@player_position.y, $window_heigth - 1].min, 0].max
    @velocity = Position.zero
    @score += 1 if collide?(@finish_position, @radius * 1.5)
    check_pressed
  end

  def collide?(object_a, radius = @radius)
    # check collisions of object_a and object_b with radius
    distance = Gosu.distance(object_a.x, object_a.y, player_position.x, player_position.y)
    distance < radius
  end

  def check_pressed
    # listen to keystrokes and perform actions
    @angle -= 4.5 if @buttons[Gosu::KbA]
    @angle += 4.5 if @buttons[Gosu::KbD]
    @velocity = detour if @buttons[Gosu::KbW]
    @velocity = Position.zero if @buttons[Gosu::KbS]
  end

  def detour
    # makes impossible running throw fountain in the centre of screen
    if collide?(@centre_position, @radius * 3)
      Position.new(
          -Gosu.offset_x(@angle, 10), -Gosu.offset_y(@angle, 10)
      )
    else
      Position.new(Gosu.offset_x(@angle, 5), Gosu.offset_y(@angle, 5))
    end
  end

  def button_down(id)
    # interception of keystrokes
    @buttons[id] = true
  end

  def button_up(id)
    # interception of the completion of keystrokes
    @buttons[id] = false
  end
end
