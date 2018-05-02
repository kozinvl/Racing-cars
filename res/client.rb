require "thread"
require "socket"

class Client

  PORT = 3000
  HOST = "10.129.201.49"

  def initialize
    @socket = TCPSocket.open(HOST, PORT)
  end

  def setup_networking
    x = true
    while x
      puts @socket.gets #getting message from client
      puts @socket.gets 
      @socket.puts(Time.now)
    end
    @socket.close
  end
end


client = Client.new
client.setup_networking






