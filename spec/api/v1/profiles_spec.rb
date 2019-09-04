require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) {  { "CONTENT_TYPE" => "application/json",
                     "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/me', params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles' }
    end

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles', headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles', params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:users) { create_list(:user, 3) }
      let(:me) { users.first }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'does not return authenticated user' do
        json_user_ids = json.map { |user| user['id'] }
        expect(json_user_ids.exclude?(me.id)).to be true
      end

      it 'returns list of user profiles except authenticated' do
        user_ids = users.drop(1).map { |user| user.id }
        all_users_except_auth = json.map { |user| user_ids.include?(user['id']) }
        # если все пользователи в списке, map вернет массив только из true [true true true ...]
        expect(all_users_except_auth.any?(false)).to be false
      end

      it 'returns all public fields' do
        json.zip(users.drop(1)).each do |user_json, user|
          %w[id email admin created_at updated_at].each do |attr|
            expect(user_json[attr]).to eq user.send(attr).as_json
          end
        end
      end

      it 'does not return private fields' do
        json.each do |user_json|
          %w[password encrypted_password].each do |attr|
            expect(user_json).to_not have_key(attr)
          end
        end
      end

    end
  end
end
