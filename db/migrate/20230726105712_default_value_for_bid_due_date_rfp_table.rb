class DefaultValueForBidDueDateRfpTable < ActiveRecord::Migration[6.1]
  def up
    change_column_default :tblRFP, :bid_due_date,  -> { 'CURRENT_TIMESTAMP' }
  end

  def down
    change_column_default :tblRFP, :bid_due_date, DateTime.now
  end
end
