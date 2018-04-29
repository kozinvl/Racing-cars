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
    @speed=0
    @move=false
    @center_coordinates=400

    @active = false
  end

  def draw
    @track_image.draw(800, 0, 0, -1)
    @car_image.draw_rot(circle_moving_x, circle_moving_y, 1, @angle)
    # @image.draw_rot(@x, 300, 1, @angle)

  end

  # def rotate
  #   @image.rotate
  # end

  def update
    if @active
      @speed+=2
    elsif !@active
      @angle -= 0
    end
  end

  def button_down(id)
    case id
      when Gosu::KB_UP
        @active=true
        @speed+=3
      when Gosu::KB_DOWN
        @active = false
      when Gosu::KB_ESCAPE
        self.close
      when Gosu::KB_LEFT
        @angle -= 210
      when Gosu::KB_RIGHT
        @angle +=210

    end
  end
end


def circle_moving_x
  @center_coordinates+Math.sin(@speed*(@pi/360))*260
end


def circle_moving_y
  @center_coordinates+Math.cos(@speed*(@pi/360))*260
end


window = Window.new
window.show
# window.draw