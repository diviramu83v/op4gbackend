# frozen_string_literal: true

require 'test_helper'

class IpEventTest < ActiveSupport::TestCase
  describe 'associations' do
    subject { ip_events(:standard) }

    should belong_to(:ip).class_name('IpAddress')
  end

  describe 'columns' do
    subject { ip_events(:standard) }

    should have_db_column(:message)
  end

  describe 'validations' do
    subject { ip_events(:standard) }

    should belong_to(:ip)
    should validate_presence_of(:message)
  end
end
