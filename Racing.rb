require 'rubygems'
require 'gosu'
require 'socket'
require_relative 'position'
require_relative 'player'
require_relative 'passive_objects'

$winW = 800
$winH = 800
$rop = 20

class Racers < Gosu::Window
  attr_accessor :listenThread, :serverSocket, :id, :player, :enemy, :running, :font

  def initialize(width, height)
    super(width, height, false)
    self.caption = 'TankDuel'
    @track = Gosu::Image.new('res/track.jpg', tileable: true)
    @player = Player.new
    @enemy = Enemy.new
    @blocks = []
    @running = true
    @finish = false
    @font = Gosu::Font.new(self, 'Arial', 24)
  end

  def needs_cursor?
    true
  end

  def self.create(_width, _height, serverSocket, player_data)
    game = Racers.new($window_width, $window_heigth)
    game.listenThread = Thread.fork do
      begin
        game.listen
      rescue IOError
      end
    end

    game.serverSocket = serverSocket
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
    end
  end

  def draw
    @track.draw 0, 0, 0
    @player.draw
    @enemy.draw
    # draw_line(@player.pos.x, @player.pos.y, 0xffffffff, @mousep.x, @mousep.y, 0xffffffff, 3)
    # if (!@blocks.nil?)
    #   @blocks.each {|b| b.draw(self)}
    # end
    # draw_rect(0, $winH * 0.96, $winW * 0.5 * @player.life / 100.0, $winH, 0xff_3344CC, 5)
    # draw_rect($winW * (1.0 - 0.5 * @enemy.life / 100.0), $winH * 0.96, $winW, $winH, 0xff_7711CC, 5)
    # if !running
    #   if (@player.life <= 0 and @enemy.life <= 0)
    #     text = "Empate"
    #   elsif @player.life <= 0
    #     text = "Derrota"
    #   else
    #     text = "Vitoria"
    #   end
    #
    #   @font.draw(text, $winW * 0.5, $winH * 0.90, 6, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
    # end
  end

  # def draw_rect(xo, yo, xf, yf, c = 0xffffffff, z = 0)
  #   draw_quad(xo, yo, c, xf, yo, c, xf, yf, c, xo, yf, c, z)
  # end

  def update
    if @finish && @running
      @running = false
      @serverSocket.puts '0'
    end
    @player.update if running
    # if (!@blocks.nil?)
    #   @blocks.each {|b| b.update;}
    #   @blocks.each do |b|
    #     check_X = b.pos.x.between?(@player.pos.x - @player.l, @player.pos.x + @player.l)
    #     check_Y = b.pos.y.between?(@player.pos.y - @player.l, @player.pos.y + @player.l)
    #     check_eX = b.pos.x.between?(@enemy.pos.x - @enemy.l, @enemy.pos.x + @enemy.l)
    #     check_eY = b.pos.y.between?(@enemy.pos.y - @enemy.l, @enemy.pos.y + @enemy.l)
    #     if (check_eX and check_eY and not b.from_enemy)
    #       b.for_delete = true
    #     end
    #     if (check_X and check_Y and b.from_enemy)
    #       b.for_delete = true
    #       @player.life = [@player.life - @player.dmg, 0].max
    #     end
    #   end
    #   @blocks.select! {|b| !b.for_delete}
    # end
    sendMe
  end

  def sendMe
    @serverSocket.puts "1,#{@player.pos.x},#{@player.pos.y},#{@player.angle}"
  end

  # def sendBlock(block)
  #   @serverSocket.puts "2,#{block.pos.x},#{block.pos.y},#{block.vel.x},#{block.vel.y}"
  # end

  # def shoot
  #   shoot_vel = Block::CONST_VEL
  #   dif = Position.sub(mousepos, @player.pos)
  #   dif = Position.mult(dif, shoot_vel / Position.modulo(dif))
  #   block = Block.new(@player.pos, dif)
  #   sendBlock(block)
  #   @blocks << block
  # end

  def button_down(id)
    case id
    when
    Gosu::KbQ
      @player.angle = 92
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
