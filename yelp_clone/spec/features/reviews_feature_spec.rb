require 'rails_helper'

feature 'reviewing' do
  before { Restaurant.create name: 'KFC', description: 'Deep fried goodness' }

  scenario 'allows users to leave a review using a form' do
    signing_up
    review_restaurant

    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('so so')
  end

  scenario 'allows users to leave a review using a form' do
    signing_up
    review_restaurant
    review_restaurant

    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('You have already reviewed this restaurant')
  end

end
