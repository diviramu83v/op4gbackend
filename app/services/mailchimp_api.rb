# frozen_string_literal: true

# a service for accessing the Mailchimp API
class MailchimpApi
  def initialize
    password = Settings.mailchimp_password
    @url = Settings.mailchimp_marketing_url
    @auth = { 'Authorization' => "Basic #{password}", 'Content-Type' => 'application/json' }
    @list_id = 'f82c33674d'
  end

  def add_member_to_list(panelist:)
    url = "#{@url}/lists/#{@list_id}/members"

    body = {
      email_address: panelist.email,
      status: 'subscribed',
      merge_fields: {
        FNAME: panelist.first_name,
        LNAME: panelist.last_name
      }
    }
    HTTParty.post(url, headers: @auth, body: body.to_json)
  end

  def archive_list_member(panelist:)
    subscriber_hash = Digest::MD5.hexdigest(panelist.email.downcase)
    url = "#{@url}/lists/#{@list_id}/members/#{subscriber_hash}"
    HTTParty.delete(url, headers: @auth)
  end

  def add_tag_to_member(panelist:, tag:)
    subscriber_hash = Digest::MD5.hexdigest(panelist.email.downcase)
    url = "#{@url}/lists/#{@list_id}/members/#{subscriber_hash}/tags"
    body = {
      tags: [{
        name: tag,
        status: 'active'
      }]
    }
    HTTParty.post(url, headers: @auth, body: body.to_json)
  end

  def remove_tag_from_member(panelist:, tag:)
    subscriber_hash = Digest::MD5.hexdigest(panelist.email.downcase)
    url = "#{@url}/lists/#{@list_id}/members/#{subscriber_hash}/tags"
    body = {
      tags: [{
        name: tag,
        status: 'inactive'
      }]
    }
    HTTParty.post(url, headers: @auth, body: body.to_json)
  end
end
