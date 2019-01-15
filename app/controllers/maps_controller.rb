class MapsController < ApplicationController
  unloadable

  before_filter :find_project, :authorize, :only => :index

  def index
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end
end
