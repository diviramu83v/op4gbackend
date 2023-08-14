# frozen_string_literal: true

require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  describe 'fixture' do
    it 'is valid' do
      client = clients(:standard)
      client.valid?
      assert_empty client.errors
    end
  end
end
