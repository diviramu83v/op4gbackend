# frozen_string_literal: true

require 'rest-client'

class FixieError < StandardError; end

# Wrapper class around methods used by Fixie. Fixie is a service that reposts
#   our requests from a set of fixed IP addresses, which enables us to do IP
#   allowlisting on HasOffers.
class Fixie
  def self.post(url:)
    if Rails.env.development?
      HTTParty.post(url, query: {})
    else
      fixie = URI.parse ENV.fetch('FIXIE_URL', nil)

      response = HTTParty.post(url, query: {}, http_proxyaddr: fixie.host, http_proxyport: fixie.port,
                                    http_proxyuser: fixie.user, http_proxypass: fixie.password)
      return if response.code == 200

      raise FixieError
    end
  end

  def self.get(url:, query: {})
    if Rails.env.development?
      HTTParty.get(url, query: query)
    else
      fixie = URI.parse ENV.fetch('FIXIE_URL', nil)

      HTTParty.get(url, query: query, http_proxyaddr: fixie.host, http_proxyport: fixie.port,
                        http_proxyuser: fixie.user, http_proxypass: fixie.password)
    end
  end
end
