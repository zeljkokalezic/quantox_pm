class V1::TasksController < V1::BaseController
  before_action :set_task, only: [:show, :update, :destroy]

  def index
    @tasks = Task.where(:project_id => task_params[:project_id])
    json_response(@tasks)
  end

  def show
    if @task.present?
      json_response(@task)
    else
      head :not_found
    end
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)

    if @task.save
      json_response(@task, :created)
    else
      json_response(@task.errors.full_messages, :unprocessable_entity)
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      json_response(@task, :created)
    else
      json_response(@task.errors.full_messages, :unprocessable_entity)
    end
  end

  # DELETE /tasks/1
  def destroy
    if @task.present?
      @task.destroy
      head :no_content
    else
      head :not_found
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      #TODO: check if tasks can be acessed by current user
      @task = Task.find_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.permit(:name, :description, :user_id, :deadline, :priority, :status, :type, :project_id)
    end
end
