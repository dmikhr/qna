require 'rails_helper'

feature 'User can sign out', %q{
  In order to end session
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user can sign out' do
    sign_in(user)
    click_on 'Log Out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
