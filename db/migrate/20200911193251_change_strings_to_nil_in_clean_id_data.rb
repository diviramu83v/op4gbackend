# frozen_string_literal: true

class ChangeStringsToNilInCleanIdData < ActiveRecord::Migration[5.2]
  # rubocop:disable Style/StringLiterals
  def change
    Panelist.where(clean_id_data: "{\"error\":{\"message\":\"CORS Timeout.\"}}").find_each do |panelist|
      panelist.update(clean_id_data: nil)
    end
  end
  # rubocop:enable Style/StringLiterals
end
