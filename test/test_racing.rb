require 'minitest/autorun'
require_relative '../racing'

class TestRacing < Minitest::Test
  def setup
    @server_socket = Minitest::Mock.new
    player_data = Minitest::Mock.new
    @racers = Racers.new(@server_socket,player_data)

  end

  def test_set_position
    assert_equal(@racers.close, false)
  end


end