# frozen_string_literal: true

require 'test_helper'

class SystemEventTest < ActiveSupport::TestCase
  describe 'fabricator' do
    setup do
      @event = system_events(:standard)
      @event.update(
        description:
          SystemEvent.format_description(
            url: 'https://google.com',
            subdomain: 'subdomain',
            controller: 'controller',
            action: 'action'
          )
      )
    end

    it 'is valid' do
      assert @event.valid?
    end

    it 'creates a test description' do
      assert_equal "URL: https://google.com\nAction: subdomain.controller#action\n", @event.description
    end
  end

  describe '.format_description' do
    test 'format with all parameters' do
      text = SystemEvent.format_description(
        url: 'url',
        subdomain: 'subdomain',
        controller: 'controller',
        action: 'action'
      )
      assert_equal "URL: url\nAction: subdomain.controller#action\n", text
    end

    test 'format without subdomain' do
      text = SystemEvent.format_description(
        url: 'url',
        subdomain: nil,
        controller: 'controller',
        action: 'action'
      )
      assert_equal "URL: url\nAction: .controller#action\n", text
    end
  end

  describe '.summarize_and_delete_old_data' do
    setup do
      @yesterday = Time.now.utc - 1.day
      @today = Time.now.utc
      @tomorrow = Time.now.utc + 1.day

      alternate_action = "URL: url2\nAction: action2\n"

      SystemEventSummary.delete_all
      SystemEvent.delete_all

      times = [
        @yesterday.beginning_of_day,
        @yesterday,
        @yesterday.end_of_day,
        @today.beginning_of_day,
        @today,
        @today.end_of_day,
        @tomorrow.end_of_day
      ]

      alternate_action_times = [
        @yesterday,
        @yesterday,
        @today,
        @tomorrow.beginning_of_day,
        @tomorrow
      ]

      times.each do |time|
        SystemEvent.create(
          description:
            SystemEvent.format_description(
              url: 'https://google.com',
              subdomain: 'subdomain',
              controller: 'controller',
              action: 'action'
            ),
          happened_at: time
        )
      end

      alternate_action_times.each do |time|
        SystemEvent.create(description: alternate_action, happened_at: time)
      end
    end

    it 'creates summary records' do
      SystemEvent.summarize_and_delete_old_data(before_day: Time.now.utc)
      rows = SystemEventSummary.all.order(:id)
      assert_equal 2, rows.count

      SystemEvent.summarize_and_delete_old_data(before_day: Time.now.utc + 1.day)
      rows = SystemEventSummary.all.order(:id)
      assert_equal 4, rows.count

      SystemEvent.summarize_and_delete_old_data(before_day: Time.now.utc + 2.days)
      rows = SystemEventSummary.all.order(:id)
      assert_equal 6, rows.count

      assert_equal rows[0].day_happened_at, @yesterday.strftime('%Y-%m-%d 00:00:00')
      assert_equal rows[0].action, 'action2'
      assert_equal rows[0].count, 2

      assert_equal rows[1].day_happened_at, @yesterday.strftime('%Y-%m-%d 00:00:00')
      assert_equal rows[1].action, 'subdomain.controller#action'
      assert_equal rows[1].count, 3

      assert_equal rows[2].day_happened_at, @today.strftime('%Y-%m-%d 00:00:00')
      assert_equal rows[2].action, 'action2'
      assert_equal rows[2].count, 1

      assert_equal rows[3].day_happened_at, @today.strftime('%Y-%m-%d 00:00:00')
      assert_equal rows[3].action, 'subdomain.controller#action'
      assert_equal rows[3].count, 3

      assert_equal rows[4].day_happened_at, @tomorrow.strftime('%Y-%m-%d 00:00:00')
      assert_equal rows[4].action, 'action2'
      assert_equal rows[4].count, 2

      assert_equal rows[5].day_happened_at, @tomorrow.strftime('%Y-%m-%d 00:00:00')
      assert_equal rows[5].action, 'subdomain.controller#action'
      assert_equal rows[5].count, 1
    end

    it 'deletes old data' do
      assert_difference -> { SystemEvent.count }, -5 do
        SystemEvent.summarize_and_delete_old_data(before_day: Time.now.utc)
      end

      assert_difference -> { SystemEvent.count }, -4 do
        SystemEvent.summarize_and_delete_old_data(before_day: Time.now.utc + 1.day)
      end

      assert_difference -> { SystemEvent.count }, -3 do
        SystemEvent.summarize_and_delete_old_data(before_day: Time.now.utc + 2.days)
      end

      assert_equal 0, SystemEvent.count
    end

    it 'alerts of failed summary imports' do
      import_return_mock = Minitest::Mock.new
      import_return_mock.expect :failed_instances, [SystemEvent.first]
      SystemEventSummary.stubs(:import).returns(import_return_mock)

      SystemEvent.summarize_and_delete_old_data(before_day: Time.now.utc + 2.days)
    end
  end
end
