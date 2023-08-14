# frozen_string_literal: true

# DMA data based on ZIP code file. Provided by Archie.
class Dma < ApplicationRecord
  has_many :zips, dependent: :nullify
  has_many :panelists, through: :zips, inverse_of: :dma
  has_many :demo_query_dmas, dependent: :destroy
  has_many :queries, through: :demo_query_dmas, inverse_of: :dmas, class_name: 'DemoQuery'

  validates :code, :name, presence: true

  scope :by_name, -> { order('name') }

  def button_label
    "DMA : #{name} [ZIP data]"
  end
end
