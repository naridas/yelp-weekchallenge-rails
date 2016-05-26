require 'rails_helper'

feature 'reviewing' do
  before { Restaurant.create name: 'KFC', description: 'Deep fried goodness' }

  scenario 'allows users to leave a review using a form' do
    signing_up
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'

    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('so so')
  end

end
