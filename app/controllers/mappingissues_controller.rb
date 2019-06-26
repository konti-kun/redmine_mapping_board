require 'query.rb'

class MappingissuesController < ApplicationController
  unloadable

  before_action :find_project, :authorize, :only => [:index]

  helper :queries
  helper :issues
  include QueriesHelper

  def create
    dx = 0
    Mappingboard.find(params["ids"].keys).each do |board|
      Issue.find(params["ids"][board.id.to_s]).each do | issue |
        note = Note.create(x: dx, y: 0, issue_id: issue.id, mappingboard_id: board.id)
        dx += 20
      end
    end
    find_project
    redirect_to action: "index", project_id: @project.id
  end

  def index
    @columns = [
      QueryColumn.new(:id, :sortable => "#{Issue.table_name}.id", :default_order => 'desc', :caption => '#', :frozen => true),
      QueryColumn.new(:tracker, :sortable => "#{Tracker.table_name}.position", :groupable => true),
      QueryColumn.new(:status, :sortable => "#{IssueStatus.table_name}.position", :groupable => true),
      QueryColumn.new(:subject, :sortable => "#{Issue.table_name}.subject"),
    ]
    @mapping_boards = Mappingboard.where(project_id: @project.id).order(:id)
    if Redmine::VERSION::MAJOR < 4 && Redmine::VERSION::MINOR < 3
      retrieve_query
    else
      retrieve_query(IssueQuery, true)
    end

    if @query.valid?
      respond_to do |format|
        format.html {
          @issue_count = @query.issue_count
          @issue_pages = Paginator.new @issue_count, per_page_option, params['page']
          @issues = @query.issues(:offset => @issue_pages.offset, :limit => @issue_pages.per_page)
          render :layout => !request.xhr?
        }
      end
    else
      respond_to do |format|
        format.html { render :layout => !request.xhr? }
        format.any(:atom, :csv, :pdf) { head 422 }
        format.api { render_validation_errors(@query) }
      end
    end
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end 

end
  
