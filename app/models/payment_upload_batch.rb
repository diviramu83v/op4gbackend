# frozen_string_literal: true

# A payment upload batch tracks group of payments uploaded into the system.
class PaymentUploadBatch < ApplicationRecord
  belongs_to :employee

  has_many :payments, dependent: :restrict_with_exception

  validates :paid_at, :period, :payment_data, presence: true

  after_create :convert_payment_data_to_payment_records

  scope :most_recent_first, -> { order('created_at DESC') }

  delegate :name, to: :employee, prefix: true

  def payment_count
    payments.count
  end

  def payment_total
    payments.sum(&:amount)
  end

  private

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def convert_payment_data_to_payment_records
    period_year = period[0..3]

    error_rows = []

    rows = payment_data.split("\r\n")
    rows.each do |row|
      data = row.split("\t")

      email = data[0].strip.downcase
      amount = data[1].strip.delete('$') if data[1].present?
      panelist = Panelist.find_by(email: email)

      payment = payments.new(
        panelist: panelist,
        amount: amount,
        paid_at: paid_at,
        period: period,
        period_year: period_year
      )

      unless payment.save
        payment.delete
        error_rows << row
      end
    end

    update!(error_data: error_rows.join("\r\n")) if error_rows.any?
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
