# frozen_string_literal: true

class ChangeReferenceOnQuotas < ActiveRecord::Migration[5.2]
  def change
    remove_reference :quotas, :onramp, foreign_key: true
    add_reference :quotas, :survey, foreign_key: true
    change_column_null :quotas, :survey_id, true
  end
end
