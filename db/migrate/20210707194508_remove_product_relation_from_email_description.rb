# frozen_string_literal: true

class RemoveProductRelationFromEmailDescription < ActiveRecord::Migration[5.2]
  def change
    remove_column :email_descriptions, :product_id, :bigint
  end
end
