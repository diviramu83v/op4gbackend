# frozen_string_literal: true

class BackportDefaultStatusToProjects < ActiveRecord::Migration[5.2]
  def change
    Project.select(:id).find_in_batches.with_index do |records, index|
      puts "Processing batch #{index + 1}\r"
      # rubocop:disable Rails/SkipsModelValidations
      Project.where(id: records).update_all(current_status: 'draft')
      # rubocop:enable Rails/SkipsModelValidations
    end
  end
end
