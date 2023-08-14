# frozen_string_literal: true

require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  describe 'fixtures' do
    setup { @roles = Role.all }

    test 'many are present' do
      assert @roles.count.positive?
    end

    test 'each is valid' do
      @roles.each do |role|
        role.valid?
        assert_empty role.errors
      end
    end
  end
end
