# frozen_string_literal: true

require 'test_helper'

class Panelist::LandingPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @panelist_params = {
      panelist: {
        first_name: 'regtest',
        last_name: 'lname-test',
        email: 'test@test.com',
        password: 'password'
      }
    }

    RecruitingCampaign.create(code: 'nonprofit123', campaignable_type: 'Nonprofit')
  end

  # rubocop:disable Rails/I18nLocaleAssignment
  def teardown
    I18n.locale = 'en'
  end
  describe 'GET show' do
    describe 'with unknown country' do
      it 'sets the locale to the default' do
        get landing_page_url(country: 'xy')

        assert_equal I18n.locale, I18n.default_locale
      end
    end
  end
  # rubocop:enable Rails/I18nLocaleAssignment

  describe 'nonprofit campaign code and panel param' do
    setup do
      @campaign = recruiting_campaigns(:standard)
      @campaign.update!(incentive: 7, campaignable: nonprofits(:one))
      @panel = Panel.find_by(name: 'Diabetes')
      @params = { code: @campaign.code, panel: @panel.slug }
    end

    it 'renders the nonprofit template' do
      get landing_page_url, params: @params

      assert_template :nonprofit
    end
  end

  describe 'nonprofit campaign code alone' do
    setup do
      @campaign = recruiting_campaigns(:standard)
      @campaign.update!(campaignable: nonprofits(:one))
      @params = { code: @campaign.code }
    end

    it 'renders the nonprofit template' do
      get landing_page_url, params: @params

      assert_template :nonprofit
    end
  end

  describe 'panel param alone' do
    setup do
      @panel = Panel.find_by(name: 'Diabetes')
      @params = { panel: @panel.slug }
    end

    it 'renders the generic view' do
      get landing_page_url, params: @params

      assert_template :show
    end
  end

  describe 'op4g panel param' do
    setup do
      @panel = Panel.find_by(name: 'Op4G')
      @params = { panel: @panel.slug }
    end

    it 'renders the default view' do
      get landing_page_url, params: @params

      assert_template :default
    end
  end

  describe 'generic campaign code alone' do
    setup do
      @campaign = recruiting_campaigns(:standard)
      @params = { code: @campaign.code }
    end

    it 'renders the right template' do
      get landing_page_url, params: @params

      assert_template :default
    end
  end

  describe 'no campaign or panel params' do
    it 'renders the default view' do
      get landing_page_url

      assert_template :default
    end
  end
end
