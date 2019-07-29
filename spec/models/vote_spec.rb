require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should have_db_column(:value).of_type(:integer) }

  it { should belong_to :user }

  it { should validate_numericality_of(:value).only_integer }
end
