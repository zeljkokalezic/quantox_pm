class V1::ProjectsController < V1::BaseController
  before_action :set_project, only: [:show, :update, :destroy]

  def index
    @projects = Project.where(:user_id => project_params[:user_id])
    json_response(@projects)
  end

  def show
    if @project.present?
      json_response(@project)
    else
      head :not_found
    end
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      json_response(@project, :created)
    else
      json_response(@project.errors.full_messages, :unprocessable_entity)
    end
  end

  def update
    if @project.nil?
      json_response(nil, :not_found)
    else
      if @project.update(project_params)
        json_response(@project)
      else
        json_response(@project.errors.full_messages, :unprocessable_entity)
      end
    end

  end

  def destroy
    if @project.present?
      @project.destroy
      head :no_content
    else
      head :not_found
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      #TODO: check if project is ownned by current user
      @project = Project.find_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.permit(:name, :description, :user_id)
    end
end
