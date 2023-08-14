class CreateTargetTypeTable < ActiveRecord::Migration[6.1]
  def up
    create_table :target_types do |t|
      t.string :name, default: ""
      t.string :description, default: ""
    end
  end

  def down
    drop_table :target_types
  end
end
