# frozen_string_literal: true

require 'test_helper'

class PanelistStatusTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  describe '#inactive?' do
    subject { panelists(:active) }

    it 'depends on the value of welcomed_at' do
      assert_not_nil subject.welcomed_at
      assert_not subject.inactive?

      subject.update!(welcomed_at: nil, status: Panelist.statuses[:signing_up])

      assert subject.inactive?
    end

    it 'depends on the value of suspended_at' do
      assert_nil subject.suspended_at
      assert_not subject.inactive?

      subject.update!(suspended_at: Time.now.utc, status: Panelist.statuses[:suspended])

      assert subject.inactive?
    end

    it 'depends on the value of deleted_at' do
      assert_nil subject.deleted_at
      assert_not subject.inactive?

      subject.update!(deleted_at: Time.now.utc, status: Panelist.statuses[:deleted])

      assert subject.inactive?
    end
  end

  describe '#soft_delete!' do
    setup do
      @panelist = panelists(:active)
      @another_panelist = panelists(:standard)
    end

    it 'deactivates the record' do
      assert_not @panelist.inactive?

      @panelist.soft_delete!

      assert @panelist.inactive?
    end

    it 'removes personal attributes' do
      @panelist.update(password: 'bigkahuna')
      assert_not @panelist.encrypted_password.blank?
      assert_not @panelist.email.nil?

      @panelist.update!(
        first_name: 'First',
        last_name: 'Last',
        postal_code: '12345',
        country: Country.find_by(slug: 'us'),
        locale: 'en',
        address: '123 Main St',
        address_line_two: 'Apartment ABC',
        city: 'Somewhere',
        state: 'TX',
        zip_code: ZipCode.first,
        age: 18,
        update_age_at: Time.now.utc,
        birthdate: Time.now.utc - 18.years,
        search_terms: 'search terms',
        campaign: recruiting_campaigns(:standard),
        email: 'test@email.com',
        legacy_earnings_cents: 1000
      )

      @panelist.soft_delete!

      assert @panelist.email.start_with?('deleted: ')
      assert @panelist.first_name.blank?
      assert @panelist.last_name.blank?
      assert @panelist.postal_code.nil?
      assert @panelist.country.nil?
      assert @panelist.encrypted_password.blank?
      assert_equal @panelist.locale, 'deleted'
      assert @panelist.address.nil?
      assert @panelist.address_line_two.nil?
      assert @panelist.city.nil?
      assert @panelist.state.nil?
      assert @panelist.zip_code_id.nil?
      assert @panelist.age.nil?
      assert @panelist.update_age_at.nil?
      assert @panelist.birthdate.nil?
      assert @panelist.search_terms.nil?
      assert @panelist.legacy_earnings_cents.zero?
    end

    it 'removes demo answers' do
      @answers = []
      3.times do
        @answers << DemoOption.create(
          demo_question: demo_questions(:standard),
          label: 'test-label'
        )
      end
      @answers.each { |answer| @panelist.add_answer(answer) }

      assert_not_empty @panelist.answers

      @panelist.soft_delete!

      assert_empty @panelist.answers
    end

    it "doesn't violate any unique keys" do
      @panelist.soft_delete!
      # Spacing the requests out due to weird testing issue with time not changing.
      travel_to Time.now.utc + 1.second
      @another_panelist.soft_delete!
    end
  end

  describe 'panelist deactivation' do
    it 'deactivates old panelists with at least 5 invitations' do
      @old_panelist = create_panelist
      5.times do
        survey = Survey.create(
          project: Project.create(
            name: Faker::Company.name,
            manager: Employee.create(
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              email: Faker::Internet.email,
              password: Faker::Internet.password
            )
          ),
          name: Faker::Company.name,
          category: 'standard'
        )
        demo_query = demo_queries(:standard)
        batch = SampleBatch.create(query: demo_query, count: 10, incentive_cents: 100, email_subject: 'Test')
        ProjectInvitation.create!(panelist_id: @old_panelist.id, sent_at: Time.now.utc, project_id: survey.project.id,
                                  survey_id: survey.id, sample_batch_id: batch.id)
      end
      @old_panelist.update!(last_activity_at: Time.now.utc - 7.months)
      @old_panelist.update!(status: Panelist.statuses[:active])

      assert_difference('Panelist.where.not(deactivated_at: nil).count') do
        Panelist.deactivate_stale_panelists
      end

      @old_panelist.reload
      assert @old_panelist.deactivated?
    end

    it 'deactivates old and inactive panelists who didn\'t complete signup' do
      @old_panelist = create_panelist
      @old_panelist.update!(
        last_activity_at: Time.now.utc - 7.months,
        status: Panelist.statuses[:signing_up]
      )

      assert @old_panelist.signing_up?
      assert_difference('Panelist.where.not(deactivated_at: nil).count') do
        Panelist.deactivate_stale_panelists
      end

      @old_panelist.reload
      assert @old_panelist.deactivated_signup?
    end

    it 'does not deactivate old panelist with less than 5 invitations' do
      @old_panelist = create_panelist
      @old_panelist.update!(last_activity_at: Time.now.utc - 7.months, status: Panelist.statuses[:active])

      assert_no_difference('Panelist.where.not(deactivated_at: nil).count') do
        Panelist.deactivate_stale_panelists
      end
    end

    it 'does not deactivate old panelist inactive less than limit' do
      @old_panelist = create_panelist
      @old_panelist.update!(last_activity_at: Time.now.utc - 5.months)

      assert_no_difference('Panelist.where.not(deactivated_at: nil).count') do
        Panelist.deactivate_stale_panelists
      end
    end

    it 'does not deactivate recently active panelists' do
      @fresh_panelist = panelists(:standard)
      @fresh_panelist.update!(last_activity_at: Time.now.utc - 1.month)

      assert_no_difference('Panelist.where.not(deactivated_at: nil).count') do
        Panelist.deactivate_stale_panelists
      end
    end

    it 'handles no stale panelists without erroring' do
      ProjectInvitation.delete_all
      Panelist.destroy_all
      assert Panelist.count.zero?
      Panelist.deactivate_stale_panelists
    end
  end

  describe '#block_ips' do
    it 'blocks ips' do
      panelist = panelists(:standard)
      ip_address = ip_addresses(:standard)
      PanelistIpHistory.create!(panelist_id: panelist.id, ip_address_id: ip_address.id, source: 'survey')

      assert_equal 'allowed', ip_address.status

      panelist.block_ips('testing block_ips')
      ip_address.reload
      assert_equal 'flagged', ip_address.status
    end
  end

  describe '#unsuspend' do
    setup do
      @panelist = panelists(:standard)
    end
    it 'unsuspends' do
      @panelist.suspend
      assert_not_nil @panelist.suspended_at

      @panelist.unsuspend
      assert_nil @panelist.suspended_at
    end
  end

  describe '#unblock_ips' do
    it 'unblocks ips' do
      panelist = panelists(:standard)
      ip_address = ip_addresses(:standard)
      PanelistIpHistory.create!(panelist_id: panelist.id, ip_address_id: ip_address.id, source: 'survey')

      panelist.block_ips('testing block_ips')
      ip_address.reload
      assert_equal 'flagged', ip_address.status

      panelist.unblock_ips
      ip_address.reload
      assert_equal 'allowed', ip_address.status
    end
  end

  describe '#record_activity' do
    it 'doesn\'t call the MadMimiRemoveFromDangerListJob if the panelist isn\'t in danger' do
      @deactivated_panelist = panelists(:standard)
      @deactivated_panelist.update(last_activity_at: Time.now.utc - 3.months)

      @deactivated_panelist.record_activity

      assert_enqueued_jobs 0
    end

    it 'calls the MadMimiRemoveFromDangerListJob once and wipes the in_danger_at field if the panelist is in danger' do
      @panelist = panelists(:standard)
      @panelist.update(last_activity_at: Time.now.utc - 3.months, in_danger_at: Time.now.utc - 1.month)

      assert_enqueued_with(job: MadMimiRemoveFromDangerListJob) do
        @panelist.record_activity
      end
    end
  end
end

private

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize
def create_panelist
  Panelist.create(
    email: Faker::Internet.email,
    password: 'testing123',
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
    status: Panelist.statuses[:signing_up],
    clean_id_data: { data: 'blank' }
  )
end
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize
