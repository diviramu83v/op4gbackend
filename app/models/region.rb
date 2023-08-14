# frozen_string_literal: true

# Represents a geographic region of the United States.
class Region < ApplicationRecord
  has_many :zips, dependent: :destroy
  has_many :panelists, through: :zips, inverse_of: :region
  has_many :demo_query_regions, dependent: :destroy
  has_many :queries, through: :demo_query_regions, inverse_of: :regions, class_name: 'DemoQuery'

  scope :by_name, -> { order('name') }

  def button_label
    "Region : #{name} [ZIP data]"
  end
end
