require 'rspec'
require_relative '../player'

describe Player do

  it 'should do change position to player' do
    @player_one = Player.new
    @player_two = Player.new
    @position = Position.new(0, 0)
    @player_one.set_position(@position)
    expect(@position).to eq @player_one.player_position
  end

  it 'should not be equal' do
    @player_one = Player.new
    @player_two = Player.new
    @position = Position.new(0, 0)
    expect(@player_two.player_position).not_to eq @player_one.player_position
  end
end