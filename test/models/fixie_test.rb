# frozen_string_literal: true

require 'test_helper'

class FixieTest < ActiveSupport::TestCase
  describe 'class methods' do
    describe 'post' do
      test 'http URLs' do
        stub_request(:post, 'http://test.com?id=abc')
          .to_return(status: 200)

        Fixie.post(url: 'http://test.com?id=abc')
      end

      test 'https URLs' do
        stub_request(:post, 'https://secure.test.com/?id=xyz')
          .to_return(status: 200)

        Fixie.post(url: 'https://secure.test.com?id=xyz')
      end
    end
  end
end
