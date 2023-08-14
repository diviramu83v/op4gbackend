class CreateTblRfpCountriesTable < ActiveRecord::Migration[6.1]
  def up
    create_table :tblRFPCountries do |t|
      t.references :tblRFP, foreign_key: { to_table: :tblRFP }
      t.references :country, foreign_key: true, null: false
    end
  end

  def down
    drop_table :tblRFPCountries
  end
end
