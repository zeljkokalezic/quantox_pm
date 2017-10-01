require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:user) { create(:user) }

  describe "GET #index" do
    it "returns a success response" do
      sign_in user

      get :index, params: {}
      p response.body
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      sign_in user
      project = create(:project)
      get :show, params: {id: project.to_param}
      expect(response).to be_success
    end
  end

end
