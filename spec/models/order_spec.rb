require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should have_many :item_orders}
    it {should have_many(:items).through(:item_orders)}
    it {should belong_to :user}
  end

  describe 'instance methods' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')

      @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: @user.id, status: 'pending')

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, fulfilled: true)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3, fulfilled: false)
    end

    it '#grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end

    it '#total_items_quantity' do
      expect(@order_1.total_items_quantity).to eq(5)
    end

    it '#cancel' do
      @order_1.cancel
      @order_1.reload

      expect(@order_1.status).to eq('cancelled')
      @order_1.item_orders.each { |item_order| expect(item_order.fulfilled).to be false }
      expect(@tire.inventory).to eq(14)
      expect(@pull_toy.inventory).to eq(35)
    end

    it '#merchant_quantity(merchant_id)' do
      expect(@order_1.merchant_quantity(@meg.id)).to eq(2)
      expect(@order_1.merchant_quantity(@brian.id)).to eq(3)
    end

    it '#merchant_subtotal(merchant_id)' do
      expect(@order_1.merchant_subtotal(@meg.id)).to eq(200)
      expect(@order_1.merchant_subtotal(@brian.id)).to eq(30)
    end
  end
end
