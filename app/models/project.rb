# frozen_string_literal: true

# A project is a way of grouping the activities around sending out and
#   completing surveys. A project has one or more campaigns.
class Project < ApplicationRecord
  include TrafficCalculations
  include PgSearch::Model
  pg_search_scope :search_by_name, against: :name

  pg_search_scope :search_by_name_any_word, against: {
                                      name: 'A'
                                    },
                                    using: {
                                      tsearch: { prefix: true, any_word: true }
                                    }

  enum close_out_status: {
    waiting_on_close_out: 'waiting',
    finalized: 'finalized'
  }

  enum product_name: {
    sample_only: 'sample_only',
    full_service: 'full_service',
    wholesale: 'wholesale'
  }

  RELEVANT_ID_LEVELS = %w[project survey vendor].freeze

  has_rich_text :rtf_notes

  has_secure_token :payment_token
  has_secure_token :relevant_id_token

  belongs_to :manager, inverse_of: :managed_projects, class_name: 'Employee'
  belongs_to :salesperson, inverse_of: :sold_projects, optional: true, class_name: 'Employee'
  belongs_to :client, optional: true

  has_many :surveys, dependent: :destroy
  has_many :earnings, through: :surveys, inverse_of: :project
  has_many :queries, through: :surveys, inverse_of: :project
  has_many :vendor_batches, through: :surveys, inverse_of: :project
  has_many :vendors, through: :surveys, inverse_of: :projects
  has_many :disqo_quotas, through: :surveys, inverse_of: :project
  has_many :cint_surveys, through: :surveys, inverse_of: :project
  has_many :schlesinger_quotas, through: :surveys, inverse_of: :project
  has_many :sample_batches, through: :surveys, inverse_of: :project
  has_many :invitations, dependent: :destroy, inverse_of: :project, class_name: 'ProjectInvitation'
  has_many :panelists, through: :invitations, inverse_of: :invited_projects
  has_many :onramps, through: :surveys, inverse_of: :project
  has_many :onboardings, through: :onramps, inverse_of: :project
  has_many :keys, dependent: :restrict_with_exception
  has_many :survey_warnings, through: :surveys
  has_many :responses, dependent: :destroy, inverse_of: :project, class_name: 'SurveyResponseUrl'
  has_many :redirect_logs, through: :responses
  has_many :rfps

  validates :product_name, presence: true, on: :update
  validates :name, presence: true
  validates :salesperson, :client, presence: true, if: :live?
  validates :work_order, presence: true, if: :finished?
  validate :relevant_id_level_in_list

  after_create :add_default_responses

  after_update :send_cint_rejected_uids, if: :finalized?

  after_save :update_invitations_on_finish

  scope :draft, -> { joins(:surveys).merge(Survey.draft).distinct }
  scope :live, -> { joins(:surveys).merge(Survey.live).distinct }
  scope :hold, -> { joins(:surveys).merge(Survey.hold).distinct }
  scope :waiting, -> { joins(:surveys).merge(Survey.waiting).distinct }
  scope :archived, -> { joins(:surveys).merge(Survey.archived).distinct }
  scope :active, -> { joins(:surveys).merge(Survey.active).distinct }
  scope :finished, -> { where.not(finished_at: nil) }

  scope :for_manager, ->(manager) { where(manager: manager) }
  scope :for_salesperson, ->(salesperson) { where(salesperson: salesperson) }
  scope :ordered_by_reverse_id, -> { order('ID DESC') }

  DEFAULT_SURVEY_NAME = 'Survey'

  PROJECT_PAGINATE = 10

  def self.needs_closing_out_manager_first(manager)
    sql = <<-SQL.squish
      SELECT DISTINCT projects.*, CASE WHEN manager_id = #{manager.id} THEN 0 ELSE 1 END AS by_manager
      FROM projects
      INNER JOIN surveys ON surveys.project_id = projects.id
      WHERE projects.close_out_status != 'finalized' AND ((surveys.status = 'finished' AND surveys.finished_at > '#{ENV.fetch('PROJECT_CLOSE_OUT_DATE', nil)}')
        OR (surveys.status = 'waiting' AND surveys.waiting_at > '#{ENV.fetch('PROJECT_CLOSE_OUT_DATE', nil)}'))
      ORDER BY by_manager, id DESC
    SQL

    Project.select('*').from("(#{sql}) AS projects")
  end

  def value
    surveys.sum { |survey| survey.value.to_i }
  end

  def default_survey
    surveys.first
  end

  def add_survey
    survey = surveys.new(name: "Survey #{surveys.count + 1}")
    survey.category = :standard

    if live?
      survey.save!(validate: false)
    else
      survey.save!
    end

    survey
  end

  def add_survey_clone(survey)
    survey_clone = surveys.new(survey.cloneable_fields)
    survey_clone.save!
    survey_clone
  end

  def add_recontact
    surveys.create!(
      name: 'Recontact',
      category: :recontact
    )
  end

  def reset_survey_names
    return unless surveys.count == 1

    surveys.first.update!(name: DEFAULT_SURVEY_NAME)
  end

  def multiple_surveys?
    surveys.count > 1
  end

  def add_query(query)
    return unless surveys.count == 1

    default_survey.add_query(query)
  end

  def assign_status(slug)
    Rails.logger.info "Project #{id} :: all surveys changed to => #{slug}"
    surveys.each do |survey|
      survey.assign_status(slug)
      survey.save!
    end
  rescue ArgumentError
    false
  end

  # Convenience methods for accessing status.
  # Anything not testable or active will show as closed.
  def on_hold?
    hold?
  end

  def finishable?
    return false if work_order.blank?

    surveys.all? do |survey|
      survey.assign_status('finished')
      survey.valid?
    end
  end

  def editable?
    surveys.any?(&:editable?)
  end

  def active?
    surveys.any?(&:active?)
  end

  def live?
    surveys.any?(&:live?)
  end

  def panelist_count
    panelists.count
  end

  def invitation_count
    invitations.count
  end

  def invitation_sent_count
    invitations.has_been_sent.count
  end

  def extended_name
    extended_name = "#{name} (#{id})"
    extended_name = "[WO #{work_order}] " + extended_name if work_order.present?
    extended_name
  end

  def display_payment_endpoint?
    full_service?
  end

  def email_template
    template = if full_service?
                 EmailDescription.full_service if full_service?
               else
                 EmailDescription.default
               end
    template.description
  end

  def complete_response
    find_response(:complete)
  end

  def quotafull_response
    find_response(:quotafull)
  end

  def terminate_response
    find_response(:terminate)
  end

  def return_key_surveys?
    surveys.any?(&:uses_return_keys?)
  end

  def survey_response_suffix
    return_key_surveys? ? '?key={{key}}&uid=' : '?uid='
  end

  def nonstandard_relevant_id_level?
    relevant_id_level != 'survey'
  end

  def relevant_id_level_in_list
    return if relevant_id_level.blank?

    errors.add(:relevant_id_level, 'must be project, survey, or vendor') unless RELEVANT_ID_LEVELS.include?(relevant_id_level)
  end

  def uid_parameter_key
    client.try(:custom_uid_parameter) || 'uid'
  end

  def mark_rejected_ids
    rejected_onboardings = onboardings.complete.rejected.or(onboardings.complete.where(client_status: nil))
    rejected_onboardings.find_each(&:rejected!)
    rejected_onboardings.where(rejected_reason: nil).update_all(rejected_reason: 'Rejected at project close out') # rubocop:disable Rails/SkipsModelValidations
  end

  def create_earnings_for_accepted_panelists
    accepted_panelist_onboardings.find_each(&:create_panelist_earning)
  end

  def accepted_panelist_onboardings
    onboardings.accepted.where.not(panelist: nil)
  end

  def bad_redirect_last_twenty_four_hours?
    redirect_logs.where('redirect_logs.created_at >= ?', 1.day.ago).count.positive?
  end

  def finished?
    return false if surveys.blank?

    surveys.all?(&:finished?)
  end

  def archived?
    return false if surveys.blank?

    surveys.all?(&:archived?)
  end

  def hold?
    return false if surveys.blank?

    surveys.any?(&:hold?)
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def surveys_that_can_be_changed_to_status(status:)
    case status
    when 'draft'
      surveys.live.or(surveys.archived)
    when 'live'
      surveys.draft.or(surveys.hold).or(surveys.waiting)
    when 'hold'
      surveys.live
    when 'waiting'
      surveys.live.or(surveys.hold)
    when 'finished'
      surveys.live.or(surveys.hold).or(surveys.waiting)
    when 'archived'
      surveys.finished.or(surveys.draft)
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def remaining_id_count
    return if onboardings.blank?

    onboardings.complete.where(client_status: nil).count
  end

  def unaccepted_count
    unaccepted_accepted_count + unaccepted_fraudulent_count + unaccepted_rejected_count
  end

  def surveys_waiting_or_finished?
    surveys.waiting.or(surveys.finished).present?
  end

  def branded?
    unbranded == false
  end

  private

  def unaccepted_accepted_count
    onboardings.accepted.count - onboardings.complete.accepted.count
  end

  def unaccepted_fraudulent_count
    onboardings.fraudulent.count - onboardings.complete.fraudulent.count
  end

  def unaccepted_rejected_count
    onboardings.rejected.count - onboardings.complete.rejected.count
  end

  def find_response(slug)
    responses.find_by(slug: slug)
  end

  def add_default_responses
    responses.create(slug: 'complete')
    responses.create(slug: 'quotafull')
    responses.create(slug: 'terminate')
  end

  def update_invitations_on_finish
    return unless finished?

    # iterate through the finished invitations looking for match
    invitations.finished.find_each(&:update_payment_status!)
  end

  def send_cint_rejected_uids
    CintApi.new.reconcile_rejected_completes(body: reconciliation_body)
  end

  def reconciliation_body
    onboardings.rejected.for_cint.map do |onboarding|
      {
        id: onboarding.uid,
        status: 4
      }
    end
  end
end
