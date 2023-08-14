# frozen_string_literal: true

class CreateOp4gDevices < ActiveRecord::Migration[5.2]
  def change
    # rubocop:disable Style/SymbolProc
    create_table :op4g_devices do |t|
      t.timestamps
    end
    # rubocop:enable Style/SymbolProc
  end
end
