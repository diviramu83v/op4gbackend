# frozen_string_literal: true

task delete_bad_birthdate_data: :environment do
  email_text = CSV.read('lib/data/email_list.csv', headers: true)

  email_text.each do |row|
    panelist = Panelist.find_by(email: row[0])
    panelist.update!(birthdate: '', age: '', update_age_at: '')
  end
end
