require "socket"
require "thread"


class ClientServer
  PORT = 12000
  HOST = "localhost"

  def initialize
    @server = TCPServer.new(HOST, PORT)
    self.run_server
  end

  def run_server
    loop do
      client = @server.accept #waiting for a client to connect
      input_line = client.gets
      client.puts 'hi man' #push message to client
      client.close
    end
  end


end


client_server = ClientServer.new




