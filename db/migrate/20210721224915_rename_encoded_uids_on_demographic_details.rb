# frozen_string_literal: true

class RenameEncodedUidsOnDemographicDetails < ActiveRecord::Migration[5.2]
  def change
    rename_column :demographic_details, :encoded_uids, :upload_data
  end
end
