# frozen_string_literal: true

# PMSA data based on ZIP code file. Provided by Archie.
class Pmsa < ApplicationRecord
  has_many :zips, dependent: :nullify
  has_many :panelists, through: :zips, inverse_of: :pmsa
  has_many :demo_query_pmsas, dependent: :destroy
  has_many :queries, through: :demo_query_pmsas, inverse_of: :pmsas, class_name: 'DemoQuery'

  validates :code, :name, presence: true

  scope :by_name, -> { order('name') }

  def button_label
    "PMSA : #{name} [ZIP data]"
  end
end
