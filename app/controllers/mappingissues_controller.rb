class MappingissuesController < ApplicationController
  unloadable

  before_action :find_project, :authorize, :only => [:index]

  helper :queries
  helper :issues
  include QueriesHelper

  def index
    use_session = !request.format.csv?
    retrieve_query(IssueQuery, use_session)

    p params[:f]

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
  
