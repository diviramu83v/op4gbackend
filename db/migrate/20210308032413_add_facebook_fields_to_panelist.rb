# frozen_string_literal: true

class AddFacebookFieldsToPanelist < ActiveRecord::Migration[5.2]
  def change
    change_table :panelists, bulk: true do |t|
      t.string :facebook_authorized
      t.string :facebook_image
      t.string :facebook_uid
      t.string :provider
    end
  end
end
