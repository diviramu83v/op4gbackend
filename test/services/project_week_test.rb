# frozen_string_literal: true

require 'test_helper'

class ProjectWeekTest < ActiveSupport::TestCase
  setup do
    @starting = 7.days.ago
    @ending = Time.now.utc

    @project_week = ProjectWeek.new(starting: @starting, ending: @ending)
  end

  test '#code' do
    assert_equal @starting.strftime('%Gwk%V'), @project_week.code
  end

  test '#clean_id_errors' do
    check = traffic_checks(:pre_show)
    check.update!(created_at: 3.days.ago)

    check.update!(data_collected: { 'error' => {} })
    assert_equal @project_week.clean_id_errors, [check]

    check.update!(data_collected: '{"error":{"message":"bad data"}}')
    assert_equal @project_week.clean_id_errors, [check]

    check.update!(data_collected: { 'forensic' => {} })
    assert_equal @project_week.clean_id_errors, []

    check.update!(data_collected: nil)
    assert_equal @project_week.clean_id_errors, []
  end

  test '.most_recent' do
    week_one = ProjectWeek.new(starting: Time.now.utc.beginning_of_week - 2.weeks, ending: Time.now.utc.end_of_week - 2.weeks)
    week_two = ProjectWeek.new(starting: Time.now.utc.beginning_of_week - 1.week, ending: Time.now.utc.end_of_week - 1.week)

    batch = ProjectWeek.most_recent(2)

    assert_equal week_one.starting, batch.first.starting
    assert_equal week_one.ending, batch.first.ending
    assert_equal week_two.starting, batch.last.starting
    assert_equal week_two.ending, batch.last.ending
  end

  test 'TrafficCalculations concern' do
    assert_equal 3, @project_week.started_count
  end

  test 'TrafficCalculations concern: batch vendor' do
    vendor = vendors(:batch)
    vendor_batch = vendor_batches(:standard)
    onramp = onramps(:testing)

    onramp.update!(category: 'vendor', vendor_batch: vendor_batch)
    @project_week = ProjectWeek.new(starting: @starting, ending: @ending, source: vendor)

    assert_equal 3, @project_week.started_count
  end

  test 'TrafficCalculations concern: api vendor' do
    vendor = vendors(:api)
    onramp = onramps(:testing)

    onramp.update!(category: 'api', api_vendor: vendor)
    @project_week = ProjectWeek.new(starting: @starting, ending: @ending, source: vendors(:api))

    assert_equal 3, @project_week.started_count
  end

  test 'TrafficCalculations concern: panel' do
    onboarding = onboardings(:standard)
    panel = panels(:standard)

    onboarding.update!(panel: panel)
    @project_week = ProjectWeek.new(starting: @starting, ending: @ending, source: panel)

    assert_equal 1, @project_week.started_count
  end
end
