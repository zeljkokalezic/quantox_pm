require 'rails_helper'

describe V1::ProjectsController do
  # initialize test data
  let(:user) { create(:user) }
  let(:new_user) { create(:user) }
  let!(:projects) {
    (1..10).map do |el|
      FactoryGirl.create(:project, {:user => user})
    end
  }

  let(:project_id) { projects.first.id }

  describe 'authorization' do
    context 'when unauthorized' do
      before do
        get "/v1/projects/#{project_id}"
      end

      it 'returns unauthorized message' do
        expect(response.body).to eq("{\"error\":\"Access denied\"}")
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when authorized' do
      before do
        sign_in user
        get "/v1/projects/#{project_id}"
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns a response' do
        expect(response.body).not_to be_empty
      end
    end
  end

  describe 'GET /v1/projects' do
    context 'user projects exist' do
      before do
        sign_in user
        get "/v1/projects?user_id=#{user.id}"
      end

      it 'returns projects' do
        expect(json).not_to be_empty
        expect(json.size).to eq(10)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'no user projects exist' do
      before do
        sign_in new_user
        get "/v1/projects?user_id=#{new_user.id}"
      end

      it 'returns projects' do
        expect(json).to be_empty
        expect(json.size).to eq(0)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET /v1/projects/:id' do
    before do
      sign_in user
      get "/v1/projects/#{project_id}"
    end

    context 'when the record exists' do
      it 'returns the project' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(project_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:project_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to be_empty
      end
    end
  end

  describe 'POST /v1/projects/' do
    # valid payload
    let(:valid_attributes) { { name: 'Learn Vue JS', description: 'Project for learning', user_id: user.id } }

    context 'when the request is valid' do
      before do
        sign_in user
        post '/v1/projects/', params: valid_attributes
      end

      it 'creates a project' do
        expect(json['name']).to eq(valid_attributes[:name])
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before do
        sign_in user
        post '/v1/projects/', params: { title: 'Foobar' }
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
            .to eq("[\"User must exist\",\"Name can't be blank\",\"Description can't be blank\"]")
      end
    end
  end

  describe 'PUT /v1/projects/' do
    let(:valid_attributes) { { description: 'Description Changed' } }

    context 'when the record exists' do
      before do
        sign_in user
        put "/v1/projects/#{project_id}", params: valid_attributes
      end

      it 'updates the record' do
        expect(json['description']).to eq(valid_attributes[:description])
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      before do
        sign_in user
        put "/v1/projects/#{100}", params: valid_attributes
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'DELETE /v1/projects/:id' do
    context 'when the record does not exist' do
      before do
        sign_in user
        delete "/v1/projects/#{project_id}"
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the record does not exist' do
      before do
        sign_in user
        delete "/v1/projects/#{100}"
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end
