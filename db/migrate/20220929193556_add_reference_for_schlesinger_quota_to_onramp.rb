# frozen_string_literal: true

class AddReferenceForSchlesingerQuotaToOnramp < ActiveRecord::Migration[6.1]
  def change
    add_reference :onramps, :schlesinger_quota, foreign_key: true
  end
end
