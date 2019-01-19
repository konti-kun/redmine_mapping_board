require 'json'

class Rect

  attr_reader :x, :y, :width, :height

  def initialize(*args)
    if args.length == 1
      if args[0].kind_of?(String)
        obj = JSON.load(args[0])
        @x = obj['x']
        @y = obj['y']
        @width = obj['width']
        @height = obj['height']
      end
    elsif args.length >= 4
      @x = args[0]
      @y = args[1]
      @width = args[2]
      @height = args[3]
    end
  end
end

