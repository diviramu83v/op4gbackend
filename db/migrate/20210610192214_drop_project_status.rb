# frozen_string_literal: true

class DropProjectStatus < ActiveRecord::Migration[5.2]
  def change
    drop_table :project_statuses do |t|
      t.string 'slug', null: false
      t.boolean 'default', default: false, null: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.boolean 'active', default: false, null: false
      t.integer 'sort', default: 0, null: false
      t.index ['slug'], name: 'index_project_statuses_on_slug', unique: true
    end
  end
end
