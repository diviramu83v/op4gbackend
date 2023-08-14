# frozen_string_literal: true

class BackfillPassedCleanIdPreviousVersion < ActiveRecord::Migration[6.1]
  def change
    Panelist.find_in_batches do |panelists|
      panelists.each do |panelist|
        next if panelist.clean_id_data.blank?

        panelist.update_column(:passed_clean_id_previous_version, !panelist.clean_id_failed?) # rubocop:disable Rails/SkipsModelValidations
      end
    end
  end
end
