# frozen_string_literal: true

require 'test_helper'

class SettingsTest < ActiveSupport::TestCase
  setup do
    @keys = %w[
      DISQO_USERNAME
      DISQO_PASSWORD
      DISQO_HASH_KEY
      DISQO_API_URL
      DISQO_REDIRECT_URL
    ]
  end

  test 'values returned' do
    @keys.each do |key|
      ENV.stubs(:fetch).with(key).returns('test-value')

      assert_equal 'test-value', Settings.send(key.downcase.to_sym)
    end
  end

  test 'errors raised' do
    @keys.each do |key|
      ENV.stubs(:fetch).with(key).returns(nil)

      assert_raises "Missing #{key} ENV var. Please add it for this environment." do
        Settings.send(key.downcase.to_sym)
      end
    end
  end
end
