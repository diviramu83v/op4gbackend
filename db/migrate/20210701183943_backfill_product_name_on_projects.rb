# frozen_string_literal: true

class BackfillProductNameOnProjects < ActiveRecord::Migration[5.2]
  # rubocop:disable Rails/SkipsModelValidations
  def change
    Project.find_each do |project|
      next if project.product.blank?
      next unless ['Sample only', 'Full service', 'Wholesale'].include?(project.product.name)

      product_name = project.product.name.downcase.parameterize.underscore
      project.update_column(:product_name, product_name)
    end
  end
  # rubocop:enable Rails/SkipsModelValidations
end
