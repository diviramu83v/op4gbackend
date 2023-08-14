class CreateJwtDenylist < ActiveRecord::Migration[6.1]
  def up
    create_table :jwt_denylist do |t|
      t.string :jti, null: false
      t.datetime :exp, null: false

      t.timestamps
    end
    add_index :jwt_denylist, :jti
  end

  def down
    drop_table :jwt_denylist
  end
end
