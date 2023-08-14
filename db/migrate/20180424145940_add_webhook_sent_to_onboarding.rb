# frozen_string_literal: true

class AddWebhookSentToOnboarding < ActiveRecord::Migration[5.1]
  def change
    add_column :onboardings, :webhook_notification_sent_at, :datetime
  end
end
