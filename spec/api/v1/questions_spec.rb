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

      before {get api_path, params: { access_token: access_token.token }, headers: headers}

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

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

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
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }

      context 'with valid attributes' do
        it 'saves a new question in the database' do
          expect { post api_path, params: { question: attributes_for(:question),
                    access_token: access_token.token } }.to change(Question, :count).by(1)
        end

        it 'API response successful' do
          post api_path, params: { question: attributes_for(:question), access_token: access_token.token }
          expect(response).to be_successful
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post api_path, params: { question: attributes_for(:question, :invalid),
                  access_token: access_token.token } }.to_not change(Question, :count)
        end

        it 'returns error' do
          post api_path, params: { question: attributes_for(:question, :invalid), access_token: access_token.token }
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:access_token) { create(:access_token) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        patch api_path, params: { id: question,
                                  question: { title: 'new title for question', body: 'new body for question' } }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        patch api_path, params: { id: question,
                                  question: { title: 'new title for question',
                                  body: 'new body for question' }, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user_other) { create(:user) }
      let(:access_token) { create(:access_token) }
      # автор вопроса и владелец токена должен быть одним пользователем, чтобы редактировать вопрос
      let!(:question) { create(:question, user_id: access_token.resource_owner_id) }
      let!(:question_other) { create(:question, user: user) }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:api_path_other) { "/api/v1/questions/#{question_other.id}" }

      context 'with valid attributes' do
        it 'changes question attributes' do
          patch api_path, params: { id: question,
                                    question: { title: 'new title for question', body: 'new body for question' },
                                    access_token: access_token.token }
          question.reload

          expect(question.title).to eq 'new title for question'
          expect(question.body).to eq 'new body for question'
        end

        it 'API response successful' do
          patch api_path, params: { id: question,
                                    question: { title: 'new title for question', body: 'new body for question' },
                                    access_token: access_token.token }
          expect(response).to be_successful
        end
      end

      context 'with invalid attributes' do
        it 'changes question attributes' do
          patch api_path, params: { id: question, question: { title: '' }, access_token: access_token.token }
          question.reload
          expect(question.title).to_not eq 'new title for question'
          expect(question.body).to_not eq 'new body for question'
        end
      end

      context 'not an author' do
        it 'cannot change question attributes' do
          patch api_path_other, params: { id: question_other,
                                    question: { title: 'new title for question', body: 'new body for question' },
                                    access_token: access_token.token }
          question_other.reload

          expect(question_other.title).to_not eq 'new title for question'
          expect(question_other.body).to_not eq 'new body for question'
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:access_token) { create(:access_token) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        delete api_path, params: { id: question }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        delete api_path, params: { id: question, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user_other) { create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question, user_id: access_token.resource_owner_id) }
      let!(:question_other) { create(:question, user: user) }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:api_path_other) { "/api/v1/questions/#{question_other.id}" }

      context 'with valid attributes' do
        it 'deletes question from the database' do
          expect { delete api_path, params: { question: question,
                    access_token: access_token.token } }.to change(Question, :count).by(-1)
        end

        it 'API response successful' do
          delete api_path, params: { question: question, access_token: access_token.token }
          expect(response.status).to eq 204
        end
      end

      context 'not an author' do
        it 'cannot delete question from the database' do
          expect { delete api_path_other, params: { question: question_other,
                    access_token: access_token.token } }.to_not change(Question, :count)
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, :with_files, user: user) }
    let(:question_response) { json['question'] }
    let!(:comments) { create_list(:comment, 3, commentable: question, user: user) }
    let!(:links) { create_list(:link, 3, linkable: question) }
    let(:access_token) { create(:access_token) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    it_behaves_like 'API response successful'

    it_behaves_like 'returns all public fields' do
      let(:items) { [question] }
      let(:json_items) { [json['question']] }
      let(:public_fields) { %w[id title body created_at updated_at] }
    end

    describe 'comments' do
      it_behaves_like 'number of items match' do
        let(:items) { comments }
        let(:json_items) { question_response['comments'] }
      end
    end

    describe 'links' do
      it_behaves_like 'number of items match' do
        let(:items) { links }
        let(:json_items) { question_response['links'] }
      end
    end

    describe 'files' do
      it_behaves_like 'number of items match' do
        let(:items) { question.files }
        let(:json_items) { question_response['files'] }
      end
    end
  end
end
