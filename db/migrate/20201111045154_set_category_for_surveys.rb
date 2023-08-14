# frozen_string_literal: true

class SetCategoryForSurveys < ActiveRecord::Migration[5.2]
  def change
    Survey.find_each do |survey|
      # rubocop:disable Rails/SkipsModelValidations
      survey.update_columns(category: :survey)
      # rubocop:enable Rails/SkipsModelValidations
    end
  end
end
