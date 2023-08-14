# frozen_string_literal: true

# panelist ip histories track ip's used by panelists
class PanelistIpHistory < ApplicationRecord
  enum source: {
    signup: 'signup',
    signin: 'signin',
    survey: 'survey'
  }

  belongs_to :panelist
  belongs_to :ip_address

  validates :source, presence: true
end
