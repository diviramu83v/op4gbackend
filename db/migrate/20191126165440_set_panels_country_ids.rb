# frozen_string_literal: true

class SetPanelsCountryIds < ActiveRecord::Migration[5.1]
  def change
    Panel.all.find_each do |panel|
      panel_country = panel.countries&.first || Country.find_by(name: 'United States')
      next if panel_country.blank?

      panel.update(country_id: panel_country.id)
    end
  end
end
