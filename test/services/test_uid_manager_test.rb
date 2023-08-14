# frozen_string_literal: true

require 'test_helper'

class TestUidManagerTest < ActiveSupport::TestCase
  describe '#next' do
    setup do
      @employee = employees(:operations)
      @onramp = onramps(:testing)
    end

    it 'should increment the employees test uid for the onramp' do
      assert_difference -> { @employee.test_uids.count } do
        TestUidManager.new(employee: @employee, onramp: @onramp).next
      end
    end

    it 'should increment the uid by 1' do
      assert_equal TestUidManager.new(employee: @employee, onramp: @onramp).next, 'js_test_1'
      assert_equal TestUidManager.new(employee: @employee, onramp: @onramp).next, 'js_test_2'
    end
  end
end
