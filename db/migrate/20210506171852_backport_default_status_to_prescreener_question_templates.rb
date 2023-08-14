# frozen_string_literal: true

# This adds the 'active' status to all of the rows in the PrescreenerQuestionTemplates table
class BackportDefaultStatusToPrescreenerQuestionTemplates < ActiveRecord::Migration[5.2]
  # rubocop:disable Rails/Output, Rails/SkipsModelValidations
  def change
    PrescreenerQuestionTemplate.select(:id).find_in_batches.with_index do |records, index|
      puts "Processing batch #{index + 1}\r"
      PrescreenerQuestionTemplate.where(id: records).update_all(status: 'active')
    end
  end
  # rubocop:enable Rails/Output, Rails/SkipsModelValidations
end
