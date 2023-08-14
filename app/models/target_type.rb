class TargetType < ApplicationRecord
  has_many :rfp_targets, class_name: "RfpTarget"
end