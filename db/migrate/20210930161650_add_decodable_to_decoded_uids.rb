# frozen_string_literal: true

class AddDecodableToDecodedUids < ActiveRecord::Migration[5.2]
  def change
    add_reference :decoded_uids, :decodable, polymorphic: true, index: true
  end
end
