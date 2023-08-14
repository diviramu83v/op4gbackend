# frozen_string_literal: true

# A panel country connects panels and countries.
class PanelCountry < ApplicationRecord
  belongs_to :panel
  belongs_to :country
end
