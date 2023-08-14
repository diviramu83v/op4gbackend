# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class AddDemoOptionsToNewQuestions < ActiveRecord::Migration[5.2]
  def up
    expert_panel = Panel.find_by(slug: 'expert-panel')

    gender = %w[Male Female Non-binary]
    marital = ['Married', 'Unmarried partner', 'Single', 'Widowed', 'Separated', 'Divorced', 'Civil union/domestic partnership']
    origin = [
      'No',
      'Yes, Mexican, Mexican American, Chicano',
      'Yes, Puerto Rican',
      'Yes, Cuban',
      'Yes, another Hispanic, Latino, or Spanish origin'
    ]
    ethnicity = [
      'Caucasian',
      'African-American',
      'Asian',
      'Native American/Pacific Islander',
      'Other',
      'Prefer not to say'
    ]
    income = [
      'Under 25,000',
      '25,000 to 49,999',
      '50,000 to 74,999',
      '75,000 to 99,999',
      '100,000 to 124,999',
      '125,000 to 149,999',
      '150,000 to 174,999',
      '175,000 to 199,999',
      '200,000 to 249,999',
      '250,000 to 299,999',
      '300,000 to 399,999',
      '400,000 to 499,999',
      '500,000 to 749,999',
      '750,000 to 999,999',
      '1,000,000 to 1,999,999',
      '2,000,000 to 2,999,999',
      '3,000,000 to 3,999,999',
      '4,000,000 or more',
      'Prefer not to say'
    ]
    education = [
      'Some high school/secondary school or less',
      'High school/secondary school graduate',
      'Some college/university (no degree)',
      'Associate\'s degree earned',
      'Bachelor\'s or undergraduate degree earned',
      'Postgraduate study',
      'Master\'s degree earned',
      'Doctorate earned (PhD, EdD, etc.)',
      'Professional degree earned (MD, DDS, DVM, etc.)',
      'Associate\'s degree earned - Vocational program',
      'Associate\'s degree earned-Academic program'
    ]
    employment_status = [
      'Employed full time (35 hours+ per week)',
      'Employed part time (under 35 hours per week)',
      'Retired',
      'Unemployed/Temporarily out of work',
      'Full-time Disabled',
      'Homemaker',
      'Other'
    ]
    job_level = [
      'Owner/Partner',
      'C-Level/President',
      'Vice President (EVP, SVP, AVP, VP)',
      'Director (Group Director, Sr. Director, Director)',
      'Manager (Sr. Manager, Manager, Program Manager)',
      'Mid-Level or Associate',
      'Administrative (Clerical or Support Staff)',
      'Consultant',
      'None of the above'
    ]
    industry = [
      'Accounting',
      'Advertising',
      'Agriculture/Fishing',
      'Architecture',
      'Automotive',
      'Aviation',
      'Banking/Financial',
      'Beauty',
      'Bio-Tech',
      'Chemicals/Plastics/Rubber',
      'Contractor/Construction',
      'Consulting',
      'Consumer Packaged Goods',
      'Education',
      'Energy/Utilities/Oil and Gas',
      'Engineering',
      'Environmental Services',
      'Fashion/Apparel',
      'Food/Beverage/Restaurant',
      'Government/Public Sector',
      'Healthcare',
      'Hospitality/Tourism',
      'Human Resources',
      'Information Technology (IT)',
      'Insurance',
      'Legal/Law',
      'Manufacturing',
      'Marketing',
      'Market Research',
      'Media/Entertainment',
      'Military',
      'Non Profit/Social services',
      'Pharmaceuticals',
      'Photography',
      'Printing Publishing',
      'Public Relations',
      'Real Estate/Property',
      'Retail/Wholesale trade',
      'Sales',
      'Security',
      'Shipping/Distribution',
      'Telecommunications',
      'Transportation'
    ]
    environment = [
      'I work in an office, behind a desk',
      'I work on my feet in a factory or warehouse setting',
      'I work on my feet in a retail or hospitality setting',
      'I work on my feet in a laboratory or medical setting',
      'I work in a different environment than those listed'
    ]
    department = [
      'Administration/General Staff',
      'Customer Service/Client Service',
      'Executive Leadership',
      'Finance/Accounting',
      'Human Resources',
      'Legal/Law',
      'Marketing',
      'Operations',
      'Procurement',
      'Sales/Business Development',
      'Information Technology (IT)',
      'Other'
    ]
    decision_making = [
      'IT Hardware',
      'IT Software',
      'Printers and copiers',
      'Financial Department',
      'Human Resources',
      'Office supplies',
      'Corporate travel',
      'Telecommunications',
      'Sales',
      'Shipping',
      'Operations',
      'Legal services',
      'Marketing/Advertising',
      'Security',
      'Food services',
      'Auto leasing/purchasing',
      'Other',
      'I don\'t have any influence or decision making authority'
    ]
    employee_count = [
      '1 to 5',
      '6 to 9',
      '10 to 24',
      '25 to 49',
      '50 to 99',
      '100 to 249',
      '250 to 499',
      '500 to 999',
      '1,000 to 1,499',
      '1,500 to 4,999',
      '5,000 to 24,999',
      '25,000 or more'
    ]
    revenue = [
      'less than 100,000',
      '100,000 to 499,999',
      '500,000 to 999,999',
      '1 million to 4.9 million',
      '5 million to 24 million',
      '25 million to 74 million',
      '75 million to 149 million',
      '150 million to 249 million',
      '250 million to 499 million',
      '500 million to 749 million',
      '750 million to 999 million',
      '1 billion to 1.4 billion',
      '1.5 billion to 1.9 billion',
      '2 billion to 4.9 billion',
      '5 billion to 9.9 billion',
      'Over 10 billion'
    ]
    employment_years = [
      'Less than one year',
      '1-3 years',
      '4-6 years',
      '7-9 years',
      '10-19 years',
      '20+'
    ]
    years_in_business = [
      'Less than one year',
      '1-3 years',
      '4-6 years',
      '7-9 years',
      '10-19 years',
      '20-49 years',
      '50+ years'
    ]

    demo_option_arrays = [[gender, 'gender'], [marital, 'marital'], [origin, 'origin'], [ethnicity, 'ethnicity'], [income, 'income'],
                          [education, 'education'], [employment_status, 'employment_status'], [job_level, 'job_level'], [industry, 'industry'],
                          [environment, 'environment'], [department, 'department'], [decision_making, 'decision_making'], [employee_count, 'employee_count'],
                          [revenue, 'revenue'], [employment_years, 'employment_years'], [years_in_business, 'years_in_business']]

    demo_option_arrays.each do |options_array|
      question = expert_panel.demo_questions.find_by(label: options_array.last)
      options_array.first.each_with_index do |option, index|
        question.demo_options.create(label: option, sort_order: index)
      end
    end
  end

  def down
    general_category = expert_panel.demo_questions_categories.find_by(name: 'General')
    professional_category = expert_panel.demo_questions_categories.find_by(name: 'Professional')
    general_category.demo_questions.each do |question|
      question.demo_options.destroy_all
    end
    professional_category.demo_questions.each do |question|
      question.demo_options.destroy_all
    end
  end
end
# rubocop:enable Metrics/ClassLength
