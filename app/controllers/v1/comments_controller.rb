class V1::CommentsController < V1::BaseController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  def index
    @comments = Comment.where(:task_id => comment_params[:task_id])
    json_response(@comments)
  end

  # GET /comments/1
  def show
  end

  # POST /comments
  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      json_response(@coment, :created)
    else
      json_response(@coment.errors.full_messages, :unprocessable_entity)
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      json_response(@coment)
    else
      json_response(@coment.errors.full_messages, :unprocessable_entity)
    end
  end

  # DELETE /comments/1
  def destroy
    if @comment.present?
      @comment.destroy
      head :no_content
    else
      head :not_found
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.permit(:text, :user_id, :task_id)
    end
end
