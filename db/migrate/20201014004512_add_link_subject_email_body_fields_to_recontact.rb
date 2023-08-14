# frozen_string_literal: true

class AddLinkSubjectEmailBodyFieldsToRecontact < ActiveRecord::Migration[5.2]
  def change
    add_column :recontacts, :link, :string
    add_column :recontacts, :subject, :string
    add_column :recontacts, :email_body, :text
  end
end
