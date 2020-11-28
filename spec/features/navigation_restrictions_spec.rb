require 'rails_helper'

RSpec.describe 'Navigation Restrictions' do
  describe 'As a Visitor' do
    it 'I can not visit the user profile' do
      visit '/profile'
    end

    it 'I cannot visit the merchant dashboard' do
      visit '/merchant'
    end

    it 'I cannot visit the merchant order show' do
      visit '/merchant/orders/3'
    end

    it 'I cannot visit the merchant items index' do
      visit '/merchant/items'
    end

    it 'I can not visit the admin dashboard' do
      visit '/admin'
    end

    it 'I can not visit the admin merchant show page' do
      visit '/admin/merchants/3'
    end

    it 'I can not visit the admin users page' do
      visit '/admin/users'
    end

    after :each do
      expect(page.status_code).to eq(404)
    end
  end

  describe 'As a default User' do
    before :each do
      @user = User.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end
    
    it 'I can not visit the merchant dashboard' do
      visit '/merchant'
    end

    it 'I cannot visit the merchant order show' do
      visit '/merchant/orders/3'
    end

    it 'I cannot visit the merchant items index' do
      visit '/merchant/items'
    end

    it 'I can not visit admin dashboard' do
      visit '/admin'
    end

    it 'I can not visit the admin merchant show page' do
      visit '/admin/merchants/3'
    end

    it 'I can not visit the admin users page' do
      visit '/admin/users'
    end

    after :each do 
      expect(page.status_code).to eq(404)
    end
  end

  describe 'As a merchant user (employee)' do
    before :each do
      @merchant = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 'merchant')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'I can not visit admin dashboard' do
      visit '/admin'
      expect(page.status_code).to eq(404)
    end

    it 'I can not visit the admin merchant show page' do
      visit '/admin/merchants/3'
    end

    it 'I can not visit the admin users page' do
      visit '/admin/users'
    end
  end

  describe 'As an Admin' do
    before :each do
      @admin = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 'admin')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    end

    it 'I can not visit the user profile' do
      visit '/profile'
    end

    it 'I can not visit the merchant dashboard' do
      visit '/merchant'
    end

    it 'I cannot visit the merchant order show' do
      visit '/merchant/orders/3'
    end

    it 'I cannot visit the merchant items index' do
      visit '/merchant/items'
    end

    it 'I cannot visit a cart' do
      visit '/cart'
    end

    after :each do
      expect(page.status_code).to eq(404)
    end
  end
end