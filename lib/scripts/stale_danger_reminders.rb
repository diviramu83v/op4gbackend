# frozen_string_literal: true

danger_list_eligible_panelists = Panelist.in_danger_of_deactivation.not_on_danger_list

danger_list = MadMimiDangerList.new

danger_list_eligible_panelists.find_each do |p|
  danger_list.add(panelist: p)
  MailchimpApi.new.add_tag_to_member(panelist: p, tag: 'Danger')
end
