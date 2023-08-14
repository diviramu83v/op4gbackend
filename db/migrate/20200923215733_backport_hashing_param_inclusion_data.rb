# frozen_string_literal: true

class BackportHashingParamInclusionData < ActiveRecord::Migration[5.2]
  def change
    Vendor.all.find_each do |vendor|
      vendor.update!(include_hashing_param_in_hash_data: false)
    end
  end
end
