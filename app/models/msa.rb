# frozen_string_literal: true

# MSA data based on ZIP code file. Provided by Archie.
class Msa < ApplicationRecord
  has_many :zips, dependent: :nullify
  has_many :panelists, through: :zips, inverse_of: :msa
  has_many :demo_query_msas, dependent: :destroy
  has_many :queries, through: :demo_query_msas, inverse_of: :msas, class_name: 'DemoQuery'

  validates :code, :name, presence: true

  scope :by_name, -> { order('name') }

  def button_label
    "MSA : #{name} [ZIP data]"
  end
end
