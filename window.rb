require 'gosu'


class Window < Gosu::Window
  def initialize
    super 800, 800, fullscreen = false
    self.caption = "Racing game"
    @track_image = Gosu::Image.new('res/track.jpg')
    @car_image = Gosu::Image.new('res/car.png')
    @image = Gosu::Image.new('res/image.png')
    @angle = 0
    @x = 320
    @y = 240
    @active = false
  end

  def draw
    @track_image.draw(800, 0, 0, -1)
    @car_image.draw_rot(300, 650, 1, 115)
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


  def circle_moving(x_0, y_0, angle)

  end
end

window = Window.new
window.show
# window.draw