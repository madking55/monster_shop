require 'rails_helper'

RSpec.describe "Create Merchant Items" do
  describe 'As a merchant employee' do 
    describe "When I visit my items index page" do
      before(:each) do
        @brian = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
        @m_user = @brian.users.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
      end

      it 'I see a link to add a new item for that merchant' do
        visit "/merchant/items"

        expect(page).to have_link "Add New Item"
      end

      it 'I can add a new item by filling out a form' do
        visit "/merchant/items"

        name = "Chamois Buttr"
        price = 18
        description = "No more chaffin'!"
        image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
        inventory = 25

        click_on "Add New Item"

        expect(current_path).to eq("/merchant/items/new")

        fill_in :name, with: name
        fill_in :price, with: price
        fill_in :description, with: description
        fill_in :image, with: image_url
        fill_in :inventory, with: inventory

        click_button "Create Item"

        new_item = Item.last

        expect(current_path).to eq("/merchant/items")
        expect(new_item.name).to eq(name)
        expect(new_item.price).to eq(price)
        expect(new_item.description).to eq(description)
        expect(new_item.image).to eq(image_url)
        expect(new_item.inventory).to eq(inventory)
        expect(Item.last.active?).to be(true)
        expect("#item-#{Item.last.id}").to be_present
        expect(page).to have_content(name)
        expect(page).to have_content("Price: $#{new_item.price}")
        expect(page).to have_css("img[src*='#{new_item.image}']")
        expect(page).to have_content("Active")
        expect(page).to have_content(new_item.description)
        expect(page).to have_content("Inventory: #{new_item.inventory}")
      end

      it 'I get an alert if I dont fully fill out the form' do
        visit "/merchant/items"

        name = ""
        price = 18
        description = "No more chaffin'!"
        image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
        inventory = ""

        click_on "Add New Item"

        fill_in :name, with: name
        fill_in :price, with: price
        fill_in :description, with: description
        fill_in :image, with: image_url
        fill_in :inventory, with: inventory

        click_button "Create Item"

        expect(page).to have_content("Name can't be blank and Inventory can't be blank")
        expect(page).to have_button("Create Item")
      end
    end
  end
end
