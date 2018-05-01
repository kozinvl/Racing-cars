require "socket"
require "thread"


class ClientServer
  PORT = 3000
  HOST = "localhost"

  def initialize
    @server = TCPServer.new(HOST, PORT)
  end

  def run_server
    loop {
      client = @server.accept #waiting for a client to connect
      client.puts(Time.now)
      client.puts 'Some information to client' #push message to client
      puts client.gets
      x = gets
      client.puts x
    }
    client.close
  end


end


client_server = ClientServer.new
client_server.run_server




