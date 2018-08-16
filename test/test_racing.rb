require 'minitest/autorun'


class TestRacing < Minitest::Test
  def setup
    @server_socket = Minitest::Mock.new
    #exec 'echo "ruby game_server.rb"'
    exec 'ruby game_server.rb alias="raging"'
    exec 'kill "/Users/mshuma/RubymineProjects/Racing-cars/game_server.rb"'
    #player_data = Minitest::Mock.new
    #@racers = Minitest::Mock.new

  end

  def test_set_position
    exec 'kill game_server.rb'
    #assert_equal(@racers.close, false)
  end

  def teardown
    exec 'kill game_server.rb'
  end


end