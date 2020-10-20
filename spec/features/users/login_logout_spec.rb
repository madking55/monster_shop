require 'rails_helper'

RSpec.describe 'User Login and Logout' do
  describe 'A registered user can log in' do
    describe 'As a default user' do
      before :each do
        @user = User.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      end

      it 'with correct credentials' do
        
        visit login_path
        fill_in 'Email', with: @user.email
        fill_in 'Password', with: @user.password
        click_button 'Log In'
        
        expect(current_path).to eq(profile_path)
        expect(page).to have_content("Logged in as #{@user.name}")
      end
    end

    describe 'As a merchant user' do
      before :each do
        @merchant = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
        @m_user = @merchant.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 'merchant')
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
      end

      it 'with correct credentials' do
        visit login_path

        fill_in 'Email', with: @m_user.email
        fill_in 'Password', with: @m_user.password
        click_button 'Log In'

        expect(current_path).to eq(merchant_dashboard_path)
        expect(page).to have_content("Logged in as #{@m_user.name}")
      end
    end

    describe 'As admin user' do
      before :each do
        @admin = User.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 'admin')
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      end

      it 'with correct credentials' do
        visit login_path

        fill_in 'Email', with: @admin.email
        fill_in 'Password', with: @admin.password
        click_button 'Log In'

        expect(current_path).to eq(admin_dashboard_path)
        expect(page).to have_content("Logged in as #{@admin.name}")
      end
    end
  end
end