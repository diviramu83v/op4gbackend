# frozen_string_literal: true

class ChangeVisitCodeFromIntToString < ActiveRecord::Migration[5.1]
  def up
    change_column :survey_router_visits, :visit_code, :string
  end

  def down
    change_column :survey_router_visits, :visit_code, :integer
  end
end
