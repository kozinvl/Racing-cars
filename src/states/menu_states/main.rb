# This class handles the Main menu behavior.
class MainMenuState < MenuState
  def initialize(options = {})
    super options
    @options = @main.lang['menu']
    @margins = [30, 40]
  end

  def load_assets
    @font = Gosu::Font.new(25, name: Path::FONTS + 'Play-Regular.ttf')
    @background = Gosu::Image.new(Path::IMAGES + 'menu-bg.jpg',
                                  tileable: true)
  end

  def draw
    super
    @options.each_with_index do |option, i|
      caption = option
      caption = '  ' + caption if i == @current_option
      top_margin = @margins[0] + (@margins[1] * i)
      @font.draw(caption, @margins[0], top_margin, ZOrder::UI)
    end
  end

  def handle_choice
    case @current_option
    when @options.size - 1
      @main.close
    else
      @main.state = @current_option + 1
    end
  end
end
