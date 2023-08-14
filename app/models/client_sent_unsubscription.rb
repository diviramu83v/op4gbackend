# frozen_string_literal: true

# A client sent unsubscription is a record of a client sent survey invitation opting to not be contacted.
class ClientSentUnsubscription < ApplicationRecord
  belongs_to :client_sent_survey_invitation

  def self.to_csv
    CSV.generate do |csv|
      csv << ['Email', 'Unsubscribe Date']

      all.find_each do |unsubscription|
        csv << [unsubscription.email, unsubscription.created_at.strftime('%m/%d/%Y')]
      end
    end
  end
end
