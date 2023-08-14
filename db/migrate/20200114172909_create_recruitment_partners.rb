# frozen_string_literal: true

class CreateRecruitmentPartners < ActiveRecord::Migration[5.1]
  safety_assured

  def change
    create_table :recruitment_partners do |t|
      t.string :affiliate_code, null: false
      t.string :affiliate_name

      t.timestamps
    end
    add_index :recruitment_partners, :affiliate_code, unique: true
  end
end
