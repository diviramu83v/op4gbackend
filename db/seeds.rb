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
  panels =
    if Panel.count.zero?
      connection.execute("SELECT SETVAL('panels_id_seq'::regclass,1,false)") # reset the sequence to 1

      Panel.create!([
        { name: 'Op4G', slug: 'op4g' },
        { name: 'OPlus', abbreviation: 'OP', slug: 'oplus' },
      ])
    else
      Panel.all.to_a
    end

  if Country.count.zero?
    connection.execute("SELECT SETVAL('countries_id_seq'::regclass,1,false)") # reset the sequence to 1

    countries = Country.create!([
      { name: 'United States',  slug: 'us', nonprofit_flag: true },
      { name: 'Canada',         slug: 'ca', nonprofit_flag: true },
      { name: 'United Kingdom', slug: 'uk', nonprofit_flag: true },
      { name: 'Germany',        slug: 'de' },
      { name: 'France',         slug: 'fr' },
      { name: 'Spain',          slug: 'es' },
      { name: 'Italy',          slug: 'it' },
      { name: 'Australia',      slug: 'au' },
    ])

    # Op4G gets three countries
    countries[0..2].each do |country|
      PanelCountry.create!(panel: Panel.find_by(name: 'Op4G'), country: country)
    end

    # OPlus gets all countries
    countries.each do |country|
      PanelCountry.create!(panel: Panel.find_by(name: 'OPlus'), country: country)
    end
  end

  if DemoQuestionsCategory.count.zero?
    oplus = Panel.find_by(name: 'OPlus')

    connection.execute("SELECT SETVAL('demo_questions_categories_id_seq'::regclass,1,false)") # reset the sequence to 1

    DemoQuestionsCategory.create!([
      { panel: oplus, name: 'Personal', slug: 'personal', sort_order: 1 },
      { panel: oplus, name: 'Work', slug: 'work', sort_order: 2 },
      { panel: oplus, name: 'Family', slug: 'family', sort_order: 3 },
    ])

    op4g = Panel.find_by(name: 'Op4G')

    DemoQuestionsCategory.create!([
      { panel: op4g, name: 'About Me',    slug: 'about-me',     sort_order: 1 },
      { panel: op4g, name: 'Education',   slug: 'education',    sort_order: 1 },
      { panel: op4g, name: 'Job',         slug: 'job',          sort_order: 1 },
      { panel: op4g, name: 'Household',   slug: 'household',    sort_order: 1 },
      { panel: op4g, name: 'Purchasing',  slug: 'purchasing',   sort_order: 1 },
      { panel: op4g, name: 'Electronics', slug: 'electronics',  sort_order: 1 },
      { panel: op4g, name: 'Online',      slug: 'online',       sort_order: 1 },
      { panel: op4g, name: 'Food',        slug: 'food',         sort_order: 1 },
      { panel: op4g, name: 'Lifestyle',   slug: 'lifestyle',    sort_order: 1 },
      { panel: op4g, name: 'Medical',     slug: 'medical',      sort_order: 1 },
      { panel: op4g, name: 'Financial',   slug: 'financial',    sort_order: 1 },
      { panel: op4g, name: 'Politics',    slug: 'politics',     sort_order: 1 },
    ])
  end

  about_me_category_id = DemoQuestionsCategory.where(slug: 'about-me').pick('id')
  education_category_id = DemoQuestionsCategory.where(slug: 'education').pick('id')
  job_category_id = DemoQuestionsCategory.where(slug: 'job').pick('id')
  household_category_id = DemoQuestionsCategory.where(slug: 'household').pick('id')
  purchasing_category_id = DemoQuestionsCategory.where(slug: 'purchasing').pick('id')
  electronics_category_id = DemoQuestionsCategory.where(slug: 'electronics').pick('id')
  online_category_id = DemoQuestionsCategory.where(slug: 'online').pick('id')
  food_category_id = DemoQuestionsCategory.where(slug: 'food').pick('id')
  lifestyle_category_id = DemoQuestionsCategory.where(slug: 'lifestyle').pick('id')
  medical_category_id = DemoQuestionsCategory.where(slug: 'medical').pick('id')
  financial_category_id = DemoQuestionsCategory.where(slug: 'financial').pick('id')
  politics_category_id = DemoQuestionsCategory.where(slug: 'politics').pick('id')

  op4g_questions =
    if DemoQuestion.count.zero?
      connection.execute("SELECT SETVAL('demo_questions_id_seq'::regclass,1,false)") # reset the sequence to 1

      DemoQuestion.create!([
        # About Me
        {
          panel: panels.first,
          label: 'Gender',
          import_label: 'gender',
          body: 'What is your gender?',
          input_type: 'radio',
          demo_questions_category_id: about_me_category_id,
          sort_order: 1
        },
        # {
        #   panel: panels.first,
        #   label: 'Activities',
        #   import_label: 'activities',
        #   body: 'What activities do you enjoy?',
        #   input_type: 'multiple',
        #   demo_questions_category_id: about_me_category_id,
        #   sort_order: 2
        # },
        {
          panel: panels.first,
          label: 'Marital',
          import_label: 'marital_status',
          body: 'What is your current marital status?',
          input_type: 'single',
          demo_questions_category_id: about_me_category_id,
          sort_order: 2
        },
        {
          panel: panels.first,
          label: 'Origin',
          import_label: 'latino',
          body: 'Are you of Hispanic, Latino, or Spanish origin?',
          input_type: 'single',
          demo_questions_category_id: about_me_category_id,
          sort_order: 3
        },
        {
          panel: panels.first,
          label: 'Race',
          import_label: 'race',
          body: 'What race do you consider yourself?',
          input_type: 'single',
          demo_questions_category_id: about_me_category_id,
          sort_order: 4
        },
        {
          panel: panels.first,
          label: 'Orientation',
          import_label: 'sexuality',
          body: 'What is your sexual orientation?',
          input_type: 'single',
          demo_questions_category_id: about_me_category_id,
          sort_order: 5
        },
        {
          panel: panels.first,
          label: 'Worth',
          import_label: 'individual_net_worth',
          body: 'Individual net worth excluding home and autos',
          input_type: 'single',
          demo_questions_category_id: about_me_category_id,
          sort_order: 6
        },
        {
          panel: panels.first,
          label: 'License',
          import_label: 'valid_drivers_license',
          body: 'Do you have an active driver\'s license?',
          input_type: 'radio',
          demo_questions_category_id: about_me_category_id,
          sort_order: 7
        },
        {
          panel: panels.first,
          label: 'Car',
          import_label: 'own_or_lease_vehicle',
          body: 'Do you own or lease a vehicle?',
          input_type: 'radio',
          demo_questions_category_id: about_me_category_id,
          sort_order: 8
        },
        {
          panel: panels.first,
          label: 'Share',
          import_label: 'share',
          body: 'Do you use a car sharing service?',
          input_type: 'radio',
          demo_questions_category_id: about_me_category_id,
          sort_order: 9
        },

        # Education
        {
          panel: panels.first,
          label: 'Education',
          import_label: 'education',
          body: 'What is the highest level of education you have completed?',
          input_type: 'single',
          demo_questions_category_id: education_category_id,
          sort_order: 10
        },
        {
          panel: panels.first,
          label: 'Enrolled',
          import_label: 'student',
          body: 'Are you currently enrolled as a student in any academic institution?',
          input_type: 'radio',
          demo_questions_category_id: education_category_id,
          sort_order: 11
        },

        # Job
        {
          panel: panels.first,
          label: 'Self-Employed',
          import_label: 'self_employed',
          body: 'Do you receive at least some of your personal income through self-employment?',
          input_type: 'radio',
          demo_questions_category_id: job_category_id,
          sort_order: 12
        },
        {
          panel: panels.first,
          label: 'Employment',
          import_label: 'employment_status',
          body: 'What is your current employment status?',
          input_type: 'single',
          demo_questions_category_id: job_category_id,
          sort_order: 13
        },
        {
          panel: panels.first,
          label: 'Industry',
          import_label: 'industry',
          body: 'Which best describes the organization or industry in which you work?',
          input_type: 'single',
          demo_questions_category_id: job_category_id,
          sort_order: 14
        },
        {
          panel: panels.first,
          label: 'Title',
          import_label: 'job_title',
          body: 'Which best describes your job title?',
          input_type: 'single',
          demo_questions_category_id: job_category_id,
          sort_order: 15
        },
        {
          panel: panels.first,
          label: 'Occupation',
          import_label: 'occupation',
          body: 'Which best describes your occupation?',
          input_type: 'single',
          demo_questions_category_id: job_category_id,
          sort_order: 16
        },
        {
          panel: panels.first,
          label: 'Workplace',
          import_label: 'work_place',
          body: 'Where do you primarily work?',
          input_type: 'single',
          demo_questions_category_id: job_category_id,
          sort_order: 17
        },
        {
          panel: panels.first,
          label: 'Computers',
          import_label: 'number_of_computers_in_all_company_locations',
          body: 'Number of computers at all company locations worldwide',
          input_type: 'single',
          demo_questions_category_id: job_category_id,
          sort_order: 18
        },
        {
          panel: panels.first,
          label: 'Employees',
          import_label: 'size_of_company_in_number_of_employees',
          body: 'Size of company in total number of employees at all locations',
          input_type: 'single',
          demo_questions_category_id: job_category_id,
          sort_order: 19
        },
        {
          panel: panels.first,
          label: 'Revenue',
          import_label: 'size_of_company_in_revenue_dollars',
          body: 'Size of company in revenue dollars',
          input_type: 'single',
          demo_questions_category_id: job_category_id,
          sort_order: 20
        },

        # Household
        {
          panel: panels.first,
          label: 'Children',
          import_label: 'children',
          body: 'How many children do you have under the age of 18?',
          input_type: 'single',
          demo_questions_category_id: household_category_id,
          sort_order: 21
        },
        {
          panel: panels.first,
          label: 'Under_6',
          import_label: 'num_living_in_household_under_6',
          body: 'Under 6 years old',
          input_type: 'single',
          demo_questions_category_id: household_category_id,
          sort_order: 22
        },
        {
          panel: panels.first,
          label: '6_to_11',
          import_label: 'num_living_in_household_from_6_to_11',
          body: 'From 6-11 years old',
          input_type: 'single',
          demo_questions_category_id: household_category_id,
          sort_order: 23
        },
        {
          panel: panels.first,
          label: '12_to_17',
          import_label: 'num_living_in_household_from_12_to_17',
          body: 'From 12-17 years old',
          input_type: 'single',
          demo_questions_category_id: household_category_id,
          sort_order: 24
        },
        {
          panel: panels.first,
          label: '18_to_24',
          import_label: 'num_living_in_household_from_18_to_24',
          body: 'From 18-24 years old',
          input_type: 'single',
          demo_questions_category_id: household_category_id,
          sort_order: 25
        },
        {
          panel: panels.first,
          label: '25_and_up',
          import_label: 'num_living_in_household_over_25',
          body: '25 years and older',
          input_type: 'single',
          demo_questions_category_id: household_category_id,
          sort_order: 26
        },
        {
          panel: panels.first,
          label: 'Residence',
          import_label: 'home_occupation',
          body: 'Do you own or rent your current residence?',
          input_type: 'single',
          demo_questions_category_id: household_category_id,
          sort_order: 27
        },
        {
          panel: panels.first,
          label: 'Income',
          import_label: 'household_income',
          body: 'What is your total annual household income, before taxes?',
          input_type: 'single',
          demo_questions_category_id: household_category_id,
          sort_order: 28
        },

        # Purchasing
        {
          panel: panels.first,
          label: 'Day_to_day_purchases',
          import_label: 'daily_purchasing',
          body: 'Who in your household is responsible for making the majority of the decisions about day-to-day purchases?',
          input_type: 'single',
          demo_questions_category_id: purchasing_category_id,
          sort_order: 29
        },
        {
          panel: panels.first,
          label: 'Large_purchases',
          import_label: 'large_purchasing',
          body: 'Who in your household is responsible for making the majority of the decisions about large purchases?',
          input_type: 'single',
          demo_questions_category_id: purchasing_category_id,
          sort_order: 30
        },

        # Duplicate from 'About Me'...
        {
          panel: panels.first,
          label: 'Vehicle',
          import_label: 'vehicle',
          body: 'Do you own or lease a vehicle?',
          input_type: 'radio',
          demo_questions_category_id: purchasing_category_id,
          sort_order: 31
        },
        {
          panel: panels.first,
          label: 'New_Vehicle',
          import_label: 'new_vehicle',
          body: 'Do you plan to buy or lease a NEW vehicle?',
          input_type: 'single',
          demo_questions_category_id: purchasing_category_id,
          sort_order: 32
        },
        {
          panel: panels.first,
          label: 'Used_Vehicle',
          import_label: 'used_vehicle',
          body: 'Do you plan to buy or lease a used vehicle?',
          input_type: 'single',
          demo_questions_category_id: purchasing_category_id,
          sort_order: 33
        },
        {
          panel: panels.first,
          label: 'Mobile_Phone',
          import_label: 'mobile_phone',
          body: 'Basic mobile device or phone',
          input_type: 'single',
          demo_questions_category_id: purchasing_category_id,
          sort_order: 34
        },
        {
          panel: panels.first,
          label: 'Smart_Phone',
          import_label: 'purchase_smart_phone',
          body: 'Smart phone (iPhone, Blackberry, etc.)',
          input_type: 'single',
          demo_questions_category_id: purchasing_category_id,
          sort_order: 35
        },
        {
          panel: panels.first,
          label: 'Portable_Gaming',
          import_label: 'purchase_portable_gaming_device',
          body: 'Portable gaming device (PSP, etc.)',
          input_type: 'single',
          demo_questions_category_id: purchasing_category_id,
          sort_order: 36
        },
        # {
        #   panel: panels.first,
        #   label: 'Portable_Dvd',
        #   import_label: 'purchase_portable_dvd_player',
        #   body: 'Portable DVD player',
        #   input_type: 'single',
        #   demo_questions_category_id: purchasing_category_id,
        #   sort_order: 37
        # },
        # {
        #   panel: panels.first,
        #   label: 'Portable_Blu-ray',
        #   import_label: 'purchase_portable_bluray_player',
        #   body: 'Portable Blu-Ray player',
        #   input_type: 'single',
        #   demo_questions_category_id: purchasing_category_id,
        #   sort_order: 38
        # },
        # {
        #   panel: panels.first,
        #   label: 'Portable_Mediplayer',
        #   import_label: 'purchase_portable_media_player',
        #   body: 'Portable mediplayer',
        #   input_type: 'single',
        #   demo_questions_category_id: purchasing_category_id,
        #   sort_order: 39
        # },
        # {
        #   panel: panels.first,
        #   label: 'Gps',
        #   import_label: 'purchase_gps_or_navigation',
        #   body: 'GPS or navigation device',
        #   input_type: 'single',
        #   demo_questions_category_id: purchasing_category_id,
        #   sort_order: 40
        # },
        # {
        #   panel: panels.first,
        #   label: 'Digital_Camera',
        #   import_label: 'purchase_digital_camera',
        #   body: 'Digital camera',
        #   input_type: 'single',
        #   demo_questions_category_id: purchasing_category_id,
        #   sort_order: 41
        # },
        # {
        #   panel: panels.first,
        #   label: 'Digital_Video_Camera',
        #   import_label: 'purchase_digital_video_camera',
        #   body: 'Digital video camera',
        #   input_type: 'single',
        #   demo_questions_category_id: purchasing_category_id,
        #   sort_order: 42
        # },
        # {
        #   panel: panels.first,
        #   label: 'Portable_Music',
        #   import_label: 'purchase_portable_digital_music_player',
        #   body: 'Portable digital music player (iPod, Zune, etc.)',
        #   input_type: 'single',
        #   demo_questions_category_id: purchasing_category_id,
        #   sort_order: 43
        # },
        # {
        #   panel: panels.first,
        #   label: 'Portable_Radio',
        #   import_label: 'purchase_portable_radio',
        #   body: 'Portable radio',
        #   input_type: 'single',
        #   demo_questions_category_id: purchasing_category_id,
        #   sort_order: 44
        # },
        # {
        #   panel: panels.first,
        #   label: 'Portable_Satellite',
        #   import_label: 'purchase_portable_satellite_radio',
        #   body: 'Portable satellite radio',
        #   input_type: 'single',
        #   demo_questions_category_id: purchasing_category_id,
        #   sort_order: 45
        # },
        # {
        #   panel: panels.first,
        #   label: 'Pocket_Computer',
        #   import_label: 'purchase_pocket_computer',
        #   body: 'Pocket computer (PDA, iPod Touch, etc.)',
        #   input_type: 'single',
        #   demo_questions_category_id: purchasing_category_id,
        #   sort_order: 46
        # },
        {
          panel: panels.first,
          label: 'Laptop',
          import_label: 'purchase_laptop_computer',
          body: 'Laptop or notebook computer',
          input_type: 'single',
          demo_questions_category_id: purchasing_category_id,
          sort_order: 47
        },
        {
          panel: panels.first,
          label: 'Netbook',
          import_label: 'purchase_netbook_computer',
          body: 'Netbook computer (smaller, lighter notebook/laptop)',
          input_type: 'single',
          demo_questions_category_id: purchasing_category_id,
          sort_order: 48
        },
        {
          panel: panels.first,
          label: 'Tablet',
          import_label: 'purchase_tablet_computer',
          body: 'Tablet computer (iPad, etc.)',
          input_type: 'single',
          demo_questions_category_id: purchasing_category_id,
          sort_order: 49
        },
        # {
        #   panel: panels.first,
        #   label: 'Voice_Recorder',
        #   import_label: 'purchase_voice_recorder',
        #   body: 'Voice recorder',
        #   input_type: 'single',
        #   demo_questions_category_id: purchasing_category_id,
        #   sort_order: 50
        # },
        # {
        #   panel: panels.first,
        #   label: 'Ebook',
        #   import_label: 'purchase_ebook_reader',
        #   body: 'Purchase Ebook Reader (Kindle, Nook, etc.)',
        #   input_type: 'single',
        #   demo_questions_category_id: purchasing_category_id,
        #   sort_order: 51
        # },

        # Electronics
        {
          panel: panels.first,
          label: 'Computer',
          import_label: 'desktop_or_laptop',
          body: 'Desktop or laptop computer',
          input_type: 'radio',
          demo_questions_category_id: electronics_category_id,
          sort_order: 52
        },
        {
          panel: panels.first,
          label: 'Gaming_Computer',
          import_label: 'desktop_or_laptop_for_gaming',
          body: 'Gaming desktop or laptop computer',
          input_type: 'radio',
          demo_questions_category_id: electronics_category_id,
          sort_order: 53
        },
        {
          panel: panels.first,
          label: 'Tablet_Computer',
          import_label: 'tablet_computer',
          body: 'Tablet computer',
          input_type: 'radio',
          demo_questions_category_id: electronics_category_id,
          sort_order: 54
        },
        # {
        #   panel: panels.first,
        #   label: 'Dvd_Player',
        #   import_label: 'dvd_player',
        #   body: 'DVD player',
        #   input_type: 'radio',
        #   demo_questions_category_id: electronics_category_id,
        #   sort_order: 55
        # },
        # {
        #   panel: panels.first,
        #   label: 'Blu-ray_Player',
        #   import_label: 'blu-ray_player',
        #   body: 'Blu-Ray player',
        #   input_type: 'radio',
        #   demo_questions_category_id: electronics_category_id,
        #   sort_order: 56
        # },
        {
          panel: panels.first,
          label: 'Cell_Phone',
          import_label: 'cell_phone',
          body: 'Cell phone',
          input_type: 'radio',
          demo_questions_category_id: electronics_category_id,
          sort_order: 57
        },
        {
          panel: panels.first,
          label: 'iPhone_Or_iPod_Touch',
          import_label: 'iphone_or_touch',
          body: 'iPhone or iPod Touch',
          input_type: 'radio',
          demo_questions_category_id: electronics_category_id,
          sort_order: 58
        },
        # {
        #   panel: panels.first,
        #   label: 'Pda',
        #   import_label: 'pda',
        #   body: 'PDA (Palm, Dell Axim, etc.)',
        #   input_type: 'radio',
        #   demo_questions_category_id: electronics_category_id,
        #   sort_order: 59
        # },
        # {
        #   panel: panels.first,
        #   label: 'Digital_Music_Player',
        #   import_label: 'digital_music_player',
        #   body: 'Digital music player (iPod, Zune, etc.)',
        #   input_type: 'radio',
        #   demo_questions_category_id: electronics_category_id,
        #   sort_order: 60
        # },
        # {
        #   panel: panels.first,
        #   label: 'Gamecube',
        #   import_label: 'nintendo_gamecube',
        #   body: 'Nintendo Gamecube',
        #   input_type: 'radio',
        #   demo_questions_category_id: electronics_category_id,
        #   sort_order: 61
        # },
        # {
        #   panel: panels.first,
        #   label: 'Wii',
        #   import_label: 'nintendo_wii',
        #   body: 'Nintendo Wii',
        #   input_type: 'radio',
        #   demo_questions_category_id: electronics_category_id,
        #   sort_order: 62
        # },
        # {
        #   panel: panels.first,
        #   label: 'Gameboy_Advance',
        #   import_label: 'nintendo_gameboy_advance',
        #   body: 'Nintendo Gameboy Advance',
        #   input_type: 'radio',
        #   demo_questions_category_id: electronics_category_id,
        #   sort_order: 63
        # },
        # {
        #   panel: panels.first,
        #   label: 'Nintendo_DS',
        #   import_label: 'nintendo_ds',
        #   body: 'Nintendo DS',
        #   input_type: 'radio',
        #   demo_questions_category_id: electronics_category_id,
        #   sort_order: 64
        # },
        # {
        #   panel: panels.first,
        #   label: 'Xbox',
        #   import_label: 'xbox',
        #   body: 'Xbox or Xbox 360',
        #   input_type: 'radio',
        #   demo_questions_category_id: electronics_category_id,
        #   sort_order: 65
        # },
        # {
        #   panel: panels.first,
        #   label: 'Xbox_Live',
        #   import_label: 'xbox_live_subscription',
        #   body: 'Xbox Live subscription',
        #   input_type: 'radio',
        #   demo_questions_category_id: electronics_category_id,
        #   sort_order: 66
        # },
        # {
        #   panel: panels.first,
        #   label: 'Xbox_Kinect',
        #   import_label: 'xbox_kinect',
        #   body: 'Xbox with Kinect',
        #   input_type: 'radio',
        #   demo_questions_category_id: electronics_category_id,
        #   sort_order: 67
        # },
        # {
        #   panel: panels.first,
        #   label: 'Playstation',
        #   import_label: 'sony_playstation',
        #   body: 'Sony Playstation',
        #   input_type: 'radio',
        #   demo_questions_category_id: electronics_category_id,
        #   sort_order: 68
        # },
        # {
        #   panel: panels.first,
        #   label: 'Ebook_Reader',
        #   import_label: 'ebook_reader',
        #   body: 'Ebook reader (Kindle, Nook, etc.)',
        #   input_type: 'radio',
        #   demo_questions_category_id: electronics_category_id,
        #   sort_order: 69
        # },

        # Online Services and Activities
        {
          panel: panels.first,
          label: 'Twitter',
          import_label: 'twitter_account',
          body: 'Post on a Twitter account',
          input_type: 'radio',
          demo_questions_category_id: online_category_id,
          sort_order: 70
        },
        {
          panel: panels.first,
          label: 'Facebook',
          import_label: 'facebook_account',
          body: 'Post, share, or surf on Facebook',
          input_type: 'radio',
          demo_questions_category_id: online_category_id,
          sort_order: 71
        },
        {
          panel: panels.first,
          label: 'LinkedIn',
          import_label: 'linkedin_account',
          body: 'Post, read, or connect on LinkedIn',
          input_type: 'radio',
          demo_questions_category_id: online_category_id,
          sort_order: 72
        },
        # {
        #   panel: panels.first,
        #   label: 'MySpace',
        #   import_label: 'myspace_account',
        #   body: 'Post or surf on MySpace',
        #   input_type: 'radio',
        #   demo_questions_category_id: online_category_id,
        #   sort_order: 73
        # },
        # {
        #   panel: panels.first,
        #   label: 'Blog',
        #   import_label: 'personal_blog',
        #   body: 'Post on personal blog',
        #   input_type: 'radio',
        #   demo_questions_category_id: online_category_id,
        #   sort_order: 74
        # },
        # {
        #   panel: panels.first,
        #   label: 'Dating',
        #   import_label: 'online_dating',
        #   body: 'Use online dating services',
        #   input_type: 'radio',
        #   demo_questions_category_id: online_category_id,
        #   sort_order: 75
        # },
        # {
        #   panel: panels.first,
        #   label: 'Genealogy',
        #   import_label: 'online_family_genealogy_account',
        #   body: 'Use online genealogy service',
        #   input_type: 'radio',
        #   demo_questions_category_id: online_category_id,
        #   sort_order: 76
        # },
        # {
        #   panel: panels.first,
        #   label: 'Read_Blogs',
        #   import_label: 'read_blogs',
        #   body: 'Read or subscribe to blogs',
        #   input_type: 'radio',
        #   demo_questions_category_id: online_category_id,
        #   sort_order: 77
        # },
        # {
        #   panel: panels.first,
        #   label: 'Read_Twitter',
        #   import_label: 'read_twitter',
        #   body: 'Read or subscribe to Twitter feeds',
        #   input_type: 'radio',
        #   demo_questions_category_id: online_category_id,
        #   sort_order: 78
        # },
        # {
        #   panel: panels.first,
        #   label: 'Online_Gaming',
        #   import_label: 'online_gaming',
        #   body: 'Online social gaming (Farmville, etc.)',
        #   input_type: 'radio',
        #   demo_questions_category_id: online_category_id,
        #   sort_order: 79
        # },
        # {
        #   panel: panels.first,
        #   label: 'Online_Multiplayer',
        #   import_label: 'online_multiplayer',
        #   body: 'Online multiplayer gaming',
        #   input_type: 'radio',
        #   demo_questions_category_id: online_category_id,
        #   sort_order: 80
        # },
        # {
        #   panel: panels.first,
        #   label: 'Gps_Location',
        #   import_label: 'gps_location',
        #   body: 'Show current GPS location online (Foursquare, etc.)',
        #   input_type: 'radio',
        #   demo_questions_category_id: online_category_id,
        #   sort_order: 81
        # },
        # {
        #   panel: panels.first,
        #   label: 'Instant_Messaging',
        #   import_label: 'instant_messaging',
        #   body: 'Use instant messaging',
        #   input_type: 'radio',
        #   demo_questions_category_id: online_category_id,
        #   sort_order: 82
        # },

        # Food and Drink
        # {
        #   panel: panels.first,
        #   label: 'Water',
        #   import_label: 'water',
        #   body: 'Bottled water',
        #   input_type: 'radio',
        #   demo_questions_category_id: food_category_id,
        #   sort_order: 83
        # },
        # {
        #   panel: panels.first,
        #   label: 'Soda',
        #   import_label: 'soda',
        #   body: 'Soda or pop',
        #   input_type: 'radio',
        #   demo_questions_category_id: food_category_id,
        #   sort_order: 84
        # },
        # {
        #   panel: panels.first,
        #   label: 'Coffee',
        #   import_label: 'coffee',
        #   body: 'Coffee',
        #   input_type: 'radio',
        #   demo_questions_category_id: food_category_id,
        #   sort_order: 85
        # },
        # {
        #   panel: panels.first,
        #   label: 'Tea',
        #   import_label: 'tea',
        #   body: 'Tea',
        #   input_type: 'radio',
        #   demo_questions_category_id: food_category_id,
        #   sort_order: 86
        # },
        {
          panel: panels.first,
          label: 'Wine',
          import_label: 'wine',
          body: 'Wine',
          input_type: 'radio',
          demo_questions_category_id: food_category_id,
          sort_order: 87
        },
        {
          panel: panels.first,
          label: 'Champagne',
          import_label: 'champagne_or_sparkling_wine',
          body: 'Champagne or sparkling wine',
          input_type: 'radio',
          demo_questions_category_id: food_category_id,
          sort_order: 88
        },
        {
          panel: panels.first,
          label: 'Beer',
          import_label: 'beer',
          body: 'Beer',
          input_type: 'radio',
          demo_questions_category_id: food_category_id,
          sort_order: 89
        },
        {
          panel: panels.first,
          label: 'Liquor',
          import_label: 'liquor',
          body: 'Hard liquor',
          input_type: 'radio',
          demo_questions_category_id: food_category_id,
          sort_order: 90
        },
        {
          panel: panels.first,
          label: 'Brandy',
          import_label: 'brandy_or_cognac',
          body: 'Brandy or cognac',
          input_type: 'radio',
          demo_questions_category_id: food_category_id,
          sort_order: 91
        },
        {
          panel: panels.first,
          label: 'Liqueur',
          import_label: 'liqueur',
          body: 'Liqueur',
          input_type: 'radio',
          demo_questions_category_id: food_category_id,
          sort_order: 92
        },

        # Lifestyle and Interests
        {
          panel: panels.first,
          label: 'Pets',
          import_label: 'pets',
          body: 'Do you have pets?',
          input_type: 'radio',
          demo_questions_category_id: lifestyle_category_id,
          sort_order: 93
        },
        {
          panel: panels.first,
          label: 'Dogs',
          import_label: 'pets_dogs',
          body: 'One or more dogs?',
          input_type: 'radio',
          demo_questions_category_id: lifestyle_category_id,
          sort_order: 94
        },
        {
          panel: panels.first,
          label: 'Cats',
          import_label: 'pets_cats',
          body: 'One or more cats?',
          input_type: 'radio',
          demo_questions_category_id: lifestyle_category_id,
          sort_order: 95
        },
        {
          panel: panels.first,
          label: 'Other_Pet',
          import_label: 'pets_other',
          body: 'A pet that is not a cat or dog?',
          input_type: 'radio',
          demo_questions_category_id: lifestyle_category_id,
          sort_order: 96
        },
        # {
        #   panel: panels.first,
        #   label: 'Movies',
        #   import_label: 'movie_theater',
        #   body: 'How often do you watch movies at a cinema/theater?',
        #   input_type: 'single',
        #   demo_questions_category_id: lifestyle_category_id,
        #   sort_order: 97
        # },

        # Medical
        {
          panel: panels.first,
          label: 'Respiratory',
          import_label: 'allergy_asthma_respiratory',
          body: 'Allergies, asthma, or respiratory condition',
          input_type: 'radio',
          demo_questions_category_id: medical_category_id,
          sort_order: 98
        },
        {
          panel: panels.first,
          label: 'Kidney',
          import_label: 'kidney_or_bladder',
          body: 'Kidney or bladder ailment',
          input_type: 'radio',
          demo_questions_category_id: medical_category_id,
          sort_order: 99
        },
        {
          panel: panels.first,
          label: 'Blood',
          import_label: 'blood_disorders',
          body: 'Blood disorder',
          input_type: 'radio',
          demo_questions_category_id: medical_category_id,
          sort_order: 100
        },
        {
          panel: panels.first,
          label: 'Mens',
          import_label: 'mens',
          body: 'Men\'s health issues',
          input_type: 'radio',
          demo_questions_category_id: medical_category_id,
          sort_order: 101
        },
        {
          panel: panels.first,
          label: 'Bone',
          import_label: 'bone_or_joint',
          body: 'Bone or joint condition',
          input_type: 'radio',
          demo_questions_category_id: medical_category_id,
          sort_order: 102
        },
        {
          panel: panels.first,
          label: 'Neuro',
          import_label: 'neurological_or_mental_health',
          body: 'Neurological or mental health condition',
          input_type: 'radio',
          demo_questions_category_id: medical_category_id,
          sort_order: 103
        },
        {
          panel: panels.first,
          label: 'Cancer',
          import_label: 'cancer_or_cancer_related',
          body: 'Cancer or cancer-related condition',
          input_type: 'radio',
          demo_questions_category_id: medical_category_id,
          sort_order: 104
        },
        {
          panel: panels.first,
          label: 'Skin',
          import_label: 'skin_conditions',
          body: 'Skin conditions',
          input_type: 'radio',
          demo_questions_category_id: medical_category_id,
          sort_order: 105
        },
        {
          panel: panels.first,
          label: 'Pain',
          import_label: 'chronic_pain',
          body: 'Chronic pain ailment',
          input_type: 'radio',
          demo_questions_category_id: medical_category_id,
          sort_order: 106
        },
        {
          panel: panels.first,
          label: 'Sleep',
          import_label: 'sleep',
          body: 'A sleep disorder',
          input_type: 'radio',
          demo_questions_category_id: medical_category_id,
          sort_order: 107
        },
        {
          panel: panels.first,
          label: 'Diabetes',
          import_label: 'diabetes_or_thyroid',
          body: 'Diabetes or thyroid condition',
          input_type: 'radio',
          demo_questions_category_id: medical_category_id,
          sort_order: 108
        },
        {
          panel: panels.first,
          label: 'Stomach',
          import_label: 'stomach_bowel_digestion',
          body: 'Stomach, bowel, or digestion ailment',
          input_type: 'radio',
          demo_questions_category_id: medical_category_id,
          sort_order: 109
        },
        {
          panel: panels.first,
          label: 'Eye_Or_Ear',
          import_label: 'eye_vision_hearing',
          body: 'Eye, vision, or hearing condition',
          input_type: 'radio',
          demo_questions_category_id: medical_category_id,
          sort_order: 110
        },
        {
          panel: panels.first,
          label: 'Womens',
          import_label: 'womens',
          body: 'Women\'s health issue',
          input_type: 'radio',
          demo_questions_category_id: medical_category_id,
          sort_order: 111
        },
        {
          panel: panels.first,
          label: 'Heart',
          import_label: 'heart_or_cardiovascular',
          body: 'Heart or cardio-vascular condition',
          input_type: 'radio',
          demo_questions_category_id: medical_category_id,
          sort_order: 112
        },
        {
          panel: panels.first,
          label: 'Infection',
          import_label: 'infectious_diseases',
          body: 'Infectious disease(s)',
          input_type: 'radio',
          demo_questions_category_id: medical_category_id,
          sort_order: 113
        },

        # Financial Products
        {
          panel: panels.first,
          label: 'Auto_Loan',
          import_label: 'auto_loan',
          body: 'Auto loan',
          input_type: 'radio',
          demo_questions_category_id: financial_category_id,
          sort_order: 114
        },
        {
          panel: panels.first,
          label: 'Cert_Of_Deposit',
          import_label: 'cert_of_deposit',
          body: 'Certificate of deposit',
          input_type: 'radio',
          demo_questions_category_id: financial_category_id,
          sort_order: 115
        },
        {
          panel: panels.first,
          label: 'Checking',
          import_label: 'checking_account',
          body: 'Checking account',
          input_type: 'radio',
          demo_questions_category_id: financial_category_id,
          sort_order: 116
        },
        {
          panel: panels.first,
          label: 'Credit_Card',
          import_label: 'bank_or_store_credit_card',
          body: 'Bank or store credit card',
          input_type: 'radio',
          demo_questions_category_id: financial_category_id,
          sort_order: 117
        },
        {
          panel: panels.first,
          label: 'Debit_Card',
          import_label: 'debit_card',
          body: 'Debit card',
          input_type: 'radio',
          demo_questions_category_id: financial_category_id,
          sort_order: 118
        },
        {
          panel: panels.first,
          label: 'Home_Equity',
          import_label: 'home_equity_loan_or_line_of_credit',
          body: 'Home equity loan or line of credit',
          input_type: 'radio',
          demo_questions_category_id: financial_category_id,
          sort_order: 119
        },
        {
          panel: panels.first,
          label: 'Stock_Account',
          import_label: 'stock_account',
          body: 'Individual stock or bond account',
          input_type: 'radio',
          demo_questions_category_id: financial_category_id,
          sort_order: 120
        },
        {
          panel: panels.first,
          label: 'Life_Insurance',
          import_label: 'life_insurance',
          body: 'Life insurance policy',
          input_type: 'radio',
          demo_questions_category_id: financial_category_id,
          sort_order: 121
        },
        {
          panel: panels.first,
          label: 'Money_Market',
          import_label: 'money_market',
          body: 'Money market account',
          input_type: 'radio',
          demo_questions_category_id: financial_category_id,
          sort_order: 122
        },
        {
          panel: panels.first,
          label: 'Mutual_Fund',
          import_label: 'mutual_fund',
          body: 'Mutual fund account',
          input_type: 'radio',
          demo_questions_category_id: financial_category_id,
          sort_order: 123
        },
        {
          panel: panels.first,
          label: 'Personal_Loan',
          import_label: 'personal_loan',
          body: 'Personal loan or line of credit',
          input_type: 'radio',
          demo_questions_category_id: financial_category_id,
          sort_order: 124
        },
        {
          panel: panels.first,
          label: 'RV_Loan',
          import_label: 'rv_loan',
          body: 'Recreational vehicle loan',
          input_type: 'radio',
          demo_questions_category_id: financial_category_id,
          sort_order: 125
        },
        {
          panel: panels.first,
          label: 'Savings_Account',
          import_label: 'savings_account',
          body: 'Savings account',
          input_type: 'radio',
          demo_questions_category_id: financial_category_id,
          sort_order: 126
        },

        # Politics
        {
          panel: panels.first,
          label: 'Political_Party',
          import_label: 'political_party',
          body: 'With which political party are you registered?',
          input_type: 'single',
          demo_questions_category_id: politics_category_id,
          sort_order: 127
        },
        {
          panel: panels.first,
          label: 'Political_Views',
          import_label: 'political_views',
          body: 'Considering your political views, how would you describe yourself?',
          input_type: 'single',
          demo_questions_category_id: politics_category_id,
          sort_order: 128
        }

        # oplus_questions = DemoQuestion.create!([
        #  { panel: panels.last, label: 'Gender',     body: 'What is your gender?',          input_type: 'single',   sort_order: 1 },
        #  { panel: panels.last, label: 'Activities', body: 'What activities do you enjoy?', input_type: 'multiple', sort_order: 2 },
        # ])
      ])
    else
      DemoQuestion.all.to_a
      # oplus_questions = ...
    end

  if DemoOption.count.zero?
    # Helper function
    def find_question(questions, label)
      questions.find { |question| question['label'] == label }
    end

    connection.execute("SELECT SETVAL('demo_options_id_seq'::regclass,1,false)") # reset the sequence to 1

    DemoOption.create!([
      # About Me
      { demo_question: find_question(op4g_questions, 'Gender'), label: 'Male',   sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Gender'), label: 'Female', sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Marital'),  label: 'Married',                           sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Marital'),  label: 'Unmarried partner',                 sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Marital'),  label: 'Single',                            sort_order: 3 },
      { demo_question: find_question(op4g_questions, 'Marital'),  label: 'Widowed',                           sort_order: 4 },
      { demo_question: find_question(op4g_questions, 'Marital'),  label: 'Separated',                         sort_order: 5 },
      { demo_question: find_question(op4g_questions, 'Marital'),  label: 'Divorced',                          sort_order: 6 },
      { demo_question: find_question(op4g_questions, 'Marital'),  label: 'Civil union/domestic partnership',  sort_order: 7 },

      { demo_question: find_question(op4g_questions, 'Origin'),   label: 'No',                                                sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Origin'),   label: 'Yes, Mexican, Mexican American, Chicano',           sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Origin'),   label: 'Yes, Puerto Rican',                                 sort_order: 3 },
      { demo_question: find_question(op4g_questions, 'Origin'),   label: 'Yes, Cuban',                                        sort_order: 4 },
      { demo_question: find_question(op4g_questions, 'Origin'),   label: 'Yes, another Hispanic, Latino, or Spanish origin',  sort_order: 5 },

      { demo_question: find_question(op4g_questions, 'Race'), label: 'White/Caucasian',                 sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Race'), label: 'Black/African-American',          sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Race'), label: 'American Indian/Alaska Native', sort_order: 3 },
      { demo_question: find_question(op4g_questions, 'Race'), label: 'Asian Indian',                    sort_order: 4 },
      { demo_question: find_question(op4g_questions, 'Race'), label: 'Chinese',                         sort_order: 5 },
      { demo_question: find_question(op4g_questions, 'Race'), label: 'Filipino',                        sort_order: 6 },
      { demo_question: find_question(op4g_questions, 'Race'), label: 'Japanese',                        sort_order: 7 },
      { demo_question: find_question(op4g_questions, 'Race'), label: 'Korean',                          sort_order: 8 },
      { demo_question: find_question(op4g_questions, 'Race'), label: 'Vietnamese',                      sort_order: 9 },
      { demo_question: find_question(op4g_questions, 'Race'), label: 'Native Hawaiian',                 sort_order: 10 },
      { demo_question: find_question(op4g_questions, 'Race'), label: 'Guamanian/Chamorro',              sort_order: 11 },
      { demo_question: find_question(op4g_questions, 'Race'), label: 'Samoan',                          sort_order: 12 },
      { demo_question: find_question(op4g_questions, 'Race'), label: 'Other Pacific Islander',          sort_order: 13 },
      { demo_question: find_question(op4g_questions, 'Race'), label: 'Other Asian',                     sort_order: 14 },
      { demo_question: find_question(op4g_questions, 'Race'), label: 'Other',                           sort_order: 15 },

      { demo_question: find_question(op4g_questions, 'Orientation'),  label: 'Heterosexual',              sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Orientation'),  label: 'Homosexual (lesbian/gay)',  sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Orientation'),  label: 'Bisexual',                  sort_order: 3 },
      { demo_question: find_question(op4g_questions, 'Orientation'),  label: 'Other',                     sort_order: 4 },
      { demo_question: find_question(op4g_questions, 'Orientation'),  label: 'Prefer not to say',         sort_order: 5 },

      { demo_question: find_question(op4g_questions, 'Worth'),  label: 'under 16,000',                sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Worth'),  label: '16,000 to 49,999',            sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Worth'),  label: '50,000 to 99,999',            sort_order: 3 },
      { demo_question: find_question(op4g_questions, 'Worth'),  label: '100,000 to 499,999',          sort_order: 4 },
      { demo_question: find_question(op4g_questions, 'Worth'),  label: '500,000 to 999,999',          sort_order: 5 },
      { demo_question: find_question(op4g_questions, 'Worth'),  label: '1 million to 4.9 million',    sort_order: 6 },
      { demo_question: find_question(op4g_questions, 'Worth'),  label: '5 million to 9.9 million',    sort_order: 7 },
      { demo_question: find_question(op4g_questions, 'Worth'),  label: '10 million to 19.9 million',  sort_order: 8 },
      { demo_question: find_question(op4g_questions, 'Worth'),  label: '20 million or more',          sort_order: 9 },
      { demo_question: find_question(op4g_questions, 'Worth'),  label: 'Prefer not to say',           sort_order: 10 },

      { demo_question: find_question(op4g_questions, 'License'),  label: 'Yes', sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'License'),  label: 'No',  sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Car'),      label: 'Yes', sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Car'),      label: 'No',  sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Share'),    label: 'Yes', sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Share'),    label: 'No',  sort_order: 2 },

      # Education
      { demo_question: find_question(op4g_questions, 'Education'), label: 'Some high school/secondary school or less',        sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Education'), label: 'High school/secondary school graduate',            sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Education'), label: 'Some college/university (no degree)',              sort_order: 3 },
      { demo_question: find_question(op4g_questions, 'Education'), label: "Associate 's degree earned",                       sort_order: 4 },
      { demo_question: find_question(op4g_questions, 'Education'), label: "Bachelor's or undergraduate degree earned ",       sort_order: 5 },
      { demo_question: find_question(op4g_questions, 'Education'), label: 'Postgraduate study ', sort_order: 6 },
      { demo_question: find_question(op4g_questions, 'Education'), label: "Master 's degree earned",                          sort_order: 7 },
      { demo_question: find_question(op4g_questions, 'Education'), label: 'Doctorate earned (PhD, EdD, etc.)',                sort_order: 8 },
      { demo_question: find_question(op4g_questions, 'Education'), label: 'Professional degree earned (MD, DDS, DVM, etc.)',  sort_order: 9 },
      { demo_question: find_question(op4g_questions, 'Education'), label: "Associate's degree earned - Vocational program ",  sort_order: 10 },
      { demo_question: find_question(op4g_questions, 'Education'), label: "Associate 's degree earned-Academic program", sort_order: 11 },

      { demo_question: find_question(op4g_questions, 'Enrolled'),  label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Enrolled'),  label: 'No',   sort_order: 2 },

      # Job
      { demo_question: find_question(op4g_questions, 'Self-Employed'),  label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Self-Employed'),  label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Employment'),  label: 'Employed full time (35 hours+ per week)',      sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Employment'),  label: 'Employed part time (under 35 hours per week)', sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Employment'),  label: 'Retired',                                      sort_order: 3 },
      { demo_question: find_question(op4g_questions, 'Employment'),  label: 'Unemployed/Temporarily out of work',           sort_order: 4 },
      { demo_question: find_question(op4g_questions, 'Employment'),  label: 'Full-time Disabled',                           sort_order: 5 },
      { demo_question: find_question(op4g_questions, 'Employment'),  label: 'Homemaker',                                    sort_order: 6 },
      { demo_question: find_question(op4g_questions, 'Employment'),  label: 'Other',                                        sort_order: 7 },

      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Accounting',                             sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Aerospace/defense',                      sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Agriculture/forestry/landscaping',       sort_order: 3 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Arts/entertainment/recreation',          sort_order: 4 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Automotive/transport',                   sort_order: 5 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Banking',                                sort_order: 6 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Broadcasting/TV/radio',                  sort_order: 7 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Building/construction',                  sort_order: 8 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Business services',                      sort_order: 9 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Chemical',                               sort_order: 10 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Computer/network services',              sort_order: 11 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Education/teaching/coaching',            sort_order: 12 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Energy/utilities',                       sort_order: 13 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Engineering services',                   sort_order: 14 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Financial services/investments',         sort_order: 15 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Government (federal state local)',       sort_order: 16 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Health/medical/services',                sort_order: 17 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'IT/technology/software',                 sort_order: 18 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Insurance',                              sort_order: 19 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Internet publishing/services',           sort_order: 20 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Law enforcement',                        sort_order: 21 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Legal services',                         sort_order: 22 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Management consulting services',         sort_order: 23 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Manufacturing',                          sort_order: 24 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Marketing',                              sort_order: 25 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Media advertising/public relations',     sort_order: 26 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Medical practice',                       sort_order: 27 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Medical services',                       sort_order: 28 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Mining/oil/gas',                         sort_order: 29 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Non-profit/religion',                    sort_order: 30 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Not currently working outside the home', sort_order: 31 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Other',                                  sort_order: 32 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Pharmaceutical',                         sort_order: 33 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Publishing/print media',                 sort_order: 34 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Real estate',                            sort_order: 35 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Repair/maintenance',                     sort_order: 36 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Restaurant/food and beverage services',  sort_order: 37 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Retail business',                        sort_order: 38 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Social services',                        sort_order: 39 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Student',                                sort_order: 40 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Telecommunications',                     sort_order: 41 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Transportation/shipping',                sort_order: 42 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Unemployed/temporarily out of work',     sort_order: 43 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Utilities',                              sort_order: 44 },
      { demo_question: find_question(op4g_questions, 'Industry'),  label: 'Wholesale business',                     sort_order: 45 },

      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Administrator',                           sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Certified public account (CPA)',          sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Chief Executive Officer (CEO)',           sort_order: 3 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Chief Financial Officer (CFO)',           sort_order: 4 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Chief Information Officer (CIO)',         sort_order: 5 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Chief Marketing Officer (CMO)',           sort_order: 6 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Chief Operating Officer (COO)',           sort_order: 7 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Chief Technology Officer (CTO)',          sort_order: 8 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Consultant/analyst/specialist',           sort_order: 9 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Dentist',                                 sort_order: 10 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Department head',                         sort_order: 11 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Director',                                sort_order: 12 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Education professional',                  sort_order: 13 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Engineering/scientific professional',     sort_order: 14 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Executive/Senior Vice President',         sort_order: 15 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Financial services professional',         sort_order: 16 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'General manager/director',                sort_order: 17 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Law enforcement officer',                 sort_order: 18 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Lawyer',                                  sort_order: 19 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Legal professional',                      sort_order: 20 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Manager',                                 sort_order: 21 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Medical assistant',                       sort_order: 22 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Medical doctor (MD)',                     sort_order: 23 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Not currently working outside the home',  sort_order: 24 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Nurse',                                   sort_order: 25 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Office administration',                   sort_order: 26 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Other',                                   sort_order: 27 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Other (company) officer/board member',    sort_order: 28 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Other chief officer',                     sort_order: 29 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Owner/partner',                           sort_order: 30 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Paralegal',                               sort_order: 31 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Pilot',                                   sort_order: 32 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'President/chairman',                      sort_order: 33 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Salesperson',                             sort_order: 34 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Social service professional',             sort_order: 35 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Student',                                 sort_order: 36 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Supervisor',                              sort_order: 37 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Technician',                              sort_order: 38 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Unemployed/temporarily out of work',      sort_order: 39 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Veterinarian',                            sort_order: 40 },
      { demo_question: find_question(op4g_questions, 'Title'),  label: 'Vice President (other)',                  sort_order: 41 },

      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Accountant/CPA/auditor',
        sort_order: 1
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Architect',
        sort_order: 2
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Artist/designer/actor/musician',
        sort_order: 3
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Broker/dealer/trader',
        sort_order: 4
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Builder/building contractor',
        sort_order: 5
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Certified financial planner (CFP)',
        sort_order: 6
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Clergy/other person at religious institution',
        sort_order: 7
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Consultant',
        sort_order: 8
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Cosmetologist/barber/other personal care',
        sort_order: 9
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Counselor/psychologist/therapist',
        sort_order: 10
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Designer',
        sort_order: 11
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Educator/teacher/coach',
        sort_order: 12
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Engineer',
        sort_order: 13
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Farmer/rancher',
        sort_order: 14
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Financial/securities analyst',
        sort_order: 15
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Homemaker',
        sort_order: 16
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'IT professional',
        sort_order: 17
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Investment banker',
        sort_order: 18
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Law enforcement',
        sort_order: 19
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Lawyer/judge',
        sort_order: 20
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Management/administration',
        sort_order: 21
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Medical doctor/dentist',
        sort_order: 22
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Medical professional (nurse, nurse\'s aid, etc.)',
        sort_order: 23
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Military',
        sort_order: 24
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Nurse',
        sort_order: 25
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Other',
        sort_order: 26
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Other financial planner/investment advisor/asset manager (CFA, ChFC, estate planning professional, CLU, etc.)',
        sort_order: 27
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Other health care (technicians, etc.)',
        sort_order: 28
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Other legal (paralegals, arbitrators, etc.)',
        sort_order: 29
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Pharmacist',
        sort_order: 30
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Public administrator/government worker',
        sort_order: 31
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Registered investment advisor (RIA)',
        sort_order: 32
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Sales/marketing/advertising',
        sort_order: 33
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Scientist',
        sort_order: 34
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Small business owner',
        sort_order: 35
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Social worker',
        sort_order: 36
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Software developer/network specialist',
        sort_order: 37
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Student',
        sort_order: 38
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Travel services/tourism',
        sort_order: 39
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Unemployed/not currently working outside the home',
        sort_order: 40
      },
      {
        demo_question: find_question(op4g_questions, 'Occupation'),
        label: 'Writer/journalist',
        sort_order: 41
      },

      { demo_question: find_question(op4g_questions, 'Workplace'),  label: 'Company offices/premises',      sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Workplace'),  label: 'Continuous travel/on the road', sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Workplace'),  label: 'Not currently employed',        sort_order: 3 },
      { demo_question: find_question(op4g_questions, 'Workplace'),  label: 'Outside of home or office',     sort_order: 4 },
      { demo_question: find_question(op4g_questions, 'Workplace'),  label: 'Work from home full-time',      sort_order: 5 },
      { demo_question: find_question(op4g_questions, 'Workplace'),  label: 'Work from office full-time',    sort_order: 6 },
      { demo_question: find_question(op4g_questions, 'Workplace'),  label: 'Work part-time/home or office', sort_order: 7 },

      { demo_question: find_question(op4g_questions, 'Computers'),  label: 'None',              sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Computers'),  label: '1 to 4',            sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Computers'),  label: '5 to 24',           sort_order: 3 },
      { demo_question: find_question(op4g_questions, 'Computers'),  label: '25 to 49',          sort_order: 4 },
      { demo_question: find_question(op4g_questions, 'Computers'),  label: '50 to 99',          sort_order: 5 },
      { demo_question: find_question(op4g_questions, 'Computers'),  label: '100 to 249',        sort_order: 6 },
      { demo_question: find_question(op4g_questions, 'Computers'),  label: '250 to 499',        sort_order: 7 },
      { demo_question: find_question(op4g_questions, 'Computers'),  label: '500 to 999',        sort_order: 8 },
      { demo_question: find_question(op4g_questions, 'Computers'),  label: '1,000 to 1,499',    sort_order: 9 },
      { demo_question: find_question(op4g_questions, 'Computers'),  label: '1,500 to 4,999',    sort_order: 10 },
      { demo_question: find_question(op4g_questions, 'Computers'),  label: '5,000 to 24,999',   sort_order: 11 },
      { demo_question: find_question(op4g_questions, 'Computers'),  label: '25,000 to 49,999',  sort_order: 12 },
      { demo_question: find_question(op4g_questions, 'Computers'),  label: '50,000 or more',    sort_order: 13 },
      { demo_question: find_question(op4g_questions, 'Computers'),  label: 'Not applicable',    sort_order: 14 },

      { demo_question: find_question(op4g_questions, 'Employees'),  label: 'None',              sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Employees'),  label: '1 to 24',           sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Employees'),  label: '25 to 49',          sort_order: 3 },
      { demo_question: find_question(op4g_questions, 'Employees'),  label: '50 to 99',          sort_order: 4 },
      { demo_question: find_question(op4g_questions, 'Employees'),  label: '100 to 249',        sort_order: 5 },
      { demo_question: find_question(op4g_questions, 'Employees'),  label: '250 to 499',        sort_order: 6 },
      { demo_question: find_question(op4g_questions, 'Employees'),  label: '500 to 999',        sort_order: 7 },
      { demo_question: find_question(op4g_questions, 'Employees'),  label: '1,000 to 1,499',    sort_order: 8 },
      { demo_question: find_question(op4g_questions, 'Employees'),  label: '1,500 to 4,999',    sort_order: 9 },
      { demo_question: find_question(op4g_questions, 'Employees'),  label: '5,000 to 24,999',   sort_order: 10 },
      { demo_question: find_question(op4g_questions, 'Employees'),  label: '25,000 or more',    sort_order: 11 },
      { demo_question: find_question(op4g_questions, 'Employees'),  label: 'Not applicable',    sort_order: 12 },

      { demo_question: find_question(op4g_questions, 'Revenue'),  label: 'less than 100,000',           sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Revenue'),  label: '100,000 to 499,999',          sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Revenue'),  label: '500,000 to 999,999',          sort_order: 3 },
      { demo_question: find_question(op4g_questions, 'Revenue'),  label: '1 million to 4.9 million',    sort_order: 4 },
      { demo_question: find_question(op4g_questions, 'Revenue'),  label: '5 million to 24 million',     sort_order: 5 },
      { demo_question: find_question(op4g_questions, 'Revenue'),  label: '25 million to 74 million',    sort_order: 6 },
      { demo_question: find_question(op4g_questions, 'Revenue'),  label: '75 million to 149 million',   sort_order: 7 },
      { demo_question: find_question(op4g_questions, 'Revenue'),  label: '150 million to 249 million',  sort_order: 8 },
      { demo_question: find_question(op4g_questions, 'Revenue'),  label: '250 million to 499 million',  sort_order: 9 },
      { demo_question: find_question(op4g_questions, 'Revenue'),  label: '500 million to 749 million',  sort_order: 10 },
      { demo_question: find_question(op4g_questions, 'Revenue'),  label: '750 million to 999 million',  sort_order: 11 },
      { demo_question: find_question(op4g_questions, 'Revenue'),  label: '1 billion to 1.4 billion',    sort_order: 12 },
      { demo_question: find_question(op4g_questions, 'Revenue'),  label: '1.5 billion to 1.9 billion',  sort_order: 13 },
      { demo_question: find_question(op4g_questions, 'Revenue'),  label: '2 billion to 4.9 billion',    sort_order: 14 },
      { demo_question: find_question(op4g_questions, 'Revenue'),  label: '5 billion to 9.9 billion',    sort_order: 15 },
      { demo_question: find_question(op4g_questions, 'Revenue'),  label: 'Over 10 billion',             sort_order: 16 },
      { demo_question: find_question(op4g_questions, 'Revenue'),  label: 'I don\'t know',               sort_order: 17 },
      { demo_question: find_question(op4g_questions, 'Revenue'),  label: 'Not applicable',              sort_order: 18 },

      # Household
      { demo_question: find_question(op4g_questions, 'Children'),  label: '0',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Children'),  label: '1',  sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Children'),  label: '2',  sort_order: 3 },
      { demo_question: find_question(op4g_questions, 'Children'),  label: '3',  sort_order: 4 },
      { demo_question: find_question(op4g_questions, 'Children'),  label: '4',  sort_order: 5 },
      { demo_question: find_question(op4g_questions, 'Children'),  label: '5',  sort_order: 6 },
      { demo_question: find_question(op4g_questions, 'Children'),  label: '6',  sort_order: 7 },
      { demo_question: find_question(op4g_questions, 'Children'),  label: '7',  sort_order: 8 },
      { demo_question: find_question(op4g_questions, 'Children'),  label: '8',  sort_order: 9 },
      { demo_question: find_question(op4g_questions, 'Children'),  label: '9+', sort_order: 10 },

      { demo_question: find_question(op4g_questions, 'Under_6'),  label: '0',   sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Under_6'),  label: '1',   sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Under_6'),  label: '2',   sort_order: 3 },
      { demo_question: find_question(op4g_questions, 'Under_6'),  label: '3',   sort_order: 4 },
      { demo_question: find_question(op4g_questions, 'Under_6'),  label: '4',   sort_order: 5 },
      { demo_question: find_question(op4g_questions, 'Under_6'),  label: '5',   sort_order: 6 },
      { demo_question: find_question(op4g_questions, 'Under_6'),  label: '6',   sort_order: 7 },
      { demo_question: find_question(op4g_questions, 'Under_6'),  label: '7',   sort_order: 8 },
      { demo_question: find_question(op4g_questions, 'Under_6'),  label: '8',   sort_order: 9 },
      { demo_question: find_question(op4g_questions, 'Under_6'),  label: '9+',  sort_order: 10 },

      { demo_question: find_question(op4g_questions, '6_to_11'),  label: '0',   sort_order: 1 },
      { demo_question: find_question(op4g_questions, '6_to_11'),  label: '1',   sort_order: 2 },
      { demo_question: find_question(op4g_questions, '6_to_11'),  label: '2',   sort_order: 3 },
      { demo_question: find_question(op4g_questions, '6_to_11'),  label: '3',   sort_order: 4 },
      { demo_question: find_question(op4g_questions, '6_to_11'),  label: '4',   sort_order: 5 },
      { demo_question: find_question(op4g_questions, '6_to_11'),  label: '5',   sort_order: 6 },
      { demo_question: find_question(op4g_questions, '6_to_11'),  label: '6',   sort_order: 7 },
      { demo_question: find_question(op4g_questions, '6_to_11'),  label: '7',   sort_order: 8 },
      { demo_question: find_question(op4g_questions, '6_to_11'),  label: '8',   sort_order: 9 },
      { demo_question: find_question(op4g_questions, '6_to_11'),  label: '9+',  sort_order: 10 },

      { demo_question: find_question(op4g_questions, '12_to_17'),  label: '0',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, '12_to_17'),  label: '1',  sort_order: 2 },
      { demo_question: find_question(op4g_questions, '12_to_17'),  label: '2',  sort_order: 3 },
      { demo_question: find_question(op4g_questions, '12_to_17'),  label: '3',  sort_order: 4 },
      { demo_question: find_question(op4g_questions, '12_to_17'),  label: '4',  sort_order: 5 },
      { demo_question: find_question(op4g_questions, '12_to_17'),  label: '5',  sort_order: 6 },
      { demo_question: find_question(op4g_questions, '12_to_17'),  label: '6',  sort_order: 7 },
      { demo_question: find_question(op4g_questions, '12_to_17'),  label: '7',  sort_order: 8 },
      { demo_question: find_question(op4g_questions, '12_to_17'),  label: '8',  sort_order: 9 },
      { demo_question: find_question(op4g_questions, '12_to_17'),  label: '9+', sort_order: 10 },

      { demo_question: find_question(op4g_questions, '18_to_24'),  label: '0',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, '18_to_24'),  label: '1',  sort_order: 2 },
      { demo_question: find_question(op4g_questions, '18_to_24'),  label: '2',  sort_order: 3 },
      { demo_question: find_question(op4g_questions, '18_to_24'),  label: '3',  sort_order: 4 },
      { demo_question: find_question(op4g_questions, '18_to_24'),  label: '4',  sort_order: 5 },
      { demo_question: find_question(op4g_questions, '18_to_24'),  label: '5',  sort_order: 6 },
      { demo_question: find_question(op4g_questions, '18_to_24'),  label: '6',  sort_order: 7 },
      { demo_question: find_question(op4g_questions, '18_to_24'),  label: '7',  sort_order: 8 },
      { demo_question: find_question(op4g_questions, '18_to_24'),  label: '8',  sort_order: 9 },
      { demo_question: find_question(op4g_questions, '18_to_24'),  label: '9+', sort_order: 10 },

      { demo_question: find_question(op4g_questions, '25_and_up'),  label: '0',   sort_order: 1 },
      { demo_question: find_question(op4g_questions, '25_and_up'),  label: '1',   sort_order: 2 },
      { demo_question: find_question(op4g_questions, '25_and_up'),  label: '2',   sort_order: 3 },
      { demo_question: find_question(op4g_questions, '25_and_up'),  label: '3',   sort_order: 4 },
      { demo_question: find_question(op4g_questions, '25_and_up'),  label: '4',   sort_order: 5 },
      { demo_question: find_question(op4g_questions, '25_and_up'),  label: '5',   sort_order: 6 },
      { demo_question: find_question(op4g_questions, '25_and_up'),  label: '6',   sort_order: 7 },
      { demo_question: find_question(op4g_questions, '25_and_up'),  label: '7',   sort_order: 8 },
      { demo_question: find_question(op4g_questions, '25_and_up'),  label: '8',   sort_order: 9 },
      { demo_question: find_question(op4g_questions, '25_and_up'),  label: '9+',  sort_order: 10 },

      { demo_question: find_question(op4g_questions, 'Residence'),  label: 'Own, with loan/mortgage', sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Residence'),  label: 'Own, no loan/mortgage',   sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Residence'),  label: 'Rent',                    sort_order: 3 },
      { demo_question: find_question(op4g_questions, 'Residence'),  label: 'Occupy w/no rent paid',   sort_order: 4 },

      { demo_question: find_question(op4g_questions, 'Income'),  label: 'Under 25,000',             sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Income'),  label: '25,000 to 49,999',         sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Income'),  label: '50,000 to 74,999',         sort_order: 3 },
      { demo_question: find_question(op4g_questions, 'Income'),  label: '75,000 to 99,999',         sort_order: 4 },
      { demo_question: find_question(op4g_questions, 'Income'),  label: '100,000 to 124,999',       sort_order: 5 },
      { demo_question: find_question(op4g_questions, 'Income'),  label: '125,000 to 149,999',       sort_order: 6 },
      { demo_question: find_question(op4g_questions, 'Income'),  label: '150,000 to 174,999',       sort_order: 7 },
      { demo_question: find_question(op4g_questions, 'Income'),  label: '175,000 to 199,999',       sort_order: 8 },
      { demo_question: find_question(op4g_questions, 'Income'),  label: '200,000 to 249,999',       sort_order: 9 },
      { demo_question: find_question(op4g_questions, 'Income'),  label: '250,000 to 299,999',       sort_order: 10 },
      { demo_question: find_question(op4g_questions, 'Income'),  label: '300,000 to 399,999',       sort_order: 11 },
      { demo_question: find_question(op4g_questions, 'Income'),  label: '400,000 to 499,999',       sort_order: 12 },
      { demo_question: find_question(op4g_questions, 'Income'),  label: '500,000 to 749,999',       sort_order: 13 },
      { demo_question: find_question(op4g_questions, 'Income'),  label: '750,000 to 999,999',       sort_order: 14 },
      { demo_question: find_question(op4g_questions, 'Income'),  label: '1,000,000 to 1,999,999',   sort_order: 15 },
      { demo_question: find_question(op4g_questions, 'Income'),  label: '2,000,000 to 2,999,999',   sort_order: 16 },
      { demo_question: find_question(op4g_questions, 'Income'),  label: '3,000,000 to 3,999,999',   sort_order: 17 },
      { demo_question: find_question(op4g_questions, 'Income'),  label: '4,000,000 or more',        sort_order: 18 },
      { demo_question: find_question(op4g_questions, 'Income'),  label: 'Prefer not to say',        sort_order: 19 },

      # Purchasing
      { demo_question: find_question(op4g_questions, 'Day_to_day_purchases'),  label: 'I am',                                                 sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Day_to_day_purchases'),  label: 'Someone else',                                         sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Day_to_day_purchases'),  label: 'I share that responsibility with someone else/others', sort_order: 3 },

      { demo_question: find_question(op4g_questions, 'Large_purchases'),  label: 'I am',                                                 sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Large_purchases'),  label: 'Someone else',                                         sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Large_purchases'),  label: 'I share that responsibility with someone else/others', sort_order: 3 },

      { demo_question: find_question(op4g_questions, 'Vehicle'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Vehicle'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'New_Vehicle'), label: 'Yes, in the next 1-6 months',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'New_Vehicle'), label: 'Yes, in the next 6-12 months', sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'New_Vehicle'), label: 'No current plan to purchase',  sort_order: 3 },

      { demo_question: find_question(op4g_questions, 'Used_Vehicle'), label: 'Yes, in the next 1-6 months',   sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Used_Vehicle'), label: 'Yes, in the next 6-12 months',  sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Used_Vehicle'), label: 'No current plan to purchase',   sort_order: 3 },

      { demo_question: find_question(op4g_questions, 'Mobile_Phone'), label: 'Yes, in the next 1-6 months',   sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Mobile_Phone'), label: 'Yes, in the next 6-12 months',  sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Mobile_Phone'), label: 'No current plan to purchase',   sort_order: 3 },

      { demo_question: find_question(op4g_questions, 'Smart_Phone'), label: 'Yes, in the next 1-6 months',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Smart_Phone'), label: 'Yes, in the next 6-12 months', sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Smart_Phone'), label: 'No current plan to purchase',  sort_order: 3 },

      { demo_question: find_question(op4g_questions, 'Portable_Gaming'), label: 'Yes, in the next 1-6 months',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Portable_Gaming'), label: 'Yes, in the next 6-12 months', sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Portable_Gaming'), label: 'No current plan to purchase',  sort_order: 3 },

      # { demo_question: find_question(op4g_questions, 'Portable_Dvd'), label: 'Yes, in the next 1-6 months',   sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Portable_Dvd'), label: 'Yes, in the next 6-12 months',  sort_order: 2 },
      # { demo_question: find_question(op4g_questions, 'Portable_Dvd'), label: 'No current plan to purchase',   sort_order: 3 },

      # { demo_question: find_question(op4g_questions, 'Portable_Blu-ray'), label: 'Yes, in the next 1-6 months', sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Portable_Blu-ray'), label: 'Yes, in the next 6-12 months',    sort_order: 2 },
      # { demo_question: find_question(op4g_questions, 'Portable_Blu-ray'), label: 'No current plan to purchase',     sort_order: 3 },

      # { demo_question: find_question(op4g_questions, 'Portable_Mediplayer'), label: 'Yes, in the next 1-6 months',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Portable_Mediplayer'), label: 'Yes, in the next 6-12 months', sort_order: 2 },
      # { demo_question: find_question(op4g_questions, 'Portable_Mediplayer'), label: 'No current plan to purchase',  sort_order: 3 },

      # { demo_question: find_question(op4g_questions, 'Gps'), label: 'Yes, in the next 1-6 months',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Gps'), label: 'Yes, in the next 6-12 months', sort_order: 2 },
      # { demo_question: find_question(op4g_questions, 'Gps'), label: 'No current plan to purchase',  sort_order: 3 },

      # { demo_question: find_question(op4g_questions, 'Digital_Camera'), label: 'Yes, in the next 1-6 months',   sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Digital_Camera'), label: 'Yes, in the next 6-12 months',  sort_order: 2 },
      # { demo_question: find_question(op4g_questions, 'Digital_Camera'), label: 'No current plan to purchase',   sort_order: 3 },

      # { demo_question: find_question(op4g_questions, 'Digital_Video_Camera'), label: 'Yes, in the next 1-6 months',   sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Digital_Video_Camera'), label: 'Yes, in the next 6-12 months',  sort_order: 2 },
      # { demo_question: find_question(op4g_questions, 'Digital_Video_Camera'), label: 'No current plan to purchase',   sort_order: 3 },

      # { demo_question: find_question(op4g_questions, 'Portable_Music'), label: 'Yes, in the next 1-6 months',   sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Portable_Music'), label: 'Yes, in the next 6-12 months',  sort_order: 2 },
      # { demo_question: find_question(op4g_questions, 'Portable_Music'), label: 'No current plan to purchase',   sort_order: 3 },

      # { demo_question: find_question(op4g_questions, 'Portable_Radio'), label: 'Yes, in the next 1-6 months',   sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Portable_Radio'), label: 'Yes, in the next 6-12 months',  sort_order: 2 },
      # { demo_question: find_question(op4g_questions, 'Portable_Radio'), label: 'No current plan to purchase',   sort_order: 3 },

      # { demo_question: find_question(op4g_questions, 'Portable_Satellite'), label: 'Yes, in the next 1-6 months',   sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Portable_Satellite'), label: 'Yes, in the next 6-12 months',  sort_order: 2 },
      # { demo_question: find_question(op4g_questions, 'Portable_Satellite'), label: 'No current plan to purchase',   sort_order: 3 },

      # { demo_question: find_question(op4g_questions, 'Pocket_Computer'), label: 'Yes, in the next 1-6 months',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Pocket_Computer'), label: 'Yes, in the next 6-12 months', sort_order: 2 },
      # { demo_question: find_question(op4g_questions, 'Pocket_Computer'), label: 'No current plan to purchase',  sort_order: 3 },

      { demo_question: find_question(op4g_questions, 'Laptop'), label: 'Yes, in the next 1-6 months',   sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Laptop'), label: 'Yes, in the next 6-12 months',  sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Laptop'), label: 'No current plan to purchase',   sort_order: 3 },

      { demo_question: find_question(op4g_questions, 'Netbook'), label: 'Yes, in the next 1-6 months',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Netbook'), label: 'Yes, in the next 6-12 months', sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Netbook'), label: 'No current plan to purchase',  sort_order: 3 },

      { demo_question: find_question(op4g_questions, 'Tablet'), label: 'Yes, in the next 1-6 months',   sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Tablet'), label: 'Yes, in the next 6-12 months',  sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Tablet'), label: 'No current plan to purchase',   sort_order: 3 },

      # { demo_question: find_question(op4g_questions, 'Voice_Recorder'), label: 'Yes, in the next 1-6 months',   sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Voice_Recorder'), label: 'Yes, in the next 6-12 months',  sort_order: 2 },
      # { demo_question: find_question(op4g_questions, 'Voice_Recorder'), label: 'No current plan to purchase',   sort_order: 3 },

      # { demo_question: find_question(op4g_questions, 'Ebook'), label: 'Yes, in the next 1-6 months',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Ebook'), label: 'Yes, in the next 6-12 months', sort_order: 2 },
      # { demo_question: find_question(op4g_questions, 'Ebook'), label: 'No current plan to purchase',  sort_order: 3 },

      # Electronics
      { demo_question: find_question(op4g_questions, 'Computer'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Computer'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Gaming_Computer'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Gaming_Computer'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Tablet_Computer'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Tablet_Computer'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'Dvd_Player'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Dvd_Player'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'Blu-ray_Player'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Blu-ray_Player'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Cell_Phone'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Cell_Phone'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'iPhone_Or_iPod_Touch'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'iPhone_Or_iPod_Touch'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'Pda'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Pda'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'Digital_Music_Player'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Digital_Music_Player'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'Gamecube'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Gamecube'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'Wii'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Wii'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'Gameboy_Advance'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Gameboy_Advance'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'Nintendo_DS'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Nintendo_DS'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'Xbox'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Xbox'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'Xbox_Live'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Xbox_Live'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'Xbox_Kinect'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Xbox_Kinect'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'Playstation'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Playstation'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'Ebook_Reader'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Ebook_Reader'), label: 'No',   sort_order: 2 },

      # Online Services and Activities
      { demo_question: find_question(op4g_questions, 'Twitter'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Twitter'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Facebook'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Facebook'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'LinkedIn'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'LinkedIn'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'MySpace'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'MySpace'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'Blog'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Blog'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'Dating'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Dating'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'Genealogy'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Genealogy'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'Read_Blogs'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Read_Blogs'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'Read_Twitter'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Read_Twitter'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'Online_Gaming'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Online_Gaming'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'Online_Multiplayer'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Online_Multiplayer'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'Gps_Location'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Gps_Location'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'Instant_Messaging'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Instant_Messaging'), label: 'No',   sort_order: 2 },

      # Food and Drink
      # { demo_question: find_question(op4g_questions, 'Water'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Water'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'Soda'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Soda'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'Coffee'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Coffee'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'Tea'), label: 'Yes',  sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Tea'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Wine'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Wine'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Champagne'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Champagne'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Beer'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Beer'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Liquor'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Liquor'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Brandy'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Brandy'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Liqueur'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Liqueur'), label: 'No',   sort_order: 2 },

      # Lifestyle and Interests
      { demo_question: find_question(op4g_questions, 'Pets'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Pets'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Dogs'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Dogs'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Cats'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Cats'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Other_Pet'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Other_Pet'), label: 'No',   sort_order: 2 },

      # { demo_question: find_question(op4g_questions, 'Movies'), label: 'Never',                     sort_order: 1 },
      # { demo_question: find_question(op4g_questions, 'Movies'), label: '1 to 4 times per year',     sort_order: 2 },
      # { demo_question: find_question(op4g_questions, 'Movies'), label: '5 to 11 times per year',    sort_order: 3 },
      # { demo_question: find_question(op4g_questions, 'Movies'), label: 'Once per month',            sort_order: 4 },
      # { demo_question: find_question(op4g_questions, 'Movies'), label: 'More than once per month',  sort_order: 5 },

      # Medical
      { demo_question: find_question(op4g_questions, 'Respiratory'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Respiratory'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Kidney'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Kidney'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Blood'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Blood'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Mens'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Mens'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Bone'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Bone'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Neuro'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Neuro'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Cancer'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Cancer'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Skin'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Skin'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Pain'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Pain'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Sleep'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Sleep'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Diabetes'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Diabetes'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Stomach'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Stomach'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Eye_Or_Ear'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Eye_Or_Ear'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Womens'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Womens'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Heart'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Heart'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Infection'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Infection'), label: 'No',   sort_order: 2 },

      # Financial Products
      { demo_question: find_question(op4g_questions, 'Auto_Loan'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Auto_Loan'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Cert_Of_Deposit'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Cert_Of_Deposit'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Checking'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Checking'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Credit_Card'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Credit_Card'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Debit_Card'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Debit_Card'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Home_Equity'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Home_Equity'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Stock_Account'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Stock_Account'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Life_Insurance'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Life_Insurance'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Money_Market'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Money_Market'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Mutual_Fund'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Mutual_Fund'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Personal_Loan'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Personal_Loan'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'RV_Loan'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'RV_Loan'), label: 'No',   sort_order: 2 },

      { demo_question: find_question(op4g_questions, 'Savings_Account'), label: 'Yes',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Savings_Account'), label: 'No',   sort_order: 2 },

      # Politics
      { demo_question: find_question(op4g_questions, 'Political_Party'), label: 'Independent',  sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Political_Party'), label: 'Democratic',   sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Political_Party'), label: 'Republican',   sort_order: 3 },
      { demo_question: find_question(op4g_questions, 'Political_Party'), label: 'Other',        sort_order: 4 },
      { demo_question: find_question(op4g_questions, 'Political_Party'), label: 'None',         sort_order: 5 },

      { demo_question: find_question(op4g_questions, 'Political_Views'), label: 'Very liberal',           sort_order: 1 },
      { demo_question: find_question(op4g_questions, 'Political_Views'), label: 'Somewhat liberal',       sort_order: 2 },
      { demo_question: find_question(op4g_questions, 'Political_Views'), label: 'Middle of the Road',     sort_order: 3 },
      { demo_question: find_question(op4g_questions, 'Political_Views'), label: 'Somewhat conservative',  sort_order: 4 },
      { demo_question: find_question(op4g_questions, 'Political_Views'), label: 'Very conservative',      sort_order: 5 },
    ])
    # else
    # op4g_question_options = DemoOption.all.to_a
  end

  if Age.count.zero?
    connection.execute("SELECT SETVAL('ages_id_seq'::regclass,1,false)") # reset the sequence to 1

    (13..102).each do |age|
      Age.create!(value: age)
    end
  end

  if Employee.count.zero?
    Employee.create!([ # password for generic employees = 'RKSv-JT9oVW3nYpnOQkcVQ'
      { id: 0,
        first_name: 'None',
        last_name: 'None',
        email: 'none@test.op4g.com',
        password: '$2a$12$VOuO30DP/XYdNbur4XD2G.O55Hu0yH4DlBlYITKoCxcOuHXntnpum' }
    ])
  end

  if Role.count.zero?
    connection.execute("SELECT SETVAL('roles_id_seq'::regclass,1,false)") # reset the sequence to 1

    Role.create!([
      { name: 'Admin' },
      { name: 'Nonprofits' },
      { name: 'Recruitment' },
      { name: 'Sales' },
      { name: 'Operations' },
      { name: 'Operations manager' },
      { name: 'Membership' },
      { name: 'Payment' },
      { name: 'Reporting' },
      { name: 'Security' }
    ])
  end

  if SurveyResponsePattern.count.zero?
    connection.execute("SELECT SETVAL('survey_response_patterns_id_seq'::regclass,1,false)") # reset the sequence to 1

    SurveyResponsePattern.create!([
      { slug: 'complete',  name: 'Complete', sort: 1 },
      { slug: 'terminate', name: 'Terminate', sort: 2 },
      { slug: 'quotafull', name: 'Quota full', sort: 3 },
    ])
  end

  if Vendor.count.zero?
    connection.execute("SELECT SETVAL('vendors_id_seq'::regclass,1,false)") # reset the sequence to 1

    Vendor.create!([
      { name: 'Hasoffers', abbreviation: 'HO' },
      { name: 'Cint'                          },
      { name: 'uSamp'                         },
      { name: 'GMI'                           },
    ])
  end

  if Product.count.zero?
    connection.execute("SELECT SETVAL('products_id_seq'::regclass,1,false)") # reset the sequence to 1

    Product.create!([
      { name: 'Basic Survey',                       sort_order: 1,  active: false },
      { name: 'Opinions 4 Good - Extended Survey',  sort_order: 2,  active: false },
      { name: 'Qualifying Survey',                  sort_order: 3,  active: false },
      { name: 'Sample only',                        sort_order: 4,  active: true },
      { name: 'Full service',                       sort_order: 5,  active: true },
      { name: 'Wholesale',                          sort_order: 6,  active: true },
    ])
  end

  if EmailDescription.count.zero?
    connection.execute("SELECT SETVAL('email_descriptions_id_seq'::regclass,1,false)") # reset the sequence to 1

    EmailDescription.create!([
      {
        name: 'Full service',
        product: Product.find_by(name: 'Full service'),
        default: false,
        description: 'This market research activity is made available on our own survey platform. If you qualify and complete the study, your earnings and associated Non-Profit donation information will be shown on your MyOp4G dashboard immediately. As is the case with all Op4G market research activities you participate with, your anonymity and privacy remains completely protected. Per our Terms Of Use, never is any of your identity information revealed to Op4G clients or any other third parties.'
      },
      {
        name: 'Other',
        product: nil,
        default: true,
        description: "This market research activity is made available on our client's survey platform. Your earnings and associated Non-Profit donation information will be shown on your MyOp4G dashboard after all participants have completed the activity, so there may be a delay of 2-3 weeks before your dashboard is updated. As is the case with all Op4G market research activities you participate with, your anonymity and privacy remains completely protected. Per our Terms Of Use, never is any of your identity information revealed to Op4G clients or any other third parties."
      },
    ])
  end
end

Rails.logger.info 'Database seeded'
