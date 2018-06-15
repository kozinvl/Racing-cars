require 'rspec'
require_relative '../player'


describe Player do

  before :each do
    @player_one = Player.new
    @player_two = Player.new
    @position = Position.new(0, 0)
    @first_player_pos = @player_one.player_position
    @second_player_pos = @player_two.player_position
  end

  it 'should change position to player' do
    @player_one.set_position(@position)
    expect(@position).to eq @player_one.player_position
  end

  it 'should not be equal start position' do
    expect(@second_player_pos).not_to eq @first_player_pos
  end

  it 'should be truthy in collide func' do
    @player_one.set_position(@position)
    @player_two.set_position(@position)
    collide_result = @player_one.collide?(@second_player_pos, 100)
    expect(collide_result).to be_truthy
  end

  context 'when clicking A button' do
    it 'changes cars angle' do
      @player_one.button_down(Gosu::KbA)
      @player_one.check_pressed
      angle_result = @player_one.angle
      expect(angle_result).to eq 85.5
    end
  end

  context 'when clicking D button' do
    it 'changes cars angle' do
      @player_one.button_down(Gosu::KbD)
      @player_one.check_pressed
      angle_result = @player_one.angle
      expect(angle_result).to eq 94.5
    end
  end

  context 'when clicking S button' do
    it 'changes cars velocity' do
      @player_one.button_down(Gosu::KbS)
      @player_one.check_pressed
      velocity_result_x = @player_one.velocity.x
      velocity_result_y = @player_one.velocity.y
      expect(velocity_result_x).to eq 0.0
      expect(velocity_result_y).to eq 0.0
    end
  end

  context 'when clicking S button' do
    it 'returns false' do
      result = @player_one.button_up Gosu::KbS
      expect(result).to be_falsey
    end
  end

  context 'when clicking W button' do
    it 'returns true' do
      result = @player_one.button_down Gosu::KbW
      expect(result).to be_truthy
    end
  end

end