# frozen_string_literal: true

class SetHashingParamInclusionToNullFalse < ActiveRecord::Migration[5.2]
  def change
    change_column_null :vendors, :include_hashing_param_in_hash_data, false
  end
end
