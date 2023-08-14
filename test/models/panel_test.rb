# frozen_string_literal: true

require 'test_helper'

class PanelTest < ActiveSupport::TestCase
  describe 'fixture' do
    it 'is valid' do
      panel = panels(:standard)
      panel.valid?
      assert_empty panel.errors
    end
  end

  describe 'validations' do
    setup do
      @panel = panels(:standard)
    end

    test 'name is required' do
      @panel.update(name: nil)
      assert_not @panel.valid?
    end

    test 'slug is required' do
      @panel.update(slug: nil)
      assert_not @panel.valid?
    end
  end

  describe 'instance methods' do
    setup do
      @panel = panels(:random)
    end

    describe '#recent_project_count' do
      describe 'count projects that have used the panel in the last 6 months' do
        it 'should increase the count' do
          assert_difference -> { @panel.recent_project_count } do
            DemoQuery.create(
              panel: @panel,
              survey: surveys(:standard)
            )
          end
        end

        it 'should not increase the count' do
          assert_no_difference -> { @panel.recent_project_count } do
            DemoQuery.create(
              panel: @panel,
              survey: surveys(:standard),
              created_at: Time.now.utc - 7.months
            )
          end
        end
      end
    end
  end

  describe 'panelist scope helpers' do
    before(:all) do
      @panel = panels(:random)
      @one_day_ago = Time.now.utc - 1.day
      @two_days_ago = Time.now.utc - 2.days
      @three_days_ago = Time.now.utc - 3.days
    end

    it 'returns the in progress signups correctly' do
      assert_difference -> { @panel.in_progress_signups.count } do
        @panel.panelists << create_panelist(
          status: Panelist.statuses[:signing_up],
          created_at: @one_day_ago,
          welcomed_at: nil
        )
      end
    end

    it 'returns the dead signups correctly' do
      assert_difference -> { @panel.dead_signups.count } do
        @panel.panelists << create_panelist(
          status: Panelist.statuses[:signing_up],
          created_at: @three_days_ago,
          welcomed_at: nil
        )
      end
    end

    it 'returns the new accounts correctly' do
      assert_difference -> { @panel.new_accounts.count } do
        @panel.panelists << create_panelist(
          status: Panelist.statuses[:active],
          welcomed_at: @one_day_ago
        )
      end
    end

    it 'returns the suspended accounts correctly' do
      assert_difference -> { @panel.suspended_accounts.count } do
        @panel.panelists << create_panelist(
          status: Panelist.statuses[:suspended],
          suspended_at: @one_day_ago
        )
      end
    end

    it 'returns the deleted accounts correctly' do
      assert_difference -> { @panel.deleted_accounts.count } do
        @panel.panelists << create_panelist(
          status: Panelist.statuses[:deleted],
          deleted_at: @one_day_ago
        )
      end
    end
  end
end

private

# rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
def create_panelist(attributes = {})
  attributes[:email] ||= Faker::Internet.email
  attributes[:password] ||= 'testing123'
  attributes[:first_name] ||= Faker::Name.first_name
  attributes[:last_name] ||= Faker::Name.last_name
  attributes[:country] ||= Country.find_by(slug: 'us')
  attributes[:original_panel] ||= Panel.find_by(slug: 'op4g-us')
  attributes[:primary_panel] ||= Panel.find_by(slug: 'op4g-us')
  attributes[:address] ||= Faker::Address.street_name
  attributes[:city] ||= Faker::Address.city
  attributes[:state] ||= Faker::Address.state_abbr
  attributes[:postal_code] ||= Faker::Address.zip.first(5)
  attributes[:birthdate] ||= Time.zone.today - 35.years - 10.days
  attributes[:clean_id_data] ||= { data: 'blank' }
  attributes[:status] ||= Panelist.statuses[:active]
  attributes[:created_at] ||= nil
  attributes[:welcomed_at] ||= nil
  attributes[:suspended_at] ||= nil
  attributes[:deleted_at] ||= nil

  Panelist.create(attributes)
end
# rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
