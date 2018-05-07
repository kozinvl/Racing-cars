require_relative 'position'
$winW, $winH = 800, 800
$rop = 20

class Enemy
  attr_accessor :pos, :angle
  attr_reader :l

  def initialize
    @pos = Position.zero
    @l = $rop
    # @color = 0xff_ff0000
    @image = Gosu::Image.new('res/car.png')
    @angle = 0.0
  end

  def setP(pos)
    @pos = pos
  end

  def set_angle(angle)
    @angle = angle
  end

=begin
  def draw(window)

    window.draw_rect(@pos.x - @l, @pos.y - @l, @pos.x + @l, @pos.y + @l, @color, 1)
  end
=end

  def draw
    @image.draw_rot(@pos.x, @pos.y, 1, @angle)
  end
end
# class Block
#   CONST_VEL = 6.5
#   attr_accessor :pos, :vel, :for_delete
#   attr_reader :l, :from_enemy
#
#   def initialize(pos, vel, from_enemy = false)
#     @pos = pos
#     @vel = vel
#     @l = $rop / 5.0
#     @from_enemy = from_enemy
#     @color = (from_enemy) ? 0xff_ff8800 : 0xff_88ff00
#     @for_delete = false
#   end
#
#   def setP(pos)
#     @pos = pos
#   end
#
#   def draw(window)
#     window.draw_rect(@pos.x - @l, @pos.y - @l, @pos.x + @l, @pos.y + @l, @color, 1)
#   end
#
#   def update
#     @pos = Position.add(@pos, @vel)
#     if !@pos.x.between?(0, $winW) or !@pos.y.between?(0, $winH)
#       @for_delete = true
#     end
#   end
# end