# frozen_string_literal: true

class AddUidEncodingPerformedAtToDecodings < ActiveRecord::Migration[5.1]
  def change
    add_column :decodings, :uid_encoding_performed_at, :datetime
  end
end
