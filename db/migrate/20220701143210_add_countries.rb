# frozen_string_literal: true

class AddCountries < ActiveRecord::Migration[6.1]
  def up
    COUNTRIES.each do |country_array|
      next if Country.find_by(name: country_array.first).present?

      Country.create(name: country_array.first, slug: country_array.last.downcase, nonprofit_flag: false)
    end
  end

  def down
    COUNTRIES.each do |country_array|
      country = Country.find_by(name: country_array.first)
      next if country.blank?

      country.destroy
    end
  end

  COUNTRIES = [
    %w[Argentina AR],
    %w[Austria AT],
    %w[Bangladesh BD],
    %w[Belarus BY],
    %w[Belgium BE],
    %w[Brazil BR],
    %w[Bulgaria BG],
    %w[Chile CL],
    %w[China CN],
    %w[Colombia CO],
    ['Costa Rica', 'CR'],
    %w[Croatia HR],
    %w[Denmark DK],
    ['Dominican Republic', 'DO'],
    %w[Estonia EE],
    %w[Finland FI],
    %w[Greece GR],
    ['Hong Kong', 'HK'],
    %w[Hungary HU],
    %w[Iceland IS],
    %w[India IN],
    %w[Indonesia ID],
    %w[Ireland IE],
    %w[Israel IL],
    %w[Japan JP],
    %w[Kazakhstan KZ],
    %w[Kenya KE],
    %w[Latvia LV],
    %w[Lithuania LT],
    %w[Luxembourg LU],
    %w[Malaysia MY],
    %w[Mexico MX],
    %w[Netherlands NL],
    ['New Zealand', 'NZ'],
    %w[Nigeria NG],
    %w[Norway NO],
    %w[Panama PA],
    %w[Peru PE],
    %w[Philippines PH],
    %w[Poland PL],
    %w[Portugal PT],
    %w[Russia RU],
    ['Saudi Arabia', 'SA'],
    %w[Serbia RS],
    %w[Singapore SG],
    %w[Slovakia SK],
    %w[Slovenia SI],
    ['South Africa', 'ZA'],
    ['South Korea', 'KR'],
    %w[Sweden SE],
    %w[Switzerland CH],
    %w[Taiwan TW],
    %w[Tanzania TZ],
    %w[Thailand TH],
    %w[Turkey TR],
    %w[Uganda UG],
    %w[Ukraine UA],
    ['United Arab Emirates', 'AE'],
    %w[Venezuela VE],
    %w[Vietnam VN]
  ].freeze
end
