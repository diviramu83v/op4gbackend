# frozen_string_literal: true

require 'test_helper'

class AuthenticityTokenCheckerTest < ActiveSupport::TestCase
  describe 'AuthenticityTokenChecker' do
    it 'should require the POST method in the request phase' do
      @env = { 'REQUEST_METHOD' => 'POST' }

      assert_equal AuthenticityTokenChecker.new.call(@env), true
    end

    it 'should return false/deny the GET request' do
      @env = { 'REQUEST_METHOD' => 'GET' }

      assert_equal AuthenticityTokenChecker.new.call(@env), false
    end
  end
end
