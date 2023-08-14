# frozen_string_literal: true

require 'test_helper'

class Employee::OnrampDisablingsControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_operations_employee
  end

  it 'disables the onramps and redirects with no anchor if the onramp has no vendor' do
    @onramp = onramps(:testing)

    post onramp_disabling_url(onramp_id: @onramp)

    assert_redirected_to survey_onramps_url(@onramp.survey)
  end

  it 'disables the onramps and redirects with with an anchor if a vendor is present' do
    @onramp = onramps(:vendor)

    post onramp_disabling_url(onramp_id: @onramp)

    assert_redirected_to survey_vendors_url(@onramp.survey, anchor: "vendor-#{@onramp.batch_vendor.id}")
  end

  it 're-enables the onramp and redirects with no anchor if the onramp has no vendor' do
    @onramp = onramps(:testing)

    delete onramp_disabling_url(onramp_id: @onramp), params: { onramp: @onramp.attributes }

    assert_redirected_to survey_onramps_url(@onramp.survey)
  end

  it 're-enables the onramp and redirects to with an anchor if a vendor is present' do
    @onramp = onramps(:vendor)

    delete onramp_disabling_url(onramp_id: @onramp), params: { onramp: @onramp.attributes }

    assert_redirected_to survey_vendors_url(@onramp.survey, anchor: "vendor-#{@onramp.batch_vendor.id}")
  end
end
