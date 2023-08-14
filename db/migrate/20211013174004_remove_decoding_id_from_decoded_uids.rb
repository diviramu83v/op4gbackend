# frozen_string_literal: true

class RemoveDecodingIdFromDecodedUids < ActiveRecord::Migration[5.2]
  def change
    remove_column :decoded_uids, :decoding_id, :bigint
  end
end
