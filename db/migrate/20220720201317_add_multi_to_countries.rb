# frozen_string_literal: true

class AddMultiToCountries < ActiveRecord::Migration[6.1]
  def up
    Country.create(name: 'Multi-country', slug: 'multi', nonprofit_flag: false)
  end

  def down
    country = Country.find_by(name: 'Multi-country')
    country.destroy
  end
end
