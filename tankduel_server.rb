require 'socket'

$winW = 800
$winH = 800

class Player
  attr_accessor :clientSocket, :player_id, :x, :y, :life

  def initialize(client, id)
    @clientSocket = client
    @player_id = id
    @x = rand($winW)
    @y = rand($winH)
    @life = 100
  end

  def listen(players_list)
    loop do
      next unless players_list.size == 2
      #puts "listening player #{@player_id}"
      info = @clientSocket.gets.chomp.split(',')
      id = info[0].to_i
      if (id == 0) && !$players.empty?
        $players = []
      elsif id == 1
        @x = info[1].to_f
        @y = info[2].to_f
        @life = info[3].to_f
        players_list[1 - @player_id].clientSocket.puts "1,#{@x},#{@y},#{@life}"
      elsif id == 2
        x = info[1].to_f
        y = info[2].to_f
        vx = info[3].to_f
        vy = info[4].to_f
        players_list[1 - @player_id].clientSocket.puts "2,#{x},#{y},#{vx},#{vy}"
      end
      #puts "#{id},#{@x},#{@y}"
    end
    @clientSocket.close
  end
end


server = TCPServer.new '10.129.201.101', 2000
$players = []
loop do
  Thread.fork(server.accept) do |client|
    num_players = $players.size
    if num_players < 2
      player = Player.new(client, num_players)
      $players << player
      info = "conectado #{player.player_id},#{player.x},#{player.y}"
      player.clientSocket.puts info
      #puts info
      #puts "player #{num_players} adicionado"
      player.listen($players)
      elseв.puts 'error SalaCheia'
      clцnt.close
    end
  end
end