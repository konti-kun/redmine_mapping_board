require 'zbar'

class MapsController < ApplicationController
  unloadable

  before_filter :find_project, :authorize, :only => :index

  def index
    @items = Position.all.order(:number)

    respond_to do |format|
      format.html
      format.json { render json: @items }
    end
  end

  def uploadfile
    uploaded_file = fileupload_param.tempfile
    rect = JSON.parse(params[:rect])
    puts rect
    image = ZBar::Image.from_jpeg(uploaded_file.read)
    qrs = image.process({symbology: 'qrcode'})
    qrs.each_with_index do |qr,i|
      pos = Position.find_or_initialize_by(number: qr.data.to_i)
      x = (qr.location[0][0] * ( rect["width"].to_f/image.width)).floor + rect["x"].to_i
      y = (qr.location[0][1] * ( rect["height"].to_f/image.height)).floor + rect["y"].to_i
      pos.update_attributes(x: x, y: y)
    end
    @items = Position.all.order(:number)
    render json: @items
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end 

  def fileupload_param
	  params.require(:uploadfile)
  end
end
