require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should have_db_column(:name).of_type(:string) }
  it { should have_db_column(:url).of_type(:string) }

  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_value("https://exmaple.com/category/page?param1=0&param2=q").for(:url) }
  it { should_not allow_value("not a valid url").for(:url) }

  # based on example from: https://makandracards.com/makandra/38645-testing-activerecord-validations-with-rspec
  describe 'Link' do
    it 'with valid url' do
      link = Link.new(name: 'Test link', url: 'http://example/com/page/1')
      link.valid?
      expect(link.errors[:url]).to_not include "URL is not valid"
    end

    it 'with not valid url' do
      link = Link.new(name: 'Test link', url: 'not a valid url')
      link.valid?
      expect(link.errors[:url]).to include "URL is not valid"
    end
  end

  describe 'Gist link' do
    it 'valid' do
      link = Link.new(name: 'Gist link', url: 'https://gist.github.com/dmikhr/c7d219d8532bb4f55f53c57aefb1200f')
      expect(link).to be_gist_link
    end

    it 'not valid' do
      link = Link.new(name: 'Link', url: 'http://example/com/page/1')
      expect(link).to_not be_gist_link

      link2 = Link.new(name: 'Gist website', url: 'https://gist.github.com')
      expect(link2).to_not be_gist_link
    end

    it 'get its contents' do
      link = Link.new(name: 'Gist link', url: 'https://gist.github.com/dmikhr/c7d219d8532bb4f55f53c57aefb1200f')
      expect(link.gist_contents).to eq 'Test gist qna'
    end
  end
end
