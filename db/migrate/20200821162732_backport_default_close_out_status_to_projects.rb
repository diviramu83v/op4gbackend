# frozen_string_literal: true

class BackportDefaultCloseOutStatusToProjects < ActiveRecord::Migration[5.2]
  # rubocop:disable Rails/SkipsModelValidations
  def change
    Project.select(:id).find_in_batches do |records|
      Project.where(id: records).update_all(close_out_status: 'waiting')
    end
  end
  # rubocop:enable Rails/SkipsModelValidations
end
