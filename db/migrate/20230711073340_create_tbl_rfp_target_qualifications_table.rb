class CreateTblRfpTargetQualificationsTable < ActiveRecord::Migration[6.1]
  def up
    create_table :tblRFPTargetQualifications do |t|
      t.references :tblRFP, foreign_key: { to_table: :tblRFP }, null: false
      t.references :target, foreign_key: { to_table: :tblRFPTargets}, null: false
      t.string :field_name, null: false, default: ""
      t.string :field_value, null: false, default: ""
    end
  end

  def down
    drop_table :tblRFPTargetQualifications
  end
end
