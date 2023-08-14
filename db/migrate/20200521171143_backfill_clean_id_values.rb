# frozen_string_literal: true

class BackfillCleanIdValues < ActiveRecord::Migration[5.2]
  # rubocop:disable Rails/SkipsModelValidations
  def up
    Onramp.find_each do |onramp|
      onramp.update_columns(check_clean_id: onramp.check_relevant_id)
    end
  end
  # rubocop:enable Rails/SkipsModelValidations
end
