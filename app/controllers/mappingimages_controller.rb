class MappingimagesController < ApplicationController
  unloadable

  before_action :find_mappingboard

  def index
    get_mappingimages_json
  end

  def create
    image = Mappingimage.new(mappingimage_url)
    image.mappingboard_id = @mappingboard.id
    image.save
    get_mappingimages_json
  end

  def update
    @image = Mappingimage.find(params[:id])
    @image.update(mappingimage_params)
    get_mappingimages_json
  end

  def destroy
    image = Mappingimage.find(params[:id])
    image.delete
    get_mappingimages_json
  end

  def get_images
    @images = Attachment.where(container_type: "Project", container_id: @mappingboard.project_id).where("content_type LIKE ?", "image/%")
  end

  private

  def find_mappingboard
    @mappingboard = Mappingboard.find(params[:mappingboard_id])
  end

  def mappingimage_url
    params.require(:mappingimage).permit(:url)
  end

  def mappingimage_params
    params.require(:mappingimage).permit(:x,:y,:width,:height)
  end

  def get_mappingimages_json
    images = Mappingimage.where(mappingboard_id: @mappingboard.id)
    render json: images.as_json
  end
end
