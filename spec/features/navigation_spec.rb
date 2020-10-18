
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

  describe 'As a User' do
    before :each do
      @user = User.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'I see who I am logged in as' do
      visit root_path

      within 'nav' do
        expect(page).to have_content("Logged in as #{@user.name}")
      end
    end

    describe 'I see a nav bar where I can link to' do
      it 'the welcome page' do
        visit items_path

        within 'nav' do
          click_link 'Home'
        end

        expect(current_path).to eq(root_path)
      end

      it 'all items' do
        visit root_path

        within 'nav' do
          click_link 'Items'
        end

        expect(current_path).to eq(items_path)
      end

      it 'all merchants' do
        visit root_path

        within 'nav' do
          click_link 'Merchants'
        end

        expect(current_path).to eq(merchants_path)
      end

      it 'my cart' do
        visit root_path

        within 'nav' do
          click_link 'Cart: 0'
        end

        expect(current_path).to eq(cart_path)
      end

      it 'the logout page' do
        visit root_path

        within 'nav' do
          click_link 'Logout'
        end

        expect(current_path).to eq(root_path)
      end

      it 'my profile page' do
        visit root_path

        within 'nav' do
          click_link 'Profile'
        end

        expect(current_path).to eq(profile_path)
      end
    end

    describe 'I do not see in my nav bar' do
      it 'the login link' do
        visit root_path

        expect(page).to_not have_link('Login')
      end

      it 'the registration link' do
        visit root_path

        expect(page).to_not have_link('Register')
      end
    end
  end
end
