# frozen_string_literal: true

require 'test_helper'

class CleanIdDeviceTest < ActiveSupport::TestCase
  describe 'fixture' do
    def setup
      @clean_id_device = clean_id_devices(:standard)
    end

    test 'is valid' do
      assert @clean_id_device.valid?
      assert_empty @clean_id_device.errors
    end
  end
end
