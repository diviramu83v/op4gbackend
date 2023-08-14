# frozen_string_literal: true

class AddReferenceForDisqoQuotaToOnramp < ActiveRecord::Migration[5.2]
  def change
    add_reference :onramps, :disqo_quota, foreign_key: true
  end
end
