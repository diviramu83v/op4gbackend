# frozen_string_literal: true

class AddNotesToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :notes, :text
  end
end
