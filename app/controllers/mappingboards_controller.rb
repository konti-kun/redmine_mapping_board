
class MappingboardsController < ApplicationController
  unloadable

  before_action :find_project, :authorize, :only => [:index]

  helper :issues

  def index
    @mappingboard = Mappingboard.get_current(@project)
    @mappingboards = Mappingboard.where(project_id: @project.id).order(:id)
    @zoom = session["zoom_#{@mappingboard.id}"]
  end

  def show
    @mappingboard = Mappingboard.find(params[:id])
    Mappingboard.set_current(@mappingboard)
    redirect_to action: "index", project_id: @mappingboard.project_id
  end

  def create
    find_project
    @mappingboard = Mappingboard.create!(:name => "default", :project_id => @project.id)
    Mappingboard.set_current(@mappingboard)
    redirect_to action: "index", project_id: @project.id
  end

  def update
    mappingboard = Mappingboard.find(params[:id])
    mappingboard.update(mappingboard_params)
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def destroy
    mappingboard = Mappingboard.find(params[:id])
    mappingboard.destroy!
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def apply_issue
    begin
      @issue = Issue.find(params[:issue_id])
      @error = false
    rescue ActiveRecord::RecordNotFound
      @error = true
    end
  end

  def set_zoom
    mappingboard = Mappingboard.find(params[:id])
    session["zoom_#{mappingboard.id}"] = {
      k: params[:zoom_k],
      x: params[:zoom_x],
      y: params[:zoom_y]
    }
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end 

  def mappingboard_params
    params.require(:mappingboard).permit(:name)
  end


end
