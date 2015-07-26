require 'rails_helper'

feature 'User Authentication' do
  before(:each) do
    @user = FactoryGirl.create(:user)
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
    click_button 'Signup'

    expect(page).to have_text('Thank you for signing up Bob')
    expect(page).to have_text('Signed in as bob@smith.com')
  end

  scenario 'allows existing users to login' do
    visit '/'

    expect(page).to have_link('Login')

    click_link 'Login'

    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password

    click_button 'Login'

    expect(page).to have_text("Welcome back #{@user.first_name}")
    expect(page).to have_text("Signed in as #{@user.email}")
  end

  scenario 'prevents existing users from logging in with bad password' do
    visit '/'

    expect(page).to have_link('Login')

    click_link 'Login'

    fill_in 'Email', with: @user.email
    fill_in 'Password', with: 'NOT_YOUR_PASSWORD'

    click_button 'Login'

    expect(page).to have_text("Invalid email or password")
    expect(page).to_not have_text("Signed in as")
  end

  scenario 'allows logged in users to logout' do
    visit login_path

    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password

    click_button 'Login'

    expect(page).to have_text("Signed in as #{@user.email}")

    expect(page).to have_link('Logout')

    click_link('Logout')

    expect(page).to have_text("#{@user.email} has been logged out.")
    expect(page).to_not have_text("Signed in as #{@user.email}")
  end

  scenario "allows a logged in user to claim a car" do
    @car1 = FactoryGirl.create(:car)
    @car2 = FactoryGirl.create(:car)

    visit login_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: @user.password
    click_button "Login"
    
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
  end
end
