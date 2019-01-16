class MapsController < ApplicationController
  unloadable

  before_filter :find_project, :authorize, :only => :index

  def index
    @items = Position.all

    respond_to do |format|
      format.html
      format.json { render json: @items }
    end
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end
end
