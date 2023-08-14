# frozen_string_literal: true

class RemoveEncodingPerformedAt < ActiveRecord::Migration[5.1]
  def change
    remove_column :decodings, :uid_encoding_performed_at, :datetime
  end
end
