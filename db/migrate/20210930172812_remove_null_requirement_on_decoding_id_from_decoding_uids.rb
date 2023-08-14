# frozen_string_literal: true

class RemoveNullRequirementOnDecodingIdFromDecodingUids < ActiveRecord::Migration[5.2]
  def change
    change_column_null :decoded_uids, :decoding_id, true
  end
end
