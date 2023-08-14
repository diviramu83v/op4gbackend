class ReferenceTypeNameInRfpTarget < ActiveRecord::Migration[6.1]
  def up
    safety_assured { remove_column :tblRFPTargets, :type_name }
    add_reference :tblRFPTargets, :target_type
  end

  def down
    remove_reference :tblRFPTargets, :target_type
    add_column :tblRFPTargets, :type_name, :string
  end
end
