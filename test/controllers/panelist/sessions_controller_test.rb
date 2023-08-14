# frozen_string_literal: true

require 'test_helper'

class Panelist::SessionsControllerTest < ActionDispatch::IntegrationTest
  describe '#create' do
    setup do
      @panelist = Panelist.create(
        email: Faker::Internet.email,
        password: 'testpass',
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        country: Country.find_by(slug: 'us'),
        original_panel: Panel.find_by(slug: 'op4g-us'),
        primary_panel: Panel.find_by(slug: 'op4g-us'),
        address: Faker::Address.street_name,
        city: Faker::Address.city,
        state: Faker::Address.state_abbr,
        postal_code: Faker::Address.zip.first(5),
        birthdate: Time.zone.today - 35.years - 10.days,
        status: Panelist.statuses[:active],
        clean_id_data: { data: 'blank' },
        confirmed_at: 3.hours.ago,
        agreed_to_terms_at: 2.hours.ago,
        welcomed_at: 1.hour.ago
      )
    end

    describe 'panelist who was deactivated recently' do
      setup do
        @panelist.update!(
          status: 'deactivated',
          deactivated_at: Time.now.utc - 3.months,
          last_activity_at: Time.now.utc - 6.months
        )
      end

      it 'will reset some columns if a deactivated panelist logs in within a year' do
        post panelist_session_url, params: { panelist: { email: @panelist.email, password: @panelist.password } }

        @panelist.reload

        assert_equal @panelist.status, 'active'
        assert_nil @panelist.deactivated_at
        assert_not_nil @panelist.last_activity_at
      end

      describe 'panelist was added to the deactivation (danger) list' do
        setup do
          Panelist.any_instance.expects(:on_danger_list?).returns(true).once
        end

        test 'triggers job to remove from MadMimi deactivation list' do
          MadMimiRemoveFromDangerListJob.expects(:perform_later).once

          post panelist_session_url, params: { panelist: { email: @panelist.email, password: @panelist.password } }
        end
      end
    end

    describe 'panelist who was deactivated a long time ago' do
      setup do
        @panelist.update!(
          status: 'deactivated',
          deactivated_at: Time.now.utc - 3.months,
          last_activity_at: Time.now.utc - 13.months
        )
      end

      it 'will retain the previous status data' do
        assert_no_changes ['@panelist.status', '@panelist.deactivated_at', '@panelist.last_activity_at'] do
          post panelist_session_url, params: { panelist: { email: @panelist.email, password: @panelist.password } }
        end
      end
    end
  end
end
