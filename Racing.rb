require 'rubygems'
require 'gosu'
require 'socket'
require_relative 'position'
require_relative 'player'
require_relative 'passive_objects'

$rop = 20

class Racers < Gosu::Window
  attr_accessor :listenThread, :serverSocket, :id, :player, :enemy, :running, :font

  def initialize(width, height)
    super(width, height, false)
    self.caption = 'Racing'
    @track = Gosu::Image.new('res/track.jpg', tileable: true)
    @shade_image = Gosu::Image.new('res/shade.png', tileable: true)
    @player = Player.new
    @enemy = Enemy.new
    @blocks = []
    @running = false
    @finish = false
    @font = Gosu::Font.new(self, 'Arial', 24)
    @loading = true
    @countdown = ['3', '2', '1', 'GO!']
    @initial_millis = 0
    @paused = false
    @loading_index = 0
    load_loading_properties
    @timer = 0.0
  end

  def needs_cursor?
    true
  end

  def load_loading_properties
    @loading_font = Gosu::Image.from_text(
        @countdown[@loading_index], 90, font: 'res/Play.ttf'
    )
  end

  def draw_when_loading
    return unless @loading
    @shade_image.draw(0, 0, 4)
    @loading_font.draw_rot($window_width / 2, $window_heigth / 2, 5, 0.0)
    if @loading_index < @countdown.size
      handle_countdown unless @paused
    else
      @initial_millis = Gosu.milliseconds
      @loading = false
      @running = true
    end
  end

  def handle_countdown
    return unless millis / 1000 > 0
    @loading_index += 1
    @initial_millis = Gosu.milliseconds
    @loading_font = Gosu::Image.from_text(
        @countdown[@loading_index], 90, font: 'res/Play.ttf'
    )
  end

  def millis
    Gosu.milliseconds - @initial_millis
  end

  def self.create(_width, _height, server_socket, player_data)
    game = Racers.new($window_width, $window_heigth)
    game.listenThread = Thread.fork do
      begin
        game.listen
      rescue IOError
      end
    end

    game.serverSocket = server_socket
    game.id, x, y = player_data.split(',').map(&:to_f)
    game.id = game.id.to_i
    game.player.setP Position.new(x, y)
    game.player.setV Position.new(0.0, 0.0)
    game.enemy.setP Position.new(-1000, -1000)
    game
  end

  def listen
    while (info = @serverSocket.gets.chomp.split(','))
      x, y, angle = info[1..3].map(&:to_f)
      @enemy.setP Position.new(x, y)
      @enemy.set_angle(angle)
      @timer += 1
    end
  end

  def draw
    case @timer
    when 0..5
      @track.draw 0, 0, 0
    else
      @track.draw 0, 0, 0
      @player.draw
      @enemy.draw
      draw_when_loading
    end
  end

  def update
    if @finish && @running
      @running = false
      @serverSocket.puts '0'
    end
    @player.update if running
    send_me
  end

  def send_me
    @serverSocket.puts "1,#{@player.pos.x},#{@player.pos.y},#{@player.angle}"
  end

  def button_down(id)
    case id
    when
    Gosu::KbQ
      @player.angle = 90
      @running = false
      @serverSocket.puts '0'
      close!
    end
    @player.button_down(id)
  end

  def button_up(id)
    @player.button_up(id)
  end

  def close
    !@running
  end
end

print "Enter IP adress \n"
ip = gets.chomp

server_socket = TCPSocket.new ip.length < 7 ? '10.129.201.101' : ip, 2000

info = server_socket.gets
flag, player_data = info.split(' ')
unless flag.eql?('error')
  game = Racers.create($window_width, $window_heigth, server_socket, player_data)
  game.show
end
server_socket.close
