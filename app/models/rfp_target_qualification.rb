class RfpTargetQualification < ApplicationRecord
  self.table_name = "tblRFPTargetQualifications"

  belongs_to :rfp, foreign_key: "tblRFP_id", class_name: "Rfp"
  belongs_to :target, class_name: "RfpTarget"

  validates :field_name, presence: true
  validates :field_value, presence: true
end