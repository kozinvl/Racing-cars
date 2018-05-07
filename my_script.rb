require 'rubygems'
require 'gosu'

WIDTH, HEIGHT = 800, 800

module ZOrder
  BACKGROUND, STARS, PLAYER, UI = *0..3
end
module Tiles
  Grass = 0
  Earth = 1
end

class Tree
  attr_reader :x, :y

  def initialize(image, x, y)
    @image = image
    @x, @y = x, y
  end

  def draw
    # Draw, slowly rotating
    # @image.draw_rot(@x, @y, 0, 25 * Math.sin(Gosu.milliseconds / 133.7))
    @image.draw(@x, @y, 0)
  end
end

# Player class.
class Player
  attr_reader :x, :y

  def initialize(map, x, y)
    @x, @y = x, y
    @vel_x = @vel_y = 0.0
    @angle = 90.0
    @score = 0
    @dir = :left
    @vy = 0 # Vertical velocity
    @map = map
    # Load all animation frames
    @image = Gosu::Image.new('res/car.png')
    # This always points to the frame that is currently drawn.
    # This is set in update, and used in draw.
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def turn_left
    @angle -= 4.5
  end

  def turn_right
    @angle += 4.5
  end

  def accelerate
    @vel_x += Gosu.offset_x(@angle, 0.5)
    @vel_y += Gosu.offset_y(@angle, 0.5)
  end

  def move
    if condition
      @x += @vel_x
      @y += @vel_y
    else
      @x -= @vel_x
      @y -= @vel_y
    end
    @vel_x *= 0.9
    @vel_y *= 0.9
  end

  def condition
    if (20...780).cover?(@x) and (0...800).cover?(@y)
      true
    end
  end

  def draw
    @image.draw_rot(@x, @y, ZOrder::PLAYER, @angle)
  end

  # Could the object be placed at x + offs_x/y + offs_y without being stuck?
  def would_fit(offs_x, offs_y)
    # Check at the center/top and center/bottom for map collisions
    not @map.solid?(@x + offs_x, @y + offs_y) and
        not @map.solid?(@x + offs_x, @y + offs_y - 45)
  end


  def collect_gems(gems)
    # Same as in the tutorial game.
    gems.reject! do |c|
      (c.x - @x).abs < 50 and (c.y - @y).abs < 50
    end
  end
end

# Map class holds and draws tiles and gems.
class Map
  attr_reader :width, :height, :gems

  def initialize(filename)
    # Load 60x60 tiles, 5px overlap in all four directions.
    @tileset = Gosu::Image.load_tiles('media/tileset.png', 80, 80, :tileable => true)

    gem_img = Gosu::Image.new('media/tree.png')
    @gems = []

    lines = File.readlines(filename).map {|line| line.chomp}
    @height = lines.size
    @width = lines[0].size
    @tiles = Array.new(@width) do |x|
      Array.new(@height) do |y|
        case lines[y][x, 1]
        when '"'
          Tiles::Grass
        when '#'
          Tiles::Earth
        when 'x'
          @gems.push(Tree.new(gem_img, x * 50 + 25, y * 50 + 25))
          nil
        else
          nil
        end
      end
    end
  end

  def draw
    # Very primitive drawing function:
    # Draws all the tiles, some off-screen, some on-screen.
    @height.times do |y|
      @width.times do |x|
        tile = @tiles[x][y]
        if tile
          # Draw the tile with an offset (tile images have some overlap)
          # Scrolling is implemented here just as in the game objects.
          @tileset[tile].draw(x * 50 - 5, y * 50 - 5, 0)
        end
      end
    end
    @gems.each {|c| c.draw}
  end

  # Solid at a given pixel position?
  def solid?(x, y)
    y < 0 || @tiles[x / 50][y / 50]
  end
end

class Racing < (Example rescue Gosu::Window)
  def initialize
    super WIDTH, HEIGHT

    self.caption = 'Cptn. Ruby'

    @track = Gosu::Image.new('res/track.jpg', :tileable => true)
    @map = Map.new('media/cptn_ruby_map.txt')
    @player_a = Player.new(@map, 400, 650)
    @player_b = Player.new(@map, 400, 750)
    # The scrolling position is stored as top left corner of the screen.
    @font = Gosu::Font.new(20)
  end

  def needs_cursor?
    true
  end

  def update
    @player_b.move
    @player_b.turn_left if Gosu.button_down? Gosu::KB_A and @player_b.condition
    @player_b.turn_right if Gosu.button_down? Gosu::KB_D and @player_b.condition
    @player_b.accelerate if Gosu.button_down? Gosu::KB_W and @player_b.condition
    @player_b.collect_gems(@map.gems)

    @player_a.move
    @player_a.turn_left if Gosu.button_down? Gosu::KB_LEFT and @player_a.condition
    @player_a.turn_right if Gosu.button_down? Gosu::KB_RIGHT and @player_a.condition
    @player_a.accelerate if Gosu.button_down? Gosu::KB_UP and @player_a.condition



    # move_x = 0
    # move_x -= 5 if Gosu.button_down? Gosu::KB_LEFT
    # move_x += 5 if Gosu.button_down? Gosu::KB_RIGHT
    # move_y = 0
    # move_y -= 5 if Gosu.button_down? Gosu::KB_UP
    # move_y += 5 if Gosu.button_down? Gosu::KB_DOWN
    # @player.update(move_x, move_y)
    @player_a.collect_gems(@map.gems)

  end

  def draw
    @track.draw 0, 0, 0
    # Gosu.translate(-@camera_x, -@camera_y) do
    @map.draw
    @player_a.draw
    @player_b.draw
    # @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    # end
  end

  def button_down(id)
    case id
      # when Gosu::KB_UP
      #   @cptn.try_to_jump
    when Gosu::KB_ESCAPE
      close
    else
      super
    end
  end

end

Racing.new.show if __FILE__ == $0