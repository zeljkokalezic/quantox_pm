require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { create(:user) }

  describe "GET #show" do
    it "returns a success response" do
      sign_in user

      task = create(:task)
      get :show, params: {id: task.to_param}
      expect(response).to be_success
    end
  end

end
