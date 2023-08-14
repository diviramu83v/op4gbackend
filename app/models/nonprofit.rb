# frozen_string_literal: true

# Represents a nonprofit member organization.
class Nonprofit < ApplicationRecord
  include RecruitmentSourceReport
  include RecruitingStats
  include LifecycleStats
  include PanelistNetProfit
  include CompletesFunnel

  STATE_OPTIONS = {
    'United States' => %w[
      AK AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN
      MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX UT VA VT WA
      WI WV WY
    ],
    'Canada' => %w[A B C],
    'United Kingdom' => %w[X Y Z]
  }.freeze

  has_attached_file :logo, Rails.configuration.paperclip_nonprofits

  validates_attachment_content_type :logo, content_type: ['image/jpeg', 'image/png', 'image/gif']

  belongs_to :country

  has_many :campaigns, as: :campaignable, dependent: :restrict_with_exception, inverse_of: :campaignable,
                       class_name: 'RecruitingCampaign'
  has_many :panelists, dependent: :restrict_with_exception, inverse_of: :nonprofit, class_name: 'Panelist'
  has_many :onboardings, through: :panelists
  has_many :onramps, through: :onboardings
  has_many :surveys, through: :onramps
  has_many :original_panelists, dependent: :restrict_with_exception, inverse_of: :original_nonprofit,
                                class_name: 'Panelist', foreign_key: :original_nonprofit_id
  has_many :archived_panelists, dependent: :restrict_with_exception, inverse_of: :archived_nonprofit,
                                class_name: 'Panelist', foreign_key: :archived_nonprofit_id
  has_many :donations, dependent: :restrict_with_exception, class_name: 'Earning', inverse_of: :nonprofit

  scope :active, -> { where(archived_at: nil) }
  scope :qualified, -> { where(fully_qualified: true) }
  scope :order_by_name, -> { order(:name) }

  validates :name, presence: true
  # Turn this on after legacy data is imported.
  # validates :address_line_1, :city, :state, :zip_code, presence: true

  def any_contact_info?
    contact_name.present? || contact_title.present? || contact_email.present? || contact_phone.present?
  end

  def any_manager_info?
    manager_name.present? || manager_email.present?
  end

  def donation_total_with_adjustment
    (donations.active.sum(:nonprofit_amount_cents) + earning_adjustment_cents) / 100.0
  end

  def signed_up_panelists_count
    original_panelists.completed_signup.count
  end

  def active_current_panelists
    panelists.active
  end

  def active_original_panelists
    original_panelists.active
  end

  def original_panelists_grouped_by_month
    original_panelists.completed_signup.select("date_trunc('month', created_at) as month, count(*) as count")
                      .group('month')
  end

  # rubocop:disable Metrics/MethodLength
  def archive
    ActiveRecord::Base.transaction do
      if update(archived_at: Time.now.utc)
        panelists.find_each do |p|
          p.update!(nonprofit: nil, donation_percentage: 0, archived_nonprofit: self)
        rescue ActiveRecord::RecordInvalid
          # rubocop:disable Rails/SkipsModelValidations
          p.update_column('nonprofit_id', nil)
          p.update_column('donation_percentage', 0)
          p.update_column('archived_nonprofit_id', id)
          # rubocop:enable Rails/SkipsModelValidations
        end

        true
      else
        false
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def self.generate_earnings_report(start_month, start_year, end_month, end_year)
    report_periods = []

    current_year = start_year.to_i
    current_month = start_month.to_i

    loop do
      leading_zero = ''
      leading_zero = '0' if current_month < 10
      report_periods << "'#{current_year}-#{leading_zero}#{current_month}'"

      if current_month < 12
        current_month += 1
      else
        current_year += 1
        current_month = 1
      end
      break if (current_month > end_month.to_i && current_year >= end_year.to_i) || current_year > end_year.to_i
    end

    nonprofit_earnings_query = <<-SQL.squish
      SELECT
        nonprofits.id,
        nonprofits.name,
        SUM(nonprofit_amount_cents) / 100.0 AS earnings
      FROM
        earnings
        LEFT JOIN panelists ON earnings.panelist_id = panelists.id
        LEFT OUTER JOIN nonprofits ON earnings.nonprofit_id = nonprofits.id
      WHERE
        earnings.period IN (#{report_periods.join(', ')})
        AND earnings.nonprofit_amount_cents > 0
      GROUP BY
        nonprofits.id,
        nonprofits.name
      ORDER BY
        nonprofits.name;
    SQL

    ActiveRecord::Base.connection.exec_query(nonprofit_earnings_query)
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  # rubocop:disable Metrics/MethodLength
  def self.build_earnings_csv(contents)
    CSV.generate do |csv|
      csv << %w[Id Name Earnings]

      contents.rows.sort_by(&:first).reverse.each do |result|
        csv << result.each do |cell|
          if cell.to_s.include?('-')
            cell
          else
            cell.to_f.round(2)
          end
        end
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
end
