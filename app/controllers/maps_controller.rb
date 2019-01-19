require 'zbar'

class MapsController < ApplicationController
  unloadable

  before_filter :find_project, :authorize, :only => :index

  def index
    @items = Position.all

    respond_to do |format|
      format.html
      format.json { render json: @items }
    end
  end

  def uploadfile
    uploaded_file = fileupload_param.tempfile
    output_path = Rails.root.join('public', fileupload_param.original_filename)
    image = ZBar::Image.from_jpeg(uploaded_file.read)
    puts image.width, image.height
    qrs = image.process
    qrs.each do |qr|
	    print qr.location, qr.data
    end
    render json: {status: 200,data: @items}
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end 

  def fileupload_param
	  params.require(:uploadfile)
  end
end
