# frozen_string_literal: true

require 'test_helper'

class KeyImportJobTest < ActiveJob::TestCase
  it 'doesn\'t throw an error for duplicate keys' do
    @project = projects(:standard)
    @survey = surveys(:standard)
    @survey.update!(temporary_keys: %w[abc xyz], project: @project)
    @survey_two = surveys(:standard)
    @survey_two.update!(temporary_keys: %w[aaa xyz], project: @project)

    KeyImportJob.perform_now(@survey)
    KeyImportJob.perform_now(@survey_two)

    assert true
  end
end
