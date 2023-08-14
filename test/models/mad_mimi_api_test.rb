# frozen_string_literal: true

require 'test_helper'

class MadMimiApiTest < ActiveSupport::TestCase
  setup do
    @api = MadMimiApi.new

    @email = 'testing@123.com'
    @list_id = '123'
  end

  describe '#add_to_list' do
    setup do
      FeatureManager.stubs(:send_real_mimi_emails?).returns(true)

      @url = "https://madmimi.com/audience_lists/#{@list_id}/add"
    end

    it 'posts to the correct URL' do
      stub_request(:post, Regexp.new(@url)).to_return(status: 200)
      @api.add_to_list(email: @email, list_id: @list_id)
    end
  end

  describe '#remove_from_list' do
    setup do
      FeatureManager.stubs(:send_real_mimi_emails?).returns(true)

      @url = "https://madmimi.com/audience_lists/#{@list_id}/remove"
    end

    it 'posts to the correct URL' do
      stub_request(:post, Regexp.new(@url)).to_return(status: 200)
      @api.remove_from_list(email: @email, list_id: @list_id)
    end
  end

  describe '#suppress_all_communication' do
    setup do
      FeatureManager.stubs(:send_real_mimi_emails?).returns(true)

      @url = "https://madmimi.com/audience_members/#{@email}/suppress_email"
    end

    it 'posts to the correct URL' do
      stub_request(:post, Regexp.new(@url)).to_return(status: 200)
      @api.suppress_all_communication(email: @email)
    end
  end

  describe 'API error' do
    setup do
      FeatureManager.stubs(:send_real_mimi_emails?).returns(true)

      # Just an example URL. Not really specific to this test.
      @url = "https://madmimi.com/audience_members/#{@email}/suppress_email"
    end

    it 'throws an error when a 200 response is not received' do
      stub_request(:post, Regexp.new(@url)).to_return(status: 500)
      assert_raises(RuntimeError) do
        @api.suppress_all_communication(email: @email)
      end
    end
  end

  describe 'production guard' do
    setup do
      # Just an example URL. Not really specific to this test.
      @url = "https://madmimi.com/audience_lists/#{@list_id}/remove"
      stub_request(:post, Regexp.new(@url)).to_return(status: 200)
    end

    it 'exits early if not in a production environment' do
      Rails.logger.expects(:info)

      @api.remove_from_list(email: @email, list_id: @list_id)
    end
  end
end
