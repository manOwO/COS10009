require 'rubygems'
require 'gosu'
require './circle'

# The screen has layers: Background, middle, top
module ZOrder
  BACKGROUND, MIDDLE, TOP = *0..2
end

class DemoWindow < Gosu::Window
  def initialize
    super(640, 400, false)
  end

  def draw
    # see www.rubydoc.info/github/gosu/gosu/Gosu/Color for colours
    draw_quad(0, 0, Gosu::Color::BLUE, 640, 0, Gosu::Color::BLUE, 0, 400, Gosu::Color::AQUA, 640, 400, Gosu::Color::AQUA, ZOrder::BACKGROUND)
    
    

    # Circle parameter - Radius
    img2 = Gosu::Image.new(Circle.new(50))
    # Image draw parameters - x, y, z, horizontal scale (use for ovals), vertical scale (use for ovals), colour
    # Colour - use Gosu::Image::{Colour name} or .rgb({red},{green},{blue}) or .rgba({alpha}{red},{green},{blue},)
    # Note - alpha is used for transparency.
    img2.draw(0, 300, ZOrder::TOP, 6, 6, Gosu::Color::GREEN)

    # draw_rect works a bit differently:
    Gosu.draw_rect(330, 270, 5, 60, 0xff_FF7700, ZOrder::TOP, mode=:default)
    Gosu.draw_rect(360, 270, 5, 60, 0xff_FF7700, ZOrder::TOP, mode=:default)

    img2.draw(308, 205, ZOrder::TOP, 0.825, 1.0, 0xff_FFCB50)
    
    img2.draw(300, 110, ZOrder::TOP, 1.0, 1.0, 0xff_FFCB50)

    
    
    
    draw_triangle(350, 215, 0xff_FF7700, 350, 180, Gosu::Color::RED, 330, 190, 0xff_FF7700, ZOrder::MIDDLE, mode=:default)

    draw_triangle(350, 115, 0xff_FF7700, 350, 80, Gosu::Color::RED, 330, 90, 0xff_FF7700, ZOrder::MIDDLE, mode=:default)
  end
end

DemoWindow.new.show
