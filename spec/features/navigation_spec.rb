
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    describe "I see a nav bar with links to" do
      
      it 'the welcome page' do
        visit items_path

        within 'nav' do
          click_link 'Home'
        end

        expect(current_path).to eq(root_path)
      end

      it 'all items' do
        visit merchants_path

        within 'nav' do
          click_link 'All Items'
        end
  
        expect(current_path).to eq(items_path)
      end

      it 'all merchants' do
        visit items_path

        within 'nav' do
          click_link 'All Merchants'
        end

        expect(current_path).to eq(merchants_path)
      end

      it 'the registration page' do
        visit root_path

        within 'nav' do
          click_link 'Register'
        end

        expect(current_path).to eq(registration_path)
      end

      it 'the login page' do
        visit root_path

        within 'nav' do
          click_link 'Login'
        end

        expect(current_path).to eq(login_path)
      end

      it 'my cart' do
        visit merchants_path

        within 'nav' do
          click_link 'Cart'
        end
        
        expect(current_path).to eq(cart_path)

        visit items_path

        within 'nav' do
          click_link 'Cart'
        end
        
        expect(current_path).to eq(cart_path)
      end
    end
  end
end
