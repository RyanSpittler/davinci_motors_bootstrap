require 'rails_helper'

feature 'Creating Cars' do
  before(:each) do
    @car1 = FactoryGirl.build(:car)
  end
  scenario 'can create a car' do
    visit '/'

    click_link 'New Car'

    fill_in 'Make', with: @car1.make
    fill_in 'Model', with: @car1.model
    fill_in 'Year', with: @car1.year
    fill_in 'Price', with: @car1.price

    click_button 'Create Car'

    expect(page).to have_content("#{@car1.year} #{@car1.make} #{@car1.model} created.")
    thousands, hundreds = @car1.price.to_s[1..-6], @car1.price.to_s[-5..-1]
    expect(page).to have_content("#{thousands},#{hundreds}")
  end

  scenario 'can create a second car' do
    FactoryGirl.create(:car)

    visit '/'

    click_link 'New Car'

    fill_in 'Make', with: @car1.make
    fill_in 'Model', with: @car1.model
    fill_in 'Year', with: @car1.year
    fill_in 'Price', with: @car1.price

    click_button 'Create Car'

    expect(page).to have_content("#{@car1.year} #{@car1.make} #{@car1.model} created.")
    thousands, hundreds = @car1.price.to_s[1..-6], @car1.price.to_s[-5..-1]
    expect(page).to have_content("#{thousands},#{hundreds}")
  end
end

feature 'Editing Cars' do
  scenario 'can edit a car' do
    @user = FactoryGirl.create(:user)
    @user.cars << @car = FactoryGirl.create(:car)

    visit '/'
    click_link "Login"
    fill_in "Email", with: @user.email
    fill_in "Password", with: @user.password
    click_button "Login"
    click_link "My Cars"

    click_link 'Edit'

    fill_in 'Price', with: '46000'

    click_button 'Update Car'

    expect(page).to have_content("#{@car.year} #{@car.make} #{@car.model} updated.")
    expect(page).to have_content("$46,000.00")
  end
end

feature 'Deleting Cars' do
  scenario 'can delete a car' do
    @user = FactoryGirl.create(:user)
    @user.cars << @car1 = FactoryGirl.create(:car)
    @user.cars << @car2 = FactoryGirl.create(:car)

    visit '/'
    click_link "Login"
    fill_in "Email", with: @user.email
    fill_in "Password", with: @user.password
    click_button "Login"
    click_link "My Cars"

    click_link "destroy_car_#{@car2.id}"

    expect(page).to have_content('Car was successfully destroyed.')

    expect(page).to have_content(@car1.make)
    expect(page).to have_content(@car1.model)
    expect(page).to have_content(@car1.year)
    thousands, hundreds = @car1.price.to_s[1..-6], @car1.price.to_s[-5..-1]
    expect(page).to have_content("#{thousands},#{hundreds}")

    expect(page).to_not have_content(@car2.make)
    expect(page).to_not have_content(@car2.model)
    expect(page).to_not have_content(@car2.year)
    thousands, hundreds = @car2.price.to_s[1..-6], @car2.price.to_s[-5..-1]
    expect(page).to_not have_content("#{thousands},#{hundreds}")
  end
end
