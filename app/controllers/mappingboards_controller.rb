
class MappingboardsController < ApplicationController
  unloadable

  before_action :find_project, :authorize, :only => [:index]

  helper :issues

  def index
    if not Mappingboard.exists?(project_id: @project.id)
      Mappingboard.create(:name => "default", :project_id => @project.id, :is_current => true)
    end
    @mappingboard = Mappingboard.find_by(project_id: @project.id, is_current: true)
    if @mappingboard.nil?
      @mappingboard = Mappingboard.find_by(project_id: @project.id)
      @mappingboard.update_attribute(:is_current, true)
    end
    @mappingboards = Mappingboard.where(project_id: @project.id)
  end

  def show
    Mappingboard.transaction do
      @mappingboard = Mappingboard.find(params[:id])
      Mappingboard.update_all(is_current: false)
      @mappingboard.update_attributes!(is_current: true)
      redirect_to action: "index", project_id: @mappingboard.project_id
    end
  end

  def create
    find_project
    Mappingboard.transaction do
      Mappingboard.update_all(is_current: false)
      @mappingboad = Mappingboard.create!(:name => "default", :project_id => @project.id, :is_current => true)
      redirect_to action: "index", project_id: @project.id
    end
  end

  def update
    mappingboard = Mappingboard.find(params[:id])
    mappingboard.update(mappingboard_params)
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

  def mappingboard_params
    params.require(:mappingboard).permit(:name)
  end


end
