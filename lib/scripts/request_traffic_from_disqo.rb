# frozen_string_literal: true

# Usage: rails runner lib/scripts/request_traffic_from_disqo.rb onramp_id onramp_token loi

onramp_id = ARGV[0].to_i
onramp_token = ARGV[1]
loi = ARGV[2]

raise 'onramp ID missing' if onramp_id.blank?
raise 'onramp token missing' if onramp_token.blank?
raise 'LOI missing' if loi.blank?

j = {
  id: '1',
  supplierId: 54_637, # The ID of the supplier. Note that the value 54637 should be used for DISQO and Survey Junkie panelists.
  studyType: 'AD_HOC',
  url: 'https://www.example.com',
  loi: 10,
  conversionRate: 85,
  cpi: 10,
  completesWanted: 10,
  qualifications: {
    and: [
      {
        range: {
          values: [
            {
              gte: 18,
              lte: 35
            }
          ],
          question: 'age'
        }
      },
      {
        equals: {
          values: [
            'US'
          ],
          question: 'geocountry'
        }
      },
      {
        equals: {
          values: [
            '1', # Female
            '2'  # Male
          ],
          question: 'gender'
        }
      },
      {
        equals: {
          values: [
            'AL', # State Abbreviation
            'AK',
            'AZ',
            'AR',
            'CA',
            'CO',
            'CT',
            'DC',
            'DE',
            'FL',
            'GA',
            'HI',
            'ID',
            'IL',
            'KS',
            'KY',
            'LA',
            'ME',
            'MD',
            'MA',
            'MI',
            'MN',
            'MS',
            'MO',
            'MT',
            'NE',
            'NV',
            'NH',
            'NJ',
            'NM',
            'NY',
            'NC',
            'ND',
            'OH',
            'OK',
            'OR',
            'PA',
            'RI',
            'SC',
            'SD',
            'TN',
            'TX',
            'UT',
            'VT',
            'VA',
            'WA',
            'WV',
            'WI',
            'WY'
          ],
          question: 'georegion'
        }
      },
      {
        equals: {
          values: [
            '1', # Completed Some High School
            '2', # High School Graduate
            '3', # Some College / University
            '4', # Associates / 2-Yr. Degree
            '5', # Bachelor's Degree
            '6', # Some Postgraduate Study
            '7', # Master's Degree
            '8', # Doctorate / PhD
            '9', # Vocational Training / Trade School
            '10', # High School Graduate
            '11', # Third Grade or Less
            '12'  # Middle School - Grades 4-8
          ],
          question: 'educationlevel'
        }
      },
      {
        equals: {
          values: [
            '1', # Employed Full-Time
            '2', # Employed Part-Time
            '3', # Self-Employed Full-Time
            '4', # Self-Employed Part-Time
            '5', # Homemaker / Stay-at-Home Parent
            '6', # Retired
            '8', # Student Full-Time
            '9', # Student Part-Time
            '10', # Permanently Unemployed / Disabled
            '11', # Unemployed
            '12', # Active military
            '13', # Inactive military/Veteran
            '14'  # None of the Above
          ],
          question: 'employmentstatus'
        }
      },
      {
        equals: {
          values: [
            '23', # Less than $5,000
            '24', # $5,000 - $9,999
            '2', # $10,000 - $14,999
            '3', # $15,000 - $19,999
            '4', # $20,000 - $19,999
            '5', # $25,000 - $29,999
            '6', # $30,000 - $34,999
            '7', # $35,000 - $39,999
            '8', # $40,000 - $44,999
            '9', # $45,000 - $49,999
            '10', # $50,000 - $54,999
            '11', # $55,000 - $59,999
            '12', # $60,000 - $64,999
            '13', # $65,000 - $69,999
            '14', # $70,000 - $74,999
            '15', # $75,000 - $79,999
            '25', # $80,000 - $84,999
            '26', # $85,000 - $89,999
            '27', # $90,000 - $94,999
            '28', # $95,000 - $99,999
            '29', # $100,000 - $124,999
            '30', # $125,000 - $149,999
            '30', # $175,000 - $199,999
            '31', # $200,000 - $249,999
            '32', # $250,000 and above
            '22' # Prefer Not to Say
          ],
          question: 'householdincome'
        }
      },
      {
        equals: {
          values: [
            '1', # White / Caucasian
            '2', # Black / African American
            '3', # American Indian / Alaskan Native
            '4', # Asian
            '5', # Middle Eastern
            '6', # Pacific Islander
            '7', # Hispanic or Mixed / Other Race
            '9', # Asian, Indian
            '10', # Asian, Chinese
            '11', # Asian, Filipino
            '12', # Asian, Japanese
            '13', # Asian, Korean
            '14', # Asian, Vietnamese
            '15', # Asian, Other
            '16', # Pacific Islander, Native Hawaiian
            '17', # Pacific Islander, Guamanian
            '18', # Pacific Islander, Samoan
            '19', # Pacific Islander, Other
            '8' # Prefer Not to Say
          ],
          question: 'ethnicity'
        }
      },
      {
        equals: {
          values: [
            '1', # 1-10
            '2', # 11-50
            '3', # 51-100
            '4', # 101-500
            '5', # 501-1000
            '6', # 1001-5000
            '7', # > 5000
            '8'  # I don't work
          ],
          question: 'employeecount'
        }
      },
      {
        equals: {
          values: [
            '32', # C-Level (e.g. CEO, CFO), Owner, Partner, President
            '33', # Vice President (EVP, SVP, AVP, VP)
            '34', # Director (Group Director, Sr. Director, Director)
            '35', # Manager (Group Manager, Sr. Manager, Manager, Program Manager)
            '36', # Supervisor
            '37', # Administrative (Clerical or Support Staff)
            '38', # Associate / Senior Associate
            '39', # Consultant
            '40', # Analyst
            '41', # Professional / Professional Specialist
            '42', # Technician / Technical Specialist
            '43', # Tradesman / Trade Specialist
            '44', # Intern
            '45', # Volunteer
            '31' # None of the above
          ],
          question: 'jobposition'
        }
      },
      {
        equals: {
          values: [
            '1', # Yes
            '2' # No
          ],
          question: 'financialdecisionmaker'
        }
      }
    ]
  },
  devices: [
    'DESKTOP', # Devices a survey can be taken on
    'PHONE',
    'TABLET'
  ],
  country: 'US',
  trackingField: 'COMPLETES' # The method by which currentClicks or currentCompletes will be counted. Values can be either COMPLETES or CLICKS.
}

j['id'] = onramp_id
j['url'] = "http://survey.op4g.com/onramps/#{onramp_token}"
# j['url'] = "http://survey.op4g-staging.com/onramps/#{onramp_token}"
j['loi'] = loi

@api = DisqoApi.new

@api.create_project(body: j.to_json)
@api.create_project_quota(project_id: onramp_id, body: j.to_json)
# @api.change_project_quota_status_live(project_id: onramp_id) This won't work with the DisqoApi class anymore
