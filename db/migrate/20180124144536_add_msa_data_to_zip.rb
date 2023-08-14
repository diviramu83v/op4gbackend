# frozen_string_literal: true

class AddMsaDataToZip < ActiveRecord::Migration[5.1]
  def change
    add_reference :zips, :msa, foreign_key: true
    add_reference :zips, :pmsa, foreign_key: true
    add_reference :zips, :dma, foreign_key: true
  end
end
