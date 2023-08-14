# frozen_string_literal: true

# an unsubscription is a record of a panelist opting out of receiving emails from op4g
class Unsubscription < ApplicationRecord
  belongs_to :panelist

  def self.to_csv
    CSV.generate do |csv|
      csv << ['Email', 'Unsubscribe Date']

      all.find_each do |unsubscription|
        csv << [unsubscription.email, unsubscription.created_at.strftime('%m/%d/%Y')]
      end
    end
  end
end
