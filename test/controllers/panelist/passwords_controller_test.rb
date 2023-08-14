# frozen_string_literal: true

require 'test_helper'

class Panelist::PasswordsControllerTest < ActionDispatch::IntegrationTest
  include Capybara::Email::DSL

  it 'should render the forgot password page if the email is not found' do
    visit new_panelist_password_url

    fill_in 'Email', with: Faker::Internet.email
    click_on 'Send reset instructions'

    assert_current_path panelist_password_url
    assert page.has_content?('Email not found')
  end

  it 'should send an password reset email to the provided email,
      and allow that user to use the token to reset their password' do

    # Create a panelist
    panelist = panelists(:standard)
    panelist.update(confirmed_at: 1.hour.ago, agreed_to_terms_at: 3.days.ago, welcomed_at: 1.day.ago)
    panelist.save!

    # Follow 'Forgot Password?' flow
    visit new_panelist_password_url
    fill_in 'Email', with: panelist.email
    click_on 'Send reset instructions'

    # Click on the link in the 'Forgot Password?' email
    open_email(panelist.email)
    current_email.click_link 'Change your password'

    # Submit the new password
    new_password = 'test1234'

    fill_in 'Password', with: new_password
    fill_in 'Confirm password', with: new_password
    click_on 'Update'

    # Log out
    assert page.has_content?('Available surveys')
    first('.navbar-nav').click_link('Sign out')
    assert page.has_content?('Sign in')

    # Log in with the new password
    fill_in 'Email', with: panelist.email
    fill_in 'Password', with: new_password
    click_on 'Sign in'

    assert page.has_content?('Available surveys')
  end

  it 'should re-render the :new page with a message to retry when the SendGrid server is temporarily unavailable' do
    Devise::PasswordsController.any_instance.stubs(:create).throws(Net::SMTPAuthenticationError)

    panelist = panelists(:standard)
    panelist.update(confirmed_at: 1.hour.ago, agreed_to_terms_at: 3.days.ago, welcomed_at: 1.day.ago)
    panelist.save!

    # Follow 'Forgot Password?' flow
    visit new_panelist_password_url
    fill_in 'Email', with: panelist.email
    click_on 'Send reset instructions'

    assert page.has_content?('Email service momentarily unavailable; please try again.')
  end
end
