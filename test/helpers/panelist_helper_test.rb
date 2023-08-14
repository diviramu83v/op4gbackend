# frozen_string_literal: true

require 'test_helper'

class PanelistHelperTest < ActionView::TestCase
  describe '#nonpayment_client_status' do
    test 'returns proper result' do
      assert_equal 'Client reported fraud', nonpayment_client_status('fraudulent')
      assert_equal 'Client did not accept answers', nonpayment_client_status('rejected')
      assert_equal 'N/A', nonpayment_client_status(nil)
    end
  end
end
