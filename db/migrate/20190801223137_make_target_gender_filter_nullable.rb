# frozen_string_literal: true

class MakeTargetGenderFilterNullable < ActiveRecord::Migration[5.1]
  def change
    change_column_null :survey_api_targets, :api_filter_genders, true
  end
end
