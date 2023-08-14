# frozen_string_literal: true

class AddSampleTypeToProject < ActiveRecord::Migration[5.1]
  def change
    add_reference :projects, :sample_type, foreign_key: true
  end
end
