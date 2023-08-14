# frozen_string_literal: true

# A panel is the basic way of grouping panelists.
class Panel < ApplicationRecord
  include RecruitingStats
  include LifecycleStats
  include PanelistNetProfit
  include CompletesFunnel
  # TODO: Replace 'internal' with 'company'.

  enum status: {
    active: 'active',
    inactive: 'inactive'
  }

  enum category: {
    standard: 'standard',
    locked: 'locked'
  }

  has_many :onboardings, dependent: :nullify
  has_many :panel_countries, dependent: :destroy
  has_many :countries, through: :panel_countries, inverse_of: :panels
  belongs_to :country, optional: true

  has_many :demo_questions_categories, dependent: :destroy, inverse_of: :panel
  has_many :demo_questions, through: :demo_questions_categories
  has_many :demographic_details, dependent: :destroy

  has_many :panel_memberships, dependent: :destroy
  has_many :panelists, through: :panel_memberships, inverse_of: :panels

  # TODO: figure out a better name for this?
  has_many :panelists_who_joined_this_panel_first, dependent: :nullify, class_name: 'Panelist', inverse_of: :original_panel

  has_many :queries, dependent: :nullify, inverse_of: :panel, class_name: 'DemoQuery'
  has_many :sample_batches, through: :queries, inverse_of: :panel
  has_many :invitations, through: :queries, class_name: 'ProjectInvitation'

  validates :name, :slug, :status, presence: true
  validates :name, uniqueness: true
  validates :slug, uniqueness: true

  delegate :in_progress_signups, to: :panelists
  delegate :dead_signups, to: :panelists
  delegate :new_accounts, to: :panelists

  monetize :incentive_cents, allow_nil: true

  scope :viewable, lambda { |employee|
    standard unless employee.admin?
  }

  def abbreviation
    self[:abbreviation] || name
  end

  def active_panelist_count
    panelists.active.count
  end

  def panelist_count
    panelists.count
  end

  # TODO: add a default column
  def self.default
    find_by(slug: 'op4g-us')
  end

  def suspended_accounts
    panelists.suspended
  end

  def deleted_accounts
    panelists.deleted
  end

  def recent_project_count
    queries.where('demo_queries.created_at > ?', Time.now.utc - 6.months).joins(:survey).count('DISTINCT surveys.project_id')
  end
end
