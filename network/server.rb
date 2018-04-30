require 'thread'
require 'socket'
PORT = 3000
HOST = 'localhost' # Заменить этот IP-адрес.
# Выход при нажатии клавиши Enter.
waiter = Thread.new do
  puts 'Press enter for server closing'
  gets
  exit
end
$mutex = Mutex.new
$list = {}

def match?(p1, p2)
  return false if !$list[p1] or !$list[p2]
  if $list[p1][0] == p2 and $list[p2][0] == p1
    true
  else
    false
  end
end

def handle_client(sess, msg, addr, port, ipname)
  $mutex.synchronize do
    cmd, player1, player2 = msg.split
    # Примечание: от клиента мы получаем данные в виде user:hostname,
    # но храним их в виде user:address.
    p1short = player1.dup # Короткие имена
    p2short = player2.split(":")[0] # (то есть не ":address").
    player1 << ":#{addr}" # Добавить IP-адрес клиента.
    user2, host2 = player2.split(':')
    host2 = ipname if host2 == nil
    player2 = user2 + ':' + IPSocket.getaddress(host2)
    if cmd != 'login'
      puts "Protocol Error: Client send message#{msg}."
    end
    $list[player1] = [player2, addr, port, ipname, sess]
    if match?(player1, player2)
      # Имена теперь переставлены: если мы попали сюда, значит
      # player2 зарегистрировался первым.
      p1 = $list[player1]
      р2 = $list[player2]
      # ID игрока = name:ipname:color
      # Цвет: 0=белый, 1=черный
      p1id = "#{p1short}:#{p1[3]}:1"
      p2id = "#{p2short}:#{p2[3]}:0"
      sess1 = p1[4]
      sess2 = p2[4]
      sess1.puts "#{p2id}"
      sess2.puts "#{p1id}"
      sess1.close
      sess2.close
    end
  end
end

text = nil
$server = TCPServer.new(HOST, PORT)
while (session = $server.accept) do
  Thread.new(session) do |sess|
    text = sess.gets
    puts "Got: #{text}" # Чтобы знать, что сервер получил.
    domain, port, ipname, ipaddr = sess.peeraddr
    handle_client sess, text, ipaddr, port, ipname
    sleep 1
  end
end
waiter.join # Выходим, когда была нажата клавиша Enter.