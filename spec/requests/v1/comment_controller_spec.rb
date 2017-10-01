require 'rails_helper'

describe V1::CommentsController do
  # initialize test data
  let(:user) { create(:user) }
  let(:new_user) { create(:user) }
  let(:task) { FactoryGirl.create(:task) }
  let(:task_id) { task.id }
  let!(:comments) {
    (1..10).map do |el|
      FactoryGirl.create(:comment, {
          :task => task
      })
    end
  }
  let(:comment_id) { comments.first.id }

  describe 'authorization' do
    context 'when unauthorized' do
      before do
        get "/v1/comments/"
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
        get "/v1/comments/"
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns a response' do
        expect(response.body).not_to be_empty
      end
    end
  end

  describe 'GET /v1/comments' do
    context 'comments exist' do
      before do
        sign_in user
        get "/v1/comments?task_id=#{task_id}"
      end

      it 'returns comments' do
        expect(json).not_to be_empty
        expect(json.size).to eq(10)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'no comments exist' do
      before do
        sign_in new_user
        get "/v1/comments?user_id=#{new_user.id}"
      end

      it 'returns comments' do
        expect(json).to be_empty
        expect(json.size).to eq(0)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET /v1/comments/:id' do
    before do
      sign_in user
      get "/v1/comments/#{comment_id}"
    end

    context 'when the record exists' do
      it 'returns the project' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(comment_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:comment_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to be_empty
      end
    end
  end

  describe 'POST /v1/comments/' do
    # valid payload
    let(:valid_attributes) { { text: 'Learning Vue JS is nice', task_id: task_id, user_id: user.id} }

    context 'when the request is valid' do
      before do
        sign_in user
        post '/v1/comments/', params: valid_attributes
      end

      it 'creates a task' do
        expect(json['text']).to eq(valid_attributes[:text])
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before do
        sign_in user
        post '/v1/comments/', params: { title: 'Foobar' }
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
            .to match("[\"User must exist\",\"Name can't be blank\",\"Description can't be blank\"]")
      end
    end
  end

  describe 'PUT /v1/comments/' do
    let(:valid_attributes) { { text: 'Text changed' } }

    context 'when the record exists' do
      before do
        sign_in user
        put "/v1/comments/#{comment_id}", params: valid_attributes
      end

      it 'updates the record' do
        expect(json['text']).to eq(valid_attributes[:text])
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      before do
        sign_in user
        put "/v1/comments/#{100}", params: valid_attributes
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'DELETE /v1/comments/:id' do
    context 'when the record does not exist' do
      before do
        sign_in user
        delete "/v1/comments/#{comment_id}"
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the record does not exist' do
      before do
        sign_in user
        delete "/v1/comments/#{100}"
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end
