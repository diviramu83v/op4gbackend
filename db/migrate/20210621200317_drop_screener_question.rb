# frozen_string_literal: true

class DropScreenerQuestion < ActiveRecord::Migration[5.2]
  def change
    drop_table :screener_questions do |t|
      t.string 'question'
      t.string 'answers', default: [], array: true
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.boolean 'custom', default: false
      t.string 'custom_answer_bank', default: [], array: true
      t.boolean 'allow_multi_select', default: false, null: false
    end
  end
end
