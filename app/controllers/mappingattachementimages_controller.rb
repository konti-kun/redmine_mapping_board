class MappingattachementimagesController < ApplicationController
  unloadable

  before_action :find_project, :only => [:index]

  def index
    images = Attachment.where(container_type: "Project", container_id: @project.id).where("content_type LIKE ?", "image/%")
    urls = []
    images.find_each do |image|
      urls.push({'url'=> url_for(action: :show, id: image.id)})
    end
    render json: urls.as_json

  end

  def show
    attachment = Attachment.find(params[:id])
    send_file attachment.diskfile, :filename => filename_for_content_disposition(attachment.filename),
                                   :type => detect_content_type(attachment),
                                   :disposition => 'inline'
  end

  private 
  def find_project
    @project = Project.find(params[:project_id])
  end 

  def detect_content_type(attachment)
    content_type = attachment.content_type
    if content_type.blank? || content_type == "application/octet-stream"
      content_type = Redmine::MimeType.of(attachment.filename)
    end
    content_type.presence || "application/octet-stream"
  end

end
