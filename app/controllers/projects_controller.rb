class ProjectsController < ApplicationController
  before_action :set_project, only: [:show]

  def index
  end

  # GET /projects/1
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end
end
