# frozen_string_literal: true

bad_birthday_panelists = Panelist.where('age < ? OR birthdate > ?', 13, Time.zone.today - 13.years)

# rubocop:disable Rails/SkipsModelValidations
bad_birthday_panelists.find_each { |p| p.update_columns(age: nil, birthdate: nil, update_age_at: nil) }
# rubocop:enable Rails/SkipsModelValidations
