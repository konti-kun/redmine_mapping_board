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
    image = ZBar::Image.from_jpeg(uploaded_file.read)
    puts image.width, image.height
    qrs = image.process({symbology: 'qrcode'})
    qrs.each_with_index do |qr,i|
      pos = Position.find_or_initialize_by(number: qr.data.to_i)
      x = (qr.location[0][0] * ( 1000.0/image.width)).floor
      y = (qr.location[0][1] * ( 600.0/image.height)).floor
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
