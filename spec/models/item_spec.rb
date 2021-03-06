require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @user = User.create!(name: "Nick", address: "123 Main St", city: "Denver", state: "CO", zip: "80439", email: "myemail@email.com", password: "password")

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end


    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      order = Order.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: @user.id)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end
  end

  describe 'class methods' do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @user = User.create!(name: "Nick", address: "123 Main St", city: "Denver", state: "CO", zip: "80439", email: "myemail@email.com", password: "password")

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @wheel = @meg.items.create(name: "A bike wheel", description: "A super awesome wheel", price: 150, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 25)
      @helmet = @meg.items.create(name: "Brain Cage", description: "A cage to protect your head", price: 150, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 70)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @catnip = @brian.items.create(name: "Catnip", description: "It'll get your cat super high", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 50)
      @scratch_pad = @brian.items.create(name: "Scratch Pad", description: "Pretty scratchy", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 5)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    it '.active_items' do
      expect(Item.active_items).to eq([@tire, @wheel, @helmet, @pull_toy, @catnip, @scratch_pad])
    end

    it '.by_popularity()' do
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

      expect(Item.by_popularity).to eq([@helmet, @catnip, @wheel, @tire, @scratch_pad])
      expect(Item.by_popularity(3, "DESC")).to eq([@helmet, @catnip, @wheel])
      expect(Item.by_popularity(3, "ASC")).to eq([@dog_bone, @pull_toy, @scratch_pad])
    end
  end
end
