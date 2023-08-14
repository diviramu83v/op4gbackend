# frozen_string_literal: true

# A country represents a real country somewhere on planet Earth.
class Country < ApplicationRecord
  include PgSearch::Model

  pg_search_scope :search_by_name, against: {
                                    name: 'A'
                                  },
                                  using: {
                                    tsearch: { prefix: true, any_word: true }
                                  }

  has_many :panel_countries, dependent: :destroy
  has_many :panels, through: :panel_countries, inverse_of: :countries
  has_many :rfp_countries, class_name: "RfpCountry"

  scope :nonprofit_options, -> { where(nonprofit_flag: true) }

  COUNTRY_PAGINATE = 10

  def button_label
    "Country : #{name}"
  end

  # TODO: add a default column
  def self.default
    find_by(slug: 'us')
  end
end
