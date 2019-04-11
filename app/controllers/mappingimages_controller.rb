class MappingimagesController < ApplicationController
  unloadable

  before_action :find_mappingboard

  def index
  end

  def get_images
    @images = Attachment.where(container_type: "Project", container_id: @mappingboard.project_id).where("content_type LIKE ?", "image/%")
  end

  private

  def find_mappingboard
    @mappingboard = Mappingboard.find(params[:mappingboard_id])
  end
end
