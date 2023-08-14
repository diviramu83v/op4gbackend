class Rfp < ApplicationRecord
  self.table_name = "tblRFP"

  RFP_PAGINATE = 10

  belongs_to :project
  belongs_to :assigned_to, class_name: "Employee"
  has_many :rfp_countries, foreign_key: "tblRFP_id", class_name: "RfpCountry", dependent: :destroy
  has_many :countries, through: :rfp_countries, dependent: :destroy
  has_many :rfp_targets, class_name: "RfpTarget", foreign_key: "tblRFP_id", dependent: :destroy
  has_many :rfp_target_qualifications, class_name: "RfpTargetQualification", foreign_key: "tblRFP_id", dependent: :destroy
  has_many :rfp_vendors, class_name: "RfpVendor", foreign_key: "tblRFP_id", dependent: :destroy
  has_many :vendors, through: :rfp_vendors
  has_one_attached :attachment, dependent: :destroy

  validates :total_n_size, presence: true
  validates :no_of_countries, presence: true
  validates :no_of_open_ends, presence: true
  validates :pi, inclusion: { in: [ true, false ] }
  validates :tracker, inclusion: { in: [ true, false ] }
  validates :qualfollowup, inclusion: { in: [ true, false ] }
  validates :status, inclusion: { in: ["open", "close"] }


  def attachmentFile
    attachment.attached? ? {blob_id: attachment.blob_id, source: Rails.application.routes.url_helpers.url_for(attachment)} : {}
  end
end