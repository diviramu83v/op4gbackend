# frozen_string_literal: true

class AddImportedDataToClientsProjectsSurveysAndVendors < ActiveRecord::Migration[5.1]
  def change
    add_column :clients,  :imported_data, :text
    add_column :projects, :imported_data, :text
    add_column :surveys,  :imported_data, :text
    add_column :vendors,  :imported_data, :text

    add_column :vendors, :complete_url, :string
    add_column :vendors, :terminate_url, :string
    add_column :vendors, :overquota_url, :string

    add_column :sample_types, :active, :boolean, null: false, default: false
  end
end
