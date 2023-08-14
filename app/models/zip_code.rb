# frozen_string_literal: true

# ZIP code data. Provided by Archie.
class ZipCode < ApplicationRecord
  belongs_to :region
  belongs_to :division
  belongs_to :state
  belongs_to :county, optional: true
  belongs_to :msa, optional: true
  belongs_to :pmsa, optional: true
  belongs_to :dma, optional: true

  has_many :panelists, dependent: :nullify
  has_many :demo_query_zips, dependent: :destroy
  has_many :queries, through: :demo_query_zips, inverse_of: :zips, class_name: 'DemoQuery'

  validates :code, presence: true

  scope :for_states, ->(states) { where(state: states) if states.any? }
  scope :for_regions, ->(regions) { where(region: regions) if regions.any? }
  scope :for_divisions, ->(divisions) { where(division: divisions) if divisions.any? }
  scope :for_dmas, ->(dmas) { where(dma: dmas) if dmas.any? }
  scope :for_msas, ->(msas) { where(msa: msas) if msas.any? }
  scope :for_pmsas, ->(pmsas) { where(pmsa: pmsas) if pmsas.any? }
  scope :for_counties, ->(counties) { where(county: counties) if counties.any? }
  scope :by_code, -> { order('code') }

  def button_label
    "ZIP : #{code} [ZIP data]"
  end
end
