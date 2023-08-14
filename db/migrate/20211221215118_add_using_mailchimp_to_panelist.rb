# frozen_string_literal: true

class AddUsingMailchimpToPanelist < ActiveRecord::Migration[5.2]
  def change
    add_column :panelists, :using_mailchimp, :boolean
  end
end
