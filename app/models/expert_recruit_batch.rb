# frozen_string_literal: true

# An expert recruit batch saves bulk emails.
class ExpertRecruitBatch < ApplicationRecord
  DEFAULT_EMAIL_WORDING = 'Hey, come take this survey please'

  enum status: {
    waiting: 'waiting',
    sent: 'sent'
  }

  validates :email_subject, :email_body, :time, presence: true
  validates :from_email, :client_name, :client_phone, :email_signature, presence: true, if: :send_for_client?
  # rubocop:disable Rails/I18nLocaleTexts
  validates :logo,
            content_type: [:png, :jpg, :jpeg],
            size: { less_than: 2.megabytes, message: 'must be less than 2MB in size' },
            if: :send_for_client?
  # rubocop:enable Rails/I18nLocaleTexts
  validates :description, presence: true, unless: :send_for_client?
  validate :employee_phone_present?, unless: :send_for_client?

  has_many :expert_recruits, dependent: :nullify

  has_one_attached :logo, dependent: :destroy

  has_rich_text :email_body
  has_rich_text :email_signature

  belongs_to :survey
  belongs_to :employee

  after_create :create_recruit_onramp

  monetize :incentive_cents, allow_nil: true

  def start_create_expert_recruits_job
    CreateExpertRecruitsJob.perform_later(self, survey)
  end

  def email_list
    return if csv_data.blank?

    JSON.parse(csv_data).map(&:first)
  end

  def first_names_and_emails
    first_names_and_emails = {}
    JSON.parse(csv_data).each do |row|
      # row[0] is email, row[1] is the first_name
      first_names_and_emails.merge!(row[0] => row[1])
    end
    first_names_and_emails
  end

  def pasted_first_names_emails
    return if csv_data.blank?

    pasted_first_names_emails = JSON.parse(csv_data)

    pasted_first_names_emails.map do |row|
      row.join(' ')
    end.join("\n")
  end

  def unsubscribed_email_list
    list = []
    email_list.each do |email|
      if sent_at.present?
        next unless email_unsubscribed_before_batch_was_sent?(email)

      elsif ExpertRecruitUnsubscription.find_by(email: email).blank? && Unsubscription.find_by(email: email).blank?
        next
      end
      list << email
    end
    list
  end

  def eligible_email_list
    email_list - unsubscribed_email_list
  end

  def send_reminders
    expert_recruits.unclicked.find_each do |expert_recruit|
      next if expert_recruit.unsubscribed?

      ExpertRecruitReminderDeliveryJob.perform_later(expert_recruit)
      update!(reminders_finished_at: Time.now.utc)
    end
  end

  def reminders_queued?
    reminders_started_at.present? && (Time.now.utc - reminders_started_at < 1.day)
  end

  def reminders_sent?
    reminders_finished_at.present? && (Time.now.utc - reminders_finished_at < 1.day)
  end

  def remindable?
    sent? && !reminders_queued? && !reminders_sent? && one_day_passed?
  end

  def one_day_passed?
    Time.now.utc - sent_at > 1.day
  end

  def sent?
    sent_at.present?
  end

  def view_friendly_csv_data
    return if csv_data.blank?

    JSON.parse(csv_data).map do |row|
      row.join(', ')
    end.join("\n")
  end

  private

  def email_unsubscribed_before_batch_was_sent?(email)
    email_unsubscribed_from_expert_network_before_batch_was_sent?(email) || email_unsubscribed_from_panelist_list_before_batch_was_sent?(email)
  end

  def email_unsubscribed_from_expert_network_before_batch_was_sent?(email)
    ExpertRecruitUnsubscription.find_by(email: email).present? && ExpertRecruitUnsubscription.find_by(email: email).created_at <= sent_at
  end

  def email_unsubscribed_from_panelist_list_before_batch_was_sent?(email)
    Unsubscription.find_by(email: email).present? && Unsubscription.find_by(email: email).created_at <= sent_at
  end

  def create_recruit_onramp
    return if survey.onramps.expert_recruit.present?

    Onramp.create!(
      category: Onramp.categories[:expert_recruit],
      survey: survey,
      check_clean_id: false,
      check_recaptcha: false,
      check_gate_survey: false
    )
  end

  def employee_phone_present?
    return if employee_id.blank?

    employee = Employee.find(employee_id)
    return if employee.phone.present?

    errors.add(:base, 'Employee\'s phone number is missing.')
  end
end
