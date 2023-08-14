# frozen_string_literal: true

# Clean_id_device from clean_id_data.
class CleanIdDevice < ApplicationRecord
  has_many :panelists, dependent: :restrict_with_exception
end
