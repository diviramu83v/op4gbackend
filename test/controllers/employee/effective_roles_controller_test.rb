# frozen_string_literal: true

require 'test_helper'

class Employee::EffectiveRolesControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_admin
  end

  describe '#create' do
    it 'should redirect to redirect_url' do
      params = { role: 'Admin', redirect_url: 'admin.op4g.com/' }
      post effective_roles_url, params: params
      assert_redirected_to 'admin.op4g.com/'
    end
  end
end
