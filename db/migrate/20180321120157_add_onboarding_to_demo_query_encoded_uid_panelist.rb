# frozen_string_literal: true

class AddOnboardingToDemoQueryEncodedUidPanelist < ActiveRecord::Migration[5.1]
  def change
    drop_table :demo_query_encoded_uid_panelists do |t|
      t.references :demo_query, foreign_key: true
      t.references :panelist, foreign_key: true

      t.timestamps
    end

    create_table :demo_query_onboardings do |t|
      t.references :demo_query, foreign_key: true, null: false
      t.references :onboarding, foreign_key: true, null: false

      t.timestamps
    end

    add_index :demo_query_onboardings, [:demo_query_id, :onboarding_id], unique: true, name: 'index_query_onboardings_on_query_id_and_onboarding_id'
  end
end
