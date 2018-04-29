require "thread"
require "socket"

class Client

  PORT = 12000
  HOST = "localhost"

  def initialize
    @socket = TCPSocket.new(HOST, PORT)
    self.setup_networking
  end

  def setup_networking
    loop do
      input_line = @socket.gets #getting message from client
      puts input_line
      socket.close
    end

  end

end


client = Client.new






