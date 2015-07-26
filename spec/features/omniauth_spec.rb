require 'rails_helper'

shared_examples 'it is OmniAuth Compatible' do |provider|
  before(:each) do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[provider] = {
      provider: "#{provider}",
      uid: '250523709',
      info: {
        name: 'first last',
        email: 'email@email'
      }
    }
  end

  let(:click_provider_link) do
    visit '/'
    
    click_link 'Signup'
    page.find("#signup-#{provider}").click
    # Since we are in test mode, we don't get the redirect from the provider.
    # We have to manually go there in Capybara.
    visit "/auth/#{provider}/callback"
  end

  scenario "can sign up via #{provider}" do
    click_provider_link

    expect(page).to have_content('Verify Details')
    click_button 'Submit'
    expect(page).to have_content("Thank you for signing up, First.")
  end

  scenario "can log back in via #{provider}" do
    click_provider_link

    click_button 'Submit'
    click_link 'Logout'

    expect(page).to have_content("email@email has been logged out.")

    click_link 'Login'
    page.find("#login-#{provider}").click
    # Since we are in test mode, we don't get the redirect from the provider.
    # We have to manually go there in Capybara.
    visit "/auth/#{provider}/callback"

    expect(page).to have_content("Welcome back, First.")
  end

  scenario "invalid users do not log in via #{provider} (ERROR above is expected)" do
    OmniAuth.config.mock_auth[provider] = :invalid_credentials
    # We make the test believe that we did not actually sign in.
    
    click_provider_link
    
    expect(page).to_not have_content("Signed in as")
    expect(page).to_not have_content("Verify Details")

    # This resets, so we no longer get authentication errors.
    OmniAuth.config.mock_auth[provider] = nil
  end
end

User.providers.each do |provider, __|
  describe provider do
    subject { provider }
    it_should_behave_like('it is OmniAuth Compatible', provider)
  end
end
