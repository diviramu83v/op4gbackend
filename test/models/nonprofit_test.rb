# frozen_string_literal: true

require 'test_helper'

class NonprofitTest < ActiveSupport::TestCase
  setup do
    @np = nonprofits(:one)
  end

  describe 'fixture' do
    setup { @nonprofit = nonprofits(:one) }

    it 'is valid' do
      @nonprofit.valid?
      assert_empty @nonprofit.errors
    end
  end

  describe '#active_original_panelists' do
    it 'returns the correct panelists' do
      assert_empty @np.active_original_panelists

      assert_difference -> { @np.active_original_panelists.count } do
        @panelist = panelists(:standard)
        @panelist.update(original_nonprofit: @np)
      end

      assert_includes @np.active_original_panelists, @panelist
    end
  end

  describe '#active_current_panelists' do
    it 'returns the correct panelists' do
      @np.panelists.delete_all
      assert_empty @np.active_current_panelists

      assert_difference -> { @np.active_current_panelists.count } do
        @panelist = panelists(:standard)
        @panelist.update(nonprofit: @np)
      end

      assert_includes @np.active_current_panelists, @panelist
    end
  end

  describe '#archive' do
    it 'archives the nonprofit and updates the panelists when the delete action is called' do
      @panelist = panelists(:active)
      @panelist.update!(nonprofit: @np)

      assert_nil @np.archived_at

      result = @np.archive

      @np.reload
      @panelist.reload

      assert_nil @panelist.nonprofit
      assert @panelist.archived_nonprofit == @np

      assert @np.archived_at.present?

      assert_equal result, true
    end

    it 'updates anyway if validation fails' do
      @panelist = panelists(:active)
      assert_nil @np.archived_at

      Panelist.any_instance.expects(:update!).raises(ActiveRecord::RecordInvalid).once

      result = @np.archive
      assert_equal result, true

      @np.reload
      @panelist.reload

      assert_nil @panelist.nonprofit
      assert_equal @panelist.archived_nonprofit, @np
      assert @np.archived_at.present?
    end
  end

  describe '#donation_total_with_adjustment' do
    setup do
      @earning = earnings(:one)
      @earning.update(nonprofit_amount_cents: 500, panelist_amount_cents: 500, total_amount: 10)
    end

    it 'returns active earnings total plus the earning adjustment' do
      @np.earning_adjustment_cents = 100

      assert_equal @np.donation_total_with_adjustment, 6
    end

    it 'returns active earnings total minus the earning adjustment' do
      @np.earning_adjustment_cents = -100

      assert_equal @np.donation_total_with_adjustment, 4
    end
  end

  describe '#generate_earnings_report' do
    setup do
      @this_month = Time.now.utc.strftime('%m')
      @this_year = Time.now.utc.strftime('%Y')
    end

    it 'returns a report of the nonprofit earnings' do
      @panelist = panelists(:active)
      @earning = earnings(:one)
      @earning.update(panelist: @panelist, period: "#{@this_year}-#{@this_month}", period_year: @this_year.to_s)
      @earnings = []
      @earnings << @earning

      result = Nonprofit.generate_earnings_report(@this_month, @this_year, @this_month, @this_year)

      assert_equal 1, result.count # account for the nonprofit fixture
    end
  end

  describe '#build_earnings_csv' do
    it 'returns a csv of the provided earnings data' do
      report_data = mock('report_data')
      report_data.expects(:rows).returns([[1, 'test_name', '100.00']])

      csv = Nonprofit.build_earnings_csv(report_data)

      assert_equal(csv == "Id,Name,Earnings\n1,test_name,100.00\n", true)
    end
  end
end
