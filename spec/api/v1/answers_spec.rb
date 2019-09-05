require 'rails_helper'

describe 'Questions API', type: :request do
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
        let(:json_items) { json }
      end

      it_behaves_like 'returns all public fields' do
        let(:items) { answers }
        let(:json_items) { json }
        let(:public_fields) { %w[id body created_at updated_at] }
      end
    end
  end
end
