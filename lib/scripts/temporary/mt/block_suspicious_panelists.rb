# frozen_string_literal: true

# rails runner lib/scripts/temporary/mt/block_suspicious_panelists.rb

# rubocop:disable Style/NumericLiterals
panelist_ids = [
  30182159,
  16186187,
  97827,
  96412,
  30169328,
  30176010,
  30176783
]
# rubocop:enable Style/NumericLiterals

panelist_ids.each do |panelist_id|
  panelist = Panelist.find(panelist_id)
  panelist.suspended!
end
