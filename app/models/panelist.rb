# frozen_string_literal: true

# A panelist is someone who signs up to take surveys from us.
class Panelist < ApplicationRecord
  include PanelistStatus
  include PanelistFinance

  # TODO: Remove this token. Don't think we're using it any longer.
  has_secure_token

  has_attached_file :id_card, Rails.configuration.paperclip_panelist_id_cards
  validates_attachment_content_type :id_card, content_type: ['image/jpeg', 'image/png', 'image/gif']

  devise :confirmable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :paypal_oauth2]

  enum paypal_verification_status: {
         flagged: 'flagged',
         unverified: 'unverified',
         verified: 'verified'
       }, _prefix: 'paypal'

  enum status: {
    signing_up: 'signing_up',
    active: 'active',
    suspended: 'suspended',
    deleted: 'deleted',
    deactivated: 'deactivated',
    deactivated_signup: 'deactivated_signup'
  }

  belongs_to :country
  belongs_to :zip_code, optional: true # ZipCode model, but postal_code is a text field.
  belongs_to :campaign, optional: true, class_name: 'RecruitingCampaign', inverse_of: :panelists
  belongs_to :original_panel, optional: true, class_name: 'Panel', inverse_of: :panelists_who_joined_this_panel_first
  belongs_to :primary_panel, class_name: 'Panel', inverse_of: :panelists
  belongs_to :nonprofit, optional: true, inverse_of: :panelists
  belongs_to :original_nonprofit, optional: true, class_name: 'Nonprofit', inverse_of: :original_panelists
  belongs_to :archived_nonprofit, optional: true, class_name: 'Nonprofit', inverse_of: :archived_panelists
  belongs_to :offer, optional: true, foreign_key: 'offer_code', primary_key: 'code', inverse_of: :panelists
  belongs_to :affiliate, optional: true, foreign_key: 'affiliate_code', primary_key: 'code', inverse_of: :panelists

  has_one :zip_state, through: :zip_code, inverse_of: :panelists, class_name: 'State'
  has_one :msa, through: :zip_code, inverse_of: :panelists
  has_one :pmsa, through: :zip_code, inverse_of: :panelists
  has_one :dma, through: :zip_code, inverse_of: :panelists
  has_one :unsubscription, dependent: :destroy

  has_many :status_events, dependent: :destroy, class_name: 'PanelistStatusEvent', inverse_of: :panelist
  has_many :panel_memberships, dependent: :destroy
  has_many :demographic_detail_results, dependent: :destroy
  has_many :panels, through: :panel_memberships, inverse_of: :panelists
  has_many :notes, dependent: :destroy, class_name: 'PanelistNote', inverse_of: :panelist
  has_many :ip_histories, dependent: :destroy, class_name: 'PanelistIpHistory', inverse_of: :panelist

  has_many :demo_answers, dependent: :destroy, inverse_of: :panelist
  has_many :demo_options, through: :demo_answers, inverse_of: :panelists
  has_many :demo_questions, through: :demo_answers

  # has_many :demo_query_encoded_uid_panelists, dependent: :destroy
  # has_many :encoded_uid_demo_queries, through: :demo_query_encoded_uid_panelists, inverse_of: :encoded_uid_panelists, source: :demo_query

  has_many :invitations, dependent: :destroy, inverse_of: :panelist, class_name: 'ProjectInvitation'
  has_many :invited_surveys, through: :invitations, source: :survey, inverse_of: :invited_panelists
  has_many :invited_projects, through: :invitations, source: :project, inverse_of: :panelists

  has_many :onboardings, dependent: :destroy

  has_many :earnings, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :email_confirmation_reminders, dependent: :destroy
  has_many :signup_reminders, dependent: :destroy

  validates :email, :first_name, :last_name, :original_panel, :paypal_verification_status, :status, presence: true
  validates :email, uniqueness: true, format: Devise.email_regexp
  validates :postal_code, presence: true, if: -> { state.present? }, on: :create
  validate :domestic_postal_code_is_appropriate, on: :create
  validate :birthdate_is_realistic

  before_validation :clean_email, :assign_search_terms, :set_donation_percentage, :set_default_country
  before_save :remove_string_from_clean_id_data
  before_save :set_paypal_verification_timestamp
  after_create :create_email_reminders
  after_create :create_affiliate_record
  after_create :create_offer_record
  after_update :mark_email_reminders_as_ignored
  after_update :start_conversions_job
  after_update :set_zip_code
  after_save :calculate_age, if: :age_needs_updating?
  after_save :add_zip_code, if: -> { zip_code.nil? }
  after_save :create_status_event

  scope :active_or_suspended, -> { where(status: %w[active suspended]) }
  scope :in_progress_signups, -> { signing_up.where('panelists.created_at > ?', Time.now.utc - 2.days) }
  scope :dead_signups, -> { signing_up.where('panelists.created_at <= ?', Time.now.utc - 2.days) }
  scope :new_accounts, -> { active.where('panelists.welcomed_at > ?', Time.now.utc - 2.days) }
  scope :signing_up_or_active, -> { where(status: %w[signing_up active]) }
  scope :completed_signup, -> { where.not(welcomed_at: nil) }
  scope :stale_logins, -> { signing_up_or_active.where('last_activity_at < ?', Time.now.utc - 6.months) }
  scope :search, ->(term) { where('search_terms LIKE ?', "%#{term.downcase.strip}%") if term.present? }
  scope :age_needs_updating, -> { active.or(signing_up).where.not(birthdate: nil).where('update_age_at < ? OR update_age_at IS NULL', Time.zone.now) }
  scope :in_danger_of_deactivation, -> { active.where('last_activity_at < ?', Time.now.utc - 5.months) }
  scope :not_on_danger_list, -> { where(in_danger_at: nil) }
  scope :locked, -> { where(lock_flag: true) }
  scope :verified, -> { where(verified_flag: true) }
  scope :scored, -> { active.or(suspended.where('suspended_at >= ?', 6.months.ago)).where.not(score: nil) }
  scope :scorable, -> { active.or(suspended.where('suspended_at >= ?', 6.months.ago)) }
  scope :unsubscribed, -> { joins(:unsubscription) }

  # scope :for_options, ->(options) { joins(:demo_options).merge(DemoOption.for_list(options)) }
  scope :for_ages, ->(ages) { where(age: ages.map(&:value)) if ages.any? }
  scope :for_country, ->(country) { where(country: country) if country.present? }
  scope :for_state_codes, ->(state_codes) { where(state: state_codes.map(&:code)) if state_codes.any? }

  scope :for_regions, ->(regions) { joins(:zip_code).merge(ZipCode.for_regions(regions)) if regions.any? }
  scope :for_divisions, ->(divisions) { joins(:zip_code).merge(ZipCode.for_divisions(divisions)) if divisions.any? }
  scope :for_states, ->(states) { joins(:zip_code).merge(ZipCode.for_states(states)) if states.any? }
  scope :for_dmas, ->(dmas) { joins(:zip_code).merge(ZipCode.for_dmas(dmas)) if dmas.any? }
  scope :for_msas, ->(msas) { joins(:zip_code).merge(ZipCode.for_msas(msas)) if msas.any? }
  scope :for_pmsas, ->(pmsas) { joins(:zip_code).merge(ZipCode.for_pmsas(pmsas)) if pmsas.any? }
  scope :for_counties, ->(counties) { joins(:zip_code).merge(ZipCode.for_counties(counties)) if counties.any? }
  scope :for_zips, ->(zips) { where(zip_code: zips) if zips.any? }
  scope :for_onboardings, ->(onboardings) { joins(:onboardings).merge(Onboarding.for_ids(onboardings.map(&:id))) if onboardings.any? }
  scope :have_been_screened_out_recently, -> { active.joins(:onboardings).merge(Onboarding.recently_screened).distinct(:panelist_id) }
  scope :have_not_received_an_invitation_in_5_months, -> { active.where('last_invited_at < ?', Time.now.utc - 5.months) }

  scope :most_recent_first, -> { order(created_at: :desc) }

  alias answers demo_answers

  def birthdate_is_realistic
    return if birthdate.blank?

    errors.add(:birthdate, 'cannot be in the future') if birthdate.future?
    errors.add(:birthdate, 'has to be at least 17 years ago') if too_young?
    errors.add(:birthdate, 'has to be less than 105 years ago') if too_old?
  end

  def birthdate_error_exists?
    return if birthdate.blank?

    birthdate.future? || too_young? || too_old?
  end

  def too_young?
    Time.zone.today.year - birthdate.year < 17 && birthdate.past?
  end

  def too_old?
    Time.zone.today.year - birthdate.year > 105
  end

  def set_paypal_verification_timestamp
    self.paypal_verified_at = Time.now.utc if paypal_verified_at.nil? && paypal_verification_status == 'verified'
    self.paypal_verified_at = nil if paypal_verified_at.present? && paypal_verification_status != 'verified'
  end

  def domestic_postal_code_is_appropriate
    return if country != Country.find_by(slug: 'us') || postal_code.blank?

    errors.add(:postal_code, 'must be valid') && return unless postal_code.scan(/\D/).empty?
    errors.add(:postal_code, 'should be 5 digits for U.S. postal codes') && return unless postal_code.length == 5
  end

  def name
    "#{first_name} #{last_name}"
  end

  def survey_token(survey)
    survey_invitation(survey).try(:token)
  end

  def invited_and_open?(survey:)
    ProjectInvitation.invited_and_open?(panelist: self, survey: survey)
  end

  def add_answer(option)
    remove_answer(option) if option.only_one_per_question?
    answers.build(demo_option_id: option.id) if answers.find_by(id: option.id).blank?
  end

  def add_answer!(option)
    add_answer(option)
    save!
  end

  def remove_answer(option)
    answers.where(demo_option_id: option).destroy_all
  end

  def on_danger_list?
    in_danger_at.present?
  end

  def current_ip_blocked?
    IpAddress.find_by(address: current_sign_in_ip.to_s).try(:blocked?)
  end

  def age_needs_updating?
    return false if birthdate.blank?
    return true if age.blank? && birthdate.present?
    return true if update_age_at.nil?
    return true if update_age_at < Time.now.utc
  end

  # rubocop:disable Metrics/MethodLength
  def calculate_age
    return if birthdate.blank?

    if too_old?
      deactivate
    else
      begin
        update!(age: current_age, update_age_at: current_age_update_date)
      rescue ActiveRecord::RecordInvalid => e
        raise e unless too_young? || email_invalid?

        # This is a temporary fix for young panelists who aren't in CA. We're
        # not allowing new signups under 17, but we don't want to lose everyone
        # who is already in that age bracket. Once all panelists are over 16, we
        # can remove this.

        # rubocop:disable Rails/SkipsModelValidations
        update_columns(age: current_age, update_age_at: current_age_update_date)
        # rubocop:enable Rails/SkipsModelValidations
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  def create_email_reminders
    return if confirmed_at.present?

    email_confirmation_reminders.create(send_at: Time.now.utc + 48.hours)
    email_confirmation_reminders.create(send_at: Time.now.utc + 72.hours)
  end

  def mark_email_reminders_as_ignored
    return if confirmed_at.blank?

    email_confirmation_reminders.find_each(&:mark_as_ignored)
  end

  def create_affiliate_record
    return if affiliate_code.blank?

    Affiliate.find_or_create_by!(code: affiliate_code)
  end

  def create_offer_record
    return if offer_code.blank?

    Offer.find_or_create_by!(code: offer_code)
  end

  def start_conversions_job
    return unless saved_change_to_welcomed_at? && welcomed_at.present? && offer_code.present?

    ProcessConversionsJob.perform_later(offer_code)
  end

  def create_status_event
    return unless saved_change_to_status? || status_events.empty?

    status_events.create!(status: status)
  end

  # rubocop:disable Metrics/AbcSize
  def create_status_event_for_exisiting_panelist
    status_events.create!(status: 'signing_up', created_at: created_at)
    if welcomed_at.present?
      status_events.create!(status: 'active', created_at: welcomed_at) if welcomed_at.present?
      status_events.create!(status: 'deactivated', created_at: deactivated_at)
      status_events.create!(status: 'suspended', created_at: suspended_at) if suspended_at.present?
      status_events.create!(status: 'deleted', created_at: deleted_at) if deleted_at.present?
    else
      status_events.create!(status: 'deactivated_signup', created_at: updated_at)
    end
  end
  # rubocop:enable Metrics/AbcSize

  def assign_search_terms
    assign_attributes(search_terms: "#{name}|#{email}".downcase)
  end

  def update_search_terms
    assign_search_terms
    save
  end

  def base_demo_questions_completed?
    address.present? && city.present? && state.present? && postal_code.present? && birthdate.present? && business_name_present_if_required?
  end

  def demos_completed?
    answered_all_questions?
  end

  def welcomed?
    welcomed_at.present?
  end

  def self.for_options(options)
    options.group_by(&:question).inject(all) do |result, question_with_options|
      question_options = question_with_options[1]
      result.where('panelists.id IN (SELECT panelist_id FROM demo_answers WHERE demo_option_id IN (?))', question_options)
    end
  end

  def self.for_project_inclusions(project_inclusions)
    project_inclusions.inject(all) do |result, inclusion|
      result.joins(:onboardings).merge(Onboarding.for_project_responses(inclusion.project, inclusion.slug))
    end
  end

  def self.panelist_ids_that_have_had_2_invitations_today
    ProjectInvitation.where('created_at > ?', Time.now.utc.beginning_of_day).group(:panelist_id).having('count(*) > 1').count.keys
  end

  def unanswered_required_questions
    primary_panel.demo_questions.required_for_panelist(self).for_country(country).by_sort_order - demo_questions
  end

  def unanswered_questions
    primary_panel.demo_questions.for_country(country).by_sort_order - demo_questions
  end

  def unanswered_questions_for_category(category)
    primary_panel.demo_questions.required_for_panelist(self).for_category(category).for_country(country).by_sort_order - demo_questions
  end

  def answers_for_category(category)
    demo_answers.for_category(category)
  end

  def eligible_for_surveys?
    demos_completed? && base_demo_questions_completed? && agreed_to_terms_at
  end

  def country_sym
    return :us if country.blank?

    country.slug.to_sym
  end

  def answered_question_categories
    primary_panel.demo_questions.map(&:demo_questions_category).sort! { |a, b| a.sort_order <=> b.sort_order }.uniq
  end

  def nonprofit_recently_archived?
    archived_nonprofit.present? &&
      nonprofit.nil? &&
      archived_nonprofit.archived_at > (Time.now.utc - 30.days)
  end

  def self.deactivate_stale_panelists
    stale_logins.find_each(&:deactivate_if_enough_recent_invitations)
  end

  def email_invalid?
    # The latter is the regex used by devise to validate emails. config/initializers/devise.rb
    email.match?(/[0-9]{5,}.@/) || !email.match?(/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
  end

  def unsubscribed?
    unsubscription.present?
  end

  def clean_id_failed?
    raise 'no clean id data' if clean_id_data.nil?

    validator = CleanIdValidator.new(clean_id_data)
    validator.failed?
  end

  def suspend_and_pay
    update!(suspend_and_pay_status: true)
  end

  def suspend_based_on_clean_id
    create_note('Automatically suspended: failed CleanID')
    suspend
  end

  # Usually called from a job.
  def add_to_signup_list
    return unless active?

    if Settings.use_mailchimp? == 'true'
      MailchimpApi.new.add_member_to_list(panelist: self)
      MailchimpApi.new.add_tag_to_member(panelist: self, tag: 'WELCOME')
      update(using_mailchimp: true)
    else
      MadMimiSignupList.new.add(panelist: self)
    end
  end

  # Usually called from a job.
  def add_to_danger_list
    return unless active?

    if using_mailchimp?
      MailchimpApi.new.add_tag_to_member(panelist: self, tag: 'Danger')
    else
      MadMimiDangerList.new.add(panelist: self)
    end
    update!(in_danger_at: Time.now.utc)
  rescue ActiveRecord::RecordInvalid => e
    # Ignoring invalid panelists who are too young. We can remove this once
    # we've removed all of these panelists.
    raise e unless too_young? || email_invalid?
  end

  # Usually called from a job.
  def remove_from_danger_list
    return unless on_danger_list?

    if using_mailchimp?
      MailchimpApi.new.remove_tag_from_member(panelist: self, tag: 'Danger')
    else
      MadMimiDangerList.new.remove(panelist: self)
    end
    update!(in_danger_at: nil)
  end

  # Usually called from a job.
  def self.process_endangered_panelists
    in_danger_of_deactivation.not_on_danger_list.find_each do |panelist|
      MadMimiAddToDangerListJob.perform_later(panelist: panelist)
    end
  end

  def set_zip_code
    return unless saved_change_to_postal_code?

    zip_code = ZipCode.find_by(code: postal_code)
    update(zip_code: zip_code)
  end

  def record_signin_ip(ip)
    ip_histories.create!(source: 'signin', ip_address: ip)
  end

  def recruiting_source
    original_nonprofit || affiliate || campaign
  end

  def recruiting_source_name
    return if recruiting_source.blank?

    recruiting_source.name
  end

  def recruiting_source_type
    return if recruiting_source.blank?

    recruiting_source.class.name.underscore.humanize.downcase
  end

  def facebook_data?
    provider || facebook_authorized || facebook_image || facebook_uid
  end

  def unlocked?
    lock_flag == false
  end

  def verified?
    verified_flag == true
  end

  def recent_accepted_count
    onboardings.finished_in_past_eighteen_months.complete.accepted.count
  end

  def recent_rejected_count
    onboardings.finished_in_past_eighteen_months.complete.rejected.count
  end

  def recent_fraudulent_count
    onboardings.finished_in_past_eighteen_months.complete.fraudulent.count
  end

  def total_recent_payouts
    return if payments.blank?

    payments.where('paid_at >= ?', 18.months.ago).count
  end

  def signup_clean_id_score
    return if clean_id_data.blank?

    clean_id_data&.dig('Score') || 'N/A'
  end

  def recent_invitations
    invitations.where('sent_at >= ?', 18.months.ago)
  end

  def recent_invitations_clicked
    return if recent_invitations.blank?

    recent_invitations.where.not(clicked_at: nil).count
  end

  def percentage_of_recent_invitations_clicked
    return if recent_invitations_clicked.blank?

    ((recent_invitations_clicked / recent_invitations.count.to_f) * 100).round(2)
  end

  def recent_invitations_not_clicked
    return if recent_invitations.blank?

    recent_invitations.where(clicked_at: nil).count
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def avg_reaction_time
    return if recent_invitations.blank?

    reaction_times = []

    recent_invitations.each do |invitation|
      next if invitation.clicked_at.blank?

      time_sent = invitation.sent_at
      time_clicked = invitation.clicked_at
      reaction_time = ((time_clicked - time_sent) / 1.minute).to_f
      reaction_times << reaction_time
    end

    reaction_times_total = reaction_times.sum
    !reaction_times_total.zero? && recent_invitations.present? ? (reaction_times_total / recent_invitations.count.to_f).round : 'N/A'
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def recent_clean_id_scores
    recent_onboardings = onboardings.last(10)
    return if recent_onboardings.blank?

    recent_onboardings.map do |onboarding|
      next unless onboarding.clean_id_data_valid?

      onboarding.clean_id_score
    end
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def net_profit
    cpi_amounts = []
    payment_amounts = []

    onboardings.complete.accepted.each do |onboarding|
      next if onboarding.survey.cpi.blank?

      cpi_amounts << onboarding.survey.cpi
    end

    cpi_total = cpi_amounts.sum.to_f

    payments.each do |payment|
      payment_amounts << payment.amount_cents
    end

    payment_total = (payment_amounts.sum / 100).to_f

    (cpi_total - payment_total).round(2)
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def recent_net_profit
    cpi_amounts = []
    payment_amounts = []

    onboardings.complete.accepted.where('survey_finished_at >= ?', 18.months.ago).find_each do |onboarding|
      next if onboarding.survey.cpi.blank?

      cpi_amounts << onboarding.survey.cpi
    end

    cpi_total = cpi_amounts.sum.to_f

    payments.where('paid_at >= ?', 18.months.ago).find_each do |payment|
      payment_amounts << payment.amount_cents
    end

    payment_total = (payment_amounts.sum / 100).to_f

    (cpi_total - payment_total).round(2)
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  private

  def business_name_present_if_required?
    campaign&.business_name_flag? ? business_name.present? : true
  end

  def add_zip_code
    return if postal_code.blank?

    new_zip = ZipCode.find_by(code: postal_code.first(5))
    return if new_zip.nil?

    update!(zip_code: new_zip)
  end

  def current_age
    return if birthdate.blank?

    panelist_age = current_year - birthdate_year
    panelist_age -= 1 unless birthday_already_passed?

    panelist_age
  end

  def current_age_update_date
    return if birthdate.blank?

    birthdate + (current_age + 1).years
  end

  def birthday_already_passed?
    return true if current_month > birthdate_month
    return true if current_month == birthdate_month && current_day >= birthdate_day

    false
  end

  def current_year
    Time.zone.today.year
  end

  def current_month
    Time.zone.today.month
  end

  def current_day
    Time.zone.today.day
  end

  def birthdate_year
    return if birthdate.nil?

    birthdate.year
  end

  def birthdate_month
    return if birthdate.nil?

    birthdate.month
  end

  def birthdate_day
    return if birthdate.nil?

    birthdate.day
  end

  def survey_invitation(survey)
    invitations.find_by(survey: survey)
  end

  def remove_string_from_clean_id_data
    return unless clean_id_data.is_a?(String)

    self.clean_id_data = nil
  end

  def clean_email
    self.email = email.strip.downcase if email.present?
  end

  def set_default_country
    self.country = Country.find_by(slug: 'us') if country.blank?
  end

  def answered_all_questions?
    return false unless primary_panel

    unanswered_required_questions.empty?
  end

  def create_note(message)
    anonymous_employee = Employee.find(0)
    notes.create!(employee: anonymous_employee, body: message)
  end
end
