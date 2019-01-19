class Position < ActiveRecord::Base
  def update_position(x, y, image, rect)
    trans_x = rect.width.to_f / image.width
    trans_y = rect.height.to_f / image.height

    @x = rect.x + x*trans_x
    @y = rect.y + y*trans_y
  end

end
