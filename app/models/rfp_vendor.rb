class RfpVendor < ApplicationRecord
  self.table_name = "tblRFPVendors"

  belongs_to :rfp, foreign_key: "tblRFP_id", class_name: "Rfp"
  belongs_to :vendor
  belongs_to :rfp_target

  validates :feasible_count, presence: true
  validates :cpi, presence: true
  validates :status, inclusion: { in: ["open", "close"] }
end