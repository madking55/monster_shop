require 'rails_helper'

 RSpec.describe "Admin Users Index" do
   describe "As an Admin" do
     before :each do
       @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
       @m_user = @merchant_1.users.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
       @d_user = User.create!(name: 'Brian', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'brian@example.com', password: 'securepassword')
       @a_user = User.create!(name: 'Meg', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'meg@example.com', password: 'securepassword', role: 'admin')
       @admin = User.create!(name: 'Sal', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'sal@example.com', password: 'securepassword', role: 'admin')
       allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
     end

     it "I can link to a list of all users" do
       visit '/admin'

       within 'nav' do
         click_link 'Users'
       end

       expect(current_path).to eq('/admin/users')

       expect(page).to have_css("#user-#{@d_user.id}")
       expect(page).to have_css("#user-#{@a_user.id}")

       within "#user-#{@m_user.id}" do
         expect(page).to have_link(@m_user.name)
         expect(page).to have_content("Role: #{@m_user.role}")
         expect(page).to have_content("Registered: #{@m_user.created_at}")
       end
     end
   end
 end