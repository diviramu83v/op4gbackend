class CreateTblRfpVendors < ActiveRecord::Migration[6.1]
  def up
    create_table :tblRFPVendors do |t|
      t.references :tblRFP, foreign_key: { to_table: :tblRFP }, null: false
      t.references :vendor, foreign_key: true, null: false
      t.references :rfp_target, foreign_key: { to_table: :tblRFPTargets }, null: false
      t.integer :feasible_count, null: false, default: 0
      t.integer :cpi, null: false, default: 0
      t.string :status, null: false, default: "open"
    end
  end

  def down
    drop_table :tblRFPVendors
  end
end
