require 'gosu'


class Window < Gosu::Window
  def initialize
    super 800, 800, fullscreen = false
    self.caption = "Racing game"
    @track_image = Gosu::Image.new('res/track.jpg')
    @car_image = Gosu::Image.new('res/car.png')
    @pi = Math::PI
    @angle = 0
    @x = 320
    @y = 240
    @active = false
  end

  def draw
    @track_image.draw(800, 0, 0, -1)
    @car_image.draw_rot(400+Math.sin(@angle*(@pi/180))*300, 400+Math.cos(@angle*(@pi/180))*300, 1, @angle)
    # @image.draw_rot(@x, 300, 1, @angle)

  end

  # def rotate
  #   @image.rotate
  # end

  def update
    if @active
      # @x += 3
      @angle += 3
    else
      @angle -= 3
    end
  end

  def button_down(id)
    if id == Gosu::KB_UP
      @active = @active ? false : true
    end
    if id == Gosu::KB_ESCAPE
      self.close
    end
  end


  def circle_moving(angle)
    @x = Math.sin(angle*(Math.PI/180))*2
    @y = Math.cos(angle*(Math.PI/180))*1
  end
end

window = Window.new
window.show
# window.draw