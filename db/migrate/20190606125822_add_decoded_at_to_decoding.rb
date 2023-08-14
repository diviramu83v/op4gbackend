# frozen_string_literal: true

class AddDecodedAtToDecoding < ActiveRecord::Migration[5.1]
  def change
    add_column :decodings, :decoded_at, :datetime
  end
end
