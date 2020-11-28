require 'rails_helper'

 RSpec.describe 'Admin Dashboard' do
   describe 'As an Admin' do
     before :each do
       @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
       @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
       @user = User.create!(name: "Megan", address: "123 North st", city: "Denver", state: "Colorado", zip: "80401", email: "12345@gmail.com", password: "password")
       @tire = @merchant_1.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
       @wheel = @merchant_1.items.create!(name: "A bike wheel", description: "A super awesome wheel", price: 150, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 25)
       @helmet = @merchant_2.items.create!(name: "Brain Cage", description: "A cage to protect your head", price: 150, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 70)
       @order_1 = @user.orders.create!(name: "Megan", address: "123 North st", city: "Denver", state: "Colorado", zip: "80401", status: "packaged")
       @order_2 = @user.orders.create!(name: "Megan", address: "123 North st", city: "Denver", state: "Colorado", zip: "80401", status: "pending")
       @order_3 = @user.orders.create!(name: "Megan", address: "123 North st", city: "Denver", state: "Colorado", zip: "80401", status: "cancelled")
       @admin = User.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'admin@example.com', password: 'securepassword', role: :admin)
       allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
     end

     it 'I can see all orders' do

       visit '/admin'

       expect(page.all('.order')[0]).to have_content(@order_1.id)
       expect(page.all('.order')[1]).to have_content(@order_2.id)
       expect(page.all('.order')[2]).to have_content(@order_3.id)

       within "#order-#{@order_1.id}" do
         expect(page).to have_content(@user.name)
         expect(page).to have_content("#{@order_1.id}: #{@order_1.status}")
         expect(page).to have_content("Created: #{@order_1.created_at}")
         expect(page).to have_link('Ship')
       end

       within "#order-#{@order_2.id}" do
         expect(page).to have_content(@user.name)
         expect(page).to have_content("#{@order_2.id}: #{@order_2.status}")
         expect(page).to have_content("Created: #{@order_2.created_at}")
         expect(page).to_not have_link('Ship')
       end

       within "#order-#{@order_3.id}" do
         expect(page).to have_content(@user.name)
         expect(page).to have_content("#{@order_3.id}: #{@order_3.status}")
         expect(page).to have_content("Created: #{@order_3.created_at}")
         expect(page).to_not have_link('Ship')
       end
     end

     it 'I can ship an order' do

      visit '/admin'

      within "#order-#{@order_1.id}" do
        click_link('Ship')
      end

      @order_1.reload

      expect(@order_1.status).to eq('shipped')

      within "#order-#{@order_1.id}" do
        expect(page).to_not have_link('Ship')
      end

      visit "/orders/#{@order_1.id}"

      expect(page).to_not have_link("Cancel Order")
    end
   end
 end