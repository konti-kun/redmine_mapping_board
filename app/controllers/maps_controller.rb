
class MapsController < ApplicationController
  unloadable

  before_action :find_project, :authorize, :only => :index

  helper :issues

  def new
    find_project
    @note = Note.new
    @issue = Issue.new
    @issue.project = @project
    @issue.author ||= User.current
    @issue.start_date ||= User.current.today if Setting.default_issue_start_date_to_creation_date?
    @issue.tracker ||= @issue.allowed_target_trackers.first
  end

  def apply_issue
    begin
      @issue = Issue.find(params[:issue_id])
      @error = false
    rescue ActiveRecord::RecordNotFound
      @error = true
    end
  end

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
    if result.rows[0][0].nil?
      note = Note.new(:number => 0, :x => 0, :y => 0)
    else
      note = Note.new(:number => result.rows[0][0], :x => 0, :y => 0)
    end
    issue = Issue.find_or_initialize_by(id: params[:issue_id])
    create_ok = true
    if issue.new_record?
      find_project
      issue.project = @project
      issue.author ||= User.current
      issue.start_date ||= User.current.today if Setting.default_issue_start_date_to_creation_date?
    else
      create_ok = !Note.exists?(:issue_id => params[:issue_id])
    end
    @error_message = nil
    if create_ok
      issue.tracker_id = params[:issue][:tracker_id]
      issue.subject = params[:issue][:subject]
      if issue.save!
        note.issue_id = issue.id
        note.save
      else
        @error_message = :message_save_issue_fail
      end
    else
      @error_message = :message_use_issue_yet
    end
    @items = get_notes_json

  end

  def del_note
    note = Note.find_by(:number => params[:number].to_i)
    note.delete
    notes = get_notes_json
    render json: notes
  end

  def update_pos
    note = Note.find_by(:number => params[:number].to_i)
    note.update!(x: params[:x].to_i, y: params[:y].to_i)
    notes = get_notes_json
    render json: notes
  end

  def show_issue
    issue = Issue.find(params[:issue_id])
    render json: issue
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
    return items.as_json(:include => {:issue => {:only => [:subject, :tracker_id]}})
  end
end
