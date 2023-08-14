# frozen_string_literal: true

class AddPreferencesToPanelistsAndDemoCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :panelists, :language,                 :string,  null: false, default: 'english'
    add_column :panelists, :newsletter,               :boolean, null: false, default: true
    add_column :panelists, :general_communications,   :boolean, null: false, default: true
    add_column :panelists, :share_email,              :boolean, null: false, default: false
    add_column :panelists, :activity_email_frequency, :string,  null: false, default: 'daily'
    add_column :panelists, :payout_threshold,         :string,  null: false, default: 'all'
    add_column :panelists, :address,                  :string
    add_column :panelists, :city,                     :string
    add_column :panelists, :state,                    :string
    add_column :panelists, :paypal,                   :boolean, null: false, default: false

    add_column :demo_questions, :slug, :string

    create_table :demo_questions_categories do |t|
      t.string :panel, null: false
      t.string :name, null: false
      t.string :slug, null: false
      t.integer :sort_order, null: false

      t.timestamps
    end
  end
end
