require "socket"
require "thread"


class ClientServer

  PORT = 12000
  HOST = "10.129.201.49"

  def self.open_server
    server = TCPServer.new(HOST, PORT)
    loop do
      client = server.accept #waiting for a client to connect
      input_line = client.gets
      output_line = 'hi man'
      client.puts output_line #push message to client
      client.close
    end
  end

end