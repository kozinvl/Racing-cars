require 'minitest/autorun'
require 'gosu'
load 'lib/player.rb'
load 'lib/position.rb'

TEST_RADIUS = 100


class TestPlayer < Minitest::Test
  def setup
    @player_one = Player.new
    @player_two = Player.new
    @position = Position.new(0, 0)

  end

  def test_set_position
    @player_one.set_position(@position)
    assert_equal(@position, @player_one.player_position)
  end

  def test_start_positions
    assert(@player_two.player_position != @player_one.player_position)
  end

  def test_players_not_one_object
    assert(@player_two != @player_one)
  end

  def test_collision
    @player_one.set_position(@position)
    @player_two.set_position(@position)
    assert_equal(@player_one.collide?(
        @player_one.player_position, @player_two.player_position, TEST_RADIUS),
                 true)
  end

  def test_collision_first_player
    @player_one.set_position(@position)
    assert_equal(@player_one.collide?(
        @player_one.player_position, @position, TEST_RADIUS),
                 true)
  end


end
