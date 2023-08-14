# frozen_string_literal: true

require 'test_helper'

class CountryTest < ActiveSupport::TestCase
  describe 'fixture' do
    it 'is valid' do
      country = countries(:standard)
      country.valid?
      assert_empty country.errors
    end
  end
end
