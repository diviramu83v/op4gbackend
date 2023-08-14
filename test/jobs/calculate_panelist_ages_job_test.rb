# frozen_string_literal: true

require 'test_helper'

# TODO: move this into the panelist model test. Job test should be simpler.
class CalculatePanelistAgesJobTest < ActiveJob::TestCase
  it "age is updated if current date is past 'update_age_at'" do
    panelist = panelists(:standard)
    panelist.birthdate = Time.zone.today - 30.years - 3.days
    panelist.update_age_at = Time.zone.today - 3.days
    panelist.age = 29
    panelist.save!

    CalculatePanelistAgesJob.perform_now

    panelist.reload

    assert panelist.age == 30
  end

  it "age does not change until date passes 'update_age_at'" do
    panelist = panelists(:standard)
    panelist.birthdate = Time.zone.today - 30.years + 3.days
    panelist.update_age_at = Time.zone.today + 3.days
    panelist.age = 29
    panelist.save!

    CalculatePanelistAgesJob.perform_now
    panelist.reload
    assert panelist.age == 29

    travel_to 10.days.from_now

    CalculatePanelistAgesJob.perform_now
    panelist.reload
    assert panelist.age == 30
    travel_back
  end

  it "'update_age_at' and 'age' are populated if birthday is present" do
    panelist = Panelist.create(
      email: Faker::Internet.email,
      password: 'testing123',
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      country: Country.find_by(slug: 'us'),
      original_panel: Panel.find_by(slug: 'op4g-us'),
      primary_panel: Panel.find_by(slug: 'op4g-us'),
      address: Faker::Address.street_name,
      city: Faker::Address.city,
      state: Faker::Address.state_abbr,
      postal_code: Faker::Address.zip.first(5),
      birthdate: Time.zone.today - 35.years - 10.days,
      status: Panelist.statuses[:signing_up],
      clean_id_data: { data: 'blank' }
    )

    CalculatePanelistAgesJob.perform_now

    panelist.reload

    assert panelist.age == 35
    assert panelist.update_age_at == Time.zone.today + 1.year - 10.days
  end
end
