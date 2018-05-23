require 'rspec'
require_relative '../position'


describe Position do

  before :each do
    @position = Position.new(10, 1)
  end

  it 'should be equal x var in initialize' do
    expect(@position.x).to eq 10
  end

  it 'should be equal y var in initialize' do
    expect(@position.y).to eq 1
  end

  it 'should be instance of class' do
    expect(@position).to be_an_instance_of Position
  end

  it 'should not be equal instances' do
    expect(@position).not_to eq Position.new 10, 10
  end

end