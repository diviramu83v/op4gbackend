class AddFeasibleCpiDetailForRfpTarget < ActiveRecord::Migration[6.1]
  def up
    add_column :tblRFPTargets, :feasible_detail, :string, default: "[]"
    add_column :tblRFPTargets, :cpi_detail, :string, default: "[]"
  end

  def down
    remove_column :tblRFPTargets, :feasible_detail
    remove_column :tblRFPTargets, :cpi_detail
  end
end
