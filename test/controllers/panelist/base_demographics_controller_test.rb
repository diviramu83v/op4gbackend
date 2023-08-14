# frozen_string_literal: true

require 'test_helper'

class Panelist::BaseDemographicsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_confirmed_panelist

    @params = {
      base_demographics: {
        address: '123 Main Street',
        city: 'Somewhere',
        state: 'TX',
        postal_code: '76017',
        year: '1986',
        month: '06',
        day: '06'
      }
    }
  end

  # TODO: update to come only after terms are accepted, etc.
  # it 'should get base_demographics' do
  #   get base_demographics_url

  #   assert_response :success
  # end

  it 'should redirect to panelist dashboard' do
    populate_panel_membership

    post base_demographics_url, params: @params

    assert_redirected_to panelist_dashboard_url
  end

  it 'should redirect back to panelist dashboard' do
    Panelist.any_instance.stubs(:base_demo_questions_completed?).returns(false)
    populate_panel_membership

    post base_demographics_url, params: @params

    assert_redirected_to panelist_dashboard_path
  end

  it 'should redirect to demographics url' do
    Panelist.any_instance.stubs(:base_demo_questions_completed?).returns(false)
    Panelist.any_instance.stubs(:demos_completed?).returns(false)
    populate_panel_membership

    post base_demographics_url, params: @params

    assert_redirected_to demographics_url
  end

  it 'should fail to create panelists demographics' do
    Panelist.any_instance.stubs(:base_demo_questions_completed?).returns(false)
    populate_panel_membership

    post base_demographics_url, params: { base_demographics: { bad_param: 'bad' } }

    assert_template :show
  end

  it 'should catch a bad date in POST request that tries to circumvent the web app and send it to the error page' do
    # make base demographics incomplete
    @panelist.state = nil
    @panelist.save!

    # put a value into the month param that is too big to be parsed into an 'int'
    @params[:base_demographics][:month] = '09173017005'

    post base_demographics_url, params: @params

    assert_template :show
  end

  def populate_panel_membership
    panel_membership = PanelMembership.new(panel_id: Panel.find_by(name: 'Op4G').id, panelist_id: @panelist.id)
    panel_membership.save!
  end
end
