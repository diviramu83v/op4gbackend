# frozen_string_literal: true

require 'test_helper'

class Employee::NonprofitCampaignsControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_recruitment_employee
  end

  it 'creates a new nonprofit campaign with default parameters' do
    @nonprofit = nonprofits(:one)

    get new_nonprofit_recruiting_campaign_url(nonprofit_id: @nonprofit.id)

    assert_template :new
  end

  it 'creates a new nonprofit campaign with the provided parameters' do
    @nonprofit = nonprofits(:one)

    post nonprofit_recruiting_campaigns_url(nonprofit_id: @nonprofit.id),
         params: { recruiting_campaign: { code: 'test' } }

    assert_redirected_to @nonprofit.campaigns.first
  end

  it 'renders the "new" template if the campaign does not save' do
    @nonprofit = nonprofits(:one)

    RecruitingCampaign.any_instance.stubs(:save).returns(false)

    post nonprofit_recruiting_campaigns_url(nonprofit_id: @nonprofit.id),
         params: { recruiting_campaign: { code: 'test' } }

    assert_template :new
  end
end
