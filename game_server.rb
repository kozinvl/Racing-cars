require 'socket'

$window_width = 800
$window_heigth = 800

class Client
  attr_accessor :client_socket, :player_id, :x, :y, :angle

  def initialize(client, id)
    @client_socket = client
    @player_id = id
    @x = rand($window_width)
    @y = rand($window_heigth)
  end

  def listen(players_list)
    loop do
      next unless players_list.size == 2
      info = @client_socket.gets.chomp.split(',')
      id = info[0].to_i
      if (id == 0) && !$players.empty?
        $players = []
      elsif id == 1
        @x = info[1].to_f
        @y = info[2].to_f
        @angle = info[3].to_f
        players_list[1 - @player_id].client_socket.puts "1,#{@x},#{@y},#{@angle}"
        # elsif id == 2
        #   x = info[1].to_f
        #   y = info[2].to_f
        #   vx = info[3].to_f
        #   vy = info[4].to_f
        #   players_list[1 - @player_id].client_socket.puts "2,#{x},#{y},#{vx},#{vy}"
      end
    end
    @client_socket.close
  end
end


server = TCPServer.new '10.129.201.101', 2000
$players = []
loop do
  begin
    Thread.fork(server.accept) do |client|
      num_players = $players.size
      if num_players < 2
        player = Client.new(client, num_players)
        $players << player
        info = "connected #{player.player_id},#{player.x},#{player.y}"
        player.client_socket.puts info
        player.listen($players)
        puts $players
      else
        puts 'error full number of players'
        client.close
      end
    end
  rescue Interrupt
    puts 'Connection closed'
  end
end