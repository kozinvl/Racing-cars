require 'rspec'
require_relative '../position'


describe Position do

  it 'should be equal in initialize' do
    position = Position.new(10, 1)
    expect(position.x).to eq 10
  end

  it 'should be instance of class' do
    position = Position.new(1, 1)
    expect(position).to be_an_instance_of Position
  end

  it 'should not be' do
    position = Position.new 10, 10.to_s
    expect(position).not_to eq Position.new 10, 10.to_s
  end


end