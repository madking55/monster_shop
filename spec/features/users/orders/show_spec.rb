require 'rails_helper'

RSpec.describe 'Order Show Page' do
  describe 'As a registered user' do
    before(:each) do
      @mike = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create!(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create!(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      @user = User.create!(name: "Bert", address: "123 Sesame St.", city: "NYC", state: "New York", zip: "10001", email: "12345@gmail.com", password: "password")
      @order_1 = @user.orders.create!(name: "Bert", address: "123 Sesame St.", city: "NYC", state: "New York", zip: "10001")
      @order_2 = @user.orders.create!(name: "Bert", address: "123 Sesame St.", city: "NYC", state: "New York", zip: "10001")
      @order_item_1 = @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_item_2 = @order_2.item_orders.create!(item: @paper, price: @paper.price, quantity: 3)
      @order_item_3 = @order_2.item_orders.create!(item: @pencil, price: @pencil.price, quantity: 1)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'I can link from my orders to order show page' do
      visit profile_orders_path

      click_link("Order No:#{@order_1.id}")
      expect(current_path).to eq("/profile/orders/#{@order_1.id}")
    end

    it 'I see an order information on the show page' do
      visit "/profile/orders/#{@order_2.id}"

      expect(page).to have_content(@order_2.id)
      expect(page).to have_content("Created On: #{@order_2.created_at}")
      expect(page).to have_content("Updated On: #{@order_2.updated_at}")
      expect(page).to have_content("Status: #{@order_2.status}")
      expect(page).to have_content("#{@order_2.total_items_quantity} items")
      expect(page).to have_content("Total: $#{(@order_2.grandtotal)}")

      within("#item-order-#{@order_item_2.id}") do
        expect(page).to have_content(@order_item_2.item.name)
        expect(page).to have_content(@order_item_2.item.description)
        expect(page).to have_css("img[src*='#{@order_item_2.item.image}']")
        expect(page).to have_content("Price: $#{@order_item_2.price}")
        expect(page).to have_content('Quantity: 3')
        expect(page).to have_content('Subtotal: $60')
      end


      within("#item-order-#{@order_item_3.id}") do
        expect(page).to have_content(@order_item_3.item.name)
        expect(page).to have_content(@order_item_3.item.description)
        expect(page).to have_css("img[src*='#{@order_item_3.item.image}']")
        expect(page).to have_content("Price: $#{@order_item_3.price}")
        expect(page).to have_content('Quantity: 1')
        expect(page).to have_content('Subtotal: $2')
      end
    end
  end
end
