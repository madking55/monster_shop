require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @user = User.create!(name: "Megan", address: "123 North st", city: "Denver", state: "Colorado", zip: "80401", email: "12345@gmail.com", password: "password")
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @wheel = @meg.items.create(name: "A bike wheel", description: "A super awesome wheel", price: 150, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 25)
      @helmet = @meg.items.create(name: "Brain Cage", description: "A cage to protect your head", price: 150, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 70)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @catnip = @brian.items.create(name: "Catnip", description: "It'll get your cat super high", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 50)
      @scratch_pad = @brian.items.create(name: "Scratch Pad", description: "Pretty scratchy", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 5)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    it "I can see a list of all active items" do
      visit items_path

      expect(page).not_to have_css("#item-#{@dog_bone.id}")

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
        expect(page).to have_link('image')
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
        expect(page).to have_link('image')
      end
    end

    it "item image is a link to that item's show page" do
      visit items_path
      within "#item-#{@tire.id}" do
        click_link('image')
        expect(current_path).to eq(item_path(@tire.id))
      end

      visit items_path
      within "#item-#{@pull_toy.id}" do
        click_link('image')
        expect(current_path).to eq(item_path(@pull_toy.id))
      end
    end

    it "all active items or merchant names are links" do
      visit items_path

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
      expect(page).not_to have_link(@dog_bone.name)
    end

    it 'I can see the top most and least popular items' do
      @order_1 = Order.create!(name: 'Megan M', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, user_id: @user.id)
      @order_2 = Order.create!(name: 'Megan M', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, user_id: @user.id)
      @order_3 = Order.create!(name: 'Megan M', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, user_id: @user.id)

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 6)
      @order_2.item_orders.create!(item: @wheel, price: @wheel.price, quantity: 20)
      @order_3.item_orders.create!(item: @helmet, price: @helmet.price, quantity: 50)
      @order_1.item_orders.create!(item: @helmet, price: @tire.price, quantity: 10)
      @order_2.item_orders.create!(item: @catnip, price: @catnip.price, quantity: 30)
      @order_3.item_orders.create!(item: @catnip, price: @catnip.price, quantity: 10)
      @order_1.item_orders.create!(item: @catnip, price: @catnip.price, quantity: 10)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 1)
      @order_1.item_orders.create!(item: @scratch_pad, price: @scratch_pad.price, quantity: 2)

      visit items_path

      within '.statistics' do
        expect(page).to have_content("Most Popular Items")
        expect(page).to have_content("Least Popular Items")
      end

      within '#most-popular-items' do
        expect(page.all('li')[0]).to have_content("#{@helmet.name}: 60 sold")
        expect(page.all('li')[1]).to have_content("#{@catnip.name}: 50 sold")
        expect(page.all('li')[2]).to have_content("#{@wheel.name}: 20 sold")
        expect(page.all('li')[3]).to have_content("#{@tire.name}: 6 sold")
        expect(page.all('li')[4]).to have_content("#{@scratch_pad.name}: 2 sold")
      end

      within '#least-popular-items' do
        expect(page.all('li')[0]).to have_content("#{@pull_toy.name}: 1 sold")
        expect(page.all('li')[1]).to have_content("#{@scratch_pad.name}: 2 sold")
        expect(page.all('li')[2]).to have_content("#{@tire.name}: 6 sold")
        expect(page.all('li')[3]).to have_content("#{@wheel.name}: 20 sold")
        expect(page.all('li')[4]).to have_content("#{@catnip.name}: 50 sold")
      end
    end
  end
end
