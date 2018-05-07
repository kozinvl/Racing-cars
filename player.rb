require_relative 'position'

$winW, $winH = 800, 800
$rop = 20

class Player
  attr_accessor :pos, :vel, :angle
  attr_reader :l

  def initialize
    @pos = Position.zero
    @vel = Position.zero
    @l = $rop
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

=begin
  def draw(window)
    window.draw_rect(@pos.x - @l, @pos.y - @l, @pos.x + @l, @pos.y + @l, @color, 2)
  end
=end
  def draw
    @image.draw_rot(@pos.x, @pos.y, 1, @angle)
  end

  def update
    @pos = Position.add(@pos, @vel)
    @pos.x = [[@pos.x, $winW - 1].min, 0].max
    @pos.y = [[@pos.y, $winH - 1].min, 0].max
    # @life = [@life + @regen_rate, 100.0].min
    check_presseds
  end

=begin
  def check_presseds()
    a = 0.35
    v_lim = 1.8
    if @buttons[Gosu::KbA]
      @vel.x += -a
    end
    if @buttons[Gosu::KbD]
      @vel.x += a
    end
    if @buttons[Gosu::KbW]
      @vel.y += -a
    end
    if @buttons[Gosu::KbS]
      @vel.y += a
    end
    @vel.x = [@vel.x, v_lim].min
    @vel.x = [@vel.x, -v_lim].max
    @vel.y = [@vel.y, v_lim].min
    @vel.y = [@vel.y, -v_lim].max
  end
=end

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
    # if @buttons[Gosu::KbS]
    #   @vel.y += a
    # end
  end

  def button_down(id)
    @buttons[id] = true
  end

  def button_up(id)
    @buttons[id] = false
  end
end