
class MappingboardsController < ApplicationController
  unloadable

  before_action :find_project, :authorize, :only => [:index]

  helper :issues

  def index
    if not Mappingboard.exists?
      Mappingboard.create(:name => "default", :project_id => @project.id)
    end
    @mappingboard = Mappingboard.first
  end

  def show
    @mappingboard = Mappingboard.find(params[:id])
  end

  def apply_issue
    begin
      @issue = Issue.find(params[:issue_id])
      @error = false
    rescue ActiveRecord::RecordNotFound
      @error = true
    end
  end

  def show_issue
    issue = Issue.find(params[:issue_id])
    render json: issue
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end 

end
