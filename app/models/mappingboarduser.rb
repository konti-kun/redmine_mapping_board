class Mappingboarduser < ActiveRecord::Base
  belongs_to :mappingboard
  belongs_to :user
end
