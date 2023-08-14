# frozen_string_literal: true

class AddSubjectToDemoOptions < ActiveRecord::Migration[5.2]
  def change
    add_column :demo_options, :subject, :string
  end
end
