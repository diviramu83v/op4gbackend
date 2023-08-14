# frozen_string_literal: true

class MakeProjectTokenNonNull < ActiveRecord::Migration[5.1]
  def change
    change_column_null :projects, :relevant_id_token, false
  end
end
