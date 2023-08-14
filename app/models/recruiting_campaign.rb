# frozen_string_literal: true

# A campaign to bring in new panelists. Used by nonprofits and other sources
class RecruitingCampaign < ApplicationRecord
  include RecruitmentSourceReport
  include RecruitingStats
  include LifecycleStats
  include PanelistNetProfit
  include CompletesFunnel

  belongs_to :campaignable, polymorphic: true, optional: true

  has_many :panelists, dependent: :nullify, inverse_of: :campaign, foreign_key: :campaign_id
  has_many :earnings, dependent: :nullify, inverse_of: :campaign, foreign_key: :campaign_id

  validates :code, presence: true, uniqueness: true

  alias_attribute :name, :code

  scope :active, -> { where('campaign_stopped_at IS NULL OR campaign_stopped_at > ?', Time.now.utc) }
  scope :most_recent_first, -> { order('created_at DESC') }
  scope :locked, -> { where(lock_flag: true) }

  def signup_started_count
    panelists.size
  end

  def signup_completed_count
    panelists.completed_signup.count
  end

  def incentive
    return nil if incentive_cents.blank?

    incentive_cents.to_d / 100
  end

  def incentive=(amount)
    return if amount.blank?
    return unless amount.to_s.numeric?

    self[:incentive_cents] = (amount.to_d * 100).round
  end

  def incentivized?
    incentive_flag == true
  end

  def active_panelists_grouped_by_month
    panelists.active.select("date_trunc('month', created_at) as month, count(*) as count").group('month')
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def to_csv
    CSV.generate do |csv|
      order = panelists.first.primary_panel.demo_questions.sort.pluck(:id)
      csv << (%w[id email] + panelists.first.primary_panel.demo_questions.sort.pluck(:body))
      panelists.each do |panelist|
        options = panelist.demo_options.pluck(:demo_question_id, :label)
        missing_question_ids = order - options.map(&:first)
        missing_question_ids.each do |id|
          options << [id, '']
        end
        sorted_options = options.sort_by { |e| order.index(e.first) }
        csv << ([panelist.id, panelist.email] + sorted_options.map(&:last))
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
