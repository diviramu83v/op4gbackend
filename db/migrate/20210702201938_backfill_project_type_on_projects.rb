# frozen_string_literal: true

class BackfillProjectTypeOnProjects < ActiveRecord::Migration[5.2]
  # rubocop:disable Rails/SkipsModelValidations
  def change
    Project.find_each do |project|
      project_type = ProjectType.find_by(id: project.project_type_id)
      next if project_type.blank?

      name = project_type.name.parameterize.underscore
      next unless Project.project_types.values.include?(name)

      project.update_column(:project_type, name)
    end
  end
  # rubocop:enable Rails/SkipsModelValidations
end
