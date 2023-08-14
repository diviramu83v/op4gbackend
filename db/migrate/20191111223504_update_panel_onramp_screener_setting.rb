# frozen_string_literal: true

class UpdatePanelOnrampScreenerSetting < ActiveRecord::Migration[5.1]
  def up
    Onramp.testing.where(check_screener: true).find_each do |testing_onramp|
      testing_onramp.survey.panel_onramps.find_each do |panel_onramp|
        panel_onramp.update!(check_screener: true)
      end
    end
  end

  # rubocop:disable Rails/SkipsModelValidations
  def down
    Onramp.panel.where(check_screener: true).update_all(check_screener: false)
  end
  # rubocop:enable Rails/SkipsModelValidations
end
