# frozen_string_literal: true

class SetHashingParamInclusionDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :vendors, :include_hashing_param_in_hash_data, from: nil, to: false
  end
end
