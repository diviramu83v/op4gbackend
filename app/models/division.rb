# frozen_string_literal: true

# Represents a geographic division of the United States.
class Division < ApplicationRecord
  has_many :zips, dependent: :destroy
  has_many :panelists, through: :zips, inverse_of: :division
  has_many :demo_query_divisions, dependent: :destroy
  has_many :queries, through: :demo_query_divisions, inverse_of: :divisions, class_name: 'DemoQuery'

  scope :by_name, -> { order('name') }

  def button_label
    "Division : #{name} [ZIP data]"
  end
end
