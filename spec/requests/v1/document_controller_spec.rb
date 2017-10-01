require 'rails_helper'

describe V1::DocumentsController do
  # initialize test data
  let(:user) { create(:user) }
  let(:new_user) { create(:user) }
  let(:comment) { create(:comment) }
  let!(:documents) {
    (1..10).map do |el|
      FactoryGirl.create(:document, {
          :comment => comment
      })
    end
  }
  let(:document_id) { documents.first.id }

  describe 'GET /v1/documents' do
    context 'user documents exist' do
      before do
        sign_in user
        get "/v1/documents?comment_id=#{comment.id}"
      end

      it 'returns documents' do
        expect(json).not_to be_empty
        expect(json.size).to eq(10)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'no user documents exist' do
      before do
        sign_in new_user
        get "/v1/documents?user_id=#{new_user.id}"
      end

      it 'returns documents' do
        expect(json).to be_empty
        expect(json.size).to eq(0)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET /v1/documents/:id' do
    before do
      sign_in user
      get "/v1/documents/#{document_id}"
    end

    context 'when the record exists' do
      it 'returns the document' do
        expect(response.body).not_to be_empty
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:document_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to be_empty
      end
    end
  end

  describe 'POST /v1/documents/' do
    # valid payload
    let(:valid_attributes) do
      path = File.join(Rails.root, '/spec/fixtures/images/test.jpg')
      {
          :file => Rack::Test::UploadedFile.new(path, 'application/pdf', true),
          :comment_id => comment.id
      }
    end

    context 'when the request is valid' do
      before do
        sign_in user
        post '/v1/documents/', params: valid_attributes
      end

      it 'creates a task' do
        expect(json['filename']).to eq('test.jpg')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before do
        sign_in user
        post '/v1/documents/', params: {}
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
            .to eq("[\"Comment must exist\",\"File contents can't be blank\",\"Filename can't be blank\"]")
      end
    end
  end

  describe 'DELETE /v1/documents/:id' do
    context 'when the record does not exist' do
      before do
        sign_in user
        delete "/v1/documents/#{document_id}"
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the record does not exist' do
      before do
        sign_in user
        delete "/v1/documents/#{100}"
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end
