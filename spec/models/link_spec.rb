require 'rails_helper'

RSpec.describe Link, type: :model do
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
end
