class Mappingboard < ActiveRecord::Base
  belongs_to :project
  has_many :notes, foreign_key: :mappingboard_id, dependent: :destroy
  has_many :mappingimages, foreign_key: :mappingboard_id, dependent: :destroy
end
