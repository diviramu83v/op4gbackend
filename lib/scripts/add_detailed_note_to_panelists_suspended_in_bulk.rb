# frozen_string_literal: true

# rails runner lib/scripts/add_detailed_note_to_panelists_suspended_in_bulk.rb

panelists = Panelist.suspended.joins(:notes).merge(PanelistNote.where(body: 'Manually suspended: failed CleanID'))

panelists.each do |panelist|
  panelist.notes.create(employee_id: 0,
                        body: 'This panelist was suspended as part of a bulk effort to clean up the panel via a script, based on their CleanID score on signup. It is possible that they are a false positive. If they write in and you believe that they are legitimate, feel free to unsuspend them.')
end
