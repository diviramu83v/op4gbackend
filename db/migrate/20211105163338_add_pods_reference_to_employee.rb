# frozen_string_literal: true

class AddPodsReferenceToEmployee < ActiveRecord::Migration[5.2]
  def change
    add_reference :employees, :pod, foreign_key: true
  end
end
