# frozen_string_literal: true

class DropRecontact < ActiveRecord::Migration[5.2]
  def change
    drop_table :recontacts do |t|
      t.string 'name', null: false
      t.bigint 'project_id', null: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.string 'link'
      t.string 'subject'
      t.text 'email_body'
      t.index ['project_id'], name: 'index_recontacts_on_project_id'
    end
  end
end
