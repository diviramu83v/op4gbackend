# frozen_string_literal: true

# A panel membership connects a panelist to a specific panel that participate in.
class PanelMembership < ApplicationRecord
  belongs_to :panel
  belongs_to :panelist
end
