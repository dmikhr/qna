require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) {  { "CONTENT_TYPE" => "application/json",
                     "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API response successful'

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

    context 'authorized' do
      let(:users) { create_list(:user, 3) }
      let(:me) { users.first }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API response successful'

      it 'does not return authenticated user' do
        json_user_ids = json.map { |user| user['id'] }
        expect(json_user_ids).to_not include(me.id)
      end

      it_behaves_like 'returns list of items' do
        # list of user profiles except authenticated
        let(:items) { users.drop(1) }
        let(:json_items) { json }
      end

      it_behaves_like 'returns all public fields' do
        let(:items) { users.drop(1) }
        let(:json_items) { json }
        let(:public_fields) { %w[id email admin created_at updated_at] }
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
