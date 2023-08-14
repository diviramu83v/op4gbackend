# frozen_string_literal: true

require 'test_helper'

class Employee::OnrampsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
  end

  it 'edit panel onramp' do
    @onramp = onramps(:panel)

    get edit_onramp_url(@onramp)

    assert_ok_with_no_warning
  end

  it 'update panel onramp' do
    @onramp = onramps(:panel)
    params = { onramp: { check_gate_survey: true } }

    patch onramp_url(@onramp, params: params)

    assert_redirected_with_no_warning
  end

  it 'edit external onramp' do
    @onramp = onramps(:vendor)

    get edit_onramp_url(@onramp)

    assert_ok_with_no_warning
  end

  it 'update external onramp' do
    @onramp = onramps(:vendor)
    params = { onramp: { check_gate_survey: true } }

    patch onramp_url(@onramp, params: params)

    assert_redirected_to survey_vendors_url(@onramp.survey)
  end

  describe '#update' do
    setup do
      Onramp.any_instance.stubs(:save).returns(false)
      @onramp = onramps(:vendor)
    end

    it 'should fail update' do
      params = { onramp: { check_gate_survey: true } }

      patch onramp_url(@onramp, params: params)
      assert_template :edit
    end
  end

  it 'affiliate code and sub affiliate code are saved if present' do
    @onramp = onramps(:vendor)
    params = { uid: 1, aff_id: 1, aff_sub: 2 }

    get survey_onramp_url(@onramps, params: params, token: @onramp.token)

    onboarding = Onboarding.find_by(uid: params[:uid])

    assert_equal onboarding.affiliate_code, '1'
    assert_equal onboarding.sub_affiliate_code, '2'
  end
end
