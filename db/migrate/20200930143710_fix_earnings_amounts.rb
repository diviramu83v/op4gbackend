# frozen_string_literal: true

class FixEarningsAmounts < ActiveRecord::Migration[5.2]
  def up
    Earning.where(period: '2020-09').find_each do |earning|
      next if earning.sample_batch.nil?

      if earning.sample_batch.incentive != earning.total_amount
        earning.total_amount = earning.sample_batch.incentive

        if earning.nonprofit.nil? || earning.panelist.donation_percentage.zero?
          earning.panelist_amount = earning.total_amount
        else
          earning.nonprofit_amount = earning.total_amount * earning.panelist.donation_percentage / 100
          earning.panelist_amount = earning.total_amount - earning.nonprofit_amount
        end

        earning.save!
      end
    end
  end
end
