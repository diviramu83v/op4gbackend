# frozen_string_literal: true

# An expert recruit unsubscription is a record of an expert recruit choosing to not be contacted.
class ExpertRecruitUnsubscription < ApplicationRecord
  belongs_to :expert_recruit

  def self.to_csv
    CSV.generate do |csv|
      csv << ['Email', 'Unsubscribe Date']

      all.find_each do |unsubscription|
        csv << [unsubscription.email, unsubscription.created_at.strftime('%m/%d/%Y')]
      end
    end
  end
end
