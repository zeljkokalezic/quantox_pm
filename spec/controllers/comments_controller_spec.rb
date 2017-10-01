require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }

  describe "GET #show" do
    it "returns a success response" do
      sign_in user

      comment = create(:comment)
      get :show, params: {id: comment.to_param}
      expect(response).to be_success
    end
  end

end
