# frozen_string_literal: true

class AddCloseOutReasonToOnboardings < ActiveRecord::Migration[5.2]
  def change
    add_reference :onboardings, :close_out_reason, foreign_key: true
  end
end
