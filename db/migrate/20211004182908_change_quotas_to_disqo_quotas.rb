# frozen_string_literal: true

class ChangeQuotasToDisqoQuotas < ActiveRecord::Migration[5.2]
  def up
    rename_table :quotas, :disqo_quotas
  end

  def down
    rename_table :disqo_quotas, :quotas
  end
end
