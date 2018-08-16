require 'rubygems'
require 'gosu'
require 'socket'
require 'bundler'
require_relative 'position'
require_relative 'player'
require_relative 'passive_objects'
require_relative 'res/data'
require_relative 'res/caching_resources'

module ZOrder
  BACKGROUND, ENEMY, PLAYER, COVER, UI = *0..5
end

class Racers < Gosu::Window
  #   class describes the creation of the application interface and client logic
  # and the interaction of objects in the application
  attr_accessor :listenThread, :serverSocket, :id, :player, :enemy, :running

  def initialize(width, height)
    #     To minimize the constructor, variables are separated and put into methods
    super(width, height, false)
    self.caption = WINDOW[:title]
    @player = Player.new
    @enemy = Enemy.new
    @centre_pos = Position.new(WINDOW[:middle], WINDOW[:middle])
    @font = Gosu::Font.new(self, 'Arial', 24)
    load_properties
    load_resources
  end

  def load_properties
    # initializing variables
    @running = false
    @finish = false
    @loading = true
    @paused = false
    @loading_index = 0
    @number_of_players = 0
    @score_label = 'Score'
    @start_time = 0.0
  end

  def load_resources
    # initializing variables
    @track = IMAGES[:track]
    @loading_screen = IMAGES[:loading_screen]
    @shade_image = IMAGES[:shade_image]
    @win_image = IMAGES[:win_image]
    @lose_image = IMAGES[:lose_image]
    @game_font = 'res/Play.ttf'
    @countdown = %w[3 2 1 GO!]
    @loading_font = Gosu::Image.from_text(
        @countdown[@loading_index], 90, font: @game_font
    )
    @endings = ['You lose', 'You win']
  end

  def self.create(width, height, server_socket, player_data)
    game = Racers.new(width, height)
    game.listenThread = Thread.fork do
      begin
        game.listen
      rescue IOError
        puts 'connection closed'
      end
    end
    game.serverSocket = server_socket
    game.id, x, y = player_data.split(',').map(&:to_f)
    game.id = game.id.to_i
    game.player.set_position Position.new(x, y)
    # game.player.set_velocity Position.new(0.0, 0.0)
    # game.enemy.set_position Position.new(-1000, -1000)
    game
  end

  def needs_cursor?
    # show cursor
    true
  end

  def draw_when_loading
    # when both players are connected, the countdown for the start will start
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
    # Preparing a picture from the text for the counter
    return unless millis / 1000 > 0
    @loading_index += 1
    @loading_font = Gosu::Image.from_text(
        @countdown[@loading_index], 90, font: 'res/Play.ttf'
    )
  end

  def millis
    # time since the connection
    Gosu.milliseconds - @start_time
  end

  def listen
    # listen to the socket

    while (info = @serverSocket.gets.chomp.split(','))
      x, y, angle, score, players, initial_millis = info[1..6].map(&:to_f)
      @enemy.set_position Position.new(x, y)
      @enemy.set_angle(angle)
      @enemy.set_score(score)
      @number_of_players = players
      @start_time = initial_millis
    end
  rescue NoMethodError
    puts 'No method'
  rescue Errno::EPIPE
    STDERR.puts 'Connection broke!'
  end

  def draw
    # The method of rendering all that is in the area of the created window
    if @number_of_players != 2
      @loading_screen.draw(0, 0, ZOrder::UI)
    else
      @track.draw 0, 0, ZOrder::BACKGROUND
      @player.draw
      @enemy.draw
      draw_when_loading
      @font.draw("#{@score_label}: #{@player.score}", 10, 10,
                 ZOrder::UI, 1.0, 1.0, 0xff_f5f5f5)
    end
    show_finish_screen.draw(0, 0, ZOrder::UI) if @finish
  end

  def show_finish_screen
    # shows the ending depending on the results of the game
    @player.score.freeze
    @enemy.score.freeze
    @finish_screen = if @enemy.score > @player.score
                       @lose_image
                     elsif @enemy.score < @player.score
                       @win_image
                     else
                       Gosu::Image.from_text(@endings[2], 90, font: @game_font)
                     end
  end

  def update
    # method of updating the area of rendering and game processes
    if !(0...10).cover?(@player.score) || !(0...10).cover?(@enemy.score) && @running
      close
      @finish = true
      @serverSocket.puts '0'
    end
    @player.update if @running
    @serverSocket.puts send_data
  end

  def send_data
    # send data to the socket from this client
    "1,#{@player.player_position.x},#{@player.player_position.y},#{@player.angle},#{@player.score}"
  end

  def button_down(id)
    # interception of keystrokes
    case id
    when Gosu::KbQ
      @running = false
      @serverSocket.puts '0'
      close!
    end
    @player.button_down(id)
  end

  def button_up(id)
    # interception of the completion of keystrokes
    @player.button_up(id)
  end

  def close
    # flow stop
    !@running
  end
end

server_socket = TCPSocket.new NET_HOST, NET_PORT
info = server_socket.gets
begin
  flag, player_data = info.split(' ')
rescue StandardError
  puts 'Limit is exceeded'
  exit
end
unless flag.eql?('error')
  game = Racers.create($window_width, $window_heigth, server_socket, player_data)
  game.show
end
server_socket.close
