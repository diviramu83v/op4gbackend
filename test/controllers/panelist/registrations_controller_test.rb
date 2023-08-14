# frozen_string_literal: true

# require 'test_helper'

# class Panelist::RegistrationsControllerTest < ActionDispatch::IntegrationTest
#   def setup
#     @panelist_params = {
#       first_name: 'regtest',
#       last_name: 'lname-test',
#       email: 'test@test.com',
#       password: 'password'
#     }
#   end

#   # TODO: not sure why this is here
#   # make sure a logger is available
#   def logger
#     @logger ||= Logger.new($stdout)
#   end

#   it 'load registration page' do
#     get new_panelist_registration_url

#     assert_response :success
#   end

#   it 'successful signup prompts for confirmation of email address on the sign-in page' do
#     Recaptcha.any_instance.stubs(:token_valid?).returns(true) # Fake recaptcha check.
#     ApplicationController.any_instance.stubs(:session).returns(code: 'any-code')

#     post panelist_registration_url, params: { panelist: @panelist_params }

#     assert_redirected_to new_panelist_session_path(emailed: true)
#   end

#   it 'invalid data' do
#     post panelist_registration_url, params: { panelist: @panelist_params.merge(first_name: '') }

#     assert_response_with_warning
#   end

#   it 'incomplete captcha' do
#     post panelist_registration_url, params: { 'g-recaptcha-response': '', panelist: @panelist_params }

#     assert_response_with_warning
#   end

#   it 'successful registration adds panelist to panel' do
#     Recaptcha.any_instance.stubs(:token_valid?).returns(true) # Fake recaptcha check.
#     ApplicationController.any_instance.stubs(:session).returns(code: 'any-code')

#     @panel = Panel.default

#     assert_difference -> { @panel.panelist_count }, 1 do
#       post panelist_registration_url, params: { panelist: @panelist_params }
#     end
#   end

#   it 'panelist default verified_flag status is false after successful registration' do
#     Recaptcha.any_instance.stubs(:token_valid?).returns(true) # Fake recaptcha check.
#     ApplicationController.any_instance.stubs(:session).returns(code: 'any-code')

#     @panel = Panel.default

#     assert_difference -> { @panel.panelist_count }, 1 do
#       post panelist_registration_url, params: { panelist: @panelist_params }
#     end

#     new_panelist = Panelist.where(email: @panelist_params[:email]).first
#     assert_equal false, new_panelist.verified_flag
#   end

#   it 'successful registration adds panelist ip history' do
#     Recaptcha.any_instance.stubs(:token_valid?).returns(true) # Fake recaptcha check.
#     ApplicationController.any_instance.stubs(:session).returns(code: 'any-code')

#     assert_difference -> { PanelistIpHistory.count }, 1 do
#       post panelist_registration_url, params: { panelist: @panelist_params }
#     end
#   end

#   it 'Successful registration with valid campaign code' do
#     Recaptcha.any_instance.stubs(:token_valid?).returns(true) # Fake recaptcha check.
#     ApplicationController.any_instance.stubs(:session).returns(code: 'any-code')

#     assert_difference -> { Panelist.count } do
#       post panelist_registration_url, params: { panelist: @panelist_params }
#     end
#   end

#   it 'Successful registration with valid affiliate code' do
#     Recaptcha.any_instance.stubs(:token_valid?).returns(true) # Fake recaptcha check.
#     ApplicationController.any_instance.stubs(:session).returns(aff_id: '123')

#     assert_difference -> { Panelist.count } do
#       post panelist_registration_url, params: { panelist: @panelist_params }
#     end
#   end

#   it 'does not save if no valid campaign code or affiliate code' do
#     Recaptcha.any_instance.stubs(:token_valid?).returns(true) # Fake recaptcha check.

#     assert_no_difference -> { Panelist.count } do
#       post panelist_registration_url, params: { panelist: @panelist_params }
#     end
#   end

#   it 'does not save if invalid campaign code' do
#     Recaptcha.any_instance.stubs(:token_valid?).returns(true) # Fake recaptcha check.
#     ApplicationController.any_instance.stubs(:session).returns(code: 'wrong-code')

#     assert_no_difference -> { Panelist.count } do
#       post panelist_registration_url, params: { panelist: @panelist_params }
#     end
#   end

#   it 'does not save if invalid affiliate code' do
#     Recaptcha.any_instance.stubs(:token_valid?).returns(true) # Fake recaptcha check.
#     ApplicationController.any_instance.stubs(:session).returns(aff_id: 'wrong-code')

#     assert_no_difference -> { Panelist.count } do
#       post panelist_registration_url, params: { panelist: @panelist_params }
#     end
#   end

#   it 'flashes alert if no valid campaign code or affiliate code' do
#     Recaptcha.any_instance.stubs(:token_valid?).returns(true) # Fake recaptcha check.

#     post panelist_registration_url, params: { panelist: @panelist_params }

#     assert_equal 'Unable to complete sign up.', flash[:alert]
#   end

#   it 'flashes alert if invalid campaign code' do
#     Recaptcha.any_instance.stubs(:token_valid?).returns(true) # Fake recaptcha check.
#     ApplicationController.any_instance.stubs(:session).returns(code: 'wrong-code')

#     post panelist_registration_url, params: { panelist: @panelist_params }

#     assert_equal 'Unable to complete sign up.', flash[:alert]
#   end

#   it 'variables are passed from URL to session to panelist' do
#     Recaptcha.any_instance.stubs(:token_valid?).returns(true)

#     RecruitingCampaign.create(code: 'audience123', campaignable_type: 'CampaignAudience')

#     @panelist_params = {
#       panelist: {
#         first_name: 'regtest',
#         last_name: 'lname-test',
#         email: 'test@test.com',
#         password: 'password'
#       }
#     }

