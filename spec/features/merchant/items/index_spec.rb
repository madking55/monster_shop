require 'rails_helper'

RSpec.describe 'Merchant Item Index Page' do
  describe 'As a merchant employee' do
    before(:each) do
      @mike = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @m_user = @mike.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create!(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create!(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      @user = User.create!(name: "Bert", address: "123 Sesame St.", city: "NYC", state: "New York", zip: "10001", email: "12345@gmail.com", password: "password")
      @order_1 = @user.orders.create!(name: "Bert", address: "123 Sesame St.", city: "NYC", state: "New York", zip: "10001", status: 'packaged')
      @order_2 = @user.orders.create!(name: "Bert", address: "123 Sesame St.", city: "NYC", state: "New York", zip: "10001", status: 'pending')
      @order_item_1 = @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, fulfilled: true)
      @order_item_2 = @order_2.item_orders.create!(item: @paper, price: @paper.price, quantity: 3, fulfilled: true)
      @order_item_3 = @order_2.item_orders.create!(item: @pencil, price: @pencil.price, quantity: 1, fulfilled: false)
      @order_item_4 = @order_2.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, fulfilled: true)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

      it 'I can link to my merchant items from the merchant dashboard' do
        visit merchant_dashboard_path

        expect(page).to have_link('My Items')
        click_link 'My Items'
        expect(current_path).to eq('/merchant/items')
      end
  end
end