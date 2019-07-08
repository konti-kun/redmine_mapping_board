class Note < ActiveRecord::Base
  belongs_to :issue
  belongs_to :mappingboard
  validates :issue, uniqueness: { scope: :mappingboard, message: l(:message_use_issue_yet) }

  def update_position(x, y, image, rect)
    x = (x * (rect["width"].to_f/image.width)).floor + rect["x"].to_i
    y = (y * (rect["height"].to_f/image.height)).floor + rect["y"].to_i
    self.attributes = { x: x, y: y}
  end

  scope :issue_of_notes, ->(mappingboard){
    where(mappingboard_id: mappingboard).eager_load(:issue).joins({issue: :status})
  }

  def self.new_with_issue(mappingboard, issue_id=nil)
    if issue_id.blank?
      issue = Issue.new(project: mappingboard.project)
      issue.author = User.current
      issue.start_date = User.current.today if Setting.default_issue_start_date_to_creation_date?
      if Redmine::VERSION::MAJOR < 4 && Redmine::VERSION::MINOR < 3
        issue.tracker = issue.project.trackers.first
      else
        issue.tracker = issue.allowed_target_trackers.first
      end
    else
      issue = Issue.find(issue_id)
    end
    self.new(x: 0, y: 0, mappingboard:  mappingboard, issue: issue)
  end
end
