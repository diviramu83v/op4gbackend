# frozen_string_literal: true

# this backports all the panelists' scores to have a default of '0'
class BackportDefaultScoreToPanelists < ActiveRecord::Migration[5.2]
  def change
    # rubocop:disable Rails/SkipsModelValidations, Rails/Output
    Panelist.select(:id).find_in_batches.with_index do |records, index|
      puts "Processing batch #{index + 1}\r"
      Panelist.where(id: records).update_all(score: 0)
    end
    # rubocop:enable Rails/SkipsModelValidations, Rails/Output
  end
end
