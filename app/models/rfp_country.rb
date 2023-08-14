class RfpCountry < ApplicationRecord
  self.table_name = "tblRFPCountries"

  belongs_to :rfp, foreign_key: "tblRFP_id", class_name: "Rfp"
  belongs_to :country
  has_many :rfp_targets, class_name: "RfpTarget", foreign_key: "country_id"

  def targetCount
    rfp_targets.count || 0
  end
end