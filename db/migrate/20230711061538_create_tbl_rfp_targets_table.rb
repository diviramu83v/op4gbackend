class CreateTblRfpTargetsTable < ActiveRecord::Migration[6.1]
  def up
    create_table :tblRFPTargets do |t|
      t.references :tblRFP, foreign_key: { to_table: :tblRFP }, null: false
      t.references :country, foreign_key: { to_table: :tblRFPCountries }, null: false
      t.string :name, null: false, default: "1"
      t.integer :ir
      t.integer :loi
      t.integer :nsize
      t.string :type_name
      t.integer :quotas, null: false, default: 0
    end
  end

  def down
    drop_table :tblRFPTargets
  end
end
