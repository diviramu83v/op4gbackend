# frozen_string_literal: true

require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  describe 'attributes' do
    subject { payments(:one) }

    should belong_to(:payment_upload_batch).optional
  end

  describe 'validations' do
    subject { payments(:one) }

    should validate_presence_of(:paid_at)
  end
end
