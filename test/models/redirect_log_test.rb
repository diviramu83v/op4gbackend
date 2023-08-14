# frozen_string_literal: true

require 'test_helper'

class RedirectLogTest < ActiveSupport::TestCase
  describe 'fixture' do
    it 'is valid' do
      redirect_log = redirect_logs(:one)
      assert redirect_log.valid?
    end
  end
end
