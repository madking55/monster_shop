require 'rails_helper'

RSpec.describe 'Orders Index Page' do
  describe 'As a registered user' do
    before(:each) do
      @user = User.create!(name: "Megan", address: "123 North st", city: "Denver", state: "Colorado", zip: "80401", email: "12345@gmail.com", password: "password")
      @mike = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create!(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create!(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
    end

    describe 'check out and fill out order info' do
      it 'creates a new order with the "pending" status and it is associated with me as a user' do
        visit '/cart'
        click_on 'Checkout'

        name = "Bert"
        address = "123 Sesame St."
        city = "NYC"
        state = "New York"
        zip = 10001

        fill_in :name, with: name
        fill_in :address, with: address
        fill_in :city, with: city
        fill_in :state, with: state
        fill_in :zip, with: zip
        click_button 'Create Order'

        new_order = Order.last
        expect(new_order.status).to eq("pending")
        expect(new_order.user_id).to eq(@user.id)
      end

      it 'I am redirected to my orders page with my new order listed and my cart empty' do
        visit '/cart'
        click_on 'Checkout'

        name = "Bert"
        address = "123 Sesame St."
        city = "NYC"
        state = "New York"
        zip = 10001

        fill_in :name, with: name
        fill_in :address, with: address
        fill_in :city, with: city
        fill_in :state, with: state
        fill_in :zip, with: zip

        click_button 'Create Order'

        new_order = Order.last

        expect(current_path).to eq('/profile/orders')
        expect(page).to have_content("Your order was created!")

        within 'nav' do
          expect(page).to have_content("Cart: 0")
        end
      end
    end
  end
end