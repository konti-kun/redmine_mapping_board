class NotesController < ApplicationController
  unloadable

  before_action :find_mappingboard, :only => [:index, :new, :create, :destroy, :update_pos, :lines]

  helper :issues

  def index
    @items = get_notes_json

    respond_to do |format|
      format.html
      format.json { render :json => @items }
    end
  end

  def new
    @note = Note.new
    @issue = Issue.new
    @issue.project_id = @mappingboard.project_id
    @issue.author ||= User.current
    @issue.start_date ||= User.current.today if Setting.default_issue_start_date_to_creation_date?
    if Redmine::VERSION::MAJOR < 4 && Redmine::VERSION::MINOR < 3
      @issue.tracker ||= @issue.project.trackers.first
    else
      @issue.tracker ||= @issue.allowed_target_trackers.first
    end
  end

  def create
    note = Note.new(:x => 0, :y => 0, :mappingboard_id => @mappingboard.id)
    issue = Issue.find_or_initialize_by(id: params[:issue_id])
    create_ok = true
    if issue.new_record?
      issue.project_id = @mappingboard.project_id
      issue.author ||= User.current
      issue.start_date ||= User.current.today if Setting.default_issue_start_date_to_creation_date?
    else
      create_ok = !Note.exists?(:issue_id => params[:issue_id], :mappingboard_id => @mappingboard.id)
    end
    @error_message = nil
    if create_ok
      issue.tracker_id = params[:issue][:tracker_id]
      issue.subject = params[:issue][:subject]
      issue.save!
      note.issue_id = issue.id
      note.save
    else
      @error_message = l(:message_use_issue_yet)
    end
    @items = get_notes_json
  rescue ActiveRecord::RecordInvalid => e
    @error_message = e.record.errors.full_messages[0]
  end

  def destroy
    note = Note.find(params[:id])
    note.delete
    notes = get_notes_json
    render json: notes
  end

  def update_pos
    note = Note.find(params[:id].to_i)
    note.update!(x: params[:x].to_i, y: params[:y].to_i)
    notes = get_notes_json
    render json: notes
  end

  def lines
    sql = 'select issue_from_id,issue_to_id from issue_relations ir inner join notes on ir.issue_from_id = notes.id where notes.mappingboard_id = :id'
    lines = ActiveRecord::Base.connection.select_all(sql, nil, {id: @mappingboard.id}.to_a)
    render json: lines
  end

  private

  def find_mappingboard
    @mappingboard = Mappingboard.find(params[:mappingboard_id])
  end

  def get_notes_json
    items =Note.where(mappingboard_id: @mappingboard).eager_load(:issue).joins({issue: :status})
    items.as_json(:include => {:issue => {:only => [:subject, :tracker_id], :include => {:status => {:only => [:is_closed]}}}})
  end
end
