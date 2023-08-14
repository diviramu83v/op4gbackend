# frozen_string_literal: true

# A panelist status event records a status change
class PanelistStatusEvent < ApplicationRecord
  belongs_to :panelist
end
