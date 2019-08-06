require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should have_db_column(:body).of_type(:string) }

  it { should belong_to :user }
  it { should belong_to :commentable }

  it { should validate_presence_of :body }
end
