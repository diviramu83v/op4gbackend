# frozen_string_literal: true

# rubocop:disable Rails/SkipsModelValidations
class UpdateProjectTokenColumn < ActiveRecord::Migration[5.1]
  def up
    Project.find_each do |project|
      project.update_column('relevant_id_token', Project.generate_unique_secure_token)
    end
  end

  def down; end
end
# rubocop:enable Rails/SkipsModelValidations
