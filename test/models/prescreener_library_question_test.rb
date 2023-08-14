# frozen_string_literal: true

require 'test_helper'

class PrescreenerLibraryQuestionTest < ActiveSupport::TestCase
  describe 'fixture' do
    def setup
      @prescreener_library_question = prescreener_library_questions(:standard)
    end

    test 'is valid' do
      assert @prescreener_library_question.valid?
    end
  end
end
