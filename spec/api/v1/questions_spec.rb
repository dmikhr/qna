require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) {{"CONTENT_TYPE" => "application/json",
                  "ACCEPT" => 'application/json'}}

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question, user: user) }

      before {get api_path, params: {access_token: access_token.token}, headers: headers}

      it_behaves_like 'API response successful'

      it_behaves_like 'returns list of items' do
        let(:items) { questions }
        let(:json_items) { json['questions'] }
      end

      it_behaves_like 'returns all public fields' do
        let(:items) { questions }
        let(:json_items) { json['questions'] }
        let(:public_fields) { %w[id title body created_at updated_at] }
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it_behaves_like 'returns list of items' do
          let(:items) { answers }
          let(:json_items) { question_response['answers'] }
        end

        it_behaves_like 'returns all public fields' do
          let(:items) { answers }
          let(:json_items) { question_response['answers'] }
          let(:public_fields) { %w[id body created_at updated_at] }
        end
      end
    end
  end
end
