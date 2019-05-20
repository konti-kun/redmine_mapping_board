class Mappingboard < ActiveRecord::Base
  belongs_to :project
  has_many :notes, foreign_key: :mappingboard_id, dependent: :destroy
  has_many :mappingimages, foreign_key: :mappingboard_id, dependent: :destroy
  has_many :mappingboardusers, foreign_key: :mappingboard_id, dependent: :destroy

  def self.get_current(project, user=User.current)
    if not Mappingboard.exists?(project_id: project.id)
      Mappingboard.create(name: "default", project_id: project.id)
    end
    mappingboarduser = Mappingboarduser.find_or_initialize_by(user_id: user.id)
    if mappingboarduser.new_record?
      mappingboard = Mappingboard.where(project_id: project.id).first
      mappingboarduser.update_attributes!(mappingboard_id: mappingboard.id)
      return mappingboard
    else
      return Mappingboard.find(mappingboarduser.mappingboard_id)
    end
  end

  def self.set_current(mappingboard, user=User.current)
    mappingboarduser = Mappingboarduser.find_or_initialize_by(user_id: user.id)
    mappingboarduser.update_attributes!(mappingboard_id: mappingboard.id)
  end
end
