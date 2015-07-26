require 'rails_helper'

def login_test_user
  click_link 'Login'
  fill_in 'Email', with: @user.email
  fill_in 'Password', with: @user.password
  click_button 'Login'
end

feature 'User Authentication' do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @car1 = FactoryGirl.create(:car)
    @car2 = FactoryGirl.create(:car)
    @car3 = FactoryGirl.build(:car)
  end
  scenario 'allows a user to signup' do
    visit '/'

    expect(page).to have_link('Signup')

    click_link('Signup')

    fill_in 'First Name', with: 'Bob'
    fill_in 'Last Name', with: 'Smith'
    fill_in 'Email', with: 'bob@smith.com'
    fill_in 'Password', with: 'sup3rs3krit'
    fill_in 'Password Confirmation', with: 'sup3rs3krit'
    click_button 'Submit'

    expect(page).to have_text('Thank you for signing up, Bob.')
    expect(page).to have_text('Signed in as bob@smith.com')
  end

  scenario 'allows existing users to login' do
    visit '/'

    expect(page).to have_link('Login')

    login_test_user

    expect(page).to have_text("Welcome back, #{@user.first_name.titleize}.")
    expect(page).to have_text("Signed in as #{@user.email}")
  end

  scenario 'prevents users from logging in with bad password' do
    visit '/'

    expect(page).to have_link('Login')

    click_link 'Login'
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: "NOT_YOUR_PASSWORD"
    click_button 'Login'

    expect(page).to have_text("Invalid email or password")
    expect(page).to_not have_text("Signed in as")
  end

  scenario 'allows logged in users to logout' do
    visit "/"

    login_test_user

    expect(page).to have_text("Signed in as #{@user.email}")

    expect(page).to have_link('Logout')

    click_link('Logout')

    expect(page).to have_text("#{@user.email} has been logged out.")
    expect(page).to_not have_text("Signed in as #{@user.email}")
  end

  scenario "allows claiming and unclaiming of cars" do
    visit "/"
    expect(page).to_not have_link("Claim")

    login_test_user

    within("#car_#{@car1.id}") do
      click_link "Claim"
    end

    expect(page).to have_text("#{@car1.make} #{@car1.model} has been moved to your inventory.")
    expect(page).to_not have_selector("#car_#{@car1.id}")
    expect(page).to have_selector("#car_#{@car2.id}")

    expect(page).to have_link("My Cars")
    click_link "My Cars"

    expect(page).to have_selector("#car_#{@car1.id}")
    expect(page).to_not have_selector("#car_#{@car2.id}")

    click_link "Home"
    within("#car_#{@car2.id}") do
      click_link "Claim"
    end

    click_link "My Cars"
    within("#car_#{@car1.id}") do
      click_link "Unclaim"
    end

    expect(page).to have_text("#{@car1.make} #{@car1.model} has been removed from your inventory.")
    expect(page).to_not have_selector("#car_#{@car1.id}")
    expect(page).to have_selector("#car_#{@car2.id}")

    click_link "Home"
    expect(page).to have_selector("#car_#{@car1.id}")
    expect(page).to_not have_selector("#car_#{@car2.id}")
  end

  scenario "allows users to edit or destroy claimed cars only" do
    visit "/"
    expect(page).to_not have_link("Edit")
    expect(page).to_not have_link("Destroy")

    login_test_user

    within("#car_#{@car1.id}") do
      click_link "Claim"
    end
    click_link "My Cars"

    expect(page).to have_link("Edit")
    expect(page).to have_link("Destroy")
  end

  scenario "new cars are available to claim when not logged in" do
    visit "/"
    click_link "New Car"

    fill_in "Make", with: @car3.make
    fill_in "Model", with: @car3.model
    fill_in "Year", with: @car3.year
    fill_in "Price", with: @car3.price
    click_button "Create Car"

    @car3 = Car.where(price: @car3.price).first

    login_test_user

    within("#car_#{@car3.id}") do
      expect(page).to have_link("Claim")
    end
  end

  scenario "new cars belong to the user when logged in" do
    visit "/"

    login_test_user

    click_link "New Car"

    fill_in "Make", with: @car3.make
    fill_in "Model", with: @car3.model
    fill_in "Year", with: @car3.year
    fill_in "Price", with: @car3.price
    click_button "Create Car"

    @car3 = Car.where(price: @car3.price).first

    click_link "My Cars"
    within("#car_#{@car3.id}") do
      expect(page).to have_link("Unclaim")
    end
  end
end
