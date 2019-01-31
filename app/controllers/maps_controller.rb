
class MapsController < ApplicationController
  unloadable

  before_filter :find_project, :authorize, :only => :index

  def index
    @items = get_notes_json

    respond_to do |format|
      format.html
      format.json { render :json => @items }
    end
  end

  def add_note
    query = <<-SQL
      SELECT MIN(number + 1) AS number
      FROM notes
      WHERE (number + 1) NOT IN(SELECT number FROM notes)
    SQL

    result = ActiveRecord::Base.connection.select_all(query)
    if result.rows.length > 0
      Note.create(:number => result.rows[0][0], :x => 0, :y => 0)
    else
      Note.create(:number => 0, :x => 0, :y => 0)
    end
    items = get_notes_json
    render json: items
  end

  def update_pos
    note = Note.find_by(:number => params[:number].to_i)
    p note
    note.x = params[:x].to_i
    note.y = params[:y].to_i
    note.save
    items = get_notes_json
    render json: items
  end

  def uploadfile
    require 'zbar'
    require 'opencv'
    include OpenCV
    uploaded_file = fileupload_param.tempfile
    rect = JSON.parse(params[:rect])
    src_img = CvMat.decode_image(uploaded_file.read)
    bin_img = src_img.threshold(128, 255, :binary)
    image = ZBar::Image.from_jpeg(bin_img.encode_image(".jpg").pack("C*"))
    qrs = image.process({symbology: 'qrcode'})
    qrs.each_with_index do |qr,i|
      pos = Note.find_or_initialize_by(number: qr.data.to_i)
      pos.project_id = params[:project_id]
      pos.update_position(qr.location[0][0],qr.location[0][1],image,rect)
      pos.save()
    end
    items = get_notes_json
    render json: items
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end 

  def fileupload_param
	  params.require(:uploadfile)
  end

  def get_notes_json
    items = Note.eager_load(:issue).order(:number)
    return JSON.parse(items.to_json(:include => {:issue => {:only => [:subject, :tracker_id]}}))
  end
end
