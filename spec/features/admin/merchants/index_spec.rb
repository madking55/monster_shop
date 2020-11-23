require 'rails_helper'

RSpec.describe 'Admin Merchant Index Page' do
  describe 'As an Admin' do 
    before :each do
      @meg = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, status: 'disabled')
      @mike = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203, status: 'enabled')
      @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create!(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create!(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      @admin = User.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: :admin)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    end

    it 'I can disable a merchant account' do
      visit admin_merchants_path

      within("#merchant-#{@meg.id}") do
        expect(page).to_not have_button('Disable')
      end
      
      expect(@mike.status).to eq('enabled')

      within("#merchant-#{@mike.id}") do
        click_button 'Disable'
      end

      expect(current_path).to eq(admin_merchants_path)

      @mike.reload

      expect(@mike.status).to eq('disabled')

      within("#merchant-#{@mike.id}") do
        expect(page).to_not have_button('Disable')
      end
      expect(page).to have_content("#{@mike.name} has been disabled")
    end

    it 'when disabling a merchant all their items are deactivated' do
      visit admin_merchants_path

      within("#merchant-#{@mike.id}") do
        click_button 'Disable'
      end

      visit items_path

      @paper.reload
      expect(@paper.active?).to be false
      expect(page).to_not have_css("#item-#{@paper.id}")

      @pencil.reload
      expect(@pencil.active?).to be false
      expect(page).to_not have_css("#item-#{@pencil.id}")
    end
  end
end