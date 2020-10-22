require 'rails_helper'

 RSpec.describe 'User Profile Show Page' do
   describe "As a registered user" do
     before :each do
       @user = User.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
       allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
     end

     it "I can view my profile page" do
       visit profile_path

       expect(page).to have_content(@user.name)
       expect(page).to have_content(@user.address)
       expect(page).to have_content(@user.email)
       expect(page).to have_content("#{@user.city} #{@user.state} #{@user.zip}")
       expect(page).to_not have_content(@user.password)
       expect(page).to have_link('Edit')
     end

     it "I can update my profile data" do
      visit profile_path
      click_link 'Edit'

      expect(current_path).to eq('/profile/edit')

      name = 'New Name'
      email = 'new@example.com'
      address = '124 new str'
      city = 'new town'
      state = 'NY'
      zip = '12034'

      fill_in "Name", with: name
      fill_in "Email", with: email
      fill_in "Address", with: address
      fill_in "City", with: city
      fill_in "State", with: state
      fill_in "Zip", with: zip
      click_button 'Update Profile'

      expect(current_path).to eq(profile_path)

      expect(page).to have_content('Profile has been updated!')
      expect(page).to have_content(name)
      expect(page).to have_content(email)
      expect(page).to have_content(address)
      expect(page).to have_content("#{city} #{state} #{zip}")
    end
   end
 end