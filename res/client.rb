require "thread"
require "socket"

class Client

  PORT = 12000
  HOST = "10.129.201.49"

  def self.setup_networking
    socket = TCPSocket.new(HOST, PORT)
    loop do
      input_line = socket.gets
      puts input_line
      socket.close
    end

  end

end