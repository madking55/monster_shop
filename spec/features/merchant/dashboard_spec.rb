require 'rails_helper'

RSpec.describe 'Merchant Dashboard' do
  describe 'As a merchant employee' do
    before :each do
      @merchant = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end


    it 'I can see the name and full address of the merchant I work for' do

      visit merchant_dashboard_path
      
      expect(page).to have_content("Merchant: #{@merchant.name}")
      expect(page).to have_content(@merchant.address)
      expect(page).to have_content("#{@merchant.city} #{@merchant.state} #{@merchant.zip}")

    end
  end
end
