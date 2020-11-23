require 'rails_helper'

RSpec.describe 'Admin Merchant Index Page' do
  describe 'As an Admin' do 
    before :each do
      @meg = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, status: 'disabled')
      @mike = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203, status: 'enabled')
      @admin = User.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: :admin)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    end

    it 'I can disable a merchant account' do
      visit admin_merchants_path

      within("#merchant-#{@meg.id}") do
        expect(page).to_not have_button('Disable')
      end
      
      within("#merchant-#{@mike.id}") do
        click_button 'Disable'
      end

      expect(current_path).to eq(admin_merchants_path)

      within("#merchant-#{@mike.id}") do
        expect(page).to_not have_button('Disable')
      end
      expect(page).to have_content("#{@mike.name} has been disabled")
    end
  end
end