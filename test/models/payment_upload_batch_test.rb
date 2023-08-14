# frozen_string_literal: true

require 'test_helper'

class PaymentUploadBatchTest < ActiveSupport::TestCase
  describe 'attributes' do
    subject { payment_upload_batches(:one) }

    should have_db_column(:paid_at)
    should have_db_column(:period)
    should have_db_column(:payment_data)
    should have_db_column(:error_data)
  end

  describe 'associations' do
    subject { payment_upload_batches(:one) }

    should belong_to(:employee)
    should have_many(:payments)
  end

  describe 'validations' do
    subject { payment_upload_batches(:one) }

    should validate_presence_of(:paid_at)
    should validate_presence_of(:period)
    should validate_presence_of(:payment_data)
  end

  describe 'automatic payment creation' do
    setup do
      @batch = PaymentUploadBatch.create(
        employee: employees(:operations),
        paid_at: Time.now.utc,
        period: '2020-01',
        payment_data: "#{Panelist.last.email}\t$55.39\r\n#{Panelist.first.email}\t$20.91\r\n#{Panelist.first.email}\t$20.91"
      )
    end

    it 'creates payments successfully' do
      assert_equal @batch.payments.count, 3
      assert_nil @batch.error_data
    end

    it 'does not unsuspend newly paid panelists' do
      panelist = panelists(:standard)
      panelist.suspended!
      assert panelist.suspended?

      PaymentUploadBatch.create(
        employee: employees(:operations),
        paid_at: Time.now.utc,
        period: '2020-01',
        payment_data: "#{panelist.email}\t$#{Faker::Number.decimal(l_digits: 2, r_digits: 2)}"
      )
      panelist.reload

      assert panelist.suspended?
    end

    it 'error rows stored in error data' do
      batch = PaymentUploadBatch.create(
        employee: employees(:operations),
        paid_at: Time.now.utc,
        period: '2020-01',
        payment_data: "#{Panelist.last.email}\t$55.39\r\nnobodysemail@notanemail.com\t$20.91"
      )

      assert_equal batch.payments.count, 1
      assert_not_nil batch.error_data
    end
  end

  describe '#payment_count' do
    it 'reflects payment count' do
      batch = payment_upload_batches(:one)
      batch.payments.delete_all
      assert_equal batch.payment_count, 0

      batch.payments << payments(:one)
      assert_equal batch.payment_count, 1

      3.times do
        batch.payments << Payment.create(
          panelist: panelists(:standard),
          amount_cents: 100,
          paid_at: Time.zone.now,
          period: Time.zone.now,
          period_year: Time.zone.now.year
        )
      end
      assert_equal batch.payment_count, 4
    end
  end

  describe '#payment_total' do
    it 'reflects total of all payments' do
      batch = payment_upload_batches(:one)
      batch.payments.delete_all
      assert_equal batch.payment_total, 0

      payments = []
      3.times do
        payments << Payment.create(
          panelist: panelists(:standard),
          amount_cents: 100,
          paid_at: Time.zone.now,
          period: Time.zone.now,
          period_year: Time.zone.now.year
        )
      end
      total = payments.sum(&:amount)

      batch.payments << payments
      assert_equal batch.payment_total, total
    end
  end

  describe '#employee_name' do
    it 'shows the name of the employee related to the batch' do
      batch = payment_upload_batches(:one)
      employee = batch.employee

      assert_equal batch.employee_name, employee.name
    end
  end

  describe '#error_data' do
    it 'is normally nil' do
      batch = payment_upload_batches(:one)

      assert_nil batch.error_data
    end

    it "records rows that don't create a payment" do
      panelist = panelists(:standard)
      batch = PaymentUploadBatch.create(
        employee: employees(:operations),
        paid_at: Time.now.utc,
        period: '2020-01',
        payment_data: "garbage_data\r\n#{panelist.email}\t$#{Faker::Number.decimal(l_digits: 2, r_digits: 2)}\r\njunk data\tmore junk"
      )

      assert_equal batch.error_data, "garbage_data\r\njunk data\tmore junk"
    end
  end
end
