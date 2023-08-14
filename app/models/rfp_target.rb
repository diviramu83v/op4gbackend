class RfpTarget < ApplicationRecord
  self.table_name = "tblRFPTargets"

  belongs_to :rfp, foreign_key: "tblRFP_id", class_name: "Rfp"
  belongs_to :rfp_country, class_name: "RfpCountry", foreign_key: "country_id"
  belongs_to :target_type
  has_many :rfp_target_qualifications, class_name: "RfpTargetQualification", foreign_key: "target_id"
  has_many :rfp_vendors
  has_many :vendors, through: :rfp_vendors

  validates :name, presence: true
  validates :quotas, presence: true

  def vendors_overview
    vendors.map {|vendor| {id: vendor.id, name: vendor.name} }
  end
end