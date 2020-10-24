require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    describe 'and visit my cart path' do
      before(:each) do
        @mike = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

        @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        @paper = @mike.items.create!(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
        @pencil = @mike.items.create!(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
        @mug = @mike.items.create!(name: "Mug", description: "This mug is ugly and chipped", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 3)
      end

      it 'I can empty my cart by clicking a link' do
        visit "/items/#{@paper.id}"
        click_on "Add To Cart"
        visit "/items/#{@tire.id}"
        click_on "Add To Cart"
        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"
        @items_in_cart = [@paper, @tire, @pencil]

        visit '/cart'
        expect(page).to have_link("Empty Cart")
        click_on "Empty Cart"
        expect(current_path).to eq("/cart")
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it 'I see all items Ive added to my cart' do
        visit "/items/#{@paper.id}"
        click_on "Add To Cart"
        visit "/items/#{@tire.id}"
        click_on "Add To Cart"
        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"
        @items_in_cart = [@paper, @tire, @pencil]

        visit '/cart'

        @items_in_cart.each do |item|
          within "#cart-item-#{item.id}" do
            expect(page).to have_link(item.name)
            expect(page).to have_css("img[src*='#{item.image}']")
            expect(page).to have_link("#{item.merchant.name}")
            expect(page).to have_content("$#{item.price}")
            expect(page).to have_content("1")
            expect(page).to have_content("$#{item.price}")
          end
        end
        expect(page).to have_content("Total: $122")

        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"
        visit '/cart'

        within "#cart-item-#{@pencil.id}" do
          expect(page).to have_content("2")
          expect(page).to have_content("$4")
        end

        expect(page).to have_content("Total: $124")
      end

      it "I can increment the count of items I want to purchase" do
        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"
 
        expect(page).to have_content("Cart: 1")
 
        visit '/cart'
        
        within "#cart-item-#{@pencil.id}" do
          4.times { click_link '+' }
          expect(page).to have_content("5")
        end
      end
  
      it "I can not increment the count of item beyond its inventory size" do
        visit "/items/#{@mug.id}"
        click_on "Add To Cart"
        visit "/items/#{@mug.id}"
        click_on "Add To Cart"
        visit "/items/#{@mug.id}"
        click_on "Add To Cart"

        visit '/cart'
  
        within "#cart-item-#{@mug.id}" do
          expect(page).to have_content("3")
          expect(page).to_not have_button('+')
        end

        visit "/items/#{@mug.id}"

        click_on 'Add To Cart'

        expect(page).to have_content("You have all the item's inventory in your cart already!")
      end

      it 'I can reduce the quantity of an item in my cart' do
        visit item_path(@pencil)
        click_on 'Add To Cart'
        visit item_path(@mug)
        click_on 'Add To Cart'
        visit item_path(@mug)
        click_on 'Add To Cart'
        visit '/cart'

        within "#cart-item-#{@mug.id}" do
          expect(page).to have_content('2')
          click_link('-')
        end

        expect(current_path).to eq('/cart')

        within "#cart-item-#{@mug.id}" do
          expect(page).to have_content('1')
        end
      end

      it 'if I reduce the quantity to zero, the item is removed from my cart' do
        visit item_path(@mug)
        click_on 'Add To Cart'
        visit '/cart'

        within "#cart-item-#{@mug.id}" do
          click_link('-')
        end

        expect(current_path).to eq('/cart')
        expect(page).to_not have_content("#{@mug.name}")
        expect(page).to have_content("Cart: 0")
      end

      it 'I must register or log in to finish the checkout process' do
        
        visit item_path(@pencil)
        click_on 'Add To Cart'
        visit item_path(@mug)
        click_on 'Add To Cart'

        visit '/cart'

        expect(page).to have_content("You must register or login to complete the checkout process")

        within('#checkout') do
          expect(page).to have_link('register')
          expect(page).to have_link('login')
        end

        click_link "register"
        expect(current_path).to eq(registration_path)

        visit '/cart'
        click_link "login"
        expect(current_path).to eq(login_path)
      end
    end
  end

  describe "When I haven't added anything to my cart" do
    describe "and visit my cart show page" do
      it "I see a message saying my cart is empty" do
        visit '/cart'
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it "I do NOT see the link to empty my cart" do
        visit '/cart'
        expect(page).to_not have_link("Empty Cart")
      end
    end
  end
end
