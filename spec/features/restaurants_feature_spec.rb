require 'rails_helper'

feature 'restaurants' do
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do

    before { Restaurant.create name: 'KFC', description: 'Deep fried goodness' }

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do
    scenario 'You have to sign in order to create,edit and delete a restaurant' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      signing_up
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end
  end

  context 'viewing restaurants' do

    let!(:kfc){ Restaurant.create(name:'KFC', description: 'Deep fried goodness' ) }

    scenario 'lets a user view a restaurant' do
     visit '/restaurants'
     click_link 'KFC'
     expect(page).to have_content 'KFC'
     expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'editing restaurants' do

    before do
      signing_up(email: 'initialize@signup.com')
      create_restaurant
      click_link "Sign out"
    end

    scenario 'let a user edit a restaurant' do
      signing_up
      create_restaurant(name: 'Bob\'s Burgers')
      visit '/restaurants'
      click_link 'Edit Bob\'s Burgers'
      fill_in 'Name', with:'Kentucky Fried Chicken'
      fill_in 'Description', with:'Deep fried goodness'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(page).to have_content 'Deep fried goodness'
      expect(current_path).to eq '/restaurants'
    end

    scenario 'user cannot edit someone elses restaurant' do
      signing_up
      click_link 'Sign out'
      signing_up(email: 'bob@rob.cob')
      click_link 'Edit KFC'
      expect(current_path).to eq '/restaurants'
      expect(page).to have_content 'Error: Cannot edit someone elses restaurant'
    end
  end

  context 'deleting restaurants' do
    before do
      signing_up
      create_restaurant
    end

    scenario 'removes a restaurant when a user clicks a delete link' do
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    scenario 'removes a restaurant when a user clicks a delete link' do
      click_link 'Sign out'
      signing_up(email: 'grig@grig.grig')
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(current_path).to eq '/restaurants'
      expect(page).to have_content 'Error: Cannot delete someone elses restaurant'
    end
  end

   context 'an invalid restaurant' do
    it 'does not let you submit a name that is too short' do
      signing_up
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'kf'
      click_button 'Create Restaurant'
      expect(page).not_to have_css 'h2', text: 'kf'
      expect(page).to have_content 'error'
    end
  end
end
