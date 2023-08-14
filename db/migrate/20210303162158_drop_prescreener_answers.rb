# frozen_string_literal: true

class DropPrescreenerAnswers < ActiveRecord::Migration[5.2]
  def up
    drop_table :prescreener_answers
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
