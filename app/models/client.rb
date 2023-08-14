# frozen_string_literal: true

# A client pays us to field a survey or provide panelists for their surveys.
class Client < ApplicationRecord
  has_many :projects, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  scope :active, -> { joins(:projects).merge(Project.active).uniq }

  scope :by_name, -> { order(:name) }

  def project_count
    projects.count
  end

  def self.inactive
    all - active
  end
end
