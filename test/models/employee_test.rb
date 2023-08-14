# frozen_string_literal: true

require 'test_helper'

class EmployeeTest < ActiveSupport::TestCase
  describe 'fixture' do
    setup { @employee = employees(:operations) }

    it 'is valid' do
      @employee.valid?
      assert_empty @employee.errors
    end

    test 'has a role' do
      assert @employee.roles.any?
    end
  end

  describe 'feasibility_count' do
    setup do
      @employee = employees(:operations)
      @panel = panels(:standard)
    end

    test 'count increases' do
      assert_equal 0, @employee.feasibility_count

      query = DemoQuery.new(employee: @employee, panel: @panel)
      query.save

      assert_equal 1, @employee.feasibility_count
    end
  end

  describe '#test_mode_on?' do
    setup do
      @employee = employees(:operations)
      @test_mode = survey_test_modes(:one)
      assert_equal @test_mode, @employee.survey_test_mode
    end

    describe 'survey test mode: easy mode on' do
      setup do
        @test_mode.update!(easy_test: true)
        @employee.reload
      end

      test 'returns true' do
        assert @employee.test_mode_on?
      end
    end

    describe 'survey test mode: easy mode off' do
      setup do
        @test_mode.update!(easy_test: false)
        @employee.reload
      end

      test 'returns false' do
        assert_not @employee.test_mode_on?
      end
    end

    describe 'survey test mode: none present' do
      setup do
        @employee.survey_test_mode.destroy!
        @employee.reload
        assert_nil @employee.survey_test_mode
      end

      test 'returns false' do
        assert_not @employee.test_mode_on?
      end
    end
  end
end
