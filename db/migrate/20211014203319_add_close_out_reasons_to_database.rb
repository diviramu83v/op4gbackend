# frozen_string_literal: true

class AddCloseOutReasonsToDatabase < ActiveRecord::Migration[5.2]
  def change
    reasons = [
      { title: 'Speeding', definition: 'LOI is significantly shorter than stated LOI. PLEASE NOTE: this should be based on our testing of the survey and NOT what the client believes the LOI to be.', category: 'rejected' },
      { title: 'Confusing/contradictory close-ended responses', definition: 'Answering standard-select questions in a contradictory fashion to other answers already given (for example: indicating that they’ve been working at their company for 15 years, but they are 23 years old)', category: 'rejected' },
      { title: 'Client not happy with quality/depth of answer', definition: 'For an expensive/elite audience with a high CPI and high-payout, OEs should be longer than one word where applicable; If the client believes the answers are not on par with price being paid.', category: 'rejected' },
      { title: 'OEs have non-egregious misspellings/other typos', definition: 'If there are a few misspellings or grammar issues. If there are MULTIPLE issues, this would be considered fraud.', category: 'rejected' },
      { title: 'Other', category: 'rejected' },
      { title: 'Poor OEs', definition: 'OE responses appear to be written by someone who does not speak English, OEs do not answer any part of the questions, or OEs appear to be written by a robot.', category: 'fraud' },
      { title: 'Straight lining', definition: 'The respondent selects the same choice # for multiple questions in a row (NOTE: this should be an excessive amount. A handful of repetitive responses could be a result of the questionnaire design).', category: 'fraud' },
      { title: 'Duplicate IPs', definition: 'It appears as if the same person/computer has taken the same survey twice.', category: 'fraud' },
      { title: 'Not captured in client’s system (client does not have that particular ID listed as a complete)', definition: 'If the client does not have a particular ID marked as a complete in their system, but it shows up as a complete in Admin, it should be marked as fraud.', category: 'fraud' },
      { title: 'Misc. fraudulent activities', definition: 'Any other suspect behavior that seems more suspicious than a respondent just being sloppy or not paying attention.', category: 'fraud' },
      { title: 'Other', category: 'fraud' }
    ]

    CloseOutReason.create!(reasons)
  end
end
