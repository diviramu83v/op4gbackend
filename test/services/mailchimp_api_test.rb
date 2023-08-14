# frozen_string_literal: true

require 'test_helper'

class MailchimpApiTest < ActiveSupport::TestCase
  setup do
    @url = Settings.mailchimp_marketing_url
    @panelist = panelists(:standard)
  end

  describe '#add_member_to_list' do
    it 'adds a member to a list without errors' do
      stub_request(:post, "#{@url}/lists/f82c33674d/members")
        .to_return(status: 200,
                   body: '',
                   headers: { 'Content-Type' => 'application/json' })
      response = MailchimpApi.new.add_member_to_list(panelist: @panelist)
      assert_equal response.code, 200
    end
  end

  describe '#archive_list_member' do
    it 'archives a member of a list' do
      stub_request(:delete, "#{@url}/lists/f82c33674d/members/#{Digest::MD5.hexdigest(@panelist.email.downcase)}")
        .to_return(status: 200,
                   body: '',
                   headers: { 'Content-Type' => 'application/json' })
      response = MailchimpApi.new.archive_list_member(panelist: @panelist)
      assert_equal response.code, 200
    end
  end

  describe '#add_tag_to_member' do
    it 'archives a member of a list' do
      stub_request(:post, "#{@url}/lists/f82c33674d/members/#{Digest::MD5.hexdigest(@panelist.email.downcase)}/tags")
        .to_return(status: 200,
                   body: '',
                   headers: { 'Content-Type' => 'application/json' })

      response = MailchimpApi.new.add_tag_to_member(panelist: @panelist, tag: 'welcome')
      assert_equal response.code, 200
    end
  end

  describe '#remove_tag_from_member' do
    it 'archives a member of a list' do
      stub_request(:post, "#{@url}/lists/f82c33674d/members/#{Digest::MD5.hexdigest(@panelist.email.downcase)}/tags")
        .to_return(status: 200,
                   body: '',
                   headers: { 'Content-Type' => 'application/json' })

      response = MailchimpApi.new.remove_tag_from_member(panelist: @panelist, tag: 'welcome')
      assert_equal response.code, 200
    end
  end
end
