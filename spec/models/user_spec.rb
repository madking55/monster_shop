require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}
    it {should validate_presence_of :email}
    it {should validate_presence_of :password}
    it {should validate_uniqueness_of :email}
  end

  describe 'relationships' do
    it {should belong_to(:merchant).optional}
    it {should have_many :orders}
  end

  describe "roles" do
    it "can be created as an admin" do
      admin_user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 2)

      expect(admin_user.role).to eq("admin")
      expect(admin_user.admin?).to be_truthy
    end

    it 'can be created as merchant' do
      merchant_user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 1)

      expect(merchant_user.role).to eq("merchant")
      expect(merchant_user.merchant?).to be_truthy
    end

    it "can be created as a default user" do
      default_user = User.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')

      expect(default_user.role).to eq("default")
      expect(default_user.default?).to be_truthy
    end
  end
end