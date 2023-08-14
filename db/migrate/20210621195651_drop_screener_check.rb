# frozen_string_literal: true

class DropScreenerCheck < ActiveRecord::Migration[5.2]
  def change
    drop_table :screener_checks do |t|
      t.string 'gender'
      t.string 'age_range'
      t.string 'state'
      t.string 'income_range'
      t.string 'ethnicity'
      t.string 'employment_status'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.jsonb 'custom_answers', default: {}
      t.string 'failed_questions', default: [], array: true
      t.boolean 'passed', default: false, null: false
    end
  end
end
