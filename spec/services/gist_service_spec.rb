require 'rails_helper'

RSpec.describe GistService, type: :service do
  let(:gist_id) { 'c7d219d8532bb4f55f53c57aefb1200f' }
  let(:gist_id_not_exist) { '111111111111111111111111112222222' }
  let(:gist_service) { GistService.new.call(gist_id) }
  let(:gist_service_with_error) { GistService.new.call(gist_id_not_exist) }

  describe 'GistService fetches text of a gist' do
    it 'with correct gist_id' do
      expect(gist_service).to eq 'Test gist qna'
    end

    it 'with nonexistent gist_id' do
      expect(gist_service_with_error).to be_falsey
    end
  end
end
