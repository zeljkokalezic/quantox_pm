class V1::DocumentsController < V1::BaseController
  before_action :set_document, only: [:show, :edit, :update, :destroy]

  # GET /documents
  def index
    @documents = Document.where(:comment_id => document_params[:comment_id])
    json_response(@documents)
  end

  # GET /documents/1
  def show
    if @document.present?
        send_data(@document.file_contents,
              type: @document.content_type,
              filename: @document.filename,
              disposition: 'inline')
    else
      head :not_found
    end
  end

  # POST /documents
  def create
    @document = Document.new(document_params)

    if @document.save
      json_response(@document, :created)
    else
      json_response(@document.errors.full_messages, :unprocessable_entity)
    end
  end

  # DELETE /documents/1
  def destroy
    if @document.present?
      @document.destroy
      head :no_content
    else
      head :not_found
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.permit(:file, :comment_id)
    end
end
