# frozen_string_literal: true

class BackFillProjectUnbrandedData < ActiveRecord::Migration[5.2]
  def up
    Project.find_each do |project|
      project.update_column(:unbranded, false) # rubocop:disable Rails/SkipsModelValidations
    end
  end
end
