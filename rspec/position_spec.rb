require 'rspec'
require_relative '../position'


describe Position do

  it 'should do equal in initialize' do
    position = Position.new(10, 1)
    expect(position.x).to eq 10
  end

  it 'should instance of class' do
    position = Position.new(1, 1)
    expect(position).to be_an_instance_of Position
  end

end