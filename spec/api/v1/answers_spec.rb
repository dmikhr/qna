require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) {{"CONTENT_TYPE" => "application/json",
                  "ACCEPT" => 'application/json'}}

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:access_token) { create(:access_token) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    end

    context 'authorized' do
      let!(:answers) { create_list(:answer, 3, question: question, user: user) }

      before { get "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API response successful'

      it_behaves_like 'returns list of items' do
        let(:items) { answers }
        let(:json_items) { json['answers'] }
      end

      it_behaves_like 'returns all public fields' do
        let(:items) { answers }
        let(:json_items) { json['answers'] }
        let(:public_fields) { %w[id body created_at updated_at] }
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:access_token) { create(:access_token) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post api_path, params: { question: attributes_for(:question) }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post api_path, params: { question: attributes_for(:question), access_token: '1234' }
        expect(response.status).to eq 401
      end
    end
    context 'authorized' do
      it 'saves a new answer in the database' do
        expect { post api_path, params: { question: question, answer: attributes_for(:answer),
                  access_token: access_token.token } }.to change(Answer, :count).by(1)
      end

      it 'API response successful' do
        post api_path, params: { question: question, answer: attributes_for(:answer), access_token: access_token.token }
        expect(response).to be_successful
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post api_path, params: { question: question, answer: attributes_for(:answer, :invalid),
                  access_token: access_token.token } }.to_not change(Answer, :count)
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, :with_files, user: user) }
    let(:answer) { create(:answer, :with_files, question: question, user: user) }
    let(:answer_response) { json['answer'] }
    let!(:comments) { create_list(:comment, 3, commentable: answer, user: user) }
    let!(:links) { create_list(:link, 3, linkable: answer) }
    let(:access_token) { create(:access_token) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    it_behaves_like 'API response successful'

    it_behaves_like 'returns all public fields' do
      let(:items) { [answer] }
      let(:json_items) { [json['answer']] }
      let(:public_fields) { %w[id body created_at updated_at] }
    end

    describe 'comments' do
      it_behaves_like 'number of items match' do
        let(:items) { comments }
        let(:json_items) { answer_response['comments'] }
      end
    end

    describe 'links' do
      it_behaves_like 'number of items match' do
        let(:items) { links }
        let(:json_items) { answer_response['links'] }
      end
    end

    describe 'files' do
      it_behaves_like 'number of items match' do
        let(:items) { answer.files }
        let(:json_items) { answer_response['files'] }
      end
    end
  end
end
