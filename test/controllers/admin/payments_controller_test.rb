# frozen_string_literal: true

require 'test_helper'

class Admin::PaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_employee = employees(:admin)
    sign_in @admin_employee
  end

  it 'view payment batch list' do
    3.times do
      PaymentUploadBatch.create(
        employee: employees(:operations),
        paid_at: Time.now.utc,
        period: '2020-01',
        payment_data: "#{Panelist.last.email}\t$55.39\r\n#{Panelist.first.email}\t$20.91"
      )
    end

    get payments_url

    assert_response :ok
    assert_template :index
  end

  it 'view payment batch form' do
    get new_payment_url

    assert_response :ok
    assert_template :new
  end

  it 'payment batch form success' do
    batch_params = payment_upload_batches(:one).attributes

    assert_difference -> { PaymentUploadBatch.count } do
      post payments_url, params: { payment_upload_batch: batch_params }
    end
    assert_redirected_to payments_url
    assert_nil flash[:alert]
  end

  it 'payment batch form success with some row errors' do
    batch_params = payment_upload_batches(:error).attributes

    assert_difference -> { PaymentUploadBatch.count } do
      post payments_url, params: { payment_upload_batch: batch_params }
    end
    assert_redirected_to payments_url
    assert_not_nil flash[:alert]
  end

  it 'payment batch records employee who creates it' do
    batch_params = payment_upload_batches(:one).attributes

    post payments_url, params: { payment_upload_batch: batch_params }
    new_batch = PaymentUploadBatch.last

    assert_equal @admin_employee, new_batch.employee
  end

  it 'payment batch form failure' do
    batch_params = payment_upload_batches(:one).attributes
    batch_params[:period] = nil

    assert_no_difference -> { PaymentUploadBatch.count } do
      post payments_url, params: { payment_upload_batch: batch_params }
    end
    assert_template :new
  end
end
