require 'gosu'

track_path = 'res/track.jpg'
loading_screen_path = 'res/loading_screen.jpg'
shade_image_path = 'res/shade.png'
win_image_path = 'res/victory.jpg'
lose_image_path = 'res/lose.jpg'
game_font_path = 'res/Play.ttf'

IMAGES = { track: Gosu::Image.new(track_path, tileable: true),
           loading_screen: Gosu::Image.new(loading_screen_path, tileable: true),
           shade_image: Gosu::Image.new(shade_image_path, tileable: true),
           win_image: Gosu::Image.new(win_image_path, tileable: true),
           lose_image: Gosu::Image.new(lose_image_path, tileable: true) }.freeze
