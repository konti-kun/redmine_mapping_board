module Common
  extend ActiveSupport::Concern

  include do
  end
  
  private 
  def get_notes_json
    items = Note.eager_load(:issue).order(:number)
    return items.as_json(:include => {:issue => {:only => [:subject, :tracker_id]}})
  end
