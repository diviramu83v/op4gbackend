# frozen_string_literal: true

class AddPanelOnramps < ActiveRecord::Migration[5.1]
  def up
    queries = DemoQuery.where.not(campaign: nil).order('campaign_id DESC, panel_id')
    queries.find_each(&:add_onramp)
  end

  def down
    Onramp.panel.delete_all
  end
end
