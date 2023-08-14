# frozen_string_literal: true

class AddSampleTypeEnumToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :sample_type, :string
  end
end
