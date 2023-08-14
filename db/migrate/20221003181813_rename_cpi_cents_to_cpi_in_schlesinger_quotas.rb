# frozen_string_literal: true

class RenameCpiCentsToCpiInSchlesingerQuotas < ActiveRecord::Migration[6.1]
  def change
    safety_assured { rename_column :schlesinger_quotas, :cpi_cents, :cpi }
  end
end
