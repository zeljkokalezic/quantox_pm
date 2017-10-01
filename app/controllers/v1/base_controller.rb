class V1::BaseController < ActionController::API
  include Response

  #proper token based auth should be implemented (eg. jwt)
  #but this is ok for now
  before_action :authenticate_api!

  def authenticate_api!
     unless current_user
       self.status = :unauthorized
       self.response_body = { error: 'Access denied' }.to_json
     end
  end
end
