# frozen_string_literal: true

require 'test_helper'

class Employee::OnrampPrescreenerActivationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_operations_employee
    @onramp = onramps(:testing)
  end

  describe '#create (async)' do
    setup do
      assert_equal false, @onramp.check_prescreener
    end

    describe 'success' do
      it 'updates prescreener flag' do
        assert_changes '@onramp.check_prescreener', from: false, to: true do
          post "#{onramp_prescreener_url(@onramp)}.js"
          @onramp.reload
        end
        assert_response :ok
      end
    end

    describe 'failure' do
      setup do
        Onramp.any_instance.expects(:update).returns(false).once
      end

      it 'does not update screener flag' do
        assert_no_changes '@onramp.check_prescreener' do
          post "#{onramp_prescreener_url(@onramp)}.js"
          @onramp.reload
        end
        assert_response :ok
      end

      it 'does not update screener flag because there are no questions' do
        @onramp.survey.prescreener_question_templates = []
        assert_no_changes '@onramp.check_prescreener' do
          post "#{onramp_prescreener_url(@onramp)}.js"
          @onramp.reload
        end
        assert_response :ok
      end
    end
  end

  describe '#destroy (async)' do
    setup do
      @onramp.update!(check_prescreener: true)
    end

    describe 'success' do
      it 'updates prescreener flag' do
        assert_changes '@onramp.check_prescreener', from: true, to: false do
          delete "#{onramp_prescreener_url(@onramp)}.js"
          @onramp.reload
        end
        assert_response :ok
      end
    end

    describe 'failure' do
      setup do
        Onramp.any_instance.expects(:update).returns(false).once
      end

      it 'does not update prescreener flag' do
        assert_no_changes '@onramp.check_prescreener' do
          delete "#{onramp_prescreener_url(@onramp)}.js"
          @onramp.reload
        end
        assert_response :ok
      end
    end
  end
end
