# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength
module SurveyApiTargetSelections
  GENDERS = %w[male female].freeze

  COUNTRIES_ARRAY = [
    %w[CA Canada],
    %w[DE Germany],
    %w[ES Spain],
    %w[FR France],
    ['GB', 'Great Britain'],
    ['US', 'United States']
  ].freeze

  MIN_AGE = 15
  MAX_AGE = 100

  EDUCATION_OPTIONS = {
    some_high_school: 'Some high school/secondary school or less',
    high_school_graduate: 'High school/secondary school graduate',
    some_college: 'Some college/university (no degree)',
    vocational_associates: 'Associate\'s degree earned - Vocational program',
    academic_associates: 'Associate\'s degree earned - Academic program',
    bachelors: 'Bachelor\'s or undergraduate degree earned',
    postgraduate: 'Postgraduate study',
    masters: 'Master\'s degree earned',
    doctorate: 'Doctorate earned (PhD, EdD, etc.)',
    professional: 'Professional degree earned (MD, DDS, DVM, etc.)'
  }.freeze

  EMPLOYMENT_OPTIONS = {
    full_time: 'Employed full time (35 hours+ per week)',
    part_time: 'Employed part time (under 35 hours per week)',
    contractor: 'Employed as a contractor',
    retired: 'Retired',
    unemployed: 'Unemployed/Temporarily out of work',
    disabled: 'Full-time Disabled',
    homemaker: 'Homemaker',
    other: 'Other'
  }.freeze

  INCOME_OPTIONS = {
    under_twenty_five_thousand: 'under $25,000',
    twenty_five_thousand_to_under_fifty_thousand: '$25,000 to $49,999',
    fifty_thousand_to_under_seventy_five_thousand: '$50,000 to $74,999',
    seventy_five_thousand_to_under_one_hundred_thousand: '$75,000 to $99,999',
    one_hundred_thousand_to_under_one_hundred_twenty_five_thousand: '$100,000 to $124,999',
    one_hundred_twenty_five_thousand_to_under_one_hundred_fifty_thousand: '$125,000 to $149,999',
    one_hundred_fifty_thousand_to_under_one_hundred_seventy_five_thousand: '$150,000 to $174,999',
    one_hundred_seventy_five_thousand_to_under_two_hundred_thousand: '$175,000 to $199,999',
    two_hundred_thousand_to_under_two_hundred_fifty_thousand: '$200,000 to $249,999',
    two_hundred_fifty_thousand_to_under_three_hundred_thousand: '$250,000 to $299,999',
    three_hundred_thousand_to_under_four_hundred_thousand: '$300,000 to $399,999',
    four_hundred_thousand_to_under_five_hundred_thousand: '$400,000 to $449,999',
    five_hundred_thousand_to_under_seven_hundred_fifty_thousand: '$500,000 to $749,999',
    seven_hundred_fifty_thousand_to_under_one_million: '$750,000 to $999,999',
    one_million_to_under_two_million: '$1 million to $1.9 million',
    two_million_to_under_three_million: '$2 million to $2.9 million',
    three_million_to_under_four_million: '$3 million to $3.9 million',
    four_million_or_more: '$4 million or more',
    prefer_not_to_say: 'Prefer not to say'
  }.freeze

  RACE_OPTIONS = {
    american_indian_alaska_native: 'American Indian/Alaska Native',
    asian_indian: 'Asian Indian',
    black_african_american: 'Black/African-American',
    chinese: 'Chinese',
    filipino: 'Filipino',
    guamanian_chamorro: 'Guamanian/Chamorro',
    japanese: 'Japanese',
    korean: 'Korean',
    native_hawaiian: 'Native Hawaiian',
    other: 'Other',
    other_asian: 'Other Asian',
    other_pacific_islander: 'Other Pacific Islander',
    samoan: 'Samoan',
    vietnamese: 'Vietnamese',
    white_caucasian: 'White/Caucasian'
  }.freeze

  NUMBER_OF_EMPLOYEE_OPTIONS = {
    none: 'None',
    one_to_under_twenty_four: '1 to 24',
    twenty_five_to_under_fifty: '25 to 49',
    fifty_to_under_one_hundred: '50 to 99',
    one_hundred_to_under_two_hundred_fifty: '100 to 249',
    two_hundred_fifty_to_under_five_hundred: '250 to 499',
    five_hundred_to_under_one_thousand: '500 to 999',
    one_thousand_to_under_one_thousand_five_hundred: '1,000 to 1,499',
    one_thousand_five_hundred_to_under_five_thousand: '1,500 to 4,999',
    five_thousand_to_under_twenty_five_thousand: '5,000 to 24,999',
    twenty_five_thousand_or_more: '25,000 or more',
    not_applicable: 'Not applicable'
  }.freeze

  JOB_TITLE_OPTIONS = {
    administrator: 'Administrator',
    certified_public_accountant: 'Certified public account (CPA)',
    chief_executive_officer: 'Chief Executive Officer (CEO)',
    chief_financial_officer: 'Chief Financial Officer (CFO)',
    chief_information_officer: 'Chief Information Officer (CIO)',
    chief_marketing_officer: 'Chief Marketing Officer (CMO)',
    chief_operating_officer: 'Chief Operating Officer (COO)',
    chief_technology_officer: 'Chief Technology Officer (CTO)',
    consultant_analyst_specialist: 'Consultant/analyst/specialist',
    dentist: 'Dentist',
    department_head: 'Department head',
    director: 'Director',
    education_professional: 'Education professional',
    engineering_scientific_professional: 'Engineering/scientific professional',
    executive_senior_vice_president: 'Executive/Senior Vice President',
    financial_services_professional: 'Financial services professional',
    general_manager_director: 'General manager/director',
    law_enforcement_officer: 'Law enforcement officer',
    lawyer: 'Lawyer',
    legal_professional: 'Legal professional',
    manager: 'Manager',
    medical_assistant: 'Medical assistant',
    medical_doctor_md: 'Medical doctor (MD)',
    not_currently_working_outside_the_home: 'Not currently working outside the home',
    nurse: 'Nurse',
    office_administration: 'Office administration',
    other: 'Other',
    other_company_officer_board_member: 'Other (company) officer/board member',
    other_chief_officer: 'Other chief officer',
    owner_partner: 'Owner/partner',
    paralegal: 'Paralegal',
    pilot: 'Pilot',
    president_chairman: 'President/chairman',
    salesperson: 'Salesperson',
    social_service_professional: 'Social service professional',
    student: 'Student',
    supervisor: 'Supervisor',
    technician: 'Technician',
    unemployed_temporarily_out_of_work: 'Unemployed/temporarily out of work',
    veterinarian: 'Veterinarian',
    vice_president_other: 'Vice President (other)'
  }.freeze

  DECISION_MAKER_OPTIONS = {
    no_influence: 'No influence',
    it_hardware: 'IT Hardware',
    it_software: 'IT Software',
    printers_and_copiers: 'Printers and Copiers',
    financial_department: 'Financial Department (Acco. Software,Corporate CC)',
    human_resources: 'Human Resources (Employee Benefits,Retirement Pro)',
    office_supplies: 'Office Supplies',
    printer_and_copier_supplies: 'Printer and Copier Supplies (e.g. Ink)',
    corporate_travel_self: 'Corporate Travel Self',
    corporate_travel_company: 'Corporate Travel Company',
    telecom_mobile: 'Telecommunications (Mobile)',
    telecom_non_mobile: 'Telecommunications (Non -Mobile)',
    sales_business_development: 'Sales/Business Development',
    shipping_mail_services: 'Shipping/Mail Services',
    operations_production: 'Operations/Production',
    legal_services: 'Legal Services',
    marketing_advertising: 'Marketing/Advertising',
    security_services: 'Security Services',
    facilities_maintenance_management: 'Facilities Maintenance and Management',
    food_services_catering: 'Food Services/Catering',
    auto_leasing_purchasing: 'Auto Leasing/Purchasing',
    it_services_products: 'IT services or products',
    maintenance: 'Maintenance',
    training: 'Training',
    procurement_buying: 'Procurement, buying',
    office_services_moving: 'Office services, moving',
    raw_materials_primary_products: 'Raw materials, primary products',
    real_estate_services: 'Real estate services',
    recruiting_new_hires: 'Recruiting new hires',
    website_development_maintenance: 'Website Development/Maintenance',
    it_infrastructure_systems_integration: 'IT Infrastructure/Outsourcing, Systems Integration',
    data_storage: 'Data Storage',
    virtualization: 'Virtualization',
    internet_wireless_services: 'Internet and Wireless Services',
    network_products_routers_lans_wireless: 'Network products (Routers, LANs, wireless, etc.)',
    handhelds_cell_smart_phone: 'Handhelds (Cell/Smart phones)',
    enterprise_applications_erp_crm: 'Enterprise Applications (ERP, CRM, etc)',
    servers: 'Servers',
    meeting_accommodations: 'Meeting accommodations',
    computer_services_it_business_solutions: 'Computer Services, IT Business Solutions',
    other_professional_services_consultants: 'Other Professional Services/Consultants',
    i_dont_work: 'I don\'t work',
    prefer_not_to_say: 'Prefer not to say'
  }.freeze
end
# rubocop:enable Metrics/ModuleLength
