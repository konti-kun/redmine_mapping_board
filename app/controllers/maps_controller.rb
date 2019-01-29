require 'zbar'

class MapsController < ApplicationController
  unloadable

  before_filter :find_project, :authorize, :only => :index

  def index
    @items = Note.eager_load(:issue).order(:number)
    @items = JSON.parse(@items.to_json(:include => {:issue => {:only => :subject}}))

    respond_to do |format|
      format.html
      format.json { render :json => @items }
    end
  end

  def uploadfile
    uploaded_file = fileupload_param.tempfile
    rect = JSON.parse(params[:rect])
    image = ZBar::Image.from_jpeg(uploaded_file.read)
    qrs = image.process({symbology: 'qrcode'})
    qrs.each_with_index do |qr,i|
      pos = Note.find_or_initialize_by(number: qr.data.to_i)
      pos.update_position(qr.location[0][0],qr.location[0][1],image,rect)
      pos.save()
    end
    @items = Note.eager_load(:issue).order(:number)
    @items = JSON.parse(@items.to_json(:include => {:issue => {:only => :subject}}))
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
