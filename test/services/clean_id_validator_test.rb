# frozen_string_literal: true

require 'test_helper'

class CleanIdValidatorTest < ActiveSupport::TestCase
  describe 'everything is good' do
    setup do
      @data = { 'TransactionId' => 'eb815afc-c4eb-47e9-89a8-8981b32f7ca4', 'Score' => 0, 'ORScore' => 0.45, 'Duplicate' => false, 'IsMobile' => false }
      stub_request(:get, 'https://gateway.navigatorsurveys.com/cleanid/result/eb815afc-c4eb-47e9-89a8-8981b32f7ca4')
        .to_return(status: 200,
                   body: '{"result": { "Score": 0, "ORScore": 0.45, "Duplicate": false}}',
                   headers: { 'Content-Type' => 'application/json' })
    end

    test 'returns false' do
      validator = CleanIdValidator.new(@data)
      assert_not validator.failed?
    end
  end

  describe 'score missing' do
    setup do
      @data = {
        'forensic' => {
          'unique' => {
            'isEventUnique' => true
          }
        }
      }
    end

    test 'returns true' do
      validator = CleanIdValidator.new(@data)
      assert validator.failed?
    end
  end

  describe 'score too high' do
    setup do
      @data = {
        'forensic' => {
          'marker' => {
            'score' => 75
          }
        }
      }
    end

    test 'returns true' do
      validator = CleanIdValidator.new(@data)
      assert validator.failed?
    end
  end

  describe 'unique flag missing' do
    setup do
      @data = {
        'forensic' => {
          'marker' => {
            'score' => 10
          }
        }
      }
    end

    test 'returns true' do
      validator = CleanIdValidator.new(@data)
      assert validator.failed?
    end
  end

  describe 'unique flag false' do
    setup do
      @data = {
        'forensic' => {
          'marker' => {
            'score' => 10
          },
          'unique' => {
            'isEventUnique' => false
          }
        }
      }
    end

    test 'returns true' do
      validator = CleanIdValidator.new(@data)
      assert validator.failed?
    end
  end

  describe 'CORS timeout error' do
    # rubocop:disable Style/StringLiterals
    setup do
      @data = "{\"error\":{\"message\":\"CORS Timeout.\"}}"
    end
    # rubocop:enable Style/StringLiterals

    it 'should fail the validator' do
      validator = CleanIdValidator.new(@data)
      assert validator.failed?
    end
  end
end
