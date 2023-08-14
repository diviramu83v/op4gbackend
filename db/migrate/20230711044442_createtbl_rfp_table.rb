class CreatetblRfpTable < ActiveRecord::Migration[6.1]
  def up
    create_table :tblRFP do |t|
      t.references :project, foreign_key: true, null: false
      t.integer :total_n_size, null: false, default: 0
      t.integer :no_of_countries, null: false, default: 1
      t.integer :no_of_open_ends, null: false
      t.boolean :pi, null: false, default: false
      t.boolean :tracker, null: false, default: false
      t.boolean :qualfollowup, null: false, default: 0
      t.text :additional_details
      t.references :assigned_to, foreign_key: { to_table: :employees }
      t.datetime :bid_due_date, default: DateTime.now
      t.string :status, null: false, default: "open"
      t.timestamps
    end
  end

  def down
    drop_table :tblRFP
  end
end
