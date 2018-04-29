# This class contains the functionality that every State must have.
class State
  def initialize(options = {})
    @main = options[:main]
  end

  def update
    raise NotImplementedError, 'This is not implemented!'
  end

  def draw
    raise NotImplementedError, 'This is not implemented!'
  end

  def button_down(_id)
    raise NotImplementedError, 'This is not implemented!'
  end
end
