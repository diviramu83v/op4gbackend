# frozen_string_literal: true

class BackfillSampleTypeForProjects < ActiveRecord::Migration[5.2]
  # rubocop:disable Rails/SkipsModelValidations
  def change
    Project.find_each do |project|
      next if project.sample_type_id.blank?
      next if SampleType.find(project.sample_type_id).name&.downcase == 'Other'

      sample_type_name = SampleType.find(project.sample_type_id).name&.downcase
      project.update_column(:sample_type, sample_type_name)
    end
  end
  # rubocop:enable Rails/SkipsModelValidations
end
