# frozen_string_literal: true

require 'test_helper'

class PanelistTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  describe 'fixture' do
    it 'is valid' do
      panelist = panelists(:standard)
      panelist.valid?
      assert_empty panelist.errors
    end
  end

  describe 'validations' do
    subject { panelists(:standard) }

    should belong_to(:primary_panel)

    it 'throws the correct validation errors' do
      panelist = Panelist.new
      panelist.save

      assert_not panelist.valid?
      assert panelist.errors.full_messages.include?('Primary panel must exist')
    end
  end

  describe 'scopes' do
    it 'should properly filter the panelist records' do
      one_day_ago = Time.now.utc - 1.day
      two_days_ago = Time.now.utc - 2.days
      three_days_ago = Time.now.utc - 3.days

      assert_difference -> { Panelist.count } do
        create_panelist(status: Panelist.statuses[:signing_up])
      end

      assert_difference -> { Panelist.signing_up.count } do
        create_panelist(
          status: Panelist.statuses[:signing_up],
          created_at: one_day_ago
        )
      end

      assert_difference -> { Panelist.in_progress_signups.count } do
        create_panelist(
          status: Panelist.statuses[:signing_up],
          created_at: one_day_ago
        )
      end
      assert_no_difference -> { Panelist.in_progress_signups.count }, 2 do
        create_panelist(
          status: Panelist.statuses[:signing_up],
          created_at: two_days_ago
        )
        create_panelist(
          status: Panelist.statuses[:signing_up],
          created_at: three_days_ago
        )
      end

      assert_no_difference -> { Panelist.dead_signups.count } do
        create_panelist(
          status: Panelist.statuses[:signing_up],
          created_at: one_day_ago
        )
      end
      assert_difference -> { Panelist.dead_signups.count }, 2 do
        create_panelist(
          status: Panelist.statuses[:signing_up],
          created_at: two_days_ago
        )
        create_panelist(
          status: Panelist.statuses[:signing_up],
          created_at: three_days_ago
        )
      end

      assert_difference -> { Panelist.active.count } do
        create_panelist(welcomed_at: one_day_ago)
      end

      assert_difference -> { Panelist.new_accounts.count } do
        create_panelist(welcomed_at: one_day_ago)
      end
      assert_no_difference -> { Panelist.new_accounts.count }, 2 do
        create_panelist(
          status: Panelist.statuses[:signing_up],
          welcomed_at: two_days_ago
        )
        create_panelist(
          status: Panelist.statuses[:signing_up],
          welcomed_at: three_days_ago
        )
      end

      assert_difference -> { Panelist.suspended.count } do
        create_panelist(
          status: Panelist.statuses[:suspended],
          suspended_at: one_day_ago
        )
      end

      assert_difference -> { Panelist.deleted.count } do
        create_panelist(
          status: Panelist.statuses[:deleted],
          deleted_at: one_day_ago
        )
      end

      assert_difference -> { Panelist.in_danger_of_deactivation.count } do
        create_panelist(last_activity_at: Time.now.utc - 6.months)
      end
    end
  end

  describe 'country_sym' do
    it 'is :us when panelist country is nil' do
      panelist = panelists(:standard)
      panelist.update(country: nil)
      assert_equal :us, panelist.country_sym
    end

    it 'is :us when panelist country is US' do
      panelist = panelists(:standard)
      assert_equal :us, panelist.country_sym
    end

    it 'is :foo when panelist country slug is foo' do
      country = Country.create(name: 'Foo', slug: 'foo')
      panelist = panelists(:standard)
      panelist.update(country: country)
      assert_equal :foo, panelist.country_sym
    end
  end

  describe '#create_email_reminders' do
    setup do
      @panelist = create_panelist(status: Panelist.statuses[:signing_up])
    end

    it 'should create and email reminder for 48 and 72 hours' do
      assert_equal 2, @panelist.email_confirmation_reminders.waiting.count
      assert_equal (Time.now.utc + 48.hours).beginning_of_day,
                   @panelist.email_confirmation_reminders.waiting.first.send_at.beginning_of_day
      assert_equal (Time.now.utc + 72.hours).beginning_of_day,
                   @panelist.email_confirmation_reminders.waiting.last.send_at.beginning_of_day
    end
  end

  describe '#mark_email_reminders_as_ignored' do
    setup do
      @panelist = create_panelist(status: Panelist.statuses[:signing_up])
    end

    it 'should mark the email reminders as ignored once the email is confirmed' do
      assert_difference -> { @panelist.email_confirmation_reminders.ignored.count }, 2 do
        @panelist.update!(confirmed_at: Time.now.utc)
      end
    end
  end

  describe '#create_affiliate_record' do
    it 'should not create an affiliate record' do
      assert_no_difference -> { Affiliate.count } do
        create_panelist(
          status: Panelist.statuses[:signing_up],
          affiliate_code: nil
        )
      end
    end

    it 'should create an affiliate record for a new affiliate code' do
      Affiliate.any_instance.stubs(:start_query_affiliate_name_job).returns(true)
      assert_difference -> { Affiliate.count } do
        create_panelist(
          status: Panelist.statuses[:signing_up],
          affiliate_code: '1234'
        )
      end
    end

    it 'should not create an affiliate record for an existing affiliate code' do
      create_panelist(
        status: Panelist.statuses[:signing_up],
        affiliate_code: '1234'
      )
      assert_no_difference -> { Affiliate.count } do
        create_panelist(
          status: Panelist.statuses[:signing_up],
          affiliate_code: '123'
        )
      end
    end
  end

  describe '#create_offer_record' do
    it 'should not create an offer record if there is no offer code' do
      assert_no_difference -> { Offer.count } do
        create_panelist(
          status: Panelist.statuses[:signing_up],
          offer_code: nil
        )
      end
    end

    it 'should create an offer record for a new offer code' do
      Offer.any_instance.stubs(:start_query_offer_name_job).returns(true)
      assert_difference -> { Offer.count } do
        create_panelist(
          status: Panelist.statuses[:signing_up],
          offer_code: '123'
        )
      end
    end

    it 'should not create an offer record for an existing offer code' do
      Offer.any_instance.stubs(:start_query_offer_name_job).returns(true)
      create_panelist(
        status: Panelist.statuses[:signing_up],
        offer_code: '123'
      )
      assert_no_difference -> { Offer.count } do
        create_panelist(
          status: Panelist.statuses[:signing_up],
          offer_code: '123'
        )
      end
    end
  end

  describe '#create_status_event' do
    it 'should create a new status event for a status change' do
      assert_difference -> { PanelistStatusEvent.count } do
        Panelist.first.update!(status: 'suspended')
      end
    end

    it 'should not create a new status event for an update that does not change the status' do
      Panelist.first.update!(status: 'active')
      assert_no_difference -> { PanelistStatusEvent.count } do
        Panelist.first.update!(status: 'active')
      end
    end

    it 'should create a new status event for a new panelist' do
      assert_difference -> { PanelistStatusEvent.count } do
        create_panelist(status: Panelist.statuses[:signing_up])
      end
    end
  end

  describe '#age_needs_updating?' do
    setup do
      @panelist = panelists(:standard)
    end

    test 'no birthdate' do
      @panelist.update!(birthdate: nil)
      assert_not @panelist.age_needs_updating?
    end

    test 'birthdate with no age' do
      @panelist.update_column('age', nil)
      @panelist.update_column('birthdate', 20.years.ago)
      assert @panelist.age_needs_updating?
    end

    test 'passed update date' do
      @panelist.update_column('update_age_at', 1.day.ago)
      assert @panelist.age_needs_updating?
    end
  end

  it '#calculate_age: middle of the year' do
    @date = Date.new(Time.zone.now.year, 7, 1)
    @panelist = panelists(:standard)
    @panelist.birthdate = @date - 30.years

    travel_to @date - 3.months
    @panelist.calculate_age
    @panelist.reload
    assert_equal @panelist.age, 29
    assert_equal @panelist.update_age_at, @date

    travel_to @date + 3.months
    @panelist.calculate_age
    @panelist.reload
    assert_equal @panelist.age, 30
    assert_equal @panelist.update_age_at, @date + 1.year
  end

  it '#calculate_age: beginning of the year' do
    @date = Date.new(Time.zone.now.year, 1, 1)
    @panelist = panelists(:standard)
    @panelist.birthdate = @date - 30.years

    travel_to @date - 3.months
    @panelist.calculate_age
    @panelist.reload
    assert_equal @panelist.age, 29
    assert_equal @panelist.update_age_at, @date

    travel_to @date + 3.months
    @panelist.calculate_age
    @panelist.reload
    assert_equal @panelist.age, 30
    assert_equal @panelist.update_age_at, @date + 1.year
  end

  it '#calculate_age: end of the year' do
    @date = Date.new(Time.zone.now.year, 7, 1)
    @panelist = panelists(:standard)
    @panelist.birthdate = @date - 30.years

    travel_to @date - 3.months
    @panelist.calculate_age
    @panelist.reload
    assert_equal @panelist.age, 29
    assert_equal @panelist.update_age_at, @date

    travel_to @date + 3.months
    @panelist.calculate_age
    @panelist.reload
    assert_equal @panelist.age, 30
    assert_equal @panelist.update_age_at, @date + 1.year
  end

  it '#calculate_age: leap day' do
    @panelist = panelists(:active)
    5.times do
      ProjectInvitation.create(panelist: @panelist)
    end

    @panelist.birthdate = Date.new(1976, 2, 29)
    @date = @panelist.birthdate + 30.years

    travel_to @date - 3.months
    @panelist.calculate_age
    @panelist.reload
    assert_equal @panelist.age, 29
    assert_equal @panelist.update_age_at, @date

    travel_to @date + 3.months
    @panelist.calculate_age
    @panelist.reload
    assert_equal @panelist.age, 30
    assert_equal @panelist.update_age_at, @date + 1.year
  end

  it '#calculate_age: birthdate is more than 105 years ago' do
    @panelist = panelists(:active)
    3.times do
      ProjectInvitation.create(panelist: @panelist)
    end

    @panelist.birthdate = Date.new(1913, 1, 11)

    @panelist.calculate_age
    @panelist.reload
    assert @panelist.deactivated?
  end

  describe 'current_ip_blocked?' do
    setup do
      @ip = ip_addresses(:standard)
      @manual_ip_block = ip_addresses(:second)
      @auto_ip_block = ip_addresses(:third)

      @manual_ip_block.update(
        blocked_at: Faker::Date.backward(days: 90),
        status: 'blocked',
        category: 'deny-manual'
      )

      @auto_ip_block.update(
        blocked_at: Faker::Date.backward(days: 90),
        status: 'blocked',
        category: 'deny-auto'
      )
    end

    it 'reports that a panelist is blocked if the current ip has a manual block' do
      @panelist = panelists(:standard)
      @panelist.update!(current_sign_in_ip: @manual_ip_block.address)
      assert_equal @panelist.current_ip_blocked?, true
    end

    it 'reports that a panelist is blocked if the current ip has an automatic block' do
      @panelist = panelists(:standard)
      @panelist.update!(current_sign_in_ip: @auto_ip_block.address)
      assert_equal @panelist.current_ip_blocked?, true
    end

    it 'reports that a panelist is not blocked if the current ip has no block' do
      @panelist = panelists(:standard)
      @panelist.update!(current_sign_in_ip: @ip.address)
      assert_equal @panelist.current_ip_blocked?, false
    end
  end

  describe 'private: add_zip_code' do
    setup do
      @zip = zip_codes(:standard)
    end

    describe 'with matching postal code' do
      it 'assigns a zip code record' do
        @panelist = panelists(:standard)
        @panelist.update!(postal_code: '11111')
        assert_equal @zip, @panelist.zip_code
      end
    end

    describe 'with non-matching postal code' do
      it 'raises an error about an invalid postal code for domestic panelists' do
        assert_raises ActiveRecord::RecordInvalid do
          Panelist.create!(
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
            postal_code: 'no match',
            birthdate: Time.zone.today - 35.years - 10.days,
            status: Panelist.statuses[:signing_up],
            clean_id_data: { data: 'blank' }
          )
        end
      end
    end

    describe 'with no postal code' do
      it 'does not assign a zip code' do
        assert_raises ActiveRecord::RecordInvalid do
          @panelist = Panelist.create!(
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
            postal_code: nil,
            birthdate: Time.zone.today - 35.years - 10.days,
            status: Panelist.statuses[:signing_up],
            clean_id_data: { data: 'blank' }
          )
        end
      end
    end

    describe 'with a zip code longer than 5 digits' do
      it 'raises an error about length for domestic panelists' do
        assert_raises ActiveRecord::RecordInvalid do
          create_panelist(
            status: Panelist.statuses[:signing_up],
            postal_code: '12345-6789'
          )
        end
      end
    end
  end

  describe 'panelist deactivation' do
    it 'deactivates old panelists with at least 5 invitations' do
      @old_panelist = panelists(:standard)
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
      @old_panelist = create_panelist(
        status: Panelist.statuses[:signing_up],
        last_activity_at: Time.now.utc - 7.months
      )

      assert @old_panelist.signing_up?
      assert_difference('Panelist.where.not(deactivated_at: nil).count') do
        Panelist.deactivate_stale_panelists
      end

      @old_panelist.reload
      assert @old_panelist.deactivated_signup?
    end

    it 'does not deactivate old panelist with less than 5 invitations' do
      @old_panelist = panelists(:standard)
      @old_panelist.update!(last_activity_at: Time.now.utc - 7.months, status: Panelist.statuses[:active])

      assert_no_difference('Panelist.where.not(deactivated_at: nil).count') do
        Panelist.deactivate_stale_panelists
      end
    end

    it 'does not deactivate old panelist inactive less than limit' do
      @old_panelist = panelists(:standard)
      @old_panelist.update!(last_activity_at: Time.now.utc - 5.months)

      assert_no_difference('Panelist.where.not(deactivated_at: nil).count') do
        Panelist.deactivate_stale_panelists
      end
    end

    it 'does not deactivate recently active panelists' do
      @fresh_panelist = create_panelist(
        status: Panelist.statuses[:signing_up],
        last_activity_at: Time.now.utc - 1.month
      )

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

  describe '#record_activity' do
    it 'doesn\'t call the MadMimiRemoveFromDangerListJob if the panelist isn\'t in danger' do
      @deactivated_panelist = create_panelist(
        status: Panelist.statuses[:active],
        last_activity_at: Time.now.utc - 3.months
      )

      @deactivated_panelist.record_activity

      assert_enqueued_jobs 0
    end

    it 'removes the panelist from the Mad Mimi danger list' do
      @panelist = create_panelist(
        status: Panelist.statuses[:active],
        last_activity_at: Time.now.utc - 3.months,
        in_danger_at: Time.now.utc - 1.month
      )
      MadMimiRemoveFromDangerListJob.expects(:perform_later).once

      @panelist.record_activity
    end
  end

  describe '#add_to_signup_list' do
    setup do
      @panelist = panelists(:active)
      stub_request(:post, 'https://us20.api.mailchimp.com/3.0/lists/f82c33674d/members').to_return(status: 200)
      stub_request(:post, 'https://us20.api.mailchimp.com/3.0/lists/f82c33674d/members/cfae9e425586b6b46661179617da39cb/tags').to_return(status: 200)
    end

    test 'happy path' do
      MadMimiSignupList.any_instance.expects(:add).once
      @panelist.add_to_signup_list
    end
  end

  describe '#add_to_danger_list' do
    setup do
      @panelist = panelists(:active)
      stub_request(:post, 'https://us20.api.mailchimp.com/3.0/lists/f82c33674d/members/cfae9e425586b6b46661179617da39cb/tags').to_return(status: 200)
    end

    test 'happy path' do
      assert_nil @panelist.in_danger_at
      MadMimiDangerList.any_instance.expects(:add).once
      @panelist.add_to_danger_list
      assert_not_nil @panelist.in_danger_at
    end
  end

  describe '#remove_from_danger_list' do
    setup do
      @panelist = panelists(:active)
      MadMimiDangerList.any_instance.expects(:add).once
      stub_request(:post, 'https://us20.api.mailchimp.com/3.0/lists/f82c33674d/members/cfae9e425586b6b46661179617da39cb/tags').to_return(status: 200)
      @panelist.add_to_danger_list
    end

    test 'happy path' do
      assert_not_nil @panelist.in_danger_at
      MadMimiDangerList.any_instance.expects(:remove).once
      @panelist.remove_from_danger_list
      assert_nil @panelist.in_danger_at
    end
  end

  describe '.process_endangered_panelists' do
    setup do
      @panelist = create_panelist(
        status: Panelist.statuses[:active],
        last_activity_at: Time.now.utc - 6.months
      )
    end

    test 'creates a job for each panelist' do
      MadMimiAddToDangerListJob.expects(:perform_later).once
      Panelist.process_endangered_panelists
    end
  end

  describe '#balance_through_last_month' do
    setup do
      @panelist = panelists(:standard)
      @this_month = Time.now.utc.strftime('%Y-%m')
      @last_month = (Time.now.utc - 1.month).strftime('%Y-%m')
      @earning = earnings(:one)
    end

    it 'should include earnings from last month' do
      @panelist = panelists(:active)
      assert_changes -> { @panelist.balance_through_last_month } do
        @earning.update(panelist: @panelist, period: @last_month, period_year: @this_year.to_s)
      end
    end

    it 'should not include earnings from this month' do
      assert_no_changes -> { @panelist.balance_through_last_month } do
        @earning.update(panelist: @panelist, period: @last_month, period_year: @this_year.to_s)
      end
    end

    it 'should include payments from last month' do
      assert_changes -> { @panelist.balance_through_last_month } do
        Payment.create(panelist: @panelist, amount: 100, period: @last_month, period_year: @this_year.to_s, paid_at: Time.now.utc - 1.month)
      end
    end

    it 'should not include payments from this month' do
      assert_no_changes -> { @panelist.balance_through_last_month } do
        Payment.create(panelist: @panelist, amount: 100, period: @this_month, period_year: @this_year.to_s, paid_at: Time.now.utc)
      end
    end
  end

  describe '#met_minimum_balance_last_month?' do
    setup do
      @panelist = panelists(:standard)
      @earning = earnings(:one)
    end

    it "returns false when previous month's balance less than minimum" do
      assert @panelist.balance_through_last_month < 10
      assert_not @panelist.met_minimum_balance_last_month?
    end

    it "returns true when previous month's balance over minimum" do
      @last_month = (Time.now.utc - 1.month).strftime('%Y-%m')
      @earning.update(panelist: @panelist, period: @last_month, period_year: @this_year.to_s, total_amount_cents: 1650, panelist_amount_cents: 1500)

      assert @panelist.balance_through_last_month >= 10
      assert @panelist.met_minimum_balance_last_month?
    end
  end

  describe '#earnings_this_month' do
    setup do
      @panelist = panelists(:standard)
      @this_month = Time.now.utc.strftime('%Y-%m')
      @last_month = (Time.now.utc - 1.month).strftime('%Y-%m')
      @earning = earnings(:one)
    end

    it 'should include earnigns from this month' do
      assert_changes -> { @panelist.earnings_this_month } do
        @earning.update(panelist: @panelist, period: @this_month, period_year: @this_year.to_s)
      end
    end

    it 'should not include earnings from last month' do
      assert_no_changes -> { @panelist.earnings_this_month } do
        @earning.update(panelist: @panelist, period: @last_month, period_year: @this_year.to_s)
      end
    end
  end

  describe '#monthly_earnings_needed' do
    setup do
      @panelist = panelists(:standard)
      @this_month = Time.now.utc.strftime('%Y-%m')
      @last_month = (Time.now.utc - 1.month).strftime('%Y-%m')
      @earning = earnings(:one)
    end

    it "should be affected by this month's earnings" do
      assert_changes -> { @panelist.monthly_earnings_needed } do
        @earning.update(panelist: @panelist, period: @this_month, period_year: @this_year.to_s)
      end
    end

    it "should not be affected by last month's earnings" do
      assert_no_changes -> { @panelist.monthly_earnings_needed } do
        @earning.update(panelist: @panelist, period: @last_month, period_year: @this_year.to_s)
      end
    end
  end

  describe '#too_young?' do
    setup do
      @panelist = panelists(:standard)
      @panelist.update!(birthdate: Time.now.utc - 40.years)
    end

    it 'should return true if the birthdate is less than 17 years ago' do
      assert_changes -> { @panelist.too_young? } do
        @panelist.update_column(:birthdate, Time.now.utc - 16.years)
      end
    end
  end

  describe '#too_old?' do
    setup do
      @panelist = panelists(:standard)
      @panelist.update!(birthdate: Time.now.utc - 40.years)
    end

    it 'should return true if the birthdate is more than 105 years ago' do
      assert_changes -> { @panelist.too_old? } do
        @panelist.update_column(:birthdate, Time.now.utc - 106.years)
      end
    end
  end

  describe '#birthdate_error_exists?' do
    setup do
      @panelist = panelists(:standard)
      @panelist.update!(birthdate: Time.now.utc - 40.years)
    end

    it 'should return true if the birthdate is less than 17 years ago' do
      assert_changes -> { @panelist.birthdate_error_exists? } do
        @panelist.update_column(:birthdate, Time.now.utc - 16.years)
      end
    end

    it 'should return true if the birthdate is more than 105 years ago' do
      assert_changes -> { @panelist.birthdate_error_exists? } do
        @panelist.update_column(:birthdate, Time.now.utc - 106.years)
      end
    end

    it 'should return true if the birthdate is in the future' do
      assert_changes -> { @panelist.birthdate_error_exists? } do
        @panelist.update_column(:birthdate, Time.now.utc + 1.year)
      end
    end
  end

  describe '#email_invalid?' do
    setup do
      @panelist = panelists(:standard)
    end

    it 'should return false' do
      assert_not @panelist.email_invalid?
    end

    it 'should return true if 6 or more digits precede @' do
      @panelist.update!(email: 'testing123456@fake.com')

      assert @panelist.email_invalid?
    end

    it 'should return true if format does not match the devise regex' do
      @panelist.update_attribute(:email, 'testing123@fake.')

      assert @panelist.email_invalid?
    end
  end

  describe '#clean_id_failed?' do
    setup do
      @panelist = panelists(:standard)
    end

    describe 'clean ID data missing' do
      setup do
        @panelist.update!(clean_id_data: nil)
      end

      it 'should raise an error' do
        assert_raises RuntimeError do
          @panelist.clean_id_failed?
        end
      end
    end

    describe 'clean ID data passes' do
      setup do
        CleanIdValidator.any_instance.expects(:failed?).returns(false)
      end

      it 'should return false' do
        assert_not @panelist.clean_id_failed?
      end
    end

    describe 'clean ID data fails' do
      setup do
        CleanIdValidator.any_instance.expects(:failed?).returns(true)
      end

      it 'should return true' do
        assert @panelist.clean_id_failed?
      end
    end
  end

  describe '#suspend_based_on_clean_id' do
    setup do
      @panelist = panelists(:standard)
    end

    it 'should create a panelist note' do
      assert_difference -> { PanelistNote.count } do
        @panelist.suspend_based_on_clean_id
      end
    end
  end

  describe '#suspend_and_pay' do
    setup do
      @panelist = panelists(:standard)
    end

    it 'should update suspend_and_pay_status to true' do
      assert_equal false, @panelist.suspend_and_pay_status
      @panelist.suspend_and_pay
      @panelist.reload
      assert_equal true, @panelist.suspend_and_pay_status
    end
  end

  describe '#record_signin_ip' do
    setup do
      @panelist = panelists(:standard)
      @ip = ip_addresses(:standard)
    end

    it 'should create an ip history for the panelist' do
      assert_difference -> { PanelistIpHistory.count } do
        @panelist.record_signin_ip(@ip)
      end
    end
  end

  describe '#recruiting_source' do
    setup do
      @panelist = panelists(:standard)
      @campaign = recruiting_campaigns(:standard)
    end

    it 'should return nil if recruiting_source is nil' do
      assert_nil @panelist.recruiting_source
    end

    it 'should return the instance of recruiting_source if not nil' do
      @panelist.update!(campaign: @campaign)

      assert_not @panelist.recruiting_source.nil?
    end
  end

  describe '#recruiting_source_name' do
    setup do
      @panelist = panelists(:standard)
      @campaign = recruiting_campaigns(:standard)
      @campaign.update!(code: 'Test Campaign')
    end

    it 'should return nil if recruiting_source_name is nil' do
      assert_nil @panelist.recruiting_source_name
    end

    it 'should return the correct recruiting source name' do
      @panelist.update!(campaign: @campaign)

      assert_match 'Test Campaign', @panelist.recruiting_source_name
    end
  end

  describe '#recruiting_source_type' do
    setup do
      @panelist = panelists(:standard)
      @campaign = recruiting_campaigns(:standard)
    end

    it 'should return nil if recruiting_source_type is nil' do
      assert_nil @panelist.recruiting_source_type
    end

    it 'should return the correct recruiting source type' do
      @panelist.update!(campaign: @campaign)

      assert_match 'recruiting campaign', @panelist.recruiting_source_type
    end
  end

  describe '#facebook_data?' do
    setup do
      @panelist = panelists(:standard)
    end

    it 'should return false when the panelist has no facebook data' do
      assert_not @panelist.facebook_data?
    end

    it 'should return true when the panelist has facebook data' do
      @panelist.update(
        provider: 'facebook',
        facebook_authorized: Time.now.utc,
        facebook_image: 'Base64ImageString',
        facebook_uid: 'FB UID'
      )

      assert @panelist.facebook_data?
    end
  end

  describe '#recent_accepted_count' do
    setup do
      @panelist = panelists(:standard)
      @onboarding = onboardings(:complete)
      @panelist.onboardings << @onboarding
    end

    test 'within timeframe and accepted' do
      assert_changes '@panelist.recent_accepted_count', from: 0, to: 1 do
        @onboarding.update(client_status: 'accepted')
        @onboarding.update!(survey_finished_at: 11.months.ago)
      end
    end

    test 'outside timeframe' do
      assert_no_changes '@panelist.recent_accepted_count' do
        @onboarding.update(client_status: 'accepted')
        @onboarding.update!(survey_finished_at: 19.months.ago)
      end
    end

    test 'not accepted' do
      assert_no_changes '@panelist.recent_accepted_count' do
        @onboarding.update(client_status: 'fraudulent')
        @onboarding.update!(survey_finished_at: 11.months.ago)
      end
    end
  end

  describe '#recent_fraudulent_count' do
    setup do
      @panelist = panelists(:standard)
      @onboarding = onboardings(:complete)
      @panelist.onboardings << @onboarding
    end

    test 'within timeframe and fraudulent' do
      assert_changes '@panelist.recent_fraudulent_count', from: 0, to: 1 do
        @onboarding.update(client_status: 'fraudulent')
        @onboarding.update!(survey_finished_at: 11.months.ago)
      end
    end

    test 'outside timeframe' do
      assert_no_changes '@panelist.recent_fraudulent_count' do
        @onboarding.update(client_status: 'fraudulent')
        @onboarding.update!(survey_finished_at: 19.months.ago)
      end
    end

    test 'not fraudulent' do
      assert_no_changes '@panelist.recent_fraudulent_count' do
        @onboarding.update(client_status: 'accepted')
        @onboarding.update!(survey_finished_at: 11.months.ago)
      end
    end
  end

  describe '#paypal_verification_timestamp_matches_status' do
    setup do
      @panelist = panelists(:standard)
    end

    test 'verified with timestamp' do
      assert_changes '@panelist.paypal_verified_at' do
        @panelist.update(paypal_verification_status: 'verified')
      end
    end

    test 'no timestamp for non-verified status change' do
      @panelist.update(paypal_verification_status: 'unverified')

      assert_no_changes '@panelist.paypal_verified_at' do
        @panelist.update(paypal_verification_status: 'flagged')
      end
    end

    test 'remove timestamp if verification is removed' do
      @panelist.update!(paypal_verified_at: 1.month.ago, paypal_verification_status: 'verified')

      assert_changes '@panelist.paypal_verified_at' do
        @panelist.update(paypal_verification_status: 'flagged')
      end
    end
  end

  describe '#recent_rejected_count' do
    setup do
      @panelist = panelists(:standard)
      @onboarding = onboardings(:complete)
      @panelist.onboardings << @onboarding
    end

    test 'within timeframe and rejected' do
      assert_changes '@panelist.recent_rejected_count', from: 0, to: 1 do
        @onboarding.update(client_status: 'rejected')
        @onboarding.update!(survey_finished_at: 11.months.ago)
      end
    end

    test 'outside timeframe' do
      assert_no_changes '@panelist.recent_rejected_count' do
        @onboarding.update(client_status: 'rejected')
        @onboarding.update!(survey_finished_at: 19.months.ago)
      end
    end

    test 'not rejected' do
      assert_no_changes '@panelist.recent_rejected_count' do
        @onboarding.update(client_status: 'accepted')
        @onboarding.update!(survey_finished_at: 11.months.ago)
      end
    end
  end

  describe '#total_recent_payouts' do
    setup do
      @panelist = panelists(:standard)
      @payment = payments(:one)
      @panelist.payments << @payment
      @last_month = Time.now.utc - 1.month
      @two_years_ago = Time.now.utc - 20.years
    end

    it "total should include last month's payout" do
      @payment.update!(paid_at: @last_month)

      assert_equal @panelist.total_recent_payouts, 1
    end

    it 'total should not include a two year old payout' do
      @payment.update!(paid_at: @two_years_ago)

      assert_equal @panelist.total_recent_payouts, 0
    end
  end

  describe '#recent_invitations' do
    setup do
      @panelist = panelists(:standard)
      @invitation = project_invitations(:standard)
      @panelist.invitations << @invitation
      @last_month = Time.now.utc - 1.month
      @two_years_ago = Time.now.utc - 20.years
    end

    it "should include last month's invitation" do
      @invitation.update!(sent_at: @last_month)

      assert_includes @panelist.recent_invitations, @invitation
    end

    it 'should not include a two year old invitation' do
      @invitation.update!(sent_at: @two_years_ago)

      assert_not_includes @panelist.recent_invitations, @invitation
    end
  end

  describe '#recent_invitations_clicked' do
    setup do
      @panelist = panelists(:standard)
      @invitation = project_invitations(:standard)
      @panelist.invitations << @invitation
      @last_month = Time.now.utc - 1.month
      @two_years_ago = Time.now.utc - 20.years
    end

    it "total should include last month's invitation that has been clicked" do
      @invitation.update!(sent_at: @last_month, clicked_at: @last_month)

      assert_equal @panelist.recent_invitations_clicked, 1
    end

    it "total should not include last month's invitation that has not been clicked" do
      @invitation.update!(sent_at: @last_month, clicked_at: nil)
      @invitation.reload

      assert_equal @panelist.recent_invitations_clicked, 0
    end
  end

  describe '#recent_invitations_not_clicked' do
    setup do
      @panelist = panelists(:standard)
      @invitation = project_invitations(:standard)
      @panelist.invitations << @invitation
      @last_month = Time.now.utc - 1.month
      @two_years_ago = Time.now.utc - 20.years
    end

    it "total should include last month's invitation that has not been clicked" do
      @invitation.update!(sent_at: @last_month, clicked_at: nil)

      assert_equal @panelist.recent_invitations_not_clicked, 1
    end

    it "total should not include last month's invitation that has been clicked" do
      @invitation.update!(sent_at: @last_month, clicked_at: @last_month)
      @invitation.reload

      assert_equal @panelist.recent_invitations_not_clicked, 0
    end
  end

  describe '#percentage_of_recent_invitations_clicked' do
    setup do
      @panelist = panelists(:standard)
      @invitation = project_invitations(:standard)
      @invitation2 = project_invitations(:standard)
      @panelist.invitations.push(@invitation, @invitation2)
      @last_month = Time.now.utc - 1.month
      @yesterday = Time.now.utc - 1.day
    end

    it 'percentage should change' do
      assert_changes '@panelist.percentage_of_recent_invitations_clicked' do
        @invitation.update!(sent_at: @last_month, clicked_at: @last_month + 2.hours)
        @invitation2.update!(sent_at: @yesterday, clicked_at: nil)
      end
    end

    it 'percentage should equal 0.0 when there are no recent_invitations_clicked' do
      @invitation.update!(sent_at: @last_month, clicked_at: nil)
      @invitation2.update!(sent_at: @yesterday, clicked_at: nil)

      assert_equal @panelist.recent_invitations_clicked, 0
      assert_equal @panelist.percentage_of_recent_invitations_clicked, 0.0
    end
  end

  describe '#avg_reaction_time' do
    setup do
      @panelist = panelists(:standard)
      @invitation = project_invitations(:standard)
      @invitation2 = project_invitations(:standard)
      @panelist.invitations.push(@invitation, @invitation2)
      @last_month = Time.now.utc - 1.month
      @yesterday = Time.now.utc - 1.day
    end

    it 'should change' do
      assert_changes '@panelist.avg_reaction_time' do
        @invitation.update!(sent_at: @last_month, clicked_at: @last_month + 2.hours)
        @invitation2.update!(sent_at: @yesterday, clicked_at: @yesterday + 4.hours)
      end
    end

    it 'should equal N/A when there are no recent invitations clicked ' do
      @invitation.update!(sent_at: @last_month, clicked_at: nil)
      @invitation2.update!(sent_at: @yesterday, clicked_at: nil)

      assert_equal @panelist.avg_reaction_time, 'N/A'
    end
  end

  describe '#signup_clean_id_score' do
    setup do
      @panelist = panelists(:standard)
      @data = { 'Score' => 20 }
    end

    it 'extracts the score from the clean_id_data' do
      @panelist.update!(clean_id_data: @data)

      assert_equal @panelist.signup_clean_id_score, 20
    end

    it 'score is nil when clean_id_data is nil' do
      @panelist.update!(clean_id_data: nil)

      assert_nil @panelist.signup_clean_id_score
    end

    it 'score equals N/A when the score is missing from the clean_id_data' do
      @data = { 'Score' => nil }

      @panelist.update!(clean_id_data: @data)

      assert_equal @panelist.signup_clean_id_score, 'N/A'
    end
  end

  describe '#net_profit' do
    setup do
      @panelist = panelists(:standard)
      @onboarding = onboardings(:complete)
      @payment = payments(:one)
      @panelist.onboardings << @onboarding
      @panelist.payments << @payment
    end

    it 'should calculate the net profit' do
      assert_changes '@panelist.net_profit' do
        @onboarding.survey.update!(cpi: 10)
        @onboarding.update!(client_status: 'accepted')

        assert_equal @onboarding.survey.cpi.to_f, 10
        assert_equal @payment.amount_cents / 100, 1
        assert_equal @panelist.net_profit, 9
      end
    end
  end

  describe '#recent_net_profit' do
    setup do
      @panelist = panelists(:standard)
      @onboarding = onboardings(:complete)
      @payment = payments(:one)
      @panelist.onboardings << @onboarding
      @panelist.payments << @payment
    end

    it 'should calculate the recent net profit' do
      assert_changes '@panelist.recent_net_profit' do
        @onboarding.survey.update!(cpi: 10)
        @onboarding.update!(client_status: 'accepted', survey_finished_at: 2.months.ago)

        assert_equal @onboarding.survey.cpi.to_f, 10
        assert_equal @payment.amount_cents / 100, 1
        assert_equal @panelist.recent_net_profit, 9
      end
    end

    it "should not include an onboarding when caluclating the recent net profit if it's survey was finished over 18 months ago" do
      assert_no_changes '@panelist.recent_net_profit' do
        @onboarding.survey.update!(cpi: 10)
        @onboarding.update!(client_status: 'accepted', survey_finished_at: 20.months.ago)
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

  Panelist.create!(attributes)
end
# rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
