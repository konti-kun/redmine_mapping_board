class MappingimagesController < ApplicationController
  unloadable

  before_action :find_mappingboard

  def index
  end

  def create
    image = Mappingimage.new(mappingimage_params)
    image.save
    images = Mappingimage.where(mappingboard_id: @mappingboard.id)
    render json: images.as_json
  end

  def get_images
    @images = Attachment.where(container_type: "Project", container_id: @mappingboard.project_id).where("content_type LIKE ?", "image/%")
  end

  private

  def find_mappingboard
    @mappingboard = Mappingboard.find(params[:mappingboard_id])
  end

  def mappingimage_params
    params.require(:mappingimage).permit(:url)
  end
end
