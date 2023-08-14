# frozen_string_literal: true

# A demographic detail result is a record used to tie a panelist to an id.
class DemographicDetailResult < ApplicationRecord
  belongs_to :demographic_detail
  belongs_to :panelist
end
