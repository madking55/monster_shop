require 'rails_helper'

RSpec.describe 'User Registration' do
  describe 'As a Visitor' do
    it 'I see a link to register as a user' do
      visit root_path
      click_link 'Register'
  
      expect(current_path).to eq(registration_path)
    end

  describe 'I can register as a user if' do
    it 'I fill in the registration form' do
      visit registration_path

      fill_in 'Name', with: 'Megan'
      fill_in 'Address', with: '123 Main St'
      fill_in 'City', with: 'Denver'
      fill_in 'State', with: 'CO'
      fill_in 'Zip', with: '80218'
      fill_in 'Email', with: 'megan@example.com'
      fill_in 'Password', with: 'securepassword'
      fill_in 'Password confirmation', with: 'securepassword'
      click_button 'Register User'

      expect(current_path).to eq(profile_path)
      expect(page).to have_content('Welcome, Megan!')
    end
  end

    describe 'I can not register as a user if' do
      it 'I do not complete the registration form' do
        visit registration_path

        fill_in 'Name', with: 'Megan'
        click_button 'Register User'

        expect(page).to have_content("Address can't be blank")
        expect(page).to have_content("City can't be blank")
        expect(page).to have_content("State can't be blank")
        expect(page).to have_content("Zip can't be blank")
        expect(page).to have_content("Email can't be blank")
        expect(page).to have_content("Password can't be blank")
      end
    end
  end
end
