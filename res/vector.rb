class Vector
  CARTESIAN = 0
  POLAR = 1
  attr_accessor :angle, :radius
  attr_reader :car_x, :car_y

  def car_x=(car_x)
    @car_x = car_x
    refresh_polar
  end

  def car_y=(car_y)
    @car_y = car_y
    refresh_polar
  end

  def initialize(scalar_a, scalar_b, coordinate_system)
    @pi = Math::PI
    @angle = 0
    @car_x = 0
    @car_y = 0
    @radius = 0
    if coordinate_system == CARTESIAN
      @car_x = scalar_a
      @car_y = scalar_b
      refresh_polar
    else
      @radius = scalar_a
      @angle = scalar_b
      refresh_cartesian

    end

  end

  def refresh_polar
    @radius = Math.sqrt(@car_x * @car_x + @car_y * @car_y)
    @angle = Math.atan2(@car_y, @car_x)
  end

  def refresh_cartesian
    @car_x = @radius * Math.cos(@angle)
    @car_y = @radius * Math.sin(@angle)
  end

  def normalize_angle(angle)
    angle -= 2 * @pi while angle >= 2 * @pi
    angle

  end
end