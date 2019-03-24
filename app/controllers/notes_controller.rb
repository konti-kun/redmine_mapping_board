class NotesController < ApplicationController
  unloadable

  before_action :find_mappingboard, :only => [:index, :new, :create, :destroy, :update_pos]

  helper :issues

  def index
    @items = get_notes_json

    respond_to do |format|
      format.html
      format.json { render :json => @items }
    end
  end

  def new
    p @mappingboard.project_id
    @note = Note.new
    @issue = Issue.new
    @issue.project_id = @mappingboard.project_id
    @issue.author ||= User.current
    @issue.start_date ||= User.current.today if Setting.default_issue_start_date_to_creation_date?
    @issue.tracker ||= @issue.allowed_target_trackers.first
  end

  def create
    query = <<-SQL
      SELECT MIN(number + 1) AS number
      FROM notes
      WHERE (number + 1) NOT IN(SELECT number FROM notes)
    SQL
    result = ActiveRecord::Base.connection.select_all(query)
    if result.rows[0][0].nil?
      note = Note.new(:number => 0, :x => 0, :y => 0, :mappingboard_id => @mappingboard.id)
    else
      note = Note.new(:number => result.rows[0][0], :x => 0, :y => 0, :mappingboard_id => @mappingboard.id)
    end
    issue = Issue.find_or_initialize_by(id: params[:issue_id])
    create_ok = true
    if issue.new_record?
      issue.project_id = @mappingboard.project_id
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

  def destroy
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

  private

  def find_mappingboard
    @mappingboard = Mappingboard.find(params[:mappingboard_id])
  end

  def get_notes_json
    items = Note.where(mappingboard_id: @mappingboard).eager_load(:issue).order(:number)
    return items.as_json(:include => {:issue => {:only => [:subject, :tracker_id]}})
  end
end
