class NotesController < ApplicationController
  unloadable

  before_action :find_mappingboard, :only => [:index, :new, :create, :destroy, :update_pos, :lines]

  helper :issues

  def index
    notes = get_notes_json
    render json: notes
  end

  def new
    @note = Note.new_with_issue(@mappingboard)
  end

  def create
    Note.transaction do
      note = Note.new_with_issue(@mappingboard, params[:issue_id])
      issue = note.issue
      issue.tracker_id = params[:issue][:tracker_id]
      issue.subject = params[:issue][:subject]
      issue.save!
      note.save!
    end
    @items = get_notes_json
  rescue ActiveRecord::RecordInvalid => e
    @error_message = e.record.errors.full_messages[0]
  rescue ActiveRecord::RecordNotFound
    @error_message = l(:message_not_issue_id)
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
    issue_relations  = IssueRelation.joins("inner join notes on notes.issue_id = issue_relations.issue_from_id").where(notes: {mappingboard_id: @mappingboard.id})
    render json: issue_relations
  end

  private

  def find_mappingboard
    @mappingboard = Mappingboard.find(params[:mappingboard_id])
  end

  def get_notes_json
    items =Note.issue_of_notes(@mappingboard)
    items.as_json(:include => {:issue => {:only => [:subject, :tracker_id], :include => {:status => {:only => [:is_closed]}}}})
  end
end
