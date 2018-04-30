require 'socket'
require 'timeout'
ChessServer = 'localhost' # Заменить этот IP-адрес.
ChessServerPort = 3000
PeerPort = 3000
WHITE, BLACK = 0, 1
Colors = %w[White Black]

def draw_board(board)
  puts <<-EOF
+------------------------------+
| Заглушка! Шахматная доска... |
+------------------------------+
  EOF
end

def analyze_move(who, move, num, board)
  # Заглушка - черные всегда выигрывают на четвертом ходу.
  if who == BLACK and num == 4
    move << ' Мат!'
  end
  true # Еще одна заглушка - любой ход считается допустимым.
end

def my_move(who, lastmove, num, board, sock)
  ok = false
  until ok do
    print 'Your turn: '
    move = STDIN.gets.chomp
    ok = analyze_move(who, move, num, board)
    puts 'Invalid turn' unless ok
  end
  sock.puts move
  move
end

def other_move(who, move, num, board, sock)
  move = sock.gets.chomp
  puts "Opponent: #{move}"
  move
end

if ARGV[0]
  myself = ARGV[0]
else
  print 'Enter your name please '
  myself = STDIN.gets.chomp
end
if ARGV[1]
  opponent_id = ARGV[1]
else
  print 'Opponents name '
  opponent_id = STDIN.gets.chomp
end
opponent = opponent_id.split(":")[0] # Удалить имя хоста.
# Обратиться к серверу
socket = TCPSocket.new(ChessServer, ChessServerPort)
response = nil
socket.puts "login # {myself} #{opponent_id}"
socket.flush
response = socket.gets.chomp
name, ipname, color = response.split ":"
color = color.to_i
if color == BLACK # Цвет фигур другого игрока,
  puts 'Connection starting...'
  server = TCPServer.new(PeerPort)
  session = server.accept
  str = nil
  begin
    timeout(30) do
      str = session.gets.chomp
      if str != 'ready'
        raise "Protocol error: message 'Ready to start is got' #{str}."
      end
    end
  rescue TimeoutError
    raise "He получено сообщение о готовности от противника."
  end
  puts "Ваш противник #{opponent}... у вас белые.n"
  who = WHITE
  move = nil
  board = nil # В этом примере не используется.
  num = 0
  draw_board(board) # Нарисовать начальное положение для белых.
  loop do
    num += 1
    move = my_move(who, move, num, board, session)
    draw_board(board)
    case move
      when "resign"
        puts "nВы сдались. #{opponent} выиграл."
        break
      when /Checkmate/
        puts "nВы поставили мат #{opponent}!"
        draw_board(board)
        break
    end
    move = other_move(who, move, num, board, session)
    draw_board(board)
    case move
      when "resign"
        puts "n#{opponent} сдался... вы выиграли!"
        break
      when /Checkmate/
        puts "n#{opponent} поставил вам мат."
        break
    end
  end
else # Мы играем черными,
  puts "nУстанавливается соединение..."
  socket = TCPSocket.new(ipname, PeerPort)
  socket.puts "ready"
  puts "Ваш противник #{opponent}... у вас черные.n"
  who = BLACK
  move = nil
  board = nil # В этом примере не используется.
  num = 0
  draw_board(board) # Нарисовать начальное положение.
  loop do
    num += 1
    move = other_move(who, move, num, board, socket)
    draw_board(board) # Нарисовать доску после хода белых,
    case move
      when "resign"
        puts "n#{opponent} сдался... вы выиграли!"
        break
      when /Checkmate/
        puts "n#{opponent} поставил вам мат."
        break
    end
    move = my_move(who, move, num, board, socket)
    draw_board(board)
    case move
      when "resign"
        puts "nВы сдались. #{opponent} выиграл."
        break
      when /Checkmate/
        puts "n#{opponent} поставил вам мат."
        break
    end
  end
  socket.close
end