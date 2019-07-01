class Note < ActiveRecord::Base
  belongs_to :issue
  belongs_to :mappingboard
  validates :issue, uniqueness: { scope: :mappingboard, message: l(:message_use_issue_yet) }

  def update_position(x, y, image, rect)
    x = (x * (rect["width"].to_f/image.width)).floor + rect["x"].to_i
    y = (y * (rect["height"].to_f/image.height)).floor + rect["y"].to_i
    self.attributes = { x: x, y: y}
  end
end
