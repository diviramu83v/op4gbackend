# frozen_string_literal: true

class DropRecruitingSource < ActiveRecord::Migration[5.1]
  def change
    drop_table :recruiting_sources do |t|
      t.string :name, null: false
      t.text :mission
      t.boolean :fully_qualified, null: false, default: false
      t.boolean :front_page, null: false, default: false
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :state
      t.string :zip_code
      t.references :country, foreign_key: true, null: false
      t.string :phone
      t.string :url
      t.string :ein
      t.string :contact_name
      t.string :contact_title
      t.string :contact_phone
      t.string :contact_email
      t.string :manager_name
      t.string :manager_email
      t.references :recruiting_source_category, foreign_key: true

      t.timestamps
    end

    drop_table :recruiting_source_categories do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
