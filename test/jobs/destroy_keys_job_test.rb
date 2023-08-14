# frozen_string_literal: true

require 'test_helper'

class DestroyKeysJobTest < ActiveJob::TestCase
  test 'removes unused keys' do
    @survey = surveys(:standard)

    assert @survey.keys.unused.length.positive?
    DestroyKeysJob.perform_now(@survey)
    assert @survey.keys.unused.empty?
  end
end
