# frozen_string_literal: true

# Manages the "in danger" audience list on Mad Mimi
class MadMimiDangerList
  LIST_ID = ENV.fetch('MIMI_IN_DANGER_LIST', nil)

  def initialize
    @api = MadMimiApi.new
  end

  def add(panelist:)
    @api.add_to_list(email: panelist.email, list_id: LIST_ID)
  end

  def remove(panelist:)
    @api.remove_from_list(email: panelist.email, list_id: LIST_ID)
  end
end
