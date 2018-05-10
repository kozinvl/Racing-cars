require 'rubygems'
require 'gosu'
require 'socket'
require_relative 'position'
require_relative 'player'
require_relative 'passive_objects'

module ZOrder
  BACKGROUND, ENEMY, PLAYER, COVER, UI = *0..5
end

class Racers < Gosu::Window
  attr_accessor :listenThread, :serverSocket, :id, :player, :enemy, :running

  def initialize(width, height)
    super(width, height, false)
    self.caption = 'Racing'
    @centre_pos = Position.new($window_width / 2, $window_heigth / 2)
    @track = Gosu::Image.new('res/track.jpg', tileable: true)
    @loading_screen = Gosu::Image.new('res/loading_screen.jpg', tileable: true)
    @shade_image = Gosu::Image.new('res/shade.png', tileable: true)
    @player = Player.new
    @enemy = Enemy.new
    @blocks = []
    @running = false
    @finish = false
    @font = Gosu::Font.new(self, 'Arial', 24)
    @loading = true
    @countdown = ['3', '2', '1', 'GO!']
    @paused = false
    @loading_index = 0
    @server_timer = 0.0
    @score_label = 'Score'
    load_loading_properties
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
    @shade_image.draw(0, 0, ZOrder::COVER)
    @loading_font.draw_rot(@centre_pos.x, @centre_pos.y, ZOrder::UI, 0.0)
    sleep(0.5)
    if @loading_index < @countdown.size
      handle_countdown unless @paused
    else
      @loading = false
      @running = true
    end
  end

  def handle_countdown
    return unless millis / 1000 > 0
    @loading_index += 1
    @loading_font = Gosu::Image.from_text(
        @countdown[@loading_index], 90, font: 'res/Play.ttf'
    )
  end

  def millis
    Gosu.milliseconds - @initial_millis
  end

  def self.create(_width, _height, server_socket, player_data)
    game = Racers.new($window_width, $window_heigth,)
    game.listenThread = Thread.fork do
      begin
        game.listen
      rescue IOError
        puts 'connection closed'
      end
    end

    game.serverSocket = server_socket
    game.id, x, y, timer = player_data.split(',').map(&:to_f)
    game.id = game.id.to_i
    game.player.set_position Position.new(x, y)
    game.player.set_velocity Position.new(0.0, 0.0)
    game.enemy.set_position Position.new(-1000, -1000)
    game
  end

  def listen
    while (info = @serverSocket.gets.chomp.split(','))
      x, y, angle, timer, initial_millis = info[1..5].map(&:to_f)
      @enemy.set_position Position.new(x, y)
      @enemy.set_angle(angle)
      @server_timer = timer
      @initial_millis = initial_millis
    end
  end

  def draw
    if @server_timer != 2
      @loading_screen.draw(0, 0, ZOrder::UI)
    else
      @track.draw 0, 0, ZOrder::BACKGROUND
      @player.draw
      @enemy.draw
      draw_when_loading
      @font.draw("#{@score_label}: #{@counter}", 10, 10,
                 ZOrder::UI, 1.0, 1.0, 0xff_f5f5f5)
    end
  end


  def update
    @counter = @player.circle_counter
    if @player.circle_counter >= 100 && @running
      @running = false
      @serverSocket.puts '0'
    end
    @player.update if running
    send_me
  end

  def send_me
    @serverSocket.puts "1,#{@player.player_position.x},#{@player.player_position.y},#{@player.angle}"
  end

  def button_down(id)
    case id
    when
    Gosu::KbQ
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

puts "Enter IP:  \n"
ip = gets.chomp
server_socket = TCPSocket.new ip.length < 7 ? '10.129.201.101' : ip, 2000
info = server_socket.gets
flag, player_data = info.split(' ')
unless flag.eql?('error')
  game = Racers.create($window_width, $window_heigth, server_socket, player_data)
  game.show
end
server_socket.close
