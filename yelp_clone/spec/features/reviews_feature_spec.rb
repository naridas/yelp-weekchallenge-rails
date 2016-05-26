require 'rails_helper'

feature 'reviewing' do
  before do
    signing_up(email: 'initialize@signup.com')
    create_restaurant
    click_link "Sign out"
    signing_up
    review_restaurant
  end

  scenario 'allows users to leave a review using a form' do
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('so so')
  end

  scenario 'only allows users to leave one review per restaurant' do
    review_restaurant
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('You have already reviewed this restaurant')
  end

  scenario 'user can delete a review' do
    visit '/restaurants'
    click_link 'Delete Review'
    expect(page).to have_content 'Review deleted successfully'
    expect(page).not_to have_content 'so so'
  end

  scenario 'users cannot delete someone elses review' do
    click_link 'Sign out'
    signing_up(email: 'poopy@mcpoop.face')
    click_link 'Delete Review'
    expect(page).to have_content 'Error: Cannot delete someone elses review'
  end

end
