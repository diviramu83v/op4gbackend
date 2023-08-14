# frozen_string_literal: true

# Represents a US county.
class County < ApplicationRecord
  has_many :zips, dependent: :destroy
  has_many :panelists, through: :zips, inverse_of: :county
  has_many :demo_query_counties, dependent: :destroy
  has_many :queries, through: :demo_query_counties, inverse_of: :counties, class_name: 'DemoQuery'

  scope :by_name, -> { order('name') }

  def button_label
    "County : #{name} [ZIP data]"
  end
end
