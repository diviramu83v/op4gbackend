# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

# Write these statements so they can be run multiple times without creating the
# same data.

require 'faker'

Rails.logger.info 'Seeding database...'

# Set up a connection for running setup queries
connection = ActiveRecord::Base.connection

# If any command fails, roll back everything.
ActiveRecord::Base.transaction do
  countries = Country.all
  panels = Panel.all

  if Panelist.count.zero?
    jerry = Panelist.create!(
      first_name: 'Jerry',
      last_name: 'Seinfeld',
      email: 'jerry@test.op4g.com',
      password: 'nosoupforyou',
      country: countries.first,
      original_panel: panels.first,
      confirmed_at: Time.now.utc
    )
    george = Panelist.create!(
      first_name: 'George',
      last_name: 'Costanza',
      email: 'george@test.op4g.com',
      password: 'nosoupforyou',
      country: countries.first,
      original_panel: panels.first,
      confirmed_at: Time.now.utc
    )
    elaine = Panelist.create!(
      first_name: 'Elaine',
      last_name: 'Benes',
      email: 'elaine@test.op4g.com',
      password: 'nosoupforyou',
      country: countries.first,
      original_panel: panels.first,
      confirmed_at: Time.now.utc
    )
    kramer = Panelist.create!(
      first_name: 'Cosmo',
      last_name: 'Kramer',
      email: 'kramer@test.op4g.com',
      password: 'nosoupforyou',
      country: countries.first,
      original_panel: panels.first,
      confirmed_at: Time.now.utc
    )

    panelists = [jerry, george, elaine, kramer]

    panels.each do |panel|
      panelists.each do |panelist|
        PanelMembership.create!(panel: panel, panelist: panelist)
      end
    end

    DemoOption.where(label: 'Male').each do |option|
      jerry.add_answer!(option)
      george.add_answer!(option)
      kramer.add_answer!(option)
    end

    DemoOption.where(label: 'Female').each do |option|
      elaine.add_answer!(option)
    end

    DemoOption.where(label: 'Comedy').each do |option|
      jerry.add_answer!(option)
    end

    DemoOption.where(label: 'Architecture').each do |option|
      george.add_answer!(option)
    end

    DemoOption.where(label: 'Baseball').each do |option|
      panelists.each do |panelist|
        panelist.add_answer!(option)
      end
    end
  end

  if Employee.count == 1 # '0' employee has already been created by seeds.rb
    connection.execute("SELECT SETVAL('employees_id_seq'::regclass,1,false)") # reset the sequence to 1

    Employee.create!([ # password for generic employees = 'RKSv-JT9oVW3nYpnOQkcVQ'
                       { first_name: 'Chris',
                         last_name: 'Stearns',
                         email: 'chris@test.op4g.com',
                         password: 'Example1' },
                       { first_name: 'Don',
                         last_name: 'Wasylyk',
                         email: 'don@test.op4g.com',
                         password: 'Example1' },
                       { first_name: 'Ryan',
                         last_name: 'Strickler',
                         email: 'ryan@test.op4g.com',
                         password: 'Example1' },
                       { first_name: 'Zac',
                         last_name: 'Williams',
                         email: 'zac@test.op4g.com',
                         password: 'Example1' },
                       { first_name: 'Dave',
                         last_name: 'Miner',
                         email: 'dave@test.op4g.com',
                         password: 'Example1' },
                       { first_name: 'Spenser',
                         last_name: 'Tingey',
                         email: 'spenser@test.op4g.com',
                         password: 'Example1' },
                       { first_name: 'Admin',
                         last_name: 'Employee',
                         email: 'admin@test.op4g.com',
                         password: 'Example1' },
                       { first_name: 'Recruitment',
                         last_name: 'Employee',
                         email: 'recruitment@test.op4g.com',
                         password: 'Example1' },
                       { first_name: 'Nonprofits',
                         last_name: 'Employee',
                         email: 'nonprofits@test.op4g.com',
                         password: 'Example1' },
                       { first_name: 'Sales',
                         last_name: 'Employee',
                         email: 'sales@test.op4g.com',
                         password: 'Example1' },
                       { first_name: 'Operations',
                         last_name: 'Employee',
                         email: 'operations@test.op4g.com',
                         password: 'Example1' },
                       { first_name: 'Operations Manager',
                         last_name: 'Employee',
                         email: 'operations-manager@test.op4g.com',
                         password: 'Example1' },
                       { first_name: 'Membership',
                         last_name: 'Employee',
                         email: 'membership@test.op4g.com',
                         password: 'Example1' },
                       { first_name: 'Payment',
                         last_name: 'Employee',
                         email: 'payment@test.op4g.com',
                         password: 'Example1' },
                       { first_name: 'Reporting',
                         last_name: 'Employee',
                         email: 'reporting@test.op4g.com',
                         password: 'Example1' },
                       { first_name: 'Security',
                         last_name: 'Employee',
                         email: 'security@test.op4g.com',
                         password: 'Example1' }
                     ])
  end

  if EmployeeRole.count.zero?
    EmployeeRole.create!([ # Chris' admin
                           { employee: Employee.find_by(email: 'chris@test.op4g.com'),
                             role: Role.find_by(name: 'Admin') },
                           # Don's  admin
                           { employee: Employee.find_by(email: 'don@test.op4g.com'),
                             role: Role.find_by(name: 'Admin') },
                           # Ryan's admin
                           { employee: Employee.find_by(email: 'ryan@test.op4g.com'),
                             role: Role.find_by(name: 'Admin') },
                           # Zac's admin
                           { employee: Employee.find_by(email: 'zac@test.op4g.com'),
                             role: Role.find_by(name: 'Admin') },
                           # Dave's admin
                           { employee: Employee.find_by(email: 'dave@test.op4g.com'),
                             role: Role.find_by(name: 'Admin') },
                           # Spenser's admin
                           { employee: Employee.find_by(email: 'spenser@test.op4g.com'),
                             role: Role.find_by(name: 'Admin') },
                           { employee: Employee.find_by(email: 'admin@test.op4g.com'),
                             role: Role.find_by(name: 'Admin') },
                           { employee: Employee.find_by(email: 'nonprofits@test.op4g.com'),
                             role: Role.find_by(name: 'Nonprofits') },
                           { employee: Employee.find_by(email: 'recruitment@test.op4g.com'),
                             role: Role.find_by(name: 'Recruitment') },
                           { employee: Employee.find_by(email: 'sales@test.op4g.com'),
                             role: Role.find_by(name: 'Sales') },
                           { employee: Employee.find_by(email: 'operations@test.op4g.com'),
                             role: Role.find_by(name: 'Operations') },
                           { employee: Employee.find_by(email: 'operations-manager@test.op4g.com'),
                             role: Role.find_by(name: 'Operations') },
                           { employee: Employee.find_by(email: 'operations-manager@test.op4g.com'),
                             role: Role.find_by(name: 'Operations manager') },
                           { employee: Employee.find_by(email: 'membership@test.op4g.com'),
                             role: Role.find_by(name: 'Membership') },
                           { employee: Employee.find_by(email: 'payment@test.op4g.com'),
                             role: Role.find_by(name: 'Payment') },
                           { employee: Employee.find_by(email: 'reporting@test.op4g.com'),
                             role: Role.find_by(name: 'Reporting') },
                           { employee: Employee.find_by(email: 'security@test.op4g.com'),
                             role: Role.find_by(name: 'Security') }
                         ])
  end

  if Client.count.zero?
    20.times do
      Client.create!(name: Faker::Company.unique.name)
    end
  end

  if Project.count.zero?
    def fake_project_name
      Faker::Company.catch_phrase
    end

    def fake_survey_name
      "#{Faker::Job.field} study"
    end

    def random_client
      Client.all[rand(Client.all.count)]
    end

    def random_product
      Product.all[rand(Product.all.count)]
    end

    def random_salesperson
      Employee.with_role('Sales')[rand(Employee.with_role('Sales').count)]
    end

    def random_project_manager
      Employee.with_role('Operations')[rand(Employee.with_role('Operations').count)]
    end

    def add_second_survey(project)
      project.surveys.first.update!(name: fake_survey_name)
      project.surveys.create!(name: fake_survey_name)
    end

    def add_required_project_attributes(project)
      project.update!(
        work_order: Faker::Number.number(digits: 4),
        salesperson: random_salesperson,
        client: random_client,
        product: random_product
      )
      project.surveys.each { |survey| add_required_survey_attributes(survey) }
    end

    def add_required_survey_attributes(survey)
      survey.update!(
        target: Faker::Number.number(digits: 4),
        cpi: Faker::Number.decimal(l_digits: 2),
        loi: rand(2..31),
        base_link: "#{Faker::Internet.url}{{uid}}"
      )
    end

    def update_project_status(project, slug)
      project.update!(status: slug)
    end

    def validate_project(project)
      project.validate!
      project.surveys.each { |survey| validate_survey(survey) }
    end

    def validate_survey(survey)
      survey.validate!
      # survey.?.each { |?| ?.validate! }
    end

    5.times do
      project = Project.create(name: "#{fake_project_name} [live/complex]", manager: random_project_manager)
      add_second_survey(project)
      add_required_project_attributes(project)
      update_project_status(project, 'live')
      validate_project(project)

      project = Project.create(name: "#{fake_project_name} [draft/complex]", manager: random_project_manager)
      add_second_survey(project)
      validate_project(project)

      project = Project.create(name: "#{fake_project_name} [live/minimal]", manager: random_project_manager)
      add_required_project_attributes(project)
      update_project_status(project, 'live')
      validate_project(project)

      project = Project.create(name: "#{fake_project_name} [draft/minimal]", manager: random_project_manager)
      validate_project(project)
    end

    600.times do
      project = Project.create(name: "#{fake_project_name} [live/minimal]", manager: random_project_manager)
      add_required_project_attributes(project)
      update_project_status(project, 'live')
      validate_project(project)
    end

    if VendorBatch.count.zero?
      VendorBatch.create!([{
                            vendor_id: Vendor.first.id,
                            incentive_cents: 150,
                            complete_url: 'https://test.op4g.com?test=',
                            terminate_url: 'https://test.op4g.com?test=',
                            overquota_url: 'https://test.op4g.com?test='
                          }])
    end

    Onramp.create!([{ token: 'token', survey: Survey.first, vendor_batch_id: VendorBatch.first.id }]) if Onramp.count.zero?

    if Onboarding.count.zero?
      Onboarding.create!([{ onramp_id: Onramp.first.id,
                            uid: 'uid1',
                            token: 'token1',
                            recaptcha_token: 'recaptchaToken1',
                            gate_survey_token: 'gateSurveyToken1',
                            ip_address: IpAddress.find_or_create_by(address: '1.1.1.1'),
                            initial_project_status: 'draft' },
                          { onramp_id: Onramp.first.id,
                            uid: 'uid2',
                            token: 'token2',
                            recaptcha_token: 'recaptchaToken2',
                            gate_survey_token: 'gateSurveyToken2',
                            ip_address: IpAddress.find_or_create_by(address: '1.1.1.1'),
                            initial_project_status: 'draft' },
                          { onramp_id: Onramp.first.id,
                            uid: 'uid3',
                            token: 'token3',
                            recaptcha_token: 'recaptchaToken3',
                            gate_survey_token: 'gateSurveyToken3',
                            ip_address: IpAddress.find_or_create_by(address: '1.1.1.1'),
                            initial_project_status: 'draft' }])
    end
  end
end

Rails.logger.info 'Database seeded with dummy data'