#     get new_panelist_registration_url(code: 'audience123', offer_id: 'offer123', aff_id: 'aff123', aff_sub: 'sub123', aff_sub2: 'sub789')
#     post panelist_registration_url, params: @panelist_params

#     @panelist = Panelist.last

#     assert_equal 'audience123', @panelist.campaign.code

#     assert_equal 'offer123', @panelist.offer_code
#     assert_equal 'aff123', @panelist.affiliate_code
#     assert_equal 'sub123', @panelist.sub_affiliate_code
#     assert_equal 'sub789', @panelist.sub_affiliate_code_2
#   end

#   it 'successful campaign registration sets panelist lock flag to match campaign lock flag' do
#     Recaptcha.any_instance.stubs(:token_valid?).returns(true) # Fake recaptcha check.

#     @campaign = recruiting_campaigns(:standard)
#     @campaign.update!(lock_flag: true)

#     get landing_page_url(code: @campaign.code)
#     get new_panelist_registration_url

#     assert_difference -> { Panelist.count }, 1 do
#       post panelist_registration_url, params: { panelist: @panelist_params }
#     end

#     new_panelist = Panelist.where(email: @panelist_params[:email]).first
#     assert_equal true, new_panelist.lock_flag
#   end

#   it 'successful campaign registration adds panelist to Op4G panel' do
#     Recaptcha.any_instance.stubs(:token_valid?).returns(true) # Fake recaptcha check.

#     @panel = Panel.find_by(slug: 'op4g-us')
#     @campaign = recruiting_campaigns(:standard)

#     get landing_page_url(code: @campaign.code)
#     get new_panelist_registration_url

#     assert_difference -> { @panel.panelist_count }, 1 do
#       post panelist_registration_url, params: { panelist: @panelist_params }
#     end

#     new_panelist = Panelist.where(email: @panelist_params[:email]).first
#     assert new_panelist.last_activity_at.present?
#   end

#   it 'should re-render the :new page with a message to retry when the SendGrid server is temporarily unavailable' do
#     Recaptcha.any_instance.stubs(:token_valid?).returns(true) # Fake recaptcha check.
#     ApplicationController.any_instance.stubs(:session).returns(code: 'any-code')
#     Panelist.any_instance.stubs(:save).raises(Net::SMTPAuthenticationError)

#     post panelist_registration_url, params: { panelist: @panelist_params }

#     assert_redirected_to new_panelist_registration_url
#     assert_not_nil flash[:notice]
#   end

#   describe 'save' do
#     test 'save fails' do
#       Recaptcha.any_instance.stubs(:token_valid?).returns(true)
#       Panelist.any_instance.expects(:save).returns(false)
#       @campaign = recruiting_campaigns(:standard)

#       get landing_page_url(code: @campaign.code)
#       get new_panelist_registration_url

#       post panelist_registration_url, params: { panelist: @panelist_params }

#       assert_equal 'Unable to complete sign up.', flash[:alert]

#       new_panelist = Panelist.where(email: @panelist_params[:email]).first
#       assert_not new_panelist
#     end
#   end

#   describe '#session_locale_or_default' do
#     setup do
#       Recaptcha.any_instance.stubs(:token_valid?).returns(true)
#       @campaign = recruiting_campaigns(:standard)

#       get landing_page_url(code: @campaign.code)
#       get new_panelist_registration_url
#     end

#     test "'au' country returns 'en' locale" do
#       ApplicationController.any_instance.stubs(:session).returns(country: 'au', code: 'any-code')

#       post panelist_registration_url, params: { panelist: @panelist_params }

#       new_panelist = Panelist.where(email: @panelist_params[:email]).first
#       assert new_panelist.locale == 'en'
#     end

#     test "'de' country returns 'de' locale" do
#       ApplicationController.any_instance.stubs(:session).returns(country: 'de', code: 'any-code')
#       post panelist_registration_url, params: { panelist: @panelist_params }

#       new_panelist = Panelist.where(email: @panelist_params[:email]).first
#       assert new_panelist.locale == 'de'
#     end

#     test "'fr' country returns 'fr' locale" do
#       ApplicationController.any_instance.stubs(:session).returns(country: 'fr', code: 'any-code')
#       post panelist_registration_url, params: { panelist: @panelist_params }

#       new_panelist = Panelist.where(email: @panelist_params[:email]).first
#       assert new_panelist.locale == 'fr'
#     end

#     test "'it' country returns 'it' locale" do
#       ApplicationController.any_instance.stubs(:session).returns(country: 'it', code: 'any-code')
#       post panelist_registration_url, params: { panelist: @panelist_params }

#       new_panelist = Panelist.where(email: @panelist_params[:email]).first
#       assert new_panelist.locale == 'it'
#     end

#     test "'es' country returns 'es' locale" do
#       ApplicationController.any_instance.stubs(:session).returns(country: 'es', code: 'any-code')
#       post panelist_registration_url, params: { panelist: @panelist_params }

#       new_panelist = Panelist.where(email: @panelist_params[:email]).first
#       assert new_panelist.locale == 'es'
#     end
#   end

#   describe 'Net::OpenTimeout' do
#     test 'raised error' do
#       Recaptcha.any_instance.stubs(:token_valid?).returns(true) # Fake recaptcha check.
#       ApplicationController.any_instance.stubs(:session).returns(code: 'any-code')
#       Panelist.any_instance.stubs(:save).raises(Net::OpenTimeout)

#       post panelist_registration_url, params: { panelist: @panelist_params }

#       assert_redirected_to new_panelist_registration_url
#       assert_not_nil flash[:alert]
#     end
#   end
# end
