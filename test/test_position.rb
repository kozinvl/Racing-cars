require 'minitest/autorun'
require 'gosu'
load 'lib/player.rb'
load 'lib/position.rb'

TEST_X = 10
TEST_Y = 1

class TestPosition < Minitest::Test
  def setup
    @position = Position.new(TEST_X, TEST_Y)
  end

  def test_instance_of
    assert_instance_of(Position, @position)
  end

  def test_equals_x
    assert_equal(TEST_X, @position.x)
  end

  def test_equals_y
    assert_equal(TEST_Y, @position.y)
  end

  def test_to_str
    test_string = @position.to_s
    assert_match(@position.x.to_s, test_string)
  end
end
